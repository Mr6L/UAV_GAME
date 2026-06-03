within QuadrotorModel.Blocks.ControlMethod;
model EnhancedPIDSysblock "Enhanced single-axis PID Sysblock: 2-DOF P/D weighting, integral separation, filtered derivative, dynamic saturation, and back-calculation anti-windup. Integral state is I_term, so Ki is applied once before the integrator."
  extends ModelWorkspace;
  import SysplorerEmbeddedCoder.Types.*;
  import BaseWorkspace.*;
  annotation(__MWORKS(version="26.2.1",PortArrangement(Left(ref, meas, kp, ki, kd, beta, gamma, integralEnableError, uMax, uMin, kaw), Right(u, error, satError)),modelType=Control,BlockSystem(blockKind=BlockKind.userModel,SampleTime(auto=true,group="")=0.02,OutputInterval=0.02),SysblockVersion="1.0"),Icon(coordinateSystem(preserveAspectRatio=false)),experiment(Algorithm=Euler,Interval=-1));
  SysplorerEmbeddedCoder.Port.Inport ref 
    annotation (Placement(transformation(origin = {-620, 150}, extent = {{-17, -12}, {17, 12}})),__MWORKS(BlockSystem(SampleTime=0)));
  SysplorerEmbeddedCoder.Port.Inport meas 
    annotation (Placement(transformation(origin = {-620, 80}, extent = {{-17, -12}, {17, 12}})),__MWORKS(BlockSystem(SampleTime=0)));
  SysplorerEmbeddedCoder.Port.Inport kp 
    annotation (Placement(transformation(origin = {-620, 10}, extent = {{-17, -12}, {17, 12}})),__MWORKS(BlockSystem(SampleTime=0)));
  SysplorerEmbeddedCoder.Port.Inport ki 
    annotation (Placement(transformation(origin = {-620, -50}, extent = {{-17, -12}, {17, 12}})),__MWORKS(BlockSystem(SampleTime=0)));
  SysplorerEmbeddedCoder.Port.Inport kd 
    annotation (Placement(transformation(origin = {-620, -110}, extent = {{-17, -12}, {17, 12}})),__MWORKS(BlockSystem(SampleTime=0)));
  SysplorerEmbeddedCoder.Port.Inport beta 
    annotation (Placement(transformation(origin = {-620, 210}, extent = {{-17, -12}, {17, 12}})),__MWORKS(BlockSystem(SampleTime=0)));
  SysplorerEmbeddedCoder.Port.Inport gamma 
    annotation (Placement(transformation(origin = {-620, -170}, extent = {{-17, -12}, {17, 12}})),__MWORKS(BlockSystem(SampleTime=0)));
  SysplorerEmbeddedCoder.Port.Inport integralEnableError 
    annotation (Placement(transformation(origin = {-620, -240}, extent = {{-17, -12}, {17, 12}})),__MWORKS(BlockSystem(SampleTime=0)));
  SysplorerEmbeddedCoder.Port.Inport uMax 
    annotation (Placement(transformation(origin = {-620, -310}, extent = {{-17, -12}, {17, 12}})),__MWORKS(BlockSystem(SampleTime=0)));
  SysplorerEmbeddedCoder.Port.Inport uMin 
    annotation (Placement(transformation(origin = {-620, -370}, extent = {{-17, -12}, {17, 12}})),__MWORKS(BlockSystem(SampleTime=0)));
  SysplorerEmbeddedCoder.Port.Inport kaw 
    annotation (Placement(transformation(origin = {-620, -430}, extent = {{-17, -12}, {17, 12}})),__MWORKS(BlockSystem(SampleTime=0)));
  SysplorerEmbeddedCoder.Port.Outport u 
    annotation (Placement(transformation(origin = {780, 80}, extent = {{-17, -12}, {17, 12}})),__MWORKS(BlockSystem(SampleTime=0)));
  SysplorerEmbeddedCoder.Port.Outport error 
    annotation (Placement(transformation(origin = {780, -40}, extent = {{-17, -12}, {17, 12}})),__MWORKS(BlockSystem(SampleTime=0)));
  SysplorerEmbeddedCoder.Port.Outport satError 
    annotation (Placement(transformation(origin = {780, -120}, extent = {{-17, -12}, {17, 12}})),__MWORKS(BlockSystem(SampleTime=0)));
  SysplorerEmbeddedCoder.MathOperation.Product betaProduct 
    annotation (Placement(transformation(origin = {-470, 190}, extent = {{-17, -14}, {17, 14}})),__MWORKS(BlockSystem(Instance(u(u1,u2),y),SampleTime=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum pErrorSum(inputs="+-",isSaturate=false) 
    annotation (Placement(transformation(origin = {-330, 170}, extent = {{-17, -14}, {17, 14}})),__MWORKS(BlockSystem(Instance(u(u1,u2),y),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime=0),PortLabels(labelType="CustomType",labels(label(text="+",instance="u1"),label(text="-",instance="u2")))));
  SysplorerEmbeddedCoder.MathOperation.Product pProduct 
    annotation (Placement(transformation(origin = {-180, 170}, extent = {{-17, -14}, {17, 14}})),__MWORKS(BlockSystem(Instance(u(u1,u2),y),SampleTime=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum errorSum(inputs="+-",isSaturate=false) 
    annotation (Placement(transformation(origin = {-430, 70}, extent = {{-17, -14}, {17, 14}})),__MWORKS(BlockSystem(Instance(u(u1,u2),y),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime=0),PortLabels(labelType="CustomType",labels(label(text="+",instance="u1"),label(text="-",instance="u2")))));
  SysplorerEmbeddedCoder.MathOperation.Abs absError 
    annotation (Placement(transformation(origin = {-300, 35}, extent = {{-17, -14}, {17, 14}})),__MWORKS(BlockSystem(Instance(u,y),SampleTime=0)));
  SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator integralEnableCompare(op=SysplorerEmbeddedCoder.LogicAndBitOperation.RelationalOperator.Operators.LE) 
    annotation (Placement(transformation(origin = {-160, 35}, extent = {{-17, -14}, {17, 14}})),__MWORKS(BlockSystem(Instance(u1,u2,y),SampleTime=0)));
  SysplorerEmbeddedCoder.Sources.Constant zeroIntegralInput(k=0) 
    annotation (Placement(transformation(origin = {-160, -35}, extent = {{-17, -14}, {17, 14}})),__MWORKS(BlockSystem(SampleTime(auto=true),Instance(y,k))));
  SysplorerEmbeddedCoder.SignalRouting.Switch integralSeparationSwitch(ct=SysplorerEmbeddedCoder.SignalRouting.Switch.ConditionType.GE,threshold=0.5) 
    annotation (Placement(transformation(origin = {10, 35}, extent = {{-21, -17}, {21, 17}})),__MWORKS(BlockSystem(Instance(u1,u2,u3,y,threshold),SampleTime=0)));
  SysplorerEmbeddedCoder.MathOperation.Product kiProduct 
    annotation (Placement(transformation(origin = {160, 35}, extent = {{-17, -14}, {17, 14}})),__MWORKS(BlockSystem(Instance(u(u1,u2),y),SampleTime=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum integratorInputSum(inputs="++",isSaturate=false) 
    annotation (Placement(transformation(origin = {300, 35}, extent = {{-17, -14}, {17, 14}})),__MWORKS(BlockSystem(Instance(u(u1,u2),y),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime=0),PortLabels(labelType="CustomType",labels(label(text="+",instance="u1"),label(text="+",instance="u2")))));
  SysplorerEmbeddedCoder.Continuous.Integrator iTermIntegrator(externalResetType=SysplorerEmbeddedCoder.Continuous.Integrator.ExternalResetType.None,initCond=0,zeroCross=true,limitOutput=false) 
    annotation (Placement(transformation(origin = {450, 35}, extent = {{-20, -16}, {20, 16}})),__MWORKS(BlockSystem(zeroCross=true,Instance(u1,y,initCond,absoluteTolerance),SampleTime=0)));
  SysplorerEmbeddedCoder.MathOperation.Product gammaProduct 
    annotation (Placement(transformation(origin = {-470, -145}, extent = {{-17, -14}, {17, 14}})),__MWORKS(BlockSystem(Instance(u(u1,u2),y),SampleTime=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum dErrorSum(inputs="+-",isSaturate=false) 
    annotation (Placement(transformation(origin = {-330, -145}, extent = {{-17, -14}, {17, 14}})),__MWORKS(BlockSystem(Instance(u(u1,u2),y),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime=0),PortLabels(labelType="CustomType",labels(label(text="+",instance="u1"),label(text="-",instance="u2")))));
  SysplorerEmbeddedCoder.Continuous.Derivative filteredDerivative(CoeffcientInTFapproximation=50) 
    annotation (Placement(transformation(origin = {-180, -145}, extent = {{-20, -16}, {20, 16}})),__MWORKS(BlockSystem(Instance(u,y),SampleTime=0)));
  SysplorerEmbeddedCoder.MathOperation.Product dProduct 
    annotation (Placement(transformation(origin = {-20, -145}, extent = {{-17, -14}, {17, 14}})),__MWORKS(BlockSystem(Instance(u(u1,u2),y),SampleTime=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum rawControlSum(inputs="+++",isSaturate=false) 
    annotation (Placement(transformation(origin = {590, 80}, extent = {{-21, -17}, {21, 17}})),__MWORKS(BlockSystem(Instance(u(u1,u2,u3),y),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime=0),PortLabels(labelType="CustomType",labels(label(text="+",instance="u1"),label(text="+",instance="u2"),label(text="+",instance="u3")))));
  SysplorerEmbeddedCoder.Discontinuities.SaturationDynamic outputSaturation 
    annotation (Placement(transformation(origin = {700, 80}, extent = {{-21, -17}, {21, 17}})),__MWORKS(BlockSystem(Instance(upperLimit,u,lowerLimit,y),SampleTime=0)));
  SysplorerEmbeddedCoder.MathOperation.Sum saturationErrorSum(inputs="+-",isSaturate=false) 
    annotation (Placement(transformation(origin = {590, -120}, extent = {{-21, -17}, {21, 17}})),__MWORKS(BlockSystem(Instance(u(u1,u2),y),Type(overflowKind=SysplorerEmbeddedCoder.Types.OverflowKind.wrap),SampleTime=0),PortLabels(labelType="CustomType",labels(label(text="+",instance="u1"),label(text="-",instance="u2")))));
  SysplorerEmbeddedCoder.MathOperation.Product antiWindupProduct 
    annotation (Placement(transformation(origin = {430, -120}, extent = {{-17, -14}, {17, 14}})),__MWORKS(BlockSystem(Instance(u(u1,u2),y),SampleTime=0)));
  model ModelWorkspace
    annotation(__MWORKS(hide = true,BlockSystem(blockKind=BlockKind.modelWorkspace)));
  end ModelWorkspace;
equation
  connect(ref, errorSum.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(meas, errorSum.u2) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(errorSum.y, error) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(ref, betaProduct.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(beta, betaProduct.u2) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(betaProduct.y, pErrorSum.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(meas, pErrorSum.u2) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(pErrorSum.y, pProduct.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(kp, pProduct.u2) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(pProduct.y, rawControlSum.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(errorSum.y, absError.u) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(absError.y, integralEnableCompare.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(integralEnableError, integralEnableCompare.u2) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(errorSum.y, integralSeparationSwitch.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(integralEnableCompare.y, integralSeparationSwitch.u2) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(zeroIntegralInput.y, integralSeparationSwitch.u3) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(integralSeparationSwitch.y, kiProduct.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(ki, kiProduct.u2) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(kiProduct.y, integratorInputSum.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(integratorInputSum.y, iTermIntegrator.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(iTermIntegrator.y, rawControlSum.u2) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(ref, gammaProduct.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(gamma, gammaProduct.u2) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(gammaProduct.y, dErrorSum.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(meas, dErrorSum.u2) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(dErrorSum.y, filteredDerivative.u) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(filteredDerivative.y, dProduct.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(kd, dProduct.u2) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(dProduct.y, rawControlSum.u3) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(rawControlSum.y, outputSaturation.u) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(uMax, outputSaturation.upperLimit) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(uMin, outputSaturation.lowerLimit) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(outputSaturation.y, u) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(outputSaturation.y, saturationErrorSum.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(rawControlSum.y, saturationErrorSum.u2) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(saturationErrorSum.y, satError) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(saturationErrorSum.y, antiWindupProduct.u1) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(kaw, antiWindupProduct.u2) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));
  connect(antiWindupProduct.y, integratorInputSum.u2) 
    annotation(Line(origin = {0.0, 0.0}, points = {{0, 0}, {0, 0}}));

end EnhancedPIDSysblock;
