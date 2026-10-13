module HelperWidth(
  input        clock,
  input        reset,
  input  [1:0] in,
  output [1:0] out
);
  assign out = in; // @[Features.scala 89:7]
endmodule
