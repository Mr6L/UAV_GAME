within QuadrotorModel.Experiments;
model FormationWindDisturbance "外部扰动下的四机编队保持"
  extends Modelica.Icons.Example;

  QuadrotorModel.PathPlanning.CircularTrajectory leaderPath(
    radius = 3,
    frequency = 0.02,
    altitude = 5,
    climbDuration = 5,
    startTime = 10)
    annotation (Placement(transformation(origin = {-150, 52}, extent = {{-12, -12}, {12, 12}})));
  QuadrotorModel.Formations.FormationOffsets offsets(
    n = 4,
    formationType = 2,
    spacing = 2)
    annotation (Placement(transformation(origin = {-150, 8}, extent = {{-12, -12}, {12, 12}})));
  QuadrotorModel.Formations.LeaderFollowerCommand command(n = 4)
    annotation (Placement(transformation(origin = {-88, 28}, extent = {{-12, -12}, {12, 12}})));
  QuadrotorModel.Disturbances.SustainedLateralWind wind(
    lateralForce = 0.02,
    startTime = 35)
    annotation (Placement(transformation(origin = {-150, -48}, extent = {{-12, -12}, {12, 12}})));

  QuadrotorModel.Formations.QuadrotorAgent drone1(
    initialPosition = {0, 0, 0},
    showSceneReferences = true)
    annotation (Placement(transformation(origin = {34, 72}, extent = {{-16, -16}, {16, 16}})));
  QuadrotorModel.Formations.QuadrotorAgent drone2(initialPosition = {-2, -2, 0})
    annotation (Placement(transformation(origin = {34, 24}, extent = {{-16, -16}, {16, 16}})));
  QuadrotorModel.Formations.QuadrotorAgent drone3(initialPosition = {-2, 2, 0})
    annotation (Placement(transformation(origin = {34, -24}, extent = {{-16, -16}, {16, 16}})));
  QuadrotorModel.Formations.QuadrotorAgent drone4(initialPosition = {-4, 0, 0})
    annotation (Placement(transformation(origin = {34, -72}, extent = {{-16, -16}, {16, 16}})));

equation
  drone1.yaw_command = 0;
  drone2.yaw_command = 0;
  drone3.yaw_command = 0;
  drone4.yaw_command = 0;
  connect(leaderPath.position_command, command.leader_command) annotation (Line(points = {{-138, 52}, {-116, 52}, {-116, 32}, {-100, 32}}, color = {0, 0, 127}));
  connect(offsets.offsets, command.offsets) annotation (Line(points = {{-138, 8}, {-116, 8}, {-116, 24}, {-100, 24}}, color = {0, 0, 127}));
  connect(command.position_command[1, :], drone1.position_command) annotation (Line(points = {{-76, 28}, {-20, 28}, {-20, 72}, {12, 72}}, color = {0, 0, 127}));
  connect(command.position_command[2, :], drone2.position_command) annotation (Line(points = {{-76, 28}, {-20, 28}, {-20, 24}, {12, 24}}, color = {0, 0, 127}));
  connect(command.position_command[3, :], drone3.position_command) annotation (Line(points = {{-76, 28}, {-20, 28}, {-20, -24}, {12, -24}}, color = {0, 0, 127}));
  connect(command.position_command[4, :], drone4.position_command) annotation (Line(points = {{-76, 28}, {-20, 28}, {-20, -72}, {12, -72}}, color = {0, 0, 127}));
  connect(wind.force, drone1.external_force) annotation (Line(points = {{-138, -48}, {-6, -48}, {-6, 62}, {12, 62}}, color = {0, 0, 127}));
  connect(wind.force, drone2.external_force) annotation (Line(points = {{-138, -48}, {-6, -48}, {-6, 14}, {12, 14}}, color = {0, 0, 127}));
  connect(wind.force, drone3.external_force) annotation (Line(points = {{-138, -48}, {-6, -48}, {-6, -34}, {12, -34}}, color = {0, 0, 127}));
  connect(wind.force, drone4.external_force) annotation (Line(points = {{-138, -48}, {-6, -48}, {-6, -82}, {12, -82}}, color = {0, 0, 127}));

  annotation (
    Diagram(coordinateSystem(extent = {{-190, -110}, {120, 100}}, grid = {2, 2})),
    experiment(Algorithm = Dassl, StartTime = 0, StopTime = 90, Tolerance = 0.0001, Interval = 0.02));
end FormationWindDisturbance;
