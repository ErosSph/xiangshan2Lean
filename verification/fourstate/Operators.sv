module Operators(input a, b, c,
  output inv, band, bor, bxor, bxnor, bnand, bnor, choose, direct);
  assign inv = ~a;
  assign band = a & b;
  assign bor = a | b;
  assign bxor = a ^ b;
  assign bxnor = a ~^ b;
  assign bnand = ~(a & b);
  assign bnor = ~(a | b);
  assign choose = c ? a : b;
  assign direct = a;
endmodule
