FIRRTL version 6.0.0
circuit Chisel2LeanReference :
  layer Verification, bind, "verification" :
    layer Assert, bind, "verification\assert" :
      layer Temporal, inline :
    layer Assume, bind, "verification\assume" :
      layer Temporal, inline :
    layer Cover, bind, "verification\cover" :
      layer Temporal, inline :

  module SignedArithmetic : @[\\audit\\src\\main\\scala\\Features.scala 43:7]
    input clock : Clock @[\\audit\\src\\main\\scala\\Features.scala 43:7]
    input reset : Reset @[\\audit\\src\\main\\scala\\Features.scala 43:7]
    output io : { flip a : SInt<4>, flip b : SInt<4>, sum : SInt<4>, wide : SInt<5>, product : SInt<8>, extended : SInt<6>, shr : SInt<4>, less : UInt<1>} @[\\audit\\src\\main\\scala\\Features.scala 45:14]

    node _io_sum_T = add(io.a, io.b) @[\\audit\\src\\main\\scala\\Features.scala 55:18]
    node _io_sum_T_1 = tail(_io_sum_T, 1) @[\\audit\\src\\main\\scala\\Features.scala 55:18]
    node _io_sum_T_2 = asSInt(_io_sum_T_1) @[\\audit\\src\\main\\scala\\Features.scala 55:18]
    connect io.sum, _io_sum_T_2 @[\\audit\\src\\main\\scala\\Features.scala 55:10]
    node _io_wide_T = add(io.a, io.b) @[\\audit\\src\\main\\scala\\Features.scala 56:19]
    connect io.wide, _io_wide_T @[\\audit\\src\\main\\scala\\Features.scala 56:11]
    node _io_product_T = mul(io.a, io.b) @[\\audit\\src\\main\\scala\\Features.scala 57:22]
    connect io.product, _io_product_T @[\\audit\\src\\main\\scala\\Features.scala 57:14]
    connect io.extended, io.a @[\\audit\\src\\main\\scala\\Features.scala 58:15]
    node _io_shr_T = shr(io.a, 1) @[\\audit\\src\\main\\scala\\Features.scala 59:18]
    connect io.shr, _io_shr_T @[\\audit\\src\\main\\scala\\Features.scala 59:10]
    node _io_less_T = lt(io.a, io.b) @[\\audit\\src\\main\\scala\\Features.scala 60:19]
    connect io.less, _io_less_T @[\\audit\\src\\main\\scala\\Features.scala 60:11]


  public module Chisel2LeanReference : @[\\reference\\src\\main\\scala\\GenerateRTL.scala 35:11]
    input clock : Clock @[\\reference\\src\\main\\scala\\GenerateRTL.scala 35:11]
    input reset : UInt<1> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 35:11]
    input c2l_port_0 : SInt<4> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:50]
    input c2l_port_1 : SInt<4> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:50]
    output c2l_port_2 : SInt<6> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:85]
    output c2l_port_3 : UInt<1> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:85]
    output c2l_port_4 : SInt<8> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:85]
    output c2l_port_5 : SInt<4> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:85]
    output c2l_port_6 : SInt<4> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:85]
    output c2l_port_7 : SInt<5> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:85]

    inst SignedArithmetic of SignedArithmetic @[\\reference\\src\\main\\scala\\GenerateRTL.scala 37:24]
    connect SignedArithmetic.clock, clock
    connect SignedArithmetic.reset, reset
    connect SignedArithmetic.io.a, c2l_port_0 @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:42]
    connect SignedArithmetic.io.b, c2l_port_1 @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:42]
    connect c2l_port_2, SignedArithmetic.io.extended @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:60]
    connect c2l_port_3, SignedArithmetic.io.less @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:60]
    connect c2l_port_4, SignedArithmetic.io.product @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:60]
    connect c2l_port_5, SignedArithmetic.io.shr @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:60]
    connect c2l_port_6, SignedArithmetic.io.sum @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:60]
    connect c2l_port_7, SignedArithmetic.io.wide @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:60]

