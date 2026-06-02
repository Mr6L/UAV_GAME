using SysplorerAPI
using Statistics
using Printf
using Sockets

const PROJECT_ROOT = abspath(get(ENV, "QUADROTOR_PROJECT_ROOT", dirname(@__DIR__)))
const MODEL_FILE = abspath(get(ENV, "QUADROTOR_MODEL_FILE", joinpath(PROJECT_ROOT, "QuadrotorModel", "package.mo")))
const RESULT_DIR = abspath(get(ENV, "QUADROTOR_RESULT_DIR", joinpath(PROJECT_ROOT, "results")))
const CONTROLLER_ID = get(ENV, "QUADROTOR_CONTROLLER_ID", "baseline_pid")
const SYSPLORER_ROOT = abspath(get(ENV, "QUADROTOR_SYSPLORER_ROOT", get(ENV, "SYSPLORER_ROOT", "E:/APP/Sysplorer 2026a")))
const SYSPLORER_EXE = joinpath(SYSPLORER_ROOT, "Bin64", "mworks.exe")
const SYSPLORER_SIM_BIN64 = joinpath(SYSPLORER_ROOT, "Simulator", "Bin64")
const SYSPLORER_MINGW64_BIN = joinpath(SYSPLORER_ROOT, "Simulator", "mingw", "15.2.0", "mingw64", "bin")
const ENABLE_PLOTS = lowercase(get(ENV, "QUADROTOR_ENABLE_PLOTS", "1")) in ["1", "true", "yes", "on"]
const POSITION_LIMIT = 50.0
const ANGLE_LIMIT = pi / 2
const FORMATION_COLLISION_DISTANCE = parse(Float64, get(ENV, "QUADROTOR_COLLISION_DISTANCE", "0.5"))
const FORMATION_UNSAFE_DISTANCE = parse(Float64, get(ENV, "QUADROTOR_UNSAFE_DISTANCE", "1.0"))

function normalized_path(p::String)
    return lowercase(replace(abspath(replace(p, "/" => "\\")), "/" => "\\"))
end

function sysplorer_runtime_paths()
    return [
        SYSPLORER_SIM_BIN64,
        SYSPLORER_MINGW64_BIN,
        joinpath(SYSPLORER_ROOT, "Bin64"),
    ]
end

function remove_sysplorer_runtime_paths!(key::String)
    haskey(ENV, key) || return
    sep = Sys.iswindows() ? ";" : ":"
    blocked = Set(normalized_path(p) for p in sysplorer_runtime_paths())
    kept = String[]
    for part in split(ENV[key], sep; keepempty=false)
        try
            normalized_path(part) in blocked || push!(kept, part)
        catch
            push!(kept, part)
        end
    end
    ENV[key] = join(kept, sep)
end

function clean_parent_plot_env!()
    remove_sysplorer_runtime_paths!("PATH")
    Sys.iswindows() && remove_sysplorer_runtime_paths!("Path")
end

clean_parent_plot_env!()
using TyPlot

struct Metric
    name::String
    value
    unit::String
    notes::String
end

struct ExperimentSettings
    start_time::Union{Nothing, Float64}
    stop_time::Union{Nothing, Float64}
    interval::Union{Nothing, Float64}
    algo::Union{Nothing, String}
    tolerance::Union{Nothing, Float64}
    source_file::String
end

function add_metric!(rows::Vector{Metric}, name::String, value; unit="", notes="")
    push!(rows, Metric(name, value, unit, notes))
end

function assert_ok(ok, msg::String)
    ok == false && error(msg)
end

function model_source_file(model::String)
    prefix = "QuadrotorModel."
    startswith(model, prefix) || error("Unsupported model package: " * model)
    parts = split(model[length(prefix)+1:end], ".")
    return joinpath(dirname(MODEL_FILE), parts...) * ".mo"
end

function model_package_name(model::String)
    parts = split(model, ".")
    length(parts) > 1 || error("Model name has no package: " * model)
    return join(parts[1:end-1], ".")
end

function existing_model_source(model::String)
    try
        source = model_source_file(model)
        return isfile(source) ? source : nothing
    catch
        return nothing
    end
end

function resolve_extends_name(raw_name::AbstractString, current_model::String)
    name = String(strip(raw_name))
    startswith(name, "Modelica.") && return nothing
    startswith(name, "QuadrotorModel.") && return existing_model_source(name) === nothing ? nothing : name

    candidates = String[]
    if occursin(".", name)
        push!(candidates, "QuadrotorModel." * name)
    end
    push!(candidates, model_package_name(current_model) * "." * name)

    for candidate in candidates
        existing_model_source(candidate) === nothing || return candidate
    end
    return nothing
end

function find_extends_models(text::String, current_model::String)
    models = String[]
    for m in eachmatch(r"\bextends\s+([A-Za-z_]\w*(?:\.[A-Za-z_]\w*)*)", text)
        parent = resolve_extends_name(m.captures[1], current_model)
        parent === nothing && continue
        parent == current_model && continue
        parent in models || push!(models, parent)
    end
    return models
end

function find_last_experiment_body(text::String)
    bodies = collect(eachmatch(r"(?s)experiment\s*\((.*?)\)", text))
    isempty(bodies) && return nothing
    return bodies[end].captures[1]
end

function experiment_value_text(body::AbstractString, key::String)
    m = match(Regex("(?i)\\b" * key * "\\s*=\\s*([^,\\)]+)"), body)
    m === nothing && return nothing
    return strip(m.captures[1])
end

function parse_experiment_number(body::AbstractString, key::String)
    raw = experiment_value_text(body, key)
    raw === nothing && return nothing
    cleaned = replace(raw, " " => "")
    try
        return parse(Float64, cleaned)
    catch err
        println("[warning] Cannot parse experiment ", key, " value: ", raw)
        return nothing
    end
end

function parse_experiment_algo(body::AbstractString)
    raw = experiment_value_text(body, "Algorithm")
    raw === nothing && return nothing
    cleaned = strip(replace(raw, "\"" => "", "'" => ""))
    cleaned = replace(cleaned, "Integration." => "")
    return cleaned == "" ? nothing : cleaned
end

function empty_experiment_settings(source::String)
    return ExperimentSettings(nothing, nothing, nothing, nothing, nothing, source)
end

function has_experiment_settings(settings::ExperimentSettings)
    return settings.start_time !== nothing ||
           settings.stop_time !== nothing ||
           settings.interval !== nothing ||
           settings.algo !== nothing ||
           settings.tolerance !== nothing
end

function read_experiment_settings(model::String; visited=Set{String}())
    if model in visited
        println("[warning] Recursive experiment annotation lookup skipped for: ", model)
        return empty_experiment_settings(model)
    end
    push!(visited, model)

    source = model_source_file(model)
    if !isfile(source)
        println("[warning] Model source file not found for experiment annotation: ", source)
        return empty_experiment_settings(source)
    end
    text = read(source, String)
    body = find_last_experiment_body(text)
    if body === nothing
        for parent in find_extends_models(text, model)
            inherited = read_experiment_settings(parent; visited=visited)
            if has_experiment_settings(inherited)
                println("[info] No direct experiment annotation in ", source)
                println("[info] Using inherited project experiment annotation from ", inherited.source_file)
                return inherited
            end
        end
        println("[warning] No experiment annotation found in: ", source)
        return empty_experiment_settings(source)
    end
    return ExperimentSettings(
        parse_experiment_number(body, "StartTime"),
        parse_experiment_number(body, "StopTime"),
        parse_experiment_number(body, "Interval"),
        parse_experiment_algo(body),
        parse_experiment_number(body, "Tolerance"),
        source,
    )
end

function simulation_keyword_pairs(settings::ExperimentSettings)
    kwargs = Pair{Symbol, Any}[]
    settings.start_time !== nothing && push!(kwargs, :startTime => settings.start_time)
    settings.stop_time !== nothing && push!(kwargs, :stopTime => settings.stop_time)
    settings.interval !== nothing && push!(kwargs, :interval => settings.interval)
    settings.algo !== nothing && push!(kwargs, :algo => settings.algo)
    return kwargs
end

function print_experiment_settings(model::String, settings::ExperimentSettings)
    println("Using project experiment annotation for: ", model)
    println("  source: ", settings.source_file)
    println("  StartTime: ", settings.start_time === nothing ? "model/default" : settings.start_time)
    println("  StopTime: ", settings.stop_time === nothing ? "model/default" : settings.stop_time)
    println("  Interval: ", settings.interval === nothing ? "model/default" : settings.interval)
    println("  Algorithm: ", settings.algo === nothing ? "model/default" : settings.algo)
    if settings.tolerance !== nothing
        println("  Tolerance: ", settings.tolerance, " (kept from model; SysplorerAPI.SimulateModel has no tolerance keyword)")
    end
end

function controller_result_root(controller_id::String=CONTROLLER_ID)
    return joinpath(RESULT_DIR, controller_id)
end

function ensure_result_dir(scenario_name::String; controller_id::String=CONTROLLER_ID)
    mkpath(RESULT_DIR)
    result_root = controller_result_root(controller_id)
    mkpath(result_root)
    result_dir = joinpath(result_root, scenario_name)
    mkpath(result_dir)
    return result_dir
end

function existing_sysplorer_ports()
    raw_ports = SysplorerAPI.FindSysplorer()
    raw_ports === nothing && return Int[]
    ports = Int[]
    for p in collect(raw_ports)
        try
            if p isa Integer
                push!(ports, Int(p))
            else
                push!(ports, parse(Int, string(p)))
            end
        catch err
            println("[warning] Ignoring non-integer Sysplorer port: ", p)
        end
    end
    return ports
end

