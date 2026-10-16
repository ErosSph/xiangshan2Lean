circuit ParamChoice :
  module ParamChoice :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : UInt<9>, out : UInt<9>}

    node _io_out_T = add(io.in, UInt<1>("h1")) @[Probes.scala 47:32]
    node _io_out_T_1 = tail(_io_out_T, 1) @[Probes.scala 47:32]
    io.out <= _io_out_T_1 @[Probes.scala 47:23]

