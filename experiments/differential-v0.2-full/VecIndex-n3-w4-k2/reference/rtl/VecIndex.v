module VecIndex(
  input        clock,
  input        reset,
  input  [3:0] in_0,
  input  [3:0] in_1,
  input  [3:0] in_2,
  output [3:0] out
);
  assign out = in_2; // @[Features.scala 134:7]
endmodule
