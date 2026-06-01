include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.MeasurementDelayExperiment"
const SCENARIO_NAME = "measurement_delay"
const SCENARIO_TYPE = "delay"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
