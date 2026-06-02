include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.FormationWindDisturbance"
const SCENARIO_NAME = "formation_wind_disturbance"
const SCENARIO_TYPE = "formation_disturbance"

run_formation_analysis(
    MODEL,
    SCENARIO_NAME,
    SCENARIO_TYPE;
    n=4,
    spacing=2.0,
    disturbance_start=35.0,
)