function path_with_sysplorer_runtime()
    sep = Sys.iswindows() ? ";" : ":"
    current = get(ENV, "PATH", "")
    parts = split(current, sep)
    for p in reverse(sysplorer_runtime_paths())
        native = replace(p, "/" => "\\")
        if isdir(native) && !(native in parts) && !(p in parts)
            current = native * sep * current
        end
    end
    return current
end

function port_available(port::Int)
    server = nothing
    try
        server = listen(ip"127.0.0.1", port)
        return true
    catch err
        return false
    finally
        server !== nothing && close(server)
    end
end

function find_available_start_port()
    configured = get(ENV, "QUADROTOR_SYSPLORER_START_PORT", "")
    if configured != ""
        port = parse(Int, configured)
        port_available(port) || error("Configured QUADROTOR_SYSPLORER_START_PORT is not available: $(port)")
        return port
    end

    for port in 8000:8100
        port_available(port) && return port
    end
    error("No available local TCP port found in 8000:8100 for Sysplorer startup.")
end

function wait_for_tcp_port(target_port::Int; timeout_s=30.0)
    deadline = time() + timeout_s
    while time() < deadline
        sock = nothing
        try
            sock = connect(ip"127.0.0.1", target_port)
            return true
        catch err
        finally
            sock !== nothing && close(sock)
        end
        sleep(0.5)
    end
    return false
end

function launch_sysplorer_process(port::Int)
    exe = replace(SYSPLORER_EXE, "/" => "\\")
    isfile(exe) || error("Sysplorer executable was not found: $(exe)")
    script_addr = "127.0.0.1:$(port)"
    cmd = Cmd([exe, "--script_addr", script_addr])
    println("Launching Sysplorer command: ", cmd)
    child_path = path_with_sysplorer_runtime()
    child_cmd = Sys.iswindows() ? addenv(cmd, "PATH" => child_path, "Path" => child_path; inherit=true) :
                                  addenv(cmd, "PATH" => child_path; inherit=true)
    return run(child_cmd; wait=false)
end

function start_and_connect_sysplorer()
    port = find_available_start_port()
    println("Starting Sysplorer: ", SYSPLORER_EXE)
    println("Selected Sysplorer port: ", port)

    launch_sysplorer_process(port)
    ready = wait_for_tcp_port(port)
    ready || error("Sysplorer launch returned, but TCP port $(port) did not open.")
    println("Sysplorer TCP port is open: ", port)
    println("Connecting Sysplorer port: ", port)
    SysplorerAPI.ConnectSysplorerEx("127.0.0.1", port)
    return port
end

function connect_or_start_sysplorer()
    env_port = get(ENV, "QUADROTOR_SYSPLORER_PORT", "")
    if env_port == ""
        env_port = get(ENV, "SYSPLORER_PORT", "")
    end
    if env_port != ""
        port = parse(Int, env_port)
        println("Connecting Sysplorer by configured port: ", port)
        SysplorerAPI.ConnectSysplorerEx("127.0.0.1", port)
        return port
    end

    if get(ENV, "QUADROTOR_REUSE_SYSPLORER", "0") == "1"
        ports = existing_sysplorer_ports()
        if isempty(ports)
            error("QUADROTOR_REUSE_SYSPLORER=1, but no running Sysplorer instance was found.")
        end
        port = ports[end]
        println("Reusing existing Sysplorer ports: ", ports)
        println("Connecting existing Sysplorer port: ", port)
        SysplorerAPI.ConnectSysplorerEx("127.0.0.1", port)
        return port
    end

    return start_and_connect_sysplorer()
end

function connect_and_open_model()
    cd(PROJECT_ROOT)
    println("Syslab working directory: ", pwd())
    connect_or_start_sysplorer()

    println("Opening model file: ", MODEL_FILE)
    assert_ok(SysplorerAPI.OpenModelFile(MODEL_FILE), "OpenModelFile failed. Check MODEL_FILE.")

    try
        SysplorerAPI.LoadLibrary("Modelica", "4.0.0.TY.1")
    catch err
        println("LoadLibrary with explicit version failed; trying default Modelica library.")
        SysplorerAPI.LoadLibrary("Modelica")
    end
end

function run_model_with_saved_settings(model::String)
    settings = read_experiment_settings(model)
    print_experiment_settings(model, settings)
    ok = false
    sim_kwargs = (; simulation_keyword_pairs(settings)...)
    try
        ok = SysplorerAPI.SimulateModel(; modelName=model, sim_kwargs...)
    catch err
        println("Keyword SimulateModel call failed; trying positional model argument with project experiment settings.")
        ok = SysplorerAPI.SimulateModel(model; sim_kwargs...)
    end
    assert_ok(ok, "SimulateModel failed. Check Sysplorer messages for compile/simulation errors.")
end

function get_result_variables_and_save(result_dir::String, scenario_name::String)
    vars = String.(SysplorerAPI.GetResultVariables(0))
    var_file = joinpath(result_dir, scenario_name * "_variables.txt")
    open(var_file, "w") do io
        for v in vars
            println(io, v)
        end
    end
    println("Saved result variable list: ", var_file)
    return vars, var_file
end

vecfloat(x) = Float64.(collect(x))
getv(varname::String) = vecfloat(SysplorerAPI.GetVarValues(varname))
rmse(x) = sqrt(mean(x .^ 2))
rms(x) = sqrt(mean(x .^ 2))
maxabs(x) = maximum(abs.(x))
final_error(x) = x[end]

function stdev(x)
    length(x) <= 1 && return 0.0
    return std(x)
end

function csv_field(x)
    s = string(x)
    if occursin(",", s) || occursin("\"", s) || occursin("\n", s)
        return "\"" * replace(s, "\"" => "\"\"") * "\""
    end
    return s
end

function write_metrics_csv(filename::String, rows::Vector{Metric})
    open(filename, "w") do io
        println(io, "metric,value,unit,notes")
        for r in rows
            println(io, join([csv_field(r.name), csv_field(r.value), csv_field(r.unit), csv_field(r.notes)], ","))
        end
    end
end

function write_timeseries_csv(filename::String, t, names::Vector{String}, arrays::Vector{Vector{Float64}})
    n = minimum([length(t); [length(a) for a in arrays]])
    open(filename, "w") do io
        println(io, join(["time"; names], ","))
        for i in 1:n
            vals = [string(t[i])]
            for a in arrays
                push!(vals, string(a[i]))
            end
            println(io, join(vals, ","))
        end
    end
end

function norm_var_name(s::String)
    return replace(lowercase(s), " " => "")
end

function pickvar(vars::Vector{String}, candidates::Vector{String}; label="", var_file="")
    for c in candidates
        c in vars && return c
    end

    for c in candidates
        cc = norm_var_name(c)
        for v in vars
            vv = norm_var_name(v)
            occursin(cc, vv) && return v
        end
    end

    println()
    println("[missing core variable] ", label)
    println("Candidates:")
    for c in candidates
        println("  ", c)
    end
    if var_file != ""
        println("Open variable list to find the real result name: ", var_file)
    end
    error("Cannot find core variable: " * label)
end

function pickvar_optional(vars::Vector{String}, candidates::Vector{String}; label="")
    try
        return pickvar(vars, candidates; label=label)
    catch err
        println("[optional variable missing] ", label, " skipped.")
        return ""
    end
end

function read_optional_vector(vars, candidates::Vector{String}, label::String)
    name = pickvar_optional(vars, candidates; label=label)
    name == "" && return "", Float64[]
    return name, getv(name)
end

function pos_ref_candidates(i::Int)
    command = i == 1 ? "xCommand.y" : i == 2 ? "yCommand.y" : "zCommand.y"
    internal = i == 1 ? "controller3_2.xReference.y" :
               i == 2 ? "controller3_2.yReference.y" :
                        "controller3_2.zReference.y"
    return [
        "controller3_2.position_command[$i]",
        "climbePath.position_command[$i]",
        "trajectory.position_command[$i]",
        "stepPath.position_command[$i]",
        "path.position_command[$i]",
        command,
        internal,
    ]
end

function pos_actual_candidates(i::Int; allow_feedback_fallback=true)
    candidates = [
        "sensors1_1.PosMea[$i]",
        "sensors1.PosMea[$i]",
        "positionNoise.cleanPosition[$i]",
        "measurementDelay.cleanPosition[$i]",
    ]
    allow_feedback_fallback && push!(candidates, "controller3_2.position[$i]")
    return candidates
end

function attitude_candidates(i::Int; allow_feedback_fallback=true)
    candidates = [
        "sensors1_1.AngleMea[$i]",
        "sensors1.AngleMea[$i]",
        "attitudeNoise.cleanAngle[$i]",
        "attitudeNoise.cleanAttitude[$i]",
        "measurementDelay.cleanAngle[$i]",
        "measurementDelay.cleanAttitude[$i]",
    ]
    allow_feedback_fallback && push!(candidates, "controller3_2.angle[$i]")
    return candidates
end

function control_candidates(i::Int)
    output_name = i == 1 ? "controller3_2.y" : "controller3_2.y$(i - 1)"
    return [output_name, "actuator1_$i.u"]
end

rotor_speed_candidates(i::Int) = ["speedSensor[$i].w", "actuator1_$i.speedSensor.w"]
disturbance_candidates(i::Int) = ["disturbanceForce.force[$i]", "disturbance.force[$i]"]
position_noise_clean_candidates(i::Int) = ["positionNoise.cleanPosition[$i]"]
position_noise_noisy_candidates(i::Int) = ["positionNoise.noisyPosition[$i]"]
attitude_noise_clean_candidates(i::Int) = ["attitudeNoise.cleanAngle[$i]", "attitudeNoise.cleanAttitude[$i]"]
attitude_noise_noisy_candidates(i::Int) = ["attitudeNoise.noisyAngle[$i]", "attitudeNoise.noisyAttitude[$i]"]
delay_position_candidates(i::Int) = ["measurementDelay.delayedPosition[$i]"]
delay_attitude_candidates(i::Int) = ["measurementDelay.delayedAngle[$i]", "measurementDelay.delayedAttitude[$i]"]

