FIRRTL version 1.1.0
circuit HierarchicalPipeline :
  module PipelineLane :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<9>
    input en : UInt<1>
    output out : UInt<9>

    reg r : UInt<9>, clock with :
      reset => (UInt<1>("h0"), r) @[Hierarchy.scala 25:18]
    node _r_T = add(in, UInt<9>("h1")) @[Hierarchy.scala 26:22]
    node _r_T_1 = tail(_r_T, 1) @[Hierarchy.scala 26:22]
    node _GEN_0 = mux(en, _r_T_1, r) @[Hierarchy.scala 26:{12,16} 25:18]
    out <= r @[Hierarchy.scala 27:7]
    r <= mux(reset, UInt<9>("h0"), _GEN_0) @[Hierarchy.scala 25:{18,18}]

  module PipelineLane_1 :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<9>
    input en : UInt<1>
    output out : UInt<9>

    reg r : UInt<9>, clock with :
      reset => (UInt<1>("h0"), r) @[Hierarchy.scala 25:18]
    node _r_T = add(in, UInt<9>("h2")) @[Hierarchy.scala 26:22]
    node _r_T_1 = tail(_r_T, 1) @[Hierarchy.scala 26:22]
    node _GEN_0 = mux(en, _r_T_1, r) @[Hierarchy.scala 26:{12,16} 25:18]
    out <= r @[Hierarchy.scala 27:7]
    r <= mux(reset, UInt<9>("h0"), _GEN_0) @[Hierarchy.scala 25:{18,18}]

  module HierarchicalPipeline :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<8>
    input en : UInt<1>
    output out : UInt<9>

    inst a of PipelineLane @[Hierarchy.scala 11:17]
    inst b of PipelineLane_1 @[Hierarchy.scala 12:17]
    out <= b.out @[Hierarchy.scala 17:7]
    a.clock <= clock
    a.reset <= reset
    a.in <= pad(in, 9) @[Hierarchy.scala 13:8]
    a.en <= en @[Hierarchy.scala 14:8]
    b.clock <= clock
    b.reset <= reset
    b.in <= a.out @[Hierarchy.scala 15:8]
    b.en <= en @[Hierarchy.scala 16:8]
