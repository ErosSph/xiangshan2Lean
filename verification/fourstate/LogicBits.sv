module LogicBits(input a, b, output not_a, and_ab, or_ab,
  output eq_ab, ne_ab, case_eq_ab, case_ne_ab,
  output lt_ab, le_ab, gt_ab, ge_ab);
  assign not_a = !a;
  assign and_ab = a && b;
  assign or_ab = a || b;
  assign eq_ab = a == b;
  assign ne_ab = a != b;
  assign case_eq_ab = a === b;
  assign case_ne_ab = a !== b;
  assign lt_ab = a < b;
  assign le_ab = a <= b;
  assign gt_ab = a > b;
  assign ge_ab = a >= b;
endmodule
