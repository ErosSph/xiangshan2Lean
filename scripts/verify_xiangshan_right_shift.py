"""Check XiangShan's original right shifter against generated Lean and integer math."""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import random
import sys

from chisel2lean import translate
from common import ROOT, lean_executable, run_logged, sbt_command
from rtl import run_rtl
from simulate import object_value


CASE = ROOT / "verification" / "xiangshan" / "right-shift"
SOURCE = ROOT / "examples" / "xiangshan" / "RightShiftModule.scala"
MODULE = "xiangshan.backend.fu.RightShiftModule"
REFERENCE_MODULE = "xiangshan.validation.OriginalRightShiftReference"


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2), encoding="utf-8")


def original_class(source):
    start = source.index("class RightShiftModule(")
    end = source.index("\nclass RightShiftWordModule(", start)
    return source[start:end].rstrip() + "\n"


def verify_provenance():
    provenance = read_json(CASE / "SOURCE.json")
    upstream = CASE / "upstream" / "Alu.scala"
    if hashlib.sha256(upstream.read_bytes()).hexdigest() != provenance["upstream_sha256"]:
        raise RuntimeError("Pinned upstream source checksum changed")
    original = original_class(upstream.read_text(encoding="utf-8"))
    adapter = provenance["adaptation"]
    expected = original.replace(adapter["original_declaration"], adapter["standalone_declaration"], 1)
    standalone = SOURCE.read_text(encoding="utf-8")
    if standalone[standalone.index("class RightShiftModule("):].rstrip() + "\n" != expected:
        raise RuntimeError("Standalone hardware differs from the documented header-only adaptation")
    reference = (CASE / "reference" / "OriginalRightShiftModule.scala").read_text(encoding="utf-8")
    if reference[reference.index("class RightShiftModule("):].rstrip() + "\n" != original:
        raise RuntimeError("Reference class differs from the original XiangShan declaration")
    return provenance


def mathematical_outputs(width, inputs):
    """Unbounded integers and two's-complement decoding; no IR evaluation."""
    modulus = 1 << width
    mask = modulus - 1
    logical, arithmetic = inputs["io.srlSrc"], inputs["io.sraSrc"]
    amount, reverse = inputs["io.shamt"], inputs["io.revShamt"]
    if not 0 <= logical < modulus or not 0 <= arithmetic < modulus:
        raise ValueError("Data input does not fit XLEN")
    if not 0 <= amount < 64 or not 0 <= reverse < 64:
        raise ValueError("Shift amounts must fit the original six-bit ports")
    signed = arithmetic if arithmetic < (1 << (width - 1)) else arithmetic - modulus
    return {"io.srl": logical >> amount,
            "io.sra": (signed >> amount) & mask,
            "io.revSrl": logical >> reverse}


def entry(logical, arithmetic, amount, reverse, reset=False):
    return {"reset": reset, "inputs": {"io.srlSrc": logical, "io.sraSrc": arithmetic,
            "io.shamt": amount, "io.revShamt": reverse}}


