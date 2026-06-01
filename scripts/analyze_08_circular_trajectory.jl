include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.CircularTrajectoryTracking"
const SCENARIO_NAME = "circular_trajectory"
const SCENARIO_TYPE = "trajectory"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
