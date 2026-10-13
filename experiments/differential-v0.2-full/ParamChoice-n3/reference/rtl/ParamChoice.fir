circuit ParamChoice :
  module ParamChoice :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : UInt<3>, out : UInt<3>}

    node _io_out_T = add(io.in, UInt<2>("h2")) @[Probes.scala 48:26]
    node _io_out_T_1 = tail(_io_out_T, 1) @[Probes.scala 48:26]
    io.out <= _io_out_T_1 @[Probes.scala 48:17]

