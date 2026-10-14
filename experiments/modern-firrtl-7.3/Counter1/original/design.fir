FIRRTL version 6.0.0
circuit Chisel2LeanReference :
  layer Verification, bind, "verification" :
    layer Assert, bind, "verification\assert" :
      layer Temporal, inline :
    layer Assume, bind, "verification\assume" :
      layer Temporal, inline :
    layer Cover, bind, "verification\cover" :
      layer Temporal, inline :

  module Counter : @[\\audit\\src\\main\\scala\\Probes.scala 5:7]
    input clock : Clock @[\\audit\\src\\main\\scala\\Probes.scala 5:7]
    input reset : Reset @[\\audit\\src\\main\\scala\\Probes.scala 5:7]
    output io : { flip en : UInt<1>, q : UInt<1>} @[\\audit\\src\\main\\scala\\Probes.scala 7:14]

    regreset cnt : UInt<1>, clock, reset, UInt<1>(0h0) @[\\audit\\src\\main\\scala\\Probes.scala 11:20]
    when io.en : @[\\audit\\src\\main\\scala\\Probes.scala 12:15]
      node _cnt_T = add(cnt, UInt<1>(0h1)) @[\\audit\\src\\main\\scala\\Probes.scala 12:28]
      node _cnt_T_1 = tail(_cnt_T, 1) @[\\audit\\src\\main\\scala\\Probes.scala 12:28]
      connect cnt, _cnt_T_1 @[\\audit\\src\\main\\scala\\Probes.scala 12:21]
    connect io.q, cnt @[\\audit\\src\\main\\scala\\Probes.scala 13:8]


  public module Chisel2LeanReference : @[\\reference\\src\\main\\scala\\GenerateRTL.scala 35:11]
    input clock : Clock @[\\reference\\src\\main\\scala\\GenerateRTL.scala 35:11]
    input reset : UInt<1> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 35:11]
    input c2l_port_0 : UInt<1> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:50]
    output c2l_port_1 : UInt<1> @[\\reference\\src\\main\\scala\\GenerateRTL.scala 49:85]

    inst Counter of Counter @[\\reference\\src\\main\\scala\\GenerateRTL.scala 37:24]
    connect Counter.clock, clock
    connect Counter.reset, reset
    connect Counter.io.en, c2l_port_0 @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:42]
    connect c2l_port_1, Counter.io.q @[\\reference\\src\\main\\scala\\GenerateRTL.scala 51:60]