function read_group(vars::Vector{String}, candidate_fn, label::String; core=false, var_file="")
    names = String[]
    data = Vector{Vector{Float64}}()
    for i in 1:3
        candidates = candidate_fn(i)
        name = core ? pickvar(vars, candidates; label="$label[$i]", var_file=var_file) :
                      pickvar_optional(vars, candidates; label="$label[$i]")
        name == "" && continue
        push!(names, name)
        push!(data, getv(name))
    end
    return names, data
end

function read_four(vars::Vector{String}, candidate_fn, label::String)
    names = String[]
    data = Vector{Vector{Float64}}()
    for i in 1:4
        name = pickvar_optional(vars, candidate_fn(i); label="$label[$i]")
        name == "" && continue
        push!(names, name)
        push!(data, getv(name))
    end
    return names, data
end

function read_standard_signals(vars::Vector{String}, scenario_type::String, var_file::String)
    allow_feedback = !(scenario_type in ["noise", "delay"])
    pos_ref_names, pos_ref = read_group(vars, pos_ref_candidates, "position reference"; core=true, var_file=var_file)
    pos_names, pos = read_group(vars, i -> pos_actual_candidates(i; allow_feedback_fallback=allow_feedback),
                                "actual position"; core=true, var_file=var_file)
    att_names, att = read_group(vars, i -> attitude_candidates(i; allow_feedback_fallback=allow_feedback),
                                "attitude"; core=false)
    ctrl_names, ctrl = read_four(vars, control_candidates, "controller output")
    rotor_names, rotor = read_four(vars, rotor_speed_candidates, "rotor speed")
    feedback_pos_names, feedback_pos = read_group(vars, i -> ["controller3_2.position[$i]"], "controller position feedback")
    feedback_att_names, feedback_att = read_group(vars, i -> ["controller3_2.angle[$i]"], "controller attitude feedback")

    return Dict{String,Any}(
        "pos_ref_names" => pos_ref_names,
        "pos_ref" => pos_ref,
        "pos_names" => pos_names,
        "pos" => pos,
        "att_names" => att_names,
        "att" => att,
        "ctrl_names" => ctrl_names,
        "ctrl" => ctrl,
        "rotor_names" => rotor_names,
        "rotor" => rotor,
        "feedback_pos_names" => feedback_pos_names,
        "feedback_pos" => feedback_pos,
        "feedback_att_names" => feedback_att_names,
        "feedback_att" => feedback_att,
    )
end

function read_yaw_signals(vars::Vector{String}, var_file::String)
    pos_names, pos = read_group(vars, i -> pos_actual_candidates(i; allow_feedback_fallback=true),
                                "actual position"; core=true, var_file=var_file)
    att_names, att = read_group(vars, i -> attitude_candidates(i; allow_feedback_fallback=true),
                                "attitude"; core=true, var_file=var_file)
    yaw_ref_name = pickvar(vars, ["yawCommand.y", "controller3_2.yaw_command", "controller3_2.feedback.u1"];
                           label="yaw reference", var_file=var_file)
    ctrl_names, ctrl = read_four(vars, control_candidates, "controller output")
    rotor_names, rotor = read_four(vars, rotor_speed_candidates, "rotor speed")
    return Dict{String,Any}(
        "pos_names" => pos_names,
        "pos" => pos,
        "att_names" => att_names,
        "att" => att,
        "yaw_ref_name" => yaw_ref_name,
        "yaw_ref" => getv(yaw_ref_name),
        "ctrl_names" => ctrl_names,
        "ctrl" => ctrl,
        "rotor_names" => rotor_names,
        "rotor" => rotor,
    )
end

function add_optional_groups!(data::Dict{String,Any}, vars::Vector{String})
    n, d = read_group(vars, disturbance_candidates, "disturbance force")
    data["disturbance_names"] = n
    data["disturbance"] = d

    n, d = read_group(vars, position_noise_clean_candidates, "clean position")
    data["position_noise_clean_names"] = n
    data["position_noise_clean"] = d
    n, d = read_group(vars, position_noise_noisy_candidates, "noisy position")
    data["position_noise_noisy_names"] = n
    data["position_noise_noisy"] = d

    n, d = read_group(vars, attitude_noise_clean_candidates, "clean attitude")
    data["attitude_noise_clean_names"] = n
    data["attitude_noise_clean"] = d
    n, d = read_group(vars, attitude_noise_noisy_candidates, "noisy attitude")
    data["attitude_noise_noisy_names"] = n
    data["attitude_noise_noisy"] = d

    n, d = read_group(vars, delay_position_candidates, "delayed position")
    data["delay_position_names"] = n
    data["delay_position"] = d
    n, d = read_group(vars, delay_attitude_candidates, "delayed attitude")
    data["delay_attitude_names"] = n
    data["delay_attitude"] = d
end

function position_errors(data::Dict{String,Any})
    ref = data["pos_ref"]
    pos = data["pos"]
    ex = ref[1] .- pos[1]
    ey = ref[2] .- pos[2]
    ez = ref[3] .- pos[3]
    e3d = sqrt.(ex .^ 2 .+ ey .^ 2 .+ ez .^ 2)
    eh = sqrt.(ex .^ 2 .+ ey .^ 2)
    return [ex, ey, ez], e3d, eh
end

function tail_range(n::Int; fraction=0.1)
    start_i = max(1, floor(Int, n * (1 - fraction)) + 1)
    return start_i:n
end

function finite_ok(arrays)
    for a in arrays
        for v in a
            !isfinite(v) && return false
        end
    end
    return true
end

function first_bad_time(t, arrays, limit)
    for i in eachindex(t)
        for a in arrays
            if i <= length(a) && (!isfinite(a[i]) || abs(a[i]) > limit)
                return t[i]
            end
        end
    end
    return NaN
end

function detect_stability(t, pos, att, err_norm)
    finite = finite_ok([pos; att; [err_norm]])
    max_position_abs = length(pos) == 0 ? NaN : maximum([maxabs(a) for a in pos])
    roll_pitch = length(att) >= 2 ? att[1:2] : Vector{Vector{Float64}}()
    max_attitude_abs = length(roll_pitch) == 0 ? NaN : maximum([maxabs(a) for a in roll_pitch])
    position_ok = isnan(max_position_abs) || max_position_abs <= POSITION_LIMIT
    attitude_ok = isnan(max_attitude_abs) || max_attitude_abs <= ANGLE_LIMIT

    trend_bad = false
    if length(err_norm) >= 30
        n = length(err_norm)
        k = max(5, floor(Int, n * 0.1))
        prev = mean(err_norm[max(1, n - 2k + 1):max(1, n - k)])
        last = mean(err_norm[n - k + 1:n])
        trend_bad = last > max(1e-6, 1.5 * prev) && last > 0.5
    end

    stable = finite && position_ok && attitude_ok && !trend_bad
    divergence_time = NaN
    if !finite || !position_ok
        divergence_time = first_bad_time(t, pos, POSITION_LIMIT)
    elseif !attitude_ok
        divergence_time = first_bad_time(t, roll_pitch, ANGLE_LIMIT)
    end

    return Dict(
        "stable" => stable,
        "finite_ok" => finite,
        "position_ok" => position_ok,
        "attitude_ok" => attitude_ok,
        "trend_bad" => trend_bad,
        "divergence_time" => divergence_time,
        "max_position_abs" => max_position_abs,
        "max_attitude_abs" => max_attitude_abs,
    )
end

function add_tracking_rows!(rows, data, t; include_horizontal=false)
    errs, e3d, eh = position_errors(data)
    labels = ["x", "y", "z"]
    for i in 1:3
        add_metric!(rows, "$(labels[i])_tracking_rmse", rmse(errs[i]), unit="m")
        add_metric!(rows, "$(labels[i])_tracking_max_abs", maxabs(errs[i]), unit="m")
        add_metric!(rows, "$(labels[i])_tracking_final_error", final_error(errs[i]), unit="m")
    end
    include_horizontal && add_metric!(rows, "horizontal_error_rmse", rmse(eh), unit="m")
    include_horizontal && add_metric!(rows, "horizontal_error_max", maximum(eh), unit="m")
    add_metric!(rows, "position_error_norm_rmse", rmse(e3d), unit="m")
    add_metric!(rows, "position_error_norm_max", maximum(e3d), unit="m")
    add_metric!(rows, "position_error_norm_final", e3d[end], unit="m")

    att = data["att"]
    if length(att) >= 3
        add_metric!(rows, "roll_max_abs", maxabs(att[1]), unit="rad")
        add_metric!(rows, "pitch_max_abs", maxabs(att[2]), unit="rad")
        add_metric!(rows, "yaw_max_abs", maxabs(att[3]), unit="rad")
    end

    ctrl = data["ctrl"]
    for i in eachindex(ctrl)
        add_metric!(rows, "control_u$(i)_max_abs", maxabs(ctrl[i]))
        add_metric!(rows, "control_u$(i)_rms", rms(ctrl[i]))
    end

    rotor = data["rotor"]
    for i in eachindex(rotor)
        add_metric!(rows, "rotor_w$(i)_max_abs", maxabs(rotor[i]), unit="rad/s")
        add_metric!(rows, "rotor_w$(i)_rms", rms(rotor[i]), unit="rad/s")
    end

    stable = detect_stability(t, data["pos"], att, e3d)
    add_metric!(rows, "stable", stable["stable"])
    add_metric!(rows, "max_position_abs", stable["max_position_abs"], unit="m")
    add_metric!(rows, "max_attitude_abs", stable["max_attitude_abs"], unit="rad")
    stable["stable"] || add_metric!(rows, "divergence_time", stable["divergence_time"], unit="s")
    return errs, e3d, eh, stable
