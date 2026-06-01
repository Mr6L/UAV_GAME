within QuadrotorModel.Experiments;
model MassPerturbation "无人机质量摄动实验"
  parameter Real massScale = 1.25 "机体质量摄动比例";
  extends StepResponseZ(
    quadChassisTest17_1(body(m = 0.159504 * massScale)));
  annotation(experiment(Algorithm=Dassl,InlineIntegrator=false,InlineStepSize=false,NumberOfIntervals=500,StartTime=0,StopTime=50,StoreEventValue=0,Tolerance=0.0001));
end MassPerturbation;