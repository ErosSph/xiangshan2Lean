module ArithmeticBits(input signed [1:0] a, b, input [1:0] amount,
  output signed [2:0] sum, diff,
  output signed [1:0] neg_a, pos_a, left_a, right_a, arithmetic_left, arithmetic_right,
  output [1:0] unsigned_right);
  assign sum = a + b;
  assign diff = a - b;
  assign neg_a = -a;
  assign pos_a = +a;
  assign left_a = a << amount;
  assign right_a = a >> amount;
  assign arithmetic_left = a <<< amount;
  assign arithmetic_right = a >>> amount;
  assign unsigned_right = $unsigned(a) >>> amount;
endmodule
