FIRRTL version 1.1.0
circuit ConditionalPriority :
  module ConditionalPriority :
    input clock : Clock
    input reset : UInt<1>
    input a : UInt<1>
    input b : UInt<1>
    input c : UInt<1>
    output combinational : UInt<3>
    output sequential : UInt<3>

    reg r : UInt<3>, clock with :
      reset => (UInt<1>("h0"), r) @[Control.scala 11:18]
    node _GEN_0 = mux(b, UInt<2>("h2"), UInt<2>("h3")) @[Control.scala 14:{18,26} 15:24]
    node _GEN_1 = mux(a, UInt<1>("h1"), _GEN_0) @[Control.scala 13:{11,19}]
    node _GEN_2 = mux(b, UInt<1>("h1"), UInt<2>("h2")) @[Control.scala 17:{13,17,40}]
    node _r_T = add(r, UInt<1>("h1")) @[Control.scala 19:25]
    node _r_T_1 = tail(_r_T, 1) @[Control.scala 19:25]
    node _GEN_3 = mux(c, UInt<2>("h3"), _r_T_1) @[Control.scala 18:{17,21} 19:20]
    node _GEN_4 = mux(a, _GEN_2, _GEN_3) @[Control.scala 16:11]
    node value = pad(_GEN_1, 3) @[Control.scala 12:19]
    combinational <= value @[Control.scala 20:17]
    sequential <= r @[Control.scala 21:14]
    r <= mux(reset, UInt<3>("h0"), _GEN_4) @[Control.scala 11:{18,18}]
