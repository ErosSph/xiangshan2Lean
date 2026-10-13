module ParamChoice(
  input        clock,
  input        reset,
  input  [3:0] io_in,
  output [3:0] io_out
);
  assign io_out = io_in + 4'h1; // @[Probes.scala 47:32]
endmodule
