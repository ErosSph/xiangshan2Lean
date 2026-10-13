module PartialGenerate(
  input   in_0,
  input   in_1,
  output  out_0,
  output  out_1
);
  assign out_0 = in_0; // @[Mainstream.scala 98:7]
  assign out_1 = in_0 + 1'h1; // @[Mainstream.scala 99:61]
endmodule
