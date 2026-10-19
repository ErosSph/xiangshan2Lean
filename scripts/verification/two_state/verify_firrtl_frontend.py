"""Compare the FIRRTL frontend with original Chisel-source Lean and original RTL.

Replays archived, successful independent RTL experiments and records every input
and before/after-edge comparison. Handwritten primitive cases get fresh official
FIRRTL -> Verilog -> Verilator execution plus an independent integer specification.
"""
from __future__ import annotations
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


import argparse
import hashlib
import json
from pathlib import Path
import sys

from common import ROOT, java_executable, run_logged, sbt_command
from differential import flat_outputs
from firrtl2lean import translate_firrtl
from firrtl_simulate import simulate_firrtl
from rtl import get_value, run_emitted_rtl


def read(path):
    return json.loads(path.read_text(encoding="utf-8"))


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2), encoding="utf-8")


def zero_state(ir):
    # An explicit experiment condition, not hardware initialization semantics.
    return {s["name"]: 0 for s in ir["signals"] if s["kind"] == "reg"}


def replay(case_dir, destination):
    request = read(case_dir / "lean" / "request.json")
    original_lean = read(case_dir / "lean" / "result.json")
    reference = read(case_dir / "reference" / "result.json")
    ports = read(case_dir / "reference" / "rtl" / "ports.json")
    source = case_dir / "reference" / "rtl" / (ports["top"] + ".fir")
    if code := translate_firrtl(source, destination / "model"):
        raise RuntimeError(f"FIRRTL translation failed in {case_dir}: {code}")
    ir_path = destination / "model" / "FIRRTL" / (ports["top"] + ".ir.json")
    ir = read(ir_path)
    interface = {s["name"]: s for s in ir["signals"] if s["kind"] in {"input", "output"}}
    mapping = {p["name"]: p["rtl_name"] for p in ports["ports"] if p["name"] != "clock"}
    for p in ports["ports"]:
        if p["name"] == "clock":
            continue
        if p["rtl_name"] not in interface:
            raise RuntimeError("Cannot map original interface " + p["name"])
    trace = []
    for entry in request["trace"]:
        values = {}
        for p in ports["ports"]:
            if p["direction"] != "input" or p["name"] == "clock":
                continue
            value = entry.get("reset", False) if p["name"] == "reset" else get_value(entry["inputs"], p["name"])
            values[p["rtl_name"]] = int(value)
        trace.append({"inputs": values})
    code, actual = simulate_firrtl(ir_path, trace, zero_state(ir), destination / "execution")
    if code:
        raise RuntimeError(f"Lean execution failed: {destination}")
    if not len(actual) == len(reference) == len(original_lean):
        raise RuntimeError("Incomplete comparison corpus")
    checked = 0
    stateful = any(s["kind"] == "reg" for s in ir["signals"])
    for index, (a, r, l) in enumerate(zip(actual, reference, original_lean)):
        for sampling in ["pre", "post"]:
            if stateful and index == 0 and sampling == "pre":
                continue
            expected = flat_outputs(r[sampling])
            old = flat_outputs(l[sampling])
            for name, value in expected.items():
                if int(a[sampling][mapping[name]]) != int(value) or int(old[name]) != int(value):
                    raise RuntimeError(f"Three-way mismatch {case_dir.name}, cycle {index}, {sampling}:{name}")
                checked += 1
    result = {"case": case_dir.name, "source_evidence": str(case_dir), "passed": True,
              "firrtl_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
              "cycles": len(actual), "output_comparisons": checked,
              "initial_state": zero_state(ir), "comparison": "FIRRTL Lean == source Lean == archived original RTL",
              "interface_mapping": mapping}
    write(destination / "summary.json", result)
    print(f"PASS {case_dir.name}: {len(actual)} cycles, {checked} comparisons", flush=True)
    return result


