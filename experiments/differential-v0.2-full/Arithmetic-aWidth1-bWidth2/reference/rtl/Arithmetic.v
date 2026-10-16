module Arithmetic(
  input        clock,
  input        reset,
  input        io_a,
  input  [1:0] io_b,
  input        io_choose,
  output [2:0] io_sum,
  output [3:0] io_carry,
  output [2:0] io_sub,
  output [2:0] io_product,
  output [2:0] io_selected,
  output       io_less,
  output       io_equal,
  output [2:0] io_concat,
  output [2:0] io_xor
);
  wire [1:0] _GEN_0 = {{1'd0}, io_a}; // @[Features.scala 32:18]
  wire [2:0] _io_sum_T = _GEN_0 + io_b; // @[Features.scala 32:18]
  wire [1:0] _io_sum_T_1 = _GEN_0 + io_b; // @[Features.scala 32:18]
  wire [1:0] _io_sub_T_1 = _GEN_0 - io_b; // @[Features.scala 34:18]
  wire [1:0] _io_selected_T = io_choose ? {{1'd0}, io_a} : io_b; // @[Features.scala 36:21]
  wire [1:0] _io_xor_T = _GEN_0 ^ io_b; // @[Features.scala 40:18]
  assign io_sum = {{1'd0}, _io_sum_T_1}; // @[Features.scala 32:10]
  assign io_carry = {{1'd0}, _io_sum_T}; // @[Features.scala 33:12]
  assign io_sub = {{1'd0}, _io_sub_T_1}; // @[Features.scala 34:10]
  assign io_product = io_a * io_b; // @[Features.scala 35:22]
  assign io_selected = {{1'd0}, _io_selected_T}; // @[Features.scala 36:15]
  assign io_less = _GEN_0 < io_b; // @[Features.scala 37:19]
  assign io_equal = _GEN_0 == io_b; // @[Features.scala 38:20]
  assign io_concat = {io_a,io_b}; // @[Cat.scala 33:92]
  assign io_xor = {{1'd0}, _io_xor_T}; // @[Features.scala 40:10]
endmodule
