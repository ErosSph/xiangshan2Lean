module HardwareHelper(
  input   in,
  output  out
);
  wire  out_sum = in + 1'h1; // @[Mainstream.scala 90:51]
  assign out = out_sum ^ 1'h1; // @[Mainstream.scala 90:60]
endmodule
