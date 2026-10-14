FIRRTL version 6.0.0
circuit BlackBox :
  extmodule External :
    input x : UInt<1>
    output y : UInt<1>
    defname = External
  public module BlackBox :
    input x : UInt<1>
    output q : UInt<1>
    inst child of External
    connect child.x, x
    connect q, child.y
