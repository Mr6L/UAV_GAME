include(joinpath(@__DIR__, "quadrotor_analysis_utils.jl"))
include(joinpath(@__DIR__, "quadrotor_experiment_manifest.jl"))

truthy(value::AbstractString) = lowercase(strip(value)) in ["1", "true", "yes", "on"]

function split_csv(value::AbstractString)
    stripped = strip(value)
    stripped == "" && return String[]
    return [strip(v) for v in split(stripped, ",") if strip(v) != ""]
end

function parse_optional_limit(value::AbstractString)
    stripped = strip(value)
    stripped == "" && return nothing
    lowercase(stripped) in ["all", "none", "nothing"] && return nothing
    return parse(Int, stripped)
end

function with_model_prefix(prefix::String, model::String)
    prefix = strip(prefix)
    prefix == "" && return model
    prefix = endswith(prefix, ".") ? prefix[1:end-1] : prefix
    short_name = split(model, ".")[end]
    return prefix * "." * short_name
end

function model_for_controller(spec; controller_id::String, model_prefix::String="")
    overrides = get(QUADROTOR_CONTROLLER_MODEL_OVERRIDES, controller_id, Dict{String, String}())
    haskey(overrides, spec.name) && return overrides[spec.name]
    controller_id == "baseline_pid" && return spec.model
    model_prefix != "" && return with_model_prefix(model_prefix, spec.model)
    error("No model mapping for controller_id=$(controller_id), scenario=$(spec.name). " *
          "Add QUADROTOR_CONTROLLER_MODEL_OVERRIDES or pass model_prefix.")
end

function select_scenarios(; groups=["all"], scenarios=String[], limit=nothing)
    selected = collect(QUADROTOR_SCENARIOS)
    if !isempty(scenarios)
        wanted = Set(scenarios)
        selected = [s for s in selected if s.name in wanted]
    elseif !("all" in groups)
        wanted_groups = Set(groups)
        selected = [s for s in selected if s.group in wanted_groups || s.type in wanted_groups]
    end
    if limit !== nothing
        selected = selected[1:min(limit, length(selected))]
    end
    return selected
end

function shutdown_sysplorer_after_scenario()
    try
        println("Closing current Sysplorer instance ...")
        SysplorerAPI.Exit()
        sleep(1.0)
    catch err
        println("[warning] Sysplorer shutdown failed or no session was active: ", err)
    end
end

function read_metrics_map(filename::String)
    metrics = Dict{String, String}()
    isfile(filename) || return metrics
    for (i, line) in enumerate(eachline(filename))
        i == 1 && continue
        parts = split(line, ","; limit=4)
        length(parts) >= 2 || continue
        metrics[parts[1]] = parts[2]
    end
    return metrics
end

function write_batch_summary(controller_id::String, rows)
    result_root = controller_result_root(controller_id)
    mkpath(result_root)
    summary_file = joinpath(result_root, "summary_metrics.csv")
    headers = [
        "controller_id", "scenario", "group", "type", "model", "status",
        "stable", "position_error_norm_rmse", "formation_error_rmse",
        "min_inter_uav_distance", "collision_flag", "metrics_file", "error_message",
    ]
    open(summary_file, "w") do io
        println(io, join(headers, ","))
        for row in rows
            values = [get(row, h, "") for h in headers]
            println(io, join(csv_field.(values), ","))
        end
    end
    return summary_file
end

function run_one_scenario(spec; controller_id::String, model_prefix::String="")
    model = model_for_controller(spec; controller_id=controller_id, model_prefix=model_prefix)
    println("=====================================")
    println("Controller: ", controller_id)
    println("Scenario: ", spec.name)
    println("Model: ", model)
    println("=====================================")

    if spec.runner == :formation
        run_formation_analysis(model, spec.name, spec.type; spec.kwargs..., controller_id=controller_id)
    else
        run_analysis(model, spec.name, spec.type; spec.kwargs..., controller_id=controller_id)
    end
    metrics_file = scenario_metrics_file(spec.name; controller_id=controller_id)
    metrics = read_metrics_map(metrics_file)
    return Dict(
        "controller_id" => controller_id,
        "scenario" => spec.name,
        "group" => spec.group,
        "type" => spec.type,
        "model" => model,
        "status" => "ok",
        "stable" => get(metrics, "stable", ""),
        "position_error_norm_rmse" => get(metrics, "position_error_norm_rmse", ""),
        "formation_error_rmse" => get(metrics, "formation_error_rmse", ""),
        "min_inter_uav_distance" => get(metrics, "min_inter_uav_distance", ""),
        "collision_flag" => get(metrics, "collision_flag", ""),
        "metrics_file" => metrics_file,
        "error_message" => "",
    )
