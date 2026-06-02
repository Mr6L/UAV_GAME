# quadrotor_sysplorer_analyze_only.jl
#
# 作用：
#   只负责启动 Sysplorer 仿真、读取仿真结果、计算定量指标并画图。
#   不修改模型参数，不修改仿真参数。
#   所有参数、扰动、噪声、延迟、仿真起止时间、求解器设置均使用 Sysplorer 模型中已有设置。

using SysplorerAPI
using TyPlot
using Statistics

# ========== 0. 用户配置区 ==========

PROJECT_ROOT = abspath(get(ENV, "QUADROTOR_PROJECT_ROOT", dirname(@__DIR__)))
MODEL_FILE = abspath(get(ENV, "QUADROTOR_MODEL_FILE", joinpath(PROJECT_ROOT, "QuadrotorModel", "package.mo")))

# 改成你要运行的场景模型，例如：
# MODEL = "QuadrotorModel.Examples.Example1"
# MODEL = "QuadrotorModel.Experiments.SustainedLateralWind"
# MODEL = "QuadrotorModel.Experiments.MeasurementDelayExperiment"
MODEL = "QuadrotorModel.Examples.Example1"

# 结果文件名前缀，输出到 Syslab 当前工作目录
RESULT_PREFIX = replace(MODEL, "." => "_")

# 失稳/异常判据，仅用于自动标记，不会干预仿真
POSITION_LIMIT = 50.0      # m
ANGLE_LIMIT = 1.5708       # rad，约 90 deg

# 额外希望读取和绘制的变量。没有就留空。
# 示例：
# EXTRA_VARIABLES = [
#     "disturbanceForce.force[1]",
#     "measurementDelay.delayedPosition[3]",
#     "positionNoise.noisyPosition[1]",
# ]
EXTRA_VARIABLES = String[]


# ========== 1. 工具函数 ==========

function assert_ok(ok, msg)
    if ok == false
        error(msg)
    end
end

function vecfloat(x)
    return Float64.(collect(x))
end

function hasvar(vars, name::String)
    return name in vars
end

function pickvar(vars, candidates::Vector{String}; label="")
    for c in candidates
        if c in vars
            return c
        end
    end

    # 宽松匹配，处理少量变量名差异
    for c in candidates
        cc = replace(lowercase(c), " " => "")
        for v in vars
            vv = replace(lowercase(v), " " => "")
            if occursin(cc, vv)
                return v
            end
        end
    end

    println("\n[变量未找到] ", label)
    println("候选变量为：")
    for c in candidates
        println("  ", c)
    end
    println("请打开 ", RESULT_PREFIX, "_result_variables.txt 搜索真实变量名后修改候选列表。")
    error("Cannot find variable for " * label)
end

function pickvar_optional(vars, candidates::Vector{String}; label="")
    try
        return pickvar(vars, candidates; label=label)
    catch err
        println("[可选变量未找到] ", label, "，跳过。")
        return ""
    end
end

function getv(varname::String)
    return vecfloat(GetVarValues(varname))
end

function rmse(e)
    return sqrt(mean(e .^ 2))
end

function maxabs(e)
    return maximum(abs.(e))
end

function signal_is_finite(x)
    for v in x
        if !isfinite(v)
            return false
        end
    end
    return true
end

function print_metric(name, e)
    println(rpad(name, 24), " RMSE = ", rmse(e),
            " | MaxAbs = ", maxabs(e),
            " | Final = ", e[end])
end

function write_metrics_csv(filename, rows)
    open(filename, "w") do io
        println(io, "name,rmse,max_abs,final")
        for r in rows
            println(io, r[1], ",", r[2], ",", r[3], ",", r[4])
        end
    end
end

function write_timeseries_csv(filename, t, names, arrays)
    open(filename, "w") do io
        println(io, join(["time"; names], ","))
        for i in 1:length(t)
            vals = [string(t[i])]
            for a in arrays
                push!(vals, string(a[i]))
            end
            println(io, join(vals, ","))
        end
    end
