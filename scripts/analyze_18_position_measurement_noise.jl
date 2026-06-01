include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.PositionMeasurementNoiseExperiment"
const SCENARIO_NAME = "position_measurement_noise"
const SCENARIO_TYPE = "noise"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