def make_trace(width, random_cycles, seed):
    mask = (1 << width) - 1
    trace = []
    if width == 8:
        # Each output function sees every data value and every six-bit amount.
        # The odd multiplier permutes all 256 arithmetic-source bit patterns.
        for value in range(256):
            for amount in range(64):
                trace.append(entry(value, (197 * value + 17) & mask, amount, 63 - amount))
    else:
        patterns = {0, 1, 2, mask, mask - 1, 1 << (width - 1), (1 << (width - 1)) - 1,
                    int("aa" * ((width + 7) // 8), 16) & mask,
                    int("55" * ((width + 7) // 8), 16) & mask}
        patterns.update(1 << bit for bit in range(width))
        patterns.update(mask ^ (1 << bit) for bit in range(width))
        for value in sorted(patterns):
            for amount in range(64):
                trace.append(entry(value, mask ^ value, amount, 63 - amount))
    rng = random.Random(seed + width)
    for _ in range(random_cycles):
        trace.append(entry(rng.getrandbits(width), rng.getrandbits(width),
                           rng.randrange(64), rng.randrange(64), bool(rng.getrandbits(1))))
    return trace


class OutputMismatch(RuntimeError):
    pass


def run_lean_trace(ir_path, width, trace, evidence, parameters=None):
    """Load large corpora at runtime, then execute the actual generated model."""
    ir = read_json(ir_path)
    if any(s["kind"] == "reg" for s in ir["signals"]):
        raise RuntimeError("This harness expects the original stateless right-shift module")
    inputs = [s for s in ir["signals"] if s["kind"] == "input"]
    outputs = [s for s in ir["signals"] if s["kind"] == "output"]
    decode = []
    fields = []
    for index, signal in enumerate(inputs):
        if signal["type"]["kind"] != "bits":
            raise RuntimeError("Unexpected XiangShan input type")
        decode.append(f'  let value{index} ← j.getObjValAs? Nat {json.dumps(signal["name"])}')
        fields.append(f'{signal["field"]} := BitVec.ofNat _ value{index}')
    decoder = "\n".join(decode)
    record = "{ " + ", ".join(fields) + " }"
    parameters = parameters or {"XLEN": width}
    output_json = object_value(outputs, "o", parameters)
    parameter_code = ", ".join(f"{p['field']} := ({parameters[p['name']]} : Int)" for p in ir["parameters"])
    code = f'''import {ir["module"]}
set_option linter.unusedVariables false
set_option maxHeartbeats 0
open {ir["namespace"]}

def p : Params := {{ {parameter_code} }}
def decodeInputs (j : Lean.Json) : Except String (Inputs p) := do
{decoder}
  pure {record}
def checked {{α : Type}} (value : Except String α) : IO α :=
  match value with
  | .ok x => pure x
  | .error message => throw (IO.userError message)
def outputsJson (o : Outputs p) : Lean.Json := {output_json}
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let text ← IO.FS.readFile "trace.json"
  let json ← checked (Lean.Json.parse text)
  let entries ← checked json.getArr?
  let mut state : State p := ⟨⟩
  let mut cycle : Nat := 0
  for entry in entries do
    let data ← checked (entry.getObjVal? "inputs")
    let inputs ← checked (decodeInputs data)
    let reset ← checked (entry.getObjValAs? Bool "reset")
    if !outputDefined p inputs state || !transitionDefined p inputs state reset then
      throw (IO.userError "Undefined model operation")
    let pre := output p inputs state
    let next := step p inputs state reset
    if !outputDefined p inputs next then throw (IO.userError "Undefined next output")
    let post := output p inputs next
    IO.println (Lean.Json.mkObj [("cycle", Lean.toJson cycle),
      ("pre", outputsJson pre), ("post", outputsJson post),
      ("state", Lean.Json.mkObj [])]).compress
    state := next
    cycle := cycle + 1
'''
    evidence.mkdir(parents=True, exist_ok=True)
    write_json(evidence / "trace.json", trace)
    write_json(evidence / "request.json", {"parameters": parameters,
                                          "cycles": len(trace), "input_loading": "runtime JSON"})
    harness = evidence / "Run.lean"
    harness.write_text(code, encoding="utf-8")
    env = os.environ.copy()
    env["LEAN_PATH"] = str(ir_path.parents[len(ir["module"].split(".")) - 1])
    print(f"XLEN={width}: executing {len(trace)} inputs in Lean", flush=True)
    if result := run_logged([lean_executable(), "--run", str(harness)], evidence / "execution",
                            cwd=evidence, env=env, echo=False):
        raise RuntimeError(f"Lean execution failed; exit={result}")
    records = [json.loads(line) for line in (evidence / "execution/stdout.log").read_text(encoding="utf-8").splitlines()
               if line.startswith("{")]
    if len(records) != len(trace):
        raise RuntimeError("Lean did not execute the entire input corpus")
    write_json(evidence / "result.json", records)
    return records


def compare(width, trace, lean, rtl, evidence):
    if len(lean) != len(rtl) or len(lean) != len(trace):
        raise RuntimeError("Trace lengths differ")
    table = []
    outputs = ("io.srl", "io.sra", "io.revSrl")
    for cycle, (t, actual, reference) in enumerate(zip(trace, lean, rtl)):
        if actual["cycle"] != cycle or reference["cycle"] != cycle:
            raise RuntimeError("Cycle numbering differs")
        expected = mathematical_outputs(width, t["inputs"])
        for sampling in ("pre", "post"):
            if actual[sampling] != expected or reference[sampling] != expected:
                mismatch = {"cycle": cycle, "sampling": sampling, "inputs": t["inputs"],
                            "expected": expected, "lean": actual[sampling], "rtl": reference[sampling]}
                write_json(evidence / "mismatch.json", mismatch)
                raise OutputMismatch(json.dumps(mismatch))
        table.append({"cycle": cycle, **t["inputs"],
                      **{"expected:" + name: expected[name] for name in outputs},
                      **{"lean:" + name: actual["post"][name] for name in outputs},
                      **{"rtl:" + name: reference["post"][name] for name in outputs}})
    with (evidence / "comparison.csv").open("w", encoding="utf-8", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(table[0]))
        writer.writeheader()
        writer.writerows(table)
    return {"status": "PASS", "parameters": {"XLEN": width}, "cycles": len(trace),
            "compared_output_values": len(trace) * 6,
            "actual_processor_configuration": width == 64,
            "coverage": "each output function exhaustive over 8-bit data and 6-bit amount; plus uncorrelated random inputs"
                        if width == 8 else "corner patterns, walking ones/zeros, every 6-bit amount, uncorrelated random inputs",
            "comparison": "integer specification == executed Lean == original-class official RTL"}


def verify_case(ir_path, descriptor, width, trace, evidence):
    write_json(evidence / "trace.json", trace)
    lean = run_lean_trace(ir_path, width, trace, evidence / "lean")
    print(f"XLEN={width}: compiling and executing original XiangShan RTL", flush=True)
    code, rtl = run_rtl(descriptor, {"XLEN": width}, trace, evidence / "reference")
    if code:
        raise RuntimeError(f"Original-class RTL failed; exit={code}")
    result = compare(width, trace, lean, rtl, evidence)
    write_json(evidence / "summary.json", result)
    return result


def negative_control(descriptor, evidence):
    """Remove the signed cast in an isolated source; original RTL must disagree."""
    source = SOURCE.read_text(encoding="utf-8")
    old = "(io.sraSrc.asSInt >> io.shamt).asUInt"
    if source.count(old) != 1:
        raise RuntimeError("Expected one arithmetic-shift connection to mutate")
    faulty = source.replace("class RightShiftModule(", "class FaultyRightShiftModule(", 1)
    faulty = faulty.replace(old, "io.sraSrc >> io.shamt", 1)
    path = evidence / "FaultyRightShiftModule.scala"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(faulty, encoding="utf-8")
    generated = evidence / "generated"
    module = "xiangshan.backend.fu.FaultyRightShiftModule"
    if translate([path], generated, module, None, True):
        raise RuntimeError("Faulty source translation failed")
    fault_ir = generated / "xiangshan/backend/fu/FaultyRightShiftModule.ir.json"
    trace = [entry(0, 1 << 63, 1, 63)]
    try:
        verify_case(fault_ir, descriptor, 64, trace, evidence / "comparison")
    except OutputMismatch:
        mismatch = read_json(evidence / "comparison/mismatch.json")
        if mismatch["rtl"] != mismatch["expected"] or mismatch["lean"]["io.sra"] == mismatch["expected"]["io.sra"]:
            raise RuntimeError("Negative control failed for an unexpected reason")
        result = {"status": "PASS", "fault": "arithmetic right shift replaced by logical right shift",
                  "detected": True, "observed": mismatch}
        write_json(evidence / "summary.json", result)
        return result
    raise RuntimeError("Negative-control mismatch was not detected")


def check_model_proof(generated, evidence):
    source = CASE / "RightShiftProof.lean"
    env = os.environ.copy()
    env["LEAN_PATH"] = str(generated)
    if result := run_logged([lean_executable(), str(source)], evidence, env=env, echo=False):
        raise RuntimeError(f"Generic Lean model proof failed; exit={result}")
    proof = {"status": "PASS", "theorems": 3,
             "scope": "generated model equals standard BitVec logical/arithmetic shifts for every model width and input",
             "source_to_model_formal_equivalence_proof": False,
             "proof_sha256": hashlib.sha256(source.read_bytes()).hexdigest()}
    write_json(evidence / "summary.json", proof)
    return proof


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--widths", nargs="+", type=int, default=[8, 32, 64])
    parser.add_argument("--random-cycles", type=int, default=512)
    parser.add_argument("--seed", type=int, default=20261013)
    parser.add_argument("--evidence", type=Path, default=ROOT / "experiments/xiangshan-right-shift")
    args = parser.parse_args()
    if not args.widths or any(w <= 0 for w in args.widths) or args.random_cycles < 0:
        parser.error("Widths must be positive; random cycles must be nonnegative")
    evidence = args.evidence.resolve()
    evidence.mkdir(parents=True, exist_ok=True)
    results = []
    try:
        provenance = verify_provenance()
        sources = [CASE / "reference" / "OriginalRightShiftModule.scala", CASE / "reference" / "Framework.scala"]
        addition = ", ".join("file(" + json.dumps(s.as_posix()) + ")" for s in sources)
        command, env = sbt_command(["set reference / Compile / unmanagedSources ++= Seq(" + addition + ")",
                                    "reference/writeReferenceClasspath"])
        if run_logged(command, evidence / "reference-build", env=env, echo=False):
            raise RuntimeError("Original XiangShan class compilation failed")
        generated = ROOT / "generated" / "xiangshan-right-shift"
        if translate([SOURCE], generated, MODULE, None, True):
            raise RuntimeError("Source-to-Lean translation failed")
        proof = check_model_proof(generated, evidence / "model-proof")
        ir_path = generated / "xiangshan/backend/fu/RightShiftModule.ir.json"
        # RTL consumes only this interface descriptor. It executes the original
        # class and framework wrapper, never the generated Lean/semantic IR.
        descriptor = evidence / "reference-interface.json"
        write_json(descriptor, {"module": REFERENCE_MODULE,
                               "parameters": [{"name": "XLEN", "kind": "Int"}]})
        for width in args.widths:
            trace = make_trace(width, args.random_cycles, args.seed)
            result = verify_case(ir_path, descriptor, width, trace, evidence / f"XLEN-{width}")
            results.append(result)
            print(f"XLEN={width}: PASS ({len(trace)} cycles)", flush=True)
        negative = negative_control(descriptor, evidence / "negative-control")
        summary = {"status": "PASS", "module": MODULE, "source": provenance,
                   "cases": results, "configurations": len(results),
                   "cycles": sum(r["cycles"] for r in results),
                   "compared_output_values": sum(r["compared_output_values"] for r in results),
                   "all_six_bit_shift_amounts_checked": True, "negative_control": negative,
                   "generated_model_specification_proof": proof,
                   "formal_equivalence_proof": False,
                   "scope": "original right-shift hardware body with isolated width/configuration framework; not whole XiangShan ALU/core"}
        write_json(evidence / "summary.json", summary)
        print(json.dumps({k: summary[k] for k in ("status", "module", "configurations", "cycles", "compared_output_values")}, indent=2))
        print("Evidence: " + str(evidence), flush=True)
        return 0
    except (RuntimeError, ValueError) as error:
        write_json(evidence / "summary.json", {"status": "FAIL", "cases": results, "error": str(error)})
        print("FAIL: " + str(error) + "\nEvidence: " + str(evidence), flush=True)
        return 1


if __name__ == "__main__":
    # Current toolchain uses the actual framework. Retain the earlier isolated
    # experiment's helpers and evidence without rebuilding its replacement p.
    from verify_xiangshan_config import main as real_framework_main
    raise SystemExit(real_framework_main())
