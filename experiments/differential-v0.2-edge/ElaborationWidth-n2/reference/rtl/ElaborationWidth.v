module ElaborationWidth(
  input        clock,
  input        reset,
  input  [1:0] in,
  output [5:0] out
);
  assign out = 6'h0; // @[Advanced.scala 10:7]
endmodule
