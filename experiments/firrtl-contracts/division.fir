circuit Division :
  module Division :
    input a : UInt<8>
    input b : UInt<8>
    output q : UInt<8>
    q <= div(a, b)
