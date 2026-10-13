FIRRTL version 1.1.0
circuit Priority :
  module Priority :
    input clock : Clock
    input reset : UInt<1>
    input io_en : UInt<1>
    input io_clear : UInt<1>
    output io_q : UInt<3>

    reg cnt : UInt<3>, clock with :
      reset => (UInt<1>("h0"), cnt) @[Probes.scala 36:20]
    node _cnt_T = add(cnt, UInt<1>("h1")) @[Probes.scala 37:28]
    node _cnt_T_1 = tail(_cnt_T, 1) @[Probes.scala 37:28]
    node _GEN_0 = mux(io_en, _cnt_T_1, cnt) @[Probes.scala 37:15 36:20 37:21]
    node _GEN_1 = mux(io_clear, UInt<1>("h0"), _GEN_0) @[Probes.scala 38:{18,24}]
    io_q <= cnt @[Probes.scala 39:8]
    cnt <= mux(reset, UInt<3>("h0"), _GEN_1) @[Probes.scala 36:{20,20}]