end

function detect_step_change(t, ref)
    n = length(ref)
    head = ref[1:max(2, floor(Int, 0.1n))]
    tail = ref[tail_range(n)]
    initial = median(head)
    final = median(tail)
    amp = final - initial
    threshold = max(abs(amp) * 0.1, 1e-6)
    idx = findfirst(i -> abs(ref[i] - initial) > threshold, eachindex(ref))
    idx === nothing && return Dict("ok" => false, "initial" => initial, "final" => final,
                                   "amplitude" => amp, "index" => 1, "time" => NaN)
    return Dict("ok" => abs(amp) > 1e-6, "initial" => initial, "final" => final,
                "amplitude" => amp, "index" => idx, "time" => t[idx])
end

function crossing_time(t, y, target, start_idx, direction)
    for i in start_idx:length(y)
        if (direction > 0 && y[i] >= target) || (direction < 0 && y[i] <= target)
            return t[i]
        end
    end
    return NaN
end

function compute_settling_time(t, y, final, step_idx, amp; band_fraction=0.05)
    band = max(abs(amp) * band_fraction, 1e-6)
    last_out = findlast(i -> abs(y[i] - final) > band, step_idx:length(y))
    last_out === nothing && return 0.0
    idx = step_idx + last_out - 1
    idx >= length(t) && return NaN
    return t[idx + 1] - t[step_idx]
end

function add_step_rows!(rows, t, ref, actual, axis_label::String)
    step = detect_step_change(t, ref)
    add_metric!(rows, "$(axis_label)_step_detected", step["ok"])
    add_metric!(rows, "$(axis_label)_step_time", step["time"], unit="s")
    add_metric!(rows, "$(axis_label)_step_amplitude", step["amplitude"])
    if !step["ok"]
        add_metric!(rows, "$(axis_label)_step_warning", "reference step not clearly detected")
        return step
    end

    idx = step["index"]
    initial = step["initial"]
    final = step["final"]
    amp = step["amplitude"]
    direction = sign(amp)
    t10 = crossing_time(t, actual, initial + 0.1 * amp, idx, direction)
    t90 = crossing_time(t, actual, initial + 0.9 * amp, idx, direction)
    rise_time = isnan(t10) || isnan(t90) ? NaN : t90 - t10
    signed = (actual[idx:end] .- final) .* direction
    peak_rel, peak_rel_idx = findmax(signed)
    overshoot_abs = max(0.0, peak_rel)
    peak_time = t[idx + peak_rel_idx - 1] - t[idx]
    settling = compute_settling_time(t, actual, final, idx, amp)
    steady_error = mean(actual[tail_range(length(actual))]) - final

    add_metric!(rows, "$(axis_label)_rise_time_10_90", rise_time, unit="s")
    add_metric!(rows, "$(axis_label)_overshoot_abs", overshoot_abs)
    add_metric!(rows, "$(axis_label)_overshoot_percent", abs(amp) < 1e-9 ? NaN : 100 * overshoot_abs / abs(amp), unit="%")
    add_metric!(rows, "$(axis_label)_peak_time", peak_time, unit="s")
    add_metric!(rows, "$(axis_label)_settling_time_5pct", settling, unit="s")
    add_metric!(rows, "$(axis_label)_steady_state_error", steady_error)
    add_metric!(rows, "$(axis_label)_rmse", rmse(ref .- actual))
    return step
end

function compute_tracking_metrics(data, t)
    rows = Metric[]
    add_tracking_rows!(rows, data, t)
    return rows
end

function compute_step_metrics(data, t, axis::Symbol)
    rows = Metric[]
    axis_idx = axis == :x ? 1 : axis == :y ? 2 : 3
    labels = ["x", "y", "z"]
    errs, e3d, eh, stable = add_tracking_rows!(rows, data, t)
    add_step_rows!(rows, t, data["pos_ref"][axis_idx], data["pos"][axis_idx], labels[axis_idx])
    other = [i for i in 1:3 if i != axis_idx]
    coupling = maximum([maxabs(data["pos"][i] .- data["pos"][i][1]) for i in other])
    add_metric!(rows, "non_step_axis_max_coupling_offset", coupling, unit="m")
    return rows
end

angle_error(ref, actual) = atan.(sin.(ref .- actual), cos.(ref .- actual))
single_angle_error(ref, actual) = atan(sin(ref - actual), cos(ref - actual))

function compute_yaw_step_metrics(data, t)
    rows = Metric[]
    yaw_ref = data["yaw_ref"]
    yaw = data["att"][3]
    yaw_err = angle_error(yaw_ref, yaw)
    yaw_actual_rel = [single_angle_error(v, yaw[1]) for v in yaw]
    yaw_ref_rel = [single_angle_error(v, yaw_ref[1]) for v in yaw_ref]

    temp_data = Dict{String,Any}(
        "pos" => data["pos"],
        "att" => data["att"],
        "ctrl" => data["ctrl"],
        "rotor" => data["rotor"],
    )
    drift = sqrt.((data["pos"][1] .- data["pos"][1][1]) .^ 2 .+
                  (data["pos"][2] .- data["pos"][2][1]) .^ 2 .+
                  (data["pos"][3] .- data["pos"][3][1]) .^ 2)
    stable = detect_stability(t, data["pos"], data["att"], drift)

    add_step_rows!(rows, t, yaw_ref_rel, yaw_actual_rel, "yaw")
    add_metric!(rows, "yaw_rmse", rmse(yaw_err), unit="rad")
    add_metric!(rows, "position_drift_max", maximum(drift), unit="m")
    add_metric!(rows, "roll_coupling_max_abs", maxabs(data["att"][1]), unit="rad")
    add_metric!(rows, "pitch_coupling_max_abs", maxabs(data["att"][2]), unit="rad")
    for i in eachindex(data["ctrl"])
        add_metric!(rows, "control_u$(i)_max_abs", maxabs(data["ctrl"][i]))
    end
    add_metric!(rows, "stable", stable["stable"])
    stable["stable"] || add_metric!(rows, "divergence_time", stable["divergence_time"], unit="s")
    return rows, yaw_err, drift
end

function compute_trajectory_metrics(data, t, scenario_name::String)
    rows = Metric[]
    errs, e3d, eh, stable = add_tracking_rows!(rows, data, t; include_horizontal=true)
    if occursin("square", scenario_name) || occursin("sharp", scenario_name)
        add_metric!(rows, "transient_error_peak", maximum(e3d), unit="m")
        add_metric!(rows, "turn_or_waypoint_error_peak", maximum(e3d), unit="m",
                    notes="global peak used when waypoint/turn times are not explicit in result variables")
    end
    return rows
end

function read_metric_value(filename::String, wanted::String)
    isfile(filename) || return NaN
    for (i, line) in enumerate(eachline(filename))
        i == 1 && continue
        parts = split(line, ",")
        length(parts) < 2 && continue
        if strip(parts[1], ['"']) == wanted
            try
                return parse(Float64, strip(parts[2], ['"']))
            catch err
                return NaN
            end
        end
    end
    return NaN
end

function baseline_scenario_for_perturbation(scenario_name::String)
    if occursin("inertia", scenario_name)
        return "step_response_x"
    elseif occursin("mass", scenario_name) || occursin("lift_coefficient", scenario_name)
        return "step_response_z"
    end
    return "step_response_z"
end

function scenario_metrics_file(scenario_name::String; controller_id::String=CONTROLLER_ID)
    return joinpath(controller_result_root(controller_id), scenario_name, scenario_name * "_metrics.csv")
end

function legacy_scenario_metrics_file(scenario_name::String)
    return joinpath(RESULT_DIR, scenario_name, scenario_name * "_metrics.csv")
end

function add_baseline_ratios!(rows, current_metrics::Vector{Metric};
                              baseline_scenario::String="example1_climb",
                              controller_id::String=CONTROLLER_ID)
    baseline_files = [
        scenario_metrics_file(baseline_scenario; controller_id=controller_id),
        legacy_scenario_metrics_file(baseline_scenario),
        joinpath(RESULT_DIR, baseline_scenario * "_metrics.csv"),
    ]
    baseline = ""
    for f in baseline_files
        if isfile(f)
            baseline = f
            break
        end
    end
    if baseline == ""
        println("Baseline metrics file not found for $(baseline_scenario); skipping performance retention ratios.")
        add_metric!(rows, "performance_retention_note", "baseline metrics file not found")
        add_metric!(rows, "performance_retention_baseline_scenario", baseline_scenario)
        return
    end

    add_metric!(rows, "performance_retention_baseline_scenario", baseline_scenario)
    lookup = Dict(r.name => r.value for r in current_metrics)
    pairs = [
        ("rmse_degradation_ratio", "position_error_norm_rmse"),
        ("max_error_degradation_ratio", "position_error_norm_max"),
        ("final_error_degradation_ratio", "position_error_norm_final"),
    ]
    for (ratio_name, metric_name) in pairs
        base = read_metric_value(baseline, metric_name)
        cur = haskey(lookup, metric_name) ? lookup[metric_name] : NaN
        value = (!isfinite(base) || abs(base) < 1e-12) ? NaN : cur / base
        add_metric!(rows, ratio_name, value, notes="baseline=$(relpath(baseline, RESULT_DIR))")
    end
end

function compute_perturbation_metrics(data, t, scenario_name::String; controller_id::String=CONTROLLER_ID)
    rows = compute_tracking_metrics(data, t)
    add_baseline_ratios!(rows, rows;
                         baseline_scenario=baseline_scenario_for_perturbation(scenario_name),
                         controller_id=controller_id)
    return rows
