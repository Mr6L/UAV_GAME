# QuadrotorModel_split

这是从官方单文件 `package.mo` 拆分得到的目录式 Modelica 工程。

## 使用方式

在 MWORKS.Sysplorer / Syslab 中加载顶层文件：

```julia
OpenModelFile("E:/Program/中国软件杯/QuadrotorModel_split/QuadrotorModel_split/QuadrotorModel/package.mo")
```

拆分后原有模型完整路径保持不变，例如：

```text
QuadrotorModel.Examples.Example1
QuadrotorModel.Examples.Example2
QuadrotorModel.Examples.Example3
```

因此原先通过 Syslab 调用的模型名一般不需要改，只需要把 `MODEL_FILE` 改成新的 `QuadrotorModel/package.mo` 路径。

## 目录说明

- `QuadrotorModel/`：拆分后的官方四旋翼模型包。
- `scripts/quadrotor_sysplorer_driver.jl`：Syslab 驱动 Sysplorer 仿真的示例脚本。
- `QuadrotorModel/package.order` 及各子包的 `package.order`：用于控制包浏览器中的显示顺序。

## 建议工作流

1. 保留这个拆分包作为基准版本。
2. 后续新增实验场景时，优先在新子包中添加模型，例如：
   - `Experiments/`
   - `PathPlanning/`
   - `Disturbances/`
   - `SensorFaults/`
3. 让 Codex / Claude 修改前，明确限制：不要改 `Mechanics/`、`Electricals/`、`Blocks/Controller/` 等官方核心模块。
4. 每次新增模块后，先在 Sysplorer 中检查模型，再由 Syslab 脚本批量运行仿真。


