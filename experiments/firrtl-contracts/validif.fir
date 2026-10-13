circuit ConditionalValue :
  module ConditionalValue :
    input en : UInt<1>
    input a : UInt<8>
    output q : UInt<8>
    q <= validif(en, a)
