circuit RegisterFile :
  module RegisterFile :
    input clock : Clock
    input reset : UInt<1>
    input write : UInt<1>
    input waddr : UInt<3>
    input raddr : UInt<3>
    input data : UInt<1>
    output out : UInt<1>

    wire _registers_WIRE : UInt<1>[1] @[Designs.scala 12:34]
    _registers_WIRE[0] <= UInt<1>("h0") @[Designs.scala 12:34]
    reg registers : UInt<1>[1], clock with :
      reset => (reset, _registers_WIRE) @[Designs.scala 12:26]
    when write : @[Designs.scala 13:15]
      registers[UInt<1>("h0")] <= data @[Designs.scala 13:34]
    out <= registers[UInt<1>("h0")] @[Designs.scala 14:7]

