within QuadrotorModel.Sensors;
    model AbsoluteAngles
      "Measure absolute angles between frame connector and the world frame"
      extends Modelica.Mechanics.MultiBody.Sensors.Internal.PartialAbsoluteSensor;
      import SI = Modelica.SIunits;
      Modelica.Blocks.Interfaces.RealOutput angles[3](
        each final quantity = "Angle",
        each final unit = "rad",
        each displayUnit = "deg")
        "Angles to rotate world frame into frame_a via 'sequence'" 
        annotation (Placement(transformation(
          origin = {110, 0},
          extent = {{-10, -10}, {10, 10}})));
      parameter Modelica.Mechanics.MultiBody.Types.RotationSequence sequence(
        min = {1, 1, 1},
        max = {3, 3, 3}) = {1, 2, 3}
        "Angles are returned to rotate world frame around axes sequence[1], sequence[2] and finally sequence[3] into frame_a" 
        annotation (Evaluate = true);
      parameter Modelica.Units.SI.Angle guessAngle1 = 0
        "Select angles[1] such that abs(angles[1] - guessAngle1) is a minimum";
    equation
      frame_a.f = zeros(3);
      frame_a.t = zeros(3);
      angles = Modelica.Mechanics.MultiBody.Frames.axesRotationsAngles(
        frame_a.R,
        sequence,
        guessAngle1);
      annotation (Icon(coordinateSystem(extent = {{-100.0, -100.0}, {100.0, 100.0}},
        grid = {2.0, 2.0}), graphics = {Text(origin = {4.5, 122.0},
        lineColor = {0, 0, 255},
        extent = {{-130.5, -24.0}, {130.5, 24.0}},
        textString = "%name",
        textStyle = {TextStyle.None},
        textColor = {0, 0, 255}), Line(origin = {85.0, 0.0},
        points = {{-15.0, 0.0}, {15.0, 0.0}},
        color = {0, 0, 127}), Text(origin = {117.0, -33.0},
        extent = {{-55.0, 11.0}, {55.0, -11.0}},
        textString = "angles")}),
        Documentation(info = "<html>
<p>
This model determines the 3 angles to rotate the world frame
into frame_a along the axes defined by parameter <strong>sequence</strong>.
For example, if sequence = {3,1,2} then the world frame is
rotated around angles[1] along the z-axis, afterwards it is rotated
around angles[2] along the x-axis, and finally it is rotated around
angles[3] along the y-axis and is then identical to frame_a.
The 3 angles are returned in the range
</p>
<pre>
    -<font face=\"Symbol\">p</font> &lt;= angles[i] &lt;= <font face=\"Symbol\">p</font>
</pre>
<p>
There are <strong>two solutions</strong> for \"angles[1]\" in this range.
Via parameter <strong>guessAngle1</strong> (default = 0) the
returned solution is selected such that |angles[1] - guessAngle1| is
minimal. The transformation matrix between the world frame and
frame_a may be in a singular configuration with respect to \"sequence\", i.e.,
there is an infinite number of angle values leading to the same relative
transformation matrix. In this case, the returned solution is
selected by setting angles[1] = guessAngle1. Then angles[2]
and angles[3] can be uniquely determined in the above range.
</p>
<p>
The parameter <strong>sequence</strong> has the restriction that
only values 1,2,3 can be used and that sequence[1] &ne; sequence[2]
and sequence[2] &ne; sequence[3]. Often used values are:
</p>
<pre>
  sequence = <strong>{1,2,3}</strong>  // Cardan or Tait-Bryan angle sequence
           = <strong>{3,1,3}</strong>  // Euler angle sequence
           = <strong>{3,2,1}</strong>
</pre>
</html>"));
    end AbsoluteAngles;