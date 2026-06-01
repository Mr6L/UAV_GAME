within QuadrotorModel;
  package GroundModel "地面模型"

    annotation (Diagram(coordinateSystem(extent = {{-100.0, -100.0}, {100.0, 100.0}},
      grid = {2.0, 2.0})),
      Icon(coordinateSystem(extent = {{-100.0, -100.0}, {100.0, 100.0}},
        preserveAspectRatio = false,
        grid = {2.0, 2.0}), graphics = {Line(origin = {2.0, 0.0},
        points = {{-62.0, 0.0}, {62.0, 0.0}}), Line(origin = {0.0, -20.0},
        points = {{-40.0, 0.0}, {40.0, 0.0}}), Line(origin = {0.0, -40.0},
        points = {{-20.0, 0.0}, {20.0, 0.0}}), Ellipse(origin = {1.0, 21.0},
        fillColor = {255, 255, 255},
        extent = {{-21.0, 21.0}, {21.0, -21.0}})}));
    extends Modelica.Icons.Package;
  end GroundModel;