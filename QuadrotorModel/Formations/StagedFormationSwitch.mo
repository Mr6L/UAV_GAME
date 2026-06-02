within QuadrotorModel.Formations;
block StagedFormationSwitch "Three-stage smooth formation switch"
  parameter Integer n(min = 1, max = 5) = 5 "Number of UAVs";
  parameter Real fromOffsets[n, 3] "Initial formation offsets";
  parameter Real middleOffsets[n, 3] "Middle formation offsets";
  parameter Real toOffsets[n, 3] "Final formation offsets";
  parameter Modelica.Units.SI.Time firstStartTime = 20 "First switch start time";
  parameter Modelica.Units.SI.Time firstDuration = 10 "First switch duration";
  parameter Modelica.Units.SI.Time secondStartTime = 50 "Second switch start time";
  parameter Modelica.Units.SI.Time secondDuration = 10 "Second switch duration";

  Modelica.Blocks.Interfaces.RealOutput offsets[n, 3] "Smoothed formation offsets"
    annotation (Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

protected
  Real tau1;
  Real tau2;
  Real blend1;
  Real blend2;
  Real middleState[n, 3];

equation
  tau1 = min(max((time - firstStartTime) / max(firstDuration, 1e-6), 0), 1);
  tau2 = min(max((time - secondStartTime) / max(secondDuration, 1e-6), 0), 1);
  blend1 = tau1 * tau1 * (3 - 2 * tau1);
  blend2 = tau2 * tau2 * (3 - 2 * tau2);

  for i in 1:n loop
    for j in 1:3 loop
      middleState[i, j] = (1 - blend1) * fromOffsets[i, j] + blend1 * middleOffsets[i, j];
      offsets[i, j] = if time < secondStartTime then middleState[i, j] else
        (1 - blend2) * middleOffsets[i, j] + blend2 * toOffsets[i, j];
    end for;
  end for;

  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, radius = 20,
        lineColor = {120, 120, 120}, fillColor = {248, 248, 248},
        fillPattern = FillPattern.Solid), Text(extent = {{-86, 24}, {86, -24}},
        textString = "3-Stage")}));
end StagedFormationSwitch;
