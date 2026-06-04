within QuadrotorModel.Mechanics;
    model Arm "机臂"
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation Dronefixed1(
        animation = false,
        r = {0.04243, -0.04243, 0.05460}) 
        annotation (Placement(transformation(origin = {2.4999999999999716, 75.50000000000004},
          extent = {{10.0, -10.0}, {-10.0, 10.0}})));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation Dronefixed2(
        animation = false,
        r = {0.04243, 0.04243, 0.05460}) 
        annotation (Placement(transformation(origin = {4.499999999999972, 24.83333333333337},
          extent = {{10.0, -10.0}, {-10.0, 10.0}})));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation Dronefixed3(
        animation = false,
        r = {-0.04243, 0.04243, 0.05460}) 
        annotation (Placement(transformation(origin = {2.4999999999999716, -25.8333333333333},
          extent = {{10.0, -10.0}, {-10.0, 10.0}})));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation Dronefixed4(
        animation = false,
        r = {-0.04243, -0.04243, 0.05460}) 
        annotation (Placement(transformation(origin = {2.4999999999999716, -76.49999999999997},
          extent = {{10.0, -10.0}, {-10.0, 10.0}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b 
        annotation (Placement(transformation(origin = {101.0, 76.0},
          extent = {{-16.0, -16.0}, {16.0, 16.0}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b1 
        annotation (Placement(transformation(origin = {101.0, 26.0},
          extent = {{-16.0, -16.0}, {16.0, 16.0}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b2 
        annotation (Placement(transformation(origin = {101.0, -24.0},
          extent = {{-16.0, -16.0}, {16.0, 16.0}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b3 
        annotation (Placement(transformation(origin = {101.0, -76.0},
          extent = {{-16.0, -16.0}, {16.0, 16.0}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a 
        annotation (Placement(transformation(origin = {-100.0, 76.0},
          extent = {{-16.0, -16.0}, {16.0, 16.0}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a1 
        annotation (Placement(transformation(origin = {-100.0, 24.0},
          extent = {{-16.0, -16.0}, {16.0, 16.0}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a2 
        annotation (Placement(transformation(origin = {-100.0, -26.0},
          extent = {{-16.0, -16.0}, {16.0, 16.0}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a3 
        annotation (Placement(transformation(origin = {-100.0, -76.0},
          extent = {{-16.0, -16.0}, {16.0, 16.0}})));
      annotation(__MWORKS(version="26.2.1"));
    equation
      connect(Dronefixed1.frame_a, frame_b) 
        annotation (Line(origin = {64.0, 77.0},
          points = {{-52.0, -1.0}, {37.0, -1.0}},
          color = {95, 95, 95},
          thickness = 0.5));
      connect(Dronefixed2.frame_a, frame_b1) 
        annotation (Line(origin = {58.0, 25.0},
          points = {{-44.0, 0.0}, {-44.0, 1.0}, {43.0, 1.0}},
          color = {95, 95, 95},
          thickness = 0.5));
      connect(Dronefixed3.frame_a, frame_b2) 
        annotation (Line(origin = {57.0, -25.0},
          points = {{-45.0, -1.0}, {44.0, -1.0}, {44.0, 1.0}},
          color = {95, 95, 95},
          thickness = 0.5));
      connect(Dronefixed4.frame_a, frame_b3) 
        annotation (Line(origin = {58.0, -74.0},
          points = {{-46.0, -2.0}, {43.0, -2.0}},
          color = {95, 95, 95},
          thickness = 0.5));
      connect(Dronefixed1.frame_b, frame_a) 
        annotation (Line(origin = {-54.0, 76.0},
          points = {{46.0, 0.0}, {-46.0, 0.0}},
          color = {95, 95, 95},
          thickness = 0.5));
      connect(Dronefixed2.frame_b, frame_a1) 
        annotation (Line(origin = {-53.0, 25.0},
          points = {{47.0, 0.0}, {45.0, 0.0}, {45.0, -1.0}, {-47.0, -1.0}},
          color = {95, 95, 95},
          thickness = 0.5));
      connect(frame_a3, Dronefixed4.frame_b) 
        annotation (Line(origin = {-54.0, -76.0},
          points = {{-46.0, 0.0}, {46.0, 0.0}},
          color = {95, 95, 95},
          thickness = 0.5));
      connect(frame_a2, Dronefixed3.frame_b) 
        annotation (Line(origin = {-54.0, -25.0},
          points = {{-46.0, -1.0}, {46.0, -1.0}},
          color = {95, 95, 95},
          thickness = 0.5));
    end Arm;