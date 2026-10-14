FIRRTL version 6.0.0
circuit AsyncReset :
  public module AsyncReset :
    input clock : Clock
    input reset : AsyncReset
    output q : UInt<8>
    regreset r : UInt<8>, clock, reset, UInt<8>(0)
    connect r, UInt<8>(1)
    connect q, r