end


# ========== 2. 连接 Sysplorer 并加载模型 ==========

println("Connecting Sysplorer ...")
ConnectSysplorer()

println("Opening model file: ", MODEL_FILE)
assert_ok(OpenModelFile(MODEL_FILE), "OpenModelFile failed. 请检查 MODEL_FILE 路径。")

try
    LoadLibrary("Modelica", "4.0.0.TY.1")
catch err
    println("LoadLibrary(\"Modelica\", \"4.0.0.TY.1\") failed, trying LoadLibrary(\"Modelica\") ...")
    LoadLibrary("Modelica")
end


# ========== 3. 启动仿真 ==========

println("Simulating model with settings saved in Sysplorer: ", MODEL)
println("No SetModelParamValue and no SetModelExperiment will be called.")

ok = false
try
    # 只指定模型名，使用模型自身保存的 experiment 设置
    global ok = SimulateModel(modelName=MODEL)
catch err
    println("SimulateModel(modelName=MODEL) failed, trying SimulateModel(MODEL) ...")
    global ok = SimulateModel(MODEL)
end

assert_ok(ok, "SimulateModel failed. 请在 Sysplorer 消息窗口查看编译/仿真错误。")


# ========== 4. 读取结果变量 ==========

println("Reading result variables ...")
vars = String.(GetResultVariables(0))

var_file = RESULT_PREFIX * "_result_variables.txt"
write(var_file, join(vars, "\n"))
println("All result variables have been written to ", var_file)

t = getv("time")

# 参考位置：优先读取控制器实际接收的参考输入
xref_name = pickvar(vars, [
    "controller3_2.position_command[1]",
    "climbePath.position_command[1]",
    "stepPath.position_command[1]",
    "path.position_command[1]",
], label="x reference")

yref_name = pickvar(vars, [
    "controller3_2.position_command[2]",
    "climbePath.position_command[2]",
    "stepPath.position_command[2]",
    "path.position_command[2]",
], label="y reference")

zref_name = pickvar(vars, [
    "controller3_2.position_command[3]",
    "climbePath.position_command[3]",
    "stepPath.position_command[3]",
    "path.position_command[3]",
], label="z reference")

# 真实位置：优先读取传感器输出。
# 对噪声/延迟场景，不建议优先使用 controller3_2.position，
# 因为它可能是加噪声或延迟后的反馈信号。
x_name = pickvar(vars, [
    "sensors1_1.PosMea[1]",
    "sensors1.PosMea[1]",
    "controller3_2.position[1]",
], label="x actual")

y_name = pickvar(vars, [
    "sensors1_1.PosMea[2]",
    "sensors1.PosMea[2]",
    "controller3_2.position[2]",
], label="y actual")

z_name = pickvar(vars, [
    "sensors1_1.PosMea[3]",
    "sensors1.PosMea[3]",
    "controller3_2.position[3]",
], label="z actual")

roll_name = pickvar_optional(vars, [
    "sensors1_1.AngleMea[1]",
    "sensors1.AngleMea[1]",
    "controller3_2.angle[1]",
], label="roll")

pitch_name = pickvar_optional(vars, [
    "sensors1_1.AngleMea[2]",
    "sensors1.AngleMea[2]",
    "controller3_2.angle[2]",
], label="pitch")

yaw_name = pickvar_optional(vars, [
    "sensors1_1.AngleMea[3]",
    "sensors1.AngleMea[3]",
    "controller3_2.angle[3]",
], label="yaw")

u1_name = pickvar_optional(vars, ["controller3_2.y",  "actuator1_1.u"], label="motor command 1")
u2_name = pickvar_optional(vars, ["controller3_2.y1", "actuator1_2.u"], label="motor command 2")
u3_name = pickvar_optional(vars, ["controller3_2.y2", "actuator1_3.u"], label="motor command 3")
u4_name = pickvar_optional(vars, ["controller3_2.y3", "actuator1_4.u"], label="motor command 4")

