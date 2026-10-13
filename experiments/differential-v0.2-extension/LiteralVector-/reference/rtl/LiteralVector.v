module LiteralVector(
  input  [2:0] a,
  output [3:0] out_0,
  output [3:0] out_1,
  output [3:0] out_2
);
  assign out_0 = {{1'd0}, a}; // @[Mainstream.scala 105:{18,18}]
  assign out_1 = 4'h1; // @[Mainstream.scala 105:{18,18}]
  assign out_2 = 4'h7; // @[Mainstream.scala 105:{18,18}]
endmodule
