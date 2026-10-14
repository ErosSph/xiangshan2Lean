FIRRTL version 6.0.0
circuit DeadAssertion :
  public module DeadAssertion :
    input clock : Clock
    input en : UInt<1>
    output q : UInt<1>
    connect q, en
    assert(clock, UInt<1>(1), UInt<1>(0), "disabled assertion is still unsupported")
