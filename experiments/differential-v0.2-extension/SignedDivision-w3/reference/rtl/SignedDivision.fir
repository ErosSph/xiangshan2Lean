circuit SignedDivision :
  module SignedDivision :
    input a : SInt<3>
    input b : SInt<3>
    output quotient : SInt<4>
    output remainder : SInt<3>

    node _quotient_T = div(a, b) @[Mainstream.scala 82:17]
    quotient <= _quotient_T @[Mainstream.scala 82:12]
    node _remainder_T = rem(a, b) @[Mainstream.scala 83:18]
    remainder <= _remainder_T @[Mainstream.scala 83:13]

