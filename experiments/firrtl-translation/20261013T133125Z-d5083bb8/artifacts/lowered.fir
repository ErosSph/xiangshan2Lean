FIRRTL version 1.1.0
circuit OriginalRightShiftReference :
  module RightShiftModule :
    input clock : Clock
    input reset : UInt<1>
    input io_shamt : UInt<6>
    input io_revShamt : UInt<6>
    input io_srlSrc : UInt<64>
    input io_sraSrc : UInt<64>
    output io_srl : UInt<64>
    output io_sra : UInt<64>
    output io_revSrl : UInt<64>

    node _io_srl_T = dshr(io_srlSrc, io_shamt) @[OriginalRightShiftModule.scala 32:24]
    node _io_sra_T = asSInt(io_sraSrc) @[OriginalRightShiftModule.scala 33:25]
    node _io_sra_T_1 = dshr(_io_sra_T, io_shamt) @[OriginalRightShiftModule.scala 33:32]
    node _io_sra_T_2 = asUInt(_io_sra_T_1) @[OriginalRightShiftModule.scala 33:45]
    node _io_revSrl_T = dshr(io_srlSrc, io_revShamt) @[OriginalRightShiftModule.scala 34:27]
    io_srl <= _io_srl_T @[OriginalRightShiftModule.scala 32:11]
    io_sra <= _io_sra_T_2 @[OriginalRightShiftModule.scala 33:11]
    io_revSrl <= _io_revSrl_T @[OriginalRightShiftModule.scala 34:14]

  module OriginalRightShiftReference :
    input clock : Clock
    input reset : UInt<1>
    input io_shamt : UInt<6>
    input io_revShamt : UInt<6>
    input io_srlSrc : UInt<64>
    input io_sraSrc : UInt<64>
    output io_srl : UInt<64>
    output io_sra : UInt<64>
    output io_revSrl : UInt<64>

    inst original of RightShiftModule @[Framework.scala 32:26]
    io_srl <= original.io_srl @[Framework.scala 37:12]
    io_sra <= original.io_sra @[Framework.scala 38:12]
    io_revSrl <= original.io_revSrl @[Framework.scala 39:15]
    original.clock <= clock
    original.reset <= reset
    original.io_shamt <= io_shamt @[Framework.scala 33:23]
    original.io_revShamt <= io_revShamt @[Framework.scala 34:26]
    original.io_srlSrc <= io_srlSrc @[Framework.scala 35:24]
    original.io_sraSrc <= io_sraSrc @[Framework.scala 36:24]
