# 控制器开发与实验切换说明

本文给后续控制算法迭代使用，重点说明当前统一控制器接口、控制器热插拔入口、批量实验运行方式，以及编队平台几何中心的约束。

## 1. 统一控制器接口

所有可被场景直接使用的控制器都应继承：

```modelica
QuadrotorModel.Blocks.Controller.Interfaces.PartialController
```

接口文件位置：

```text
QuadrotorModel/Blocks/Controller/Interfaces/PartialController.mo
```

统一输入：

| 端口 | 含义 | 约定 |
| --- | --- | --- |
| `position_command[3]` | 期望位置 `[x, y, z]` | 单位 m |
| `yaw_command` | 期望 yaw 角 | 单位 rad；不用时场景设为 `0` |
| `position[3]` | 实际位置 `[x, y, z]` | 来自传感器 |
| `angle[3]` | 实际姿态 `[roll, pitch, yaw]` | 单位 rad，来自传感器 |

统一输出：

| 端口 | 含义 |
| --- | --- |
| `y` | 1 号电机控制量 |
| `y1` | 2 号电机控制量 |
| `y2` | 3 号电机控制量 |
| `y3` | 4 号电机控制量 |

当前基线控制器是：

```text
QuadrotorModel/Blocks/Controller/BaselinePIDController.mo
```

它包装了原来的 PID 控制器，并把内部 yaw 参考改为外部 `yaw_command`。旧的 `QuadrotorModel.Experiments.YawCommandController` 只作为历史遗留模型保留，后续不要再让新场景依赖它。

## 2. 如何开发新控制器

建议在下面目录新增控制器：

```text
QuadrotorModel/Blocks/Controller/
```

最小结构示例：

```modelica
within QuadrotorModel.Blocks.Controller;
model MyController "My controller v1"
  extends QuadrotorModel.Blocks.Controller.Interfaces.PartialController;

  // 在这里声明参数、内部模块和中间变量。

equation
  // 必须为 y/y1/y2/y3 提供完整方程。
  // 可以使用 position_command、yaw_command、position、angle。
end MyController;
```

新增 `.mo` 文件后，需要把类名加入：

```text
QuadrotorModel/Blocks/Controller/package.order
```

开发时注意：

- 不要改场景里的控制器端口名；新控制器适配统一接口即可。
- 即使暂时不用 yaw，也保留 `yaw_command` 输入，场景会给普通实验设置为 `0`。
- 如果新算法输出的是力/力矩而不是电机控制量，需要在控制器内部加分配器或适配器，最终仍输出 `y/y1/y2/y3`。
- `StepResponseYaw` 会真正给 `yaw_command` 非零阶跃，是检查 yaw 接口最直接的场景。
- 编队场景通过 `QuadrotorModel.Formations.QuadrotorAgent` 转发同一套控制器接口。

## 3. 如何切换当前控制器

全项目的控制器切换入口是：

```text
QuadrotorModel/Blocks/Controller/ActiveController.mo
```

当前内容等价于：

```modelica
within QuadrotorModel.Blocks.Controller;
model ActiveController "Current controller selected for all scenarios"
  parameter Real baselineYawKP = 5 "Legacy baseline yaw loop proportional gain";
  extends QuadrotorModel.Blocks.Controller.BaselinePIDController(yawKP = baselineYawKP);
end ActiveController;
```

切换到新控制器时，只改这里。例如：

```modelica
within QuadrotorModel.Blocks.Controller;
model ActiveController "Current controller selected for all scenarios"
  extends QuadrotorModel.Blocks.Controller.MyController;
end ActiveController;
```

如果新控制器需要参数，建议也集中暴露在 `ActiveController.mo`，避免每个场景单独改参数。

注意：`scripts/run_experiments.jl` 里的 `QUADROTOR_CONTROLLER_ID` 只影响结果目录名，不会自动切换 Modelica 控制器。真正的控制器切换点始终是 `ActiveController.mo`。

