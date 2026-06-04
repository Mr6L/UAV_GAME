within QuadrotorModel.Blocks.Controller;
model ActiveController "Current controller selected for all scenarios"
  extends QuadrotorModel.Blocks.Controller.Interfaces.PartialController;

  parameter Real baselineYawKP = 5 "Legacy scenario yaw gain mapped to the enhanced yaw loop";
  parameter Real hoverMass = 0.159504 + 4 * 0.000913171 "Effective vehicle mass used by the enhanced controller hover feedforward";
  parameter Real gravity = 9.81 "Gravity used by the enhanced controller hover feedforward";
  parameter Real liftCoefficient = 0.002 "Rotor lift coefficient used by the enhanced controller hover feedforward";
  parameter Real hoverFeedforwardScale = 1 "Scale factor for parameter-based hover feedforward";

  QuadrotorModel.Blocks.Controller.EnhancedPIDController core(
    yawKP = baselineYawKP,
    hoverMass = hoverMass,
    gravity = gravity,
    liftCoefficient = liftCoefficient,
    hoverFeedforwardScale = hoverFeedforwardScale)
    annotation (Placement(transformation(origin = {0, 0}, extent = {{-24, -24}, {24, 24}})), __MWORKS(SECInstance = true));

equation
  connect(position_command[1], core.positionCommandX)
    annotation (Line(points = {{-120, 60}, {-66, 60}, {-66, 18}, {-26, 18}}, color = {0, 0, 127}));
  connect(position_command[2], core.positionCommandY)
    annotation (Line(points = {{-120, 60}, {-70, 60}, {-70, 14}, {-26, 14}}, color = {0, 0, 127}));
  connect(position_command[3], core.positionCommandZ)
    annotation (Line(points = {{-120, 60}, {-74, 60}, {-74, 10}, {-26, 10}}, color = {0, 0, 127}));
  connect(yaw_command, core.yawCommand)
    annotation (Line(points = {{-120, 28}, {-52, 28}, {-52, 6}, {-26, 6}}, color = {0, 0, 127}));
  connect(position[1], core.positionX)
    annotation (Line(points = {{-120, 0}, {-54, 0}, {-54, 2}, {-26, 2}}, color = {0, 0, 127}));
  connect(position[2], core.positionY)
    annotation (Line(points = {{-120, 0}, {-54, 0}, {-54, -2}, {-26, -2}}, color = {0, 0, 127}));
  connect(position[3], core.positionZ)
    annotation (Line(points = {{-120, 0}, {-58, 0}, {-58, -6}, {-26, -6}}, color = {0, 0, 127}));
  connect(angle[1], core.rollAngle)
    annotation (Line(points = {{-120, -60}, {-66, -60}, {-66, -10}, {-26, -10}}, color = {0, 0, 127}));
  connect(angle[2], core.pitchAngle)
    annotation (Line(points = {{-120, -60}, {-70, -60}, {-70, -14}, {-26, -14}}, color = {0, 0, 127}));
  connect(angle[3], core.yawAngle)
    annotation (Line(points = {{-120, -60}, {-74, -60}, {-74, -18}, {-26, -18}}, color = {0, 0, 127}));
  connect(core.y, y)
    annotation (Line(points = {{26, 14}, {58, 14}, {58, 60}, {120, 60}}, color = {0, 0, 127}));
  connect(core.y1, y1)
    annotation (Line(points = {{26, 5}, {120, 5}, {120, 20}}, color = {0, 0, 127}));
  connect(core.y2, y2)
    annotation (Line(points = {{26, -5}, {120, -5}, {120, -20}}, color = {0, 0, 127}));
  connect(core.y3, y3)
    annotation (Line(points = {{26, -14}, {58, -14}, {58, -60}, {120, -60}}, color = {0, 0, 127}));

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {Rectangle(extent = {{-100, 100}, {100, -100}},
        lineColor = {80, 120, 160}, fillColor = {245, 250, 255},
        fillPattern = FillPattern.Solid), Text(extent = {{-88, 24}, {88, -24}},
        textString = "Enhanced PID")}),
    Diagram(coordinateSystem(extent = {{-140, -90}, {140, 90}}, grid = {2, 2})),
    Documentation(info = "<html><p>ActiveController keeps the legacy array interface and delegates to the Sysblock EnhancedPIDController core through an SECInstance.</p></html>"));
end ActiveController;
