within QuadrotorModel.Experiments;
model FormationVShapeSpiral "五机V字队形螺旋爬升"
  extends Modelica.Icons.Example;

  QuadrotorModel.PathPlanning.CirclePath leaderPath(
    ramp(duration = 80, height = 8),
    sine(f = 0.025, amplitude = 3, startTime = 10),
    cosine(f = 0.025, amplitude = 3, startTime = 10))
    annotation (Placement(transformation(origin = {-140, 46}, extent = {{-12, -12}, {12, 12}})));
  QuadrotorModel.Formations.FormationOffsets offsets(
    n = 5,
    formationType = 3,
    spacing = 2)
    annotation (Placement(transformation(origin = {-140, -18}, extent = {{-12, -12}, {12, 12}})));
  QuadrotorModel.Formations.LeaderFollowerCommand command(n = 5)
    annotation (Placement(transformation(origin = {-80, 14}, extent = {{-12, -12}, {12, 12}})));

  QuadrotorModel.Formations.QuadrotorAgent drone1(
    initialPosition = {0, 0, 0},
    showSceneReferences = true)
    annotation (Placement(transformation(origin = {34, 84}, extent = {{-14, -14}, {14, 14}})));
  QuadrotorModel.Formations.QuadrotorAgent drone2(initialPosition = {-2, -1.5, 0})
    annotation (Placement(transformation(origin = {34, 42}, extent = {{-14, -14}, {14, 14}})));
  QuadrotorModel.Formations.QuadrotorAgent drone3(initialPosition = {-2, 1.5, 0})
    annotation (Placement(transformation(origin = {34, 0}, extent = {{-14, -14}, {14, 14}})));
  QuadrotorModel.Formations.QuadrotorAgent drone4(initialPosition = {-4, -3, 0})
    annotation (Placement(transformation(origin = {34, -42}, extent = {{-14, -14}, {14, 14}})));
  QuadrotorModel.Formations.QuadrotorAgent drone5(initialPosition = {-4, 3, 0})
    annotation (Placement(transformation(origin = {34, -84}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Sources.Constant zeroForce[3](each k = 0)
    annotation (Placement(transformation(origin = {-24, -104}, extent = {{-8, -8}, {8, 8}})));

equation
  drone1.yaw_command = 0;
  drone2.yaw_command = 0;
  drone3.yaw_command = 0;
  drone4.yaw_command = 0;
  drone5.yaw_command = 0;
  connect(leaderPath.position_command, command.leader_command) annotation (Line(points = {{-128, 46}, {-110, 46}, {-110, 18}, {-92, 18}}, color = {0, 0, 127}));
  connect(offsets.offsets, command.offsets) annotation (Line(points = {{-128, -18}, {-110, -18}, {-110, 10}, {-92, 10}}, color = {0, 0, 127}));
  connect(command.position_command[1, :], drone1.position_command) annotation (Line(points = {{-68, 14}, {-20, 14}, {-20, 84}, {14, 84}}, color = {0, 0, 127}));
  connect(command.position_command[2, :], drone2.position_command) annotation (Line(points = {{-68, 14}, {-20, 14}, {-20, 42}, {14, 42}}, color = {0, 0, 127}));
  connect(command.position_command[3, :], drone3.position_command) annotation (Line(points = {{-68, 14}, {-20, 14}, {-20, 0}, {14, 0}}, color = {0, 0, 127}));
  connect(command.position_command[4, :], drone4.position_command) annotation (Line(points = {{-68, 14}, {-20, 14}, {-20, -42}, {14, -42}}, color = {0, 0, 127}));
  connect(command.position_command[5, :], drone5.position_command) annotation (Line(points = {{-68, 14}, {-20, 14}, {-20, -84}, {14, -84}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone1.external_force) annotation (Line(points = {{-15, -104}, {-6, -104}, {-6, 76}, {14, 76}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone2.external_force) annotation (Line(points = {{-15, -104}, {-6, -104}, {-6, 34}, {14, 34}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone3.external_force) annotation (Line(points = {{-15, -104}, {-6, -104}, {-6, -8}, {14, -8}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone4.external_force) annotation (Line(points = {{-15, -104}, {-6, -104}, {-6, -50}, {14, -50}}, color = {0, 0, 127}));
  connect(zeroForce.y, drone5.external_force) annotation (Line(points = {{-15, -104}, {-6, -104}, {-6, -92}, {14, -92}}, color = {0, 0, 127}));

  annotation (
    Diagram(coordinateSystem(extent = {{-180, -120}, {120, 110}}, grid = {2, 2})),
    experiment(Algorithm = Dassl, StartTime = 0, StopTime = 100, Tolerance = 0.0001, Interval = 0.02));
end FormationVShapeSpiral;
