within QuadrotorModel.PathPlanning;
model STrajectory "S型轨迹"
  extends PartialPositionCommand;

  parameter Real forwardSpeed = 0.5 "x方向速度";
  parameter Real amplitude = 3 "y方向幅值";
  parameter Real frequency = 0.025 "S型横向频率";
  parameter Real altitude = 5 "巡航高度";
  parameter Modelica.Units.SI.Time climbDuration = 5 "爬升时间";
  parameter Modelica.Units.SI.Time startTime = 10 "水平轨迹启动时间";

protected
  constant Real pi = Modelica.Constants.pi;
  Real tau;
equation
  tau = max(time - startTime, 0);
  position_command[1] = if time < startTime then 0 else forwardSpeed * tau;
  position_command[2] = if time < startTime then 0 else amplitude * sin(2 * pi * frequency * tau);
  position_command[3] = if time < climbDuration then altitude * time / climbDuration else altitude;

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {2, 2}),
      graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}},
        radius = 25), Line(points = {{-70, -30}, {-35, 35}, {0, -30}, {35, 35}, {70, -30}},
        color = {120, 120, 120}, smooth = Smooth.Bezier)}));
end STrajectory;