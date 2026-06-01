include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.STrajectoryTracking"
const SCENARIO_NAME = "s_trajectory"
const SCENARIO_TYPE = "trajectory"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
