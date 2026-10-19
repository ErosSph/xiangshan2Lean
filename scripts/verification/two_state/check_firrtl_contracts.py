"""Check unsupported hardware diagnostics, undefined division, and a Lean mutant."""
from pathlib import Path as _BootstrapPath
import sys as _bootstrap_sys

if "__file__" in globals():
    _BOOTSTRAP_FILE = _BootstrapPath(__file__).resolve()
    _SCRIPTS_ROOT = next((parent for parent in _BOOTSTRAP_FILE.parents if parent.name == "scripts"), None)
    if _SCRIPTS_ROOT is None:
        raise RuntimeError("categorized script must be under scripts/")
    _PROJECT_ROOT = _SCRIPTS_ROOT.parent
    for _entry in (_SCRIPTS_ROOT, _BOOTSTRAP_FILE.parent):
        if str(_entry) not in _bootstrap_sys.path:
            _bootstrap_sys.path.insert(0, str(_entry))
else:
    _BOOTSTRAP_FILE = None
    _SCRIPTS_ROOT = None
    _PROJECT_ROOT = None

import json
import os
from pathlib import Path
import re
import shutil

from chisel2lean import check_lean
from common import ROOT
from firrtl2lean import translate_firrtl
from firrtl_simulate import simulate_firrtl


