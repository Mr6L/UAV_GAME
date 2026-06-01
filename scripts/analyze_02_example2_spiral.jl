include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Examples.Example2"
const SCENARIO_NAME = "example2_spiral"
const SCENARIO_TYPE = "tracking"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
