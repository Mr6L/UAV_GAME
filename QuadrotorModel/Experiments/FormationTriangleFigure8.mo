within QuadrotorModel.Experiments;
model FormationTriangleFigure8 "三机三角队形跟踪8字轨迹"
  extends Modelica.Icons.Example;

  QuadrotorModel.PathPlanning.EightPath leaderPath(
    XAMP = 4,
    YAMP = 4,
    XOmega = 0.025,
    YOmega = 0.05)
    annotation (Placement(transformation(origin = {-140, 40}, extent = {{-12, -12}, {12, 12}})));
  QuadrotorModel.Formations.FormationOffsets offsets(
    n = 3,
    formationType = 1,
    spacing = 2)
    annotation (Placement(transformation(origin = {-140, -20}, extent = {{-12, -12}, {12, 12}})));
  QuadrotorModel.Formations.LeaderFollowerCommand command(n = 3)
    annotation (Placement(transformation(origin = {-80, 10}, extent = {{-12, -12}, {12, 12}})));

  QuadrotorModel.Formations.QuadrotorAgent drone1(
    initialPosition = {0, 0, 0},
    showSceneReferences = true)
    annotation (Placement(transformation(origin = {30, 58}, extent = {{-18, -18}, {18, 18}})));
  QuadrotorModel.Formations.QuadrotorAgent drone2(initialPosition = {-2, -2, 0})
    annotation (Placement(transformation(origin = {30, 0}, extent = {{-18, -18}, {18, 18}})));
  QuadrotorModel.Formations.QuadrotorAgent drone3(initialPosition = {-2, 2, 0})
    annotation (Placement(transformation(origin = {30, -58}, extent = {{-18, -18}, {18, 18}})));
  Modelica.Blocks.Sources.Constant zeroForce[3](each k = 0)
    annotation (Placement(transformation(origin = {-24, -92}, extent = {{-8, -8}, {8, 8}})));

equation
  drone1.yaw_command = 0;
  drone2.yaw_command = 0;
  drone3.yaw_command = 0;
  connect(leaderPath.position_command, command.leader_command) annotation (Line(points = {{-128, 40}, {-110, 40}, {-110, 14}, {-92, 14}}, color = {0, 0, 127}));
  connect(offsets.offsets, command.offsets) annotation (Line(points = {{-128, -20}, {-110, -20}, {-110, 6}, {-92, 6}}, color = {0, 0, 127}));
  connect(command.position_command[1, :], drone1.position_command) annotation (Line(points = {{-68, 10}, {-20, 10}, {-20, 58}, {8, 58}}, color = {0, 0, 127}));
  connect(command.position_command[2, :], drone2.position_command) annotation (Line(points = {{-68, 10}, {-20, 10}, {-20, 0}, {8, 0}}, color = {0, 0, 127}));
  connect(command.position_command[3, :], drone3.position_command) annotation (Line(points = {{-68, 10}, {-20, 10}, {-20, -58}, {8, -58}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone1.external_force) annotation (Line(points = {{-15, -92}, {-6, -92}, {-6, 48}, {8, 48}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone2.external_force) annotation (Line(points = {{-15, -92}, {-6, -92}, {-6, -10}, {8, -10}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone3.external_force) annotation (Line(points = {{-15, -92}, {-6, -92}, {-6, -68}, {8, -68}}, color = {0, 0, 127}));

  annotation (
    Diagram(coordinateSystem(extent = {{-180, -110}, {120, 100}}, grid = {2, 2})),
    experiment(Algorithm = Dassl, StartTime = 0, StopTime = 120, Tolerance = 0.0001, Interval = 0.02));
end FormationTriangleFigure8;
