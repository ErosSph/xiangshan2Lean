module ElaborationLiteral(
  input        clock,
  input        reset,
  input  [2:0] in,
  output [2:0] out
);
  assign out = 3'h1; // @[Advanced.scala 18:7]
endmodule
