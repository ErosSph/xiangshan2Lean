FIRRTL version 6.0.0
circuit Division :
  public module Division :
    input en : UInt<1>
    input a : UInt<8>
    input b : UInt<8>
    output q : UInt<8>
    connect q, mux(en, div(a, b), UInt<8>(7))
