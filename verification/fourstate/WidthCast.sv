module WidthCast(
  input [3:0] u, v,
  input signed [3:0] s, t,
  input [1:0] amount,
  input choose,
  output [7:0] add_u, sub_u, not_u, neg_u, left_u, right_sum,
  output signed [7:0] add_s, not_s, neg_s, right_s,
  output [7:0] mixed, selected, narrow_u, narrow_s, nested, concatenated,
  output [7:0] unsigned_inner, count_self, compare_self,
  output [11:0] outer_u,
  output signed [11:0] outer_s
);
  assign add_u = 8'(u + v);
  assign sub_u = 8'(u - v);
  assign not_u = 8'(~u);
  assign neg_u = 8'(-u);
  assign left_u = 8'(u << amount);
  assign right_sum = 8'((u + v) >> amount);
  assign add_s = 8'(s + t);
  assign not_s = 8'(~s);
  assign neg_s = 8'(-s);
  assign right_s = 8'(s >>> amount);
  assign mixed = 8'(s + u);
  assign selected = 8'(choose ? u + v : u - v);
  assign narrow_u = 2'(u + v);
  assign narrow_s = 2'(s + t);
  assign nested = 8'(4'(u + v));
  assign concatenated = 8'({u + v});
  assign unsigned_inner = 8'($unsigned(s + t));
  assign count_self = 8'(u << (u + v));
  assign compare_self = 8'((u + v) == 4'd14);
  assign outer_u = 8'(u + v);
  assign outer_s = 8'(s + t);
endmodule
