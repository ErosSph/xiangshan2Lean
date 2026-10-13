module PartialGenerate(
  input  [4:0] in_0,
  input  [4:0] in_1,
  input  [4:0] in_2,
  input  [4:0] in_3,
  output [4:0] out_0,
  output [4:0] out_1,
  output [4:0] out_2,
  output [4:0] out_3
);
  assign out_0 = in_0; // @[Mainstream.scala 98:7]
  assign out_1 = in_0 + 5'h1; // @[Mainstream.scala 99:61]
  assign out_2 = in_1 + 5'h1; // @[Mainstream.scala 99:61]
  assign out_3 = in_2 + 5'h1; // @[Mainstream.scala 99:61]
endmodule
