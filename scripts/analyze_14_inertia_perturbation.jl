include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.InertiaPerturbation"
const SCENARIO_NAME = "inertia_perturbation"
const SCENARIO_TYPE = "perturbation"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
