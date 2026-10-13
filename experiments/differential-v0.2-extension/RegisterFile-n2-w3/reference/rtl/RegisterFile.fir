circuit RegisterFile :
  module RegisterFile :
    input clock : Clock
    input reset : UInt<1>
    input write : UInt<1>
    input waddr : UInt<3>
    input raddr : UInt<3>
    input data : UInt<3>
    output out : UInt<3>

    wire _registers_WIRE : UInt<3>[2] @[Designs.scala 12:34]
    _registers_WIRE[0] <= UInt<3>("h0") @[Designs.scala 12:34]
    _registers_WIRE[1] <= UInt<3>("h0") @[Designs.scala 12:34]
    reg registers : UInt<3>[2], clock with :
      reset => (reset, _registers_WIRE) @[Designs.scala 12:26]
    when write : @[Designs.scala 13:15]
      node _T = bits(waddr, 0, 0)
      registers[_T] <= data @[Designs.scala 13:34]
    node _out_T = bits(raddr, 0, 0)
    out <= registers[_out_T] @[Designs.scala 14:7]

