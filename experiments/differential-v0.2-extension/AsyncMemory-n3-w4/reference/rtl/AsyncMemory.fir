circuit AsyncMemory :
  module AsyncMemory :
    input clock : Clock
    input reset : UInt<1>
    input write : UInt<1>
    input waddr : UInt<3>
    input raddr : UInt<3>
    input data : UInt<4>
    output out : UInt<4>

    cmem memory : UInt<4> [3] @[Memories.scala 11:19]
    when write : @[Memories.scala 12:15]
      node _T = bits(waddr, 1, 0)
      write mport MPORT = memory[_T], clock
      MPORT <= data
    node _out_T = bits(raddr, 1, 0) @[Memories.scala 13:21]
    read mport out_MPORT = memory[_out_T], clock @[Memories.scala 13:21]
    out <= out_MPORT @[Memories.scala 13:7]

