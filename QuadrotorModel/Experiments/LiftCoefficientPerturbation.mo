within QuadrotorModel.Experiments;
model LiftCoefficientPerturbation "电机升力系数摄动实验"
  parameter Real liftCoefficientScale = 0.85 "升力系数摄动比例";
  extends StepResponseZ(
    quadChassisTest17_1(lift_cofficient = 0.002 * liftCoefficientScale));
end LiftCoefficientPerturbation;