FIRRTL version 6.0.0
circuit ConditionalInvalid :
  public module ConditionalInvalid :
    input en : UInt<1>
    input a : UInt<8>
    output q : UInt<8>
    wire w : UInt<8>
    invalidate w
    when en :
      connect w, a
    connect q, w
