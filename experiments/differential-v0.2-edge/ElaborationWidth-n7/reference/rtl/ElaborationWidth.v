module ElaborationWidth(
  input         clock,
  input         reset,
  input  [6:0]  in,
  output [10:0] out
);
  wire [6:0] _out_T_1 = in + 7'h1; // @[Advanced.scala 10:19]
  assign out = {{4'd0}, _out_T_1}; // @[Advanced.scala 10:7]
endmodule
