# Quadrotor analysis scripts

This directory contains Syslab/Julia scripts for evaluating the saved Sysplorer
quadrotor scenarios. The scripts only run saved models, read result variables,
compute metrics, write CSV files, and open Syslab/TyPlot figure windows by default.

The scripts do not edit Modelica models and do not override saved experiment
settings.

## How to run

Open Syslab in this project workspace and run one script:

```julia
include("scripts/analyze_01_example1_climb.jl")
```

The script starts Sysplorer itself, connects to the requested script port, opens
the model package, reads the target scene's `experiment(...)` annotation from
its `.mo` file, runs the scene with those project simulation settings, then
writes analysis files to `results/<controller_id>/<scenario_name>/`.
The default controller id is `baseline_pid`, for example
`results/baseline_pid/example1_climb/`.

By default, the model package path is resolved from this repository:

```text
<repo>/QuadrotorModel/package.mo
```

If the repository or model package is in a non-standard location, override it
before including a script:

```julia
ENV["QUADROTOR_PROJECT_ROOT"] = pwd()
# or override only the model package:
ENV["QUADROTOR_MODEL_FILE"] = joinpath(pwd(), "QuadrotorModel", "package.mo")
```

If Sysplorer is installed somewhere else, set it explicitly, for example:

```julia
ENV["QUADROTOR_SYSPLORER_ROOT"] = "E:/APP/Sysplorer 2026a"
```

By default, the script starts Sysplorer on an available local port from `8000`
to `8100`. To pin the startup port, set:

```julia
ENV["QUADROTOR_SYSPLORER_START_PORT"] = "8000"
include("scripts/analyze_01_example1_climb.jl")
```

To connect to an already-running Sysplorer instance instead of starting a new
one, specify its script port before including the script:

```julia
ENV["QUADROTOR_SYSPLORER_PORT"] = "port_number"
include("scripts/analyze_01_example1_climb.jl")
```

To reuse the newest detected Sysplorer port:

```julia
ENV["QUADROTOR_REUSE_SYSPLORER"] = "1"
include("scripts/analyze_01_example1_climb.jl")
```

Syslab/TyPlot figure windows are opened by default. To disable plotting for
batch runs:

```julia
ENV["QUADROTOR_ENABLE_PLOTS"] = "0"
include("scripts/analyze_01_example1_climb.jl")
```

The script starts Sysplorer as a child process with its own runtime `PATH`. The
parent Syslab/Julia process keeps Sysplorer Qt paths out of its `PATH` before
loading TyPlot, so TyPlot can use the Syslab plotting runtime.

For simulation settings, the scripts parse each scene's `experiment(...)`
annotation and pass the supported values to `SimulateModel`: `StartTime`,
`StopTime`, `Interval`, and `Algorithm`. If a scene has no direct
`experiment(...)` annotation, the scripts follow its project inheritance chain
and use the inherited scene annotation, such as `StepResponseX` or
`StepResponseZ`. They do not call `SetModelExperiment` and do not modify any
`.mo` file. `Tolerance` is printed when found, but the current SysplorerAPI
`SimulateModel` function does not expose a tolerance keyword.

## Output files

Each scenario writes three files in its own versioned result folder:

- `results/<controller_id>/<scenario_name>/<scenario_name>_variables.txt`
- `results/<controller_id>/<scenario_name>/<scenario_name>_metrics.csv`
- `results/<controller_id>/<scenario_name>/<scenario_name>_timeseries.csv`

If an optional variable is absent, the script prints a warning and skips the
related metric or plot. If a core variable is absent, the script stops and asks
the user to inspect the exported variable list.

## Script map

