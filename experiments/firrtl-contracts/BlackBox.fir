circuit BlackBox :
  extmodule External :
    defname = External
  module BlackBox :
    output q : UInt<1>
    inst ext of External
    q <= UInt<1>(0)