end

function run_experiments(; controller_id::String=CONTROLLER_ID,
                         model_prefix::String=get(ENV, "QUADROTOR_CONTROLLER_MODEL_PREFIX", ""),
                         groups=["all"],
                         scenarios=String[],
                         limit=nothing,
                         continue_on_error::Bool=false,
                         shutdown_each::Bool=true,
                         dry_run::Bool=false)
    selected = select_scenarios(groups=groups, scenarios=scenarios, limit=limit)
    isempty(selected) && error("No scenarios selected.")

    println("Selected $(length(selected)) scenario(s).")
    println("Controller: ", controller_id)
    println("Groups: ", join(groups, ","))
    !isempty(scenarios) && println("Scenarios: ", join(scenarios, ","))
    limit !== nothing && println("Limit: ", limit)
    println("Result root: ", controller_result_root(controller_id))
    shutdown_each && println("Sysplorer will be closed after each scenario.")
    dry_run && println("Dry run enabled; no Sysplorer simulation will be started.")
    flush(stdout)

    if dry_run
        for spec in selected
            model = try
                model_for_controller(spec; controller_id=controller_id, model_prefix=model_prefix)
            catch err
                "<unmapped: " * sprint(showerror, err) * ">"
            end
            println(" - ", spec.name, " [", spec.group, "/", spec.type, "] -> ", model)
        end
        return ""
    end

    summary_rows = Vector{Dict{String, String}}()
    summary_file = ""
    for spec in selected
        row = Dict{String, String}()
        try
            row = run_one_scenario(spec; controller_id=controller_id, model_prefix=model_prefix)
        catch err
            row = Dict(
                "controller_id" => controller_id,
                "scenario" => spec.name,
                "group" => spec.group,
                "type" => spec.type,
                "model" => try
                    model_for_controller(spec; controller_id=controller_id, model_prefix=model_prefix)
                catch
                    spec.model
                end,
                "status" => "failed",
                "stable" => "",
                "position_error_norm_rmse" => "",
                "formation_error_rmse" => "",
                "min_inter_uav_distance" => "",
                "collision_flag" => "",
                "metrics_file" => scenario_metrics_file(spec.name; controller_id=controller_id),
                "error_message" => sprint(showerror, err),
            )
            println("[error] Scenario failed: ", spec.name)
            println(row["error_message"])
        finally
            shutdown_each && shutdown_sysplorer_after_scenario()
        end

        push!(summary_rows, row)
        summary_file = write_batch_summary(controller_id, summary_rows)
        if get(row, "status", "") == "failed" && !continue_on_error
            println("Stopping batch because continue_on_error=false.")
            break
        end
    end
    println("Batch summary: ", summary_file)
    return summary_file
end

function run_experiments_from_env()
    controller_id = get(ENV, "QUADROTOR_CONTROLLER_ID", CONTROLLER_ID)
    groups = split_csv(get(ENV, "QUADROTOR_BATCH_GROUPS", "all"))
    isempty(groups) && (groups = ["all"])
    scenarios = split_csv(get(ENV, "QUADROTOR_BATCH_SCENARIOS", ""))
    limit = parse_optional_limit(get(ENV, "QUADROTOR_BATCH_LIMIT", ""))
    continue_on_error = truthy(get(ENV, "QUADROTOR_BATCH_CONTINUE_ON_ERROR", "0"))
    shutdown_each = truthy(get(ENV, "QUADROTOR_BATCH_SHUTDOWN_EACH", "1"))
    dry_run = truthy(get(ENV, "QUADROTOR_BATCH_DRY_RUN", "0"))
    return run_experiments(controller_id=controller_id,
                           groups=groups,
                           scenarios=scenarios,
                           limit=limit,
                           continue_on_error=continue_on_error,
                           shutdown_each=shutdown_each,
                           dry_run=dry_run)
end
