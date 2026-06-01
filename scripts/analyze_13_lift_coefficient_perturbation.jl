include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.LiftCoefficientPerturbation"
const SCENARIO_NAME = "lift_coefficient_perturbation"
const SCENARIO_TYPE = "perturbation"

run_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE)
