# 四旋翼多场景分析脚本说明

本目录包含用于评估 Sysplorer 中已保存四旋翼场景的 Syslab/Julia 脚本。脚本只负责运行已保存模型、读取仿真结果变量、计算指标、写出 CSV 文件，并默认打开 Syslab/TyPlot 图窗。

这些脚本不会编辑 Modelica 模型，也不会覆盖场景中已保存的 experiment 设置。

## 运行方式

在当前工程工作区打开 Syslab，然后运行某一个分析脚本：

```julia
include("scripts/analyze_01_example1_climb.jl")
```

脚本会自动启动 Sysplorer，连接到脚本指定端口，打开模型包，运行对应的已保存场景，并将分析结果写入 `results/<controller_id>/<scenario_name>/`。
默认控制器版本为 `baseline_pid`，新版本脚本会将结果写入 `results/<controller_id>/<scenario_name>/`，例如 `results/baseline_pid/example1_climb/`。

模型包路径默认从当前仓库自动推导：

```text
<仓库根目录>/QuadrotorModel/package.mo
```

如果仓库或模型包在其他位置，可以在运行脚本前覆盖：

```julia
ENV["QUADROTOR_PROJECT_ROOT"] = pwd()
# 或只覆盖模型包：
ENV["QUADROTOR_MODEL_FILE"] = joinpath(pwd(), "QuadrotorModel", "package.mo")
```

如果 Sysplorer 安装目录不同，可以设置，例如：

```julia
ENV["QUADROTOR_SYSPLORER_ROOT"] = "E:/APP/Sysplorer 2026a"
```

脚本默认从本地端口 `8000` 到 `8100` 中选择一个可用端口启动 Sysplorer。如果需要固定启动端口，可以设置：

```julia
ENV["QUADROTOR_SYSPLORER_START_PORT"] = "8000"
include("scripts/analyze_01_example1_climb.jl")
```

如果想连接一个已经打开的 Sysplorer，而不是让脚本启动新实例，可以在运行前指定端口：

```julia
ENV["QUADROTOR_SYSPLORER_PORT"] = "端口号"
include("scripts/analyze_01_example1_climb.jl")
```

如果想复用当前检测到的最新 Sysplorer 端口：

```julia
ENV["QUADROTOR_REUSE_SYSPLORER"] = "1"
include("scripts/analyze_01_example1_climb.jl")
```

Syslab/TyPlot 图窗默认打开。如果批量运行时不想绘图，可以在运行前关闭：

```julia
ENV["QUADROTOR_ENABLE_PLOTS"] = "0"
include("scripts/analyze_01_example1_climb.jl")
```

仿真设置方面，脚本会读取对应场景 `.mo` 文件中的 `experiment(...)` 注解，并把当前 SysplorerAPI 支持的参数传给 `SimulateModel`：`StartTime`、`StopTime`、`Interval` 和 `Algorithm`。如果某个场景没有直接写 `experiment(...)`，脚本会沿项目继承链查找父场景注解，例如 `StepResponseX` 或 `StepResponseZ`。脚本不会调用 `SetModelExperiment`，也不会修改任何 `.mo` 文件。若场景里写了 `Tolerance`，脚本会在控制台打印出来；当前 `SysplorerAPI.SimulateModel` 方法没有提供 tolerance 关键字，因此不会用脚本覆盖该值。

脚本会把 Sysplorer 作为子进程启动，并只给这个子进程补充 Sysplorer 运行时 `PATH`。父级 Syslab/Julia 进程会在加载 TyPlot 前清理 Sysplorer 的 Qt 路径，避免 TyPlot 和 Sysplorer 混用不同版本 Qt。

## 输出文件

每个场景会在自己的结果文件夹中写出三类文件：

- `results/<controller_id>/<scenario_name>/<scenario_name>_variables.txt`
- `results/<controller_id>/<scenario_name>/<scenario_name>_metrics.csv`
- `results/<controller_id>/<scenario_name>/<scenario_name>_timeseries.csv`

