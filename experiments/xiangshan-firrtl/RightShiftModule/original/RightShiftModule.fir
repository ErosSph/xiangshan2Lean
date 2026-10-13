circuit RightShiftModule :
  module RightShiftModule :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip shamt : UInt<6>, flip revShamt : UInt<6>, flip srlSrc : UInt<64>, flip sraSrc : UInt<64>, srl : UInt<64>, sra : UInt<64>, revSrl : UInt<64>}

    node _io_srl_T = dshr(io.srlSrc, io.shamt) @[Alu.scala 77:24]
    io.srl <= _io_srl_T @[Alu.scala 77:11]
    node _io_sra_T = asSInt(io.sraSrc) @[Alu.scala 78:31]
    node _io_sra_T_1 = dshr(_io_sra_T, io.shamt) @[Alu.scala 78:34]
    node _io_sra_T_2 = asUInt(_io_sra_T_1) @[Alu.scala 78:53]
    io.sra <= _io_sra_T_2 @[Alu.scala 78:11]
    node _io_revSrl_T = dshr(io.srlSrc, io.revShamt) @[Alu.scala 79:27]
    io.revSrl <= _io_revSrl_T @[Alu.scala 79:14]

