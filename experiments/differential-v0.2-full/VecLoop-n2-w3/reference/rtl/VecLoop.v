module VecLoop(
  input        clock,
  input        reset,
  input  [2:0] io_in_0,
  input  [2:0] io_in_1,
  output [2:0] io_out_0,
  output [2:0] io_out_1
);
  assign io_out_0 = io_in_0 + 3'h1; // @[Probes.scala 56:48]
  assign io_out_1 = io_in_1 + 3'h1; // @[Probes.scala 56:48]
endmodule
