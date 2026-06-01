include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.SustainedLateralWindExperiment"
const SCENARIO_NAME = "sustained_lateral_wind"
const SCENARIO_TYPE = "disturbance"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
