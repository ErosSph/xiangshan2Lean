circuit SignedArithmetic :
  module SignedArithmetic :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip a : SInt<4>, flip b : SInt<4>, sum : SInt<4>, wide : SInt<5>, product : SInt<8>, extended : SInt<6>, shr : SInt<4>, less : UInt<1>}

    node _io_sum_T = add(io.a, io.b) @[Features.scala 55:18]
    node _io_sum_T_1 = tail(_io_sum_T, 1) @[Features.scala 55:18]
    node _io_sum_T_2 = asSInt(_io_sum_T_1) @[Features.scala 55:18]
    io.sum <= _io_sum_T_2 @[Features.scala 55:10]
    node _io_wide_T = add(io.a, io.b) @[Features.scala 56:19]
    io.wide <= _io_wide_T @[Features.scala 56:11]
    node _io_product_T = mul(io.a, io.b) @[Features.scala 57:22]
    io.product <= _io_product_T @[Features.scala 57:14]
    io.extended <= io.a @[Features.scala 58:15]
    node _io_shr_T = shr(io.a, 1) @[Features.scala 59:18]
    io.shr <= _io_shr_T @[Features.scala 59:10]
    node _io_less_T = lt(io.a, io.b) @[Features.scala 60:19]
    io.less <= _io_less_T @[Features.scala 60:11]

