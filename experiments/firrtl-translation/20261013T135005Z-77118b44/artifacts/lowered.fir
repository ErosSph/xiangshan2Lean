FIRRTL version 1.1.0
circuit NestedHierarchy :
  module PipelineLane :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<6>
    input en : UInt<1>
    output out : UInt<6>

    reg r : UInt<6>, clock with :
      reset => (UInt<1>("h0"), r) @[Hierarchy.scala 25:18]
    node _r_T = add(in, UInt<6>("h1")) @[Hierarchy.scala 26:22]
    node _r_T_1 = tail(_r_T, 1) @[Hierarchy.scala 26:22]
    node _GEN_0 = mux(en, _r_T_1, r) @[Hierarchy.scala 26:{12,16} 25:18]
    out <= r @[Hierarchy.scala 27:7]
    r <= mux(reset, UInt<6>("h0"), _GEN_0) @[Hierarchy.scala 25:{18,18}]

  module PipelineLane_1 :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<6>
    input en : UInt<1>
    output out : UInt<6>

    reg r : UInt<6>, clock with :
      reset => (UInt<1>("h0"), r) @[Hierarchy.scala 25:18]
    node _r_T = add(in, UInt<6>("h2")) @[Hierarchy.scala 26:22]
    node _r_T_1 = tail(_r_T, 1) @[Hierarchy.scala 26:22]
    node _GEN_0 = mux(en, _r_T_1, r) @[Hierarchy.scala 26:{12,16} 25:18]
    out <= r @[Hierarchy.scala 27:7]
    r <= mux(reset, UInt<6>("h0"), _GEN_0) @[Hierarchy.scala 25:{18,18}]

  module HierarchicalPipeline :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<5>
    input en : UInt<1>
    output out : UInt<6>

    inst a of PipelineLane @[Hierarchy.scala 11:17]
    inst b of PipelineLane_1 @[Hierarchy.scala 12:17]
    out <= b.out @[Hierarchy.scala 17:7]
    a.clock <= clock
    a.reset <= reset
    a.in <= pad(in, 6) @[Hierarchy.scala 13:8]
    a.en <= en @[Hierarchy.scala 14:8]
    b.clock <= clock
    b.reset <= reset
    b.in <= a.out @[Hierarchy.scala 15:8]
    b.en <= en @[Hierarchy.scala 16:8]

  module NestedHierarchy :
    input clock : Clock
    input reset : UInt<1>
    input io_in : UInt<5>
    input io_en : UInt<1>
    output io_out : UInt<6>

    inst child of HierarchicalPipeline @[Hierarchy.scala 33:21]
    io_out <= child.out @[Hierarchy.scala 36:10]
    child.clock <= clock
    child.reset <= reset
    child.in <= io_in @[Hierarchy.scala 34:12]
    child.en <= io_en @[Hierarchy.scala 35:12]
