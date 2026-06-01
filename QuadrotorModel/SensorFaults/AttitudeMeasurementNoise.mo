within QuadrotorModel.SensorFaults;
model AttitudeMeasurementNoise "姿态测量噪声"
  parameter Real amplitude = 0.01 "姿态角噪声幅值";
  parameter Modelica.Units.SI.Time startTime = 5 "噪声开始时间";
  Modelica.Blocks.Interfaces.RealInput cleanAngle[3] "无噪声姿态测量"
    annotation (Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput noisyAngle[3] "带噪声姿态测量"
    annotation (Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

equation
  noisyAngle[1] = cleanAngle[1] + (if time < startTime then 0 else amplitude * (0.6 * sin(23.0 * time) + 0.4 * sin(49.0 * time + 0.2)));
  noisyAngle[2] = cleanAngle[2] + (if time < startTime then 0 else amplitude * (0.5 * sin(29.0 * time + 0.5) + 0.5 * sin(41.0 * time)));
  noisyAngle[3] = cleanAngle[3] + (if time < startTime then 0 else amplitude * (0.4 * sin(11.0 * time) + 0.6 * sin(35.0 * time + 1.4)));

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {2, 2}),
      graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}},
        radius = 25), Text(extent = {{-74, 58}, {74, 8}}, textString = "Att Noise")}));
end AttitudeMeasurementNoise;
