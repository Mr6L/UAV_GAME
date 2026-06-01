# 四旋翼多场景分析脚本说明

本目录包含用于评估 Sysplorer 中已保存四旋翼场景的 Syslab/Julia 脚本。脚本只负责运行已保存模型、读取仿真结果变量、计算指标、写出 CSV 文件，并默认打开 Syslab/TyPlot 图窗。

这些脚本不会编辑 Modelica 模型，也不会覆盖场景中已保存的 experiment 设置。

## 运行方式

在当前工程工作区打开 Syslab，然后运行某一个分析脚本：

```julia
include("scripts/analyze_01_example1_climb.jl")
```

脚本会自动启动 Sysplorer，连接到脚本指定端口，打开模型包，运行对应的已保存场景，并将分析结果写入 `results/`。

模型包路径固定为：

```text
E:/Program/中国软件杯/QuadrotorModel_split/QuadrotorModel_split/QuadrotorModel/package.mo
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

每个场景会写出三类文件：

- `results/<scenario_name>_variables.txt`
- `results/<scenario_name>_metrics.csv`
- `results/<scenario_name>_timeseries.csv`

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

`QuadrotorModel.Experiments.YawCommandController` 不作为独立实验场景列出，也没有单独分析脚本。它只作为 `StepResponseYaw` 场景内部使用的 yaw 指令控制器。

## 公共工具文件

`quadrotor_analysis_utils.jl` 提供以下通用能力：

- 启动 Sysplorer、连接端口、打开模型、运行仿真、导出变量列表。
- 基于候选变量名匹配参考量、真实状态、控制器反馈、控制器输出、旋翼转速、扰动、噪声和延迟信号。
- 计算轨迹跟踪、位置阶跃、yaw 阶跃、复杂轨迹、参数摄动、外部扰动、测量噪声和测量延迟指标。
- 执行稳定性判定，包括 NaN/Inf、位置阈值、roll/pitch 阈值和仿真后段误差发散趋势。
- 写出指标 CSV、时序 CSV，并使用 Syslab/TyPlot 打开图窗。

## 参数摄动基准文件

参数摄动场景会优先查找：

```text
results/baseline_example1_metrics.csv
```

如果该文件不存在，则继续查找：

```text
results/example1_climb_metrics.csv
```

如果两个基准文件都不存在，脚本会跳过性能退化比计算，但仍会正常输出当前摄动场景的指标。

## 工程约束

- 不修改任何 `.mo` 模型文件。
- 不调用 `SetModelParamValue`。
- 不调用 `SetModelExperiment`。
- 不为 `YawCommandController` 创建单独分析脚本。
- 噪声和延迟场景优先以 `sensors1_1.PosMea` 和 `sensors1_1.AngleMea` 作为真实状态。
- yaw 误差使用角度环绕处理，避免跨越正负 pi 时误差计算错误。
