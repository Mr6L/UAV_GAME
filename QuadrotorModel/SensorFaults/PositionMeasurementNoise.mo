within QuadrotorModel.SensorFaults;
model PositionMeasurementNoise "位置测量噪声"
  parameter Real amplitude = 0.03 "位置噪声幅值";
  parameter Modelica.Units.SI.Time startTime = 5 "噪声开始时间";
  Modelica.Blocks.Interfaces.RealInput cleanPosition[3] "无噪声位置测量" 
    annotation (Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput noisyPosition[3] "带噪声位置测量" 
    annotation (Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

equation
  noisyPosition[1] = cleanPosition[1] + (if time < startTime then 0 else amplitude * (0.6 * sin(17.0 * time) + 0.4 * sin(43.0 * time + 0.3)));
  noisyPosition[2] = cleanPosition[2] + (if time < startTime then 0 else amplitude * (0.5 * sin(19.0 * time + 0.7) + 0.5 * sin(37.0 * time)));
  noisyPosition[3] = cleanPosition[3] + (if time < startTime then 0 else amplitude * (0.4 * sin(13.0 * time) + 0.6 * sin(31.0 * time + 1.1)));

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {2, 2}),
      graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}},
        radius = 25), Text(extent = {{-70, 58}, {70, 8}}, textString = "Pos Noise")}),__MWORKS(version="26.2.1"));
end PositionMeasurementNoise;