"""Verify a new Chisel example against mathematical expectations and official RTL."""
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
import csv
import hashlib
import json
from pathlib import Path
import random

from chisel2lean import translate
from common import ROOT, run_logged, sbt_command
from rtl import run_rtl
from simulate import simulate


SOURCE = ROOT / "examples" / "SaturatingAccumulator.scala"
MODULE = "walkthrough.SaturatingAccumulator"
DIRECTED = ROOT / "examples" / "saturating-accumulator-trace.json"
GOLDEN = ROOT / "examples" / "saturating-accumulator-expected.json"


class OutputMismatch(RuntimeError):
    """A completed execution disagreed with the independent specification."""


def read_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2), encoding="utf-8")


def mathematical_spec(width: int, trace: list[dict]) -> list[dict]:
    """Use unbounded integer arithmetic; do not read IR or generated Lean."""
    if not trace or not trace[0].get("reset", False):
        raise ValueError("The first cycle must establish a state through reset")
    maximum = (1 << width) - 1
    value, overflow = 0, False
    result = []
    for cycle, entry in enumerate(trace):
        inputs = entry["inputs"]
        if not 0 <= inputs["data"] <= maximum:
            raise ValueError("Input data does not fit the selected width")
        before = {"value": value, "overflow": overflow}
        if entry.get("reset", False) or inputs["clear"]:
            value, overflow = 0, False
        elif inputs["en"]:
            total = value + inputs["data"]
            overflow = overflow or total > maximum
            value = min(total, maximum)
        after = {"value": value, "overflow": overflow}
        result.append({"cycle": cycle, "pre": before, "post": after,
                       "state": {"acc": value, "seenOverflow": overflow}})
    return result


def make_trace(width: int, random_cycles: int, seed: int) -> list[dict]:
    maximum = (1 << width) - 1
    trace = read_json(DIRECTED)
    # The published directed values are for w=4; clamp them for w=1.
    # At other widths the reset -> maximum -> +0 -> +1 sequence also
    # reaches the exact limit and crosses it.
    for entry in trace:
        entry["inputs"]["data"] = min(entry["inputs"]["data"], maximum)
    trace[11]["inputs"]["data"] = maximum
    trace[12]["inputs"]["data"] = maximum
    rng = random.Random(seed + width)
    for cycle in range(random_cycles):
        data = rng.randrange(maximum + 1)
        if cycle % 16 == 0:
            data = maximum
        elif cycle % 16 == 1:
            data = 0
        trace.append({"reset": cycle == random_cycles // 2,
                      "inputs": {"en": bool(rng.getrandbits(1)),
                                 "clear": rng.randrange(10) == 0, "data": data}})
    return trace


def normal_outputs(value: dict) -> dict:
    if set(value) != {"value", "overflow"}:
        raise RuntimeError("Unexpected output interface: " + repr(value))
    if value["overflow"] not in (False, True, 0, 1):
        raise RuntimeError("Overflow is not a Bool value")
    return {"value": int(value["value"]), "overflow": bool(value["overflow"])}


def verify_case(ir_path: Path, width: int, trace: list[dict], evidence: Path) -> dict:
    expected = mathematical_spec(width, trace)
    write_json(evidence / "expected.json", expected)
    code, lean = simulate(ir_path, {"w": width}, trace, None, evidence / "lean")
    if code:
        raise RuntimeError(f"Lean execution failed with exit code {code}")
    code, rtl = run_rtl(ir_path, {"w": width}, trace, evidence / "reference")
    if code:
        raise RuntimeError(f"Official RTL execution failed with exit code {code}")
    if len(lean) != len(rtl) or len(lean) != len(expected):
        raise RuntimeError("Trace lengths differ")
    compared = 0
    display = []
    for cycle, (spec, actual, reference) in enumerate(zip(expected, lean, rtl)):
        if spec["cycle"] != actual["cycle"] or spec["cycle"] != reference["cycle"]:
            raise RuntimeError("Cycle numbering differs")
        for sampling in ("pre", "post"):
            if cycle == 0 and sampling == "pre":
                continue  # The first reset edge establishes RTL's state.
            a = normal_outputs(actual[sampling])
            b = normal_outputs(reference[sampling])
            if spec[sampling] != a or spec[sampling] != b:
                mismatch = {"cycle": cycle, "sampling": sampling,
                            "expected": spec[sampling], "lean": a, "rtl": b}
                write_json(evidence / "mismatch.json", mismatch)
                raise OutputMismatch("Output mismatch: " + json.dumps(mismatch))
            compared += 2
        if actual["state"] != spec["state"]:
            raise RuntimeError(f"Lean state differs from the specification at cycle {cycle}")
        inputs = trace[cycle]["inputs"]
        display.append({"cycle": cycle, "reset": int(trace[cycle].get("reset", False)),
                        "en": int(inputs["en"]), "clear": int(inputs["clear"]),
                        "data": inputs["data"], "expected_value": spec["post"]["value"],
                        "expected_overflow": int(spec["post"]["overflow"]),
                        "lean_value": actual["post"]["value"],
                        "lean_overflow": int(actual["post"]["overflow"]),
                        "rtl_value": reference["post"]["value"],
                        "rtl_overflow": int(reference["post"]["overflow"])})
    with (evidence / "comparison.csv").open("w", encoding="utf-8", newline="") as output:
        writer = csv.DictWriter(output, fieldnames=list(display[0]))
        writer.writeheader()
        writer.writerows(display)
    result = {"status": "PASS", "parameters": {"w": width}, "cycles": len(trace),
              "compared_output_values": compared,
              "comparison": "mathematical expectation == executed Lean == official RTL",
              "initial_sampling": "post first reset edge; subsequent pre and post edges"}
    write_json(evidence / "summary.json", result)
    return result


