within QuadrotorModel.Blocks.Controller.Interfaces;
partial model PartialController "Unified quadrotor controller interface"
  Modelica.Blocks.Interfaces.RealInput position_command[3] "Position command x/y/z"
    annotation (Placement(transformation(origin = {-120, 60}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput yaw_command "Yaw command"
    annotation (Placement(transformation(origin = {-120, 28}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {-110, 28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput position[3] "Measured position x/y/z"
    annotation (Placement(transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput angle[3] "Measured attitude roll/pitch/yaw"
    annotation (Placement(transformation(origin = {-120, -60}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput y "Motor 1 command"
    annotation (Placement(transformation(origin = {120, 60}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput y1 "Motor 2 command"
    annotation (Placement(transformation(origin = {120, 20}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput y2 "Motor 3 command"
    annotation (Placement(transformation(origin = {120, -20}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput y3 "Motor 4 command"
    annotation (Placement(transformation(origin = {120, -60}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {Rectangle(extent = {{-100, 100}, {100, -100}},
        lineColor = {120, 120, 120}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.Solid), Text(extent = {{-86, 22}, {86, -22}},
        textString = "Controller")}),
    Diagram(coordinateSystem(extent = {{-140, -90}, {140, 90}}, grid = {2, 2})));
end PartialController;
