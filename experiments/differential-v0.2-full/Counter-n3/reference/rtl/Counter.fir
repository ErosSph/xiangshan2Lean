circuit Counter :
  module Counter :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip en : UInt<1>, q : UInt<3>}

    reg cnt : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[Probes.scala 11:20]
    when io.en : @[Probes.scala 12:15]
      node _cnt_T = add(cnt, UInt<1>("h1")) @[Probes.scala 12:28]
      node _cnt_T_1 = tail(_cnt_T, 1) @[Probes.scala 12:28]
      cnt <= _cnt_T_1 @[Probes.scala 12:21]
    io.q <= cnt @[Probes.scala 13:8]

