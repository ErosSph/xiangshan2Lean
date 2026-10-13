circuit SyncMemory :
  module SyncMemory :
    input clock : Clock
    input reset : UInt<1>
    input write : UInt<1>
    input readEnable : UInt<1>
    input waddr : UInt<3>
    input raddr : UInt<3>
    input data : UInt<3>
    output out : UInt<3>

    smem memory : UInt<3> [2] @[Memories.scala 24:27]
    when write : @[Memories.scala 25:15]
      node _T = bits(waddr, 0, 0)
      write mport MPORT = memory[_T], clock
      MPORT <= data
    wire _out_WIRE : UInt @[Memories.scala 26:21]
    _out_WIRE is invalid @[Memories.scala 26:21]
    when readEnable : @[Memories.scala 26:21]
      _out_WIRE <= raddr @[Memories.scala 26:21]
      node _out_T = or(_out_WIRE, UInt<1>("h0")) @[Memories.scala 26:21]
      node _out_T_1 = bits(_out_T, 0, 0) @[Memories.scala 26:21]
      read mport out_MPORT = memory[_out_T_1], clock @[Memories.scala 26:21]
    out <= out_MPORT @[Memories.scala 26:7]

