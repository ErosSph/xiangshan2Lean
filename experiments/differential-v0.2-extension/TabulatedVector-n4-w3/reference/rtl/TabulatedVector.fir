circuit TabulatedVector :
  module TabulatedVector :
    input in : UInt<3>[4]
    output out : UInt<3>[4]

    node _computed_T = add(in[0], UInt<1>("h1")) @[Designs.scala 56:53]
    node _computed_T_1 = tail(_computed_T, 1) @[Designs.scala 56:53]
    node _computed_T_2 = add(in[1], UInt<1>("h1")) @[Designs.scala 56:53]
    node _computed_T_3 = tail(_computed_T_2, 1) @[Designs.scala 56:53]
    node _computed_T_4 = add(in[2], UInt<1>("h1")) @[Designs.scala 56:53]
    node _computed_T_5 = tail(_computed_T_4, 1) @[Designs.scala 56:53]
    node _computed_T_6 = add(in[3], UInt<1>("h1")) @[Designs.scala 56:53]
    node _computed_T_7 = tail(_computed_T_6, 1) @[Designs.scala 56:53]
    wire computed : UInt<3>[4] @[Designs.scala 56:25]
    computed[0] <= _computed_T_1 @[Designs.scala 56:25]
    computed[1] <= _computed_T_3 @[Designs.scala 56:25]
    computed[2] <= _computed_T_5 @[Designs.scala 56:25]
    computed[3] <= _computed_T_7 @[Designs.scala 56:25]
    out <= computed @[Designs.scala 57:7]

