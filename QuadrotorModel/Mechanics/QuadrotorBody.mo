within QuadrotorModel.Mechanics;
    model QuadrotorBody "四旋翼机身"
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a 
        annotation (Placement(transformation(origin = {-100.0, 0.0},
          extent = {{-16.0, -16.0}, {16.0, 16.0}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b 
        annotation (Placement(transformation(origin = {100.0, 0.0},
          extent = {{-16.0, -16.0}, {16.0, 16.0}})));
      Modelica.Mechanics.MultiBody.Parts.BodyShape body(
        animation = true,
        animateSphere = false,
        r = {0, 0, 0},
        r_CM = {0, 0, 0.0230935},
        m = 0.159504,
        I_11 = 0.00010556,
        I_22 = 0.00010556,
        I_33 = 0.00010556,
        I_21 = 0,
        I_31 = 0,
        I_32 = 0,
        shapeType = "QuadBody.hsf",
        r_shape = {0, 0, 0},
        lengthDirection = {-1, 0, 0},
        widthDirection = {0, 1, 0},
        length = 1,
        width = 1,
        height = 1,
        extra = 1,
        color = {255, 255, 255},
        specularCoefficient = 1,
        r_0(fixed = false),
        enforceStates = true) annotation (Placement(transformation(extent = {{10.0, -10.0}, {-10.0, 10.0}})));
      annotation(__MWORKS(version="26.2.1"));
    equation
      connect(frame_a, body.frame_b) 
        annotation (Line(origin = {-55.0, 0.0},
          points = {{-45.0, 0.0}, {45.0, 0.0}},
          color = {95, 95, 95},
          thickness = 0.5));
      connect(body.frame_a, frame_b) 
        annotation (Line(origin = {55.0, 0.0},
          points = {{-45.0, 0.0}, {45.0, 0.0}},
          color = {95, 95, 95},
          thickness = 0.5));
    end QuadrotorBody;