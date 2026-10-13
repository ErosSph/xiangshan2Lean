circuit OriginalRightShiftReference :
  module RightShiftModule :
    input clock : Clock
    input reset : Reset
    output io : { flip shamt : UInt<6>, flip revShamt : UInt<6>, flip srlSrc : UInt<64>, flip sraSrc : UInt<64>, srl : UInt<64>, sra : UInt<64>, revSrl : UInt<64>}

    node _io_srl_T = dshr(io.srlSrc, io.shamt) @[OriginalRightShiftModule.scala 32:24]
    io.srl <= _io_srl_T @[OriginalRightShiftModule.scala 32:11]
    node _io_sra_T = asSInt(io.sraSrc) @[OriginalRightShiftModule.scala 33:25]
    node _io_sra_T_1 = dshr(_io_sra_T, io.shamt) @[OriginalRightShiftModule.scala 33:32]
    node _io_sra_T_2 = asUInt(_io_sra_T_1) @[OriginalRightShiftModule.scala 33:45]
    io.sra <= _io_sra_T_2 @[OriginalRightShiftModule.scala 33:11]
    node _io_revSrl_T = dshr(io.srlSrc, io.revShamt) @[OriginalRightShiftModule.scala 34:27]
    io.revSrl <= _io_revSrl_T @[OriginalRightShiftModule.scala 34:14]

  module OriginalRightShiftReference :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip shamt : UInt<6>, flip revShamt : UInt<6>, flip srlSrc : UInt<64>, flip sraSrc : UInt<64>, srl : UInt<64>, sra : UInt<64>, revSrl : UInt<64>}

    inst original of RightShiftModule @[Framework.scala 32:26]
    original.clock <= clock
    original.reset <= reset
    original.io.shamt <= io.shamt @[Framework.scala 33:23]
    original.io.revShamt <= io.revShamt @[Framework.scala 34:26]
    original.io.srlSrc <= io.srlSrc @[Framework.scala 35:24]
    original.io.sraSrc <= io.sraSrc @[Framework.scala 36:24]
    io.srl <= original.io.srl @[Framework.scala 37:12]
    io.sra <= original.io.sra @[Framework.scala 38:12]
    io.revSrl <= original.io.revSrl @[Framework.scala 39:15]

