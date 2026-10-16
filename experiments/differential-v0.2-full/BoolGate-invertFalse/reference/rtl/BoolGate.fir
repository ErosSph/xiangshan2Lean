circuit BoolGate :
  module BoolGate :
    input in : UInt<1>
    output out : UInt<1>

    out <= in @[Features.scala 80:7]