end

function force_norm(force)
    length(force) < 3 && return Float64[]
    return sqrt.(force[1] .^ 2 .+ force[2] .^ 2 .+ force[3] .^ 2)
end

function recovery_time(t, err_norm, start_idx; band=0.1)
    hold = max(5, floor(Int, 0.05 * length(t)))
    for i in start_idx:length(t)
        j = min(length(t), i + hold)
        all(err_norm[i:j] .<= band) && return t[i] - t[start_idx]
    end
    return NaN
end

function compute_disturbance_metrics(data, t, scenario_name::String)
    rows = Metric[]
    errs, e3d, eh, stable = add_tracking_rows!(rows, data, t)
    force = data["disturbance"]
    fn = force_norm(force)
    if length(fn) > 0
        threshold = max(1e-8, 0.05 * maximum(fn))
        idx = findfirst(v -> v > threshold, fn)
        peak, peak_idx = findmax(fn)
        if idx !== nothing
            add_metric!(rows, "disturbance_start_time", t[idx], unit="s")
            add_metric!(rows, "disturbance_peak", peak, unit="N")
            add_metric!(rows, "disturbance_direction_x", force[1][peak_idx])
            add_metric!(rows, "disturbance_direction_y", force[2][peak_idx])
            add_metric!(rows, "disturbance_direction_z", force[3][peak_idx])
            before = 1:max(1, idx - 1)
            add_metric!(rows, "pre_disturbance_position_x_mean", mean(data["pos"][1][before]), unit="m")
            add_metric!(rows, "pre_disturbance_position_y_mean", mean(data["pos"][2][before]), unit="m")
            add_metric!(rows, "pre_disturbance_position_z_mean", mean(data["pos"][3][before]), unit="m")
            add_metric!(rows, "post_disturbance_max_position_error", maximum(e3d[idx:end]), unit="m")
            add_metric!(rows, "recovery_time", recovery_time(t, e3d, idx), unit="s")
            add_metric!(rows, "post_recovery_tail_error_mean", mean(e3d[tail_range(length(e3d))]), unit="m")
        end
    end

    if occursin("sustained", scenario_name)
        steady = mean(e3d[tail_range(length(e3d))])
        add_metric!(rows, "sustained_steady_position_error", steady, unit="m")
        add_metric!(rows, "sustained_steady_error_near_zero", steady < 0.1)
    elseif occursin("pulse", scenario_name)
        tail_std = stdev(e3d[tail_range(length(e3d))])
        add_metric!(rows, "pulse_persistent_oscillation_std", tail_std, unit="m")
        add_metric!(rows, "pulse_persistent_oscillation", tail_std > 0.1)
    elseif occursin("random", scenario_name)
        add_metric!(rows, "random_disturbance_error_rms", rms(e3d), unit="m")
        add_metric!(rows, "random_disturbance_error_std", stdev(e3d), unit="m")
        for i in eachindex(data["ctrl"])
            add_metric!(rows, "random_control_u$(i)_rms", rms(data["ctrl"][i]))
        end
    end
    return rows
end

function add_noise_pair_metrics!(rows, clean, noisy, prefix)
    n = min(length(clean), length(noisy))
    n == 0 && return
    for i in 1:n
        diff = noisy[i] .- clean[i]
        add_metric!(rows, "$(prefix)_axis$(i)_noise_rms", rms(diff))
        add_metric!(rows, "$(prefix)_axis$(i)_noise_std", stdev(diff))
        add_metric!(rows, "$(prefix)_axis$(i)_noise_max_abs", maxabs(diff))
    end
end

function compute_noise_metrics(data, t)
    rows = Metric[]
    add_tracking_rows!(rows, data, t)
    add_noise_pair_metrics!(rows, data["position_noise_clean"], data["position_noise_noisy"], "position")
    add_noise_pair_metrics!(rows, data["attitude_noise_clean"], data["attitude_noise_noisy"], "attitude")
    _, e3d, _ = position_errors(data)
    add_metric!(rows, "true_position_error_rms", rms(e3d), unit="m")
    add_metric!(rows, "true_position_error_std", stdev(e3d), unit="m")
    if length(data["att"]) >= 3
        add_metric!(rows, "roll_std", stdev(data["att"][1]), unit="rad")
        add_metric!(rows, "pitch_std", stdev(data["att"][2]), unit="rad")
        add_metric!(rows, "yaw_std", stdev(data["att"][3]), unit="rad")
    end
    for i in eachindex(data["ctrl"])
        add_metric!(rows, "control_u$(i)_std", stdev(data["ctrl"][i]))
    end
    for i in eachindex(data["rotor"])
        add_metric!(rows, "rotor_w$(i)_std", stdev(data["rotor"][i]), unit="rad/s")
    end
    return rows
end

function compute_delay_metrics(data, t)
    rows = Metric[]
    errs, e3d, eh, stable = add_tracking_rows!(rows, data, t)
    delayed_pos = data["delay_position"]
    if length(delayed_pos) >= 3
        for i in 1:3
            diff = delayed_pos[i] .- data["pos"][i]
            add_metric!(rows, "delayed_position_axis$(i)_diff_rms", rms(diff), unit="m")
            add_metric!(rows, "delayed_position_axis$(i)_diff_max_abs", maxabs(diff), unit="m")
        end
    end
    if stable["stable"]
        add_step_rows!(rows, t, data["pos_ref"][3], data["pos"][3], "z")
    else
        add_metric!(rows, "delay_response_note", "unstable response; ordinary settling metrics are not interpreted")
    end
    return rows
end

function drone_position_candidates(drone::Int, axis::Int)
    return [
        "drone$(drone).position[$axis]",
        "drone$(drone).sensors.PosMea[$axis]",
        "drone$(drone).controller.position[$axis]",
        "drone$(drone).quadChassis.body.r_0[$axis]",
        "drone$(drone).quadChassis.body.frame_a.r_0[$axis]",
    ]
end

function drone_command_candidates(drone::Int, axis::Int)
    return [
        "drone$(drone).position_command[$axis]",
        "command.position_command[$drone,$axis]",
        "command.position_command[$drone, $axis]",
        "drone$(drone).controller.position_command[$axis]",
    ]
end

function formation_force_candidates(axis::Int)
    return [
        "wind.force[$axis]",
        "drone1.external_force[$axis]",
        "drone1.disturbanceForce.force[$axis]",
    ]
end

function read_formation_group(vars::Vector{String}, n::Int, candidate_fn, label::String; core=false, var_file="")
    names = [String[] for _ in 1:n]
    data = [Vector{Vector{Float64}}() for _ in 1:n]
    for drone in 1:n
        for axis in 1:3
            candidates = candidate_fn(drone, axis)
            name = core ? pickvar(vars, candidates; label="$label drone$(drone)[$axis]", var_file=var_file) :
                          pickvar_optional(vars, candidates; label="$label drone$(drone)[$axis]")
            name == "" && continue
            push!(names[drone], name)
            push!(data[drone], getv(name))
        end
    end
    return names, data
end

function read_formation_signals(vars::Vector{String}, n::Int, var_file::String)
    pos_names, positions = read_formation_group(vars, n, drone_position_candidates, "actual position"; core=true, var_file=var_file)
    cmd_names, commands = read_formation_group(vars, n, drone_command_candidates, "position command"; core=true, var_file=var_file)
    force_names, force = read_group(vars, formation_force_candidates, "formation external force")
    return Dict{String,Any}(
        "n" => n,
        "position_names" => pos_names,
        "positions" => positions,
        "command_names" => cmd_names,
        "commands" => commands,
        "force_names" => force_names,
        "force" => force,
    )
end

function norm3(ax, ay, az)
    return sqrt.(ax .^ 2 .+ ay .^ 2 .+ az .^ 2)
end

function tracking_error_norms(data::Dict{String,Any})
    n = data["n"]
    positions = data["positions"]
    commands = data["commands"]
    errs = Vector{Vector{Float64}}()
    for drone in 1:n
        push!(errs, norm3(commands[drone][1] .- positions[drone][1],
                         commands[drone][2] .- positions[drone][2],
                         commands[drone][3] .- positions[drone][3]))
    end
    return errs
end

function formation_error_norms(data::Dict{String,Any})
    n = data["n"]
    positions = data["positions"]
    commands = data["commands"]
    leader_pos = positions[1]
    leader_cmd = commands[1]
    errs = Vector{Vector{Float64}}()
    for drone in 2:n
        ex = (positions[drone][1] .- leader_pos[1]) .- (commands[drone][1] .- leader_cmd[1])
        ey = (positions[drone][2] .- leader_pos[2]) .- (commands[drone][2] .- leader_cmd[2])
        ez = (positions[drone][3] .- leader_pos[3]) .- (commands[drone][3] .- leader_cmd[3])
        push!(errs, norm3(ex, ey, ez))
    end
    return errs
end

function aggregate_rms_by_time(series::Vector{Vector{Float64}})
    isempty(series) && return Float64[]
    n = minimum(length.(series))
    out = zeros(n)
    for i in 1:n
        out[i] = sqrt(mean([s[i]^2 for s in series]))
    end
    return out
end

function collect_series_values(series::Vector{Vector{Float64}})
    values = Float64[]
    for s in series
        append!(values, s)
    end
    return values
end

