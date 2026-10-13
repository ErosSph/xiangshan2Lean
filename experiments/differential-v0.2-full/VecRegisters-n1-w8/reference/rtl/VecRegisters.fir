circuit VecRegisters :
  module VecRegisters :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : UInt<8>[1], out : UInt<8>[1]}

    reg registers : UInt<8>[1], clock with :
      reset => (UInt<1>("h0"), registers) @[Features.scala 105:22]
    registers[0] <= io.in[0] @[Features.scala 107:18]
    io.out[0] <= registers[0] @[Features.scala 108:15]

