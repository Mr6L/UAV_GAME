within QuadrotorModel.Blocks.Controller;
model EnhancedPIDController "6-DOF controller using six enhanced PID Sysblock modules"
  extends ModelWorkspace;
  import SysplorerEmbeddedCoder.Types.*;
  import BaseWorkspace.*;
  annotation(__MWORKS(version = "26.2.1",PortArrangement(Left(positionCommandX, positionCommandY, positionCommandZ, yawCommand, positionX, positionY, positionZ, rollAngle, pitchAngle, yawAngle), Right(y, y1, y2, y3)),modelType = Control,BlockSystem(blockKind=BlockKind.userModel,SampleTime(auto=true,group="")=0.02,OutputInterval=0.02),SysblockVersion = "1.0"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {80, 120, 160}, fillColor = {245, 250, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-88, 28}, {88, -28}}, textString = "Enhanced PID")}),
    Diagram(coordinateSystem(extent = {{-760, -420}, {980, 420}}, grid = {10, 10})));
  SysplorerEmbeddedCoder.Port.Inport positionCommandX "Position command x" 
    annotation(Placement(transformation(origin = {-720, 240}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),SampleTime(group="D0")=0,Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport positionCommandY "Position command y" 
    annotation(Placement(transformation(origin = {-720, 90}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),SampleTime(group="D0")=0,Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport positionCommandZ "Position command z" 
    annotation(Placement(transformation(origin = {-720, -60}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),SampleTime(group="D0")=0,Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport yawCommand "Yaw command" 
    annotation(Placement(transformation(origin = {-720, 360}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),SampleTime(group="D0")=0,Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport positionX "Measured position x" 
    annotation(Placement(transformation(origin = {-720, 210}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),SampleTime(group="D0")=0,Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport positionY "Measured position y" 
    annotation(Placement(transformation(origin = {-720, 60}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),SampleTime(group="D0")=0,Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport positionZ "Measured position z" 
    annotation(Placement(transformation(origin = {-720, -90}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),SampleTime(group="D0")=0,Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport rollAngle "Measured roll angle" 
    annotation(Placement(transformation(origin = {-720, -330}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),SampleTime(group="D0")=0,Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport pitchAngle "Measured pitch angle" 
    annotation(Placement(transformation(origin = {-720, -210}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),SampleTime(group="D0")=0,Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport yawAngle "Measured yaw angle" 
    annotation(Placement(transformation(origin = {-720, 330}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"),SampleTime(group="D0")=0,Dimension=1)));
  SysplorerEmbeddedCoder.Port.Outport y "Motor 1 command" 
    annotation(Placement(transformation(origin = {940, 210}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Outport y1 "Motor 2 command" 
    annotation(Placement(transformation(origin = {940, 90}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Outport y2 "Motor 3 command" 
    annotation(Placement(transformation(origin = {940, -30}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Outport y3 "Motor 4 command" 
    annotation(Placement(transformation(origin = {940, -150}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  QuadrotorModel.Blocks.ControlMethod.EnhancedPIDSysblock yawPID(leakRate = yawLeakRate, derivativeFilterN = yawDerivativeFilterN) 
    annotation(Placement(transformation(origin = {-280, 340}, extent = {{-40, -28}, {40, 28}})), __MWORKS(SECInstance = true,BlockSystem(SampleTime(group="")=0)));
  QuadrotorModel.Blocks.ControlMethod.EnhancedPIDSysblock xPositionPID(leakRate = lateralPositionLeakRate, derivativeFilterN = lateralPositionDerivativeFilterN) 
    annotation(Placement(transformation(origin = {-280, 220}, extent = {{-40, -28}, {40, 28}})), __MWORKS(SECInstance = true,BlockSystem(SampleTime(group="")=0)));
  QuadrotorModel.Blocks.ControlMethod.EnhancedPIDSysblock yPositionPID(leakRate = lateralPositionLeakRate, derivativeFilterN = lateralPositionDerivativeFilterN) 
    annotation(Placement(transformation(origin = {-280, 70}, extent = {{-40, -28}, {40, 28}})), __MWORKS(SECInstance = true,BlockSystem(SampleTime(group="")=0)));
  QuadrotorModel.Blocks.ControlMethod.EnhancedPIDSysblock heightPID(leakRate = heightLeakRate, derivativeFilterN = heightDerivativeFilterN) 
    annotation(Placement(transformation(origin = {-280, -80}, extent = {{-40, -28}, {40, 28}})), __MWORKS(SECInstance = true,BlockSystem(SampleTime(group="")=0)));
  QuadrotorModel.Blocks.ControlMethod.EnhancedPIDSysblock pitchPID(leakRate = attitudeLeakRate, derivativeFilterN = attitudeDerivativeFilterN) 
    annotation(Placement(transformation(origin = {80, -210}, extent = {{-40, -28}, {40, 28}})), __MWORKS(SECInstance = true,BlockSystem(SampleTime(group="")=0)));
  QuadrotorModel.Blocks.ControlMethod.EnhancedPIDSysblock rollPID(leakRate = attitudeLeakRate, derivativeFilterN = attitudeDerivativeFilterN) 
    annotation(Placement(transformation(origin = {80, -330}, extent = {{-40, -28}, {40, 28}})), __MWORKS(SECInstance = true,BlockSystem(SampleTime(group="")=0)));
  SysplorerEmbeddedCoder.MathOperation.Gain rollMeasurementSign(k = -1) 
    annotation(Placement(transformation(origin = {-460, -330}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant betaOneSignal(k = 1) 
    annotation(Placement(transformation(origin = {-560, 390}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant gammaZeroSignal(k = 0) 
    annotation(Placement(transformation(origin = {-560, 360}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant falseResetSignal(k = 0) 
    annotation(Placement(transformation(origin = {-560, 330}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawKpSignal(k = yawKP) 
    annotation(Placement(transformation(origin = {-560, 310}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawKiSignal(k = yawKI) 
    annotation(Placement(transformation(origin = {-560, 280}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawKdSignal(k = yawKD) 
    annotation(Placement(transformation(origin = {-560, 250}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawIntegralEnableSignal(k = yawIntegralEnableError) 
    annotation(Placement(transformation(origin = {-420, 390}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawOutputMaxSignal(k = yawOutputMax) 
    annotation(Placement(transformation(origin = {-420, 360}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawOutputMinSignal(k = yawOutputMin) 
    annotation(Placement(transformation(origin = {-420, 330}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant yawKawSignal(k = yawKaw) 
    annotation(Placement(transformation(origin = {-420, 300}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant lateralKpSignal(k = lateralPositionKP) 
    annotation(Placement(transformation(origin = {-560, 160}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant lateralKiSignal(k = lateralPositionKI) 
    annotation(Placement(transformation(origin = {-560, 130}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant lateralKdSignal(k = lateralPositionKD) 
    annotation(Placement(transformation(origin = {-560, 100}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant lateralIntegralEnableSignal(k = lateralPositionIntegralEnableError) 
    annotation(Placement(transformation(origin = {-420, 160}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant commandedAngleMaxSignal(k = maxCommandedAngle) 
    annotation(Placement(transformation(origin = {-420, 130}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant commandedAngleMinSignal(k = minCommandedAngle) 
    annotation(Placement(transformation(origin = {-420, 100}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant lateralKawSignal(k = lateralPositionKaw) 
    annotation(Placement(transformation(origin = {-420, 70}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightKpSignal(k = heightKP) 
    annotation(Placement(transformation(origin = {-560, -140}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightKiSignal(k = heightKI) 
    annotation(Placement(transformation(origin = {-560, -170}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightKdSignal(k = heightKD) 
    annotation(Placement(transformation(origin = {-560, -200}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightIntegralEnableSignal(k = heightIntegralEnableError) 
    annotation(Placement(transformation(origin = {-420, -140}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightOutputMaxSignal(k = heightOutputMax) 
    annotation(Placement(transformation(origin = {-420, -170}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightOutputMinSignal(k = heightOutputMin) 
    annotation(Placement(transformation(origin = {-420, -200}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant heightKawSignal(k = heightKaw) 
    annotation(Placement(transformation(origin = {-420, -230}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant attitudeKpSignal(k = attitudeKP) 
    annotation(Placement(transformation(origin = {-120, -260}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant attitudeKiSignal(k = attitudeKI) 
    annotation(Placement(transformation(origin = {-120, -290}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant attitudeKdSignal(k = attitudeKD) 
    annotation(Placement(transformation(origin = {-120, -320}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant attitudeIntegralEnableSignal(k = attitudeIntegralEnableError) 
    annotation(Placement(transformation(origin = {-20, -260}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant attitudeOutputMaxSignal(k = attitudeOutputMax) 
    annotation(Placement(transformation(origin = {-20, -290}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant attitudeOutputMinSignal(k = attitudeOutputMin) 
    annotation(Placement(transformation(origin = {-20, -320}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant attitudeKawSignal(k = attitudeKaw) 
    annotation(Placement(transformation(origin = {-20, -350}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(auto=true,group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Gain yawMixGain(k = 0.707) 
    annotation(Placement(transformation(origin = {300, 250}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Gain pitchMixGain(k = 0.707) 
    annotation(Placement(transformation(origin = {300, 170}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Gain rollMixGain(k = 0.707) 
    annotation(Placement(transformation(origin = {300, 90}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor1Attitude(inputs = "--+", isSaturate = false) 
    annotation(Placement(transformation(origin = {460, 210}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor2Attitude(inputs = "+--", isSaturate = false) 
    annotation(Placement(transformation(origin = {460, 90}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor3Attitude(inputs = "-+-", isSaturate = false) 
    annotation(Placement(transformation(origin = {460, -30}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor4Attitude(inputs = "+++", isSaturate = false) 
    annotation(Placement(transformation(origin = {460, -150}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor1Command(inputs = "++", isSaturate = false) 
    annotation(Placement(transformation(origin = {630, 210}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor2Command(inputs = "++", isSaturate = false) 
    annotation(Placement(transformation(origin = {630, 90}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor3Command(inputs = "++", isSaturate = false) 
    annotation(Placement(transformation(origin = {630, -30}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor4Command(inputs = "++", isSaturate = false) 
    annotation(Placement(transformation(origin = {630, -150}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Gain motor1Sign(k = 1) 
    annotation(Placement(transformation(origin = {790, 210}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Gain motor2Sign(k = -1) 
    annotation(Placement(transformation(origin = {790, 90}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Gain motor3Sign(k = 1) 
    annotation(Placement(transformation(origin = {790, -30}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Gain motor4Sign(k = -1) 
    annotation(Placement(transformation(origin = {790, -150}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  model ModelWorkspace
    annotation(__MWORKS(hide=true, BlockSystem(blockKind=BlockKind.modelWorkspace)));
    parameter RealAuto controllerSampleTime = 0.02 "Shared Sysblock sample time. Position loops can use 0.01-0.02 s; attitude loops are usually tested at 0.002-0.005 s. If all loops must share one time, test 0.005 s after functional validation." annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);

    parameter RealAuto yawKP = 5 "Yaw loop proportional gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto yawKI = 0 "Yaw loop integral gain; first version keeps yaw integral disabled" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto yawKD = 0 "Yaw loop derivative gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto yawOutputMax = 7 "Yaw mixed-channel upper limit" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto yawOutputMin = -7 "Yaw mixed-channel lower limit" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto yawIntegralEnableError = 0.3 "Yaw integral separation threshold" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto yawKaw = 0 "Yaw anti-windup gain; zero because yawKI is zero in this version" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto yawLeakRate = 0 "Yaw integral leak; 0 disables leak" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto yawDerivativeFilterN = 50 "Yaw derivative filter coefficient N" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);

    parameter RealAuto lateralPositionKP = 0.15 "Position loop proportional gain, including angle conversion" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionKI = 0 "Position loop integral gain disabled for first version" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionKD = 0.1 "Position loop derivative gain, including angle conversion" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionIntegralEnableError = 0.5 "Position integral separation threshold; increase during tuning if integral never becomes active" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto maxCommandedAngle = 15 / 57.3 "Outer-loop attitude command upper limit in rad" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto minCommandedAngle = -15 / 57.3 "Outer-loop attitude command lower limit in rad" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionKaw = 0 "Position anti-windup gain; zero because lateralPositionKI is zero in this version" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionLeakRate = 0 "Position integral leak; 0 disables leak" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionDerivativeFilterN = 50 "Position derivative filter coefficient N; tune lower, e.g. 5-20, after baseline validation" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);

    parameter RealAuto attitudeKP = 14.142 "Attitude loop proportional gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeKI = 0 "Attitude loop integral gain kept zero in the first version" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeKD = 1.414 "Attitude loop derivative gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeOutputMax = 7 "Attitude mixed-channel upper limit" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeOutputMin = -7 "Attitude mixed-channel lower limit" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeIntegralEnableError = 0.2 "Attitude integral separation threshold" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeKaw = 0 "Attitude anti-windup gain; zero because attitudeKI is zero in this version" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeLeakRate = 0 "Attitude integral leak; 0 disables leak" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeDerivativeFilterN = 50 "Attitude derivative filter coefficient N; tune in 20-100 range after validation" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);

    parameter RealAuto heightKP = 8 "Height loop proportional gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightKI = 6 "Height loop integral gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightKD = 4 "Height loop derivative gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightOutputMax = 30 "Height thrust-correction upper limit. Tune from motor model, hover throttle, and max thrust; do not leave effectively unlimited." annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightOutputMin = -30 "Height thrust-correction lower limit. Tune together with heightOutputMax and actuator range." annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightIntegralEnableError = 2.0 "Height integral separation threshold. During debugging, set larger to confirm integral removes steady error, then tighten gradually." annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightKaw = 1 "Height anti-windup back-calculation gain; heightKI is nonzero" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightLeakRate = 0 "Height integral leak; 0 disables leak" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightDerivativeFilterN = 50 "Height derivative filter coefficient N" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
  end ModelWorkspace;
equation
  connect(yawCommand, yawPID.ref) annotation(Line(points = {{-720, 360}, {-280, 340}}, color = {0, 0, 0}));
  connect(yawAngle, yawPID.meas) annotation(Line(points = {{-720, 330}, {-280, 340}}, color = {0, 0, 0}));
  connect(yawKpSignal.y, yawPID.kp) annotation(Line(points = {{-560, 310}, {-280, 340}}, color = {0, 0, 0}));
  connect(yawKiSignal.y, yawPID.ki) annotation(Line(points = {{-560, 280}, {-280, 340}}, color = {0, 0, 0}));
  connect(yawKdSignal.y, yawPID.kd) annotation(Line(points = {{-560, 250}, {-280, 340}}, color = {0, 0, 0}));
  connect(betaOneSignal.y, yawPID.beta) annotation(Line(points = {{-560, 390}, {-280, 340}}, color = {0, 0, 0}));
  connect(gammaZeroSignal.y, yawPID.gamma) annotation(Line(points = {{-560, 360}, {-280, 340}}, color = {0, 0, 0}));
  connect(yawIntegralEnableSignal.y, yawPID.integralEnableError) annotation(Line(points = {{-420, 390}, {-280, 340}}, color = {0, 0, 0}));
  connect(yawOutputMaxSignal.y, yawPID.uMax) annotation(Line(points = {{-420, 360}, {-280, 340}}, color = {0, 0, 0}));
  connect(yawOutputMinSignal.y, yawPID.uMin) annotation(Line(points = {{-420, 330}, {-280, 340}}, color = {0, 0, 0}));
  connect(yawKawSignal.y, yawPID.kaw) annotation(Line(points = {{-420, 300}, {-280, 340}}, color = {0, 0, 0}));
  connect(falseResetSignal.y, yawPID.reset) annotation(Line(points = {{-560, 330}, {-280, 340}}, color = {0, 0, 0}));
  connect(positionCommandX, xPositionPID.ref) annotation(Line(points = {{-720, 240}, {-280, 220}}, color = {0, 0, 0}));
  connect(positionX, xPositionPID.meas) annotation(Line(points = {{-720, 210}, {-280, 220}}, color = {0, 0, 0}));
  connect(positionCommandY, yPositionPID.ref) annotation(Line(points = {{-720, 90}, {-280, 70}}, color = {0, 0, 0}));
  connect(positionY, yPositionPID.meas) annotation(Line(points = {{-720, 60}, {-280, 70}}, color = {0, 0, 0}));
  connect(lateralKpSignal.y, xPositionPID.kp) annotation(Line(points = {{-560, 160}, {-280, 220}}, color = {0, 0, 0}));
  connect(lateralKpSignal.y, yPositionPID.kp) annotation(Line(points = {{-560, 160}, {-280, 70}}, color = {0, 0, 0}));
  connect(lateralKiSignal.y, xPositionPID.ki) annotation(Line(points = {{-560, 130}, {-280, 220}}, color = {0, 0, 0}));
  connect(lateralKiSignal.y, yPositionPID.ki) annotation(Line(points = {{-560, 130}, {-280, 70}}, color = {0, 0, 0}));
  connect(lateralKdSignal.y, xPositionPID.kd) annotation(Line(points = {{-560, 100}, {-280, 220}}, color = {0, 0, 0}));
  connect(lateralKdSignal.y, yPositionPID.kd) annotation(Line(points = {{-560, 100}, {-280, 70}}, color = {0, 0, 0}));
  connect(betaOneSignal.y, xPositionPID.beta) annotation(Line(points = {{-560, 390}, {-280, 220}}, color = {0, 0, 0}));
  connect(betaOneSignal.y, yPositionPID.beta) annotation(Line(points = {{-560, 390}, {-280, 70}}, color = {0, 0, 0}));
  connect(gammaZeroSignal.y, xPositionPID.gamma) annotation(Line(points = {{-560, 360}, {-280, 220}}, color = {0, 0, 0}));
  connect(gammaZeroSignal.y, yPositionPID.gamma) annotation(Line(points = {{-560, 360}, {-280, 70}}, color = {0, 0, 0}));
  connect(lateralIntegralEnableSignal.y, xPositionPID.integralEnableError) annotation(Line(points = {{-420, 160}, {-280, 220}}, color = {0, 0, 0}));
  connect(lateralIntegralEnableSignal.y, yPositionPID.integralEnableError) annotation(Line(points = {{-420, 160}, {-280, 70}}, color = {0, 0, 0}));
  connect(commandedAngleMaxSignal.y, xPositionPID.uMax) annotation(Line(points = {{-420, 130}, {-280, 220}}, color = {0, 0, 0}));
  connect(commandedAngleMaxSignal.y, yPositionPID.uMax) annotation(Line(points = {{-420, 130}, {-280, 70}}, color = {0, 0, 0}));
  connect(commandedAngleMinSignal.y, xPositionPID.uMin) annotation(Line(points = {{-420, 100}, {-280, 220}}, color = {0, 0, 0}));
  connect(commandedAngleMinSignal.y, yPositionPID.uMin) annotation(Line(points = {{-420, 100}, {-280, 70}}, color = {0, 0, 0}));
  connect(lateralKawSignal.y, xPositionPID.kaw) annotation(Line(points = {{-420, 70}, {-280, 220}}, color = {0, 0, 0}));
  connect(lateralKawSignal.y, yPositionPID.kaw) annotation(Line(points = {{-420, 70}, {-280, 70}}, color = {0, 0, 0}));
  connect(falseResetSignal.y, xPositionPID.reset) annotation(Line(points = {{-560, 330}, {-280, 220}}, color = {0, 0, 0}));
  connect(falseResetSignal.y, yPositionPID.reset) annotation(Line(points = {{-560, 330}, {-280, 70}}, color = {0, 0, 0}));
  connect(positionCommandZ, heightPID.ref) annotation(Line(points = {{-720, -60}, {-280, -80}}, color = {0, 0, 0}));
  connect(positionZ, heightPID.meas) annotation(Line(points = {{-720, -90}, {-280, -80}}, color = {0, 0, 0}));
  connect(heightKpSignal.y, heightPID.kp) annotation(Line(points = {{-560, -140}, {-280, -80}}, color = {0, 0, 0}));
  connect(heightKiSignal.y, heightPID.ki) annotation(Line(points = {{-560, -170}, {-280, -80}}, color = {0, 0, 0}));
  connect(heightKdSignal.y, heightPID.kd) annotation(Line(points = {{-560, -200}, {-280, -80}}, color = {0, 0, 0}));
  connect(betaOneSignal.y, heightPID.beta) annotation(Line(points = {{-560, 390}, {-280, -80}}, color = {0, 0, 0}));
  connect(gammaZeroSignal.y, heightPID.gamma) annotation(Line(points = {{-560, 360}, {-280, -80}}, color = {0, 0, 0}));
  connect(heightIntegralEnableSignal.y, heightPID.integralEnableError) annotation(Line(points = {{-420, -140}, {-280, -80}}, color = {0, 0, 0}));
  connect(heightOutputMaxSignal.y, heightPID.uMax) annotation(Line(points = {{-420, -170}, {-280, -80}}, color = {0, 0, 0}));
  connect(heightOutputMinSignal.y, heightPID.uMin) annotation(Line(points = {{-420, -200}, {-280, -80}}, color = {0, 0, 0}));
  connect(heightKawSignal.y, heightPID.kaw) annotation(Line(points = {{-420, -230}, {-280, -80}}, color = {0, 0, 0}));
  connect(falseResetSignal.y, heightPID.reset) annotation(Line(points = {{-560, 330}, {-280, -80}}, color = {0, 0, 0}));
  connect(xPositionPID.u, pitchPID.ref) annotation(Line(points = {{-280, 220}, {80, -210}}, color = {0, 0, 0}));
  connect(pitchAngle, pitchPID.meas) annotation(Line(points = {{-720, -210}, {80, -210}}, color = {0, 0, 0}));
  connect(yPositionPID.u, rollPID.ref) annotation(Line(points = {{-280, 70}, {80, -330}}, color = {0, 0, 0}));
  connect(rollAngle, rollMeasurementSign.u) annotation(Line(points = {{-720, -330}, {-460, -330}}, color = {0, 0, 0}));
  connect(rollMeasurementSign.y, rollPID.meas) annotation(Line(points = {{-460, -330}, {80, -330}}, color = {0, 0, 0}));
  connect(attitudeKpSignal.y, pitchPID.kp) annotation(Line(points = {{-120, -260}, {80, -210}}, color = {0, 0, 0}));
  connect(attitudeKpSignal.y, rollPID.kp) annotation(Line(points = {{-120, -260}, {80, -330}}, color = {0, 0, 0}));
  connect(attitudeKiSignal.y, pitchPID.ki) annotation(Line(points = {{-120, -290}, {80, -210}}, color = {0, 0, 0}));
  connect(attitudeKiSignal.y, rollPID.ki) annotation(Line(points = {{-120, -290}, {80, -330}}, color = {0, 0, 0}));
  connect(attitudeKdSignal.y, pitchPID.kd) annotation(Line(points = {{-120, -320}, {80, -210}}, color = {0, 0, 0}));
  connect(attitudeKdSignal.y, rollPID.kd) annotation(Line(points = {{-120, -320}, {80, -330}}, color = {0, 0, 0}));
  connect(betaOneSignal.y, pitchPID.beta) annotation(Line(points = {{-560, 390}, {80, -210}}, color = {0, 0, 0}));
  connect(betaOneSignal.y, rollPID.beta) annotation(Line(points = {{-560, 390}, {80, -330}}, color = {0, 0, 0}));
  connect(gammaZeroSignal.y, pitchPID.gamma) annotation(Line(points = {{-560, 360}, {80, -210}}, color = {0, 0, 0}));
  connect(gammaZeroSignal.y, rollPID.gamma) annotation(Line(points = {{-560, 360}, {80, -330}}, color = {0, 0, 0}));
  connect(attitudeIntegralEnableSignal.y, pitchPID.integralEnableError) annotation(Line(points = {{-20, -260}, {80, -210}}, color = {0, 0, 0}));
  connect(attitudeIntegralEnableSignal.y, rollPID.integralEnableError) annotation(Line(points = {{-20, -260}, {80, -330}}, color = {0, 0, 0}));
  connect(attitudeOutputMaxSignal.y, pitchPID.uMax) annotation(Line(points = {{-20, -290}, {80, -210}}, color = {0, 0, 0}));
  connect(attitudeOutputMaxSignal.y, rollPID.uMax) annotation(Line(points = {{-20, -290}, {80, -330}}, color = {0, 0, 0}));
  connect(attitudeOutputMinSignal.y, pitchPID.uMin) annotation(Line(points = {{-20, -320}, {80, -210}}, color = {0, 0, 0}));
  connect(attitudeOutputMinSignal.y, rollPID.uMin) annotation(Line(points = {{-20, -320}, {80, -330}}, color = {0, 0, 0}));
  connect(attitudeKawSignal.y, pitchPID.kaw) annotation(Line(points = {{-20, -350}, {80, -210}}, color = {0, 0, 0}));
  connect(attitudeKawSignal.y, rollPID.kaw) annotation(Line(points = {{-20, -350}, {80, -330}}, color = {0, 0, 0}));
  connect(falseResetSignal.y, pitchPID.reset) annotation(Line(points = {{-560, 330}, {80, -210}}, color = {0, 0, 0}));
  connect(falseResetSignal.y, rollPID.reset) annotation(Line(points = {{-560, 330}, {80, -330}}, color = {0, 0, 0}));
  connect(yawPID.u, yawMixGain.u) annotation(Line(points = {{-280, 340}, {300, 250}}, color = {0, 0, 0}));
  connect(pitchPID.u, pitchMixGain.u) annotation(Line(points = {{80, -210}, {300, 170}}, color = {0, 0, 0}));
  connect(rollPID.u, rollMixGain.u) annotation(Line(points = {{80, -330}, {300, 90}}, color = {0, 0, 0}));
  connect(yawMixGain.y, motor1Attitude.u1) annotation(Line(points = {{300, 250}, {460, 210}}, color = {0, 0, 0}));
  connect(pitchMixGain.y, motor1Attitude.u2) annotation(Line(points = {{300, 170}, {460, 210}}, color = {0, 0, 0}));
  connect(rollMixGain.y, motor1Attitude.u3) annotation(Line(points = {{300, 90}, {460, 210}}, color = {0, 0, 0}));
  connect(yawMixGain.y, motor2Attitude.u1) annotation(Line(points = {{300, 250}, {460, 90}}, color = {0, 0, 0}));
  connect(pitchMixGain.y, motor2Attitude.u2) annotation(Line(points = {{300, 170}, {460, 90}}, color = {0, 0, 0}));
  connect(rollMixGain.y, motor2Attitude.u3) annotation(Line(points = {{300, 90}, {460, 90}}, color = {0, 0, 0}));
  connect(yawMixGain.y, motor3Attitude.u1) annotation(Line(points = {{300, 250}, {460, -30}}, color = {0, 0, 0}));
  connect(pitchMixGain.y, motor3Attitude.u2) annotation(Line(points = {{300, 170}, {460, -30}}, color = {0, 0, 0}));
  connect(rollMixGain.y, motor3Attitude.u3) annotation(Line(points = {{300, 90}, {460, -30}}, color = {0, 0, 0}));
  connect(yawMixGain.y, motor4Attitude.u1) annotation(Line(points = {{300, 250}, {460, -150}}, color = {0, 0, 0}));
  connect(pitchMixGain.y, motor4Attitude.u2) annotation(Line(points = {{300, 170}, {460, -150}}, color = {0, 0, 0}));
  connect(rollMixGain.y, motor4Attitude.u3) annotation(Line(points = {{300, 90}, {460, -150}}, color = {0, 0, 0}));
  connect(motor1Attitude.y, motor1Command.u1) annotation(Line(points = {{460, 210}, {630, 210}}, color = {0, 0, 0}));
  connect(motor2Attitude.y, motor2Command.u1) annotation(Line(points = {{460, 90}, {630, 90}}, color = {0, 0, 0}));
  connect(motor3Attitude.y, motor3Command.u1) annotation(Line(points = {{460, -30}, {630, -30}}, color = {0, 0, 0}));
  connect(motor4Attitude.y, motor4Command.u1) annotation(Line(points = {{460, -150}, {630, -150}}, color = {0, 0, 0}));
  connect(heightPID.u, motor1Command.u2) annotation(Line(points = {{-280, -80}, {630, 210}}, color = {0, 0, 0}));
  connect(heightPID.u, motor2Command.u2) annotation(Line(points = {{-280, -80}, {630, 90}}, color = {0, 0, 0}));
  connect(heightPID.u, motor3Command.u2) annotation(Line(points = {{-280, -80}, {630, -30}}, color = {0, 0, 0}));
  connect(heightPID.u, motor4Command.u2) annotation(Line(points = {{-280, -80}, {630, -150}}, color = {0, 0, 0}));
  connect(motor1Command.y, motor1Sign.u) annotation(Line(points = {{630, 210}, {790, 210}}, color = {0, 0, 0}));
  connect(motor2Command.y, motor2Sign.u) annotation(Line(points = {{630, 90}, {790, 90}}, color = {0, 0, 0}));
  connect(motor3Command.y, motor3Sign.u) annotation(Line(points = {{630, -30}, {790, -30}}, color = {0, 0, 0}));
  connect(motor4Command.y, motor4Sign.u) annotation(Line(points = {{630, -150}, {790, -150}}, color = {0, 0, 0}));
  connect(motor1Sign.y, y) annotation(Line(points = {{790, 210}, {940, 210}}, color = {0, 0, 0}));
  connect(motor2Sign.y, y1) annotation(Line(points = {{790, 90}, {940, 90}}, color = {0, 0, 0}));
  connect(motor3Sign.y, y2) annotation(Line(points = {{790, -30}, {940, -30}}, color = {0, 0, 0}));
  connect(motor4Sign.y, y3) annotation(Line(points = {{790, -150}, {940, -150}}, color = {0, 0, 0}));
end EnhancedPIDController;