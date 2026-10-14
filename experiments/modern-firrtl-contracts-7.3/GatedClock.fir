FIRRTL version 6.0.0
circuit GatedClock :
  public module GatedClock :
    input clock : Clock
    input en : UInt<1>
    output q : UInt<8>
    node gated = asClock(and(asUInt(clock), en))
    reg r : UInt<8>, gated
    connect r, UInt<8>(1)
    connect q, r
