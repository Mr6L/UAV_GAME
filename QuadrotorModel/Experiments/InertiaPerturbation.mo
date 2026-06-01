within QuadrotorModel.Experiments;
model InertiaPerturbation "转动惯量摄动实验"
  parameter Real inertiaScale = 1.5 "机体转动惯量摄动比例";
  extends StepResponseX(
    quadChassisTest17_1(body(
      I_11 = 0.00010556 * inertiaScale,
      I_22 = 0.00010556 * inertiaScale,
      I_33 = 0.00010556 * inertiaScale)));
end InertiaPerturbation;