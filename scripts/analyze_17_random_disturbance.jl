include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.RandomDisturbanceExperiment"
const SCENARIO_NAME = "random_disturbance"
const SCENARIO_TYPE = "disturbance"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
