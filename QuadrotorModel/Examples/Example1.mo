within QuadrotorModel.Examples;
    model Example1 "阶梯爬升运动"

      PathPlanning.ClimbPath climbePath(gain(k = 1.0)) 
        annotation (Placement(transformation(origin = {-150.0, 24.0},
          extent = {{-16.0, -16.0}, {16.0, 16.0}})));
      annotation (Diagram(coordinateSystem(extent = {{-200.0, -100.0}, {200.0, 100.0}},
        grid = {2.0, 2.0})),
        Icon(coordinateSystem(extent = {{-100.0, -100.0}, {100.0, 100.0}},
          preserveAspectRatio = false,
          grid = {2.0, 2.0})),experiment(StopTime=50,Interval=0.01)
        );
      Mechanics.QuadChassis quadChassisTest17_1 annotation (Placement(transformation(origin = {86.00000000000001, 8.499999999999986},
        extent = {{-34.0, -33.99999999999999}, {34.0, 34.00000000000001}})));
      Electricals.Actuator actuator1_1 
        annotation (Placement(transformation(origin = {2.0, 46.5},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      Electricals.Actuator actuator1_2 
        annotation (Placement(transformation(origin = {2.0, 22.5},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      Electricals.Actuator actuator1_3 
        annotation (Placement(transformation(origin = {2.0, -3.5},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      Electricals.Actuator actuator1_4 
        annotation (Placement(transformation(origin = {2.0, -29.5},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));


      extends Modelica.Icons.Example;
      Sensors.Sensors sensors1_1 
        annotation (Placement(transformation(origin = {2.0000000000000018, -64.5},
          extent = {{21.0, -19.0}, {-21.0, 19.0}})));
      Blocks.Controller.ActiveController controller3_2 
        annotation (Placement(transformation(origin = {-70.99999999999999, 9.0},
          extent = {{-25.000000000000014, -25.0}, {25.0, 25.0}})));
      Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor[4] annotation (Placement(transformation(origin = {80.0, 66.0},
        extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      equation
      controller3_2.yaw_command = 0;
      connect(actuator1_1.flange_a, quadChassisTest17_1.flange_a) 
        annotation (Line(origin = {27.0, 30.5},
          points = {{-15.0, 16.0}, {3.0, 16.0}, {3.0, -2.0}, {25.0, -2.0}},
          color = {0, 0, 0},
          thickness = 0.8));
      connect(actuator1_2.flange_a, quadChassisTest17_1.flange_a1) 
        annotation (Line(origin = {27.0, 14.5},
          points = {{-15.0, 8.0}, {3.0, 8.0}, {3.0, 2.0}, {25.0, 2.0}, {25.0, 1.0}},
          color = {0, 0, 0},
          thickness = 0.8));
      connect(actuator1_3.flange_a, quadChassisTest17_1.flange_a2) 
        annotation (Line(origin = {27.0, 0.5},
          points = {{-15.0, -4.0}, {3.0, -4.0}, {3.0, 1.0}, {25.0, 1.0}},
          color = {0, 0, 0},
          thickness = 1.0));
      connect(actuator1_4.flange_a, quadChassisTest17_1.flange_a3) 
        annotation (Line(origin = {27.0, -13.5},
          points = {{-15.0, -16.0}, {3.0, -16.0}, {3.0, 2.0}, {25.0, 2.0}},
          color = {0, 0, 0},
          thickness = 0.8));
      connect(quadChassisTest17_1.frame_a, sensors1_1.frame_a) 
        annotation (Line(origin = {16.0, -30.5},
          points = {{104.0, 39.0}, {122.0, 39.0}, {122.0, -34.0}, {7.0, -34.0}},
          color = {95, 95, 95},
          thickness = 0.8));
      connect(actuator1_1.u, controller3_2.y) 
        annotation (Line(origin = {-21.0, 27.5},
          points = {{11.0, 19.0}, {-15.0, 19.0}, {-15.0, -4.0}, {-22.0, -4.0}},
          color = {0, 0, 127},
          thickness = 0.8));
      connect(actuator1_2.u, controller3_2.y1) 
        annotation (Line(origin = {-21.0, 15.5},
          points = {{11.0, 7.0}, {-8.0, 7.0}, {-8.0, -1.0}, {-22.0, -1.0}},
          color = {0, 0, 127},
          thickness = 0.8));
      connect(actuator1_3.u, controller3_2.y2) 
        annotation (Line(origin = {-21.0, 2.5},
          points = {{11.0, -6.0}, {-8.0, -6.0}, {-8.0, 2.0}, {-22.0, 2.0}},
          color = {0, 0, 127},
          thickness = 0.8));
      connect(actuator1_4.u, controller3_2.y3) 
        annotation (Line(origin = {-21.0, -10.5},
          points = {{11.0, -19.0}, {-16.0, -19.0}, {-16.0, 5.0}, {-22.0, 5.0}},
          color = {0, 0, 127},
          thickness = 0.8));
      connect(sensors1_1.AngleMea, controller3_2.angle) 
        annotation (Line(origin = {-58.0, -39.0},
          points = {{37.0, -18.0}, {-55.0, -18.0}, {-55.0, 33.0}, {-41.0, 33.0}},
          color = {0, 0, 127},
          thickness = 0.8));
      connect(sensors1_1.PosMea, controller3_2.position) 
        annotation (Line(origin = {-76.0, -34.0},
          points = {{55.0, -38.0}, {-50.0, -38.0}, {-50.0, 44.0}, {-23.0, 44.0}},
          color = {0, 0, 127},
          thickness = 0.8));
      connect(climbePath.position_command, controller3_2.position_command) 
        annotation (Line(origin = {-115.0, 24.0},
          points = {{-17.0, 0.0}, {17.0, 0.0}},
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
    end Example1;
