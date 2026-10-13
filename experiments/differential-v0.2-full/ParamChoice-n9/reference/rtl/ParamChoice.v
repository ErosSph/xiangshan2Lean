module ParamChoice(
  input        clock,
  input        reset,
  input  [8:0] io_in,
  output [8:0] io_out
);
  assign io_out = io_in + 9'h1; // @[Probes.scala 47:32]
endmodule
