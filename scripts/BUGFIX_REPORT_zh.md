# 四旋翼分析脚本 Bug 修复记录

本文档记录从“通过脚本启动 Sysplorer 后仿真编译失败”到当前版本稳定运行期间，用户提出的主要 bug、原因分析和解决方法。

## 1. 脚本启动 Sysplorer 后仿真编译失败

### Bug 点

运行 `analyze_01_example1_climb.jl`、`analyze_02_example2_spiral.jl` 时，模型检查和翻译可以完成，但生成求解器阶段失败，报错类似：

```text
生成求解器失败. 创建编译C代码的进程失败. 错误码: -1.
错误(3005): 编译模型失败。
```

用户手动双击 `QuadrotorModel/package.mo` 打开 Sysplorer 后，在场景中直接仿真可以成功；但由脚本启动的 Sysplorer 中，即使手动点击仿真也失败。

### 原因分析

问题不在 Modelica 模型本身，而在脚本启动 Sysplorer 进程的环境变量。

早期脚本为了让 Sysplorer 找到仿真运行库，给启动命令设置了 Sysplorer 相关 `PATH`。但启动子进程时没有完整继承父进程环境，导致 Sysplorer 后续创建 C 编译进程时缺少必要环境，最终表现为“创建编译 C 代码的进程失败”。

同时，如果把 Sysplorer 的运行时路径直接污染到父级 Syslab/Julia 进程，又会影响后续 TyPlot 的 Qt 运行库加载。

### 解决方法

在 `quadrotor_analysis_utils.jl` 中调整启动方式：

- Sysplorer 作为子进程启动。
- 子进程使用 `addenv(...; inherit=true)`，完整继承父进程环境。
- 只给 Sysplorer 子进程补充 Sysplorer 运行时路径。
- 父级 Syslab/Julia 进程在加载 TyPlot 前清理 Sysplorer 的 Qt 路径，避免绘图库冲突。

关键结果：

- 通过脚本启动的 Sysplorer 可以正常编译并仿真。
- 不需要修改任何 `.mo` 模型文件。
- 原来的 `quadrotor_sysplorer_driver.jl` 工作流保持可用。

## 2. 脚本工作流不应依赖手动打开 Sysplorer

### Bug 点

用户希望只在 Syslab 中运行分析脚本，脚本自动完成：

- 启动 Sysplorer；
- 打开项目模型包；
- 进入对应场景仿真；
- 获取数据；
- 完成指标分析和绘图。

早期脚本需要依赖外部手动打开或复用 Sysplorer，工作流不够稳定。

### 原因分析

自动化脚本需要明确区分两种模式：

- 默认模式：脚本自己启动新的 Sysplorer 实例；
- 调试模式：复用已有 Sysplorer 端口。

如果端口、模型路径和运行目录没有统一管理，脚本容易连接到错误实例，或者打开模型后仿真环境不一致。

### 解决方法

公共工具函数统一负责 Sysplorer 连接和模型打开：

- `MODEL_FILE` 固定指向项目模型包 `QuadrotorModel/package.mo`。
- `connect_or_start_sysplorer()` 默认启动新实例。
- `QUADROTOR_SYSPLORER_PORT` 可连接指定端口。
- `QUADROTOR_REUSE_SYSPLORER=1` 可复用已检测到的最新端口。
- `connect_and_open_model()` 统一切换工作目录、连接 Sysplorer、打开模型包并加载 Modelica 库。

这样每个 `analyze_*.jl` 只需要声明模型名和场景名，然后调用公共 `run_analysis(...)`。

## 3. 绘图功能需要自动打开，且不能使用 Python

### Bug 点

用户要求分析脚本完成后自动弹出图窗，不希望手动设置绘图；后续又明确要求不要使用 Python 做数据分析画图，应使用 Syslab 内置工具。

之前尝试外部 Python 绘图时出现命令行崩溃或运行时库冲突风险。

### 原因分析

该项目运行链路同时涉及 Sysplorer、Syslab/Julia 和绘图库。Python/matplotlib 会额外引入 Python 运行时和图形后端，容易和 Sysplorer、Syslab 的 Qt 运行库产生冲突，也不符合“使用软件内置工具弹窗”的要求。

### 解决方法

移除 Python 绘图路径，统一使用 Syslab 内置 TyPlot：

- `quadrotor_analysis_utils.jl` 中直接 `using TyPlot`。
- `ENABLE_PLOTS` 默认开启：

```julia
const ENABLE_PLOTS = lowercase(get(ENV, "QUADROTOR_ENABLE_PLOTS", "1")) in ["1", "true", "yes", "on"]
```

- 批量运行时如需关闭绘图，可显式设置：

```julia
ENV["QUADROTOR_ENABLE_PLOTS"] = "0"
```

- 绘图前清理父进程中 Sysplorer Qt 路径，保证 TyPlot 使用 Syslab 自身绘图运行时。

关键结果：

- 单个分析脚本运行完成后会自动弹出 TyPlot 图窗。
- 不再依赖 Python/matplotlib。
- 保留批处理关闭绘图的环境变量开关。

## 4. 脚本打开的仿真停止时间显示为 1

### Bug 点

用户发现通过脚本启动并打开结果查看器时，界面上仿真停止时间显示为 `1`，但项目中场景设置不是 `1`，例如 `Example1` 的停止时间应为 `50`。

### 原因分析

早期脚本调用 `SimulateModel(modelName=model)` 或 `SimulateModel(model)` 时，没有显式传入项目场景中的 `experiment(...)` 仿真设置。SysplorerAPI 在这种调用方式下可能使用 API 或界面默认值，导致界面显示的停止时间不符合项目场景注解。

