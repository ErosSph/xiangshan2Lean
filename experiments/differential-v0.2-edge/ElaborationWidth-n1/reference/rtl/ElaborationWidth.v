module ElaborationWidth(
  input        clock,
  input        reset,
  input        in,
  output [4:0] out
);
  assign out = 5'h0; // @[Advanced.scala 10:7]
endmodule
