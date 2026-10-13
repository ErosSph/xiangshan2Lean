module HelperWidth(
  input        clock,
  input        reset,
  input  [3:0] in,
  output [5:0] out
);
  assign out = {{2'd0}, in}; // @[Features.scala 89:7]
endmodule
