circuit BoolGate :
  module BoolGate :
    input in : UInt<1>
    output out : UInt<1>

    node _out_T = eq(in, UInt<1>("h0")) @[Features.scala 80:23]
    out <= _out_T @[Features.scala 80:7]

