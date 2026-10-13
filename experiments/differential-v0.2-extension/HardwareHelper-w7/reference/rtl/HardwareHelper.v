module HardwareHelper(
  input  [6:0] in,
  output [6:0] out
);
  wire [6:0] out_sum = in + 7'h1; // @[Mainstream.scala 90:51]
  assign out = out_sum ^ 7'h1; // @[Mainstream.scala 90:60]
endmodule
