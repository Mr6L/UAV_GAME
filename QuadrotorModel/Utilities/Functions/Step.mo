within QuadrotorModel.Utilities.Functions;
      function Step "三次阶跃函数"
        extends Modelica.Icons.Function;
        input Real x "自变量，可以是时间或时间的任一函数";
        input Real x_0 "自变量的STEP函数开始值，可以是常数或函数表达式或设计变量";
        input Real h_0 "STEP函数的初始值，可以是常数或函数表达式或设计变量";
        input Real x_1 "自变量的STEP函数结束值，可以是常数或函数表达式或设计变量";
        input Real h_1 "STEP函数的最终值，可以是常数或函数表达式或设计变量";
        output Real y "函数输出值";
      algorithm
        y := if x <= x_0 then h_0 else if x > x_0 and x < x_1 then h_0 + ((h_1 - h_0) * ((x - x_0) / (x_1 - x_0)) ^ 2) * (3 - 2 * ((x - x_0) / (x_1 - x_0))) else h_1;
      end Step;