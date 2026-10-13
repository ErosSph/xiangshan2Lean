FIRRTL version 1.1.0
circuit Counter :
  module Counter :
    input clock : Clock
    input reset : UInt<1>
    input io_en : UInt<1>
    output io_q : UInt<1>

    reg cnt : UInt<1>, clock with :
      reset => (UInt<1>("h0"), cnt) @[Probes.scala 11:20]
    node _cnt_T = add(cnt, UInt<1>("h1")) @[Probes.scala 12:28]
    node _cnt_T_1 = tail(_cnt_T, 1) @[Probes.scala 12:28]
    node _GEN_0 = mux(io_en, _cnt_T_1, cnt) @[Probes.scala 12:15 11:20 12:21]
    io_q <= cnt @[Probes.scala 13:8]
    cnt <= mux(reset, UInt<1>("h0"), _GEN_0) @[Probes.scala 11:{20,20}]
