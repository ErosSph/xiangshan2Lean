circuit RegisterFile :
  module RegisterFile :
    input clock : Clock
    input reset : UInt<1>
    input write : UInt<1>
    input waddr : UInt<3>
    input raddr : UInt<3>
    input data : UInt<7>
    output out : UInt<7>

    wire _registers_WIRE : UInt<7>[8] @[Designs.scala 12:34]
    _registers_WIRE[0] <= UInt<7>("h0") @[Designs.scala 12:34]
    _registers_WIRE[1] <= UInt<7>("h0") @[Designs.scala 12:34]
    _registers_WIRE[2] <= UInt<7>("h0") @[Designs.scala 12:34]
    _registers_WIRE[3] <= UInt<7>("h0") @[Designs.scala 12:34]
    _registers_WIRE[4] <= UInt<7>("h0") @[Designs.scala 12:34]
    _registers_WIRE[5] <= UInt<7>("h0") @[Designs.scala 12:34]
    _registers_WIRE[6] <= UInt<7>("h0") @[Designs.scala 12:34]
    _registers_WIRE[7] <= UInt<7>("h0") @[Designs.scala 12:34]
    reg registers : UInt<7>[8], clock with :
      reset => (reset, _registers_WIRE) @[Designs.scala 12:26]
    when write : @[Designs.scala 13:15]
      registers[waddr] <= data @[Designs.scala 13:34]
    out <= registers[raddr] @[Designs.scala 14:7]

