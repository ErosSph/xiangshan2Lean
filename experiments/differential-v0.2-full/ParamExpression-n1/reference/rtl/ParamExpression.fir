circuit ParamExpression :
  module ParamExpression :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : UInt<2>, out : UInt<2>}

    io.out <= io.in @[Probes.scala 64:10]