function pairwise_distance_series(data::Dict{String,Any})
    n = data["n"]
    positions = data["positions"]
    names = String[]
    distances = Vector{Vector{Float64}}()
    for i in 1:n-1
        for j in i+1:n
            push!(names, "distance_drone$(i)_drone$(j)")
            push!(distances, norm3(positions[i][1] .- positions[j][1],
                                  positions[i][2] .- positions[j][2],
                                  positions[i][3] .- positions[j][3]))
        end
    end
    if isempty(distances)
        return names, distances, Float64[], "", NaN, NaN
    end

    npts = minimum(length.(distances))
    min_by_time = zeros(npts)
    for k in 1:npts
        min_by_time[k] = minimum(d[k] for d in distances)
    end

    best_pair = ""
    best_distance = Inf
    best_index = 1
    for i in eachindex(distances)
        value, idx = findmin(distances[i])
        if value < best_distance
            best_distance = value
            best_index = idx
            best_pair = names[i]
        end
    end
    return names, distances, min_by_time, best_pair, best_index, best_distance
end

function tail_trend_bad(signal; min_value=0.5, ratio=1.5)
    length(signal) >= 30 || return false
    n = length(signal)
    k = max(5, floor(Int, n * 0.1))
    prev = mean(signal[max(1, n - 2k + 1):max(1, n - k)])
    last = mean(signal[n - k + 1:n])
    return last > max(1e-6, ratio * prev) && last > min_value
end

function time_index_at_or_after(t, value)
    idx = findfirst(x -> x >= value, t)
    return idx === nothing ? length(t) : idx
end

function time_index_at_or_before(t, value)
    idx = findlast(x -> x <= value, t)
    return idx === nothing ? 1 : idx
end

function time_window(t, start_time, end_time)
    start_idx = time_index_at_or_after(t, start_time)
    end_idx = isfinite(end_time) ? time_index_at_or_before(t, end_time) : length(t)
    end_idx = max(start_idx, end_idx)
    return start_idx:end_idx
end

function first_hold_time(t, signal, start_time, threshold; hold_time=2.0, end_time=Inf)
    start_idx = time_index_at_or_after(t, start_time)
    dt = length(t) > 1 ? median(diff(t)) : hold_time
    hold_n = max(1, ceil(Int, hold_time / max(dt, 1e-6)))
    for i in start_idx:length(t)
        t[i] > end_time && break
        j = min(length(t), i + hold_n - 1)
        t[j] > end_time && break
        all(signal[i:j] .<= threshold) && return t[i]
    end
    return NaN
end

function add_switch_metrics!(rows, t, formation_error, spacing, switch_times, switch_durations)
    isempty(switch_times) && return
    threshold = max(0.3, 0.15 * spacing)
    add_metric!(rows, "switch_completion_threshold", threshold, unit="m")

    first_start = switch_times[1]
    last_end = switch_times[end] + switch_durations[end]
    switch_range = time_window(t, first_start, Inf)
    add_metric!(rows, "switching_formation_error_max", maximum(formation_error[switch_range]), unit="m")

    for i in eachindex(switch_times)
        start_time = switch_times[i]
        duration = switch_durations[i]
        next_start = i < length(switch_times) ? switch_times[i + 1] : Inf
        ready_time = first_hold_time(t, formation_error, start_time + duration, threshold; hold_time=2.0, end_time=next_start)
        prefix = i == 1 ? "first_switch" : i == 2 ? "second_switch" : "switch$(i)"
        add_metric!(rows, "$(prefix)_completion_abs_time", ready_time, unit="s")
        add_metric!(rows, "$(prefix)_completion_time", isnan(ready_time) ? NaN : ready_time - start_time, unit="s")
        add_metric!(rows, "$(prefix)_settling_after_reference_end", isnan(ready_time) ? NaN : ready_time - (start_time + duration), unit="s")
        local_range = time_window(t, start_time, next_start)
        add_metric!(rows, "$(prefix)_formation_error_max", maximum(formation_error[local_range]), unit="m")
    end

    tail_start = time_index_at_or_after(t, last_end)
    add_metric!(rows, "post_switch_tail_formation_error", mean(formation_error[tail_start:end]), unit="m")
end

function add_formation_disturbance_metrics!(rows, data, t, formation_error, spacing; disturbance_start=nothing)
    add_metric!(rows, "formation_disturbance_scope", "common_force_all_uavs",
                notes="current formation wind scenario applies the same force to every UAV")
    force = data["force"]
    fn = force_norm(force)
    start_idx = nothing
    if length(fn) > 0 && maximum(fn) > 0
        threshold = max(1e-8, 0.05 * maximum(fn))
        start_idx = findfirst(v -> v > threshold, fn)
        peak, peak_idx = findmax(fn)
        if start_idx !== nothing
            add_metric!(rows, "formation_disturbance_start_time", t[start_idx], unit="s")
            add_metric!(rows, "formation_disturbance_peak", peak, unit="N")
            add_metric!(rows, "formation_disturbance_peak_time", t[peak_idx], unit="s")
            length(force) >= 3 && add_metric!(rows, "formation_disturbance_direction_x", force[1][peak_idx], unit="N")
            length(force) >= 3 && add_metric!(rows, "formation_disturbance_direction_y", force[2][peak_idx], unit="N")
            length(force) >= 3 && add_metric!(rows, "formation_disturbance_direction_z", force[3][peak_idx], unit="N")
        end
    elseif disturbance_start !== nothing
        start_idx = time_index_at_or_after(t, disturbance_start)
        add_metric!(rows, "formation_disturbance_start_time", t[start_idx], unit="s", notes="configured start time")
    end

    start_idx === nothing && return
    band = max(0.3, 0.15 * spacing)
    add_metric!(rows, "post_disturbance_formation_error_max", maximum(formation_error[start_idx:end]), unit="m")
    add_metric!(rows, "formation_disturbance_recovery_time", recovery_time(t, formation_error, start_idx; band=band), unit="s")
    add_metric!(rows, "post_recovery_tail_formation_error", mean(formation_error[tail_range(length(formation_error))]), unit="m")
    add_metric!(rows, "sustained_wind_steady_formation_error", mean(formation_error[tail_range(length(formation_error))]), unit="m")
end

function compute_formation_metrics(data, t, scenario_type::String; spacing=2.0,
                                   switch_times=Float64[], switch_durations=Float64[],
                                   disturbance_start=nothing,
                                   collision_distance=FORMATION_COLLISION_DISTANCE,
                                   unsafe_distance=FORMATION_UNSAFE_DISTANCE)
    rows = Metric[]
    n = data["n"]
    tracking = tracking_error_norms(data)
    formation_followers = formation_error_norms(data)
    formation_error = aggregate_rms_by_time(formation_followers)
    formation_values = collect_series_values(formation_followers)
    dist_names, distances, min_dist, closest_pair, closest_idx, closest_distance = pairwise_distance_series(data)

    add_metric!(rows, "formation_drone_count", n)
    add_metric!(rows, "formation_spacing_nominal", spacing, unit="m")
    add_metric!(rows, "collision_distance_threshold", collision_distance, unit="m")
    add_metric!(rows, "unsafe_distance_threshold", unsafe_distance, unit="m")

    add_metric!(rows, "leader_tracking_rmse", rmse(tracking[1]), unit="m")
    add_metric!(rows, "leader_tracking_max", maximum(tracking[1]), unit="m")
    add_metric!(rows, "leader_tracking_final", tracking[1][end], unit="m")

    follower_rmse = Float64[]
    follower_max = Float64[]
    for drone in 2:n
        terr = tracking[drone]
        push!(follower_rmse, rmse(terr))
        push!(follower_max, maximum(terr))
        add_metric!(rows, "follower$(drone)_tracking_rmse", rmse(terr), unit="m")
        add_metric!(rows, "follower$(drone)_tracking_max", maximum(terr), unit="m")
        ferr = formation_followers[drone - 1]
        add_metric!(rows, "follower$(drone)_formation_error_rmse", rmse(ferr), unit="m")
        add_metric!(rows, "follower$(drone)_formation_error_max", maximum(ferr), unit="m")
    end
    add_metric!(rows, "follower_tracking_rmse_mean", mean(follower_rmse), unit="m")
    add_metric!(rows, "follower_tracking_max", maximum(follower_max), unit="m")

    add_metric!(rows, "formation_error_rmse", rms(formation_values), unit="m")
    add_metric!(rows, "formation_error_max", maximum(formation_values), unit="m")
    add_metric!(rows, "formation_error_final", formation_error[end], unit="m")
    add_metric!(rows, "formation_error_tail_mean", mean(formation_error[tail_range(length(formation_error))]), unit="m")

    add_metric!(rows, "min_inter_uav_distance", closest_distance, unit="m")
    add_metric!(rows, "closest_pair", closest_pair)
    add_metric!(rows, "closest_pair_time", isempty(min_dist) ? NaN : t[closest_idx], unit="s")
    add_metric!(rows, "collision_flag", closest_distance < collision_distance)
    add_metric!(rows, "unsafe_spacing_flag", closest_distance < unsafe_distance)

    position_arrays = Vector{Vector{Float64}}()
    for drone in data["positions"]
        append!(position_arrays, drone)
    end
    finite = finite_ok([position_arrays; [formation_error]; distances])
    max_position_abs = maximum([maxabs(a) for a in position_arrays])
    divergence = maximum(formation_values) > 2 * spacing || tail_trend_bad(formation_error)
    add_metric!(rows, "formation_divergence_flag", divergence)
    add_metric!(rows, "max_position_abs", max_position_abs, unit="m")
    add_metric!(rows, "stable", finite && max_position_abs <= POSITION_LIMIT && !divergence && closest_distance >= collision_distance)

    if scenario_type == "formation_switch"
        add_switch_metrics!(rows, t, formation_error, spacing, switch_times, switch_durations)
        if !isempty(min_dist)
            switch_range = time_window(t, isempty(switch_times) ? t[1] : switch_times[1], Inf)
            add_metric!(rows, "switching_min_inter_uav_distance", minimum(min_dist[switch_range]), unit="m")
        end
    elseif scenario_type == "formation_disturbance"
        add_formation_disturbance_metrics!(rows, data, t, formation_error, spacing; disturbance_start=disturbance_start)
    end

    return rows