if __name__ == "__main__":
    evidence = ROOT / "experiments" / "firrtl-contracts"
    evidence.mkdir(parents=True, exist_ok=True)
    translation_logs = evidence / "translations"
    translation_logs.mkdir(exist_ok=True)
    fixtures = {
        "Memory": ('''circuit Memory :
  module Memory :
    input clock : Clock
    input addr : UInt<2>
    output q : UInt<8>
    mem m :
      data-type => UInt<8>
      depth => 4
      read-latency => 0
      write-latency => 1
      reader => r
      writer => w
      read-under-write => undefined
    m.r.clk <= clock
    m.r.en <= UInt<1>(1)
    m.r.addr <= addr
    m.w.clk <= clock
    m.w.en <= UInt<1>(0)
    m.w.addr <= addr
    m.w.data <= UInt<8>(0)
    m.w.mask <= UInt<1>(1)
    q <= m.r.data
''', "Memory ports"),
        "InvalidCharacter": ('''circuit InvalidCharacter :
  module InvalidCharacter :
    output q : UInt<1>
    q <= UInt<1>(0) §
''', "lexical error"),
        "AsyncReset": ('''circuit AsyncReset :
  module AsyncReset :
    input clock : Clock
    input reset : AsyncReset
    output q : UInt<8>
    reg r : UInt<8>, clock with :
      reset => (reset, UInt<8>(0))
    r <= UInt<8>(1)
    q <= r
''', "[Aa]synchronous|AsyncReset"),
        "MultiClock": ('''circuit MultiClock :
  module MultiClock :
    input a : Clock
    input b : Clock
    output q : UInt<8>
    reg r : UInt<8>, a
    reg s : UInt<8>, b
    r <= UInt<8>(1)
    s <= r
    q <= s
''', "Multiple.*clock"),
        "BlackBox": ('''circuit BlackBox :
  extmodule External :
    defname = External
  module BlackBox :
    output q : UInt<1>
    inst ext of External
    q <= UInt<1>(0)
''', "BlackBox|ExtModule"),
        "ClockGate": ('''circuit ClockGate :
  module ClockGate :
    input clock : Clock
    input en : UInt<1>
    output q : UInt<8>
    node gated = asClock(and(asUInt(clock), en))
    reg r : UInt<8>, gated
    r <= UInt<8>(1)
    q <= r
''', "scalar reference|clock"),
        "Assertion": ('''circuit Assertion :
  module Assertion :
    input clock : Clock
    input en : UInt<1>
    output q : UInt<1>
    q <= en
    assert(clock, en, UInt<1>(1), "contract")
''', "Unsupported statement.*assert"),
        "ModernVersion": ('''FIRRTL version 6.0.0
circuit ModernVersion :
  module ModernVersion :
    output q : UInt<1>
    q <= UInt<1>(0)
''', "version|Version")}
    results = []
    for name, (text, diagnostic) in fixtures.items():
        source = evidence / (name + ".fir")
        source.write_text(text, encoding="utf-8")
        before = set(translation_logs.iterdir())
        code = translate_firrtl(source, evidence / name, frontend="classic", evidence=translation_logs)
        attempts = set(translation_logs.iterdir()) - before
        if code == 0 or len(attempts) != 1:
            raise RuntimeError("Unsupported fixture unexpectedly translated: " + name)
        stderr = (next(iter(attempts)) / "compiler/stderr.log").read_text(encoding="utf-8")
        if not re.search(diagnostic, stderr):
            raise RuntimeError(f"Wrong diagnostic for {name}: {stderr}")
        results.append({"case": name, "rejected": True, "diagnostic": stderr.strip()})
    division = evidence / "division.fir"
    division.write_text('''circuit Division :
  module Division :
    input a : UInt<8>
    input b : UInt<8>
    output q : UInt<8>
    q <= div(a, b)
''')
    if translate_firrtl(division, evidence / "division"):
        raise RuntimeError("Division fixture conversion failed")
    code, _ = simulate_firrtl(evidence / "division/FIRRTL/Division.ir.json",
                             [{"inputs": {"a": 7, "b": 0}}], {}, evidence / "undefined-division")
    if not code or "Undefined output operation" not in (evidence / "undefined-division/execution/stderr.log").read_text():
        raise RuntimeError("Undefined division was accepted")
    validif = evidence / "validif.fir"
    validif.write_text('''circuit ConditionalValue :
  module ConditionalValue :
    input en : UInt<1>
    input a : UInt<8>
    output q : UInt<8>
    q <= validif(en, a)
''')
    if translate_firrtl(validif, evidence / "validif"):
        raise RuntimeError("validif conversion failed")
    code, _ = simulate_firrtl(evidence / "validif/FIRRTL/ConditionalValue.ir.json",
                             [{"inputs": {"en": 0, "a": 7}}], {}, evidence / "undefined-validif")
    if not code or "Undefined output operation" not in (evidence / "undefined-validif/execution/stderr.log").read_text():
        raise RuntimeError("False validif condition was accepted")
    production = ROOT / "examples/firrtl/PrimitiveWidths.fir"
    if translate_firrtl(production, evidence / "production"):
        raise RuntimeError("Primitive fixture conversion failed")
    mutant = evidence / "mutant"
    shutil.copytree(evidence / "production", mutant, dirs_exist_ok=True)
    lean = mutant / "FIRRTL/PrimitiveWidths.lean"
    text, count = re.subn(r'(negSigned := )[^,\n}]+', r'\1(BitVec.ofNat 4 0)', lean.read_text(encoding="utf-8"), count=1)
    if count != 1:
        raise RuntimeError("Mutation target not found")
    lean.write_text(text, encoding="utf-8")
    if check_lean(mutant, evidence / "mutant-check"):
        raise RuntimeError("The mutant must type-check to test behavioral detection")
    code, rows = simulate_firrtl(mutant / "FIRRTL/PrimitiveWidths.ir.json",
        [{"inputs": {"u": 1, "s": 4, "t": 20, "amount": 0}}], {}, evidence / "mutant-run")
    if code or rows[0]["post"]["negSigned"] == 4:
        raise RuntimeError("Mutant was not detected")
    summary = {"passed": True, "rejections": results, "undefined_division_rejected": True, "false_validif_rejected": True,
               "negative_control": {"detected": True, "fault": "replace signed negation output with zero",
                                    "expected": 4, "mutant_actual": rows[0]["post"]["negSigned"],
                                    "production_unchanged": True}}
    (evidence / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    (ROOT / "docs/validation-firrtl-contracts.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print(json.dumps({k: v for k, v in summary.items() if k != "rejections"}, indent=2))
