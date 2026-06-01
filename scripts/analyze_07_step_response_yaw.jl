include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.StepResponseYaw"
const SCENARIO_NAME = "step_response_yaw"
const SCENARIO_TYPE = "yaw_step"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