end

function build_formation_timeseries(data)
    names = String[]
    arrays = Vector{Vector{Float64}}()
    n = data["n"]
    axis_names = ["x", "y", "z"]
    for drone in 1:n
        for axis in 1:3
            push!(names, "drone$(drone)_$(axis_names[axis])")
            push!(arrays, data["positions"][drone][axis])
            push!(names, "drone$(drone)_$(axis_names[axis])_cmd")
            push!(arrays, data["commands"][drone][axis])
        end
    end

    tracking = tracking_error_norms(data)
    for drone in 1:n
        push!(names, "drone$(drone)_tracking_error")
        push!(arrays, tracking[drone])
    end

    follower_errors = formation_error_norms(data)
    formation_error = aggregate_rms_by_time(follower_errors)
    for i in eachindex(follower_errors)
        push!(names, "drone$(i + 1)_formation_error")
        push!(arrays, follower_errors[i])
    end
    push!(names, "formation_error_rms")
    push!(arrays, formation_error)

    dist_names, distances, min_dist, _, _, _ = pairwise_distance_series(data)
    for i in eachindex(distances)
        push!(names, dist_names[i])
        push!(arrays, distances[i])
    end
    if !isempty(min_dist)
        push!(names, "min_inter_uav_distance")
        push!(arrays, min_dist)
    end

    if length(data["force"]) > 0
        for i in eachindex(data["force"])
            push!(names, "formation_force_$(i)")
            push!(arrays, data["force"][i])
        end
    end
    return names, arrays
end

function plot_vertical_markers(xs, ymin, ymax)
    for x in xs
        plot([x, x], [ymin, ymax])
    end
end

function plot_formation_trajectories(data, scenario_name)
    n = data["n"]
    figure()
    try
        plot3(data["positions"][1][1], data["positions"][1][2], data["positions"][1][3]); hold("on")
        for drone in 2:n
            plot3(data["positions"][drone][1], data["positions"][drone][2], data["positions"][drone][3])
        end
        xlabel("x / m"); ylabel("y / m"); zlabel("z / m")
        title("3D Formation Trajectories - " * scenario_name)
    catch err
        println("[warning] 3D plot failed; falling back to XY trajectory plot: ", err)
        plot(data["positions"][1][1], data["positions"][1][2]); hold("on")
        for drone in 2:n
            plot(data["positions"][drone][1], data["positions"][drone][2])
        end
        xlabel("x / m"); ylabel("y / m")
        title("XY Formation Trajectories - " * scenario_name)
    end
    grid("on")
    legend(["drone$(i)" for i in 1:n])
end

function plot_formation_outputs(t, data, scenario_name; switch_times=Float64[], disturbance_start=nothing)
    follower_errors = formation_error_norms(data)
    formation_error = aggregate_rms_by_time(follower_errors)
    figure()
    plot(t, formation_error); hold("on")
    for i in eachindex(follower_errors)
        plot(t, follower_errors[i])
    end
    if !isempty(switch_times)
        ymax = maximum(formation_error)
        plot_vertical_markers(switch_times, 0.0, ymax)
    end
    if disturbance_start !== nothing
        ymax = maximum(formation_error)
        plot_vertical_markers([disturbance_start], 0.0, ymax)
    end
    grid("on")
    xlabel("Time / s")
    ylabel("Formation error / m")
    legend(["formation_rms"; ["drone$(i + 1)" for i in eachindex(follower_errors)]])
    title("Formation Error - " * scenario_name)

    tracking = tracking_error_norms(data)
    figure()
    plot(t, tracking[1]); hold("on")
    for drone in 2:data["n"]
        plot(t, tracking[drone])
    end
    grid("on")
    xlabel("Time / s")
    ylabel("Tracking error / m")
    legend(["drone$(i)" for i in 1:data["n"]])
    title("Leader/Follower Tracking Error - " * scenario_name)

    dist_names, distances, min_dist, _, _, _ = pairwise_distance_series(data)
    isempty(distances) && return
    figure()
    plot(t, min_dist); hold("on")
    for d in distances
        plot(t, d)
    end
    grid("on")
    xlabel("Time / s")
    ylabel("Distance / m")
    legend(["min_distance"; dist_names])
    title("Inter-UAV Distances - " * scenario_name)

    length(data["force"]) > 0 && plot_group(t, data["force"], ["Fx", "Fy", "Fz"],
                                             "Formation Disturbance Force - " * scenario_name, "Force / N")
end

function print_formation_report(model, scenario_name, scenario_type, data, rows, files)
    report_data = Dict{String,Any}(
        "pos_names" => reduce(vcat, data["position_names"]),
        "pos_ref_names" => reduce(vcat, data["command_names"]),
    )
    print_report(model, scenario_name, scenario_type, report_data, rows, files)
end

function run_formation_analysis(model::String, scenario_name::String, scenario_type::String; n::Int,
                                spacing=2.0, switch_times=Float64[], switch_durations=Float64[],
                                disturbance_start=nothing,
                                collision_distance=FORMATION_COLLISION_DISTANCE,
                                unsafe_distance=FORMATION_UNSAFE_DISTANCE,
                                controller_id::String=CONTROLLER_ID)
    result_dir = ensure_result_dir(scenario_name; controller_id=controller_id)
    connect_and_open_model()
    run_model_with_saved_settings(model)
    println("Reading result variable list ...")
    vars, var_file = get_result_variables_and_save(result_dir, scenario_name)
    println("Reading time vector ...")
    t = getv("time")

    println("Reading formation signals ...")
    data = read_formation_signals(vars, n, var_file)
    println("Computing formation metrics ...")
    rows = compute_formation_metrics(data, t, scenario_type; spacing=spacing,
                                     switch_times=switch_times,
                                     switch_durations=switch_durations,
                                     disturbance_start=disturbance_start,
                                     collision_distance=collision_distance,
                                     unsafe_distance=unsafe_distance)

    metrics_file = joinpath(result_dir, scenario_name * "_metrics.csv")
    timeseries_file = joinpath(result_dir, scenario_name * "_timeseries.csv")
    names, arrays = build_formation_timeseries(data)

    println("Writing formation analysis CSV files ...")
    write_metrics_csv(metrics_file, rows)
    write_timeseries_csv(timeseries_file, t, names, arrays)

    if ENABLE_PLOTS
        plot_formation_trajectories(data, scenario_name)
        plot_formation_outputs(t, data, scenario_name; switch_times=switch_times, disturbance_start=disturbance_start)
    else
        println("Plot generation skipped because QUADROTOR_ENABLE_PLOTS is disabled.")
    end

    print_formation_report(model, scenario_name, scenario_type, data, rows, [var_file, metrics_file, timeseries_file])
end

function plot_position_tracking(t, data, scenario_name)
    ref = data["pos_ref"]
    pos = data["pos"]
    figure()
    plot(t, ref[1]); hold("on")
    plot(t, pos[1]); plot(t, ref[2]); plot(t, pos[2]); plot(t, ref[3]); plot(t, pos[3])
    grid("on")
    xlabel("Time / s")
    ylabel("Position / m")
    legend(["x_ref", "x", "y_ref", "y", "z_ref", "z"])
    title("Position Tracking - " * scenario_name)
end

function plot_step_axis(t, data, axis_idx, scenario_name)
    labels = ["x", "y", "z"]
    figure()
    plot(t, data["pos_ref"][axis_idx]); hold("on")
    plot(t, data["pos"][axis_idx])
    grid("on")
    xlabel("Time / s")
    ylabel(labels[axis_idx] * " / m")
    legend([labels[axis_idx] * "_ref", labels[axis_idx]])
    title("Step Axis Tracking - " * scenario_name)
end

function plot_xyz_actual(t, data, scenario_name)
    figure()
    plot(t, data["pos"][1]); hold("on")
    plot(t, data["pos"][2]); plot(t, data["pos"][3])
    grid("on")
    xlabel("Time / s")
    ylabel("Position / m")
    legend(["x", "y", "z"])
    title("Actual Positions - " * scenario_name)
end

function plot_xy_trajectory(data, scenario_name)
    figure()
    plot(data["pos_ref"][1], data["pos_ref"][2]); hold("on")
    plot(data["pos"][1], data["pos"][2])
    grid("on")
    xlabel("x / m")
    ylabel("y / m")
    legend(["reference", "actual"])
    title("XY Trajectory - " * scenario_name)
end

function plot_error_norm(t, e3d, scenario_name)
    figure()
    plot(t, e3d)
    grid("on")
    xlabel("Time / s")
    ylabel("3D error norm / m")
    title("Position Error Norm - " * scenario_name)
end

function plot_errors(t, errs, scenario_name)
    figure()
    plot(t, errs[1]); hold("on")
    plot(t, errs[2]); plot(t, errs[3])
    grid("on")
    xlabel("Time / s")
    ylabel("Tracking error / m")
    legend(["e_x", "e_y", "e_z"])
    title("Position Errors - " * scenario_name)
end

function plot_attitude(t, att, scenario_name)
    length(att) < 3 && return
    figure()
    plot(t, att[1]); hold("on")
    plot(t, att[2]); plot(t, att[3])
    grid("on")
    xlabel("Time / s")
    ylabel("Angle / rad")
    legend(["roll", "pitch", "yaw"])
    title("Attitude - " * scenario_name)
end

function plot_control_outputs(t, ctrl, scenario_name)
    length(ctrl) == 0 && return
    figure()
    plot(t, ctrl[1]); hold("on")
    for i in 2:length(ctrl)
        plot(t, ctrl[i])
    end
    grid("on")
    xlabel("Time / s")
    ylabel("Controller output")
    legend(["u$(i)" for i in 1:length(ctrl)])
    title("Controller Outputs - " * scenario_name)
