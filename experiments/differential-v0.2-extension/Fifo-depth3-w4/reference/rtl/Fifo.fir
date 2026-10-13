circuit Fifo :
  module Fifo :
    input clock : Clock
    input reset : UInt<1>
    input enq : UInt<1>
    input deq : UInt<1>
    input data : UInt<4>
    output out : UInt<4>
    output full : UInt<1>
    output empty : UInt<1>

    wire _storage_WIRE : UInt<4>[3] @[Designs.scala 25:32]
    _storage_WIRE[0] <= UInt<4>("h0") @[Designs.scala 25:32]
    _storage_WIRE[1] <= UInt<4>("h0") @[Designs.scala 25:32]
    _storage_WIRE[2] <= UInt<4>("h0") @[Designs.scala 25:32]
    reg storage : UInt<4>[3], clock with :
      reset => (reset, _storage_WIRE) @[Designs.scala 25:24]
    reg read : UInt<2>, clock with :
      reset => (reset, UInt<2>("h0")) @[Designs.scala 26:21]
    reg write : UInt<2>, clock with :
      reset => (reset, UInt<2>("h0")) @[Designs.scala 27:22]
    reg count : UInt<2>, clock with :
      reset => (reset, UInt<2>("h0")) @[Designs.scala 28:22]
    node _push_T = lt(count, UInt<2>("h3")) @[Designs.scala 29:27]
    node push = and(enq, _push_T) @[Designs.scala 29:18]
    node _pop_T = neq(count, UInt<1>("h0")) @[Designs.scala 30:26]
    node pop = and(deq, _pop_T) @[Designs.scala 30:17]
    when push : @[Designs.scala 31:14]
      storage[write] <= data @[Designs.scala 32:20]
      node _write_T = eq(write, UInt<2>("h2")) @[Designs.scala 33:24]
      node _write_T_1 = add(write, UInt<1>("h1")) @[Designs.scala 33:54]
      node _write_T_2 = tail(_write_T_1, 1) @[Designs.scala 33:54]
      node _write_T_3 = mux(_write_T, UInt<1>("h0"), _write_T_2) @[Designs.scala 33:17]
      write <= _write_T_3 @[Designs.scala 33:11]
    when pop : @[Designs.scala 35:13]
      node _read_T = eq(read, UInt<2>("h2")) @[Designs.scala 35:32]
      node _read_T_1 = add(read, UInt<1>("h1")) @[Designs.scala 35:61]
      node _read_T_2 = tail(_read_T_1, 1) @[Designs.scala 35:61]
      node _read_T_3 = mux(_read_T, UInt<1>("h0"), _read_T_2) @[Designs.scala 35:26]
      read <= _read_T_3 @[Designs.scala 35:20]
    node _T = eq(pop, UInt<1>("h0")) @[Designs.scala 36:16]
    node _T_1 = and(push, _T) @[Designs.scala 36:13]
    when _T_1 : @[Designs.scala 36:22]
      node _count_T = add(count, UInt<1>("h1")) @[Designs.scala 36:39]
      node _count_T_1 = tail(_count_T, 1) @[Designs.scala 36:39]
      count <= _count_T_1 @[Designs.scala 36:30]
    node _T_2 = eq(push, UInt<1>("h0")) @[Designs.scala 37:15]
    node _T_3 = and(pop, _T_2) @[Designs.scala 37:12]
    when _T_3 : @[Designs.scala 37:22]
      node _count_T_2 = sub(count, UInt<1>("h1")) @[Designs.scala 37:39]
      node _count_T_3 = tail(_count_T_2, 1) @[Designs.scala 37:39]
      count <= _count_T_3 @[Designs.scala 37:30]
    out <= storage[read] @[Designs.scala 38:7]
    node _full_T = eq(count, UInt<2>("h3")) @[Designs.scala 39:17]
    full <= _full_T @[Designs.scala 39:8]
    node _empty_T = eq(count, UInt<1>("h0")) @[Designs.scala 40:18]
    empty <= _empty_T @[Designs.scala 40:9]

