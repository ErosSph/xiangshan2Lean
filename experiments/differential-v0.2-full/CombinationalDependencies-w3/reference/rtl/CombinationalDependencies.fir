circuit CombinationalDependencies :
  module CombinationalDependencies :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : UInt<3>, flip en : UInt<1>, out : UInt<3>}

    wire a : UInt<3> @[Features.scala 69:15]
    wire b : UInt<3> @[Features.scala 70:15]
    a <= UInt<1>("h0") @[Features.scala 71:5]
    b <= a @[Features.scala 72:5]
    io.out <= b @[Features.scala 73:10]
    when io.en : @[Features.scala 74:15]
      a <= io.in @[Features.scala 74:19]


