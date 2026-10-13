module MoreBits(
  input  [2:0] a,
  input  [2:0] b,
  input  [1:0] shift,
  output [2:0] quotient,
  output [2:0] remainder,
  output [5:0] shifted,
  output [1:0] top,
  output [1:0] bottom,
  output [7:0] filled,
  output       bit_
);
  wire [3:0] _filled_T_1 = {a[1:0],a[1:0]}; // @[Cat.scala 33:92]
  wire [2:0] _bit_T = a >> shift; // @[Mainstream.scala 73:11]
  wire [5:0] _GEN_0 = {{3'd0}, a}; // @[Mainstream.scala 69:16]
  assign quotient = a / b; // @[Mainstream.scala 67:17]
  assign remainder = a % b; // @[Mainstream.scala 68:18]
  assign shifted = _GEN_0 << shift; // @[Mainstream.scala 69:16]
  assign top = a[2:1]; // @[Mainstream.scala 70:16]
  assign bottom = a[1:0]; // @[Mainstream.scala 71:19]
  assign filled = {_filled_T_1,_filled_T_1}; // @[Cat.scala 33:92]
  assign bit_ = _bit_T[0]; // @[Mainstream.scala 73:11]
endmodule
