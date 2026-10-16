module Arithmetic(
  input        clock,
  input        reset,
  input  [2:0] io_a,
  input  [2:0] io_b,
  input        io_choose,
  output [5:0] io_sum,
  output [6:0] io_carry,
  output [5:0] io_sub,
  output [5:0] io_product,
  output [5:0] io_selected,
  output       io_less,
  output       io_equal,
  output [5:0] io_concat,
  output [5:0] io_xor
);
  wire [3:0] _io_sum_T = io_a + io_b; // @[Features.scala 32:18]
  wire [2:0] _io_sum_T_1 = io_a + io_b; // @[Features.scala 32:18]
  wire [2:0] _io_sub_T_1 = io_a - io_b; // @[Features.scala 34:18]
  wire [2:0] _io_selected_T = io_choose ? io_a : io_b; // @[Features.scala 36:21]
  wire [2:0] _io_xor_T = io_a ^ io_b; // @[Features.scala 40:18]
  assign io_sum = {{3'd0}, _io_sum_T_1}; // @[Features.scala 32:10]
  assign io_carry = {{3'd0}, _io_sum_T}; // @[Features.scala 33:12]
  assign io_sub = {{3'd0}, _io_sub_T_1}; // @[Features.scala 34:10]
  assign io_product = io_a * io_b; // @[Features.scala 35:22]
  assign io_selected = {{3'd0}, _io_selected_T}; // @[Features.scala 36:15]
  assign io_less = io_a < io_b; // @[Features.scala 37:19]
  assign io_equal = io_a == io_b; // @[Features.scala 38:20]
  assign io_concat = {io_a,io_b}; // @[Cat.scala 33:92]
  assign io_xor = {{3'd0}, _io_xor_T}; // @[Features.scala 40:10]
endmodule