此外，不同场景的仿真设置不完全相同：

- `Example1`：`StopTime=50, Interval=0.01`
- `Example3`：`StopTime=120`
- 轨迹类场景：通常 `StopTime=80`
- 阶跃、扰动、噪声、延迟类场景：通常 `StopTime=50`

部分派生场景本身没有直接写 `experiment(...)`，而是继承自 `StepResponseX` 或 `StepResponseZ`。

### 解决方法

在 `quadrotor_analysis_utils.jl` 中新增项目仿真设置读取逻辑：

- 根据模型名定位对应 `.mo` 源文件。
- 读取场景中的 `experiment(...)` 注解。
- 提取当前 `SysplorerAPI.SimulateModel` 支持的关键字：
  - `StartTime`
  - `StopTime`
  - `Interval`
  - `Algorithm`
- 显式传入 `SimulateModel`：

```julia
sim_kwargs = (; simulation_keyword_pairs(settings)...)
SysplorerAPI.SimulateModel(; modelName=model, sim_kwargs...)
```

如果当前场景没有直接写 `experiment(...)`，脚本会沿继承链查找父场景注解，例如：

- `MassPerturbation -> StepResponseZ`
- `LiftCoefficientPerturbation -> StepResponseZ`
- `InertiaPerturbation -> StepResponseX`
- `SustainedLateralWindExperiment -> StepResponseZ`
- `PulseDisturbanceExperiment -> StepResponseZ`
- `RandomDisturbanceExperiment -> StepResponseZ`

关键结果：

- `Example1` 实际运行结果时间轴最后一行是 `50.0`。
- 20 个分析场景都能解析到直接或继承的项目仿真参数。
- 不调用 `SetModelExperiment`，不修改 `.mo` 文件。

## 5. 仿真设置解析过程中的 `SubString` 类型错误

### Bug 点

加入 `experiment(...)` 解析后，运行脚本时出现：

```text
MethodError: no method matching parse_experiment_number(::SubString{String}, ::String)
```

### 原因分析

正则匹配得到的 `captures[1]` 是 `SubString{String}`，而早期解析函数只声明接受 `String`。

Julia 中 `String` 和 `SubString{String}` 都属于字符串类型，但方法签名过窄时不会自动匹配。

### 解决方法

将相关解析函数参数从 `String` 放宽为 `AbstractString`：

- `experiment_value_text(body::AbstractString, key::String)`
- `parse_experiment_number(body::AbstractString, key::String)`
- `parse_experiment_algo(body::AbstractString)`

关键结果：

- 直接场景和继承场景都可以正常解析仿真注解。
- `Example1` 正确解析为 `(stopTime = 50.0, interval = 0.01)`。

## 6. 部分场景没有直接 `experiment(...)` 注解

### Bug 点

参数扰动和外部扰动场景中，部分 `.mo` 文件没有直接写 `experiment(...)`，如果只查当前文件，会回退到默认仿真设置。

### 原因分析

这些场景是通过继承已有实验场景构造的。例如：

```modelica
model MassPerturbation
  extends StepResponseZ(...);
end MassPerturbation;
```

它们的仿真设置实际来自父场景，而不是当前派生模型文件。

### 解决方法

增加继承链解析：

- 扫描当前模型中的 `extends ...`。
- 将相对模型名解析为完整模型名。
- 查找父模型 `.mo` 文件。
- 父模型若有 `experiment(...)`，则作为当前场景的仿真设置来源。
- 设置递归访问集合，避免循环继承导致死循环。

关键结果：

无直接注解的场景现在会打印提示，并使用继承来源，例如：

```text
[info] No direct experiment annotation in ...MassPerturbation.mo
[info] Using inherited project experiment annotation from ...StepResponseZ.mo
```

## 7. 不能修改模型参数和实验设置

### Bug 点

任务要求所有分析脚本不得调用：

- `SetModelParamValue`
- `SetModelExperiment`

同时不得修改任何 `.mo` 模型文件。

### 原因分析

本项目的分析脚本定位是“读取并评估已保存场景”，不是重新配置模型。若脚本调用参数修改 API 或实验设置 API，会破坏结果可复现性，也可能覆盖项目中已经保存的场景设置。

### 解决方法

当前脚本只做以下操作：

- 打开模型包；
- 运行目标模型；
- 读取仿真结果变量；
- 计算指标；
- 写出 CSV；
- 使用 TyPlot 绘图。

仿真时间等设置通过读取 `.mo` 中已有 `experiment(...)` 注解并传给 `SimulateModel`，不使用 `SetModelExperiment` 写回模型。

验证命令：

```powershell
rg -n "SetModelParamValue|SetModelExperiment" scripts -g "quadrotor_analysis_utils.jl" -g "analyze_*.jl"
```

当前检查无命中。

## 当前版本验证结果

已完成的关键验证：

- 20 个 `analyze_*.jl` 脚本数量正确。
- 未创建 `YawCommandController` 的独立分析脚本。
- 分析脚本和公共工具中无 `SetModelParamValue`。
- 分析脚本和公共工具中无 `SetModelExperiment`。
- 不再使用 Python/matplotlib 绘图。
- 通过 Syslab 运行脚本可自动启动 Sysplorer、打开模型、仿真、导出指标并弹出 TyPlot 图窗。
- `analyze_01_example1_climb.jl` 实际运行后，`results/example1_climb_timeseries.csv` 最后一行时间为 `50.0`。
- 未修改任何 `.mo` 模型文件。

