FIRRTL version 1.1.0
circuit VectorReset :
  module VectorReset :
    input clock : Clock
    input reset : UInt<1>
    input in_0 : UInt<4>
    input in_1 : UInt<4>
    input in_2 : UInt<4>
    input en : UInt<1>
    output out_0 : UInt<4>
    output out_1 : UInt<4>
    output out_2 : UInt<4>

    reg regs_0 : UInt<4>, clock with :
      reset => (UInt<1>("h0"), regs_0) @[Mainstream.scala 10:21]
    reg regs_1 : UInt<4>, clock with :
      reset => (UInt<1>("h0"), regs_1) @[Mainstream.scala 10:21]
    reg regs_2 : UInt<4>, clock with :
      reset => (UInt<1>("h0"), regs_2) @[Mainstream.scala 10:21]
    node _regs_0_T = add(in_0, UInt<1>("h1")) @[Mainstream.scala 11:54]
    node _regs_0_T_1 = tail(_regs_0_T, 1) @[Mainstream.scala 11:54]
    node _GEN_0 = mux(en, _regs_0_T_1, regs_0) @[Mainstream.scala 10:21 11:{35,45}]
    node _regs_1_T = add(in_1, UInt<1>("h1")) @[Mainstream.scala 11:54]
    node _regs_1_T_1 = tail(_regs_1_T, 1) @[Mainstream.scala 11:54]
    node _GEN_1 = mux(en, _regs_1_T_1, regs_1) @[Mainstream.scala 10:21 11:{35,45}]
    node _regs_2_T = add(in_2, UInt<1>("h1")) @[Mainstream.scala 11:54]
    node _regs_2_T_1 = tail(_regs_2_T, 1) @[Mainstream.scala 11:54]
    node _GEN_2 = mux(en, _regs_2_T_1, regs_2) @[Mainstream.scala 10:21 11:{35,45}]
    node _regs_WIRE_0 = UInt<4>("h0") @[Mainstream.scala 10:{29,29}]
    node _regs_WIRE_1 = UInt<4>("h0") @[Mainstream.scala 10:{29,29}]
    node _regs_WIRE_2 = UInt<4>("h0") @[Mainstream.scala 10:{29,29}]
    out_0 <= regs_0 @[Mainstream.scala 12:7]
    out_1 <= regs_1 @[Mainstream.scala 12:7]
    out_2 <= regs_2 @[Mainstream.scala 12:7]
    regs_0 <= mux(reset, _regs_WIRE_0, _GEN_0) @[Mainstream.scala 10:{21,21}]
    regs_1 <= mux(reset, _regs_WIRE_1, _GEN_1) @[Mainstream.scala 10:{21,21}]
    regs_2 <= mux(reset, _regs_WIRE_2, _GEN_2) @[Mainstream.scala 10:{21,21}]
