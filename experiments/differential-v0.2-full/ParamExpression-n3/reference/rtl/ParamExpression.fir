circuit ParamExpression :
  module ParamExpression :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : UInt<4>, out : UInt<6>}

    io.out <= io.in @[Probes.scala 64:10]