如果某个可选变量不存在，脚本会在控制台打印提示，并跳过对应指标或图形。如果核心变量不存在，脚本会停止，并提示查看导出的变量列表来确认真实变量名。

## 脚本与场景对应关系

| 脚本 | Sysplorer 模型 | 类型 | 主要指标 |
|---|---|---|---|
| `analyze_01_example1_climb.jl` | `QuadrotorModel.Examples.Example1` | tracking | 单轴 RMSE/最大误差/最终误差、三维误差、姿态、控制输出、旋翼转速、稳定性 |
| `analyze_02_example2_spiral.jl` | `QuadrotorModel.Examples.Example2` | tracking | 单轴 RMSE/最大误差/最终误差、三维误差、姿态、控制输出、旋翼转速、稳定性 |
| `analyze_03_example3_figure8.jl` | `QuadrotorModel.Examples.Example3` | tracking | 单轴 RMSE/最大误差/最终误差、三维误差、姿态、控制输出、旋翼转速、稳定性 |
| `analyze_04_step_response_x.jl` | `QuadrotorModel.Experiments.StepResponseX` | step | x 轴阶跃幅值、上升时间、超调、峰值时间、调节时间、稳态误差、耦合偏移、稳定性 |
| `analyze_05_step_response_y.jl` | `QuadrotorModel.Experiments.StepResponseY` | step | y 轴阶跃幅值、上升时间、超调、峰值时间、调节时间、稳态误差、耦合偏移、稳定性 |
| `analyze_06_step_response_z.jl` | `QuadrotorModel.Experiments.StepResponseZ` | step | z 轴阶跃幅值、上升时间、超调、峰值时间、调节时间、稳态误差、耦合偏移、稳定性 |
| `analyze_07_step_response_yaw.jl` | `QuadrotorModel.Experiments.StepResponseYaw` | yaw_step | yaw 阶跃指标、角度环绕误差、位置漂移、roll/pitch 耦合、控制峰值、稳定性 |
| `analyze_08_circular_trajectory.jl` | `QuadrotorModel.Experiments.CircularTrajectoryTracking` | trajectory | 单轴 RMSE、水平面误差、三维误差、最终误差、姿态、控制输出、稳定性 |
| `analyze_09_s_trajectory.jl` | `QuadrotorModel.Experiments.STrajectoryTracking` | trajectory | 单轴 RMSE、水平面误差、三维误差、最终误差、姿态、控制输出、稳定性 |
| `analyze_10_square_waypoint.jl` | `QuadrotorModel.Experiments.SquareWaypointTracking` | trajectory | 轨迹误差、瞬态/航点附近误差峰值兜底 |
| `analyze_11_sharp_turn.jl` | `QuadrotorModel.Experiments.SharpTurnTracking` | trajectory | 轨迹误差、瞬态/转弯附近误差峰值兜底 |
| `analyze_12_mass_perturbation.jl` | `QuadrotorModel.Experiments.MassPerturbation` | perturbation | 跟踪指标、旋翼/控制指标、稳定性、可选基准退化比 |
| `analyze_13_lift_coefficient_perturbation.jl` | `QuadrotorModel.Experiments.LiftCoefficientPerturbation` | perturbation | 跟踪指标、旋翼/控制指标、稳定性、可选基准退化比 |
| `analyze_14_inertia_perturbation.jl` | `QuadrotorModel.Experiments.InertiaPerturbation` | perturbation | 跟踪指标、旋翼/控制指标、稳定性、可选基准退化比 |
| `analyze_15_sustained_lateral_wind.jl` | `QuadrotorModel.Experiments.SustainedLateralWindExperiment` | disturbance | 扰动开始时间、峰值、方向、恢复时间、稳态误差、跟踪指标、稳定性 |
| `analyze_16_pulse_disturbance.jl` | `QuadrotorModel.Experiments.PulseDisturbanceExperiment` | disturbance | 脉冲后最大偏差、恢复时间、持续振荡判定、跟踪指标、稳定性 |
| `analyze_17_random_disturbance.jl` | `QuadrotorModel.Experiments.RandomDisturbanceExperiment` | disturbance | 扰动期间误差 RMS/标准差/最大值、控制 RMS、跟踪指标、稳定性 |
| `analyze_18_position_measurement_noise.jl` | `QuadrotorModel.Experiments.PositionMeasurementNoiseExperiment` | noise | 真实状态跟踪、位置 noisy-clean 指标、控制/旋翼 RMS 与标准差、稳定性 |
| `analyze_19_attitude_measurement_noise.jl` | `QuadrotorModel.Experiments.AttitudeMeasurementNoiseExperiment` | noise | 真实状态跟踪、姿态 noisy-clean 指标、控制/旋翼 RMS 与标准差、稳定性 |
| `analyze_20_measurement_delay.jl` | `QuadrotorModel.Experiments.MeasurementDelayExperiment` | delay | 真实状态跟踪、延迟反馈与真实测量差值、稳定时的 z 轴响应、失稳时的发散信息 |
| `analyze_21_formation_triangle_figure8.jl` | `QuadrotorModel.Experiments.FormationTriangleFigure8` | formation | 三机三角队形误差、leader/follower 跟踪误差、最小机间距、碰撞/不安全间距判定 |
| `analyze_22_formation_diamond_circle.jl` | `QuadrotorModel.Experiments.FormationDiamondCircle` | formation | 四机菱形队形误差、leader/follower 跟踪误差、最小机间距、碰撞/不安全间距判定 |
| `analyze_23_formation_vshape_spiral.jl` | `QuadrotorModel.Experiments.FormationVShapeSpiral` | formation | 五机 V 字队形误差、leader/follower 跟踪误差、最小机间距、碰撞/不安全间距判定 |
| `analyze_24_formation_switching.jl` | `QuadrotorModel.Experiments.FormationSwitching` | formation_switch | 横队-菱形-V 字切换完成时间、切换期间最大队形误差、切换期间最小机间距 |
| `analyze_25_formation_wind_disturbance.jl` | `QuadrotorModel.Experiments.FormationWindDisturbance` | formation_disturbance | 风扰下队形误差峰值、编队扰动恢复时间、稳态队形误差、最小机间距 |

