FIRRTL version 1.1.0
circuit RegisterIdioms :
  module RegisterIdioms :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<3>
    input en : UInt<1>
    output out : UInt<3>

    reg delayed : UInt<3>, clock with :
      reset => (UInt<1>("h0"), delayed) @[Mainstream.scala 20:24]
    reg held : UInt<3>, clock with :
      reset => (UInt<1>("h0"), held) @[Reg.scala 35:20]
    node _GEN_0 = mux(en, delayed, held) @[Reg.scala 36:18 35:20 36:22]
    reg explicit : UInt<3>, clock with :
      reset => (UInt<1>("h0"), explicit) @[Mainstream.scala 22:25]
    out <= explicit @[Mainstream.scala 24:7]
    delayed <= mux(reset, UInt<3>("h0"), in) @[Mainstream.scala 20:{24,24,24}]
    held <= mux(reset, UInt<3>("h0"), _GEN_0) @[Reg.scala 35:{20,20}]
    explicit <= mux(reset, UInt<1>("h0"), held) @[Mainstream.scala 22:{25,25} 23:12]
