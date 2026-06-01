include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.SharpTurnTracking"
const SCENARIO_NAME = "sharp_turn"
const SCENARIO_TYPE = "trajectory"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
