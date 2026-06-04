within QuadrotorModel.Formations;
block SmoothFormationSwitch "两种队形偏移的平滑切换"
  parameter Integer n(min = 1, max = 5) = 5 "无人机数量";
  parameter Real fromOffsets[n, 3] "初始队形偏移";
  parameter Real toOffsets[n, 3] "目标队形偏移";
  parameter Modelica.Units.SI.Time startTime = 20 "切换开始时间";
  parameter Modelica.Units.SI.Time duration = 10 "切换持续时间";

  Modelica.Blocks.Interfaces.RealOutput offsets[n, 3] "平滑过渡后的队形偏移" 
    annotation (Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

protected
  Real tau;
  Real blend;

equation
  tau = min(max((time - startTime) / max(duration, 1e-6), 0), 1);
  blend = tau * tau * (3 - 2 * tau);
  for i in 1:n loop
    for j in 1:3 loop
      offsets[i, j] = (1 - blend) * fromOffsets[i, j] + blend * toOffsets[i, j];
    end for;
  end for;

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, radius = 20,
        lineColor = {120, 120, 120}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.Solid), Text(extent = {{-86, 24}, {86, -24}},
        textString = "Switch")}),__MWORKS(version="26.2.1"));
end SmoothFormationSwitch;