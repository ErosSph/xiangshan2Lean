module ElaborationWidth(
  input        clock,
  input        reset,
  input  [2:0] in,
  output [6:0] out
);
  assign out = 7'h0; // @[Advanced.scala 10:7]
endmodule