## 4. 如何跑实验

推荐在 Syslab/Julia 命令窗口进入项目目录后运行：

```julia
cd(raw"E:\Desktop\Projects\UAV_GAME")
```

debug 阶段先少跑几个实验：

```julia
ENV["QUADROTOR_CONTROLLER_ID"] = "my_controller_v1"
ENV["QUADROTOR_BATCH_DRY_RUN"] = "0"
ENV["QUADROTOR_BATCH_LIMIT"] = "3"
ENV["QUADROTOR_BATCH_GROUPS"] = "step"
include("scripts/run_experiments.jl")
```

只预览将要运行哪些实验，不启动 Sysplorer：

```julia
ENV["QUADROTOR_BATCH_DRY_RUN"] = "1"
ENV["QUADROTOR_BATCH_LIMIT"] = "5"
ENV["QUADROTOR_BATCH_GROUPS"] = "all"
include("scripts/run_experiments.jl")
```

最终全量运行：

```julia
for k in [
    "QUADROTOR_BATCH_DRY_RUN",
    "QUADROTOR_BATCH_LIMIT",
    "QUADROTOR_BATCH_GROUPS",
    "QUADROTOR_BATCH_SCENARIOS",
]
    haskey(ENV, k) && delete!(ENV, k)
end
ENV["QUADROTOR_CONTROLLER_ID"] = "my_controller_v1"
include("scripts/run_experiments.jl")
```

重要：不要把 `QUADROTOR_BATCH_SHUTDOWN_EACH` 设为 `0`。默认每个实验结束后关闭当前 Sysplorer，避免全量 25 个实验时同时留下大量 Sysplorer 实例导致电脑卡死。

常用筛选变量：

| 环境变量 | 作用 |
| --- | --- |
| `QUADROTOR_BATCH_LIMIT` | 限制运行数量，debug 阶段很有用 |
| `QUADROTOR_BATCH_GROUPS` | 按组筛选：`step`、`trajectory`、`formation`、`all` 等 |
| `QUADROTOR_BATCH_SCENARIOS` | 按具体场景名筛选，优先级高于 group |
| `QUADROTOR_CONTROLLER_ID` | 结果目录标签，例如 `results/my_controller_v1/` |

## 5. 编队平台几何中心约束

之前多无人机场景有一个容易复发的问题：编队平台的几何中心不在原点。表现为 offsets 以某一架无人机或 leader 为基准，导致整个平台相对期望轨迹偏移。

当前修复点在：

```text
QuadrotorModel/Formations/FormationOffsets.mo
```

实现方式是先生成 `rawOffsets`，再计算所有无人机 offset 的均值 `center`，最终输出：

```modelica
offsets[i, j] = rawOffsets[i, j] - center[j];
```

因此对每种队形都应满足：

```text
sum(offsets[:, 1]) = 0
sum(offsets[:, 2]) = 0
sum(offsets[:, 3]) = 0
```

后续新增队形时，只需要定义原始几何形状，不要手工把 leader 放在原点；`FormationOffsets` 会自动把整个平台几何中心平移到原点。这里的 `leader_command` 更准确地说是编队平台中心参考点，历史命名暂未修改。

## 6. 建议验证流程

每次切换控制器后，至少做以下检查：

1. `check_model`：`QuadrotorModel.Blocks.Controller.ActiveController`
2. `check_model`：`QuadrotorModel.Experiments.StepResponseYaw`
3. `simulate_model`：`QuadrotorModel.Experiments.StepResponseYaw`，确认 `controller3_2.yaw_command` 末端为 `0.17453292519943295`
4. `simulate_model`：`QuadrotorModel.Experiments.StepResponseZ`，确认普通场景下 `controller3_2.yaw_command` 末端为 `0`
5. 编队算法相关改动后，额外检查一个 formation 场景，例如 `QuadrotorModel.Experiments.FormationTriangleFigure8`

