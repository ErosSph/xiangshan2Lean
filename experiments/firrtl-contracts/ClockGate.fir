circuit ClockGate :
  module ClockGate :
    input clock : Clock
    input en : UInt<1>
    output q : UInt<8>
    node gated = asClock(and(asUInt(clock), en))
    reg r : UInt<8>, gated
    r <= UInt<8>(1)
    q <= r
