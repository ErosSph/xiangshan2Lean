circuit TabulatedVector :
  module TabulatedVector :
    input in : UInt<2>[1]
    output out : UInt<2>[1]

    node _computed_T = add(in[0], UInt<1>("h1")) @[Designs.scala 56:53]
    node _computed_T_1 = tail(_computed_T, 1) @[Designs.scala 56:53]
    wire computed : UInt<2>[1] @[Designs.scala 56:25]
    computed[0] <= _computed_T_1 @[Designs.scala 56:25]
    out <= computed @[Designs.scala 57:7]