w1_name = pickvar_optional(vars, ["speedSensor[1].w", "actuator1_1.speedSensor.w"], label="rotor speed 1")
w2_name = pickvar_optional(vars, ["speedSensor[2].w", "actuator1_2.speedSensor.w"], label="rotor speed 2")
w3_name = pickvar_optional(vars, ["speedSensor[3].w", "actuator1_3.speedSensor.w"], label="rotor speed 3")
w4_name = pickvar_optional(vars, ["speedSensor[4].w", "actuator1_4.speedSensor.w"], label="rotor speed 4")

xref = getv(xref_name); yref = getv(yref_name); zref = getv(zref_name)
x    = getv(x_name);    y    = getv(y_name);    z    = getv(z_name)

has_attitude = roll_name != "" && pitch_name != "" && yaw_name != ""
if has_attitude
    roll = getv(roll_name)
    pitch = getv(pitch_name)
    yaw = getv(yaw_name)
else
    roll = Float64[]; pitch = Float64[]; yaw = Float64[]
end

has_command = u1_name != "" && u2_name != "" && u3_name != "" && u4_name != ""
if has_command
    u1 = getv(u1_name); u2 = getv(u2_name); u3 = getv(u3_name); u4 = getv(u4_name)
else
    u1 = Float64[]; u2 = Float64[]; u3 = Float64[]; u4 = Float64[]
end

has_rotor_speed = w1_name != "" && w2_name != "" && w3_name != "" && w4_name != ""
if has_rotor_speed
    w1 = getv(w1_name); w2 = getv(w2_name); w3 = getv(w3_name); w4 = getv(w4_name)
else
    w1 = Float64[]; w2 = Float64[]; w3 = Float64[]; w4 = Float64[]
end

extra_names = String[]
extra_data = Vector{Vector{Float64}}()
for name in EXTRA_VARIABLES
    if hasvar(vars, name)
        push!(extra_names, name)
        push!(extra_data, getv(name))
    else
        println("[额外变量未找到] ", name)
    end
end


# ========== 5. 定量分析 ==========

ex = xref .- x
ey = yref .- y
ez = zref .- z
e_norm = sqrt.(ex.^2 .+ ey.^2 .+ ez.^2)

finite_ok = signal_is_finite(x) && signal_is_finite(y) && signal_is_finite(z)
position_ok = maxabs(x) < POSITION_LIMIT && maxabs(y) < POSITION_LIMIT && maxabs(z) < POSITION_LIMIT

angle_ok = true
if has_attitude
    angle_ok = maxabs(roll) < ANGLE_LIMIT && maxabs(pitch) < ANGLE_LIMIT
end

stable_flag = finite_ok && position_ok && angle_ok

println("\n========== Quantitative Metrics ==========")
println("Model: ", MODEL)
println("Simulation time: ", t[1], " s -> ", t[end], " s")
println("Result variable names:")
println("  xref = ", xref_name, " | x = ", x_name)
println("  yref = ", yref_name, " | y = ", y_name)
println("  zref = ", zref_name, " | z = ", z_name)

print_metric("x tracking error", ex)
print_metric("y tracking error", ey)
print_metric("z tracking error", ez)
println(rpad("3D position error", 24), " RMSE = ", rmse(e_norm),
        " | Max = ", maximum(e_norm),
        " | Final = ", e_norm[end])

println("Final position:  [", x[end], ", ", y[end], ", ", z[end], "]")
println("Final reference: [", xref[end], ", ", yref[end], ", ", zref[end], "]")

if has_attitude
    println("Final attitude rad: [", roll[end], ", ", pitch[end], ", ", yaw[end], "]")
end

if stable_flag
    println("Stability flag: STABLE under current thresholds.")
