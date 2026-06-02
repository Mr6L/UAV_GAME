include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.FormationDiamondCircle"
const SCENARIO_NAME = "formation_diamond_circle"
const SCENARIO_TYPE = "formation"

run_formation_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE; n=4, spacing=2.0)
