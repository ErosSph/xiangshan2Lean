module SignedDivision(
  input  [7:0] a,
  input  [7:0] b,
  output [8:0] quotient,
  output [7:0] remainder
);
  assign quotient = $signed(a) / $signed(b); // @[Mainstream.scala 82:17]
  assign remainder = $signed(a) % $signed(b); // @[Mainstream.scala 83:18]
endmodule
