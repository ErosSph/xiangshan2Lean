circuit SignedDivision :
  module SignedDivision :
    input a : SInt<2>
    input b : SInt<2>
    output quotient : SInt<3>
    output remainder : SInt<2>

    node _quotient_T = div(a, b) @[Mainstream.scala 82:17]
    quotient <= _quotient_T @[Mainstream.scala 82:12]
    node _remainder_T = rem(a, b) @[Mainstream.scala 83:18]
    remainder <= _remainder_T @[Mainstream.scala 83:13]

