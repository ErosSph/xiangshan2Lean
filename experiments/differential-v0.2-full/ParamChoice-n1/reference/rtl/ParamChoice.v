module ParamChoice(
  input   clock,
  input   reset,
  input   io_in,
  output  io_out
);
  wire [1:0] _GEN_0 = {{1'd0}, io_in}; // @[Probes.scala 48:26]
  wire [1:0] _io_out_T_1 = _GEN_0 + 2'h2; // @[Probes.scala 48:26]
  assign io_out = _io_out_T_1[0]; // @[Probes.scala 48:17]
endmodule
