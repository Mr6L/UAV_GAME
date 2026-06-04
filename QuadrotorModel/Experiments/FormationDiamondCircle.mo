within QuadrotorModel.Experiments;
model FormationDiamondCircle "四机菱形队形跟踪圆形轨迹"
  extends Modelica.Icons.Example;

  QuadrotorModel.PathPlanning.CircularTrajectory leaderPath(
    radius = 4,
    frequency = 0.02,
    altitude = 5,
    climbDuration = 5,
    startTime = 10) 
    annotation (Placement(transformation(origin = {-140, 44}, extent = {{-12, -12}, {12, 12}})));
  QuadrotorModel.Formations.FormationOffsets offsets(
    n = 4,
    formationType = 2,
    spacing = 2) 
    annotation (Placement(transformation(origin = {-140, -18}, extent = {{-12, -12}, {12, 12}})));
  QuadrotorModel.Formations.LeaderFollowerCommand command(n = 4) 
    annotation (Placement(transformation(origin = {-80, 12}, extent = {{-12, -12}, {12, 12}})));

  QuadrotorModel.Formations.QuadrotorAgent drone1(
    initialPosition = {2, 0, 0},
    showSceneReferences = true) 
    annotation (Placement(transformation(origin = {30, 72}, extent = {{-16, -16}, {16, 16}})));
  QuadrotorModel.Formations.QuadrotorAgent drone2(initialPosition = {0, -2, 0}) 
    annotation (Placement(transformation(origin = {30, 24}, extent = {{-16, -16}, {16, 16}})));
  QuadrotorModel.Formations.QuadrotorAgent drone3(initialPosition = {0, 2, 0}) 
    annotation (Placement(transformation(origin = {30, -24}, extent = {{-16, -16}, {16, 16}})));
  QuadrotorModel.Formations.QuadrotorAgent drone4(initialPosition = {-2, 0, 0}) 
    annotation (Placement(transformation(origin = {30, -72}, extent = {{-16, -16}, {16, 16}})));
  Modelica.Blocks.Sources.Constant zeroForce[3](each k = 0) 
    annotation (Placement(transformation(origin = {-24, -98}, extent = {{-8, -8}, {8, 8}})));

equation
  drone1.yaw_command = 0;
  drone2.yaw_command = 0;
  drone3.yaw_command = 0;
  drone4.yaw_command = 0;
  connect(leaderPath.position_command, command.leader_command) annotation (Line(points = {{-128, 44}, {-110, 44}, {-110, 16}, {-92, 16}}, color = {0, 0, 127}));
  connect(offsets.offsets, command.offsets) annotation (Line(points = {{-128, -18}, {-110, -18}, {-110, 8}, {-92, 8}}, color = {0, 0, 127}));
  connect(command.position_command[1, :], drone1.position_command) annotation (Line(points = {{-68, 12}, {-20, 12}, {-20, 72}, {10, 72}}, color = {0, 0, 127}));
  connect(command.position_command[2, :], drone2.position_command) annotation (Line(points = {{-68, 12}, {-20, 12}, {-20, 24}, {10, 24}}, color = {0, 0, 127}));
  connect(command.position_command[3, :], drone3.position_command) annotation (Line(points = {{-68, 12}, {-20, 12}, {-20, -24}, {10, -24}}, color = {0, 0, 127}));
  connect(command.position_command[4, :], drone4.position_command) annotation (Line(points = {{-68, 12}, {-20, 12}, {-20, -72}, {10, -72}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone1.external_force) annotation (Line(points = {{-15, -98}, {-6, -98}, {-6, 62}, {10, 62}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone2.external_force) annotation (Line(points = {{-15, -98}, {-6, -98}, {-6, 14}, {10, 14}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone3.external_force) annotation (Line(points = {{-15, -98}, {-6, -98}, {-6, -34}, {10, -34}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone4.external_force) annotation (Line(points = {{-15, -98}, {-6, -98}, {-6, -82}, {10, -82}}, color = {0, 0, 127}));

  annotation (
    Diagram(coordinateSystem(extent = {{-180, -110}, {120, 100}}, grid = {2, 2})),
    experiment(Algorithm = Dassl, StartTime = 0, StopTime = 100, Tolerance = 0.0001, Interval = 0.02),__MWORKS(version="26.2.1"));
end FormationDiamondCircle;