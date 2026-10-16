circuit AsyncMemory :
  module AsyncMemory :
    input clock : Clock
    input reset : UInt<1>
    input write : UInt<1>
    input waddr : UInt<3>
    input raddr : UInt<3>
    input data : UInt<7>
    output out : UInt<7>

    cmem memory : UInt<7> [8] @[Memories.scala 11:19]
    when write : @[Memories.scala 12:15]
      write mport MPORT = memory[waddr], clock
      MPORT <= data
    read mport out_MPORT = memory[raddr], clock @[Memories.scala 13:21]
    out <= out_MPORT @[Memories.scala 13:7]

