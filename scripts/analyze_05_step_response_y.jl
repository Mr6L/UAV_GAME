include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.StepResponseY"
const SCENARIO_NAME = "step_response_y"
const SCENARIO_TYPE = "step"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE; step_axis=:y)
