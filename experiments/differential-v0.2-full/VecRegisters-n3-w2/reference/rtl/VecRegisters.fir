circuit VecRegisters :
  module VecRegisters :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : UInt<2>[3], out : UInt<2>[3]}

    reg registers : UInt<2>[3], clock with :
      reset => (UInt<1>("h0"), registers) @[Features.scala 105:22]
    registers[0] <= io.in[0] @[Features.scala 107:18]
    io.out[0] <= registers[0] @[Features.scala 108:15]
    registers[1] <= io.in[1] @[Features.scala 107:18]
    io.out[1] <= registers[1] @[Features.scala 108:15]
    registers[2] <= io.in[2] @[Features.scala 107:18]
    io.out[2] <= registers[2] @[Features.scala 108:15]

