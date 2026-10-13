circuit MuxPriorities :
  module MuxPriorities :
    input a : UInt<5>
    input b : UInt<5>
    input c : UInt<5>
    input sel : UInt<2>
    input x : UInt<1>
    input y : UInt<1>
    output lookup : UInt<5>
    output muxcase : UInt<5>
    output priority : UInt<5>
    output widthCheck : UInt<6>

    node _lookup_T = eq(UInt<1>("h0"), sel) @[Mux.scala 81:61]
    node _lookup_T_1 = mux(_lookup_T, a, UInt<1>("h0")) @[Mux.scala 81:58]
    node _lookup_T_2 = eq(UInt<1>("h0"), sel) @[Mux.scala 81:61]
    node _lookup_T_3 = mux(_lookup_T_2, b, _lookup_T_1) @[Mux.scala 81:58]
    node _lookup_T_4 = eq(UInt<1>("h1"), sel) @[Mux.scala 81:61]
    node _lookup_T_5 = mux(_lookup_T_4, c, _lookup_T_3) @[Mux.scala 81:58]
    lookup <= _lookup_T_5 @[Muxes.scala 17:10]
    node _muxcase_T = mux(y, b, c) @[Mux.scala 101:16]
    node _muxcase_T_1 = mux(x, a, _muxcase_T) @[Mux.scala 101:16]
    muxcase <= _muxcase_T_1 @[Muxes.scala 18:11]
    node _priority_T = mux(y, b, c) @[Mux.scala 47:70]
    node _priority_T_1 = mux(x, a, _priority_T) @[Mux.scala 47:70]
    priority <= _priority_T_1 @[Muxes.scala 19:12]
    node _exhaustive_T = eq(UInt<1>("h1"), sel) @[Mux.scala 81:61]
    node _exhaustive_T_1 = mux(_exhaustive_T, b, a) @[Mux.scala 81:58]
    node _exhaustive_T_2 = eq(UInt<2>("h2"), sel) @[Mux.scala 81:61]
    node _exhaustive_T_3 = mux(_exhaustive_T_2, c, _exhaustive_T_1) @[Mux.scala 81:58]
    node _exhaustive_T_4 = eq(UInt<2>("h3"), sel) @[Mux.scala 81:61]
    node exhaustive = mux(_exhaustive_T_4, a, _exhaustive_T_3) @[Mux.scala 81:58]
    node _widthCheck_T = add(exhaustive, UInt<1>("h1")) @[Muxes.scala 21:28]
    widthCheck <= _widthCheck_T @[Muxes.scala 21:14]

