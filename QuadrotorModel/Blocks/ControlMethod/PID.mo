within QuadrotorModel.Blocks.ControlMethod;
      model PID "连续PID控制器"

        parameter Real KP = 1;
        parameter Real KI = 1;
        parameter Real KD = 1;
        Modelica.Blocks.Math.Gain gain(k = KP) 
          annotation (Placement(transformation(origin = {-30.0, 60.0},
            extent = {{-10.0, -10.0}, {10.0, 10.0}})));
        Modelica.Blocks.Math.Add3 add3_1 
          annotation (Placement(transformation(origin = {38.0, 0.0},
            extent = {{-10.0, -10.0}, {10.0, 10.0}})));
        Modelica.Blocks.Continuous.Integrator integrator 
          annotation (Placement(transformation(origin = {-50.0, 0.0},
            extent = {{-10.0, -10.0}, {10.0, 10.0}})));
        Modelica.Blocks.Continuous.Derivative der1 annotation (Placement(transformation(origin = {-50.0, -60.0},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));

        Modelica.Blocks.Math.Gain gain1(k = KI) 
          annotation (Placement(transformation(origin = {-10.0, 0.0},
            extent = {{-10.0, -10.0}, {10.0, 10.0}})));
        Modelica.Blocks.Math.Gain gain2(k = KD) 
          annotation (Placement(transformation(origin = {-10.0, -60.0},
            extent = {{-10.0, -10.0}, {10.0, 10.0}})));
        annotation (Icon(coordinateSystem(extent = {{-100.0, -100.0}, {100.0, 100.0}},
          grid = {2.0, 2.0}), graphics = {Rectangle(origin = {0.9443507588532611, -1.0556492411467104},
          lineColor = {200, 200, 200},
          fillColor = {248, 248, 248},
          fillPattern = FillPattern.HorizontalCylinder,
          extent = {{-100.0, -100.0}, {100.0, 100.0}},
          radius = 25.0), Text(origin = {-0.24957841483981724, 0.527824620573357},
          lineColor = {120, 120, 120},
          extent = {{-92.0, 73.0}, {92.0, -73.0}},
          textString = "PID",
          fontName = "Times New Roman",
          textStyle = {TextStyle.None},
          textColor = {120, 120, 120})}));
        extends Modelica.Blocks.Interfaces.SISO;
        Modelica.Blocks.Math.Gain gain3 
          annotation (Placement(transformation(origin = {73.99999999999999, 0.0},
            extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      equation
        connect(u, integrator.u) 
          annotation (Line(origin = {-91.0, 0.0},
            points = {{-29.0, 0.0}, {29.0, 0.0}},
            color = {0, 0, 127}));
        connect(u, gain.u) 
          annotation (Line(origin = {-81.0, 30.0},
            points = {{-39.0, -30.0}, {1.0, -30.0}, {1.0, 30.0}, {39.0, 30.0}},
            color = {0, 0, 127}));
        connect(u, der1.u) 
          annotation (Line(origin = {-91.0, -30.0},
            points = {{-29.0, 30.0}, {11.0, 30.0}, {11.0, -30.0}, {29.0, -30.0}},
            color = {0, 0, 127}));
        connect(integrator.y, gain1.u) 
          annotation (Line(origin = {-30.0, 0.0},
            points = {{-9.0, 0.0}, {8.0, 0.0}},
            color = {0, 0, 127}));
        connect(der1.y, gain2.u) 
          annotation (Line(origin = {-30.0, -60.0},
            points = {{-9.0, 0.0}, {8.0, 0.0}},
            color = {0, 0, 127}));
        connect(gain.y, add3_1.u1) 
          annotation (Line(origin = {20.0, 34.0},
            points = {{-39.0, 26.0}, {-6.0, 26.0}, {-6.0, -26.0}, {6.0, -26.0}},
            color = {0, 0, 127}));
        connect(gain1.y, add3_1.u2) 
          annotation (Line(origin = {30.0, 0.0},
            points = {{-29.0, 0.0}, {-4.0, 0.0}},
            color = {0, 0, 127}));
        connect(gain2.y, add3_1.u3) 
          annotation (Line(origin = {30.0, -34.0},
            points = {{-29.0, -26.0}, {-16.0, -26.0}, {-16.0, 26.0}, {-4.0, 26.0}},
            color = {0, 0, 127}));
        connect(add3_1.y, gain3.u) 
          annotation (Line(origin = {55.0, 0.0},
            points = {{-6.0, 0.0}, {6.999999999999986, 0.0}},
            color = {0, 0, 127}));
        connect(gain3.y, y) 
          annotation (Line(origin = {98.0, 0.0},
            points = {{-13.000000000000014, 0.0}, {12.0, 0.0}},
            color = {0, 0, 127}));
      end PID;