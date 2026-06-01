include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Examples.Example1"
const SCENARIO_NAME = "example1_climb"
const SCENARIO_TYPE = "tracking"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
