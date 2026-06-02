within QuadrotorModel.Blocks.Controller;
model BaselinePIDController "Baseline PID controller using the unified interface"
  extends QuadrotorModel.Blocks.Controller.Interfaces.PartialController;

  parameter Real yawKP = 5 "Yaw loop proportional gain for the baseline PID";

  QuadrotorModel.Blocks.Controller.Controller controller(PID1(KP = yawKP))
    annotation (Placement(transformation(origin = {0, 0}, extent = {{-24, -24}, {24, 24}})));

equation
  connect(position_command, controller.position_command)
    annotation (Line(points = {{-120, 60}, {-56, 60}, {-56, 14}, {-26, 14}}, color = {0, 0, 127}));
  connect(yaw_command, controller.yaw_command)
    annotation (Line(points = {{-120, 28}, {-50, 28}, {-50, 7}, {-26, 7}}, color = {0, 0, 127}));
  connect(position, controller.position)
    annotation (Line(points = {{-120, 0}, {-40, 0}, {-40, 0}, {-26, 0}}, color = {0, 0, 127}));
  connect(angle, controller.angle)
    annotation (Line(points = {{-120, -60}, {-56, -60}, {-56, -14}, {-26, -14}}, color = {0, 0, 127}));
  connect(controller.y, y)
    annotation (Line(points = {{26, 14}, {58, 14}, {58, 60}, {120, 60}}, color = {0, 0, 127}));
  connect(controller.y1, y1)
    annotation (Line(points = {{26, 5}, {120, 5}, {120, 20}}, color = {0, 0, 127}));
  connect(controller.y2, y2)
    annotation (Line(points = {{26, -5}, {120, -5}, {120, -20}}, color = {0, 0, 127}));
  connect(controller.y3, y3)
    annotation (Line(points = {{26, -14}, {58, -14}, {58, -60}, {120, -60}}, color = {0, 0, 127}));

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {Rectangle(extent = {{-100, 100}, {100, -100}},
        lineColor = {120, 120, 120}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.Solid), Text(extent = {{-88, 24}, {88, -24}},
        textString = "Baseline PID")}),
    Diagram(coordinateSystem(extent = {{-140, -90}, {140, 90}}, grid = {2, 2})));
end BaselinePIDController;
