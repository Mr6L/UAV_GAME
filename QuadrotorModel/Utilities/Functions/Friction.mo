within QuadrotorModel.Utilities.Functions;
      function Friction "摩擦力"
        extends Modelica.Icons.Function;
        import SI = Modelica.SIunits;
        //输入参数
        input Modelica.Units.SI.Force N "法向载荷";
        input Modelica.Units.SI.Velocity V "相对滑移速度";
        input Modelica.Units.SI.Velocity V_s "最大静摩擦对应的相对滑移速度";
        input Modelica.Units.SI.CoefficientOfFriction Cst "静摩擦系数";
        input Modelica.Units.SI.Velocity Vtr "动摩擦对应的相对滑移速度";
        input Modelica.Units.SI.CoefficientOfFriction Cdy "动摩擦系数";
        output Modelica.Units.SI.Force F_f "摩擦力";
        annotation(__MWORKS(version="26.2.1"));
        //中间变量
      algorithm
        F_f := N * QuadrotorModel.Utilities.Functions.Step(V, -V_s, -1, V_s, 1) * QuadrotorModel.Utilities.Functions.Step(abs(V), V_s, Cst, Vtr, Cdy);
      end Friction;