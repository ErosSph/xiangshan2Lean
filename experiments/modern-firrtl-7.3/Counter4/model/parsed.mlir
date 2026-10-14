"builtin.module"() ({
  "firrtl.circuit"() <{annotations = [], name = "Chisel2LeanReference"}> ({
    "firrtl.layer"() <{convention = #firrtl<layerconvention bind>, sym_name = "Verification"}> ({
      "firrtl.layer"() <{convention = #firrtl<layerconvention bind>, sym_name = "Assert"}> ({
        "firrtl.layer"() <{convention = #firrtl<layerconvention inline>, sym_name = "Temporal"}> ({
        ^bb0:
        }) : () -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-7.3\\Counter4\\original\\design.fir":5:7)
      }) {output_file = #hw.output_file<"verification\FFsert\\">} : () -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-7.3\\Counter4\\original\\design.fir":4:5)
      "firrtl.layer"() <{convention = #firrtl<layerconvention bind>, sym_name = "Assume"}> ({
        "firrtl.layer"() <{convention = #firrtl<layerconvention inline>, sym_name = "Temporal"}> ({
        ^bb0:
        }) : () -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-7.3\\Counter4\\original\\design.fir":7:7)
      }) {output_file = #hw.output_file<"verification\FFsume\\">} : () -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-7.3\\Counter4\\original\\design.fir":6:5)
      "firrtl.layer"() <{convention = #firrtl<layerconvention bind>, sym_name = "Cover"}> ({
        "firrtl.layer"() <{convention = #firrtl<layerconvention inline>, sym_name = "Temporal"}> ({
        ^bb0:
        }) : () -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-7.3\\Counter4\\original\\design.fir":9:7)
      }) {output_file = #hw.output_file<"verification\FFver\\">} : () -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-7.3\\Counter4\\original\\design.fir":8:5)
    }) {output_file = #hw.output_file<"verification\\">} : () -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-7.3\\Counter4\\original\\design.fir":3:3)
    "firrtl.module"() <{annotations = [], convention = #firrtl<convention internal>, domainInfo = [], layers = [], portAnnotations = [], portDirections = array<i1: false, false, true>, portLocations = [loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":5:7), loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":5:7), loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":7:14)], portNames = ["clock", "reset", "io"], portSymbols = [], portTypes = [!firrtl.clock, !firrtl.reset, !firrtl.bundle<en flip: uint<1>, q: uint<4>>], sym_name = "Counter"}> ({
    ^bb0(%arg4: !firrtl.clock loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":5:7), %arg5: !firrtl.reset loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":5:7), %arg6: !firrtl.bundle<en flip: uint<1>, q: uint<4>> loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":7:14)):
      %4 = "firrtl.subfield"(%arg6) <{fieldIndex = 1 : i32}> : (!firrtl.bundle<en flip: uint<1>, q: uint<4>>) -> !firrtl.uint<4> loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":13:8)
      %5 = "firrtl.subfield"(%arg6) <{fieldIndex = 0 : i32}> : (!firrtl.bundle<en flip: uint<1>, q: uint<4>>) -> !firrtl.uint<1> loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":12:15)
      %6 = "firrtl.constant"() <{value = 0 : ui4}> : () -> !firrtl.const.uint<4> loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":11:20)
      %7 = "firrtl.regreset"(%arg4, %arg5, %6) <{annotations = [], name = "cnt", nameKind = #firrtl<name_kind interesting_name>}> : (!firrtl.clock, !firrtl.reset, !firrtl.const.uint<4>) -> !firrtl.uint<4> loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":11:20)
      %8 = "firrtl.constant"() <{value = 1 : ui1}> : () -> !firrtl.const.uint<1> loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":12:28)
      "firrtl.when"(%5) ({
        %9 = "firrtl.add"(%7, %8) : (!firrtl.uint<4>, !firrtl.const.uint<1>) -> !firrtl.uint<5> loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":12:28)
        %10 = "firrtl.node"(%9) <{annotations = [], name = "_cnt_T", nameKind = #firrtl<name_kind interesting_name>}> : (!firrtl.uint<5>) -> !firrtl.uint<5> loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":12:28)
        %11 = "firrtl.tail"(%10) <{amount = 1 : i32}> : (!firrtl.uint<5>) -> !firrtl.uint<4> loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":12:28)
        %12 = "firrtl.node"(%11) <{annotations = [], name = "_cnt_T_1", nameKind = #firrtl<name_kind interesting_name>}> : (!firrtl.uint<4>) -> !firrtl.uint<4> loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":12:28)
        "firrtl.matchingconnect"(%7, %12) : (!firrtl.uint<4>, !firrtl.uint<4>) -> () loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":12:21)
      }, {
      }) : (!firrtl.uint<1>) -> () loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":12:15)
      "firrtl.matchingconnect"(%4, %7) : (!firrtl.uint<4>, !firrtl.uint<4>) -> () loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":13:8)
    }) {sym_visibility = "private"} : () -> () loc("\\\\audit\\\\src\\\\main\\\\scala\\\\Probes.scala":5:7)
    "firrtl.module"() <{annotations = [], convention = #firrtl<convention scalarized>, domainInfo = [], layers = [], portAnnotations = [], portDirections = array<i1: false, false, false, true>, portLocations = [loc("\\\\reference\\\\src\\\\main\\\\scala\\\\GenerateRTL.scala":35:11), loc("\\\\reference\\\\src\\\\main\\\\scala\\\\GenerateRTL.scala":35:11), loc("\\\\reference\\\\src\\\\main\\\\scala\\\\GenerateRTL.scala":49:50), loc("\\\\reference\\\\src\\\\main\\\\scala\\\\GenerateRTL.scala":49:85)], portNames = ["clock", "reset", "c2l_port_0", "c2l_port_1"], portSymbols = [], portTypes = [!firrtl.clock, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<4>], sym_name = "Chisel2LeanReference"}> ({
    ^bb0(%arg0: !firrtl.clock loc("\\\\reference\\\\src\\\\main\\\\scala\\\\GenerateRTL.scala":35:11), %arg1: !firrtl.uint<1> loc("\\\\reference\\\\src\\\\main\\\\scala\\\\GenerateRTL.scala":35:11), %arg2: !firrtl.uint<1> loc("\\\\reference\\\\src\\\\main\\\\scala\\\\GenerateRTL.scala":49:50), %arg3: !firrtl.uint<4> loc("\\\\reference\\\\src\\\\main\\\\scala\\\\GenerateRTL.scala":49:85)):
      %0:3 = "firrtl.instance"() <{annotations = [], domainInfo = [[], [], []], layers = [], moduleName = @Counter, name = "Counter", nameKind = #firrtl<name_kind interesting_name>, portAnnotations = [[], [], []], portDirections = array<i1: false, false, true>, portNames = ["clock", "reset", "io"]}> : () -> (!firrtl.clock, !firrtl.reset, !firrtl.bundle<en flip: uint<1>, q: uint<4>>) loc("\\\\reference\\\\src\\\\main\\\\scala\\\\GenerateRTL.scala":37:24)
      %1 = "firrtl.subfield"(%0#2) <{fieldIndex = 1 : i32}> : (!firrtl.bundle<en flip: uint<1>, q: uint<4>>) -> !firrtl.uint<4> loc("\\\\reference\\\\src\\\\main\\\\scala\\\\GenerateRTL.scala":51:60)
      %2 = "firrtl.subfield"(%0#2) <{fieldIndex = 0 : i32}> : (!firrtl.bundle<en flip: uint<1>, q: uint<4>>) -> !firrtl.uint<1> loc("\\\\reference\\\\src\\\\main\\\\scala\\\\GenerateRTL.scala":51:42)
      "firrtl.matchingconnect"(%0#0, %arg0) : (!firrtl.clock, !firrtl.clock) -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-7.3\\Counter4\\original\\design.fir":31:5)
      %3 = "firrtl.resetCast"(%arg1) : (!firrtl.uint<1>) -> !firrtl.reset loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-7.3\\Counter4\\original\\design.fir":32:5)
      "firrtl.matchingconnect"(%0#1, %3) : (!firrtl.reset, !firrtl.reset) -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-7.3\\Counter4\\original\\design.fir":32:5)
      "firrtl.matchingconnect"(%2, %arg2) : (!firrtl.uint<1>, !firrtl.uint<1>) -> () loc("\\\\reference\\\\src\\\\main\\\\scala\\\\GenerateRTL.scala":51:42)
      "firrtl.matchingconnect"(%arg3, %1) : (!firrtl.uint<4>, !firrtl.uint<4>) -> () loc("\\\\reference\\\\src\\\\main\\\\scala\\\\GenerateRTL.scala":51:60)
    }) : () -> () loc("\\\\reference\\\\src\\\\main\\\\scala\\\\GenerateRTL.scala":35:11)
  }) : () -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-7.3\\Counter4\\original\\design.fir":2:1)
}) : () -> () loc("E:\\ICT\\chisel2lean4\\experiments\\modern-firrtl-7.3\\Counter4\\original\\design.fir":0:0)