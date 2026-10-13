module SignedArithmetic(
  input          clock,
  input          reset,
  input  [64:0]  io_a,
  input  [64:0]  io_b,
  output [64:0]  io_sum,
  output [65:0]  io_wide,
  output [129:0] io_product,
  output [66:0]  io_extended,
  output [64:0]  io_shr,
  output         io_less
);
  wire [63:0] _io_shr_T = io_a[64:1]; // @[Features.scala 59:18]
  assign io_sum = $signed(io_a) + $signed(io_b); // @[Features.scala 55:18]
  assign io_wide = $signed(io_a) + $signed(io_b); // @[Features.scala 56:19]
  assign io_product = $signed(io_a) * $signed(io_b); // @[Features.scala 57:22]
  assign io_extended = {{2{io_a[64]}},io_a}; // @[Features.scala 58:15]
  assign io_shr = {{1{_io_shr_T[63]}},_io_shr_T}; // @[Features.scala 59:10]
  assign io_less = $signed(io_a) < $signed(io_b); // @[Features.scala 60:19]
endmodule
