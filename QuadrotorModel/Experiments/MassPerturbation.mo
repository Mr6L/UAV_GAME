within QuadrotorModel.Experiments;
model MassPerturbation "无人机质量摄动实验"
  parameter Real massScale = 1.25 "机体质量摄动比例";
  extends StepResponseZ(
    quadChassisTest17_1(body(m = 0.159504 * massScale)));
end MassPerturbation;