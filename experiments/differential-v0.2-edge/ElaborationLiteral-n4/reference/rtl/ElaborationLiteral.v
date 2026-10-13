module ElaborationLiteral(
  input        clock,
  input        reset,
  input  [3:0] in,
  output [3:0] out
);
  assign out = 4'hf; // @[Advanced.scala 18:7]
endmodule
