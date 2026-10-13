circuit Arithmetic :
  module Arithmetic :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip a : UInt<7>, flip b : UInt<3>, flip choose : UInt<1>, sum : UInt<10>, carry : UInt<11>, sub : UInt<10>, product : UInt<10>, selected : UInt<10>, less : UInt<1>, equal : UInt<1>, concat : UInt<10>, xor : UInt<10>}

    node _io_sum_T = add(io.a, io.b) @[Features.scala 32:18]
    node _io_sum_T_1 = tail(_io_sum_T, 1) @[Features.scala 32:18]
    io.sum <= _io_sum_T_1 @[Features.scala 32:10]
    node _io_carry_T = add(io.a, io.b) @[Features.scala 33:20]
    io.carry <= _io_carry_T @[Features.scala 33:12]
    node _io_sub_T = sub(io.a, io.b) @[Features.scala 34:18]
    node _io_sub_T_1 = tail(_io_sub_T, 1) @[Features.scala 34:18]
    io.sub <= _io_sub_T_1 @[Features.scala 34:10]
    node _io_product_T = mul(io.a, io.b) @[Features.scala 35:22]
    io.product <= _io_product_T @[Features.scala 35:14]
    node _io_selected_T = mux(io.choose, io.a, io.b) @[Features.scala 36:21]
    io.selected <= _io_selected_T @[Features.scala 36:15]
    node _io_less_T = lt(io.a, io.b) @[Features.scala 37:19]
    io.less <= _io_less_T @[Features.scala 37:11]
    node _io_equal_T = eq(io.a, io.b) @[Features.scala 38:20]
    io.equal <= _io_equal_T @[Features.scala 38:12]
    node _io_concat_T = cat(io.a, io.b) @[Cat.scala 33:92]
    io.concat <= _io_concat_T @[Features.scala 39:13]
    node _io_xor_T = xor(io.a, io.b) @[Features.scala 40:18]
    io.xor <= _io_xor_T @[Features.scala 40:10]

