"""Check the model equivalence bridge proofs with freshly generated models."""
import json
import os
from chisel2lean import translate
from common import ROOT, lean_executable, run_logged
from firrtl2lean import translate_firrtl

if __name__ == "__main__":
    source_out = ROOT / "generated" / "firrtl-bridge-source"
    fixed_out = ROOT / "generated" / "firrtl-bridge-fixed"
    for source, module in [(ROOT / "audit/src/main/scala/Probes.scala", "probes.Counter"),
                           (ROOT / "examples/xiangshan/RightShiftModule.scala", "xiangshan.backend.fu.RightShiftModule")]:
        if translate([source], source_out, module, None, True):
            raise SystemExit("Source route failed")
    sources = [ROOT / "examples/firrtl/Counter4.fir",
               ROOT / "verification/firrtl/OriginalRightShiftReference.fir"]
    original = ROOT / "verification/xiangshan/firrtl/RightShiftModule.fir"
    if original.is_file():
        sources.append(original)
    for source in sources:
        if translate_firrtl(source, fixed_out):
            raise SystemExit("FIRRTL route failed")
    env = os.environ.copy()
    env["LEAN_PATH"] = os.pathsep.join(map(str, [source_out, fixed_out]))
    evidence = ROOT / "experiments" / "firrtl-proofs"
    names = ["CounterBridge", "RightShiftBridge"] + (["RightShiftOriginalBridge"] if original.is_file() else [])
    for name in names:
        if run_logged([lean_executable(), str(ROOT / "verification/firrtl" / (name + ".lean"))], evidence / name, env=env):
            raise SystemExit("Bridge proof failed: " + name)
    summary = {"passed": True, "lean_version": "4.19.0", "proofs": [
        {"file": "verification/firrtl/CounterBridge.lean", "configuration": {"n": 4},
         "scope": "all initial states, all enable/reset inputs, all finite sequence lengths"},
        {"file": "verification/firrtl/RightShiftBridge.lean", "configuration": {"XLEN": 64},
         "scope": "all source bit patterns, all six-bit shift amounts, both reset values"}],
        "general_compiler_correctness_proved": False,
        "full_xiangshan_framework_in_this_right_shift_fixture": False}
    if original.is_file():
        summary["proofs"].append({"file": "verification/firrtl/RightShiftOriginalBridge.lean", "configuration": {"XLEN": 64},
                                  "full_xiangshan_framework": True, "release": "v2.1",
                                  "scope": "all source bit patterns, all six-bit shift amounts, both reset values"})
    (evidence / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    (ROOT / "docs" / "validation-firrtl-bridges.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
