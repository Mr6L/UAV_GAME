include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.FormationVShapeSpiral"
const SCENARIO_NAME = "formation_vshape_spiral"
const SCENARIO_TYPE = "formation"

run_formation_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE; n=5, spacing=2.0)
