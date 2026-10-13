circuit DualRegister :
  module DualRegister :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : UInt<9>, a : UInt<9>, b : UInt<9>}

    reg first : UInt<9>, clock with :
      reset => (reset, UInt<9>("h0")) @[Probes.scala 22:22]
    reg second : UInt<9>, clock with :
      reset => (reset, UInt<9>("h0")) @[Probes.scala 23:23]
    first <= io.in @[Probes.scala 24:9]
    second <= first @[Probes.scala 25:10]
    io.a <= first @[Probes.scala 26:8]
    io.b <= second @[Probes.scala 27:8]