`QuadrotorModel.Experiments.YawCommandController` 不作为独立实验场景列出，也没有单独分析脚本。它只作为 `StepResponseYaw` 场景内部使用的 yaw 指令控制器。

编队脚本使用 `run_formation_analysis(...)`，会额外输出每架无人机真实位置、期望位置、单机跟踪误差、follower 相对 leader 的队形误差、所有机间距离和逐时刻最小机间距。默认碰撞阈值为 `0.5 m`，不安全间距阈值为 `1.0 m`，可通过环境变量 `QUADROTOR_COLLISION_DISTANCE` 和 `QUADROTOR_UNSAFE_DISTANCE` 覆盖。

## 批量运行

`scripts/run_experiments.jl` 是一键批量入口。直接运行这个文件就会开始执行选中的实验；不设置任何环境变量时，会运行全部 25 个场景，结果写入 `results/baseline_pid/`，批量运行默认关闭绘图窗口，并且每个场景结束后关闭当前 Sysplorer。

```julia
include("scripts/run_experiments.jl")
```

运行前可以用环境变量配置批量任务：

```julia
ENV["QUADROTOR_BATCH_LIMIT"] = "3"              # 只跑选中集合中的前 3 个
ENV["QUADROTOR_BATCH_GROUPS"] = "tracking,step" # 按组筛选；默认 all
ENV["QUADROTOR_BATCH_SCENARIOS"] = "example1_climb,step_response_z"
ENV["QUADROTOR_BATCH_DRY_RUN"] = "1"            # 只预览，不启动 Sysplorer
ENV["QUADROTOR_BATCH_CONTINUE_ON_ERROR"] = "1"  # 某个场景失败后继续
ENV["QUADROTOR_BATCH_SHUTDOWN_EACH"] = "1"      # 每个场景后关闭 Sysplorer
ENV["QUADROTOR_CONTROLLER_ID"] = "baseline_pid"
ENV["QUADROTOR_CONTROLLER_MODEL_PREFIX"] = "QuadrotorModel.Experiments.Improved"
include("scripts/run_experiments.jl")
```

