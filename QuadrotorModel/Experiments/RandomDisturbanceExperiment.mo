within QuadrotorModel.Experiments;
model RandomDisturbanceExperiment "随机扰动实验"
  extends StepResponseZ;

  QuadrotorModel.Disturbances.RandomDisturbance disturbance(
    amplitude = 0.025,
    startTime = 12)
    annotation (Placement(transformation(origin = {-150, -82}, extent = {{-16, -16}, {16, 16}})));
  Modelica.Mechanics.MultiBody.Forces.WorldForce disturbanceForce(
    resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameB.frame_b,
    animation = false)
    annotation (Placement(transformation(origin = {58, -86}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(disturbance.force, disturbanceForce.force)
    annotation (Line(points = {{-132, -82}, {20, -82}, {20, -86}, {46, -86}},
      color = {0, 0, 127}, thickness = 0.8));
  connect(disturbanceForce.frame_b, quadChassisTest17_1.frame_a)
    annotation (Line(points = {{68, -86}, {150, -86}, {150, 8.5}, {120, 8.5}},
      color = {95, 95, 95}, thickness = 0.8));
end RandomDisturbanceExperiment;
