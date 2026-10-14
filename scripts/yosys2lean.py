"""Convert fixed RTL through official Yosys FunctionalIR into executable Lean 4."""
from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import sys
import uuid

from bootstrap_yosys import INSTALL
from common import ROOT, lean_executable, run_logged
from functional_ir import emit_lean, import_functional, preflight


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2), encoding="utf-8")


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def translate_yosys(source: Path, output: Path, top: str, namespace="Yosys.Design", clock=None,
                    evidence: Path | None = None, check=True):
    source, output = source.resolve(), output.resolve()
    if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_$]*", top):
        raise ValueError("Top must be an ordinary Verilog module identifier")
    attempt = dt.datetime.now(dt.timezone.utc).strftime("%Y%m%dT%H%M%SZ")+"-"+uuid.uuid4().hex[:8]
    log = (evidence or ROOT / "experiments/yosys-translation").resolve()/attempt
    stage=log/"artifacts"; stage.mkdir(parents=True)
    shutil.copy2(source,stage/"design.v")
    runner=[sys.executable,str(ROOT/"scripts/yosys_runner.py"),"-Q","-T"]
    first=f'read_slang --threads 1 --no-proc --no-synthesis-define --no-default-translate-off-format /work/design.v --top {top}; hierarchy -check -top {top}; proc -noopt; flatten; opt_clean; memory_collect; write_json /work/before.json'
    if run_logged([*runner,"-p",first],log/"yosys-prepare",cwd=stage,echo=False):
        raise RuntimeError("Yosys RTL normalization failed; see "+str(log/"yosys-prepare"))
    data=json.loads((stage/"before.json").read_text())
    module=data["modules"][top]
    if clock is None:
        clock=next((n for n in ("clock","clk") if n in module["ports"] and module["ports"][n]["direction"]=="input"),None)
    hardware=preflight(module,clock)
    # Official lowering retains edge detection. Never silently abstract/gate a clock.
    second='read_json /work/before.json; clk2fflogic -nolower -nopeepopt; memory_nordff; opt_clean; setundef -undriven -anyseq; write_json /work/unconstrained.json'
    if run_logged([*runner,"-p",second],log/"yosys-functional",cwd=stage,echo=False):
        raise RuntimeError("Yosys FunctionalIR conversion failed; see "+str(log/"yosys-functional"))
    exposed=json.loads((stage/"unconstrained.json").read_text())
    lowered=exposed["modules"][top]
    arbitrary=[]
    for cell_name,cell in list(lowered["cells"].items()):
        if cell["type"]!="$anyseq":continue
        # Expose each official arbitrary-value driver as an ordinary input.
        # No value is assigned; callers must supply it on every global step.
        name="c2l_undefined_"+str(len(arbitrary))
        if name in lowered["ports"] or name in lowered["netnames"]:
            raise ValueError("Reserved arbitrary-input name collides with RTL: "+name)
        bits=cell["connections"]["Y"]
        lowered["ports"][name]={"direction":"input","bits":bits}
        lowered["netnames"][name]={"hide_name":0,"bits":bits,"attributes":cell["attributes"]}
        del lowered["cells"][cell_name]
        arbitrary.append({"name":name,"width":len(bits),"source":cell["attributes"].get("src",cell_name)})
    write(stage/"exposed.json",exposed)
    final='read_json /work/exposed.json; check -assert; write_json /work/lowered.json; write_functional_smt2 /work/functional.smt2'
    if run_logged([*runner,"-p",final],log/"yosys-export",cwd=stage,echo=False):
        raise RuntimeError("Yosys transfer export failed; see "+str(log/"yosys-export"))
    ir=import_functional((stage/"functional.smt2").read_text(),lowered,namespace,hardware["clock"])
    ir["hardware"]=hardware; ir["top"]=top
    ir["arbitrary_inputs"]=arbitrary
    relative=Path(*namespace.split("."))
    lean=stage/relative.with_suffix(".lean"); lean.parent.mkdir(parents=True,exist_ok=True)
    lean.write_text(emit_lean(ir),encoding="utf-8")
    ir_path=stage/relative.with_suffix(".ir.json"); write(ir_path,ir)
    if check:
        env=os.environ.copy();env["LEAN_PATH"]=str(stage)
        if run_logged([lean_executable(),"-o",str(lean.with_suffix(".olean")),str(lean)],log/"lean-check",cwd=stage,env=env,echo=False):
            raise RuntimeError("Generated Lean failed to compile; see "+str(log/"lean-check"))
    lock=json.loads((INSTALL/"chisel2lean-lock.json").read_text())
    manifest={"format":"chisel2lean-yosys-manifest-v1","frontend":"yosys-functional","symbolic_parameters":False,
              "source":str(source),"source_sha256":digest(source),"lean_version":"4.19.0","yosys_lock":lock,
              "namespace":namespace,"ir":relative.with_suffix(".ir.json").as_posix(),"lean":relative.with_suffix(".lean").as_posix(),"arbitrary_inputs":arbitrary,
              "lean_checked":check,"hardware":hardware,"nodes":len(ir["nodes"]),"evidence":str(log),
              "semantics":"Two-state completion, single positive-edge clock. clk2fflogic retains edges. Explicit initial state; unknown initial bits unconstrained. Data X/Z and undriven nets become explicit arbitrary inputs using setundef -anyseq. Reachable division by zero is rejected by execution domains. Not IEEE four-state simulation equivalence.",
              "reader_sha256":digest(ROOT/"scripts/functional_ir.py"),"driver_sha256":digest(Path(__file__)),
              "artifact_sha256":{p.relative_to(stage).as_posix():digest(p) for p in (stage/"before.json",stage/"exposed.json",stage/"lowered.json",stage/"functional.smt2",lean,ir_path)}}
    write(stage/"manifest.json",manifest)
    output.mkdir(parents=True,exist_ok=True)
    for p in stage.rglob("*"):
        if p.is_file():
            dest=output/p.relative_to(stage);dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,dest)
    print(f'Generated {namespace}: {len(ir["nodes"])} FunctionalIR nodes, {len(ir["states"])} state fields',flush=True)
    return ir_path.relative_to(stage)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source",type=Path)
    parser.add_argument("--top",required=True)
    parser.add_argument("--out",type=Path,default=ROOT/"generated/yosys")
    parser.add_argument("--namespace",default="Yosys.Design")
    parser.add_argument("--clock")
    parser.add_argument("--evidence",type=Path)
    parser.add_argument("--check",action=argparse.BooleanOptionalAction,default=True)
    args=parser.parse_args()
    translate_yosys(args.source,args.out,args.top,args.namespace,args.clock,args.evidence,args.check)
    return 0


if __name__=="__main__":
    try: raise SystemExit(main())
    except (RuntimeError,ValueError) as e:
        print(str(e),file=sys.stderr);raise SystemExit(2)
