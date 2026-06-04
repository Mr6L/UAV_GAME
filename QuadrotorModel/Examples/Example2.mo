within QuadrotorModel.Examples;
    model Example2 "螺旋爬升运动"

      PathPlanning.CirclePath climbePath(ramp(height=20), sine(f=0.05), cosine(f=0.05, startTime=10, phase=0)) 
        annotation (Placement(transformation(origin = {-159.00000000000003, 31.0},
          extent = {{-16.0, -16.0}, {16.0, 16.0}})));

      Mechanics.QuadChassis quadChassisTest17_1 annotation (Placement(transformation(origin = {95.0, 17.5},
        extent = {{-34.0, -33.99999999999999}, {34.0, 34.00000000000001}})));
      Electricals.Actuator actuator1_1 
        annotation (Placement(transformation(origin = {1.0, 53.5},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      Electricals.Actuator actuator1_2 
        annotation (Placement(transformation(origin = {1.0, 29.5},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      Electricals.Actuator actuator1_3 
        annotation (Placement(transformation(origin = {1.0, 3.500000000000007},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      Electricals.Actuator actuator1_4 
        annotation (Placement(transformation(origin = {1.0, -22.499999999999993},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));


      annotation (Diagram(coordinateSystem(extent = {{-200.0, -100.0}, {200.0, 100.0}},
        grid = {2.0, 2.0})),
        Icon(coordinateSystem(extent = {{-100.0, -100.0}, {100.0, 100.0}},
          preserveAspectRatio = false,
          grid = {2.0, 2.0})),
        experiment(Algorithm = Dassl, StartTime = 0, StopTime = 50, Tolerance = 0.0001, Interval = 0.01),__MWORKS(version="26.2.1"));
      extends Modelica.Icons.Example;
      Blocks.Controller.ActiveController controller3_2 
        annotation (Placement(transformation(origin = {-76.00000000000001, 16.0},
          extent = {{-25.000000000000014, -25.0}, {25.0, 25.0}})));
      Sensors.Sensors sensors1_1 
        annotation (Placement(transformation(origin = {0.9999999999999996, -64.5},
          extent = {{19.342105263157897, -17.5}, {-19.342105263157897, 17.5}})));
      Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor[4] annotation (Placement(transformation(origin = {80.0, 66.0},
        extent = {{-10.0, -10.0}, {10.0, 10.0}})));
    equation
      controller3_2.yaw_command = 0;
      connect(actuator1_1.flange_a, quadChassisTest17_1.flange_a) 
        annotation (Line(origin = {26.0, 37.5},
          points = {{-15.0, 16.0}, {4.0, 16.0}, {4.0, 0.0}, {35.0, 0.0}},
          color = {0, 0, 0},
          thickness = 0.8));
      connect(actuator1_2.flange_a, quadChassisTest17_1.flange_a1) 
        annotation (Line(origin = {26.0, 21.5},
          points = {{-15.0, 8.0}, {4.0, 8.0}, {4.0, 3.0}, {35.0, 3.0}},
          color = {0, 0, 0},
          thickness = 0.8));
      connect(actuator1_3.flange_a, quadChassisTest17_1.flange_a2) 
        annotation (Line(origin = {26.0, 7.500000000000007},
          points = {{-15.0, -4.0}, {4.0, -4.0}, {4.0, 3.0}, {35.0, 3.0}},
          color = {0, 0, 0},
          thickness = 0.8));
      connect(actuator1_4.flange_a, quadChassisTest17_1.flange_a3) 
        annotation (Line(origin = {26.0, -6.499999999999993},
          points = {{-15.0, -16.0}, {4.0, -16.0}, {4.0, 4.0}, {35.0, 4.0}},
          color = {0, 0, 0},
          thickness = 0.8));
      connect(quadChassisTest17_1.frame_a, sensors1_1.frame_a) 
        annotation (Line(origin = {25.0, -21.499999999999993},
          points = {{104.0, 39.0}, {122.0, 39.0}, {122.0, -43.0}, {-5.0, -43.0}},
          color = {95, 95, 95},
          thickness = 0.8));
      connect(actuator1_1.u, controller3_2.y) 
        annotation (Line(origin = {-30.0, 34.5},
          points = {{19.0, 19.0}, {-11.0, 19.0}, {-11.0, -4.0}, {-19.0, -4.0}},
          color = {0, 0, 127},
          thickness = 0.8));
      connect(actuator1_2.u, controller3_2.y1) 
        annotation (Line(origin = {-30.0, 22.5},
          points = {{19.0, 7.0}, {-5.0, 7.0}, {-5.0, -1.0}, {-19.0, -1.0}},
          color = {0, 0, 127},
          thickness = 0.8));
      connect(actuator1_3.u, controller3_2.y2) 
        annotation (Line(origin = {-30.0, 9.500000000000007},
          points = {{19.0, -6.0}, {-5.0, -6.0}, {-5.0, 2.0}, {-19.0, 2.0}},
          color = {0, 0, 127},
          thickness = 0.8));
      connect(actuator1_4.u, controller3_2.y3) 
        annotation (Line(origin = {-30.0, -3.499999999999993},
          points = {{19.0, -19.0}, {-9.0, -19.0}, {-9.0, 5.0}, {-19.0, 5.0}},
          color = {0, 0, 127},
          thickness = 0.8));
      connect(climbePath.position_command, controller3_2.position_command) 
        annotation (Line(origin = {-143.0, -11.0},
          points = {{2.0, 42.0}, {39.0, 42.0}},
          color = {0, 0, 127},
          thickness = 1.0));
      connect(sensors1_1.AngleMea, controller3_2.angle) 
        annotation (Line(origin = {-66.0, -31.0},
          points = {{46.0, -27.0}, {-50.0, -27.0}, {-50.0, 32.0}, {-38.0, 32.0}},
          color = {0, 0, 127},
          thickness = 0.8));
      connect(sensors1_1.PosMea, controller3_2.position) 
        annotation (Line(origin = {-92.0, -29.0},
          points = {{72.0, -42.0}, {-34.0, -42.0}, {-34.0, 46.0}, {-12.0, 46.0}},
          color = {0, 0, 127},
          thickness = 0.8));
      connect(actuator1_1.flange_a, speedSensor[1].flange) 
        annotation (Line(origin = {44.0, 57.0},
          points = {{-32.0, -10.0}, {-14.0, -10.0}, {-14.0, 9.0}, {26.0, 9.0}},
          color = {0, 0, 0}));
      connect(actuator1_2.flange_a, speedSensor[2].flange) 
        annotation (Line(origin = {44.0, 45.0},
          points = {{-32.0, -22.0}, {-14.0, -22.0}, {-14.0, 21.0}, {26.0, 21.0}},
          color = {0, 0, 0}));
      connect(actuator1_3.flange_a, speedSensor[3].flange) 
        annotation (Line(origin = {44.0, 32.0},
          points = {{-32.0, -35.0}, {-14.0, -35.0}, {-14.0, 34.0}, {26.0, 34.0}},
          color = {0, 0, 0}));
      connect(actuator1_4.flange_a, speedSensor[4].flange) 
        annotation (Line(origin = {44.0, 19.0},
          points = {{-32.0, -48.0}, {-14.0, -48.0}, {-14.0, 47.0}, {26.0, 47.0}},
          color = {0, 0, 0},
          thickness = 0.8));
    end Example2;