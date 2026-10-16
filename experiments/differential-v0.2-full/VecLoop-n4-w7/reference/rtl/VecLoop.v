module VecLoop(
  input        clock,
  input        reset,
  input  [6:0] io_in_0,
  input  [6:0] io_in_1,
  input  [6:0] io_in_2,
  input  [6:0] io_in_3,
  output [6:0] io_out_0,
  output [6:0] io_out_1,
  output [6:0] io_out_2,
  output [6:0] io_out_3
);
  assign io_out_0 = io_in_0 + 7'h1; // @[Probes.scala 56:48]
  assign io_out_1 = io_in_1 + 7'h1; // @[Probes.scala 56:48]
  assign io_out_2 = io_in_2 + 7'h1; // @[Probes.scala 56:48]
  assign io_out_3 = io_in_3 + 7'h1; // @[Probes.scala 56:48]
endmodule
