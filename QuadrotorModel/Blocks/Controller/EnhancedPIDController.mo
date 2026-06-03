within QuadrotorModel.Blocks.Controller;
model EnhancedPIDController "6-DOF controller using enhanced PID Sysblock modules"
  extends ModelWorkspace;
  import SysplorerEmbeddedCoder.Types.*;
  import BaseWorkspace.*;
  annotation(__MWORKS(version = "26.2.1",PortArrangement(Left(positionCommandX, positionCommandY, positionCommandZ, yawCommand, positionX, positionY, positionZ, rollAngle, pitchAngle, yawAngle), Right(y, y1, y2, y3)),modelType = Control,BlockSystem(blockKind=BlockKind.userModel,SampleTime(auto=true,group="")=0.02,OutputInterval=0.02),SysblockVersion = "1.0"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {80, 120, 160}, fillColor = {245, 250, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-88, 28}, {88, -28}}, textString = "Enhanced PID")}),
    Diagram(coordinateSystem(extent = {{-260, -220}, {260, 220}}, grid = {2, 2})));

  SysplorerEmbeddedCoder.Port.Inport positionCommandX "Position command x" 
    annotation (Placement(transformation(origin = {-250, 150}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),Dimension(dimensionType=DimensionType.none)=1,SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Port.Inport positionCommandY "Position command y" 
    annotation (Placement(transformation(origin = {-250, 120}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),Dimension(dimensionType=DimensionType.none)=1,SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Port.Inport positionCommandZ "Position command z" 
    annotation (Placement(transformation(origin = {-250, 90}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),Dimension(dimensionType=DimensionType.none)=1,SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Port.Inport yawCommand "Yaw command" 
    annotation (Placement(transformation(origin = {-250, 60}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),Dimension(dimensionType=DimensionType.none)=1,SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Port.Inport positionX "Measured position x" 
    annotation (Placement(transformation(origin = {-250, 20}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),Dimension(dimensionType=DimensionType.none)=1,SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Port.Inport positionY "Measured position y" 
    annotation (Placement(transformation(origin = {-250, -10}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),Dimension(dimensionType=DimensionType.none)=1,SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Port.Inport positionZ "Measured position z" 
    annotation (Placement(transformation(origin = {-250, -40}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),Dimension(dimensionType=DimensionType.none)=1,SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Port.Inport rollAngle "Measured roll angle" 
    annotation (Placement(transformation(origin = {-250, -80}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),Dimension(dimensionType=DimensionType.none)=1,SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Port.Inport pitchAngle "Measured pitch angle" 
    annotation (Placement(transformation(origin = {-250, -110}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),Dimension(dimensionType=DimensionType.none)=1,SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Port.Inport yawAngle "Measured yaw angle" 
    annotation (Placement(transformation(origin = {-250, -140}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),Dimension(dimensionType=DimensionType.none)=1,SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Port.Outport y "Motor 1 command" 
    annotation (Placement(transformation(origin = {250, 90}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Outport y1 "Motor 2 command" 
    annotation (Placement(transformation(origin = {250, 30}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Outport y2 "Motor 3 command" 
    annotation (Placement(transformation(origin = {250, -30}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Outport y3 "Motor 4 command" 
    annotation (Placement(transformation(origin = {250, -90}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));

  SysplorerEmbeddedCoder.Sources.Constant yawKpSignal(k = yawKP) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawKiSignal(k = yawKI) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawKdSignal(k = yawKD) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawBetaSignal(k = 1) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawGammaSignal(k = 0) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawIntegralEnableSignal(k = yawIntegralEnableError) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawOutputMaxSignal(k = yawOutputMax) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawOutputMinSignal(k = -yawOutputMax) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawKawSignal(k = yawKaw) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawZeroIntegralSignal(k = 0) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product yawBetaProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum yawPErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product yawPProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum yawErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Abs yawAbsError 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator yawIntegralEnableCompare(op = SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator.Operators.LE) 
    annotation (__MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.SignalRouting.Switch yawIntegralSeparationSwitch(ct = SysplorerEmbeddedCoder.SignalRouting.Switch.ConditionType.GE, threshold = 0.5) 
    annotation (__MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="boolean"),Dimension=1),
u3(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
threshold(Type(ref="boolean"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product yawKiProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum yawIntegratorInputSum(inputs = "++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Continuous.Integrator yawITermIntegrator(externalResetType = SysplorerEmbeddedCoder.Continuous.Integrator.ExternalResetType.None, initCond = 0, zeroCross = true, limitOutput = false) 
    annotation (__MWORKS(BlockSystem(zeroCross=true,Instance(u1(Dimension=1),
y(Dimension=1),
initCond(Dimension=1),
absoluteTolerance(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product yawGammaProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum yawDErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Continuous.Derivative yawFilteredDerivative(CoeffcientInTFapproximation = 50) 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product yawDProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum yawRawControlSum(inputs = "+++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Discontinuities.SaturationDynamic yawOutputSaturation 
    annotation (__MWORKS(BlockSystem(Instance(upperLimit(Type(ref="double"),Dimension=1),
u(Type(ref="double"),Dimension=1),
lowerLimit(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum yawSaturationErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product yawAntiWindupProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));

  SysplorerEmbeddedCoder.Sources.Constant xPositionKpSignal(k = lateralPositionKP) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant xPositionKiSignal(k = lateralPositionKI) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant xPositionKdSignal(k = lateralPositionKD) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant xPositionBetaSignal(k = 1) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant xPositionGammaSignal(k = 0) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant xPositionIntegralEnableSignal(k = lateralPositionIntegralEnableError) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant xPositionOutputMaxSignal(k = maxCommandedAngle) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant xPositionOutputMinSignal(k = -maxCommandedAngle) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant xPositionKawSignal(k = lateralPositionKaw) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant xPositionZeroIntegralSignal(k = 0) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product xPositionBetaProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum xPositionPErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product xPositionPProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum xPositionErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Abs xPositionAbsError 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator xPositionIntegralEnableCompare(op = SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator.Operators.LE) 
    annotation (__MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.SignalRouting.Switch xPositionIntegralSeparationSwitch(ct = SysplorerEmbeddedCoder.SignalRouting.Switch.ConditionType.GE, threshold = 0.5) 
    annotation (__MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="boolean"),Dimension=1),
u3(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
threshold(Type(ref="boolean"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product xPositionKiProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum xPositionIntegratorInputSum(inputs = "++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Continuous.Integrator xPositionITermIntegrator(externalResetType = SysplorerEmbeddedCoder.Continuous.Integrator.ExternalResetType.None, initCond = 0, zeroCross = true, limitOutput = false) 
    annotation (__MWORKS(BlockSystem(zeroCross=true,Instance(u1(Dimension=1),
y(Dimension=1),
initCond(Dimension=1),
absoluteTolerance(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product xPositionGammaProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum xPositionDErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Continuous.Derivative xPositionFilteredDerivative(CoeffcientInTFapproximation = 50) 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product xPositionDProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum xPositionRawControlSum(inputs = "+++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Discontinuities.SaturationDynamic xPositionOutputSaturation 
    annotation (__MWORKS(BlockSystem(Instance(upperLimit(Type(ref="double"),Dimension=1),
u(Type(ref="double"),Dimension=1),
lowerLimit(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum xPositionSaturationErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product xPositionAntiWindupProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));

  SysplorerEmbeddedCoder.Sources.Constant yPositionKpSignal(k = lateralPositionKP) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yPositionKiSignal(k = lateralPositionKI) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yPositionKdSignal(k = lateralPositionKD) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yPositionBetaSignal(k = 1) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yPositionGammaSignal(k = 0) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yPositionIntegralEnableSignal(k = lateralPositionIntegralEnableError) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yPositionOutputMaxSignal(k = maxCommandedAngle) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yPositionOutputMinSignal(k = -maxCommandedAngle) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yPositionKawSignal(k = lateralPositionKaw) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yPositionZeroIntegralSignal(k = 0) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product yPositionBetaProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum yPositionPErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product yPositionPProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum yPositionErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Abs yPositionAbsError 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator yPositionIntegralEnableCompare(op = SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator.Operators.LE) 
    annotation (__MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.SignalRouting.Switch yPositionIntegralSeparationSwitch(ct = SysplorerEmbeddedCoder.SignalRouting.Switch.ConditionType.GE, threshold = 0.5) 
    annotation (__MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="boolean"),Dimension=1),
u3(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
threshold(Type(ref="boolean"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product yPositionKiProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum yPositionIntegratorInputSum(inputs = "++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Continuous.Integrator yPositionITermIntegrator(externalResetType = SysplorerEmbeddedCoder.Continuous.Integrator.ExternalResetType.None, initCond = 0, zeroCross = true, limitOutput = false) 
    annotation (__MWORKS(BlockSystem(zeroCross=true,Instance(u1(Dimension=1),
y(Dimension=1),
initCond(Dimension=1),
absoluteTolerance(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product yPositionGammaProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum yPositionDErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Continuous.Derivative yPositionFilteredDerivative(CoeffcientInTFapproximation = 50) 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product yPositionDProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum yPositionRawControlSum(inputs = "+++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Discontinuities.SaturationDynamic yPositionOutputSaturation 
    annotation (__MWORKS(BlockSystem(Instance(upperLimit(Type(ref="double"),Dimension=1),
u(Type(ref="double"),Dimension=1),
lowerLimit(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum yPositionSaturationErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product yPositionAntiWindupProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));

  SysplorerEmbeddedCoder.Sources.Constant heightKpSignal(k = heightKP) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightKiSignal(k = heightKI) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightKdSignal(k = heightKD) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightBetaSignal(k = 1) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightGammaSignal(k = 0) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightIntegralEnableSignal(k = heightIntegralEnableError) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightOutputMaxSignal(k = heightOutputMax) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightOutputMinSignal(k = -heightOutputMax) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightKawSignal(k = heightKaw) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightZeroIntegralSignal(k = 0) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product heightBetaProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum heightPErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product heightPProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum heightErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Abs heightAbsError 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator heightIntegralEnableCompare(op = SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator.Operators.LE) 
    annotation (__MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.SignalRouting.Switch heightIntegralSeparationSwitch(ct = SysplorerEmbeddedCoder.SignalRouting.Switch.ConditionType.GE, threshold = 0.5) 
    annotation (__MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="boolean"),Dimension=1),
u3(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
threshold(Type(ref="boolean"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product heightKiProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum heightIntegratorInputSum(inputs = "++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Continuous.Integrator heightITermIntegrator(externalResetType = SysplorerEmbeddedCoder.Continuous.Integrator.ExternalResetType.None, initCond = 0, zeroCross = true, limitOutput = false) 
    annotation (__MWORKS(BlockSystem(zeroCross=true,Instance(u1(Dimension=1),
y(Dimension=1),
initCond(Dimension=1),
absoluteTolerance(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product heightGammaProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum heightDErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Continuous.Derivative heightFilteredDerivative(CoeffcientInTFapproximation = 50) 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product heightDProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum heightRawControlSum(inputs = "+++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Discontinuities.SaturationDynamic heightOutputSaturation 
    annotation (__MWORKS(BlockSystem(Instance(upperLimit(Type(ref="double"),Dimension=1),
u(Type(ref="double"),Dimension=1),
lowerLimit(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum heightSaturationErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product heightAntiWindupProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));

  SysplorerEmbeddedCoder.Sources.Constant pitchKpSignal(k = attitudeKP) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant pitchKiSignal(k = attitudeKI) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant pitchKdSignal(k = attitudeKD) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant pitchBetaSignal(k = 1) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant pitchGammaSignal(k = 0) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant pitchIntegralEnableSignal(k = attitudeIntegralEnableError) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant pitchOutputMaxSignal(k = attitudeOutputMax) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant pitchOutputMinSignal(k = -attitudeOutputMax) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant pitchKawSignal(k = attitudeKaw) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant pitchZeroIntegralSignal(k = 0) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product pitchBetaProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum pitchPErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product pitchPProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum pitchErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Abs pitchAbsError 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator pitchIntegralEnableCompare(op = SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator.Operators.LE) 
    annotation (__MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.SignalRouting.Switch pitchIntegralSeparationSwitch(ct = SysplorerEmbeddedCoder.SignalRouting.Switch.ConditionType.GE, threshold = 0.5) 
    annotation (__MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="boolean"),Dimension=1),
u3(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
threshold(Type(ref="boolean"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product pitchKiProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum pitchIntegratorInputSum(inputs = "++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Continuous.Integrator pitchITermIntegrator(externalResetType = SysplorerEmbeddedCoder.Continuous.Integrator.ExternalResetType.None, initCond = 0, zeroCross = true, limitOutput = false) 
    annotation (__MWORKS(BlockSystem(zeroCross=true,Instance(u1(Dimension=1),
y(Dimension=1),
initCond(Dimension=1),
absoluteTolerance(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product pitchGammaProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum pitchDErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Continuous.Derivative pitchFilteredDerivative(CoeffcientInTFapproximation = 50) 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product pitchDProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum pitchRawControlSum(inputs = "+++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Discontinuities.SaturationDynamic pitchOutputSaturation 
    annotation (__MWORKS(BlockSystem(Instance(upperLimit(Type(ref="double"),Dimension=1),
u(Type(ref="double"),Dimension=1),
lowerLimit(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum pitchSaturationErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product pitchAntiWindupProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));

  SysplorerEmbeddedCoder.Sources.Constant rollKpSignal(k = attitudeKP) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant rollKiSignal(k = attitudeKI) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant rollKdSignal(k = attitudeKD) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant rollBetaSignal(k = 1) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant rollGammaSignal(k = 0) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant rollIntegralEnableSignal(k = attitudeIntegralEnableError) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant rollOutputMaxSignal(k = attitudeOutputMax) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant rollOutputMinSignal(k = -attitudeOutputMax) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant rollKawSignal(k = attitudeKaw) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant rollZeroIntegralSignal(k = 0) 
    annotation (__MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product rollBetaProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum rollPErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product rollPProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum rollErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Abs rollAbsError 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator rollIntegralEnableCompare(op = SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator.Operators.LE) 
    annotation (__MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.SignalRouting.Switch rollIntegralSeparationSwitch(ct = SysplorerEmbeddedCoder.SignalRouting.Switch.ConditionType.GE, threshold = 0.5) 
    annotation (__MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="boolean"),Dimension=1),
u3(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
threshold(Type(ref="boolean"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product rollKiProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum rollIntegratorInputSum(inputs = "++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Continuous.Integrator rollITermIntegrator(externalResetType = SysplorerEmbeddedCoder.Continuous.Integrator.ExternalResetType.None, initCond = 0, zeroCross = true, limitOutput = false) 
    annotation (__MWORKS(BlockSystem(zeroCross=true,Instance(u1(Dimension=1),
y(Dimension=1),
initCond(Dimension=1),
absoluteTolerance(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product rollGammaProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum rollDErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Continuous.Derivative rollFilteredDerivative(CoeffcientInTFapproximation = 50) 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product rollDProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum rollRawControlSum(inputs = "+++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Discontinuities.SaturationDynamic rollOutputSaturation 
    annotation (__MWORKS(BlockSystem(Instance(upperLimit(Type(ref="double"),Dimension=1),
u(Type(ref="double"),Dimension=1),
lowerLimit(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum rollSaturationErrorSum(inputs = "+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product rollAntiWindupProduct 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));

  SysplorerEmbeddedCoder.MathOperation.Gain rollMeasurementSign(k = -1) 
    annotation (Placement(transformation(origin = {-92, -72}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Gain yawMixGain(k = 0.707) 
    annotation (Placement(transformation(origin = {36, 120}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Gain pitchMixGain(k = 0.707) 
    annotation (Placement(transformation(origin = {36, 40}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Gain rollMixGain(k = 0.707) 
    annotation (Placement(transformation(origin = {36, -40}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));

  SysplorerEmbeddedCoder.MathOperation.Sum motor1Attitude(inputs = "--+", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor2Attitude(inputs = "+--", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor3Attitude(inputs = "-+-", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor4Attitude(inputs = "+++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));

  SysplorerEmbeddedCoder.MathOperation.Sum motor1Command(inputs = "++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor2Command(inputs = "++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor3Command(inputs = "++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor4Command(inputs = "++", isSaturate = false) 
    annotation (__MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));

  SysplorerEmbeddedCoder.MathOperation.Gain motor1Sign(k = 1) 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Gain motor2Sign(k = -1) 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Gain motor3Sign(k = 1) 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Gain motor4Sign(k = -1) 
    annotation (__MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));

  model ModelWorkspace
    annotation(__MWORKS(hide = true, BlockSystem(blockKind = BlockKind.modelWorkspace)));
    parameter RealAuto yawKP = 5 "Yaw loop proportional gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto yawKI = 0 "Yaw loop integral gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto yawKD = 0 "Yaw loop derivative gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto yawOutputMax = 7 "Yaw loop mixed-channel limit" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto yawIntegralEnableError = 0.3 "Yaw integral separation threshold" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto yawKaw = 1 "Yaw anti-windup back-calculation gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionKP = 0.15 "Position loop proportional gain, including angle conversion" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionKI = 0 "Position loop integral gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionKD = 0.1 "Position loop derivative gain, including angle conversion" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionIntegralEnableError = 0.5 "Position loop integral separation threshold" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto maxCommandedAngle = 15 / 57.3 "Outer-loop attitude command limit" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionKaw = 1 "Position loop anti-windup back-calculation gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeKP = 14.142 "Attitude loop proportional gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeKI = 0 "Attitude loop integral gain kept zero in the first version" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeKD = 1.414 "Attitude loop derivative gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeOutputMax = 7 "Attitude loop mixed-channel limit" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeIntegralEnableError = 0.2 "Attitude loop integral separation threshold" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeKaw = 1 "Attitude loop anti-windup back-calculation gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightKP = 8 "Height loop proportional gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightKI = 6 "Height loop integral gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightKD = 4 "Height loop derivative gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightOutputMax = 1e6 "Loose first-pass height correction limit" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightIntegralEnableError = 0.5 "Height integral separation threshold" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightKaw = 1 "Height loop anti-windup back-calculation gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
  end ModelWorkspace;

equation
  connect(yawCommand, yawErrorSum.u1);
  connect(yawAngle, yawErrorSum.u2);
  connect(yawErrorSum.y, yawAbsError.u);
  connect(yawAbsError.y, yawIntegralEnableCompare.u1);
  connect(yawIntegralEnableSignal.y, yawIntegralEnableCompare.u2);
  connect(yawErrorSum.y, yawIntegralSeparationSwitch.u1);
  connect(yawIntegralEnableCompare.y, yawIntegralSeparationSwitch.u2);
  connect(yawZeroIntegralSignal.y, yawIntegralSeparationSwitch.u3);
  connect(yawIntegralSeparationSwitch.y, yawKiProduct.u1);
  connect(yawKiSignal.y, yawKiProduct.u2);
  connect(yawKiProduct.y, yawIntegratorInputSum.u1);
  connect(yawIntegratorInputSum.y, yawITermIntegrator.u1);
  connect(yawITermIntegrator.y, yawRawControlSum.u2);

  connect(yawCommand, yawBetaProduct.u1);
  connect(yawBetaSignal.y, yawBetaProduct.u2);
  connect(yawBetaProduct.y, yawPErrorSum.u1);
  connect(yawAngle, yawPErrorSum.u2);
  connect(yawPErrorSum.y, yawPProduct.u1);
  connect(yawKpSignal.y, yawPProduct.u2);
  connect(yawPProduct.y, yawRawControlSum.u1);

  connect(yawCommand, yawGammaProduct.u1);
  connect(yawGammaSignal.y, yawGammaProduct.u2);
  connect(yawGammaProduct.y, yawDErrorSum.u1);
  connect(yawAngle, yawDErrorSum.u2);
  connect(yawDErrorSum.y, yawFilteredDerivative.u);
  connect(yawFilteredDerivative.y, yawDProduct.u1);
  connect(yawKdSignal.y, yawDProduct.u2);
  connect(yawDProduct.y, yawRawControlSum.u3);

  connect(yawRawControlSum.y, yawOutputSaturation.u);
  connect(yawOutputMaxSignal.y, yawOutputSaturation.upperLimit);
  connect(yawOutputMinSignal.y, yawOutputSaturation.lowerLimit);
  connect(yawOutputSaturation.y, yawSaturationErrorSum.u1);
  connect(yawRawControlSum.y, yawSaturationErrorSum.u2);
  connect(yawSaturationErrorSum.y, yawAntiWindupProduct.u1);
  connect(yawKawSignal.y, yawAntiWindupProduct.u2);
  connect(yawAntiWindupProduct.y, yawIntegratorInputSum.u2);

  connect(positionCommandX, xPositionErrorSum.u1);
  connect(positionX, xPositionErrorSum.u2);
  connect(xPositionErrorSum.y, xPositionAbsError.u);
  connect(xPositionAbsError.y, xPositionIntegralEnableCompare.u1);
  connect(xPositionIntegralEnableSignal.y, xPositionIntegralEnableCompare.u2);
  connect(xPositionErrorSum.y, xPositionIntegralSeparationSwitch.u1);
  connect(xPositionIntegralEnableCompare.y, xPositionIntegralSeparationSwitch.u2);
  connect(xPositionZeroIntegralSignal.y, xPositionIntegralSeparationSwitch.u3);
  connect(xPositionIntegralSeparationSwitch.y, xPositionKiProduct.u1);
  connect(xPositionKiSignal.y, xPositionKiProduct.u2);
  connect(xPositionKiProduct.y, xPositionIntegratorInputSum.u1);
  connect(xPositionIntegratorInputSum.y, xPositionITermIntegrator.u1);
  connect(xPositionITermIntegrator.y, xPositionRawControlSum.u2);

  connect(positionCommandX, xPositionBetaProduct.u1);
  connect(xPositionBetaSignal.y, xPositionBetaProduct.u2);
  connect(xPositionBetaProduct.y, xPositionPErrorSum.u1);
  connect(positionX, xPositionPErrorSum.u2);
  connect(xPositionPErrorSum.y, xPositionPProduct.u1);
  connect(xPositionKpSignal.y, xPositionPProduct.u2);
  connect(xPositionPProduct.y, xPositionRawControlSum.u1);

  connect(positionCommandX, xPositionGammaProduct.u1);
  connect(xPositionGammaSignal.y, xPositionGammaProduct.u2);
  connect(xPositionGammaProduct.y, xPositionDErrorSum.u1);
  connect(positionX, xPositionDErrorSum.u2);
  connect(xPositionDErrorSum.y, xPositionFilteredDerivative.u);
  connect(xPositionFilteredDerivative.y, xPositionDProduct.u1);
  connect(xPositionKdSignal.y, xPositionDProduct.u2);
  connect(xPositionDProduct.y, xPositionRawControlSum.u3);

  connect(xPositionRawControlSum.y, xPositionOutputSaturation.u);
  connect(xPositionOutputMaxSignal.y, xPositionOutputSaturation.upperLimit);
  connect(xPositionOutputMinSignal.y, xPositionOutputSaturation.lowerLimit);
  connect(xPositionOutputSaturation.y, xPositionSaturationErrorSum.u1);
  connect(xPositionRawControlSum.y, xPositionSaturationErrorSum.u2);
  connect(xPositionSaturationErrorSum.y, xPositionAntiWindupProduct.u1);
  connect(xPositionKawSignal.y, xPositionAntiWindupProduct.u2);
  connect(xPositionAntiWindupProduct.y, xPositionIntegratorInputSum.u2);

  connect(positionCommandY, yPositionErrorSum.u1);
  connect(positionY, yPositionErrorSum.u2);
  connect(yPositionErrorSum.y, yPositionAbsError.u);
  connect(yPositionAbsError.y, yPositionIntegralEnableCompare.u1);
  connect(yPositionIntegralEnableSignal.y, yPositionIntegralEnableCompare.u2);
  connect(yPositionErrorSum.y, yPositionIntegralSeparationSwitch.u1);
  connect(yPositionIntegralEnableCompare.y, yPositionIntegralSeparationSwitch.u2);
  connect(yPositionZeroIntegralSignal.y, yPositionIntegralSeparationSwitch.u3);
  connect(yPositionIntegralSeparationSwitch.y, yPositionKiProduct.u1);
  connect(yPositionKiSignal.y, yPositionKiProduct.u2);
  connect(yPositionKiProduct.y, yPositionIntegratorInputSum.u1);
  connect(yPositionIntegratorInputSum.y, yPositionITermIntegrator.u1);
  connect(yPositionITermIntegrator.y, yPositionRawControlSum.u2);

  connect(positionCommandY, yPositionBetaProduct.u1);
  connect(yPositionBetaSignal.y, yPositionBetaProduct.u2);
  connect(yPositionBetaProduct.y, yPositionPErrorSum.u1);
  connect(positionY, yPositionPErrorSum.u2);
  connect(yPositionPErrorSum.y, yPositionPProduct.u1);
  connect(yPositionKpSignal.y, yPositionPProduct.u2);
  connect(yPositionPProduct.y, yPositionRawControlSum.u1);

  connect(positionCommandY, yPositionGammaProduct.u1);
  connect(yPositionGammaSignal.y, yPositionGammaProduct.u2);
  connect(yPositionGammaProduct.y, yPositionDErrorSum.u1);
  connect(positionY, yPositionDErrorSum.u2);
  connect(yPositionDErrorSum.y, yPositionFilteredDerivative.u);
  connect(yPositionFilteredDerivative.y, yPositionDProduct.u1);
  connect(yPositionKdSignal.y, yPositionDProduct.u2);
  connect(yPositionDProduct.y, yPositionRawControlSum.u3);

  connect(yPositionRawControlSum.y, yPositionOutputSaturation.u);
  connect(yPositionOutputMaxSignal.y, yPositionOutputSaturation.upperLimit);
  connect(yPositionOutputMinSignal.y, yPositionOutputSaturation.lowerLimit);
  connect(yPositionOutputSaturation.y, yPositionSaturationErrorSum.u1);
  connect(yPositionRawControlSum.y, yPositionSaturationErrorSum.u2);
  connect(yPositionSaturationErrorSum.y, yPositionAntiWindupProduct.u1);
  connect(yPositionKawSignal.y, yPositionAntiWindupProduct.u2);
  connect(yPositionAntiWindupProduct.y, yPositionIntegratorInputSum.u2);

  connect(positionCommandZ, heightErrorSum.u1);
  connect(positionZ, heightErrorSum.u2);
  connect(heightErrorSum.y, heightAbsError.u);
  connect(heightAbsError.y, heightIntegralEnableCompare.u1);
  connect(heightIntegralEnableSignal.y, heightIntegralEnableCompare.u2);
  connect(heightErrorSum.y, heightIntegralSeparationSwitch.u1);
  connect(heightIntegralEnableCompare.y, heightIntegralSeparationSwitch.u2);
  connect(heightZeroIntegralSignal.y, heightIntegralSeparationSwitch.u3);
  connect(heightIntegralSeparationSwitch.y, heightKiProduct.u1);
  connect(heightKiSignal.y, heightKiProduct.u2);
  connect(heightKiProduct.y, heightIntegratorInputSum.u1);
  connect(heightIntegratorInputSum.y, heightITermIntegrator.u1);
  connect(heightITermIntegrator.y, heightRawControlSum.u2);

  connect(positionCommandZ, heightBetaProduct.u1);
  connect(heightBetaSignal.y, heightBetaProduct.u2);
  connect(heightBetaProduct.y, heightPErrorSum.u1);
  connect(positionZ, heightPErrorSum.u2);
  connect(heightPErrorSum.y, heightPProduct.u1);
  connect(heightKpSignal.y, heightPProduct.u2);
  connect(heightPProduct.y, heightRawControlSum.u1);

  connect(positionCommandZ, heightGammaProduct.u1);
  connect(heightGammaSignal.y, heightGammaProduct.u2);
  connect(heightGammaProduct.y, heightDErrorSum.u1);
  connect(positionZ, heightDErrorSum.u2);
  connect(heightDErrorSum.y, heightFilteredDerivative.u);
  connect(heightFilteredDerivative.y, heightDProduct.u1);
  connect(heightKdSignal.y, heightDProduct.u2);
  connect(heightDProduct.y, heightRawControlSum.u3);

  connect(heightRawControlSum.y, heightOutputSaturation.u);
  connect(heightOutputMaxSignal.y, heightOutputSaturation.upperLimit);
  connect(heightOutputMinSignal.y, heightOutputSaturation.lowerLimit);
  connect(heightOutputSaturation.y, heightSaturationErrorSum.u1);
  connect(heightRawControlSum.y, heightSaturationErrorSum.u2);
  connect(heightSaturationErrorSum.y, heightAntiWindupProduct.u1);
  connect(heightKawSignal.y, heightAntiWindupProduct.u2);
  connect(heightAntiWindupProduct.y, heightIntegratorInputSum.u2);

  connect(xPositionOutputSaturation.y, pitchErrorSum.u1);
  connect(pitchAngle, pitchErrorSum.u2);
  connect(pitchErrorSum.y, pitchAbsError.u);
  connect(pitchAbsError.y, pitchIntegralEnableCompare.u1);
  connect(pitchIntegralEnableSignal.y, pitchIntegralEnableCompare.u2);
  connect(pitchErrorSum.y, pitchIntegralSeparationSwitch.u1);
  connect(pitchIntegralEnableCompare.y, pitchIntegralSeparationSwitch.u2);
  connect(pitchZeroIntegralSignal.y, pitchIntegralSeparationSwitch.u3);
  connect(pitchIntegralSeparationSwitch.y, pitchKiProduct.u1);
  connect(pitchKiSignal.y, pitchKiProduct.u2);
  connect(pitchKiProduct.y, pitchIntegratorInputSum.u1);
  connect(pitchIntegratorInputSum.y, pitchITermIntegrator.u1);
  connect(pitchITermIntegrator.y, pitchRawControlSum.u2);

  connect(xPositionOutputSaturation.y, pitchBetaProduct.u1);
  connect(pitchBetaSignal.y, pitchBetaProduct.u2);
  connect(pitchBetaProduct.y, pitchPErrorSum.u1);
  connect(pitchAngle, pitchPErrorSum.u2);
  connect(pitchPErrorSum.y, pitchPProduct.u1);
  connect(pitchKpSignal.y, pitchPProduct.u2);
  connect(pitchPProduct.y, pitchRawControlSum.u1);

  connect(xPositionOutputSaturation.y, pitchGammaProduct.u1);
  connect(pitchGammaSignal.y, pitchGammaProduct.u2);
  connect(pitchGammaProduct.y, pitchDErrorSum.u1);
  connect(pitchAngle, pitchDErrorSum.u2);
  connect(pitchDErrorSum.y, pitchFilteredDerivative.u);
  connect(pitchFilteredDerivative.y, pitchDProduct.u1);
  connect(pitchKdSignal.y, pitchDProduct.u2);
  connect(pitchDProduct.y, pitchRawControlSum.u3);

  connect(pitchRawControlSum.y, pitchOutputSaturation.u);
  connect(pitchOutputMaxSignal.y, pitchOutputSaturation.upperLimit);
  connect(pitchOutputMinSignal.y, pitchOutputSaturation.lowerLimit);
  connect(pitchOutputSaturation.y, pitchSaturationErrorSum.u1);
  connect(pitchRawControlSum.y, pitchSaturationErrorSum.u2);
  connect(pitchSaturationErrorSum.y, pitchAntiWindupProduct.u1);
  connect(pitchKawSignal.y, pitchAntiWindupProduct.u2);
  connect(pitchAntiWindupProduct.y, pitchIntegratorInputSum.u2);

  connect(yPositionOutputSaturation.y, rollErrorSum.u1);
  connect(rollMeasurementSign.y, rollErrorSum.u2);
  connect(rollErrorSum.y, rollAbsError.u);
  connect(rollAbsError.y, rollIntegralEnableCompare.u1);
  connect(rollIntegralEnableSignal.y, rollIntegralEnableCompare.u2);
  connect(rollErrorSum.y, rollIntegralSeparationSwitch.u1);
  connect(rollIntegralEnableCompare.y, rollIntegralSeparationSwitch.u2);
  connect(rollZeroIntegralSignal.y, rollIntegralSeparationSwitch.u3);
  connect(rollIntegralSeparationSwitch.y, rollKiProduct.u1);
  connect(rollKiSignal.y, rollKiProduct.u2);
  connect(rollKiProduct.y, rollIntegratorInputSum.u1);
  connect(rollIntegratorInputSum.y, rollITermIntegrator.u1);
  connect(rollITermIntegrator.y, rollRawControlSum.u2);

  connect(yPositionOutputSaturation.y, rollBetaProduct.u1);
  connect(rollBetaSignal.y, rollBetaProduct.u2);
  connect(rollBetaProduct.y, rollPErrorSum.u1);
  connect(rollMeasurementSign.y, rollPErrorSum.u2);
  connect(rollPErrorSum.y, rollPProduct.u1);
  connect(rollKpSignal.y, rollPProduct.u2);
  connect(rollPProduct.y, rollRawControlSum.u1);

  connect(yPositionOutputSaturation.y, rollGammaProduct.u1);
  connect(rollGammaSignal.y, rollGammaProduct.u2);
  connect(rollGammaProduct.y, rollDErrorSum.u1);
  connect(rollMeasurementSign.y, rollDErrorSum.u2);
  connect(rollDErrorSum.y, rollFilteredDerivative.u);
  connect(rollFilteredDerivative.y, rollDProduct.u1);
  connect(rollKdSignal.y, rollDProduct.u2);
  connect(rollDProduct.y, rollRawControlSum.u3);

  connect(rollRawControlSum.y, rollOutputSaturation.u);
  connect(rollOutputMaxSignal.y, rollOutputSaturation.upperLimit);
  connect(rollOutputMinSignal.y, rollOutputSaturation.lowerLimit);
  connect(rollOutputSaturation.y, rollSaturationErrorSum.u1);
  connect(rollRawControlSum.y, rollSaturationErrorSum.u2);
  connect(rollSaturationErrorSum.y, rollAntiWindupProduct.u1);
  connect(rollKawSignal.y, rollAntiWindupProduct.u2);
  connect(rollAntiWindupProduct.y, rollIntegratorInputSum.u2);

  connect(rollAngle, rollMeasurementSign.u);

  connect(yawOutputSaturation.y, yawMixGain.u);
  connect(pitchOutputSaturation.y, pitchMixGain.u);
  connect(rollOutputSaturation.y, rollMixGain.u);

  connect(yawMixGain.y, motor1Attitude.u1);
  connect(pitchMixGain.y, motor1Attitude.u2);
  connect(rollMixGain.y, motor1Attitude.u3);
  connect(yawMixGain.y, motor2Attitude.u1);
  connect(pitchMixGain.y, motor2Attitude.u2);
  connect(rollMixGain.y, motor2Attitude.u3);
  connect(yawMixGain.y, motor3Attitude.u1);
  connect(pitchMixGain.y, motor3Attitude.u2);
  connect(rollMixGain.y, motor3Attitude.u3);
  connect(yawMixGain.y, motor4Attitude.u1);
  connect(pitchMixGain.y, motor4Attitude.u2);
  connect(rollMixGain.y, motor4Attitude.u3);

  connect(motor1Attitude.y, motor1Command.u1);
  connect(motor2Attitude.y, motor2Command.u1);
  connect(motor3Attitude.y, motor3Command.u1);
  connect(motor4Attitude.y, motor4Command.u1);
  connect(heightOutputSaturation.y, motor1Command.u2);
  connect(heightOutputSaturation.y, motor2Command.u2);
  connect(heightOutputSaturation.y, motor3Command.u2);
  connect(heightOutputSaturation.y, motor4Command.u2);

  connect(motor1Command.y, motor1Sign.u);
  connect(motor2Command.y, motor2Sign.u);
  connect(motor3Command.y, motor3Sign.u);
  connect(motor4Command.y, motor4Sign.u);
  connect(motor1Sign.y, y);
  connect(motor2Sign.y, y1);
  connect(motor3Sign.y, y2);
  connect(motor4Sign.y, y3);
end EnhancedPIDController;