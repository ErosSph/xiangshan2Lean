"""Execute a generated Lean model on a JSON input/reset trace."""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import sys
import uuid

from chisel2lean4._compat import enable_legacy_script_imports

enable_legacy_script_imports()
from common import ROOT, lean_executable, run_logged


def eval_param(expr: dict, values: dict):
    kind = expr["kind"]
    if kind == "int":
        return int(expr["value"])
    if kind == "bool":
        return expr["value"]
    if kind == "name":
        return values[expr["name"]]
    if kind == "forall":
        return all(eval_param(expr["condition"], values | {expr["index"]: i})
                   for i in range(max(0, eval_param(expr["size"], values))))
    args = [eval_param(a, values) for a in expr["args"]]
    if kind == "if":
        return args[1] if args[0] else args[2]
    op = expr["op"]
    functions = {"+": lambda a, b: a + b, "-": lambda a, b: a - b,
                 "/": lambda a, b: (abs(a) // abs(b)) * (-1 if (a < 0) != (b < 0) else 1),
                 "%": lambda a, b: a - (abs(a) // abs(b)) * (-1 if (a < 0) != (b < 0) else 1) * b,
                 "*": lambda a, b: a * b, "max": max, "min": min,
                 "neg": lambda a: -a, "!": lambda a: not a,
                 "<": lambda a, b: a < b, "<=": lambda a, b: a <= b,
                 ">": lambda a, b: a > b, ">=": lambda a, b: a >= b,
                 "==": lambda a, b: a == b, "!=": lambda a, b: a != b,
                 "&&": lambda a, b: a and b, "||": lambda a, b: a or b,
                 "log2Ceil": lambda a: (a - 1).bit_length() if a > 1 else 0,
                 "pow2": lambda a: 1 << max(0, a)}
    functions["unsignedWidth"] = lambda a: max(1, a.bit_length())
    functions["signedWidth"] = lambda a: (a if a >= 0 else -a - 1).bit_length() + 1
    functions["lookupComplete"] = lambda w, *keys: False if w < 0 or w > len(keys).bit_length() else len({k % (1 << w) for k in keys}) == 1 << w
    functions["fitsUnsigned"] = lambda a, b: a >= 0 and b >= 0 and a.bit_length() <= b
    functions["fitsSigned"] = lambda a, b: b >= 1 and ((a if a >= 0 else -a - 1).bit_length() + 1) <= b
    result = functions[op](*args)
    if expr.get("wrap32"):
        result = (result + (1 << 31)) % (1 << 32) - (1 << 31)
    return result


def lean_value(tpe: dict, value, parameters: dict) -> str:
    kind = tpe["kind"]
    if kind == "bool":
        if value not in (True, False, 0, 1):
            raise ValueError("Bool values must be true/false or 0/1")
        return "true" if value else "false"
    if kind == "bits":
        return f"(BitVec.ofInt _ ({int(value)} : Int))"
    if kind == "vec":
        size = eval_param(tpe["size"], parameters)
        if not isinstance(value, list) or len(value) != size:
            raise ValueError(f"Vec requires exactly {size} elements")
        cases = " ".join(f"| {i} => {lean_value(tpe['element'], v, parameters)}" for i, v in enumerate(value))
        # The wildcard is unreachable for a valid Fin index.
        return f"(fun j => match j.val with {cases} | _ => default)"
    raise ValueError(f"Unknown hardware type: {kind}")


def record(signals: list[dict], values: dict, parameters: dict) -> str:
    if not signals:
        return "⟨⟩"
    names = {s["name"] for s in signals}
    if set(values) != names:
        raise ValueError(f"Expected fields {sorted(names)}, got {sorted(values)}")
    return "{ " + ", ".join(f"{s['field']} := {lean_value(s['type'], values[s['name']], parameters)}" for s in signals) + " }"


def json_value(tpe: dict, expr: str, parameters: dict, depth=0) -> str:
    if tpe["kind"] == "bool":
        return f"Lean.toJson ({expr})"
    if tpe["kind"] == "bits":
        return f"Lean.toJson ({expr}).toNat"
    size = eval_param(tpe["size"], parameters)
    index = f"j{depth}"
    child = json_value(tpe["element"], f"({expr}) {index}", parameters, depth + 1)
    return f"Lean.Json.arr (((List.finRange {size}).map (fun {index} => {child})).toArray)"


def object_value(signals, name, parameters):
    fields = [f"({json.dumps(s['name'])}, {json_value(s['type'], name + '.' + s['field'], parameters)})" for s in signals]
    return "Lean.Json.mkObj [" + ", ".join(fields) + "]"


def simulate(ir_path: Path, parameters: dict, trace: list[dict], initial: dict | None,
             evidence: Path, allow_undefined_initial_output: bool = False) -> tuple[int, list[dict]]:
    ir = json.loads(ir_path.read_text(encoding="utf-8"))
    parameter_fields = ir["parameters"]
    if set(parameters) != {p["name"] for p in parameter_fields}:
        raise ValueError("Supply exactly the module's constructor parameters")
    for p in parameter_fields:
        required_type = int if p["kind"] == "Int" else bool
        if type(parameters[p["name"]]) is not required_type:
            raise ValueError(f"Parameter {p['name']} must have type {p['kind']}")
    if not all(eval_param(r, parameters) for r in ir["requirements"]):
        raise ValueError("Parameters violate the source/model legal domain")
    if not trace:
        raise ValueError("An input trace must have at least one cycle")
    inputs = [s for s in ir["signals"] if s["kind"] == "input"]
    outputs = [s for s in ir["signals"] if s["kind"] == "output"]
    registers = [s for s in ir["signals"] if s["kind"] == "reg"]
    pvalues = []
    for p in parameter_fields:
        value = ("true" if parameters[p["name"]] else "false") if p["kind"] == "Bool" else f"({int(parameters[p['name']])} : Int)"
        pvalues.append(f"{p['field']} := {value}")
    params_code = "{ " + ", ".join(pvalues) + " }" if pvalues else "⟨⟩"
    trace_code = ",\n  ".join(f"({record(inputs, entry['inputs'], parameters)}, {'true' if entry.get('reset', False) else 'false'})" for entry in trace)
    ns = ir["namespace"]
    checks = ir.get("definedness") == "executable-predicates"
    pre_check = f'if !outputDefined p inputs state && !(cycle == 0 && {str(allow_undefined_initial_output).lower()}) then throw (IO.userError "Undefined output operation in input trace")' if checks else ''
    step_check = 'if !transitionDefined p inputs state reset then throw (IO.userError "Undefined transition operation in input trace")' if checks else ''
    post_check = 'if !outputDefined p inputs next then throw (IO.userError "Undefined output operation after clock edge")' if checks else ''
    has_reset_state = len(ir["resets"]) == len(registers) and not any(
        reads_state(r["expression"]) for r in ir["resets"])
    if initial is None:
        if not has_reset_state:
            raise ValueError("This module has no complete reset state; supply --initial-state")
        initial_code = "resetState p first"
    else:
        initial_code = record(registers, initial, parameters)
    code = f"""import {ir['module']}
set_option linter.unusedVariables false
set_option maxRecDepth 20000
set_option maxHeartbeats 0
open {ns}
def p : Params := {params_code}
def inputsTrace : List (Inputs p × Bool) := [
  {trace_code}]
def outputsJson (o : Outputs p) : Lean.Json := {object_value(outputs, 'o', parameters)}
def stateJson (s : State p) : Lean.Json := {object_value(registers, 's', parameters)}
def main : IO Unit := do
  if !valid p then throw (IO.userError "Invalid source parameters")
  let first : Inputs p := {record(inputs, trace[0]['inputs'], parameters)}
  let mut state : State p := {initial_code}
  let mut cycle : Nat := 0
  for entry in inputsTrace do
    let (inputs, reset) := entry
    {pre_check}
    let pre := output p inputs state
    {step_check}
    let next := step p inputs state reset
    {post_check}
    let post := output p inputs next
    IO.println (Lean.Json.mkObj [("cycle", Lean.toJson cycle), ("pre", outputsJson pre),
      ("post", outputsJson post), ("state", stateJson next)]).compress
    state := next
    cycle := cycle + 1
"""
    evidence.mkdir(parents=True, exist_ok=True)
    harness = evidence / "Run.lean"
    harness.write_text(code, encoding="utf-8")
    (evidence / "request.json").write_text(json.dumps({"parameters": parameters, "trace": trace, "initial_state": initial}, indent=2), encoding="utf-8")
    root = ir_path.parents[len(ir["module"].split(".")) - 1]
    env = os.environ.copy()
    env["LEAN_PATH"] = str(root)
    result = run_logged([lean_executable(), "--run", str(harness)], evidence / "execution", cwd=root, env=env, echo=False)
    records = []
    if result == 0:
        for line in (evidence / "execution" / "stdout.log").read_text(encoding="utf-8").splitlines():
            if line.startswith("{"):
                value = json.loads(line)
                if "cycle" in value:
                    records.append(value)
        if len(records) != len(trace):
            raise RuntimeError("Lean execution did not return one result per cycle")
        (evidence / "result.json").write_text(json.dumps(records, indent=2), encoding="utf-8")
    return result, records


def reads_state(expression):
    return expression["kind"] == "reg" or any(reads_state(a) for a in expression["args"])


def parse_parameters(arguments):
    result = {}
    for argument in arguments:
        name, value = argument.split("=", 1)
        result[name] = value.lower() == "true" if value.lower() in {"true", "false"} else int(value)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("ir", type=Path)
    parser.add_argument("--params", nargs="*", default=[])
    parser.add_argument("--config-snapshot", type=Path, help="materialize_config.py output containing automatically mapped parameters")
    parser.add_argument("--trace", type=Path, required=True)
    parser.add_argument("--initial-state", type=Path)
    parser.add_argument("--warmup", action="store_true", help="allow an undefined output before the first edge; post-edge outputs must be defined")
    parser.add_argument("--evidence", type=Path)
    args = parser.parse_args()
    evidence = args.evidence or ROOT / "experiments" / "simulation" / uuid.uuid4().hex[:12]
    initial = json.loads(args.initial_state.read_text(encoding="utf-8")) if args.initial_state else None
    parameters = parse_parameters(args.params)
    if args.config_snapshot:
        if args.params:
            parser.error("Use either --params or --config-snapshot")
        snapshot = json.loads(args.config_snapshot.read_text(encoding="utf-8"))
        if snapshot["module"] != json.loads(args.ir.read_text(encoding="utf-8"))["module"]:
            parser.error("Configuration snapshot belongs to a different module")
        parameters = snapshot["parameters"]
    code, _ = simulate(args.ir.resolve(), parameters, json.loads(args.trace.read_text(encoding="utf-8")), initial, evidence.resolve(), args.warmup)
    print(f"Evidence: {evidence}")
    return code


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (ValueError, RuntimeError) as error:
        print(str(error), file=sys.stderr)
        raise SystemExit(2)
