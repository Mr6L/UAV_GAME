within QuadrotorModel.Blocks.ControlMethod;
model EnhancedPIDSysblock "Enhanced single-axis PID Sysblock with gated anti-windup, leak, reset, and diagnostics"
  extends ModelWorkspace;
  import SysplorerEmbeddedCoder.Types.*;
  import BaseWorkspace.*;
  annotation(__MWORKS(version = "26.2.1",PortArrangement(Left(ref, meas, kp, ki, kd, beta, gamma, integralEnableError, uMax, uMin, kaw, reset), Right(u, error, satError, sat_flag)),modelType = Control,BlockSystem(blockKind = BlockKind.userModel,SampleTime(auto=true,group = "")=0.02,OutputInterval = 0.02),SysblockVersion = "1.0"),
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Diagram(coordinateSystem(extent = {{-700, -520}, {850, 260}}, grid = {10, 10})),
    experiment(Algorithm = Euler, Interval = -1));
  SysplorerEmbeddedCoder.Port.Inport ref 
    annotation(Placement(transformation(origin = {-650, 160}, extent = {{-17, -12}, {17, 12}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport meas 
    annotation(Placement(transformation(origin = {-650, 90}, extent = {{-17, -12}, {17, 12}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport kp 
    annotation(Placement(transformation(origin = {-650, 20}, extent = {{-17, -12}, {17, 12}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport ki 
    annotation(Placement(transformation(origin = {-650, -40}, extent = {{-17, -12}, {17, 12}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport kd 
    annotation(Placement(transformation(origin = {-650, -100}, extent = {{-17, -12}, {17, 12}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport beta 
    annotation(Placement(transformation(origin = {-650, 207.01},
    extent = {{-17, -12}, {17, 12}}),
    iconTransformation(origin = {-101.8, 8.33333},
    extent = {{-1.8, -1.8}, {1.8, 1.8}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport gamma 
    annotation(Placement(transformation(origin = {-650, -160}, extent = {{-17, -12}, {17, 12}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport integralEnableError 
    annotation(Placement(transformation(origin = {-650, -230}, extent = {{-17, -12}, {17, 12}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport uMax 
    annotation(Placement(transformation(origin = {-650, -300}, extent = {{-17, -12}, {17, 12}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport uMin 
    annotation(Placement(transformation(origin = {-650, -360}, extent = {{-17, -12}, {17, 12}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport kaw 
    annotation(Placement(transformation(origin = {-650, -430}, extent = {{-17, -12}, {17, 12}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Inport reset 
    annotation(Placement(transformation(origin = {-650, -500}, extent = {{-17, -12}, {17, 12}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Outport u 
    annotation(Placement(transformation(origin = {910, 90.0095},
    extent = {{-17, -12}, {17, 12}}),
    iconTransformation(origin = {101.8, 75},
    extent = {{-1.8, -1.8}, {1.8, 1.8}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Outport error 
    annotation(Placement(transformation(origin = {910, -39.9905},
    extent = {{-17, -12}, {17, 12}}),
    iconTransformation(origin = {101.8, 25},
    extent = {{-1.8, -1.8}, {1.8, 1.8}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Outport satError 
    annotation(Placement(transformation(origin = {910, -129.99},
    extent = {{-17, -12}, {17, 12}}),
    iconTransformation(origin = {101.8, -25},
    extent = {{-1.8, -1.8}, {1.8, 1.8}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="double"),Dimension=1)));
  SysplorerEmbeddedCoder.Port.Outport sat_flag 
    annotation(Placement(transformation(origin = {910, -219.99},
    extent = {{-17, -12}, {17, 12}}),
    iconTransformation(origin = {101.8, -75},
    extent = {{-1.8, -1.8}, {1.8, 1.8}})), __MWORKS(BlockSystem(SampleTime(group="D0")=0,Type(ref="boolean"),Dimension=1)));
  SysplorerEmbeddedCoder.MathOperation.Product betaProduct 
    annotation(Placement(transformation(origin = {-500, 200}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum pErrorSum(inputs = "+-", isSaturate = false) 
    annotation(Placement(transformation(origin = {-350, 180}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0),PortLabels(labelType = "CustomType", labels(label(text = "+", instance = "u1"), label(text = "-", instance = "u2")))));
  SysplorerEmbeddedCoder.MathOperation.Product pProduct 
    annotation(Placement(transformation(origin = {-200, 180}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum errorSum(inputs = "+-", isSaturate = false) 
    annotation(Placement(transformation(origin = {-500, 56},
    extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0),PortLabels(labelType = "CustomType", labels(label(text = "+", instance = "u1"), label(text = "-", instance = "u2")))));
  SysplorerEmbeddedCoder.MathOperation.Abs absError 
    annotation(Placement(transformation(origin = {-350, -4},
    extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator integralEnableCompare(op = SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator.Operators.LE) 
    annotation(Placement(transformation(origin = {-140, 23},
    extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant zeroIntegralInput(k = 0) 
    annotation(Placement(transformation(origin = {-180, -50}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(SampleTime(auto=true,group="D0")=0,Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)))));
  SysplorerEmbeddedCoder.SignalRouting.Switch integralSeparationSwitch(ct = SysplorerEmbeddedCoder.SignalRouting.Switch.ConditionType.GE, threshold = 0.5) 
    annotation(Placement(transformation(origin = {39, 20},
    extent = {{-21, -17}, {21, 17}})), __MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="boolean"),Dimension=1),
u3(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
threshold(Type(ref="boolean"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product kiProduct 
    annotation(Placement(transformation(origin = {180, 20}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant epsSignal(k = eps) 
    annotation(Placement(transformation(origin = {-500, -276},
    extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(SampleTime(auto=true,group="D0")=0,Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)))));
  SysplorerEmbeddedCoder.Sources.Constant zeroSignal(k = 0) 
    annotation(Placement(transformation(origin = {-500, -330}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(SampleTime(auto=true,group="D0")=0,Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)))));
  SysplorerEmbeddedCoder.MathOperation.Abs absKi 
    annotation(Placement(transformation(origin = {-350, -250}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator kiActiveCompare(op = SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator.Operators.GE) 
    annotation(Placement(transformation(origin = {-200, -250}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator kawActiveCompare(op = SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator.Operators.GE) 
    annotation(Placement(transformation(origin = {-200, -330}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product antiWindupProduct 
    annotation(Placement(transformation(origin = {280, -210}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.SignalRouting.Switch antiWindupKiSwitch(ct = SysplorerEmbeddedCoder.SignalRouting.Switch.ConditionType.GE, threshold = 0.5) 
    annotation(Placement(transformation(origin = {430, -230}, extent = {{-21, -17}, {21, 17}})), __MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="boolean"),Dimension=1),
u3(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
threshold(Type(ref="boolean"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.SignalRouting.Switch antiWindupActiveSwitch(ct = SysplorerEmbeddedCoder.SignalRouting.Switch.ConditionType.GE, threshold = 0.5) 
    annotation(Placement(transformation(origin = {570, -230}, extent = {{-21, -17}, {21, 17}})), __MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="boolean"),Dimension=1),
u3(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1),
threshold(Type(ref="boolean"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.Sources.Constant leakRateSignal(k = leakRate) 
    annotation(Placement(transformation(origin = {180, -90}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(SampleTime(auto=true,group="D0")=0,Instance(y(Type(ref="double"),Dimension=1),
k(Type(ref="double"),Dimension=1)))));
  SysplorerEmbeddedCoder.MathOperation.Product leakProduct 
    annotation(Placement(transformation(origin = {360, -70}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum integratorInputSum(inputs = "++-", isSaturate = false) 
    annotation(Placement(transformation(origin = {650, 20}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0),PortLabels(labelType = "CustomType", labels(label(text = "+", instance = "u1"), label(text = "+", instance = "u2"), label(text = "-", instance = "u3")))));
  SysplorerEmbeddedCoder.Continuous.Integrator iTermIntegrator(externalResetType = SysplorerEmbeddedCoder.Continuous.Integrator.ExternalResetType.Level, initCond = 0, zeroCross = true, limitOutput = false) 
    annotation(Placement(transformation(origin = {651, 156},
    extent = {{-20, -16}, {20, 16}})), __MWORKS(BlockSystem(zeroCross=true,Instance(u1(Dimension=1),
u2(Type(ref="double"),Dimension=1),
y(Dimension=1),
initCond(Dimension=1),
absoluteTolerance(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product gammaProduct 
    annotation(Placement(transformation(origin = {-500, -132},
    extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum dErrorSum(inputs = "+-", isSaturate = false) 
    annotation(Placement(transformation(origin = {-350, -130}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0),PortLabels(labelType = "CustomType", labels(label(text = "+", instance = "u1"), label(text = "-", instance = "u2")))));
  SysplorerEmbeddedCoder.Continuous.Derivative filteredDerivative(CoeffcientInTFapproximation = derivativeFilterN) 
    annotation(Placement(transformation(origin = {-200, -130}, extent = {{-20, -16}, {20, 16}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Product dProduct 
    annotation(Placement(transformation(origin = {-30, -123},
    extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum rawControlSum(inputs = "+++", isSaturate = false) 
    annotation(Placement(transformation(origin = {500, 100}, extent = {{-21, -17}, {21, 17}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
u3(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0),PortLabels(labelType = "CustomType", labels(label(text = "+", instance = "u1"), label(text = "+", instance = "u2"), label(text = "+", instance = "u3")))));
  SysplorerEmbeddedCoder.Discontinuities.SaturationDynamic outputSaturation 
    annotation(Placement(transformation(origin = {650, 90}, extent = {{-21, -17}, {21, 17}})), __MWORKS(BlockSystem(Instance(upperLimit(Type(ref="double"),Dimension=1),
u(Type(ref="double"),Dimension=1),
lowerLimit(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum saturationErrorSum(inputs = "+-", isSaturate = false) 
    annotation(Placement(transformation(origin = {650, -130}, extent = {{-21, -17}, {21, 17}})), __MWORKS(BlockSystem(Instance(u(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1)),
y(Type(ref="double"),Dimension=1)),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime(group="D0")=0),PortLabels(labelType = "CustomType", labels(label(text = "+", instance = "u1"), label(text = "-", instance = "u2")))));
  SysplorerEmbeddedCoder.MathOperation.Abs absSatError 
    annotation(Placement(transformation(origin = {650, -220}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u(Type(ref="double"),Dimension=1),
y(Type(ref="double"),Dimension=1)),SampleTime(group="D0")=0)));
  SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator satFlagCompare(op = SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator.Operators.GE) 
    annotation(Placement(transformation(origin = {720, -220}, extent = {{-17, -14}, {17, 14}})), __MWORKS(BlockSystem(Instance(u1(Type(ref="double"),Dimension=1),
u2(Type(ref="double"),Dimension=1),
y(Dimension=1)),SampleTime(group="D0")=0)));
  model ModelWorkspace
    annotation(__MWORKS(hide=true,BlockSystem(blockKind=BlockKind.modelWorkspace)));
    parameter RealAuto eps = 1e-9 "Deadband for Ki and saturation diagnostics" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto leakRate = 0 "Integral leak rate; 0 keeps the previous no-leak behavior" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
    parameter RealAuto derivativeFilterN = 50 "Derivative filter coefficient N in Kd*N*s/(s+N)" annotation(__MWORKS(BlockSystem(Type(inherit=InheritType.none,ref="double"))), HideResult=true);
  end ModelWorkspace;
equation
  connect(ref, errorSum.u1) annotation(Line(origin = {0, 0},
    points = {{-630.954, 159.99}, {-522.6, 159.99}, {-522.6, 63}, {-518.8, 63}},
    color = {0, 0, 0}));
  connect(meas, errorSum.u2) annotation(Line(origin = {0, 0},
    points = {{-630.954, 89.9905}, {-522.6, 89.9905}, {-522.6, 49}, {-518.8, 49}},
    color = {0, 0, 0}));
  connect(errorSum.y, error) annotation(Line(origin = {110, 0.00951024},
    points = {{-591.2, 55.9905}, {750, 55.9905}, {750, -40.0095}, {780.999, -40.0095}},
    color = {0, 0, 0}));
  connect(ref, betaProduct.u1) annotation(Line(origin = {0, 0},
    points = {{-630.954, 159.99}, {-522.6, 159.99}, {-522.6, 207}, {-518.8, 207}},
    color = {0, 0, 0}));
  connect(beta, betaProduct.u2) annotation(Line(origin = {0, 0},
    points = {{-630.954, 207}, {-522.6, 207}, {-522.6, 193}, {-518.8, 193}},
    color = {0, 0, 0}));
  connect(betaProduct.y, pErrorSum.u1) annotation(Line(origin = {0, 0},
    points = {{-481.2, 200}, {-372.6, 200}, {-372.6, 187}, {-368.8, 187}},
    color = {0, 0, 0}));
  connect(meas, pErrorSum.u2) annotation(Line(origin = {0, 0},
    points = {{-630.954, 89.9905}, {-372.6, 89.9905}, {-372.6, 173}, {-368.8, 173}},
    color = {0, 0, 0}));
  connect(pErrorSum.y, pProduct.u1) annotation(Line(origin = {0, 0},
    points = {{-331.2, 180}, {-222.6, 180}, {-222.6, 187}, {-218.8, 187}},
    color = {0, 0, 0}));
  connect(kp, pProduct.u2) annotation(Line(points = {{-650, 20}, {-200, 180}}, color = {0, 0, 0}));
  connect(pProduct.y, rawControlSum.u1) annotation(Line(origin = {0, 0},
    points = {{-181.2, 180}, {440, 180}, {440, 111.333}, {477.2, 111.333}},
    color = {0, 0, 0}));
  connect(errorSum.y, absError.u) annotation(Line(origin = {0, 0},
    points = {{-481.2, 56}, {-372.6, 56}, {-372.6, -4}, {-368.8, -4}},
    color = {0, 0, 0}));
  connect(absError.y, integralEnableCompare.u1) annotation(Line(origin = {0, 0},
    points = {{-331.2, -4}, {-202.6, -4}, {-202.6, 30}, {-158.8, 30}},
    color = {0, 0, 0}));
  connect(integralEnableError, integralEnableCompare.u2) annotation(Line(origin = {0, 0},
    points = {{-630.954, -230.01}, {-180, -230.01}, {-180, 16}, {-158.8, 16}},
    color = {0, 0, 0}));
  connect(errorSum.y, integralSeparationSwitch.u1) annotation(Line(origin = {0, 0},
    points = {{-481.2, 56}, {-6.6, 56}, {-6.6, 31.3333}, {16.2, 31.3333}},
    color = {0, 0, 0}));
  connect(integralEnableCompare.y, integralSeparationSwitch.u2) annotation(Line(origin = {0, 0},
    points = {{-121.2, 23}, {-6.6, 23}, {-6.6, 20}, {16.2, 20}},
    color = {0, 0, 0}));
  connect(zeroIntegralInput.y, integralSeparationSwitch.u3) annotation(Line(origin = {0, 0},
    points = {{-161.2, -50}, {12.4, -50}, {12.4, 8.66667}, {16.2, 8.66667}},
    color = {0, 0, 0}));
  connect(integralSeparationSwitch.y, kiProduct.u1) annotation(Line(origin = {0, 0},
    points = {{61.8, 20}, {105.9, 20}, {105.9, 27}, {161.2, 27}},
    color = {0, 0, 0}));
  connect(ki, kiProduct.u2) annotation(Line(origin = {0, 0},
    points = {{-630.954, -40.0095}, {140, -40.0095}, {140, 13}, {161.2, 13}},
    color = {0, 0, 0}), __MWORKS(BlockSystem(NamedSignal)));
  connect(kiProduct.y, integratorInputSum.u1) annotation(Line(origin = {0, 0},
    points = {{198.8, 20}, {610, 20}, {610, 29.3333}, {631.2, 29.3333}},
    color = {0, 0, 0}));
  connect(ki, absKi.u) annotation(Line(origin = {0, 0},
    points = {{-630.954, -40.0095}, {-380, -40.0095}, {-380, -250}, {-368.8, -250}},
    color = {0, 0, 0}), __MWORKS(BlockSystem(NamedSignal)));
  connect(absKi.y, kiActiveCompare.u1) annotation(Line(origin = {0, 0},
    points = {{-331.2, -250}, {-327.4, -250}, {-327.4, -243}, {-218.8, -243}},
    color = {0, 0, 0}));
  connect(epsSignal.y, kiActiveCompare.u2) annotation(Line(origin = {0, 0},
    points = {{-481.2, -276}, {-240, -276}, {-240, -257}, {-218.8, -257}},
    color = {0, 0, 0}));
  connect(kaw, kawActiveCompare.u1) annotation(Line(origin = {0, 0},
    points = {{-630.954, -430.01}, {-260, -430.01}, {-260, -323}, {-218.8, -323}},
    color = {0, 0, 0}));
  connect(zeroSignal.y, kawActiveCompare.u2) annotation(Line(origin = {0, 0},
    points = {{-481.2, -330}, {-222.6, -330}, {-222.6, -337}, {-218.8, -337}},
    color = {0, 0, 0}), __MWORKS(BlockSystem(NamedSignal)));
  connect(saturationErrorSum.y, antiWindupProduct.u1) annotation(Line(origin = {0, 0},
    points = {{672.8, -130}, {190, -130}, {190, -203}, {261.2, -203}},
    color = {0, 0, 0}));
  connect(kaw, antiWindupProduct.u2) annotation(Line(origin = {0, 0},
    points = {{-630.954, -430.01}, {190, -430.01}, {190, -217}, {261.2, -217}},
    color = {0, 0, 0}));
  connect(antiWindupProduct.y, antiWindupKiSwitch.u1) annotation(Line(origin = {0, 0},
    points = {{298.8, -210}, {302.6, -210}, {302.6, -218.667}, {407.2, -218.667}},
    color = {0, 0, 0}));
  connect(kiActiveCompare.y, antiWindupKiSwitch.u2) annotation(Line(origin = {0, 0},
    points = {{-181.2, -250}, {380, -250}, {380, -230}, {407.2, -230}},
    color = {0, 0, 0}));
  connect(zeroSignal.y, antiWindupKiSwitch.u3) annotation(Line(origin = {0, 0},
    points = {{-481.2, -330}, {360, -330}, {360, -241.333}, {407.2, -241.333}},
    color = {0, 0, 0}), __MWORKS(BlockSystem(NamedSignal)));
  connect(antiWindupKiSwitch.y, antiWindupActiveSwitch.u1) annotation(Line(origin = {0, 0},
    points = {{452.8, -230}, {510, -230}, {510, -200}, {543.4, -200}, {543.4, -218.667}, {547.2, -218.667}},
    color = {0, 0, 0}), __MWORKS(BlockSystem(NamedSignal)));
  connect(kawActiveCompare.y, antiWindupActiveSwitch.u2) annotation(Line(origin = {0, 0},
    points = {{-181.2, -330}, {-177.4, -330}, {-177.4, -340}, {490, -340}, {490, -220}, {530, -220}, {530, -230}, {547.2, -230}},
    color = {0, 0, 0}));
  connect(zeroSignal.y, antiWindupActiveSwitch.u3) annotation(Line(origin = {0, 0},
    points = {{-481.2, -330}, {520, -330}, {520, -241.333}, {547.2, -241.333}},
    color = {0, 0, 0}), __MWORKS(BlockSystem(NamedSignal)));
  connect(antiWindupActiveSwitch.y, integratorInputSum.u2) annotation(Line(origin = {0, 0},
    points = {{592.8, -230}, {596.6, -230}, {596.6, 10}, {627.4, 10}, {627.4, 20}, {631.2, 20}},
    color = {0, 0, 0}));
  connect(iTermIntegrator.y, leakProduct.u1) annotation(Line(origin = {0, 0},
    points = {{672.8, 156}, {710, 156}, {710, 40}, {320, 40}, {320, -63}, {341.2, -63}},
    color = {0, 0, 0}));
  connect(leakRateSignal.y, leakProduct.u2) annotation(Line(origin = {0, 0},
    points = {{198.8, -90}, {320, -90}, {320, -77}, {341.2, -77}},
    color = {0, 0, 0}));
  connect(leakProduct.y, integratorInputSum.u3) annotation(Line(points = {{360, -70}, {650, 20}}, color = {0, 0, 0}));
  connect(integratorInputSum.y, iTermIntegrator.u1) annotation(Line(origin = {0, 0},
    points = {{668.8, 20}, {672.6, 20}, {672.6, 36}, {540, 36}, {540, 164}, {629.2, 164}},
    color = {0, 0, 0}), __MWORKS(BlockSystem(NamedSignal)));
  connect(reset, iTermIntegrator.u2) annotation(Line(origin = {0, 0},
    points = {{-630.954, -500.01}, {580, -500.01}, {580, 148}, {629.2, 148}},
    color = {0, 0, 0}), __MWORKS(BlockSystem(NamedSignal)));
  connect(iTermIntegrator.y, rawControlSum.u2) annotation(Line(origin = {0, 0},
    points = {{672.8, 156}, {676.6, 156}, {676.6, 138}, {473.4, 138}, {473.4, 100}, {477.2, 100}},
    color = {0, 0, 0}));
  connect(ref, gammaProduct.u1) annotation(Line(origin = {0, 0},
    points = {{-630.954, 159.99}, {-630.954, -125}, {-518.8, -125}},
    color = {0, 0, 0}));
  connect(gamma, gammaProduct.u2) annotation(Line(origin = {0, 0},
    points = {{-630.954, -160.01}, {-522.6, -160.01}, {-522.6, -139}, {-518.8, -139}},
    color = {0, 0, 0}));
  connect(gammaProduct.y, dErrorSum.u1) annotation(Line(origin = {0, 0},
    points = {{-481.2, -132}, {-372.6, -132}, {-372.6, -123}, {-368.8, -123}},
    color = {0, 0, 0}));
  connect(meas, dErrorSum.u2) annotation(Line(origin = {0, 0},
    points = {{-630.954, 89.9905}, {-410, 89.9905}, {-410, -137}, {-368.8, -137}},
    color = {0, 0, 0}));
  connect(dErrorSum.y, filteredDerivative.u) annotation(Line(points = {{-350, -130}, {-200, -130}}, color = {0, 0, 0}));
  connect(filteredDerivative.y, dProduct.u1) annotation(Line(origin = {0, 0},
    points = {{-178.2, -130}, {-174.4, -130}, {-174.4, -140}, {-70, -140}, {-70, -116}, {-48.8, -116}},
    color = {0, 0, 0}));
  connect(kd, dProduct.u2) annotation(Line(origin = {0, 0},
    points = {{-630.954, -100.01}, {-80, -100.01}, {-80, -130}, {-48.8, -130}},
    color = {0, 0, 0}), __MWORKS(BlockSystem(NamedSignal)));
  connect(dProduct.y, rawControlSum.u3) annotation(Line(origin = {0, 0},
    points = {{-11.2, -123}, {473.4, -123}, {473.4, 88.6667}, {477.2, 88.6667}},
    color = {0, 0, 0}));
  connect(rawControlSum.y, outputSaturation.u) annotation(Line(origin = {0, 0},
    points = {{522.8, 100}, {526.6, 100}, {526.6, 90}, {627.2, 90}},
    color = {0, 0, 0}));
  connect(uMax, outputSaturation.upperLimit) annotation(Line(origin = {0, 0},
    points = {{-630.954, -300.01}, {560, -300.01}, {560, 130}, {600, 130}, {600, 110}, {610, 110}, {610, 101.333}, {627.2, 101.333}},
    color = {0, 0, 0}));
  connect(uMin, outputSaturation.lowerLimit) annotation(Line(origin = {0, 0},
    points = {{-630.954, -360.01}, {600, -360.01}, {600, 78.6667}, {627.2, 78.6667}},
    color = {0, 0, 0}));
  connect(outputSaturation.y, u) annotation(Line(origin = {110, 0.00951024},
    points = {{562.8, 89.9905}, {780.999, 89.9905}},
    color = {0, 0, 0}));
  connect(outputSaturation.y, saturationErrorSum.u1) annotation(Line(origin = {0, 0},
    points = {{672.8, 90}, {730, 90}, {730, -90}, {610, -90}, {610, -121.5}, {627.2, -121.5}},
    color = {0, 0, 0}));
  connect(rawControlSum.y, saturationErrorSum.u2) annotation(Line(points = {{500, 100}, {650, -130}}, color = {0, 0, 0}));
  connect(saturationErrorSum.y, satError) annotation(Line(origin = {110, 0.00951024},
    points = {{562.8, -130.01}, {780.999, -130.01}},
    color = {0, 0, 0}));
  connect(saturationErrorSum.y, absSatError.u) annotation(Line(origin={0,0},
points={{672.8,-130},{610,-130},{610,-220},{631.2,-220}},
color={0,0,0}));
  connect(absSatError.y, satFlagCompare.u1) annotation(Line(points = {{650, -220}, {720, -220}}, color = {0, 0, 0}));
  connect(epsSignal.y, satFlagCompare.u2) annotation(Line(origin = {0, 0},
    points = {{-481.2, -276}, {697.4, -276}, {697.4, -227}, {701.2, -227}},
    color = {0, 0, 0}));
  connect(satFlagCompare.y, sat_flag) annotation(Line(origin = {110, 0.00951024},
    points = {{628.8, -220.01}, {780.999, -220.01}},
    color = {0, 0, 0}));
end EnhancedPIDSysblock;