FIRRTL version 1.1.0
circuit DualRegister :
  module DualRegister :
    input clock : Clock
    input reset : UInt<1>
    input io_in : UInt<3>
    output io_a : UInt<3>
    output io_b : UInt<3>

    reg first : UInt<3>, clock with :
      reset => (UInt<1>("h0"), first) @[Probes.scala 22:22]
    reg second : UInt<3>, clock with :
      reset => (UInt<1>("h0"), second) @[Probes.scala 23:23]
    io_a <= first @[Probes.scala 26:8]
    io_b <= second @[Probes.scala 27:8]
    first <= mux(reset, UInt<3>("h0"), io_in) @[Probes.scala 22:{22,22} 24:9]
    second <= mux(reset, UInt<3>("h0"), first) @[Probes.scala 23:{23,23} 25:10]
