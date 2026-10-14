"builtin.module"() ({
  "firrtl.circuit"() <{annotations = [], name = "UnknownVersion"}> ({
    "firrtl.module"() <{annotations = [], convention = #firrtl<convention scalarized>, domainInfo = [], layers = [], portAnnotations = [], portDirections = array<i1: true>, portLocations = [loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-contracts-7.3\\UnknownVersion.fir":4:12)], portNames = ["q"], portSymbols = [], portTypes = [!firrtl.uint<1>], sym_name = "UnknownVersion"}> ({
    ^bb0(%arg0: !firrtl.uint<1> loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-contracts-7.3\\UnknownVersion.fir":4:12)):
      %0 = "firrtl.constant"() <{value = 0 : ui1}> : () -> !firrtl.const.uint<1> loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-contracts-7.3\\UnknownVersion.fir":5:16)
      %1 = "firrtl.constCast"(%0) : (!firrtl.const.uint<1>) -> !firrtl.uint<1> loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-contracts-7.3\\UnknownVersion.fir":5:5)
      "firrtl.matchingconnect"(%arg0, %1) : (!firrtl.uint<1>, !firrtl.uint<1>) -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-contracts-7.3\\UnknownVersion.fir":5:5)
    }) : () -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-contracts-7.3\\UnknownVersion.fir":3:10)
  }) : () -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-contracts-7.3\\UnknownVersion.fir":2:1)
}) : () -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-contracts-7.3\\UnknownVersion.fir":0:0)