end

function plot_rotor_speeds(t, rotor, scenario_name)
    length(rotor) == 0 && return
    figure()
    plot(t, rotor[1]); hold("on")
    for i in 2:length(rotor)
        plot(t, rotor[i])
    end
    grid("on")
    xlabel("Time / s")
    ylabel("Rotor speed / rad/s")
    legend(["w$(i)" for i in 1:length(rotor)])
    title("Rotor Speeds - " * scenario_name)
end

function plot_group(t, group, labels, title_text, ylabel_text)
    length(group) == 0 && return
    figure()
    plot(t, group[1]); hold("on")
    for i in 2:length(group)
        plot(t, group[i])
    end
    grid("on")
    xlabel("Time / s")
    ylabel(ylabel_text)
    legend(labels)
    title(title_text)
end

function build_standard_timeseries(data)
    errs, e3d, eh = position_errors(data)
    names = ["x_ref", "x", "y_ref", "y", "z_ref", "z", "e_x", "e_y", "e_z", "error_3d", "error_horizontal"]
    arrays = [data["pos_ref"][1], data["pos"][1], data["pos_ref"][2], data["pos"][2],
              data["pos_ref"][3], data["pos"][3], errs[1], errs[2], errs[3], e3d, eh]
    if length(data["att"]) >= 3
        append!(names, ["roll", "pitch", "yaw"])
        append!(arrays, data["att"])
    end
    for i in eachindex(data["ctrl"])
        push!(names, "u$(i)")
        push!(arrays, data["ctrl"][i])
    end
    for i in eachindex(data["rotor"])
        push!(names, "w$(i)")
        push!(arrays, data["rotor"][i])
    end
    groups = [
        ("force", "disturbance"),
        ("position_clean", "position_noise_clean"),
        ("position_noisy", "position_noise_noisy"),
        ("attitude_clean", "attitude_noise_clean"),
        ("attitude_noisy", "attitude_noise_noisy"),
        ("position_delayed", "delay_position"),
        ("attitude_delayed", "delay_attitude"),
    ]
    for (prefix, key) in groups
        if haskey(data, key)
            for i in eachindex(data[key])
                push!(names, "$(prefix)_$(i)")
                push!(arrays, data[key][i])
            end
        end
    end
    return names, arrays, errs, e3d, eh
end

function plot_standard_outputs(t, data, scenario_name, scenario_type; step_axis=:z)
    names, arrays, errs, e3d, eh = build_standard_timeseries(data)
    if scenario_type == "trajectory"
        plot_xy_trajectory(data, scenario_name)
    end
    plot_position_tracking(t, data, scenario_name)
    if scenario_type == "step"
        axis_idx = step_axis == :x ? 1 : step_axis == :y ? 2 : 3
        plot_step_axis(t, data, axis_idx, scenario_name)
        plot_xyz_actual(t, data, scenario_name)
    end
    plot_errors(t, errs, scenario_name)
    plot_error_norm(t, e3d, scenario_name)
    plot_attitude(t, data["att"], scenario_name)
    plot_control_outputs(t, data["ctrl"], scenario_name)
    plot_rotor_speeds(t, data["rotor"], scenario_name)
    haskey(data, "disturbance") && plot_group(t, data["disturbance"], ["Fx", "Fy", "Fz"],
                                               "Disturbance Force - " * scenario_name, "Force / N")
    return names, arrays
end

function plot_noise_delay_outputs(t, data, scenario_name)
    if length(data["position_noise_clean"]) > 0 && length(data["position_noise_noisy"]) > 0
        plot_group(t, [data["position_noise_clean"]; data["position_noise_noisy"]],
                   ["clean_x", "clean_y", "clean_z", "noisy_x", "noisy_y", "noisy_z"],
                   "Position Noise Signals - " * scenario_name, "Position / m")
    end
    if length(data["attitude_noise_clean"]) > 0 && length(data["attitude_noise_noisy"]) > 0
        plot_group(t, [data["attitude_noise_clean"]; data["attitude_noise_noisy"]],
                   ["clean_roll", "clean_pitch", "clean_yaw", "noisy_roll", "noisy_pitch", "noisy_yaw"],
                   "Attitude Noise Signals - " * scenario_name, "Angle / rad")
    end
    if length(data["delay_position"]) > 0
        plot_group(t, [data["pos"]; data["delay_position"]],
                   ["x", "y", "z", "x_delayed", "y_delayed", "z_delayed"],
                   "Delayed Position Feedback - " * scenario_name, "Position / m")
    end
end

function print_report(model, scenario_name, scenario_type, data, rows, files)
    println()
    println("========== Scenario Report ==========")
    println("Scenario: ", scenario_name)
    println("Model: ", model)
    println("Type: ", scenario_type)
    if haskey(data, "pos_ref_names")
        println("Position reference variables: ", join(data["pos_ref_names"], ", "))
    end
    if haskey(data, "pos_names")
        println("Actual position variables: ", join(data["pos_names"], ", "))
    end
    if haskey(data, "att_names")
        println("Attitude variables: ", join(data["att_names"], ", "))
    end
    if haskey(data, "yaw_ref_name")
        println("Yaw reference variable: ", data["yaw_ref_name"])
    end
    stable_row = findfirst(r -> r.name == "stable", rows)
    stable_row !== nothing && println("Stability: ", rows[stable_row].value)
    println("Core metrics:")
    for r in rows[1:min(length(rows), 12)]
        println("  ", r.name, " = ", r.value, r.unit == "" ? "" : " " * r.unit)
    end
    println("Result files:")
    for f in files
        println("  ", f)
    end
    println("=====================================")
end

function run_analysis(model::String, scenario_name::String, scenario_type::String; step_axis=:z,
                      controller_id::String=CONTROLLER_ID)
    result_dir = ensure_result_dir(scenario_name; controller_id=controller_id)
    connect_and_open_model()
    run_model_with_saved_settings(model)
    println("Reading result variable list ...")
    vars, var_file = get_result_variables_and_save(result_dir, scenario_name)
    println("Reading time vector ...")
    t = getv("time")

    metrics_file = joinpath(result_dir, scenario_name * "_metrics.csv")
    timeseries_file = joinpath(result_dir, scenario_name * "_timeseries.csv")

    if scenario_type == "yaw_step"
        println("Reading yaw-step signals ...")
        data = read_yaw_signals(vars, var_file)
        println("Computing yaw-step metrics ...")
        rows, yaw_err, drift = compute_yaw_step_metrics(data, t)
        names = ["yaw_ref", "yaw", "yaw_error", "position_drift"]
        arrays = [data["yaw_ref"], data["att"][3], yaw_err, drift]
        if length(data["pos"]) >= 3
            append!(names, ["x", "y", "z"])
            append!(arrays, data["pos"])
        end
        if length(data["att"]) >= 3
            append!(names, ["roll", "pitch", "yaw_actual"])
            append!(arrays, data["att"])
        end
        for i in eachindex(data["ctrl"])
            push!(names, "u$(i)")
            push!(arrays, data["ctrl"][i])
        end
        println("Writing analysis CSV files ...")
        write_metrics_csv(metrics_file, rows)
        write_timeseries_csv(timeseries_file, t, names, arrays)
        if ENABLE_PLOTS
            figure(); plot(t, data["yaw_ref"]); hold("on"); plot(t, data["att"][3])
            grid("on"); xlabel("Time / s"); ylabel("Yaw / rad")
            legend(["yaw_ref", "yaw"]); title("Yaw Step - " * scenario_name)
            figure(); plot(t, yaw_err); grid("on"); xlabel("Time / s"); ylabel("Yaw error / rad")
            title("Yaw Error - " * scenario_name)
            plot_error_norm(t, drift, scenario_name)
            plot_attitude(t, data["att"], scenario_name)
            plot_control_outputs(t, data["ctrl"], scenario_name)
        else
            println("Plot generation skipped because QUADROTOR_ENABLE_PLOTS is disabled.")
        end
        print_report(model, scenario_name, scenario_type, data, rows, [var_file, metrics_file, timeseries_file])
        return
    end

    println("Reading standard signals ...")
    data = read_standard_signals(vars, scenario_type, var_file)
    add_optional_groups!(data, vars)

    println("Computing metrics ...")
    if scenario_type == "tracking"
        rows = compute_tracking_metrics(data, t)
    elseif scenario_type == "step"
        rows = compute_step_metrics(data, t, step_axis)
    elseif scenario_type == "trajectory"
        rows = compute_trajectory_metrics(data, t, scenario_name)
    elseif scenario_type == "perturbation"
        rows = compute_perturbation_metrics(data, t, scenario_name; controller_id=controller_id)
    elseif scenario_type == "disturbance"
        rows = compute_disturbance_metrics(data, t, scenario_name)
    elseif scenario_type == "noise"
        rows = compute_noise_metrics(data, t)
    elseif scenario_type == "delay"
        rows = compute_delay_metrics(data, t)
    else
        error("Unknown scenario type: " * scenario_type)
    end

    names, arrays, errs, e3d, eh = build_standard_timeseries(data)
    println("Writing analysis CSV files ...")
    write_metrics_csv(metrics_file, rows)
    write_timeseries_csv(timeseries_file, t, names, arrays)
    if ENABLE_PLOTS
        plot_standard_outputs(t, data, scenario_name, scenario_type; step_axis=step_axis)
        scenario_type in ["noise", "delay"] && plot_noise_delay_outputs(t, data, scenario_name)
    else
        println("Plot generation skipped because QUADROTOR_ENABLE_PLOTS is disabled.")
    end
    print_report(model, scenario_name, scenario_type, data, rows, [var_file, metrics_file, timeseries_file])
end
