within QuadrotorModel.Formations;
block FormationOffsets "固定队形偏移生成器"
  parameter Integer n(min = 1, max = 5) = 3 "无人机数量";
  parameter Integer formationType(min = 1, max = 4) = 1 "1三角 2菱形 3V字 4横队";
  parameter Real spacing = 2 "队形间距";

  Modelica.Blocks.Interfaces.RealOutput offsets[n, 3] "每架无人机相对leader的偏移"
    annotation (Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

protected
  Real rawOffsets[n, 3];
  Real center[3];

equation
  for i in 1:n loop
    rawOffsets[i, 1] =
      if formationType == 1 then
        (if i == 1 then 0 else -spacing)
      elseif formationType == 2 then
        (if i == 1 then 0 elseif i == 2 then -spacing elseif i == 3 then -spacing elseif i == 4 then -2 * spacing else -spacing)
      elseif formationType == 3 then
        (if i == 1 then 0 elseif i <= 3 then -spacing else -2 * spacing)
      else
        -(i - 1) * spacing;

    rawOffsets[i, 2] =
      if formationType == 1 then
        (if i == 1 then 0 elseif i == 2 then -spacing else spacing)
      elseif formationType == 2 then
        (if i == 1 then 0 elseif i == 2 then -spacing elseif i == 3 then spacing elseif i == 4 then 0 else 0)
      elseif formationType == 3 then
        (if i == 1 then 0 elseif i == 2 then -0.75 * spacing elseif i == 3 then 0.75 * spacing elseif i == 4 then -1.5 * spacing else 1.5 * spacing)
      else
        0;

    rawOffsets[i, 3] = 0;
  end for;

  for j in 1:3 loop
    center[j] = sum(rawOffsets[i, j] for i in 1:n) / n;
    for i in 1:n loop
      offsets[i, j] = rawOffsets[i, j] - center[j];
    end for;
  end for;

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, radius = 20,
        lineColor = {120, 120, 120}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.Solid), Text(extent = {{-82, 24}, {82, -24}},
        textString = "Offsets")}));
end FormationOffsets;
