FIRRTL version 1.1.0
circuit SignedArithmetic :
  module SignedArithmetic :
    input clock : Clock
    input reset : UInt<1>
    input io_a : SInt<4>
    input io_b : SInt<4>
    output io_sum : SInt<4>
    output io_wide : SInt<5>
    output io_product : SInt<8>
    output io_extended : SInt<6>
    output io_shr : SInt<4>
    output io_less : UInt<1>

    node _io_sum_T = add(io_a, io_b) @[Features.scala 55:18]
    node _io_sum_T_1 = tail(_io_sum_T, 1) @[Features.scala 55:18]
    node _io_sum_T_2 = asSInt(_io_sum_T_1) @[Features.scala 55:18]
    node _io_wide_T = add(io_a, io_b) @[Features.scala 56:19]
    node _io_product_T = mul(io_a, io_b) @[Features.scala 57:22]
    node _io_shr_T = shr(io_a, 1) @[Features.scala 59:18]
    node _io_less_T = lt(io_a, io_b) @[Features.scala 60:19]
    io_sum <= _io_sum_T_2 @[Features.scala 55:10]
    io_wide <= _io_wide_T @[Features.scala 56:11]
    io_product <= _io_product_T @[Features.scala 57:14]
    io_extended <= pad(io_a, 6) @[Features.scala 58:15]
    io_shr <= pad(_io_shr_T, 4) @[Features.scala 59:10]
    io_less <= _io_less_T @[Features.scala 60:11]
