module MoreBits(
  input  [1:0] a,
  input  [1:0] b,
  input  [1:0] shift,
  output [1:0] quotient,
  output [1:0] remainder,
  output [4:0] shifted,
  output [1:0] top,
  output       bottom,
  output [1:0] filled,
  output       bit_
);
  wire [1:0] _bit_T = a >> shift; // @[Mainstream.scala 73:11]
  wire [4:0] _GEN_0 = {{3'd0}, a}; // @[Mainstream.scala 69:16]
  assign quotient = a / b; // @[Mainstream.scala 67:17]
  assign remainder = a % b; // @[Mainstream.scala 68:18]
  assign shifted = _GEN_0 << shift; // @[Mainstream.scala 69:16]
  assign top = a; // @[Mainstream.scala 70:16]
  assign bottom = a[0]; // @[Mainstream.scala 71:19]
  assign filled = a; // @[Mainstream.scala 72:27]
  assign bit_ = _bit_T[0]; // @[Mainstream.scala 73:11]
endmodule
