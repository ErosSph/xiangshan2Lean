module TabulatedVector(
  input  [2:0] in_0,
  input  [2:0] in_1,
  input  [2:0] in_2,
  input  [2:0] in_3,
  output [2:0] out_0,
  output [2:0] out_1,
  output [2:0] out_2,
  output [2:0] out_3
);
  assign out_0 = in_0 + 3'h1; // @[Designs.scala 56:53]
  assign out_1 = in_1 + 3'h1; // @[Designs.scala 56:53]
  assign out_2 = in_2 + 3'h1; // @[Designs.scala 56:53]
  assign out_3 = in_3 + 3'h1; // @[Designs.scala 56:53]
endmodule
