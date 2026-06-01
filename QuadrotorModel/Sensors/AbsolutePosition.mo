within QuadrotorModel.Sensors;
    model AbsolutePosition
      "Measure absolute position vector of the origin of a frame connector"
      extends Modelica.Mechanics.MultiBody.Sensors.Internal.PartialAbsoluteSensor;

      Modelica.Blocks.Interfaces.RealOutput r[3](
        each final quantity = "Length",
        each final unit = "m")
        "Absolute position vector resolved in frame defined by resolveInFrame" 
        annotation (Placement(transformation(
          extent = {{-10, -10}, {10, 10}},
          origin = {110, 0})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_resolve frame_resolve if 
        resolveInFrame == Modelica.Mechanics.MultiBody.Types.ResolveInFrameA.frame_resolve
        "Coordinate system in which output vector r is optionally resolved" 
        annotation (Placement(transformation(extent = {{-16, -16}, {16, 16}},
          rotation = -90,
          origin = {0, -100})));

      parameter Modelica.Mechanics.MultiBody.Types.ResolveInFrameA resolveInFrame =
        Modelica.Mechanics.MultiBody.Types.ResolveInFrameA.frame_a
        "Frame in which output vector r shall be resolved (world, frame_a, or frame_resolve)";
    protected
      Modelica.Mechanics.MultiBody.Sensors.Internal.BasicAbsolutePosition position(resolveInFrame = resolveInFrame) 
        annotation (Placement(transformation(extent = {{-10, -10}, {10, 10}})));

      Modelica.Mechanics.MultiBody.Interfaces.ZeroPosition zeroPosition if 
        not (resolveInFrame == Modelica.Mechanics.MultiBody.Types.ResolveInFrameA.frame_resolve) 
        annotation (Placement(transformation(extent = {{20, -40}, {40, -20}})));
    equation
      connect(position.frame_resolve, frame_resolve) annotation (Line(
        points = {{0, -10}, {0, -100}},
        color = {95, 95, 95},
        pattern = LinePattern.Dot));
      connect(zeroPosition.frame_resolve, position.frame_resolve) 
        annotation (Line(
          points = {{20, -30}, {0, -30}, {0, -10}},
          color = {95, 95, 95},
          pattern = LinePattern.Dot));
      connect(position.r, r) annotation (Line(
        points = {{11, 0}, {110, 0}}, color = {0, 0, 127}));
      connect(position.frame_a, frame_a) annotation (Line(
        points = {{-10, 0}, {-100, 0}},
        color = {95, 95, 95},
        thickness = 0.5));
      annotation (Icon(coordinateSystem(
        preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {
        Line(
        points = {{70, 0}, {100, 0}},
        color = {0, 0, 127}),
        Text(
        extent = {{-127, 95}, {134, 143}},
        textString = "%name",
        lineColor = {0, 0, 255}),
        Text(
        extent = {{62, 46}, {146, 16}},
        textString = "r"),
        Text(
        extent = {{15, -67}, {146, -92}},
        lineColor = {95, 95, 95},
        textString = "resolve"),
        Line(
        points = {{0, -96}, {0, -96}, {0, -70}, {0, -70}},
        pattern = LinePattern.Dot)}),
        Documentation(info = "<html>
<p>
The absolute position vector of the origin of frame_a is
determined and provided at the output signal connector <strong>r</strong>.
</p>

<p>
Via parameter <strong>resolveInFrame</strong> it is defined, in which frame
the position vector is resolved:
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr><th><strong>resolveInFrame =<br>Types.ResolveInFrameA.</strong></th><th><strong>Meaning</strong></th></tr>
<tr><td>world</td>
    <td>Resolve vector in world frame</td></tr>

<tr><td>frame_a</td>
    <td>Resolve vector in frame_a</td></tr>

<tr><td>frame_resolve</td>
    <td>Resolve vector in frame_resolve</td></tr>
</table>

<p>
If resolveInFrame = Types.ResolveInFrameA.frame_resolve, the conditional connector
\"frame_resolve\" is enabled and r is resolved in the frame, to
which frame_resolve is connected. Note, if this connector is enabled, it must
be connected.
</p>

<h4>Example</h4>
<p>
If resolveInFrame = Types.ResolveInFrameA.frame_a, the output vector is
computed as:
</p>

<blockquote><pre>
r = MultiBody.Frames.resolve2(frame_a.R, frame_b.r_0);
</pre></blockquote>
</html>"));
    end AbsolutePosition;