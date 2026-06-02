include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))

const MODEL = "QuadrotorModel.Experiments.FormationSwitching"
const SCENARIO_NAME = "formation_switching"
const SCENARIO_TYPE = "formation_switch"

run_formation_analysis(
    MODEL,
    SCENARIO_NAME,
    SCENARIO_TYPE;
    n=5,
    spacing=2.0,
    switch_times=[20.0, 50.0],
    switch_durations=[10.0, 10.0],
)
