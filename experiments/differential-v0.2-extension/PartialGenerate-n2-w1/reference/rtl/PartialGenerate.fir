circuit PartialGenerate :
  module PartialGenerate :
    input in : UInt<1>[2]
    output out : UInt<1>[2]

    out <= in @[Mainstream.scala 98:7]
    node _value_T = add(in[0], UInt<1>("h1")) @[Mainstream.scala 99:61]
    node value = tail(_value_T, 1) @[Mainstream.scala 99:61]
    out[1] <= value @[Mainstream.scala 99:77]

