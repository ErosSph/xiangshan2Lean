module ElaborationWidth(
  input        clock,
  input        reset,
  input  [3:0] in,
  output [7:0] out
);
  wire [3:0] _out_T_1 = in + 4'h1; // @[Advanced.scala 10:19]
  assign out = {{4'd0}, _out_T_1}; // @[Advanced.scala 10:7]
endmodule