def primitives(destination):
    source = ROOT / "examples" / "firrtl" / "PrimitiveWidths.fir"
    if translate_firrtl(source, destination / "model"):
        raise RuntimeError("Primitive-width translation failed")
    ir_path = destination / "model" / "FIRRTL" / "PrimitiveWidths.ir.json"
    # Exhaust the complete 15-bit input space, including unequal-width signed operands.
    trace = [{"inputs": {"u": u, "s": s, "t": t, "amount": amount}}
             for u in range(8) for s in range(8) for t in range(32) for amount in range(16)]
    code, lean = simulate_firrtl(ir_path, trace, {}, destination / "lean")
    if code:
        raise RuntimeError("Primitive-width Lean execution failed")
    directory = destination / "reference" / "rtl"
    classpath = (ROOT / ".cache" / "firrtl-classpath.txt").read_text().strip()
    if run_logged([java_executable(), "-cp", classpath, "chicala.lean.firrtl.FirrtlReference", str(source), str(directory)],
                  destination / "reference" / "compiler", echo=False):
        raise RuntimeError("Official FIRRTL reference generation failed")
    code, rtl = run_emitted_rtl(directory, read(directory / "ports.json"), trace, destination / "reference")
    if code:
        raise RuntimeError("Primitive-width Verilator execution failed")
    def signed(v, w):
        return v if v < 1 << (w - 1) else v - (1 << w)
    checked = 0
    for entry, actual, reference in zip(trace, lean, rtl):
        u, s, t, amount = (entry["inputs"][k] for k in ["u", "s", "t", "amount"])
        expected = {"addCarry": (u + 1) % 16, "subBorrow": (u - 1) % 16,
                    "negUnsigned": (-u) % 16, "negSigned": (-signed(s, 3)) % 16,
                    "cvtUnsigned": u, "signedAnd": (signed(s, 3) & signed(t, 5)) % 32,
                    "signedNot": (~s) % 8, "arithmeticShift": (signed(s, 3) >> amount) % 8,
                    "logicalOvershift": 0}
        for sampling in ["pre", "post"]:
            if actual[sampling] != expected or reference[sampling] != expected:
                raise RuntimeError(f"Primitive semantics mismatch: {entry}, {actual}, {reference}, {expected}")
            checked += len(expected)
    result = {"case": "PrimitiveWidths", "passed": True, "cycles": len(trace), "output_comparisons": checked,
              "exhaustive_input_bits": 15,
              "comparison": "FIRRTL Lean == fresh official RTL == independent integer specification"}
    write(destination / "summary.json", result)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rebuild", action="store_true")
    parser.add_argument("--resume", action="store_true")
    parser.add_argument("--evidence", type=Path, default=ROOT / "experiments" / "firrtl-validation")
    args = parser.parse_args()
    if args.rebuild:
        command, env = sbt_command(["classicFirrtl/writeFirrtlClasspath"])
        if code := run_logged(command, args.evidence / "build", env=env):
            return code
    requested = {
        "Counter-n1", "Counter-n4", "Counter-n9", "DualRegister-n3", "Priority-n3",
        "SignedArithmetic-w4", "SignedArithmetic-w65", "ConditionalPriority-w3", "HierarchicalPipeline-w8",
        "HierarchicalComb-w3", "NestedHierarchy-w5", "ResetFromInput-w3", "PartialReset-w3",
        "VectorReset-n3-w4", "RegisterFile-n8-w7", "Fifo-depth2-w3",
        "Arithmetic-aWidth65-bWidth7", "ExtendedBits-w128-shift3", "SignedDivision-w8",
        "RegisterIdioms-w3", "SwitchMachine-w5", "BundlePipeline-w8", "RenamedAccumulator-width3-increment3"}
    cases = []
    for request in sorted((ROOT / "experiments").glob("differential-v0.2-*/*/lean/request.json")):
        case = request.parent.parent
        if case.name in requested:
            cases.append(case)
    if not cases:
        raise RuntimeError("Original differential evidence is unavailable; run scripts/verification/two_state/validate.py first")
    results = []
    compiler = Path((ROOT / ".cache" / "firrtl-classpath.txt").read_text().strip().split(";" if sys.platform == "win32" else ":")[0])
    compiler_sha = hashlib.sha256(compiler.read_bytes()).hexdigest()
    for case in cases:
        destination = args.evidence / case.name
        cached = destination / "summary.json"
        manifest = destination / "model" / "manifest.json"
        if args.resume and cached.is_file() and manifest.is_file() and read(manifest)["compiler_sha256"] == compiler_sha:
            old = read(cached)
            if hashlib.sha256(Path(read(manifest)["source"]).read_bytes()).hexdigest() == old["firrtl_sha256"]:
                results.append(old)
                continue
        results.append(replay(case, destination))
    results.append(primitives(args.evidence / "PrimitiveWidths"))
    summary = {"passed": True, "firrtl_version": "1.5.6", "lean_version": "4.19.0", "cases": results,
               "configurations": len(results), "cycles": sum(x["cycles"] for x in results),
               "output_comparisons": sum(x["output_comparisons"] for x in results),
               "formal_translation_equivalence": False}
    write(args.evidence / "summary.json", summary)
    write(ROOT / "docs" / "validation-firrtl.json", summary)
    print(json.dumps({k: v for k, v in summary.items() if k != "cases"}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
