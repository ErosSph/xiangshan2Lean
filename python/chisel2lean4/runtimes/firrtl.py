"""Execute a FIRRTL-generated scalar Lean model; initial state is always explicit.

Loads traces at runtime so large corpora do not become giant Lean list literals.
FIRRTL reset ports are supplied in inputs, as declared in the model's manifest.
"""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import sys

from chisel2lean4._compat import enable_legacy_script_imports

enable_legacy_script_imports()
from common import ROOT, lean_executable, run_logged
from simulate import object_value


def simulate_firrtl(ir_path: Path, trace: list[dict], initial: dict,
                    evidence: Path, warmup: bool = False) -> tuple[int, list[dict]]:
    ir_path = ir_path.resolve()
    ir = json.loads(ir_path.read_text(encoding="utf-8"))
    if ir.get("frontend") != "firrtl" or ir["parameters"]:
        raise ValueError("Expected a fixed-configuration FIRRTL model")
    inputs = [s for s in ir["signals"] if s["kind"] == "input"]
    outputs = [s for s in ir["signals"] if s["kind"] == "output"]
    registers = [s for s in ir["signals"] if s["kind"] == "reg"]
    if not trace:
        raise ValueError("Trace must not be empty")
    if set(initial) != {s["name"] for s in registers}:
        raise ValueError("Supply all FIRRTL state fields explicitly; use {} for a combinational circuit")
    for entry in trace:
        if set(entry["inputs"]) != {s["name"] for s in inputs}:
            raise ValueError("Trace input fields must match the FIRRTL interface, including reset ports")
    def decoder(name, typename, sigs):
        lines = []
        fields = []
        for idx, s in enumerate(sigs):
            if s["type"]["kind"] != "bits":
                raise ValueError("This driver requires scalar integer fields after official aggregate lowering")
            lines.append(f'  let v{idx} ← j.getObjValAs? Int {json.dumps(s["name"])}')
            fields.append(f'{s["field"]} := BitVec.ofInt _ v{idx}')
        record = "{ " + ", ".join(fields) + " }" if fields else "⟨⟩"
        return f'def {name} (j : Lean.Json) : Except String ({typename} p) := do\n' + "\n".join(lines) + f'\n  return {record}\n'
    ns = ir["namespace"]
    code = f'''import {ir["module"]}
set_option linter.unusedVariables false
set_option maxRecDepth 10000
set_option maxHeartbeats 0
open {ns}
def p : Params := ⟨⟩
{decoder("decodeInputs", "Inputs", inputs)}
{decoder("decodeState", "State", registers)}
def outputJson (o : Outputs p) : Lean.Json := {object_value(outputs, "o", {})}
def stateJson (s : State p) : Lean.Json := {object_value(registers, "s", {})}
def unwrap (r : Except String α) : IO α :=
  match r with
  | .ok x => pure x
  | .error e => throw (IO.userError e)
def main (args : List String) : IO Unit := do
  let path ← match args with
    | [path] => pure path
    | _ => throw (IO.userError "Supply one request JSON path")
  let j ← unwrap (Lean.Json.parse (← IO.FS.readFile path))
  let rows ← unwrap (j.getObjValAs? (Array Lean.Json) "trace")
  let initial ← unwrap (j.getObjVal? "initial")
  let mut state ← unwrap (decodeState initial)
  let mut cycle : Nat := 0
  for row in rows do
    let values ← unwrap (row.getObjVal? "inputs")
    let inputs ← unwrap (decodeInputs values)
    if !outputDefined p inputs state && !(cycle == 0 && {str(warmup).lower()}) then
      throw (IO.userError "Undefined output operation")
    if !transitionDefined p inputs state then
      throw (IO.userError "Undefined transition operation")
    let pre := output p inputs state
    let next := step p inputs state
    if !outputDefined p inputs next then
      throw (IO.userError "Undefined output operation after edge")
    IO.println ((Lean.Json.mkObj [("cycle", Lean.toJson cycle),
      ("pre", outputJson pre), ("post", outputJson (output p inputs next)),
      ("state", stateJson next)]).compress)
    state := next
    cycle := cycle + 1
'''
    evidence.mkdir(parents=True, exist_ok=True)
    request = evidence / "request.json"
    request.write_text(json.dumps({"trace": trace, "initial": initial}), encoding="utf-8")
    source = evidence / "Run.lean"
    source.write_text(code, encoding="utf-8")
    root = ir_path
    for _ in ir["module"].split("."):
        root = root.parent
    env = os.environ.copy()
    env["LEAN_PATH"] = str(root)
    code = run_logged([lean_executable(), "--run", str(source.resolve()), str(request.resolve())],
                      evidence / "execution", cwd=root, env=env, echo=False)
    rows = [] if code else [json.loads(line) for line in (evidence / "execution" / "stdout.log").read_text(encoding="utf-8").splitlines() if line.strip()]
    if not code and len(rows) != len(trace):
        raise RuntimeError("Lean returned an incomplete trace")
    (evidence / "result.json").write_text(json.dumps(rows, indent=2), encoding="utf-8")
    return code, rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("ir", type=Path)
    parser.add_argument("--trace", required=True, type=Path)
    parser.add_argument("--initial-state", required=True, help="JSON object, e.g. {} or {\"cnt\":0}")
    parser.add_argument("--evidence", type=Path, default=ROOT / "experiments" / "firrtl-run")
    parser.add_argument("--warmup", action="store_true")
    args = parser.parse_args()
    trace = json.loads(args.trace.read_text(encoding="utf-8"))
    code, rows = simulate_firrtl(args.ir, trace, json.loads(args.initial_state), args.evidence.resolve(), args.warmup)
    if not code:
        print(f"Executed {len(rows)} cycles; evidence: {args.evidence}")
    return code


if __name__ == "__main__":
    raise SystemExit(main())
