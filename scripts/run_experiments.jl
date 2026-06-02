# 一键批量实验入口。
#
# 直接在 Syslab/Julia 中运行本文件时，会立即开始批量实验。
# 不设置任何环境变量时，本脚本会：
#   1. 运行 manifest 中的全部 25 个实验；
#   2. 使用默认控制器编号 baseline_pid；
#   3. 将结果写入 results/<controller_id>/；
#   4. 每个实验结束后关闭当前 Sysplorer，避免同时打开大量 Sysplorer；
#   5. 批量运行时默认关闭绘图窗口，减少内存占用。
#
# 推荐用法 A：跑全部实验
#   在 Syslab 的 Julia 命令窗口执行：
#
#   cd(raw"E:\Desktop\Projects\UAV_GAME")
#   for k in [
#       "QUADROTOR_BATCH_DRY_RUN",
#       "QUADROTOR_BATCH_LIMIT",
#       "QUADROTOR_BATCH_GROUPS",
#       "QUADROTOR_BATCH_SCENARIOS",
#   ]
#       haskey(ENV, k) && delete!(ENV, k)
#   end
#   include("scripts/run_experiments.jl")
#
# 推荐用法 B：debug 时只预览前 3 个编队实验，不启动 Sysplorer
#
#   cd(raw"E:\Desktop\Projects\UAV_GAME")
#   ENV["QUADROTOR_BATCH_DRY_RUN"] = "1"
#   ENV["QUADROTOR_BATCH_LIMIT"] = "3"
#   ENV["QUADROTOR_BATCH_GROUPS"] = "formation"
#   include("scripts/run_experiments.jl")
#
# 推荐用法 C：真实运行前 3 个编队实验
#
#   cd(raw"E:\Desktop\Projects\UAV_GAME")
#   ENV["QUADROTOR_BATCH_DRY_RUN"] = "0"
#   ENV["QUADROTOR_BATCH_LIMIT"] = "3"
#   ENV["QUADROTOR_BATCH_GROUPS"] = "formation"
#   include("scripts/run_experiments.jl")
#
# 推荐用法 D：只跑指定场景
#
#   cd(raw"E:\Desktop\Projects\UAV_GAME")
#   ENV["QUADROTOR_BATCH_DRY_RUN"] = "0"
#   ENV["QUADROTOR_BATCH_SCENARIOS"] = "example1_climb,step_response_z"
#   include("scripts/run_experiments.jl")
#
# 常用环境变量说明：
#   QUADROTOR_BATCH_DRY_RUN
#       "1" 表示只打印将要运行的实验，不启动 Sysplorer；
#       "0" 或删除该变量表示真实运行。
#
#   QUADROTOR_BATCH_LIMIT
#       限制运行数量，例如 "3" 只跑选中集合中的前 3 个；
#       删除该变量或设为 "all" 表示不限制。
#
#   QUADROTOR_BATCH_GROUPS
#       按组筛选实验，逗号分隔。可用值包括：
#       tracking, step, trajectory, perturbation, disturbance, noise_delay,
#       formation, all。
#
#   QUADROTOR_BATCH_SCENARIOS
#       指定具体场景名，逗号分隔，例如：
#       "example1_climb,step_response_z"。
#       注意：该变量优先级高于 QUADROTOR_BATCH_GROUPS。
#
#   QUADROTOR_BATCH_CONTINUE_ON_ERROR
#       "1" 表示某个实验失败后继续跑后续实验；
#       默认失败后停止。
#
#   QUADROTOR_BATCH_SHUTDOWN_EACH
#       "1" 表示每个实验后关闭 Sysplorer，默认就是 "1"；
#       不建议改成 "0"，否则全量实验可能同时留下很多 Sysplorer。
#
#   QUADROTOR_CONTROLLER_ID
#       控制器结果编号，例如 "baseline_pid" 或 "improved_pid_v1"。
#       结果会写入 results/<controller_id>/。
#       注意：它只影响结果目录名称，不会自动切换 Modelica 控制器。
#       真正的控制器切换点是：
#       QuadrotorModel/Blocks/Controller/ActiveController.mo
#
#   QUADROTOR_CONTROLLER_MODEL_PREFIX
#       改进控制器使用独立实验模型时，用它把原始模型名映射到新包下。
#       例如设置为 "QuadrotorModel.Experiments.Improved" 后，
#       QuadrotorModel.Experiments.StepResponseZ 会映射为
#       QuadrotorModel.Experiments.Improved.StepResponseZ。
#
# 如果你只想加载函数、然后手动调用 run_experiments(...)，不要 include 本文件；
# 请改为：
#
#   include("scripts/quadrotor_experiment_runner.jl")
#   run_experiments(groups=["step"], limit=2, dry_run=true)

if !haskey(ENV, "QUADROTOR_ENABLE_PLOTS")
    ENV["QUADROTOR_ENABLE_PLOTS"] = "0"
end

include(joinpath(@__DIR__, "quadrotor_experiment_runner.jl"))

println("开始执行 scripts/run_experiments.jl 批量实验入口。")
println("如需只预览不仿真，请在运行前设置 ENV[\"QUADROTOR_BATCH_DRY_RUN\"] = \"1\"。")
flush(stdout)

run_experiments_from_env()
