include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.SquareWaypointTracking"
const SCENARIO_NAME = "square_waypoint"
const SCENARIO_TYPE = "trajectory"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
