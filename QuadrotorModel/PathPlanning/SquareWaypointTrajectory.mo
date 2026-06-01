within QuadrotorModel.PathPlanning;
model SquareWaypointTrajectory "方形航点轨迹"
  extends PartialPositionCommand;

  parameter Real sideLength = 4 "方形边长";
  parameter Modelica.Units.SI.Time segmentDuration = 10 "单边飞行时间";
  parameter Real altitude = 5 "巡航高度";
  parameter Modelica.Units.SI.Time climbDuration = 5 "爬升时间";
  parameter Modelica.Units.SI.Time startTime = 10 "水平轨迹启动时间";

protected
  Real tau;
  Real phaseTime;
equation
  tau = max(time - startTime, 0);
  phaseTime = mod(tau, 4 * segmentDuration);
  position_command[1] =
    if time < startTime then 0 else 
    if phaseTime < segmentDuration then sideLength * phaseTime / segmentDuration else 
    if phaseTime < 2 * segmentDuration then sideLength else 
    if phaseTime < 3 * segmentDuration then sideLength * (1 - (phaseTime - 2 * segmentDuration) / segmentDuration) else 0;
  position_command[2] =
    if time < startTime then 0 else 
    if phaseTime < segmentDuration then 0 else 
    if phaseTime < 2 * segmentDuration then sideLength * (phaseTime - segmentDuration) / segmentDuration else 
    if phaseTime < 3 * segmentDuration then sideLength else sideLength * (1 - (phaseTime - 3 * segmentDuration) / segmentDuration);
  position_command[3] = if time < climbDuration then altitude * time / climbDuration else altitude;

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {2, 2}),
      graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}},
        radius = 25), Rectangle(extent = {{-55, 55}, {55, -55}}, lineColor = {120, 120, 120})}));
end SquareWaypointTrajectory;