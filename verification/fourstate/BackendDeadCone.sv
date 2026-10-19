module BackendDeadCone(
  input [4:0] a, b,
  input c, d,
  output add_const, mux_bit, shift_bit, low_x, low_z,
  output [4:0] sum
);
  assign add_const = 1'({(a+b), 1'b1});
  assign mux_bit = 1'({(c ? a : b), d});
  assign shift_bit = 1'({(c ? a : b), (1'b1 << a)});
  assign low_x = 1'({(a+b), 1'bx});
  assign low_z = 1'({(a+b), 1'bz});
  assign sum = a+b;
endmodule
