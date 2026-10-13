FIRRTL version 1.1.0
circuit SignedDivision :
  module SignedDivision :
    input a : SInt<8>
    input b : SInt<8>
    output quotient : SInt<9>
    output remainder : SInt<8>

    node _quotient_T = div(a, b) @[Mainstream.scala 82:17]
    node _remainder_T = rem(a, b) @[Mainstream.scala 83:18]
    quotient <= _quotient_T @[Mainstream.scala 82:12]
    remainder <= _remainder_T @[Mainstream.scala 83:13]
