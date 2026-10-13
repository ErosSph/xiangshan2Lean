circuit SwitchMachine :
  module SwitchMachine :
    input clock : Clock
    input reset : UInt<1>
    input in : UInt<2>
    input en : UInt<1>
    output out : UInt<2>

    reg state : UInt<2>, clock with :
      reset => (reset, UInt<2>("h0")) @[Mainstream.scala 45:22]
    reg data : UInt<2>, clock with :
      reset => (reset, UInt<2>("h0")) @[Mainstream.scala 46:21]
    node _T = eq(UInt<2>("h0"), state) @[Mainstream.scala 47:17]
    when _T : @[Mainstream.scala 47:17]
      when en : @[Mainstream.scala 48:25]
        data <= in @[Mainstream.scala 48:32]
        state <= UInt<2>("h1") @[Mainstream.scala 48:45]
    else :
      node _T_1 = eq(UInt<2>("h1"), state) @[Mainstream.scala 47:17]
      when _T_1 : @[Mainstream.scala 47:17]
        node _data_T = add(data, UInt<1>("h1")) @[Mainstream.scala 49:29]
        node _data_T_1 = tail(_data_T, 1) @[Mainstream.scala 49:29]
        data <= _data_T_1 @[Mainstream.scala 49:21]
        state <= UInt<2>("h2") @[Mainstream.scala 49:42]
      else :
        node _T_2 = eq(UInt<2>("h2"), state) @[Mainstream.scala 47:17]
        when _T_2 : @[Mainstream.scala 47:17]
          state <= UInt<2>("h0") @[Mainstream.scala 50:22]
    node _out_T = eq(state, UInt<2>("h2")) @[Mainstream.scala 52:20]
    node _out_T_1 = mux(_out_T, data, UInt<1>("h0")) @[Mainstream.scala 52:13]
    out <= _out_T_1 @[Mainstream.scala 52:7]

