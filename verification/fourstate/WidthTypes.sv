module WidthTypes(
  input signed [3:0] s,
  input [3:0] u,
  input [1:0] short_u,
  input [0:3] asc,
  input [64:0] wide,
  input choose,
  output [7:0] sign_ext, zero_ext, sign_cast, unsigned_cast,
  output [7:0] sized_cast, mixed_bits, branch, selected,
  output [7:0] unequal_bits, branch_unequal, short_signed,
  output [3:0] truncated,
  output [3:0] asc_copy,
  output [64:0] wide_copy,
  output [0:64] ascending_copy,
  output signed [7:0] signed_literal
);
  assign sign_ext = s;
  assign zero_ext = u;
  assign sign_cast = $signed(u);
  assign unsigned_cast = $unsigned(s);
  assign sized_cast = 8'(s);
  assign mixed_bits = s ^ u;
  assign unequal_bits = s ^ short_u;
  assign branch = choose ? s : u;
  assign branch_unequal = choose ? s : short_u;
  assign short_signed = $signed(short_u);
  assign selected = s[3:1];
  assign truncated = wide;
  assign asc_copy = asc;
  assign wide_copy = wide;
  assign ascending_copy = wide;
  assign signed_literal = 8'sbz;
endmodule
