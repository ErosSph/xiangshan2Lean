module ParamExpression(
  input         clock,
  input         reset,
  input  [9:0]  io_in,
  output [17:0] io_out
);
  assign io_out = {{8'd0}, io_in}; // @[Probes.scala 64:10]
endmodule
