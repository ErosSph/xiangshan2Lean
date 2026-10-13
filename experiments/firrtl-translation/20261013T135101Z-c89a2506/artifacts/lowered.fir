FIRRTL version 1.1.0
circuit SwitchMachine :
  module SwitchMachine :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<5>
    input en : UInt<1>
    output out : UInt<5>

    reg state : UInt<2>, clock with :
      reset => (UInt<1>("h0"), state) @[Mainstream.scala 45:22]
    reg data : UInt<5>, clock with :
      reset => (UInt<1>("h0"), data) @[Mainstream.scala 46:21]
    node _T = eq(UInt<2>("h0"), state) @[Mainstream.scala 47:17]
    node _GEN_0 = mux(en, in, data) @[Mainstream.scala 46:21 48:{25,32}]
    node _GEN_1 = mux(en, UInt<2>("h1"), state) @[Mainstream.scala 45:22 48:{25,45}]
    node _T_1 = eq(UInt<2>("h1"), state) @[Mainstream.scala 47:17]
    node _data_T = add(data, UInt<1>("h1")) @[Mainstream.scala 49:29]
    node _data_T_1 = tail(_data_T, 1) @[Mainstream.scala 49:29]
    node _T_2 = eq(UInt<2>("h2"), state) @[Mainstream.scala 47:17]
    node _GEN_2 = mux(_T_2, UInt<2>("h0"), state) @[Mainstream.scala 47:17 45:22 50:22]
    node _GEN_3 = mux(_T_1, _data_T_1, data) @[Mainstream.scala 47:17 46:21 49:21]
    node _GEN_4 = mux(_T_1, UInt<2>("h2"), _GEN_2) @[Mainstream.scala 47:17 49:42]
    node _GEN_5 = mux(_T, _GEN_0, _GEN_3) @[Mainstream.scala 47:17]
    node _GEN_6 = mux(_T, _GEN_1, _GEN_4) @[Mainstream.scala 47:17]
    node _out_T = eq(state, UInt<2>("h2")) @[Mainstream.scala 52:20]
    node _out_T_1 = mux(_out_T, data, UInt<1>("h0")) @[Mainstream.scala 52:13]
    out <= _out_T_1 @[Mainstream.scala 52:7]
    state <= mux(reset, UInt<2>("h0"), _GEN_6) @[Mainstream.scala 45:{22,22}]
    data <= mux(reset, UInt<5>("h0"), _GEN_5) @[Mainstream.scala 46:{21,21}]
