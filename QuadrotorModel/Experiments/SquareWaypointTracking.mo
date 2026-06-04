within QuadrotorModel.Experiments;
model SquareWaypointTracking "方形航点轨迹跟踪实验"
  extends Modelica.Icons.Example;

  QuadrotorModel.PathPlanning.SquareWaypointTrajectory trajectory(
    sideLength = 4,
    segmentDuration = 10,
    altitude = 5,
    climbDuration = 5,
    startTime = 10) 
    annotation (Placement(transformation(origin = {-150, 24},
      extent = {{-16, -16}, {16, 16}})));
  QuadrotorModel.Mechanics.QuadChassis quadChassisTest17_1 
    annotation (Placement(transformation(origin = {86, 8.5},
      extent = {{-34, -34}, {34, 34}})));
  QuadrotorModel.Electricals.Actuator actuator1_1 
    annotation (Placement(transformation(origin = {2, 46.5},
      extent = {{-10, -10}, {10, 10}})));
  QuadrotorModel.Electricals.Actuator actuator1_2 
    annotation (Placement(transformation(origin = {2, 22.5},
      extent = {{-10, -10}, {10, 10}})));
  QuadrotorModel.Electricals.Actuator actuator1_3 
    annotation (Placement(transformation(origin = {2, -3.5},
      extent = {{-10, -10}, {10, 10}})));
  QuadrotorModel.Electricals.Actuator actuator1_4 
    annotation (Placement(transformation(origin = {2, -29.5},
      extent = {{-10, -10}, {10, 10}})));
  QuadrotorModel.Sensors.Sensors sensors1_1 
    annotation (Placement(transformation(origin = {2, -64.5},
      extent = {{21, -19}, {-21, 19}})));
  QuadrotorModel.Blocks.Controller.ActiveController controller3_2 
    annotation (Placement(transformation(origin = {-71, 9},
      extent = {{-25, -25}, {25, 25}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor[4] 
    annotation (Placement(transformation(origin = {80, 66},
      extent = {{-10, -10}, {10, 10}})));

equation
  controller3_2.yaw_command = 0;
  connect(trajectory.position_command, controller3_2.position_command) 
    annotation (Line(points = {{-132, 24}, {-99, 24}},
      color = {0, 0, 127}, thickness = 0.8));
  connect(actuator1_1.flange_a, quadChassisTest17_1.flange_a) 
    annotation (Line(points = {{12, 46.5}, {30, 46.5}, {30, 28.5}, {52, 28.5}},
      color = {0, 0, 0}, thickness = 0.8));
  connect(actuator1_2.flange_a, quadChassisTest17_1.flange_a1) 
    annotation (Line(points = {{12, 22.5}, {30, 22.5}, {30, 16.5}, {52, 16.5}},
      color = {0, 0, 0}, thickness = 0.8));
  connect(actuator1_3.flange_a, quadChassisTest17_1.flange_a2) 
    annotation (Line(points = {{12, -3.5}, {30, -3.5}, {30, 2.5}, {52, 2.5}},
      color = {0, 0, 0}, thickness = 0.8));
  connect(actuator1_4.flange_a, quadChassisTest17_1.flange_a3) 
    annotation (Line(points = {{12, -29.5}, {30, -29.5}, {30, -13.5}, {52, -13.5}},
      color = {0, 0, 0}, thickness = 0.8));
  connect(quadChassisTest17_1.frame_a, sensors1_1.frame_a) 
    annotation (Line(points = {{120, 8.5}, {138, 8.5}, {138, -64.5}, {23, -64.5}},
      color = {95, 95, 95}, thickness = 0.8));
  connect(actuator1_1.u, controller3_2.y) 
    annotation (Line(points = {{-10, 46.5}, {-36, 46.5}, {-36, 23.5}, {-43, 23.5}},
      color = {0, 0, 127}, thickness = 0.8));
  connect(actuator1_2.u, controller3_2.y1) 
    annotation (Line(points = {{-10, 22.5}, {-29, 22.5}, {-29, 14.5}, {-43, 14.5}},
      color = {0, 0, 127}, thickness = 0.8));
  connect(actuator1_3.u, controller3_2.y2) 
    annotation (Line(points = {{-10, -3.5}, {-29, -3.5}, {-29, 4.5}, {-43, 4.5}},
      color = {0, 0, 127}, thickness = 0.8));
  connect(actuator1_4.u, controller3_2.y3) 
    annotation (Line(points = {{-10, -29.5}, {-37, -29.5}, {-37, -5.5}, {-43, -5.5}},
      color = {0, 0, 127}, thickness = 0.8));
  connect(sensors1_1.AngleMea, controller3_2.angle) 
    annotation (Line(points = {{-19, -56.9}, {-113, -56.9}, {-113, -6}, {-99, -6}},
      color = {0, 0, 127}, thickness = 0.8));
  connect(sensors1_1.PosMea, controller3_2.position) 
    annotation (Line(points = {{-19, -71.7}, {-126, -71.7}, {-126, 10}, {-99, 10}},
      color = {0, 0, 127}, thickness = 0.8));
  connect(actuator1_1.flange_a, speedSensor[1].flange) 
    annotation (Line(points = {{12, 46.5}, {30, 46.5}, {30, 66}, {70, 66}},
      color = {0, 0, 0}));
  connect(actuator1_2.flange_a, speedSensor[2].flange) 
    annotation (Line(points = {{12, 22.5}, {30, 22.5}, {30, 66}, {70, 66}},
      color = {0, 0, 0}));
  connect(actuator1_3.flange_a, speedSensor[3].flange) 
    annotation (Line(points = {{12, -3.5}, {30, -3.5}, {30, 66}, {70, 66}},
      color = {0, 0, 0}));
  connect(actuator1_4.flange_a, speedSensor[4].flange) 
    annotation (Line(points = {{12, -29.5}, {30, -29.5}, {30, 66}, {70, 66}},
      color = {0, 0, 0}, thickness = 0.8));

  annotation (
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}},
      grid = {2, 2})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}},
      preserveAspectRatio = false,
      grid = {2, 2})),
    experiment(Algorithm = Dassl, StartTime = 0, StopTime = 80,
      Tolerance = 0.0001, Interval = 0.01),__MWORKS(version="26.2.1"));
end SquareWaypointTracking;