circuit ParamExpression :
  module ParamExpression :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : UInt<10>, out : UInt<18>}

    io.out <= io.in @[Probes.scala 64:10]

