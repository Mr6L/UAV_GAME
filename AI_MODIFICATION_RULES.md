# AI 修改边界

你在修改该工程时，必须遵守：

1. 不要修改 `QuadrotorModel/Mechanics/`、`QuadrotorModel/Electricals/`、`QuadrotorModel/Blocks/Controller/`、`QuadrotorModel/Sensors/` 中的官方核心模型，除非用户明确要求。
2. 新增实验场景优先放入 `QuadrotorModel/Experiments/`。如果该目录不存在，先创建子包。
3. 新增路径生成器优先放入 `QuadrotorModel/PathPlanning/`。
4. 新增扰动模型优先放入 `QuadrotorModel/Disturbances/`。如果该目录不存在，先创建子包。
5. 不要删除或改写已有模型中的 `annotation(Placement(...))`、`annotation(Line(...))`、`Diagram(...)`、`Icon(...)`，否则 Sysplorer 图形界面可能损坏。
6. 保持已有类名和接口名稳定，例如 `QuadrotorModel.Examples.Example1` 不应改名。
7. 新增或删除模型文件时，同步更新对应目录下的 `package.order`。
8. 本文档中的路径均相对于仓库根目录 `UAV_GAME/`；不要提交个人机器上的绝对工作目录路径。
