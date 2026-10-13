circuit RenamedAccumulator :
  module RenamedAccumulator :
    input clock : Clock
    input reset : UInt<1>
    input active : UInt<1>
    output result : UInt<9>

    reg storage : UInt<9>, clock with :
      reset => (reset, UInt<9>("h0")) @[Features.scala 11:24]
    when active : @[Features.scala 12:16]
      node _storage_T = add(storage, UInt<9>("h7")) @[Features.scala 12:37]
      node _storage_T_1 = tail(_storage_T, 1) @[Features.scala 12:37]
      storage <= _storage_T_1 @[Features.scala 12:26]
    result <= storage @[Features.scala 13:10]