| Script | Sysplorer model | Type | Main metrics |
|---|---|---|---|
| `analyze_01_example1_climb.jl` | `QuadrotorModel.Examples.Example1` | tracking | axis RMSE/max/final error, 3D error, attitude, control output, rotor speed, stability |
| `analyze_02_example2_spiral.jl` | `QuadrotorModel.Examples.Example2` | tracking | axis RMSE/max/final error, 3D error, attitude, control output, rotor speed, stability |
| `analyze_03_example3_figure8.jl` | `QuadrotorModel.Examples.Example3` | tracking | axis RMSE/max/final error, 3D error, attitude, control output, rotor speed, stability |
| `analyze_04_step_response_x.jl` | `QuadrotorModel.Experiments.StepResponseX` | step | x step amplitude, rise time, overshoot, peak time, settling time, steady error, coupling, stability |
| `analyze_05_step_response_y.jl` | `QuadrotorModel.Experiments.StepResponseY` | step | y step amplitude, rise time, overshoot, peak time, settling time, steady error, coupling, stability |
| `analyze_06_step_response_z.jl` | `QuadrotorModel.Experiments.StepResponseZ` | step | z step amplitude, rise time, overshoot, peak time, settling time, steady error, coupling, stability |
| `analyze_07_step_response_yaw.jl` | `QuadrotorModel.Experiments.StepResponseYaw` | yaw_step | yaw step metrics with angle wrapping, position drift, roll/pitch coupling, control peak, stability |
| `analyze_08_circular_trajectory.jl` | `QuadrotorModel.Experiments.CircularTrajectoryTracking` | trajectory | axis RMSE, horizontal and 3D error, final error, attitude, control output, stability |
| `analyze_09_s_trajectory.jl` | `QuadrotorModel.Experiments.STrajectoryTracking` | trajectory | axis RMSE, horizontal and 3D error, final error, attitude, control output, stability |
| `analyze_10_square_waypoint.jl` | `QuadrotorModel.Experiments.SquareWaypointTracking` | trajectory | trajectory error plus transient/waypoint peak error fallback |
| `analyze_11_sharp_turn.jl` | `QuadrotorModel.Experiments.SharpTurnTracking` | trajectory | trajectory error plus transient/turn peak error fallback |
| `analyze_12_mass_perturbation.jl` | `QuadrotorModel.Experiments.MassPerturbation` | perturbation | tracking metrics, rotor/control metrics, stability, optional baseline degradation ratios |
| `analyze_13_lift_coefficient_perturbation.jl` | `QuadrotorModel.Experiments.LiftCoefficientPerturbation` | perturbation | tracking metrics, rotor/control metrics, stability, optional baseline degradation ratios |
| `analyze_14_inertia_perturbation.jl` | `QuadrotorModel.Experiments.InertiaPerturbation` | perturbation | tracking metrics, rotor/control metrics, stability, optional baseline degradation ratios |
| `analyze_15_sustained_lateral_wind.jl` | `QuadrotorModel.Experiments.SustainedLateralWindExperiment` | disturbance | disturbance start/peak/direction, recovery, steady error, tracking metrics, stability |
| `analyze_16_pulse_disturbance.jl` | `QuadrotorModel.Experiments.PulseDisturbanceExperiment` | disturbance | pulse peak deviation, recovery time, oscillation indicator, tracking metrics, stability |
| `analyze_17_random_disturbance.jl` | `QuadrotorModel.Experiments.RandomDisturbanceExperiment` | disturbance | disturbance-period RMS/std/max error, control RMS, tracking metrics, stability |
| `analyze_18_position_measurement_noise.jl` | `QuadrotorModel.Experiments.PositionMeasurementNoiseExperiment` | noise | true-state tracking, noisy-clean position metrics, control/rotor RMS and std, stability |
| `analyze_19_attitude_measurement_noise.jl` | `QuadrotorModel.Experiments.AttitudeMeasurementNoiseExperiment` | noise | true-state tracking, noisy-clean attitude metrics, control/rotor RMS and std, stability |
| `analyze_20_measurement_delay.jl` | `QuadrotorModel.Experiments.MeasurementDelayExperiment` | delay | true-state tracking, delayed-vs-clean feedback error, z response if stable, divergence details if unstable |
| `analyze_21_formation_triangle_figure8.jl` | `QuadrotorModel.Experiments.FormationTriangleFigure8` | formation | triangular formation error, leader/follower tracking error, minimum inter-UAV distance, collision/unsafe-spacing flags |
| `analyze_22_formation_diamond_circle.jl` | `QuadrotorModel.Experiments.FormationDiamondCircle` | formation | diamond formation error, leader/follower tracking error, minimum inter-UAV distance, collision/unsafe-spacing flags |
| `analyze_23_formation_vshape_spiral.jl` | `QuadrotorModel.Experiments.FormationVShapeSpiral` | formation | V-shape formation error, leader/follower tracking error, minimum inter-UAV distance, collision/unsafe-spacing flags |
| `analyze_24_formation_switching.jl` | `QuadrotorModel.Experiments.FormationSwitching` | formation_switch | line-diamond-V switch completion time, peak switching formation error, switching minimum inter-UAV distance |
| `analyze_25_formation_wind_disturbance.jl` | `QuadrotorModel.Experiments.FormationWindDisturbance` | formation_disturbance | post-wind formation error peak, formation disturbance recovery time, steady formation error, minimum inter-UAV distance |

`QuadrotorModel.Experiments.YawCommandController` is intentionally not listed
as a scenario. It is only used by `StepResponseYaw`.

