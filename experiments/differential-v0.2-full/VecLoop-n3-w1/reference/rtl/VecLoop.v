module VecLoop(
  input   clock,
  input   reset,
  input   io_in_0,
  input   io_in_1,
  input   io_in_2,
  output  io_out_0,
  output  io_out_1,
  output  io_out_2
);
  assign io_out_0 = io_in_0 + 1'h1; // @[Probes.scala 56:48]
  assign io_out_1 = io_in_1 + 1'h1; // @[Probes.scala 56:48]
  assign io_out_2 = io_in_2 + 1'h1; // @[Probes.scala 56:48]
endmodule
