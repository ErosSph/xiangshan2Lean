circuit RegisterFile :
  module RegisterFile :
    input clock : Clock
    input reset : UInt<1>
    input write : UInt<1>
    input waddr : UInt<3>
    input raddr : UInt<3>
    input data : UInt<4>
    output out : UInt<4>

    wire _registers_WIRE : UInt<4>[3] @[Designs.scala 12:34]
    _registers_WIRE[0] <= UInt<4>("h0") @[Designs.scala 12:34]
    _registers_WIRE[1] <= UInt<4>("h0") @[Designs.scala 12:34]
    _registers_WIRE[2] <= UInt<4>("h0") @[Designs.scala 12:34]
    reg registers : UInt<4>[3], clock with :
      reset => (reset, _registers_WIRE) @[Designs.scala 12:26]
    when write : @[Designs.scala 13:15]
      node _T = bits(waddr, 1, 0)
      registers[_T] <= data @[Designs.scala 13:34]
    node _out_T = bits(raddr, 1, 0)
    out <= registers[_out_T] @[Designs.scala 14:7]