Formation scripts call `run_formation_analysis(...)`. They write each UAV's
actual position, commanded position, tracking error, follower-relative formation
error, all pairwise distances, and the minimum inter-UAV distance at each time
step. The default collision threshold is `0.5 m`, and the default unsafe-spacing
threshold is `1.0 m`; override them with `QUADROTOR_COLLISION_DISTANCE` and
`QUADROTOR_UNSAFE_DISTANCE`.

## Batch runs

Use `scripts/run_experiments.jl` as the one-click batch entry point. Running
this file directly starts the selected batch. With no environment overrides it
runs all 25 scenarios, writes to `results/baseline_pid/`, disables plot windows,
and closes Sysplorer after each scenario.

```julia
include("scripts/run_experiments.jl")
```

Set environment variables before running the file to configure the batch:

```julia
ENV["QUADROTOR_BATCH_LIMIT"] = "3"              # run only the first 3 selected scenarios
ENV["QUADROTOR_BATCH_GROUPS"] = "tracking,step" # comma-separated groups; default is all
ENV["QUADROTOR_BATCH_SCENARIOS"] = "example1_climb,step_response_z"
ENV["QUADROTOR_BATCH_DRY_RUN"] = "1"            # preview selection without starting Sysplorer
ENV["QUADROTOR_BATCH_CONTINUE_ON_ERROR"] = "1"  # keep going after a failed scenario
ENV["QUADROTOR_BATCH_SHUTDOWN_EACH"] = "1"      # close Sysplorer after each scenario
ENV["QUADROTOR_CONTROLLER_ID"] = "baseline_pid"
ENV["QUADROTOR_CONTROLLER_MODEL_PREFIX"] = "QuadrotorModel.Experiments.Improved"
include("scripts/run_experiments.jl")
```

Valid groups include `tracking`, `step`, `trajectory`, `perturbation`,
`disturbance`, `noise_delay`, `formation`, and `all`. If
`QUADROTOR_BATCH_SCENARIOS` is set, it takes precedence over groups.
`QUADROTOR_BATCH_LIMIT=all` or leaving it unset means no limit.

For interactive debugging, include the reusable helper instead of the one-click
entry point:

```julia
include("scripts/quadrotor_experiment_runner.jl")
run_experiments(groups=["step"], limit=2)
run_experiments(scenarios=["example1_climb", "step_response_z"])
run_experiments(controller_id="baseline_pid", groups=["all"])
```

The batch runner closes the current Sysplorer instance after each scenario by
default, so it does not leave 25 Sysplorer processes open during full runs. A
failed scenario stops the batch by default; pass `continue_on_error=true` or set
`QUADROTOR_BATCH_CONTINUE_ON_ERROR=1` to continue.

For improved controllers, prefer separate experiment models and map them by
`controller_id` plus `model_prefix`:

```julia
run_experiments(
    controller_id="improved_pid_v1",
    model_prefix="QuadrotorModel.Experiments.Improved",
    scenarios=["step_response_z"],
)
```

This maps `QuadrotorModel.Experiments.StepResponseZ` to
`QuadrotorModel.Experiments.Improved.StepResponseZ` and writes results under
`results/improved_pid_v1/step_response_z/`. For scenario-specific mappings,
edit `QUADROTOR_CONTROLLER_MODEL_OVERRIDES` in
`scripts/quadrotor_experiment_manifest.jl`.

## Shared utility

`quadrotor_analysis_utils.jl` provides:

- Sysplorer startup, connection, model opening, simulation, and variable export helpers.
- Candidate-based variable matching for references, true states, controller feedback, controller outputs, rotor speeds, disturbance, noise, and delay signals.
- Tracking, step, yaw-step, trajectory, perturbation, disturbance, noise, and delay metric functions.
- Formation metrics for formation-keeping error, leader/follower tracking error, switch completion time, disturbance recovery time, minimum inter-UAV distance, and collision/unsafe-spacing flags.
- Stability checks for non-finite values, position limit, roll/pitch limit, and late-run divergence trend.
- CSV writers and Syslab/TyPlot visualization helpers.

For perturbation scenarios, degradation ratios are computed against matching
step baselines: `mass_perturbation` and `lift_coefficient_perturbation` use
`step_response_z`, while `inertia_perturbation` uses `step_response_x`. The
versioned path `results/<controller_id>/<baseline_scenario>/...` is preferred;
legacy `results/<baseline_scenario>/...` and flat files under `results/` are
still accepted. If no baseline file exists, degradation ratios are skipped and
the current scenario metrics are still written.

## Constraints

- No `.mo` model file is modified.
- No script calls `SetModelParamValue`.
- No script calls `SetModelExperiment`.
- No analysis script is created for `YawCommandController`.
