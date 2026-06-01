within QuadrotorModel.Mechanics;
    model Rotor "旋翼模型"
      Modelica.Mechanics.MultiBody.Parts.BodyShape propellers1(
        animation = true,
        animateSphere = false,
        r = {0, 0, 0},
        m = 0.000913171,
        I_11 = 1.59662e-7,
        I_22 = 1.59594e-7,
        I_33 = 3.16359e-7,
        I_21 = 0,
        I_31 = 0,
        I_32 = 0,
        shapeType = "QuadPropeller.hsf",
        r_shape = {0, 0, 0},
        lengthDirection = {0.923728, 0.383049, 0},
        widthDirection = {-0.383049, 0.923728, 0},
        length = 1,
        width = 1,
        height = 1,
        extra = 1,
        color = {255, 255, 255},
        specularCoefficient = 1,
        r_0(fixed = false)) 
        annotation (Placement(transformation(origin = {-25.00000000000003, -0.5000000000000284},
          extent = {{10.0, -10.0}, {-10.0, 10.0}})));
      Modelica.Mechanics.MultiBody.Joints.Revolute revolute1(
        animation = false,
        n = {0, 0, 1},
        useAxisFlange = true) 
        annotation (Placement(transformation(origin = {16.99999999999997, -0.5000000000000284},
          extent = {{10.0, -10.0}, {-10.0, 10.0}})));
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_a annotation (Placement(transformation(origin = {-100.0, 18.000000000000014},
        extent = {{-10.0, -10.0}, {10.0, 10.0}}),
        iconTransformation(origin = {-100.40059043098442, 1.7339167500375368},
          extent = {{-10.0, -10.0}, {10.0, 10.0}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b 
        annotation (Placement(transformation(origin = {101.0, 0.0},
          extent = {{-16.0, -16.0}, {16.0, 16.0}})));
    equation
      connect(propellers1.frame_a, revolute1.frame_b) 
        annotation (Line(origin = {-4.0, -0.5},
          points = {{-11.0, 0.0}, {11.0, 0.0}},
          color = {95, 95, 95},
          thickness = 0.5));



      connect(revolute1.axis, flange_a) 
        annotation (Line(origin = {19.0, 14.5},
          points = {{-2.0, -5.0}, {-2.0, 4.0}, {-118.0, 4.0}},
          color = {0, 0, 0}));
      connect(revolute1.frame_a, frame_b) 
        annotation (Line(origin = {64.0, 1.0},
          points = {{-37.0, -2.0}, {37.0, -2.0}, {37.0, -1.0}},
          color = {95, 95, 95},
          thickness = 0.5));
    end Rotor;