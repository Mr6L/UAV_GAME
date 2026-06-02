within QuadrotorModel.Blocks.Controller;
model ActiveController "Current controller selected for all scenarios"
  parameter Real baselineYawKP = 5 "Legacy baseline yaw loop proportional gain";
  extends QuadrotorModel.Blocks.Controller.BaselinePIDController(yawKP = baselineYawKP);

  annotation (Documentation(info = "<html><p>Switch controllers here. New controllers should extend QuadrotorModel.Blocks.Controller.Interfaces.PartialController and keep the same ports.</p></html>"));
end ActiveController;
