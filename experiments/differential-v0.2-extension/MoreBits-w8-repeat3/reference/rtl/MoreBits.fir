circuit MoreBits :
  module MoreBits :
    input a : UInt<8>
    input b : UInt<8>
    input shift : UInt<2>
    output quotient : UInt<8>
    output remainder : UInt<8>
    output shifted : UInt<11>
    output top : UInt<2>
    output bottom : UInt<7>
    output filled : UInt<6>
    output bit : UInt<1>

    node _quotient_T = div(a, b) @[Mainstream.scala 67:17]
    quotient <= _quotient_T @[Mainstream.scala 67:12]
    node _remainder_T = rem(a, b) @[Mainstream.scala 68:18]
    remainder <= _remainder_T @[Mainstream.scala 68:13]
    node _shifted_T = dshl(a, shift) @[Mainstream.scala 69:16]
    shifted <= _shifted_T @[Mainstream.scala 69:11]
    node _top_T = head(a, 2) @[Mainstream.scala 70:16]
    top <= _top_T @[Mainstream.scala 70:7]
    node _bottom_T = tail(a, 1) @[Mainstream.scala 71:19]
    bottom <= _bottom_T @[Mainstream.scala 71:10]
    node _filled_T = bits(a, 1, 0) @[Mainstream.scala 72:27]
    node _filled_T_1 = cat(_filled_T, _filled_T) @[Cat.scala 33:92]
    node _filled_T_2 = cat(_filled_T, _filled_T_1) @[Cat.scala 33:92]
    filled <= _filled_T_2 @[Mainstream.scala 72:10]
    node _bit_T = dshr(a, shift) @[Mainstream.scala 73:11]
    node _bit_T_1 = bits(_bit_T, 0, 0) @[Mainstream.scala 73:11]
    bit <= _bit_T_1 @[Mainstream.scala 73:7]

