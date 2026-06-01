within QuadrotorModel.SensorFaults;
model MeasurementDelay "测量信号延迟"
  parameter Modelica.Units.SI.Time delayTime = 0.08 "测量延迟时间";
  Modelica.Blocks.Interfaces.RealInput cleanPosition[3] "无延迟位置测量"
    annotation (Placement(transformation(origin = {-110, 42}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {-110, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput cleanAngle[3] "无延迟姿态测量"
    annotation (Placement(transformation(origin = {-110, -42}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {-110, -42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput delayedPosition[3] "延迟后位置测量"
    annotation (Placement(transformation(origin = {110, 42}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput delayedAngle[3] "延迟后姿态测量"
    annotation (Placement(transformation(origin = {110, -42}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, -42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.FixedDelay positionDelay[3](each delayTime = delayTime)
    annotation (Placement(transformation(origin = {-2, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.FixedDelay angleDelay[3](each delayTime = delayTime)
    annotation (Placement(transformation(origin = {-2, -42}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(cleanPosition, positionDelay.u)
    annotation (Line(points = {{-110, 42}, {-14, 42}}, color = {0, 0, 127}));
  connect(positionDelay.y, delayedPosition)
    annotation (Line(points = {{9, 42}, {110, 42}}, color = {0, 0, 127}));
  connect(cleanAngle, angleDelay.u)
    annotation (Line(points = {{-110, -42}, {-14, -42}}, color = {0, 0, 127}));
  connect(angleDelay.y, delayedAngle)
    annotation (Line(points = {{9, -42}, {110, -42}}, color = {0, 0, 127}));

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {2, 2}),
      graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}},
        radius = 25), Text(extent = {{-54, 28}, {54, -28}}, textString = "Delay")}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {2, 2})));
end MeasurementDelay;
