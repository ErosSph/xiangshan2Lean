circuit HierarchicalPipeline :
  module PipelineLane :
    input clock : Clock
    input reset : Reset
    input in : UInt<4>
    input en : UInt<1>
    output out : UInt<4>

    reg r : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[Hierarchy.scala 25:18]
    when en : @[Hierarchy.scala 26:12]
      node _r_T = add(in, UInt<4>("h1")) @[Hierarchy.scala 26:22]
      node _r_T_1 = tail(_r_T, 1) @[Hierarchy.scala 26:22]
      r <= _r_T_1 @[Hierarchy.scala 26:16]
    out <= r @[Hierarchy.scala 27:7]

  module PipelineLane_1 :
    input clock : Clock
    input reset : Reset
    input in : UInt<4>
    input en : UInt<1>
    output out : UInt<4>

    reg r : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[Hierarchy.scala 25:18]
    when en : @[Hierarchy.scala 26:12]
      node _r_T = add(in, UInt<4>("h2")) @[Hierarchy.scala 26:22]
      node _r_T_1 = tail(_r_T, 1) @[Hierarchy.scala 26:22]
      r <= _r_T_1 @[Hierarchy.scala 26:16]
    out <= r @[Hierarchy.scala 27:7]

  module HierarchicalPipeline :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<3>
    input en : UInt<1>
    output out : UInt<4>

    inst a of PipelineLane @[Hierarchy.scala 11:17]
    a.clock <= clock
    a.reset <= reset
    inst b of PipelineLane_1 @[Hierarchy.scala 12:17]
    b.clock <= clock
    b.reset <= reset
    a.in <= in @[Hierarchy.scala 13:8]
    a.en <= en @[Hierarchy.scala 14:8]
    b.in <= a.out @[Hierarchy.scala 15:8]
    b.en <= en @[Hierarchy.scala 16:8]
    out <= b.out @[Hierarchy.scala 17:7]