def verify_negative_control(evidence: Path) -> dict:
    """Both implementations of a deliberately faulty source should fail the spec."""
    original = SOURCE.read_text(encoding="utf-8")
    if original.count("seenOverflow := true.B") != 1:
        raise RuntimeError("Expected exactly one overflow-setting connection to mutate")
    faulty = original.replace("class SaturatingAccumulator", "class FaultySaturatingAccumulator", 1)
    faulty = faulty.replace("seenOverflow := true.B", "seenOverflow := false.B", 1)
    evidence.mkdir(parents=True, exist_ok=True)
    source = evidence / "FaultySaturatingAccumulator.scala"
    source.write_text(faulty, encoding="utf-8")
    command, env = sbt_command([
        f"set reference / Compile / unmanagedSources ++= Seq(file({json.dumps(SOURCE.as_posix())}), file({json.dumps(source.as_posix())}))",
        "reference/writeReferenceClasspath"])
    if run_logged(command, evidence / "reference-build", env=env, echo=False):
        raise RuntimeError("Negative-control official source compilation failed")
    generated = evidence / "generated"
    module = "walkthrough.FaultySaturatingAccumulator"
    if translate([source], generated, module, None, True):
        raise RuntimeError("Negative-control translation/type checking failed")
    ir = generated / "walkthrough" / "FaultySaturatingAccumulator.ir.json"
    try:
        verify_case(ir, 4, read_json(DIRECTED), evidence / "comparison")
    except OutputMismatch:
        mismatch = read_json(evidence / "comparison" / "mismatch.json")
        if mismatch["lean"] != mismatch["rtl"] or mismatch["lean"] == mismatch["expected"]:
            raise RuntimeError("The negative control did not produce the intended three-way result")
        result = {"status": "PASS", "mutation": "overflow flag deliberately never set",
                  "isolated_source_copy": True, "observed_verification": "FAIL",
                  "lean_matches_rtl": True, "specification_mismatch_detected": True,
                  "first_mismatch": mismatch}
        write_json(evidence / "summary.json", result)
        return result
    raise RuntimeError("The deliberately faulty design unexpectedly satisfied the specification")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--widths", type=int, nargs="+", default=[1, 4, 8])
    parser.add_argument("--random-cycles", type=int, default=200)
    parser.add_argument("--seed", type=int, default=20261013)
    parser.add_argument("--negative-control", action="store_true",
                        help="also verify that a faulty isolated source fails even when Lean agrees with RTL")
    parser.add_argument("--evidence", type=Path, default=ROOT / "experiments" / "saturating-demo")
    args = parser.parse_args()
    if any(w <= 0 for w in args.widths) or args.random_cycles < 0:
        parser.error("Widths must be positive and random cycle count nonnegative")
    evidence = args.evidence.resolve()
    summary = {"status": "RUNNING", "module": MODULE,
               "source_sha256": hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
               "seed": args.seed, "cases": [], "formal_equivalence_proof": False}
    write_json(evidence / "summary.json", summary)
    try:
        # A hand-written table is a second check on the independent executable spec.
        directed_expected = [r["post"] for r in mathematical_spec(4, read_json(DIRECTED))]
        if directed_expected != read_json(GOLDEN):
            raise RuntimeError("The mathematical specification disagrees with the directed expected table")
        summary["directed_expected_table_checked"] = True

        # Compile this exact fresh source with the official Chisel plugin. This
        # temporary sbt setting is scoped to this run; build.sbt is not modified.
        source_literal = json.dumps(SOURCE.as_posix())
        command, env = sbt_command([
            f"set reference / Compile / unmanagedSources += file({source_literal})",
            "reference/writeReferenceClasspath"])
        print("Building the official-Chisel reference from the new source...", flush=True)
        if run_logged(command, evidence / "reference-build", env=env, echo=False):
            raise RuntimeError("Official source compilation failed; see reference-build logs")

        generated = ROOT / "generated" / "saturating-demo"
        print("Translating the new source and checking generated Lean...", flush=True)
        if translate([SOURCE], generated, MODULE, None, True):
            raise RuntimeError("Chisel-to-Lean translation/type checking failed")
        ir_path = generated / "walkthrough" / "SaturatingAccumulator.ir.json"
        manifest = read_json(generated / "manifest.json")
        summary["lean_checked"] = manifest["lean_checked"]
        summary["compiler_sha256"] = manifest["compiler_sha256"]
        for width in args.widths:
            print(f"Checking w={width}: directed cases plus {args.random_cycles} random cycles...", flush=True)
            result = verify_case(ir_path, width, make_trace(width, args.random_cycles, args.seed),
                                 evidence / f"w{width}")
            summary["cases"].append(result)
            print(f"w={width}: PASS ({result['cycles']} cycles)", flush=True)
        if args.negative_control:
            print("Checking an isolated faulty design against the specification...", flush=True)
            summary["negative_control"] = verify_negative_control(evidence / "negative-control")
            print("Negative control: PASS (faulty Lean and RTL agree; independent expectation rejects both)", flush=True)
        summary.update(status="PASS", configurations=len(summary["cases"]),
                       cycles=sum(c["cycles"] for c in summary["cases"]),
                       compared_output_values=sum(c["compared_output_values"] for c in summary["cases"]))
        write_json(evidence / "summary.json", summary)
        print(json.dumps(summary, indent=2))
        print(f"Evidence: {evidence}")
        return 0
    except Exception as error:
        summary.update(status="FAIL", error=str(error))
        write_json(evidence / "summary.json", summary)
        print(f"FAIL: {error}\nEvidence: {evidence}", flush=True)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
