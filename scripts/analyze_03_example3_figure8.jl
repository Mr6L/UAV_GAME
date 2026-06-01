include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Examples.Example3"
const SCENARIO_NAME = "example3_figure8"
const SCENARIO_TYPE = "tracking"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
