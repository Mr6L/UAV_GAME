within QuadrotorModel.PathPlanning;
model CircularTrajectory "定高圆形轨迹"
  extends PartialPositionCommand;

  parameter Real radius = 4 "圆形轨迹半径";
  parameter Real frequency = 0.025 "圆周频率";
  parameter Real altitude = 5 "巡航高度";
  parameter Modelica.Units.SI.Time climbDuration = 5 "爬升时间";
  parameter Modelica.Units.SI.Time startTime = 10 "水平轨迹启动时间";

protected
  constant Real pi = Modelica.Constants.pi;
  Real tau;
  Real theta;
equation
  tau = max(time - startTime, 0);
  theta = 2 * pi * frequency * tau;
  position_command[1] = if time < startTime then 0 else radius * sin(theta);
  position_command[2] = if time < startTime then 0 else radius * (1 - cos(theta));
  position_command[3] = if time < climbDuration then altitude * time / climbDuration else altitude;

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {2, 2}),
      graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}},
        radius = 25), Ellipse(extent = {{-60, 60}, {60, -60}}, lineColor = {120, 120, 120})}));
end CircularTrajectory;