module Vectors(input [2:5] a, input [7:4] b, input c,
  input [64:0] wide_a, wide_b,
  output [8:11] mixed, output [3:0] sliced, literal,
  output [64:0] wide_result, wide_direct);
  wire [3:0] intermediate;
  assign mixed = c ? intermediate : b;
  assign intermediate = ~a ^ b;
  assign sliced = {a[2:3], b[5], a[5]};
  assign literal = 4'b01xz;
  assign wide_result = c ? (wide_a & wide_b) : ~(wide_a | wide_b);
  assign wide_direct = {wide_a[64:1], wide_a[0]};
endmodule
