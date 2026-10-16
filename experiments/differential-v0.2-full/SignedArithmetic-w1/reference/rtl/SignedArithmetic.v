module SignedArithmetic(
  input        clock,
  input        reset,
  input        io_a,
  input        io_b,
  output       io_sum,
  output [1:0] io_wide,
  output [1:0] io_product,
  output [2:0] io_extended,
  output       io_shr,
  output       io_less
);
  assign io_sum = $signed(io_a) + $signed(io_b); // @[Features.scala 55:18]
  assign io_wide = $signed(io_a) + $signed(io_b); // @[Features.scala 56:19]
  assign io_product = $signed(io_a) * $signed(io_b); // @[Features.scala 57:22]
  assign io_extended = {3{io_a}}; // @[Features.scala 58:15]
  assign io_shr = io_a; // @[Features.scala 59:18]
  assign io_less = $signed(io_a) < $signed(io_b); // @[Features.scala 60:19]
endmodule
