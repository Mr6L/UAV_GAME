include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.FormationTriangleFigure8"
const SCENARIO_NAME = "formation_triangle_figure8"
const SCENARIO_TYPE = "formation"

run_formation_analysis(MODEL, SCENARIO_NAME, SCENARIO_TYPE; n=3, spacing=2.0)
