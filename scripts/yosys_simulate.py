"""Execute generated Lean FunctionalIR models, including array-valued memory state."""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path

from common import ROOT, lean_executable, run_logged


def experiment_initial(ir):
    """A disclosed experiment choice: unknown bits zero, known internal constraints retained."""
    return {f["name"]: f["initial"]["value"] if f["sort"]["kind"]=="bits" else
            [v["value"] for v in f["initial"]["words"]] for f in ir["states"]}


def simulate_yosys(ir_path, trace, initial, evidence):
    ir_path=ir_path.resolve();ir=json.loads(ir_path.read_text())
    if not trace: raise ValueError("Trace is empty")
    if set(initial)!={f["name"] for f in ir["states"]}: raise ValueError("Supply every state field explicitly")
    clock=ir["clock"]
    names={f["name"] for f in ir["inputs"]}-{clock}
    if any(set(row["inputs"])!=names for row in trace): raise ValueError("Inputs must match the model, except its clock supplied by the cycle driver")
    def decoder(name,typename,fields):
        lines=[f'def {name} (j : Lean.Json) : Except String {typename} := do']
        values=[]
        for i,f in enumerate(fields):
            key=json.dumps(f["name"]); t=f["sort"]
            if t["kind"]=="bits":
                lines.append(f'  let v{i} ← j.getObjValAs? Int {key}')
                v=f'BitVec.ofInt {t["width"]} v{i}'
            else:
                size=1<<t["address_width"]
                lines += [f'  let v{i} ← j.getObjValAs? (Array Int) {key}',
                          f'  if v{i}.size != {size} then throw "Memory initial state has wrong size"']
                v=f'(fun address => BitVec.ofInt {t["width"]} (v{i}[address.toNat]!))'
            values.append(f'{f["field"]} := {v}')
        record="{ "+", ".join(values)+" }" if values else "⟨⟩"
        return "\n".join(lines+[f'  return {record}'])
    def encode(fields,var):
        return "Lean.Json.mkObj ["+", ".join(f'({json.dumps(f["name"])}, Lean.toJson {var}.{f["field"]}.toNat)' for f in fields)+"]"
    clock_field=next((f["field"] for f in ir["inputs"] if f["name"]==clock),None)
    low="{ inputs with "+clock_field+" := 0 }" if clock else "inputs"
    high="{ inputs with "+clock_field+" := 1 }" if clock else "inputs"
    if clock:
        phases=f'''    let low := evaluate ({low}) state
    if !low.outputDefined || !low.transitionDefined then throw (IO.userError "Undefined low-clock operation")
    let high := evaluate ({high}) low.nextState
    if !high.outputDefined || !high.transitionDefined then throw (IO.userError "Undefined high-clock operation")
    let pre := low.outputs
    let post := high.outputs
    state := high.nextState'''
    else:
        phases='''    let r := evaluate inputs state
    if !r.outputDefined || !r.transitionDefined then throw (IO.userError "Undefined operation")
    let pre := r.outputs
    let post := r.outputs
    state := r.nextState'''
    code=f'''import {ir["namespace"]}
set_option linter.unusedVariables false
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open {ir["namespace"]}
{decoder("decodeInputs","Inputs",ir["inputs"])}
{decoder("decodeState","State",ir["states"])}
def encodeOutputs (o : Outputs) : Lean.Json := {encode(ir["outputs"],"o")}
def unwrap (r : Except String α) : IO α :=
  match r with
  | .ok x => pure x
  | .error e => throw (IO.userError e)
def main (args : List String) : IO Unit := do
  let [path] := args | throw (IO.userError "Supply request path")
  let j ← unwrap (Lean.Json.parse (← IO.FS.readFile path))
  let rows ← unwrap (j.getObjValAs? (Array Lean.Json) "trace")
  let mut state ← unwrap (decodeState (← unwrap (j.getObjVal? "initial")))
  if !initialValid state then throw (IO.userError "Initial state violates known-bit constraints")
  let mut cycle : Nat := 0
  for row in rows do
    let inputs ← unwrap (decodeInputs (← unwrap (row.getObjVal? "inputs")))
{phases}
    IO.println ((Lean.Json.mkObj [("cycle", Lean.toJson cycle),
      ("pre", encodeOutputs pre), ("post", encodeOutputs post)]).compress)
    cycle := cycle + 1
'''
    evidence.mkdir(parents=True,exist_ok=True)
    converted=[]
    for row in trace:
        values=dict(row["inputs"])
        if clock: values[clock]=0
        converted.append({"inputs":values})
    request=evidence/"request.json";request.write_text(json.dumps({"trace":converted,"initial":initial}),encoding="utf-8")
    source=evidence/"Run.lean";source.write_text(code,encoding="utf-8")
    root=ir_path
    for _ in ir["namespace"].split("."):root=root.parent
    env=os.environ.copy();env["LEAN_PATH"]=str(root)
    result=run_logged([lean_executable(),"--run",str(source.resolve()),str(request.resolve())],evidence/"execution",cwd=root,env=env,echo=False)
    rows=[] if result else [json.loads(line) for line in (evidence/"execution/stdout.log").read_text().splitlines() if line.strip()]
    if not result and len(rows)!=len(trace):raise RuntimeError("Incomplete Lean trace")
    (evidence/"result.json").write_text(json.dumps(rows,indent=2),encoding="utf-8")
    return result,rows


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("ir",type=Path)
    inputs=p.add_mutually_exclusive_group(required=True)
    inputs.add_argument("--trace",type=Path)
    inputs.add_argument("--request",type=Path,help="Previously saved request JSON containing trace and explicit initial state")
    initial=p.add_mutually_exclusive_group()
    initial.add_argument("--initial-state",help="JSON object; scalar registers and complete memory word arrays")
    initial.add_argument("--initial-file",type=Path,help="File containing the explicit initial state JSON object")
    p.add_argument("--evidence",type=Path,default=ROOT/"experiments/yosys-run")
    a=p.parse_args()
    if a.request:
        if a.initial_state or a.initial_file:p.error("A request already supplies the initial state")
        request=json.loads(a.request.read_text(encoding="utf-8"));trace=request["trace"];state=request["initial"]
        clock=json.loads(a.ir.read_text(encoding="utf-8"))["clock"]
        trace=[{"inputs":{n:v for n,v in r["inputs"].items() if n!=clock}} for r in trace]
    else:
        if a.initial_state is None and a.initial_file is None:p.error("Supply --initial-state or --initial-file with --trace")
        trace=json.loads(a.trace.read_text(encoding="utf-8"))
        state=json.loads(a.initial_file.read_text(encoding="utf-8") if a.initial_file else a.initial_state)
    code,_=simulate_yosys(a.ir,trace,state,a.evidence.resolve())
    return code


if __name__=="__main__":raise SystemExit(main())
