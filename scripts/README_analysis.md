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
writes analysis files to `results/`.

The fixed model package path is:

```text
E:/Program/中国软件杯/QuadrotorModel_split/QuadrotorModel_split/QuadrotorModel/package.mo
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

Each scenario writes:

- `results/<scenario_name>_variables.txt`
- `results/<scenario_name>_metrics.csv`
- `results/<scenario_name>_timeseries.csv`

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

`QuadrotorModel.Experiments.YawCommandController` is intentionally not listed
as a scenario. It is only used by `StepResponseYaw`.

## Shared utility

`quadrotor_analysis_utils.jl` provides:

- Sysplorer startup, connection, model opening, simulation, and variable export helpers.
- Candidate-based variable matching for references, true states, controller feedback, controller outputs, rotor speeds, disturbance, noise, and delay signals.
- Tracking, step, yaw-step, trajectory, perturbation, disturbance, noise, and delay metric functions.
- Stability checks for non-finite values, position limit, roll/pitch limit, and late-run divergence trend.
- CSV writers and Syslab/TyPlot visualization helpers.

For perturbation scenarios, the utility first looks for
`results/baseline_example1_metrics.csv`; if absent, it also accepts
`results/example1_climb_metrics.csv`. If neither exists, degradation ratios are
skipped and the current scenario metrics are still written.

## Constraints

- No `.mo` model file is modified.
- No script calls `SetModelParamValue`.
- No script calls `SetModelExperiment`.
- No analysis script is created for `YawCommandController`.
