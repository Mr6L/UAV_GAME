include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.MassPerturbation"
const SCENARIO_NAME = "mass_perturbation"
const SCENARIO_TYPE = "perturbation"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
