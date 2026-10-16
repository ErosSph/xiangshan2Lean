module LogicCompare(input signed [1:0] a, b, input [1:0] u,
  output not_a, and_ab, or_ab, eq_ab, ne_ab, case_eq_ab, case_ne_ab,
  output signed_lt, signed_le, signed_gt, signed_ge,
  output mixed_lt, cast_lt, slice_lt);
  assign not_a = !a;
  assign and_ab = a && b;
  assign or_ab = a || b;
  assign eq_ab = a == b;
  assign ne_ab = a != b;
  assign case_eq_ab = a === b;
  assign case_ne_ab = a !== b;
  assign signed_lt = a < b;
  assign signed_le = a <= b;
  assign signed_gt = a > b;
  assign signed_ge = a >= b;
  assign mixed_lt = a < u;
  assign cast_lt = a < $signed(u);
  assign slice_lt = a[1:0] < b;
endmodule
