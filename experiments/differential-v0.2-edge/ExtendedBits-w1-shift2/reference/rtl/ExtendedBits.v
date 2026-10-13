module ExtendedBits(
  input        clock,
  input        reset,
  input        in,
  input        flag,
  input  [1:0] amount,
  output       inverted,
  output [1:0] negative,
  output [2:0] concatenated,
  output       isZero,
  output       shifted,
  output       dynamic,
  output [3:0] padded
);
  wire  _negative_T_1 = 1'h0 - in; // @[Advanced.scala 34:15]
  wire [1:0] _concatenated_T_2 = {flag,_negative_T_1}; // @[Cat.scala 33:92]
  assign inverted = ~in; // @[Advanced.scala 33:15]
  assign negative = {{1'd0}, _negative_T_1}; // @[Advanced.scala 34:12]
  assign concatenated = {{1'd0}, _concatenated_T_2}; // @[Advanced.scala 35:16]
  assign isZero = ~in; // @[Advanced.scala 36:13]
  assign shifted = 1'h0; // @[Advanced.scala 37:17]
  assign dynamic = in >> amount; // @[Advanced.scala 38:17]
  assign padded = {{3'd0}, in}; // @[Advanced.scala 39:19]
endmodule
