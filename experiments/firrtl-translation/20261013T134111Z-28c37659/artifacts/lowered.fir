FIRRTL version 1.1.0
circuit Arithmetic :
  module Arithmetic :
    input clock : Clock
    input reset : UInt<1>
    input io_a : UInt<65>
    input io_b : UInt<7>
    input io_choose : UInt<1>
    output io_sum : UInt<72>
    output io_carry : UInt<73>
    output io_sub : UInt<72>
    output io_product : UInt<72>
    output io_selected : UInt<72>
    output io_less : UInt<1>
    output io_equal : UInt<1>
    output io_concat : UInt<72>
    output io_xor : UInt<72>

    node _io_sum_T = add(io_a, io_b) @[Features.scala 32:18]
    node _io_sum_T_1 = tail(_io_sum_T, 1) @[Features.scala 32:18]
    node _io_carry_T = add(io_a, io_b) @[Features.scala 33:20]
    node _io_sub_T = sub(io_a, io_b) @[Features.scala 34:18]
    node _io_sub_T_1 = tail(_io_sub_T, 1) @[Features.scala 34:18]
    node _io_product_T = mul(io_a, io_b) @[Features.scala 35:22]
    node _io_selected_T = mux(io_choose, io_a, io_b) @[Features.scala 36:21]
    node _io_less_T = lt(io_a, io_b) @[Features.scala 37:19]
    node _io_equal_T = eq(io_a, io_b) @[Features.scala 38:20]
    node _io_concat_T = cat(io_a, io_b) @[Cat.scala 33:92]
    node _io_xor_T = xor(io_a, io_b) @[Features.scala 40:18]
    io_sum <= pad(_io_sum_T_1, 72) @[Features.scala 32:10]
    io_carry <= pad(_io_carry_T, 73) @[Features.scala 33:12]
    io_sub <= pad(_io_sub_T_1, 72) @[Features.scala 34:10]
    io_product <= _io_product_T @[Features.scala 35:14]
    io_selected <= pad(_io_selected_T, 72) @[Features.scala 36:15]
    io_less <= _io_less_T @[Features.scala 37:11]
    io_equal <= _io_equal_T @[Features.scala 38:12]
    io_concat <= _io_concat_T @[Features.scala 39:13]
    io_xor <= pad(_io_xor_T, 72) @[Features.scala 40:10]
