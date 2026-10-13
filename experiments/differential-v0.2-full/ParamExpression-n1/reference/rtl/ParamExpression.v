module ParamExpression(
  input        clock,
  input        reset,
  input  [1:0] io_in,
  output [1:0] io_out
);
  assign io_out = io_in; // @[Probes.scala 64:10]
endmodule
