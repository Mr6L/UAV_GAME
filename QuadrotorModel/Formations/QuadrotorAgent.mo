within QuadrotorModel.Formations;
model QuadrotorAgent "可复用单机闭环无人机代理"
  parameter Real initialPosition[3] = {0, 0, 0} "初始位置建议值";
  parameter Boolean showSceneReferences = false "显示场景参考物";

  Modelica.Blocks.Interfaces.RealInput position_command[3] "期望位置" 
    annotation (Placement(transformation(origin = {-120, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput yaw_command "期望航向角" 
    annotation (Placement(transformation(origin = {-120, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput external_force[3] "外部扰动力" 
    annotation (Placement(transformation(origin = {-120, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput position[3] "真实位置测量" 
    annotation (Placement(transformation(origin = {120, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput angle[3] "姿态角测量" 
    annotation (Placement(transformation(origin = {120, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput motor_command[4] "四路电机控制量" 
    annotation (Placement(transformation(origin = {120, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput rotor_speed[4] "四路旋翼转速" 
    annotation (Placement(transformation(origin = {120, -60}, extent = {{-10, -10}, {10, 10}})));

  QuadrotorModel.Mechanics.QuadChassis quadChassis(
    body(r_0(start = initialPosition, fixed = {true, true, true}))) 
    annotation (Placement(transformation(origin = {48, 2}, extent = {{-20, -20}, {20, 20}})));
  QuadrotorModel.Formations.SceneReferences sceneReferences(animation = showSceneReferences) 
    annotation (Placement(transformation(origin = {94, -84}, extent = {{-10, -10}, {10, 10}})));
  QuadrotorModel.Electricals.Actuator actuator1 
    annotation (Placement(transformation(origin = {-6, 42}, extent = {{-8, -8}, {8, 8}})));
  QuadrotorModel.Electricals.Actuator actuator2 
    annotation (Placement(transformation(origin = {-6, 20}, extent = {{-8, -8}, {8, 8}})));
  QuadrotorModel.Electricals.Actuator actuator3 
    annotation (Placement(transformation(origin = {-6, -2}, extent = {{-8, -8}, {8, 8}})));
  QuadrotorModel.Electricals.Actuator actuator4 
    annotation (Placement(transformation(origin = {-6, -24}, extent = {{-8, -8}, {8, 8}})));
  QuadrotorModel.Sensors.Sensors sensors 
    annotation (Placement(transformation(origin = {2, -58}, extent = {{15, -13}, {-15, 13}})));
  QuadrotorModel.Blocks.Controller.ActiveController controller 
    annotation (Placement(transformation(origin = {-60, 0}, extent = {{-18, -18}, {18, 18}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor[4] 
    annotation (Placement(transformation(origin = {52, 58}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Mechanics.MultiBody.Forces.WorldForce disturbanceForce(
    resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameB.frame_b,
    animation = false) 
    annotation (Placement(transformation(origin = {28, -82}, extent = {{-8, -8}, {8, 8}})));

equation
  connect(position_command, controller.position_command) annotation (Line(points = {{-120, 60}, {-88, 60}, {-88, 6}, {-78, 6}}, color = {0, 0, 127}));
  connect(yaw_command, controller.yaw_command) annotation (Line(points = {{-120, 20}, {-94, 20}, {-94, 2}, {-78, 2}}, color = {0, 0, 127}));
  connect(external_force, disturbanceForce.force) annotation (Line(points = {{-120, -60}, {-20, -60}, {-20, -82}, {20, -82}}, color = {0, 0, 127}));
  connect(disturbanceForce.frame_b, quadChassis.frame_a) annotation (Line(points = {{36, -82}, {48, -82}, {48, -18}}, color = {95, 95, 95}));
  connect(quadChassis.world.frame_b, sceneReferences.frame_a) annotation (Line(origin={0,0},
points={{75,20},{83,20},{83,-84}},
color={95,95,95}),__MWORKS(BlockSystem(NamedSignal)));

  connect(actuator1.flange_a, quadChassis.flange_a) annotation (Line(points = {{2, 42}, {30, 42}, {30, 14}}, color = {0, 0, 0}));
  connect(actuator2.flange_a, quadChassis.flange_a1) annotation (Line(points = {{2, 20}, {28, 20}, {28, 6}}, color = {0, 0, 0}));
  connect(actuator3.flange_a, quadChassis.flange_a2) annotation (Line(points = {{2, -2}, {28, -2}, {28, -6}}, color = {0, 0, 0}));
  connect(actuator4.flange_a, quadChassis.flange_a3) annotation (Line(points = {{2, -24}, {30, -24}, {30, -14}}, color = {0, 0, 0}));
  connect(quadChassis.frame_a, sensors.frame_a) annotation (Line(points = {{48, -18}, {48, -58}, {17, -58}}, color = {95, 95, 95}));

  connect(controller.y, actuator1.u) annotation (Line(points = {{-42, 10}, {-24, 10}, {-24, 42}, {-16, 42}}, color = {0, 0, 127}));
  connect(controller.y1, actuator2.u) annotation (Line(points = {{-42, 4}, {-26, 4}, {-26, 20}, {-16, 20}}, color = {0, 0, 127}));
  connect(controller.y2, actuator3.u) annotation (Line(points = {{-42, -4}, {-26, -4}, {-26, -2}, {-16, -2}}, color = {0, 0, 127}));
  connect(controller.y3, actuator4.u) annotation (Line(points = {{-42, -10}, {-24, -10}, {-24, -24}, {-16, -24}}, color = {0, 0, 127}));
  connect(sensors.AngleMea, controller.angle) annotation (Line(points = {{-13, -52}, {-86, -52}, {-86, -8}, {-78, -8}}, color = {0, 0, 127}));
  connect(sensors.PosMea, controller.position) annotation (Line(points = {{-13, -62}, {-92, -62}, {-92, -2}, {-78, -2}}, color = {0, 0, 127}));

  connect(actuator1.flange_a, speedSensor[1].flange) annotation (Line(points = {{2, 42}, {52, 42}, {52, 50}}, color = {0, 0, 0}));
  connect(actuator2.flange_a, speedSensor[2].flange) annotation (Line(points = {{2, 20}, {52, 20}, {52, 50}}, color = {0, 0, 0}));
  connect(actuator3.flange_a, speedSensor[3].flange) annotation (Line(points = {{2, -2}, {52, -2}, {52, 50}}, color = {0, 0, 0}));
  connect(actuator4.flange_a, speedSensor[4].flange) annotation (Line(points = {{2, -24}, {52, -24}, {52, 50}}, color = {0, 0, 0}));

  position = sensors.PosMea;
  angle = sensors.AngleMea;
  motor_command[1] = controller.y;
  motor_command[2] = controller.y1;
  motor_command[3] = controller.y2;
  motor_command[4] = controller.y3;
  for i in 1:4 loop
    rotor_speed[i] = speedSensor[i].w;
  end for;

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, radius = 20,
        lineColor = {120, 120, 120}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.Solid), Text(extent = {{-78, 24}, {78, -24}},
        textString = "Agent")}),
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})),__MWORKS(version="26.2.1"));
end QuadrotorAgent;