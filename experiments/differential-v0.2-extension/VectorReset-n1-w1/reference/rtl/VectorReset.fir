circuit VectorReset :
  module VectorReset :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<1>[1]
    input en : UInt<1>
    output out : UInt<1>[1]

    wire _regs_WIRE : UInt<1>[1] @[Mainstream.scala 10:29]
    _regs_WIRE[0] <= UInt<1>("h0") @[Mainstream.scala 10:29]
    reg regs : UInt<1>[1], clock with :
      reset => (reset, _regs_WIRE) @[Mainstream.scala 10:21]
    when en : @[Mainstream.scala 11:35]
      node _regs_0_T = add(in[0], UInt<1>("h1")) @[Mainstream.scala 11:54]
      node _regs_0_T_1 = tail(_regs_0_T, 1) @[Mainstream.scala 11:54]
      regs[0] <= _regs_0_T_1 @[Mainstream.scala 11:45]
    out <= regs @[Mainstream.scala 12:7]

