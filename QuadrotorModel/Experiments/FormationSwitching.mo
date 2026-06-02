within QuadrotorModel.Experiments;
model FormationSwitching "横队、菱形和V字队形平滑切换"
  extends Modelica.Icons.Example;

  parameter Integer n = 5;
  parameter Real lineOffsets[5, 3] = [0, 0, 0; -2, -2.2, 0; -2, -0.8, 0; -2, 0.8, 0; -2, 2.2, 0];
  parameter Real diamondOffsets[5, 3] = [0, 0, 0; -2, -2, 0; -2, 0, 0; -4, 0, 0; -2, 2, 0];
  parameter Real vOffsets[5, 3] = [0, 0, 0; -2, -1.5, 0; -2, 1.5, 0; -4, -3, 0; -4, 3, 0];
  parameter Modelica.Units.SI.Time secondSwitchTime = 50;

  QuadrotorModel.PathPlanning.STrajectory leaderPath(
    forwardSpeed = 0.25,
    amplitude = 2.5,
    frequency = 0.02,
    altitude = 5,
    climbDuration = 5,
    startTime = 10)
    annotation (Placement(transformation(origin = {-150, 52}, extent = {{-12, -12}, {12, 12}})));
  QuadrotorModel.Formations.StagedFormationSwitch stagedSwitch(
    n = n,
    fromOffsets = lineOffsets,
    middleOffsets = diamondOffsets,
    toOffsets = vOffsets,
    firstStartTime = 20,
    firstDuration = 10,
    secondStartTime = secondSwitchTime,
    secondDuration = 10)
    annotation (Placement(transformation(origin = {-150, -18}, extent = {{-12, -12}, {12, 12}})));
  QuadrotorModel.Formations.LeaderFollowerCommand command(n = n)
    annotation (Placement(transformation(origin = {-82, 8}, extent = {{-12, -12}, {12, 12}})));

  QuadrotorModel.Formations.QuadrotorAgent drone1(
    initialPosition = {0, 0, 0},
    showSceneReferences = true)
    annotation (Placement(transformation(origin = {34, 84}, extent = {{-14, -14}, {14, 14}})));
  QuadrotorModel.Formations.QuadrotorAgent drone2(initialPosition = {-2, -2.2, 0})
    annotation (Placement(transformation(origin = {34, 42}, extent = {{-14, -14}, {14, 14}})));
  QuadrotorModel.Formations.QuadrotorAgent drone3(initialPosition = {-2, -0.8, 0})
    annotation (Placement(transformation(origin = {34, 0}, extent = {{-14, -14}, {14, 14}})));
  QuadrotorModel.Formations.QuadrotorAgent drone4(initialPosition = {-2, 0.8, 0})
    annotation (Placement(transformation(origin = {34, -42}, extent = {{-14, -14}, {14, 14}})));
  QuadrotorModel.Formations.QuadrotorAgent drone5(initialPosition = {-2, 2.2, 0})
    annotation (Placement(transformation(origin = {34, -84}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Sources.Constant zeroForce[3](each k = 0)
    annotation (Placement(transformation(origin = {-24, -104}, extent = {{-8, -8}, {8, 8}})));

equation
  drone1.yaw_command = 0;
  drone2.yaw_command = 0;
  drone3.yaw_command = 0;
  drone4.yaw_command = 0;
  drone5.yaw_command = 0;
  connect(leaderPath.position_command, command.leader_command) annotation (Line(points = {{-138, 52}, {-112, 52}, {-112, 12}, {-94, 12}}, color = {0, 0, 127}));
  connect(stagedSwitch.offsets, command.offsets) annotation (Line(points = {{-138, -18}, {-112, -18}, {-112, 4}, {-94, 4}}, color = {0, 0, 127}));
  connect(command.position_command[1, :], drone1.position_command) annotation (Line(points = {{-70, 8}, {-22, 8}, {-22, 84}, {14, 84}}, color = {0, 0, 127}));
  connect(command.position_command[2, :], drone2.position_command) annotation (Line(points = {{-70, 8}, {-22, 8}, {-22, 42}, {14, 42}}, color = {0, 0, 127}));
  connect(command.position_command[3, :], drone3.position_command) annotation (Line(points = {{-70, 8}, {-22, 8}, {-22, 0}, {14, 0}}, color = {0, 0, 127}));
  connect(command.position_command[4, :], drone4.position_command) annotation (Line(points = {{-70, 8}, {-22, 8}, {-22, -42}, {14, -42}}, color = {0, 0, 127}));
  connect(command.position_command[5, :], drone5.position_command) annotation (Line(points = {{-70, 8}, {-22, 8}, {-22, -84}, {14, -84}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone1.external_force) annotation (Line(points = {{-15, -104}, {-6, -104}, {-6, 76}, {14, 76}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone2.external_force) annotation (Line(points = {{-15, -104}, {-6, -104}, {-6, 34}, {14, 34}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone3.external_force) annotation (Line(points = {{-15, -104}, {-6, -104}, {-6, -8}, {14, -8}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone4.external_force) annotation (Line(points = {{-15, -104}, {-6, -104}, {-6, -50}, {14, -50}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone5.external_force) annotation (Line(points = {{-15, -104}, {-6, -104}, {-6, -92}, {14, -92}}, color = {0, 0, 127}));

  annotation (
    Diagram(coordinateSystem(extent = {{-190, -120}, {120, 110}}, grid = {2, 2})),
    experiment(Algorithm = Dassl, StartTime = 0, StopTime = 90, Tolerance = 0.0001, Interval = 0.02));
end FormationSwitching;
