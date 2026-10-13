circuit HierarchicalComb :
  module CombLane :
    output io : { flip in : UInt<8>, out : UInt<8>}

    io.out <= io.in @[Hierarchy.scala 51:10]

  module HierarchicalComb :
    input a : UInt<8>
    output out : UInt<8>

    inst child of CombLane @[Hierarchy.scala 43:21]
    child.io.in <= a @[Hierarchy.scala 44:15]
    node _out_T = add(child.io.out, UInt<1>("h1")) @[Hierarchy.scala 45:23]
    node _out_T_1 = tail(_out_T, 1) @[Hierarchy.scala 45:23]
    out <= _out_T_1 @[Hierarchy.scala 45:7]

