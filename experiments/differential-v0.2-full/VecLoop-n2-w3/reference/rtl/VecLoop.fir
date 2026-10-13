circuit VecLoop :
  module VecLoop :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : UInt<3>[2], out : UInt<3>[2]}

    node _io_out_0_T = add(io.in[0], UInt<1>("h1")) @[Probes.scala 56:48]
    node _io_out_0_T_1 = tail(_io_out_0_T, 1) @[Probes.scala 56:48]
    io.out[0] <= _io_out_0_T_1 @[Probes.scala 56:36]
    node _io_out_1_T = add(io.in[1], UInt<1>("h1")) @[Probes.scala 56:48]
    node _io_out_1_T_1 = tail(_io_out_1_T, 1) @[Probes.scala 56:48]
    io.out[1] <= _io_out_1_T_1 @[Probes.scala 56:36]

