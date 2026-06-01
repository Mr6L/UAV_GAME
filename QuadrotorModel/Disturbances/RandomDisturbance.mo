within QuadrotorModel.Disturbances;
model RandomDisturbance "随机扰动"
  parameter Real amplitude = 0.025 "随机扰动幅值";
  parameter Modelica.Units.SI.Time startTime = 12 "扰动开始时间";
  Modelica.Blocks.Interfaces.RealOutput force[3] "外部扰动力" annotation (
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression fx(
    y = if time < startTime then 0 else amplitude * (0.55 * sin(7.1 * time) + 0.30 * sin(13.7 * time + 0.6) + 0.15 * sin(29.3 * time + 1.2)))
    annotation (Placement(transformation(origin = {-34, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression fy(
    y = if time < startTime then 0 else amplitude * (0.50 * sin(5.3 * time + 1.4) + 0.35 * sin(17.9 * time) + 0.15 * sin(31.1 * time + 0.3)))
    annotation (Placement(transformation(origin = {-34, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant fz(k = 0)
    annotation (Placement(transformation(origin = {-34, -40}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(fx.y, force[1]) annotation (Line(points = {{-23, 40}, {70, 40}, {70, 0}, {110, 0}},
    color = {0, 0, 127}));
  connect(fy.y, force[2]) annotation (Line(points = {{-23, 0}, {110, 0}},
    color = {0, 0, 127}));
  connect(fz.y, force[3]) annotation (Line(points = {{-23, -40}, {70, -40}, {70, 0}, {110, 0}},
    color = {0, 0, 127}));

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {2, 2}),
      graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}},
        radius = 25), Line(points = {{-70, 0}, {-46, 26}, {-22, -18}, {0, 18}, {24, -26}, {48, 24}, {70, 0}},
        color = {80, 80, 180}, thickness = 1, smooth = Smooth.Bezier)}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {2, 2})));
end RandomDisturbance;
