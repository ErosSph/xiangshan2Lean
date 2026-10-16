circuit Priority :
  module Priority :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip en : UInt<1>, flip clear : UInt<1>, q : UInt<1>}

    reg cnt : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Probes.scala 36:20]
    when io.en : @[Probes.scala 37:15]
      node _cnt_T = add(cnt, UInt<1>("h1")) @[Probes.scala 37:28]
      node _cnt_T_1 = tail(_cnt_T, 1) @[Probes.scala 37:28]
      cnt <= _cnt_T_1 @[Probes.scala 37:21]
    when io.clear : @[Probes.scala 38:18]
      cnt <= UInt<1>("h0") @[Probes.scala 38:24]
    io.q <= cnt @[Probes.scala 39:8]

