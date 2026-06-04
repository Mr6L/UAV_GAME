within QuadrotorModel.PathPlanning;
partial model PartialPositionCommand "位置指令轨迹接口"
  Modelica.Blocks.Interfaces.RealOutput position_command[3] "指令信号--x,y,z" 
    annotation (Placement(transformation(origin = {110, 0},
      extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, 0},
        extent = {{-10, -10}, {10, 10}})));
  annotation(__MWORKS(version="26.2.1"));
end PartialPositionCommand;