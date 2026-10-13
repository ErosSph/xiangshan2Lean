circuit DirectCounter :
  module DirectCounter :
    input clock : Clock
    input reset : UInt<1>
    input en : UInt<1>
    output q : UInt<3>

    reg cnt : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[Probes.scala 71:20]
    when en : @[Probes.scala 72:12]
      node _cnt_T = add(cnt, UInt<1>("h1")) @[Probes.scala 72:25]
      node _cnt_T_1 = tail(_cnt_T, 1) @[Probes.scala 72:25]
      cnt <= _cnt_T_1 @[Probes.scala 72:18]
    q <= cnt @[Probes.scala 73:5]

