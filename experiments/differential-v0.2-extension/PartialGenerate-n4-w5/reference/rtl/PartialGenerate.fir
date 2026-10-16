circuit PartialGenerate :
  module PartialGenerate :
    input in : UInt<5>[4]
    output out : UInt<5>[4]

    out <= in @[Mainstream.scala 98:7]
    node _value_T = add(in[0], UInt<1>("h1")) @[Mainstream.scala 99:61]
    node value = tail(_value_T, 1) @[Mainstream.scala 99:61]
    out[1] <= value @[Mainstream.scala 99:77]
    node _value_T_1 = add(in[1], UInt<1>("h1")) @[Mainstream.scala 99:61]
    node value_1 = tail(_value_T_1, 1) @[Mainstream.scala 99:61]
    out[2] <= value_1 @[Mainstream.scala 99:77]
    node _value_T_2 = add(in[2], UInt<1>("h1")) @[Mainstream.scala 99:61]
    node value_2 = tail(_value_T_2, 1) @[Mainstream.scala 99:61]
    out[3] <= value_2 @[Mainstream.scala 99:77]

