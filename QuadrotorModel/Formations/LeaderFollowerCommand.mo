within QuadrotorModel.Formations;
block LeaderFollowerCommand "leader-follower 位置指令生成"
  parameter Integer n(min = 1, max = 5) = 3 "无人机数量";

  Modelica.Blocks.Interfaces.RealInput leader_command[3] "leader期望位置"
    annotation (Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput offsets[n, 3] "相对leader的队形偏移"
    annotation (Placement(transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput position_command[n, 3] "每架无人机期望位置"
    annotation (Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

equation
  for i in 1:n loop
    for j in 1:3 loop
      position_command[i, j] = leader_command[j] + offsets[i, j];
    end for;
  end for;

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, radius = 20,
        lineColor = {120, 120, 120}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.Solid), Text(extent = {{-88, 24}, {88, -24}},
        textString = "LF Cmd")}));
end LeaderFollowerCommand;
