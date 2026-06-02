within QuadrotorModel.Formations;
model SceneReferences "静态场景参考物"
  parameter Boolean animation = true "显示场景参考物";

  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "参考物挂接坐标系"
    annotation (Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Mechanics.MultiBody.Visualizers.FixedShape2 groundPlatform(
    shapeType = "box",
    r_shape = {0, 0, -0.205},
    lengthDirection = {1, 0, 0},
    widthDirection = {0, 1, 0},
    length = 12,
    width = 12,
    height = 0.02,
    color = {225, 225, 225},
    animation = animation)
    annotation (Placement(transformation(origin = {-54, 74}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedShape2 xAxisReference(
    shapeType = "box",
    r_shape = {0, 0, -0.15},
    lengthDirection = {1, 0, 0},
    widthDirection = {0, 1, 0},
    length = 8,
    width = 0.03,
    height = 0.03,
    color = {220, 40, 40},
    animation = animation)
    annotation (Placement(transformation(origin = {-54, 52}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedShape2 yAxisReference(
    shapeType = "box",
    r_shape = {0, 0, -0.12},
    lengthDirection = {0, 1, 0},
    widthDirection = {1, 0, 0},
    length = 8,
    width = 0.03,
    height = 0.03,
    color = {40, 170, 60},
    animation = animation)
    annotation (Placement(transformation(origin = {-54, 30}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedShape2 gridLineX[5](
    each shapeType = "box",
    r_shape = {{0, -6, -0.185}, {0, -3, -0.185}, {0, 0, -0.185}, {0, 3, -0.185}, {0, 6, -0.185}},
    each lengthDirection = {1, 0, 0},
    each widthDirection = {0, 1, 0},
    each length = 12,
    each width = 0.0125,
    each height = 0.0125,
    color = {{115, 115, 115}, {115, 115, 115}, {150, 150, 150}, {115, 115, 115}, {115, 115, 115}},
    each animation = animation)
    annotation (Placement(transformation(origin = {2, 28}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedShape2 gridLineY[5](
    each shapeType = "box",
    r_shape = {{-6, 0, -0.182}, {-3, 0, -0.182}, {0, 0, -0.182}, {3, 0, -0.182}, {6, 0, -0.182}},
    each lengthDirection = {0, 1, 0},
    each widthDirection = {1, 0, 0},
    each length = 12,
    each width = 0.0125,
    each height = 0.0125,
    color = {{115, 115, 115}, {115, 115, 115}, {150, 150, 150}, {115, 115, 115}, {115, 115, 115}},
    each animation = animation)
    annotation (Placement(transformation(origin = {42, 28}, extent = {{-6, -6}, {6, 6}})));

equation
  connect(frame_a, groundPlatform.frame_a)
    annotation (Line(points = {{-110, 0}, {-74, 0}, {-74, 74}, {-62, 74}}, color = {95, 95, 95}));
  connect(frame_a, xAxisReference.frame_a)
    annotation (Line(points = {{-110, 0}, {-74, 0}, {-74, 52}, {-62, 52}}, color = {95, 95, 95}));
  connect(frame_a, yAxisReference.frame_a)
    annotation (Line(points = {{-110, 0}, {-74, 0}, {-74, 30}, {-62, 30}}, color = {95, 95, 95}));
  for i in 1:5 loop
    connect(frame_a, gridLineX[i].frame_a);
    connect(frame_a, gridLineY[i].frame_a);
  end for;

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {Rectangle(extent = {{-100, 100}, {100, -100}},
        lineColor = {120, 120, 120}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.Solid), Text(extent = {{-86, 24}, {86, -24}},
        textString = "Scene")}),
    Diagram(coordinateSystem(extent = {{-120, -20}, {80, 90}}, grid = {2, 2})));
end SceneReferences;
