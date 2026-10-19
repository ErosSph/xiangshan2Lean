module ConditionalCore #(parameter W=1)(input clock, sel,
  input [W-1:0] a, b, output [W-1:0] expr, identical,
  output eq, case_eq, output reg [W-1:0] q_if, q_expr, q_old);
  assign expr = sel ? a : b;
  assign identical = sel ? a : a;
  assign eq = a == b;
  assign case_eq = a === b;
  always @(posedge clock) begin
    if (sel) q_if <= a; else q_if <= b;
    q_expr <= sel ? a : b;
    q_old <= q_expr;
  end
endmodule

module ConditionalScalar(input clk, sel, a, b, output expr, identical,
  eq, case_eq, q_if, q_expr, q_old);
  ConditionalCore #(.W(1)) core(clk,sel,a,b,expr,identical,eq,case_eq,q_if,q_expr,q_old);
endmodule

module ConditionalVector(input clk, sel, input [1:0] a,b,
  output [1:0] expr, identical, output eq, case_eq,
  output [1:0] q_if,q_expr,q_old);
  ConditionalCore #(.W(2)) core(clk,sel,a,b,expr,identical,eq,case_eq,q_if,q_expr,q_old);
endmodule
