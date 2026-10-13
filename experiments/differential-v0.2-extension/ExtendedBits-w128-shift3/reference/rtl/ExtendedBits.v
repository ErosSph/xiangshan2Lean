module ExtendedBits(
  input          clock,
  input          reset,
  input  [127:0] in,
  input          flag,
  input  [1:0]   amount,
  output [127:0] inverted,
  output [128:0] negative,
  output [129:0] concatenated,
  output         isZero,
  output [127:0] shifted,
  output [127:0] dynamic,
  output [130:0] padded
);
  wire [127:0] _negative_T_1 = 128'h0 - in; // @[Advanced.scala 34:15]
  wire [128:0] _concatenated_T_2 = {flag,_negative_T_1}; // @[Cat.scala 33:92]
  assign inverted = ~in; // @[Advanced.scala 33:15]
  assign negative = {{1'd0}, _negative_T_1}; // @[Advanced.scala 34:12]
  assign concatenated = {{1'd0}, _concatenated_T_2}; // @[Advanced.scala 35:16]
  assign isZero = in == 128'h0; // @[Advanced.scala 36:13]
  assign shifted = {{3'd0}, in[127:3]}; // @[Advanced.scala 37:11]
  assign dynamic = in >> amount; // @[Advanced.scala 38:17]
  assign padded = {{3'd0}, in}; // @[Advanced.scala 39:19]
endmodule
