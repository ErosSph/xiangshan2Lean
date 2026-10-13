circuit VectorReset :
  module VectorReset :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<8>[5]
    input en : UInt<1>
    output out : UInt<8>[5]

    wire _regs_WIRE : UInt<8>[5] @[Mainstream.scala 10:29]
    _regs_WIRE[0] <= UInt<8>("h0") @[Mainstream.scala 10:29]
    _regs_WIRE[1] <= UInt<8>("h0") @[Mainstream.scala 10:29]
    _regs_WIRE[2] <= UInt<8>("h0") @[Mainstream.scala 10:29]
    _regs_WIRE[3] <= UInt<8>("h0") @[Mainstream.scala 10:29]
    _regs_WIRE[4] <= UInt<8>("h0") @[Mainstream.scala 10:29]
    reg regs : UInt<8>[5], clock with :
      reset => (reset, _regs_WIRE) @[Mainstream.scala 10:21]
    when en : @[Mainstream.scala 11:35]
      node _regs_0_T = add(in[0], UInt<1>("h1")) @[Mainstream.scala 11:54]
      node _regs_0_T_1 = tail(_regs_0_T, 1) @[Mainstream.scala 11:54]
      regs[0] <= _regs_0_T_1 @[Mainstream.scala 11:45]
    when en : @[Mainstream.scala 11:35]
      node _regs_1_T = add(in[1], UInt<1>("h1")) @[Mainstream.scala 11:54]
      node _regs_1_T_1 = tail(_regs_1_T, 1) @[Mainstream.scala 11:54]
      regs[1] <= _regs_1_T_1 @[Mainstream.scala 11:45]
    when en : @[Mainstream.scala 11:35]
      node _regs_2_T = add(in[2], UInt<1>("h1")) @[Mainstream.scala 11:54]
      node _regs_2_T_1 = tail(_regs_2_T, 1) @[Mainstream.scala 11:54]
      regs[2] <= _regs_2_T_1 @[Mainstream.scala 11:45]
    when en : @[Mainstream.scala 11:35]
      node _regs_3_T = add(in[3], UInt<1>("h1")) @[Mainstream.scala 11:54]
      node _regs_3_T_1 = tail(_regs_3_T, 1) @[Mainstream.scala 11:54]
      regs[3] <= _regs_3_T_1 @[Mainstream.scala 11:45]
    when en : @[Mainstream.scala 11:35]
      node _regs_4_T = add(in[4], UInt<1>("h1")) @[Mainstream.scala 11:54]
      node _regs_4_T_1 = tail(_regs_4_T, 1) @[Mainstream.scala 11:54]
      regs[4] <= _regs_4_T_1 @[Mainstream.scala 11:45]
    out <= regs @[Mainstream.scala 12:7]

