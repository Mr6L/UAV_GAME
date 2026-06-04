within QuadrotorModel.Disturbances;
model SustainedLateralWind "持续横向风扰"
  parameter Real lateralForce = 0.03 "横向持续扰动力";
  parameter Modelica.Units.SI.Time startTime = 12 "扰动开始时间";
  Modelica.Blocks.Interfaces.RealOutput force[3] "外部扰动力" annotation (
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression fx(
    y = if time < startTime then 0 else lateralForce) 
    annotation (Placement(transformation(origin = {-34, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant fy(k = 0) 
    annotation (Placement(transformation(origin = {-34, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant fz(k = 0) 
    annotation (Placement(transformation(origin = {-34, -40}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(fx.y, force[1]) annotation (Line(points = {{-23, 40}, {70, 40}, {70, 0}, {110, 0}},
    color = {0, 0, 127}));
  connect(fy.y, force[2]) annotation (Line(points = {{-23, 0}, {110, 0}},
    color = {0, 0, 127}));
  connect(fz.y, force[3]) annotation (Line(points = {{-23, -40}, {70, -40}, {70, 0}, {110, 0}},
    color = {0, 0, 127}));

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {2, 2}),
      graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}},
        radius = 25), Line(points = {{-70, 0}, {60, 0}}, color = {0, 0, 200},
        thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(extent = {{-54, 46}, {54, 16}},
        textString = "Wind")}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {2, 2})),__MWORKS(version="26.2.1"));
end SustainedLateralWind;