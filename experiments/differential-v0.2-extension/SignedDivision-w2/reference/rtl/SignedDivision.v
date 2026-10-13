module SignedDivision(
  input  [1:0] a,
  input  [1:0] b,
  output [2:0] quotient,
  output [1:0] remainder
);
  assign quotient = $signed(a) / $signed(b); // @[Mainstream.scala 82:17]
  assign remainder = $signed(a) % $signed(b); // @[Mainstream.scala 83:18]
endmodule
