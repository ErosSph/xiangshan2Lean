"""Check modern-input rejection, pre-optimization effects and executable definedness."""
from __future__ import annotations

import json
from pathlib import Path
import re

from common import ROOT
from firrtl2lean import translate_firrtl
from firrtl_simulate import simulate_firrtl


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2), encoding="utf-8")


def main():
    evidence = ROOT / "experiments/modern-firrtl-contracts-7.3"
    evidence.mkdir(parents=True, exist_ok=True)
    translation_logs = evidence / "translations"
    translation_logs.mkdir(exist_ok=True)
    def circuit(name, body):
        return f"FIRRTL version 6.0.0\ncircuit {name} :\n  public module {name} :\n" + body
    fixtures = {
        "Memory": (circuit("Memory", '''    input clock : Clock
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
    connect m.r.clk, clock
    connect m.r.en, UInt<1>(1)
    connect m.r.addr, addr
    connect m.w.clk, clock
    connect m.w.en, UInt<1>(0)
    connect m.w.addr, addr
    connect m.w.data, UInt<8>(0)
    connect m.w.mask, UInt<1>(1)
    connect q, m.r.data
'''), "Memory ports/latencies"),
        "AsyncReset": (circuit("AsyncReset", '''    input clock : Clock
    input reset : AsyncReset
    output q : UInt<8>
    regreset r : UInt<8>, clock, reset, UInt<8>(0)
    connect r, UInt<8>(1)
    connect q, r
'''), "Asynchronous reset"),
        "MultiClock": (circuit("MultiClock", '''    input a : Clock
    input b : Clock
    output q : UInt<8>
    reg r : UInt<8>, a
    reg s : UInt<8>, b
    connect r, UInt<8>(1)
    connect s, r
    connect q, s
'''), "Multiple.*clock"),
        "GatedClock": (circuit("GatedClock", '''    input clock : Clock
    input en : UInt<1>
    output q : UInt<8>
    node gated = asClock(and(asUInt(clock), en))
    reg r : UInt<8>, gated
    connect r, UInt<8>(1)
    connect q, r
'''), "Unsupported operation|clock|Clock"),
        "DeadAssertion": (circuit("DeadAssertion", '''    input clock : Clock
    input en : UInt<1>
    output q : UInt<1>
    connect q, en
    assert(clock, UInt<1>(1), UInt<1>(0), "disabled assertion is still unsupported")
'''), "Unsupported verification"),
        "BlackBox": ('''FIRRTL version 6.0.0
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
''', "BlackBox/ExtModule"),
        "UnknownVersion": (circuit("UnknownVersion", "    output q : UInt<1>\n    connect q, UInt<1>(0)\n").replace("6.0.0", "99.0.0"), "version|Version"),
        "InvalidCharacter": (circuit("InvalidCharacter", "    output q : UInt<1>\n    connect q, UInt<1>(0) §\n"), "error"),
        "ConditionalInvalid": (circuit("ConditionalInvalid", '''    input en : UInt<1>
    input a : UInt<8>
    output q : UInt<8>
    wire w : UInt<8>
    invalidate w
    when en :
      connect w, a
    connect q, w
'''), "invalidvalue/DontCare")}
    results = []
    for name, (text, pattern) in fixtures.items():
        path = evidence / (name + ".fir")
        path.write_text(text, encoding="utf-8")
        before = set(translation_logs.iterdir())
        destination = evidence / "rejected" / name
        code = translate_firrtl(path, destination, frontend="circt", evidence=translation_logs)
        attempts = set(translation_logs.iterdir()) - before
        if not code or len(attempts) != 1 or list(destination.glob("**/*.lean")):
            raise RuntimeError("Unsupported modern fixture was published: " + name)
        log = next(iter(attempts))
        diagnostics = "\n".join(p.read_text(encoding="utf-8") for p in [log / "diagnostic.txt", *log.rglob("stderr.log")] if p.is_file())
        if not re.search(pattern, diagnostics):
            raise RuntimeError(f"Wrong modern diagnostic for {name}: {diagnostics}")
        results.append({"case": name, "rejected": True, "evidence": str(log)})
    source = evidence / "Division.fir"
    source.write_text(circuit("Division", '''    input en : UInt<1>
    input a : UInt<8>
    input b : UInt<8>
    output q : UInt<8>
    connect q, mux(en, div(a, b), UInt<8>(7))
'''), encoding="utf-8")
    if translate_firrtl(source, evidence / "Division", frontend="circt"):
        raise RuntimeError("Modern division translation failed")
    ir = evidence / "Division/FIRRTL/Division.ir.json"
    for label, inputs, expect_code in [("inactive-division", {"en": 0, "a": 19, "b": 0}, 0),
                                        ("active-division", {"en": 1, "a": 19, "b": 0}, 1),
                                        ("valid-division", {"en": 1, "a": 19, "b": 2}, 0)]:
        code, rows = simulate_firrtl(ir, [{"inputs": inputs}], {}, evidence / label)
        if bool(code) != bool(expect_code):
            raise RuntimeError("Wrong modern definedness behavior: " + label)
        if not code and rows[0]["post"]["q"] != (7 if inputs["en"] == 0 else 9):
            raise RuntimeError("Wrong modern division value")
        results.append({"case": label, "passed": True})
    constant = evidence / "ConstantDivision.fir"
    constant.write_text(circuit("ConstantDivision", '''    input a : UInt<8>
    output q : UInt<8>
    connect q, div(a, UInt<8>(0))
'''), encoding="utf-8")
    if translate_firrtl(constant, evidence / "ConstantDivision", frontend="circt", evidence=translation_logs):
        raise RuntimeError("Constant division translation failed")
    code, _ = simulate_firrtl(evidence / "ConstantDivision/FIRRTL/ConstantDivision.ir.json",
                              [{"inputs": {"a": 19}}], {}, evidence / "constant-division")
    if not code or "Undefined output operation" not in (evidence / "constant-division/execution/stderr.log").read_text(encoding="utf-8"):
        raise RuntimeError("Constant zero division was silently refined")
    results.append({"case": "constant-zero-division", "passed": True})
    summary = {"status": "PASS", "checks": len(results), "cases": results,
               "compiler_sha256": json.loads((evidence / "ConstantDivision/manifest.json").read_text(encoding="utf-8"))["compiler_sha256"],
               "unsupported_effects_rejected_before_optimization": True, "formal_translation_equivalence": False}
    write(evidence / "summary.json", summary)
    write(ROOT / "docs/validation-modern-firrtl-contracts-7.3.json", summary)
    print(json.dumps(summary, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
