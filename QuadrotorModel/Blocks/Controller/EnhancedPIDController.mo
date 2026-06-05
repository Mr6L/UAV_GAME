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
    annotation(Placement(transformation(origin = {-220, 334.333},
    extent = {{-40, -28}, {40, 28}})), __MWORKS(SECInstance = true,BlockSystem(SampleTime(group="")=0)));
  QuadrotorModel.Blocks.ControlMethod.EnhancedPIDSysblock xPositionPID(leakRate = lateralPositionLeakRate, derivativeFilterN = lateralPositionDerivativeFilterN) 
    annotation(Placement(transformation(origin = {-220, 212.333},
    extent = {{-40, -28}, {40, 28}})), __MWORKS(SECInstance = true,BlockSystem(SampleTime(group="")=0)));
  QuadrotorModel.Blocks.ControlMethod.EnhancedPIDSysblock yPositionPID(leakRate = lateralPositionLeakRate, derivativeFilterN = lateralPositionDerivativeFilterN) 
    annotation(Placement(transformation(origin = {-220, 49},
    extent = {{-40, -28}, {40, 28}})), __MWORKS(SECInstance = true,BlockSystem(SampleTime(group="")=0)));
  QuadrotorModel.Blocks.ControlMethod.EnhancedPIDSysblock heightPID(leakRate = heightLeakRate, derivativeFilterN = heightDerivativeFilterN) 
    annotation(Placement(transformation(origin = {-220, -97},
    extent = {{-40, -28}, {40, 28}})), __MWORKS(SECInstance = true,BlockSystem(SampleTime(group="")=0)));
  QuadrotorModel.Blocks.ControlMethod.EnhancedPIDSysblock pitchPID(leakRate = attitudeLeakRate, derivativeFilterN = attitudeDerivativeFilterN) 
    annotation(Placement(transformation(origin = {130, -140},
    extent = {{-40, -28}, {40, 28}})), __MWORKS(SECInstance = true,BlockSystem(SampleTime(group="")=0)));
  QuadrotorModel.Blocks.ControlMethod.EnhancedPIDSysblock rollPID(leakRate = attitudeLeakRate, derivativeFilterN = attitudeDerivativeFilterN) 
    annotation(Placement(transformation(origin = {130, -333.667},
    extent = {{-40, -28}, {40, 28}})), __MWORKS(SECInstance = true,BlockSystem(SampleTime(group="")=0)));
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
  SysplorerEmbeddedCoder.Sources.Constant lateralGammaSignal(k = lateralPositionGamma) 
    annotation(Placement(transformation(origin = {-560, 70}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
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
  SysplorerEmbeddedCoder.Sources.Constant heightGammaSignal(k = heightGamma) 
    annotation(Placement(transformation(origin = {-560, -230}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
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
  SysplorerEmbeddedCoder.Sources.Constant hoverThrustSignal(k = hoverThrust) 
    annotation(Placement(transformation(origin = {-420, -260}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(y(Type(ref="double"),Dimension=1),
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
    annotation(Placement(transformation(origin = {490, 210},
    extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor2Attitude(inputs = "+--", isSaturate = false) 
    annotation(Placement(transformation(origin = {490, 96.6667},
    extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor3Attitude(inputs = "-+-", isSaturate = false) 
    annotation(Placement(transformation(origin = {470, -25},
    extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor4Attitude(inputs = "+++", isSaturate = false) 
    annotation(Placement(transformation(origin = {440, -161},
    extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor1Command(inputs = "++", isSaturate = false) 
    annotation(Placement(transformation(origin = {640, 210},
    extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor2Command(inputs = "++", isSaturate = false) 
    annotation(Placement(transformation(origin = {640, 91.6667},
    extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor3Command(inputs = "++", isSaturate = false) 
    annotation(Placement(transformation(origin = {640, -30},
    extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum motor4Command(inputs = "++", isSaturate = false) 
    annotation(Placement(transformation(origin = {640, -156},
    extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum heightCollectiveCommand(inputs = "++", isSaturate = false) 
    annotation(Placement(transformation(origin = {300, -80}, extent = {{-10, -10}, {10, 10}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
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

    parameter RealAuto lateralPositionKP = 0.4 "Position loop proportional gain, including angle conversion" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionKI = 0 "Position loop integral gain disabled for first version" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionKD = 0.3 "Position loop derivative gain, including angle conversion" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionGamma = 0.70 "Position derivative setpoint weighting; 1 tracks command velocity like the legacy PID, 0 differentiates measurement only" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionIntegralEnableError = 0.5 "Position integral separation threshold; increase during tuning if integral never becomes active" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto maxCommandedAngle = 15 / 57.3 "Outer-loop attitude command upper limit in rad" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto minCommandedAngle = -15 / 57.3 "Outer-loop attitude command lower limit in rad" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionKaw = 0 "Position anti-windup gain; zero because lateralPositionKI is zero in this version" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionLeakRate = 0 "Position integral leak; 0 disables leak" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto lateralPositionDerivativeFilterN = 5 "Position derivative filter coefficient N; tune lower, e.g. 5-20, after baseline validation" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);

    parameter RealAuto attitudeKP = 8 "Attitude loop proportional gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeKI = 0 "Attitude loop integral gain kept zero in the first version" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeKD = 1.2 "Attitude loop derivative gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeOutputMax = 7 "Attitude mixed-channel upper limit" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeOutputMin = -7 "Attitude mixed-channel lower limit" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeIntegralEnableError = 0.2 "Attitude integral separation threshold" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeKaw = 0 "Attitude anti-windup gain; zero because attitudeKI is zero in this version" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeLeakRate = 0 "Attitude integral leak; 0 disables leak" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto attitudeDerivativeFilterN = 50 "Attitude derivative filter coefficient N; tune in 20-100 range after validation" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);

    parameter RealAuto heightKP = 5 "Height loop proportional gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightKI = 0.3 "Height loop integral gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightKD = 12 "Height loop derivative gain" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightGamma = 0.3 "Height derivative setpoint weighting; partial command derivative improves climb tracking while limiting derivative kick" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto hoverMass = 0.159504 + 4 * 0.000913171 "Effective vehicle mass used by hover feedforward; include body mass plus propeller masses in the current plant model" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto gravity = 9.81 "Gravity used by the hover feedforward calculation" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto liftCoefficient = 0.002 "Rotor lift coefficient used by the plant force model: thrust = liftCoefficient * speed^2" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto hoverFeedforwardScale = 1 "Multiplier for hover feedforward; keep 1 for parameter-based simulation compensation" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto hoverThrust = hoverFeedforwardScale * sqrt(hoverMass * gravity / (4 * liftCoefficient)) "Per-motor hover speed/command bias computed from mass, gravity, and rotor lift coefficient" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightOutputMax = 12 "Height PID correction upper limit, not total thrust; total command is hoverThrust + heightPID.u" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightOutputMin = -0.9 * hoverThrust "Height PID correction lower limit; keeps hoverThrust + heightPID.u positive so rotor directions are not reversed" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightIntegralEnableError = 10.0 "Height integral separation threshold. Keep large during debugging so integral can remove steady error, then tighten gradually." annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightKaw = 0.2 "Height anti-windup back-calculation gain; heightKI is nonzero" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightLeakRate = 0 "Height integral leak; 0 disables leak" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto heightDerivativeFilterN = 1.5 "Height derivative filter coefficient N; lower value limits setpoint derivative kick" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
  end ModelWorkspace;
equation
  connect(yawCommand, yawPID.ref) annotation(Line(origin = {0, 0},
    points = {{-708, 360}, {-572, 360}, {-572, 348}, {-265.6, 348}, {-265.6, 360}, {-261.8, 360}},
    color = {0, 0, 0}));
  connect(yawAngle, yawPID.meas) annotation(Line(origin = {0, 0},
    points = {{-708, 330}, {-572, 330}, {-572, 342}, {-265.6, 342}, {-265.6, 355.333}, {-261.8, 355.333}},
    color = {0, 0, 0}));
  connect(yawKpSignal.y, yawPID.kp) annotation(Line(origin = {0, 0},
    points = {{-548.2, 310}, {-265.6, 310}, {-265.6, 350.667}, {-261.8, 350.667}},
    color = {0, 0, 0}));
  connect(yawKiSignal.y, yawPID.ki) annotation(Line(origin = {0, 0},
    points = {{-548.2, 280}, {-265.6, 280}, {-265.6, 346}, {-261.8, 346}},
    color = {0, 0, 0}));
  connect(yawKdSignal.y, yawPID.kd) annotation(Line(origin = {0, 0},
    points = {{-548.2, 250}, {-265.6, 250}, {-265.6, 341.333}, {-261.8, 341.333}},
    color = {0, 0, 0}));
  connect(betaOneSignal.y, yawPID.beta) annotation(Line(origin = {0, 0},
    points = {{-548.2, 390}, {-432, 390}, {-432, 378}, {-265.6, 378}, {-265.6, 336.667}, {-261.8, 336.667}},
    color = {0, 0, 0}));
  connect(gammaZeroSignal.y, yawPID.gamma) annotation(Line(origin = {0, 0},
    points = {{-548.2, 360}, {-432, 360}, {-432, 348}, {-265.6, 348}, {-265.6, 332}, {-261.8, 332}},
    color = {0, 0, 0}));
  connect(yawIntegralEnableSignal.y, yawPID.integralEnableError) annotation(Line(origin = {0, 0},
    points = {{-408.2, 390}, {-265.6, 390}, {-265.6, 327.333}, {-261.8, 327.333}},
    color = {0, 0, 0}));
  connect(yawOutputMaxSignal.y, yawPID.uMax) annotation(Line(origin = {0, 0},
    points = {{-408.2, 360}, {-265.6, 360}, {-265.6, 322.667}, {-261.8, 322.667}},
    color = {0, 0, 0}));
  connect(yawOutputMinSignal.y, yawPID.uMin) annotation(Line(origin = {0, 0},
    points = {{-408.2, 330}, {-265.6, 330}, {-265.6, 318}, {-261.8, 318}},
    color = {0, 0, 0}));
  connect(yawKawSignal.y, yawPID.kaw) annotation(Line(origin = {0, 0},
    points = {{-408.2, 300}, {-265.6, 300}, {-265.6, 313.333}, {-261.8, 313.333}},
    color = {0, 0, 0}));
  connect(falseResetSignal.y, yawPID.reset) annotation(Line(origin = {0, 0},
    points = {{-548.2, 330}, {-432, 330}, {-432, 318}, {-265.6, 318}, {-265.6, 308.667}, {-261.8, 308.667}},
    color = {0, 0, 0}));
  connect(positionCommandX, xPositionPID.ref) annotation(Line(origin = {0, 0},
    points = {{-708, 240}, {-572, 240}, {-572, 238}, {-261.8, 238}},
    color = {0, 0, 0}));
  connect(positionX, xPositionPID.meas) annotation(Line(origin = {0, 0},
    points = {{-708, 210}, {-265.6, 210}, {-265.6, 233.333}, {-261.8, 233.333}},
    color = {0, 0, 0}));
  connect(positionCommandY, yPositionPID.ref) annotation(Line(origin = {0, 0},
    points = {{-708, 90.0000048}, {-572, 90.0000048}, {-572, 88}, {-265.6, 88}, {-265.6, 74.6667}, {-261.8, 74.6667}},
    color = {0, 0, 0}));
  connect(positionY, yPositionPID.meas) annotation(Line(origin = {0, 0},
    points = {{-708, 60}, {-432, 60}, {-432, 58}, {-265.6, 58}, {-265.6, 70}, {-261.8, 70}},
    color = {0, 0, 0}));
  connect(lateralKpSignal.y, xPositionPID.kp) annotation(Line(origin = {0, 0},
    points = {{-548.2, 160}, {-432, 160}, {-432, 228.667}, {-261.8, 228.667}},
    color = {0, 0, 0}));
  connect(lateralKpSignal.y, yPositionPID.kp) annotation(Line(origin = {0, 0},
    points = {{-548.2, 160}, {-432, 160}, {-432, 148}, {-265.6, 148}, {-265.6, 65.3333}, {-261.8, 65.3333}},
    color = {0, 0, 0}));
  connect(lateralKiSignal.y, xPositionPID.ki) annotation(Line(origin = {0, 0},
    points = {{-548.2, 130}, {-432, 130}, {-432, 224}, {-261.8, 224}},
    color = {0, 0, 0}));
  connect(lateralKiSignal.y, yPositionPID.ki) annotation(Line(origin = {0, 0},
    points = {{-548.2, 130}, {-432, 130}, {-432, 118}, {-265.6, 118}, {-265.6, 60.6667}, {-261.8, 60.6667}},
    color = {0, 0, 0}));
  connect(lateralKdSignal.y, xPositionPID.kd) annotation(Line(origin = {0, 0},
    points = {{-548.2, 100}, {-432, 100}, {-432, 219.333}, {-261.8, 219.333}},
    color = {0, 0, 0}));
  connect(lateralKdSignal.y, yPositionPID.kd) annotation(Line(origin = {0, 0},
    points = {{-548.2, 100}, {-432, 100}, {-432, 56}, {-261.8, 56}},
    color = {0, 0, 0}));
  connect(betaOneSignal.y, xPositionPID.beta) annotation(Line(origin = {0, 0},
    points = {{-548.2, 390}, {-432, 390}, {-432, 214.667}, {-261.8, 214.667}},
    color = {0, 0, 0}));
  connect(betaOneSignal.y, yPositionPID.beta) annotation(Line(origin = {0, 0},
    points = {{-548.2, 390}, {-432, 390}, {-432, 51.3333}, {-261.8, 51.3333}},
    color = {0, 0, 0}));
  connect(lateralGammaSignal.y, xPositionPID.gamma) annotation(Line(origin = {0, 0},
    points = {{-548.2, 70}, {-432, 70}, {-432, 210}, {-261.8, 210}},
    color = {0, 0, 0}));
  connect(lateralGammaSignal.y, yPositionPID.gamma) annotation(Line(origin = {0, 0},
    points = {{-548.2, 70}, {-432, 70}, {-432, 46.6667}, {-261.8, 46.6667}},
    color = {0, 0, 0}));
  connect(lateralIntegralEnableSignal.y, xPositionPID.integralEnableError) annotation(Line(origin = {0, 0},
    points = {{-408.2, 160}, {-265.6, 160}, {-265.6, 205.333}, {-261.8, 205.333}},
    color = {0, 0, 0}));
  connect(lateralIntegralEnableSignal.y, yPositionPID.integralEnableError) annotation(Line(origin = {0, 0},
    points = {{-408.2, 160}, {-265.6, 160}, {-265.6, 42}, {-261.8, 42}},
    color = {0, 0, 0}));
  connect(commandedAngleMaxSignal.y, xPositionPID.uMax) annotation(Line(origin = {0, 0},
    points = {{-408.2, 130}, {-265.6, 130}, {-265.6, 200.667}, {-261.8, 200.667}},
    color = {0, 0, 0}));
  connect(commandedAngleMaxSignal.y, yPositionPID.uMax) annotation(Line(origin = {0, 0},
    points = {{-408.2, 130}, {-265.6, 130}, {-265.6, 37.3333}, {-261.8, 37.3333}},
    color = {0, 0, 0}));
  connect(commandedAngleMinSignal.y, xPositionPID.uMin) annotation(Line(origin = {0, 0},
    points = {{-408.2, 100}, {-265.6, 100}, {-265.6, 196}, {-261.8, 196}},
    color = {0, 0, 0}));
  connect(commandedAngleMinSignal.y, yPositionPID.uMin) annotation(Line(origin = {0, 0},
    points = {{-408.2, 100}, {-265.6, 100}, {-265.6, 32.6667}, {-261.8, 32.6667}},
    color = {0, 0, 0}));
  connect(lateralKawSignal.y, xPositionPID.kaw) annotation(Line(origin = {0, 0},
    points = {{-408.2, 70}, {-325.6, 70}, {-325.6, 191.333}, {-261.8, 191.333}},
    color = {0, 0, 0}));
  connect(lateralKawSignal.y, yPositionPID.kaw) annotation(Line(origin = {0, 0},
    points = {{-408.2, 70}, {-265.6, 70}, {-265.6, 28}, {-261.8, 28}},
    color = {0, 0, 0}));
  connect(falseResetSignal.y, xPositionPID.reset) annotation(Line(origin = {0, 0},
    points = {{-548.2, 330}, {-432, 330}, {-432, 186.667}, {-261.8, 186.667}},
    color = {0, 0, 0}));
  connect(falseResetSignal.y, yPositionPID.reset) annotation(Line(origin = {0, 0},
    points = {{-548.2, 330}, {-432, 330}, {-432, 23.3333}, {-261.8, 23.3333}},
    color = {0, 0, 0}));
  connect(positionCommandZ, heightPID.ref) annotation(Line(origin = {0, 0},
    points = {{-708, -60}, {-265.6, -60}, {-265.6, -71.3333}, {-261.8, -71.3333}},
    color = {0, 0, 0}));
  connect(positionZ, heightPID.meas) annotation(Line(origin = {0, 0},
    points = {{-708, -90}, {-265.6, -90}, {-265.6, -76}, {-261.8, -76}},
    color = {0, 0, 0}));
  connect(heightKpSignal.y, heightPID.kp) annotation(Line(origin = {0, 0},
    points = {{-548.2, -140}, {-432, -140}, {-432, -80.6667}, {-261.8, -80.6667}},
    color = {0, 0, 0}));
  connect(heightKiSignal.y, heightPID.ki) annotation(Line(origin = {0, 0},
    points = {{-548.2, -170}, {-432, -170}, {-432, -85.3333}, {-261.8, -85.3333}},
    color = {0, 0, 0}));
  connect(heightKdSignal.y, heightPID.kd) annotation(Line(origin = {0, 0},
    points = {{-548.2, -200}, {-432, -200}, {-432, -90}, {-261.8, -90}},
    color = {0, 0, 0}));
  connect(betaOneSignal.y, heightPID.beta) annotation(Line(origin = {0, 0},
    points = {{-548.2, 390}, {-432, 390}, {-432, -94.6667}, {-261.8, -94.6667}},
    color = {0, 0, 0}));
  connect(heightGammaSignal.y, heightPID.gamma) annotation(Line(origin = {0, 0},
    points = {{-548.2, -230}, {-432, -230}, {-432, -99.3333}, {-261.8, -99.3333}},
    color = {0, 0, 0}));
  connect(heightIntegralEnableSignal.y, heightPID.integralEnableError) annotation(Line(origin = {0, 0},
    points = {{-408.2, -140}, {-265.6, -140}, {-265.6, -104}, {-261.8, -104}},
    color = {0, 0, 0}));
  connect(heightOutputMaxSignal.y, heightPID.uMax) annotation(Line(origin = {0, 0},
    points = {{-408.2, -170}, {-265.6, -170}, {-265.6, -108.667}, {-261.8, -108.667}},
    color = {0, 0, 0}));
  connect(heightOutputMinSignal.y, heightPID.uMin) annotation(Line(origin = {0, 0},
    points = {{-408.2, -200}, {-265.6, -200}, {-265.6, -113.333}, {-261.8, -113.333}},
    color = {0, 0, 0}));
  connect(heightKawSignal.y, heightPID.kaw) annotation(Line(origin = {0, 0},
    points = {{-408.2, -230}, {-265.6, -230}, {-265.6, -118}, {-261.8, -118}},
    color = {0, 0, 0}));
  connect(falseResetSignal.y, heightPID.reset) annotation(Line(origin = {0, 0},
    points = {{-548.2, 330}, {-432, 330}, {-432, -122.667}, {-261.8, -122.667}},
    color = {0, 0, 0}));
  connect(heightPID.u, heightCollectiveCommand.u1) annotation(Line(origin = {0, 0},
    points = {{-178.2, -76}, {288.2, -76}, {288.2, -75}},
    color = {0, 0, 0}));
  connect(hoverThrustSignal.y, heightCollectiveCommand.u2) annotation(Line(points = {{-420, -260}, {300, -80}}, color = {0, 0, 0}));
  connect(xPositionPID.u, pitchPID.ref) annotation(Line(origin = {0, 0},
    points = {{-178.2, 233.333}, {34.4, 233.333}, {34.4, -114.333}, {88.2, -114.333}},
    color = {0, 0, 0}));
  connect(pitchAngle, pitchPID.meas) annotation(Line(origin = {0, 0},
    points = {{-708, -210}, {-572, -210}, {-572, -188}, {34.4, -188}, {34.4, -119}, {88.2, -119}},
    color = {0, 0, 0}));
  connect(yPositionPID.u, rollPID.ref) annotation(Line(origin = {0, 0},
    points = {{-178.2, 70}, {34.4, 70}, {34.4, -308}, {88.2, -308}},
    color = {0, 0, 0}));
  connect(rollAngle, rollMeasurementSign.u) annotation(Line(points = {{-720, -330}, {-460, -330}}, color = {0, 0, 0}));
  connect(rollMeasurementSign.y, rollPID.meas) annotation(Line(origin = {0, 0},
    points = {{-448.2, -330}, {84.4, -330}, {84.4, -312.667}, {88.2, -312.667}},
    color = {0, 0, 0}));
  connect(attitudeKpSignal.y, pitchPID.kp) annotation(Line(origin = {0, 0},
    points = {{-108.2, -260}, {-32, -260}, {-32, -123.667}, {88.2, -123.667}},
    color = {0, 0, 0}));
  connect(attitudeKpSignal.y, rollPID.kp) annotation(Line(origin = {0, 0},
    points = {{-108.2, -260}, {-32, -260}, {-32, -272}, {84.4, -272}, {84.4, -317.333}, {88.2, -317.333}},
    color = {0, 0, 0}));
  connect(attitudeKiSignal.y, pitchPID.ki) annotation(Line(origin = {0, 0},
    points = {{-108.2, -290}, {-32, -290}, {-32, -128.333}, {88.2, -128.333}},
    color = {0, 0, 0}));
  connect(attitudeKiSignal.y, rollPID.ki) annotation(Line(origin = {0, 0},
    points = {{-108.2, -290}, {-32, -290}, {-32, -302}, {84.4, -302}, {84.4, -322}, {88.2, -322}},
    color = {0, 0, 0}));
  connect(attitudeKdSignal.y, pitchPID.kd) annotation(Line(origin = {0, 0},
    points = {{-108.2, -320}, {-32, -320}, {-32, -133}, {88.2, -133}},
    color = {0, 0, 0}));
  connect(attitudeKdSignal.y, rollPID.kd) annotation(Line(origin = {0, 0},
    points = {{-108.2, -320}, {-32, -320}, {-32, -332}, {84.4, -332}, {84.4, -326.667}, {88.2, -326.667}},
    color = {0, 0, 0}));
  connect(betaOneSignal.y, pitchPID.beta) annotation(Line(origin = {0, 0},
    points = {{-548.2, 390}, {-432, 390}, {-432, 378}, {34.4, 378}, {34.4, -137.667}, {88.2, -137.667}},
    color = {0, 0, 0}));
  connect(betaOneSignal.y, rollPID.beta) annotation(Line(origin = {0, 0},
    points = {{-548.2, 390}, {-432, 390}, {-432, 378}, {125.6, 378}, {125.6, -303.667}, {84.4, -303.667}, {84.4, -331.333}, {88.2, -331.333}},
    color = {0, 0, 0}));
  connect(gammaZeroSignal.y, pitchPID.gamma) annotation(Line(origin = {0, 0},
    points = {{-548.2, 360}, {-432, 360}, {-432, 348}, {-265.6, 348}, {-265.6, -142.333}, {88.2, -142.333}},
    color = {0, 0, 0}));
  connect(gammaZeroSignal.y, rollPID.gamma) annotation(Line(origin = {0, 0},
    points = {{-548.2, 360}, {-432, 360}, {-432, 348}, {-265.6, 348}, {-265.6, 304.333}, {175.6, 304.333}, {175.6, -363.667}, {84.4, -363.667}, {84.4, -336}, {88.2, -336}},
    color = {0, 0, 0}));
  connect(attitudeIntegralEnableSignal.y, pitchPID.integralEnableError) annotation(Line(origin = {0, 0},
    points = {{-8.2, -260}, {34.4, -260}, {34.4, -147}, {88.2, -147}},
    color = {0, 0, 0}));
  connect(attitudeIntegralEnableSignal.y, rollPID.integralEnableError) annotation(Line(origin = {0, 0},
    points = {{-8.2, -260}, {84.4, -260}, {84.4, -340.667}, {88.2, -340.667}},
    color = {0, 0, 0}));
  connect(attitudeOutputMaxSignal.y, pitchPID.uMax) annotation(Line(origin = {0, 0},
    points = {{-8.2, -290}, {34.4, -290}, {34.4, -151.667}, {88.2, -151.667}},
    color = {0, 0, 0}));
  connect(attitudeOutputMaxSignal.y, rollPID.uMax) annotation(Line(origin = {0, 0},
    points = {{-8.2, -290}, {84.4, -290}, {84.4, -345.333}, {88.2, -345.333}},
    color = {0, 0, 0}));
  connect(attitudeOutputMinSignal.y, pitchPID.uMin) annotation(Line(origin = {0, 0},
    points = {{-8.2, -320}, {34.4, -320}, {34.4, -156.333}, {88.2, -156.333}},
    color = {0, 0, 0}));
  connect(attitudeOutputMinSignal.y, rollPID.uMin) annotation(Line(origin = {0, 0},
    points = {{-8.2, -320}, {84.4, -320}, {84.4, -350}, {88.2, -350}},
    color = {0, 0, 0}));
  connect(attitudeKawSignal.y, pitchPID.kaw) annotation(Line(origin = {0, 0},
    points = {{-8.2, -350}, {34.4, -350}, {34.4, -161}, {88.2, -161}},
    color = {0, 0, 0}));
  connect(attitudeKawSignal.y, rollPID.kaw) annotation(Line(origin = {0, 0},
    points = {{-8.2, -350}, {84.4, -350}, {84.4, -354.667}, {88.2, -354.667}},
    color = {0, 0, 0}));
  connect(falseResetSignal.y, pitchPID.reset) annotation(Line(origin = {0, 0},
    points = {{-548.2, 330}, {-432, 330}, {-432, 318}, {-265.6, 318}, {-265.6, -165.667}, {88.2, -165.667}},
    color = {0, 0, 0}));
  connect(falseResetSignal.y, rollPID.reset) annotation(Line(origin = {0, 0},
    points = {{-548.2, 330}, {-432, 330}, {-432, 318}, {-265.6, 318}, {-265.6, 304.333}, {175.6, 304.333}, {175.6, -363.667}, {84.4, -363.667}, {84.4, -359.333}, {88.2, -359.333}},
    color = {0, 0, 0}));
  connect(yawPID.u, yawMixGain.u) annotation(Line(origin = {0, 0},
    points = {{-178.2, 355.333}, {284.4, 355.333}, {284.4, 250}, {288.2, 250}},
    color = {0, 0, 0}));
  connect(pitchPID.u, pitchMixGain.u) annotation(Line(origin = {0, 0},
    points = {{171.8, -119}, {284.4, -119}, {284.4, 170}, {288.2, 170}},
    color = {0, 0, 0}));
  connect(rollPID.u, rollMixGain.u) annotation(Line(origin = {0, 0},
    points = {{171.8, -312.667}, {284.4, -312.667}, {284.4, 90}, {288.2, 90}},
    color = {0, 0, 0}));
  connect(yawMixGain.y, motor1Attitude.u1) annotation(Line(origin = {0, 0},
    points = {{311.8, 250}, {474.4, 250}, {474.4, 216.667}, {478.2, 216.667}},
    color = {0, 0, 0}));
  connect(pitchMixGain.y, motor1Attitude.u2) annotation(Line(origin = {0, 0},
    points = {{311.8, 170}, {474.4, 170}, {474.4, 210}, {478.2, 210}},
    color = {0, 0, 0}));
  connect(rollMixGain.y, motor1Attitude.u3) annotation(Line(origin = {0, 0},
    points = {{311.8, 90}, {444.4, 90}, {444.4, 203.333}, {478.2, 203.333}},
    color = {0, 0, 0}));
  connect(yawMixGain.y, motor2Attitude.u1) annotation(Line(origin = {0, 0},
    points = {{311.8, 250}, {474.4, 250}, {474.4, 103.333}, {478.2, 103.333}},
    color = {0, 0, 0}));
  connect(pitchMixGain.y, motor2Attitude.u2) annotation(Line(origin = {0, 0},
    points = {{311.8, 170}, {474.4, 170}, {474.4, 96.6667}, {478.2, 96.6667}},
    color = {0, 0, 0}));
  connect(rollMixGain.y, motor2Attitude.u3) annotation(Line(origin = {0, 0},
    points = {{311.8, 90}, {478.2, 90}},
    color = {0, 0, 0}));
  connect(yawMixGain.y, motor3Attitude.u1) annotation(Line(origin = {0, 0},
    points = {{311.8, 250}, {454.4, 250}, {454.4, -18.3333}, {458.2, -18.3333}},
    color = {0, 0, 0}));
  connect(pitchMixGain.y, motor3Attitude.u2) annotation(Line(origin = {0, 0},
    points = {{311.8, 170}, {454.4, 170}, {454.4, -25}, {458.2, -25}},
    color = {0, 0, 0}));
  connect(rollMixGain.y, motor3Attitude.u3) annotation(Line(origin = {0, 0},
    points = {{311.8, 90}, {454.4, 90}, {454.4, -31.6667}, {458.2, -31.6667}},
    color = {0, 0, 0}));
  connect(yawMixGain.y, motor4Attitude.u1) annotation(Line(origin = {0, 0},
    points = {{311.8, 250}, {424.4, 250}, {424.4, -154.333}, {428.2, -154.333}},
    color = {0, 0, 0}));
  connect(pitchMixGain.y, motor4Attitude.u2) annotation(Line(origin = {0, 0},
    points = {{311.8, 170}, {424.4, 170}, {424.4, -161}, {428.2, -161}},
    color = {0, 0, 0}));
  connect(rollMixGain.y, motor4Attitude.u3) annotation(Line(origin = {0, 0},
    points = {{311.8, 90}, {424.4, 90}, {424.4, -167.667}, {428.2, -167.667}},
    color = {0, 0, 0}));
  connect(motor1Attitude.y, motor1Command.u1) annotation(Line(origin = {0, 0},
    points = {{501.8, 210}, {614.4, 210}, {614.4, 215}, {628.2, 215}},
    color = {0, 0, 0}));
  connect(motor2Attitude.y, motor2Command.u1) annotation(Line(origin = {0, 0},
    points = {{501.8, 96.6667}, {628.2, 96.6667}},
    color = {0, 0, 0}));
  connect(motor3Attitude.y, motor3Command.u1) annotation(Line(origin = {0, 0},
    points = {{481.8, -25}, {628.2, -25}},
    color = {0, 0, 0}));
  connect(motor4Attitude.y, motor4Command.u1) annotation(Line(origin = {0, 0},
    points = {{451.8, -161}, {614.4, -161}, {614.4, -151}, {628.2, -151}},
    color = {0, 0, 0}));
  connect(heightCollectiveCommand.y, motor1Command.u2) annotation(Line(origin = {0, 0},
    points = {{311.8, -80}, {614.4, -80}, {614.4, 205}, {628.2, 205}},
    color = {0, 0, 0}));
  connect(heightCollectiveCommand.y, motor2Command.u2) annotation(Line(origin = {0, 0},
    points = {{311.8, -80}, {614.4, -80}, {614.4, 86.6667}, {628.2, 86.6667}},
    color = {0, 0, 0}));
  connect(heightCollectiveCommand.y, motor3Command.u2) annotation(Line(origin = {0, 0},
    points = {{311.8, -80}, {624.4, -80}, {624.4, -35}, {628.2, -35}},
    color = {0, 0, 0}));
  connect(heightCollectiveCommand.y, motor4Command.u2) annotation(Line(origin = {0, 0},
    points = {{311.8, -80}, {624.4, -80}, {624.4, -161}, {628.2, -161}},
    color = {0, 0, 0}));
  connect(motor1Command.y, motor1Sign.u) annotation(Line(origin = {0, 0},
    points = {{651.8, 210}, {778.2, 210}},
    color = {0, 0, 0}));
  connect(motor2Command.y, motor2Sign.u) annotation(Line(origin = {0, 0},
    points = {{651.8, 91.6667}, {774.4, 91.6667}, {774.4, 90}, {778.2, 90}},
    color = {0, 0, 0}));
  connect(motor3Command.y, motor3Sign.u) annotation(Line(origin = {0, 0},
    points = {{651.8, -30}, {778.2, -30}},
    color = {0, 0, 0}));
  connect(motor4Command.y, motor4Sign.u) annotation(Line(origin = {0, 0},
    points = {{651.8, -156}, {774.4, -156}, {774.4, -150}, {778.2, -150}},
    color = {0, 0, 0}));
  connect(motor1Sign.y, y) annotation(Line(points = {{790, 210}, {940, 210}}, color = {0, 0, 0}));
  connect(motor2Sign.y, y1) annotation(Line(points = {{790, 90}, {940, 90}}, color = {0, 0, 0}));
  connect(motor3Sign.y, y2) annotation(Line(points = {{790, -30}, {940, -30}}, color = {0, 0, 0}));
  connect(motor4Sign.y, y3) annotation(Line(points = {{790, -150}, {940, -150}}, color = {0, 0, 0}));
end EnhancedPIDController;