FIRRTL version 6.0.0
circuit MultiClock :
  public module MultiClock :
    input a : Clock
    input b : Clock
    output q : UInt<8>
    reg r : UInt<8>, a
    reg s : UInt<8>, b
    connect r, UInt<8>(1)
    connect s, r
    connect q, s
