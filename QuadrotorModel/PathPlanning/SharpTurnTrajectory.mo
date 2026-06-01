within QuadrotorModel.PathPlanning;
model SharpTurnTrajectory "急转弯轨迹"
  extends PartialPositionCommand;

  parameter Real speed = 0.6 "直线段速度";
  parameter Real firstLegLength = 5 "第一直线段长度";
  parameter Real secondLegLength = 5 "第二直线段长度";
  parameter Real altitude = 5 "巡航高度";
  parameter Modelica.Units.SI.Time climbDuration = 5 "爬升时间";
  parameter Modelica.Units.SI.Time startTime = 10 "水平轨迹启动时间";

protected
  Real tau;
  Real turnTime;
  Real secondTau;
equation
  tau = max(time - startTime, 0);
  turnTime = firstLegLength / speed;
  secondTau = max(tau - turnTime, 0);
  position_command[1] = if time < startTime then 0 else min(speed * tau, firstLegLength);
  position_command[2] = if time < startTime then 0 else min(speed * secondTau, secondLegLength);
  position_command[3] = if time < climbDuration then altitude * time / climbDuration else altitude;

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {2, 2}),
      graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}},
        radius = 25), Line(points = {{-65, -45}, {20, -45}, {20, 55}}, color = {120, 120, 120},
        thickness = 0.5, arrow = {Arrow.None, Arrow.Filled})}));
end SharpTurnTrajectory;