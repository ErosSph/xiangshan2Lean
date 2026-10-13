circuit ParameterLookup :
  module ParameterLookup :
    input sel : UInt<2>
    input a : UInt<2>
    input b : UInt<2>
    output out : UInt<2>

    node _out_T = add(a, b) @[Designs.scala 49:64]
    node _out_T_1 = tail(_out_T, 1) @[Designs.scala 49:64]
    node _out_T_2 = eq(UInt<1>("h0"), sel) @[Mux.scala 81:61]
    node _out_T_3 = mux(_out_T_2, a, UInt<1>("h0")) @[Mux.scala 81:58]
    node _out_T_4 = eq(UInt<1>("h1"), sel) @[Mux.scala 81:61]
    node _out_T_5 = mux(_out_T_4, b, _out_T_3) @[Mux.scala 81:58]
    node _out_T_6 = eq(UInt<2>("h2"), sel) @[Mux.scala 81:61]
    node _out_T_7 = mux(_out_T_6, _out_T_1, _out_T_5) @[Mux.scala 81:58]
    out <= _out_T_7 @[Designs.scala 49:7]

