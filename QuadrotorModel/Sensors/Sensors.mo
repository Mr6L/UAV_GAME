within QuadrotorModel.Sensors;
    model Sensors
      AbsoluteAngles absoluteAngles 
        annotation (Placement(transformation(origin = {0.0, 20.0},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));



      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a 
        annotation (Placement(transformation(origin = {-100.0, 0.0},
          extent = {{-16.0, -16.0}, {16.0, 16.0}}),
          iconTransformation(origin = {-100.0, 0.0},
            extent = {{-16.0, -16.0}, {16.0, 16.0}})));
      Modelica.Blocks.Interfaces.RealOutput AngleMea[3] "角度测量信号" annotation (Placement(transformation(origin = {110.0, 20.0},
        extent = {{-10.0, -10.0}, {10.0, 10.0}}),
        iconTransformation(origin = {110.0, 40.0},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      Modelica.Blocks.Interfaces.RealOutput PosMea[3] "位置测量信号" annotation (Placement(transformation(origin = {110.0, -24.0},
        extent = {{-10.0, -10.0}, {10.0, 10.0}}),
        iconTransformation(origin = {110.0, -38.0},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      annotation (Icon(coordinateSystem(extent = {{-100.0, -100.0}, {100.0, 100.0}},
        grid = {2.0, 2.0}), graphics = {Rectangle(origin = {-7.105427357601002e-15, 0.0},
        lineColor = {200, 200, 200},
        fillColor = {248, 248, 248},
        fillPattern = FillPattern.HorizontalCylinder,
        extent = {{-100.0, -100.0}, {100.0, 100.0}},
        radius = 25.0), Text(origin = {6.0, 0.0},
        lineColor = {136, 136, 136},
        extent = {{-68.0, 60.0}, {68.0, -60.0}},
        textString = "Sensors",
        textStyle = {TextStyle.None},
        textColor = {136, 136, 136})}));
      AbsolutePosition absolutePosition1(
        resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameA.world) annotation (Placement(transformation(origin = {0.0, -23.974440894568694},
          extent = {{10.0, 10.0}, {-10.0, -10.0}},
          rotation = 180.0)));
    equation
      connect(frame_a, absoluteAngles.frame_a) 
        annotation (Line(origin = {-55.0, 10.0},
          points = {{-45.0, -10.0}, {-5.0, -10.0}, {-5.0, 10.0}, {45.0, 10.0}},
          color = {95, 95, 95},
          thickness = 0.5));

      connect(absoluteAngles.angles, AngleMea) 
        annotation (Line(origin = {61.0, 19.0},
          points = {{-50.0, 1.0}, {49.0, 1.0}},
          color = {0, 0, 127}));
      connect(absolutePosition1.frame_a, frame_a) 
        annotation (Line(origin = {-55.0, -12.0},
          points = {{45.0, -12.0}, {-5.0, -12.0}, {-5.0, 12.0}, {-45.0, 12.0}},
          color = {95, 95, 95},
          thickness = 0.5));
      connect(absolutePosition1.r, PosMea) 
        annotation (Line(origin = {61.0, -23.0},
          points = {{-50.0, -1.0}, {49.0, -1.0}},
          color = {0, 0, 127}));
    end Sensors;