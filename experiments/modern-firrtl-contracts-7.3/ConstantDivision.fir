FIRRTL version 6.0.0
circuit ConstantDivision :
  public module ConstantDivision :
    input a : UInt<8>
    output q : UInt<8>
    connect q, div(a, UInt<8>(0))
