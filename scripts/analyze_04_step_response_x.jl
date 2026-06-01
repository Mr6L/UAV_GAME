include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.StepResponseX"
const SCENARIO_NAME = "step_response_x"
const SCENARIO_TYPE = "step"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE; step_axis=:x)
