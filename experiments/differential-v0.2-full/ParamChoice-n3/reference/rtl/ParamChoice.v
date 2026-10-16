module ParamChoice(
  input        clock,
  input        reset,
  input  [2:0] io_in,
  output [2:0] io_out
);
  assign io_out = io_in + 3'h2; // @[Probes.scala 48:26]
endmodule