else
    println("Stability flag: UNSTABLE or abnormal under current thresholds.")
    println("  finite_ok   = ", finite_ok)
    println("  position_ok = ", position_ok, "  threshold = ", POSITION_LIMIT, " m")
    println("  angle_ok    = ", angle_ok, "  threshold = ", ANGLE_LIMIT, " rad")
end

metrics_file = RESULT_PREFIX * "_metrics.csv"
metric_rows = [
    ("x_tracking_error", rmse(ex), maxabs(ex), ex[end]),
    ("y_tracking_error", rmse(ey), maxabs(ey), ey[end]),
    ("z_tracking_error", rmse(ez), maxabs(ez), ez[end]),
    ("position_error_norm", rmse(e_norm), maximum(e_norm), e_norm[end]),
]
write_metrics_csv(metrics_file, metric_rows)
println("Metrics saved to ", metrics_file)

timeseries_names = ["xref", "x", "yref", "y", "zref", "z", "ex", "ey", "ez", "e_norm"]
timeseries_data = [xref, x, yref, y, zref, z, ex, ey, ez, e_norm]

if has_attitude
    append!(timeseries_names, ["roll", "pitch", "yaw"])
    append!(timeseries_data, [roll, pitch, yaw])
end

if has_command
    append!(timeseries_names, ["u1", "u2", "u3", "u4"])
    append!(timeseries_data, [u1, u2, u3, u4])
end

if has_rotor_speed
    append!(timeseries_names, ["w1", "w2", "w3", "w4"])
    append!(timeseries_data, [w1, w2, w3, w4])
end

append!(timeseries_names, extra_names)
append!(timeseries_data, extra_data)

timeseries_file = RESULT_PREFIX * "_timeseries.csv"
write_timeseries_csv(timeseries_file, t, timeseries_names, timeseries_data)
println("Time series saved to ", timeseries_file)


# ========== 6. 可视化分析 ==========

figure()
plot(t, xref)
hold("on")
plot(t, x)
plot(t, yref)
plot(t, y)
plot(t, zref)
plot(t, z)
grid("on")
xlabel("Time / s")
ylabel("Position / m")
legend(["x_ref", "x", "y_ref", "y", "z_ref", "z"])
title("Position Tracking: " * MODEL)

figure()
plot(t, ex)
hold("on")
plot(t, ey)
plot(t, ez)
grid("on")
xlabel("Time / s")
ylabel("Tracking Error / m")
legend(["e_x", "e_y", "e_z"])
title("Position Tracking Errors")

figure()
plot(t, e_norm)
grid("on")
xlabel("Time / s")
ylabel("Position Error Norm / m")
title("3D Position Error Norm")

if has_attitude
    figure()
    plot(t, roll)
    hold("on")
    plot(t, pitch)
    plot(t, yaw)
    grid("on")
    xlabel("Time / s")
    ylabel("Angle / rad")
    legend(["roll", "pitch", "yaw"])
    title("Attitude Angles")
end

if has_command
    figure()
    plot(t, u1)
    hold("on")
    plot(t, u2)
    plot(t, u3)
    plot(t, u4)
    grid("on")
    xlabel("Time / s")
    ylabel("Motor Command")
    legend(["u1", "u2", "u3", "u4"])
    title("Controller Outputs")
end

if has_rotor_speed
    figure()
    plot(t, w1)
    hold("on")
    plot(t, w2)
    plot(t, w3)
    plot(t, w4)
    grid("on")
    xlabel("Time / s")
    ylabel("Rotor Speed / rad/s")
    legend(["w1", "w2", "w3", "w4"])
    title("Rotor Speeds")
end

if length(extra_data) > 0
    figure()
    for i in 1:length(extra_data)
        if i == 1
            plot(t, extra_data[i])
            hold("on")
        else
            plot(t, extra_data[i])
        end
    end
    grid("on")
    xlabel("Time / s")
    ylabel("Extra Variables")
    legend(extra_names)
    title("Extra Variables")
end

println("\nDone.")
