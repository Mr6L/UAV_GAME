within QuadrotorModel.PathPlanning;
    model CirclePath "螺旋爬升模型"
      Modelica.Blocks.Sources.Ramp ramp(startTime = 0, duration = 150,
        height = 10) 
        annotation (Placement(transformation(origin = {-2.0, -50.209416252197016},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      Modelica.Blocks.Interfaces.RealOutput position_command[3] "指令信号--x,y,z" annotation (Placement(transformation(origin = {111.0, 0.0},
        extent = {{-10.0, -10.0}, {10.0, 10.0}}),
        iconTransformation(origin = {110.0, 0.0},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      Modelica.Blocks.Math.Gain gain(k = 1) 
        annotation (Placement(transformation(origin = {55.94162521970009, -50.121461426274266},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      Modelica.Blocks.Math.Gain gain1(k = 1) 
        annotation (Placement(transformation(origin = {55.94162521970009, 41.790583747803},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      Modelica.Blocks.Sources.Sine sine(f=0.03, amplitude=3, startTime=10) 
        annotation (Placement(transformation(origin = {-2.0, -0.209416252197002},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      Modelica.Blocks.Sources.Cosine cosine(f=0.03, amplitude=3, startTime=10) 
        annotation (Placement(transformation(origin = {-2.0, 41.790583747803},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));



      Modelica.Blocks.Math.Gain gain2(k = 1) 
        annotation (Placement(transformation(origin = {56.779290228488094, 0.0},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      annotation (Icon(coordinateSystem(extent = {{-100.0, -100.0}, {100.0, 100.0}},
        grid = {2.0, 2.0}), graphics = {Rectangle(origin = {-0.2695547533092224, 0.5391095066185301},
        lineColor = {200, 200, 200},
        fillColor = {248, 248, 248},
        fillPattern = FillPattern.HorizontalCylinder,
        extent = {{-100.0, -100.0}, {100.0, 100.0}},
        radius = 25.0), Ellipse(origin = {2.0, 1.0},
        lineColor = {118, 118, 118},
        fillColor = {255, 255, 255},
        lineThickness = 0.5,
        extent = {{60.0, 39.0}, {-60.0, -39.0}}), Line(origin = {2.0, 31.0},
        points = {{0.0, -33.0}, {0.0, 33.0}},
        color = {132, 132, 132},
        pattern = LinePattern.Dash,
        arrow = {Arrow.None, Arrow.Filled},
        arrowSize = 4.0,
        __MWorks_Manhattanize = true)}),__MWORKS(version="26.2.1"));
    equation
      connect(gain1.y, position_command[1]) 
        annotation (Line(origin = {89.0, 21.0},
          points = {{-22.0, 21.0}, {-9.0, 21.0}, {-9.0, -21.0}, {22.0, -21.0}},
          color = {0, 0, 127}));
      connect(gain2.y, position_command[2]) 
        annotation (Line(origin = {90.0, 0.0},
          points = {{-22.0, 0.0}, {21.0, 0.0}},
          color = {0, 0, 127}));
      connect(gain.y, position_command[3]) 
        annotation (Line(origin = {90.0, -25.0},
          points = {{-23.0, -25.0}, {-10.0, -25.0}, {-10.0, 25.0}, {21.0, 25.0}},
          color = {0, 0, 127}));
      connect(cosine.y, gain1.u) 
        annotation (Line(origin = {7.0, 42.0},
          points = {{2.0, 0.0}, {37.0, 0.0}},
          color = {0, 0, 127}));
      connect(sine.y, gain2.u) 
        annotation (Line(origin = {7.0, 0.0},
          points = {{2.0, 0.0}, {38.0, 0.0}},
          color = {0, 0, 127}));
      connect(ramp.y, gain.u) 
        annotation (Line(origin = {7.0, -50.0},
          points = {{2.0, 0.0}, {37.0, 0.0}},
          color = {0, 0, 127}));
    end CirclePath;