可用分组包括 `tracking`、`step`、`trajectory`、`perturbation`、`disturbance`、`noise_delay`、`formation` 和 `all`。如果设置了 `QUADROTOR_BATCH_SCENARIOS`，则优先按场景名筛选；`QUADROTOR_BATCH_LIMIT=all` 或不设置表示不限制数量。

如果只是调试函数调用，不想 include 后立刻运行，请加载可复用 helper：

```julia
include("scripts/quadrotor_experiment_runner.jl")
run_experiments(groups=["step"], limit=2)
run_experiments(scenarios=["example1_climb", "step_response_z"])
run_experiments(controller_id="baseline_pid", groups=["all"])
```

批量脚本默认每个场景结束后关闭当前 Sysplorer 实例，避免同时打开大量 Sysplorer。若某个场景失败，默认停止批量运行；可设置 `continue_on_error=true` 或 `ENV["QUADROTOR_BATCH_CONTINUE_ON_ERROR"] = "1"` 继续后续场景。

如需测试改进控制器，建议使用独立实验模型并通过 `controller_id` 与 `model_prefix` 映射：

```julia
run_experiments(
    controller_id="improved_pid_v1",
    model_prefix="QuadrotorModel.Experiments.Improved",
    scenarios=["step_response_z"],
)
```

此时 `QuadrotorModel.Experiments.StepResponseZ` 会映射为 `QuadrotorModel.Experiments.Improved.StepResponseZ`，结果写入 `results/improved_pid_v1/step_response_z/`。如果不同场景需要不同映射，可编辑 `scripts/quadrotor_experiment_manifest.jl` 中的 `QUADROTOR_CONTROLLER_MODEL_OVERRIDES`。

## 公共工具文件

`quadrotor_analysis_utils.jl` 提供以下通用能力：

- 启动 Sysplorer、连接端口、打开模型、运行仿真、导出变量列表。
- 基于候选变量名匹配参考量、真实状态、控制器反馈、控制器输出、旋翼转速、扰动、噪声和延迟信号。
- 计算轨迹跟踪、位置阶跃、yaw 阶跃、复杂轨迹、参数摄动、外部扰动、测量噪声和测量延迟指标。
- 计算编队保持误差、leader/follower 跟踪误差、队形切换完成时间、编队扰动恢复时间、最小机间距和碰撞/不安全间距判定。
- 执行稳定性判定，包括 NaN/Inf、位置阈值、roll/pitch 阈值和仿真后段误差发散趋势。
- 写出指标 CSV、时序 CSV，并使用 Syslab/TyPlot 打开图窗。

## 参数摄动基准文件

参数摄动场景会按同类阶跃场景计算退化比：

- `mass_perturbation` 对比 `step_response_z`
- `lift_coefficient_perturbation` 对比 `step_response_z`
- `inertia_perturbation` 对比 `step_response_x`

新版路径优先使用：

```text
results/<controller_id>/<baseline_scenario>/<baseline_scenario>_metrics.csv
```

旧版 `results/<baseline_scenario>/...` 和平铺在 `results/` 目录下的基准文件仍会兼容查找。如果这些基准文件都不存在，脚本会跳过性能退化比计算，但仍会正常输出当前摄动场景的指标。

## 工程约束

- 不修改任何 `.mo` 模型文件。
- 不调用 `SetModelParamValue`。
- 不调用 `SetModelExperiment`。
- 不为 `YawCommandController` 创建单独分析脚本。
- 噪声和延迟场景优先以 `sensors1_1.PosMea` 和 `sensors1_1.AngleMea` 作为真实状态。
- yaw 误差使用角度环绕处理，避免跨越正负 pi 时误差计算错误。
