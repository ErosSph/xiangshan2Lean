module ParamExpression(
  input        clock,
  input        reset,
  input  [3:0] io_in,
  output [5:0] io_out
);
  assign io_out = {{2'd0}, io_in}; // @[Probes.scala 64:10]
endmodule
