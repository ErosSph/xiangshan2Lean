"""Fresh official Chisel RTL / Yosys-to-Lean / FIRRTL-to-Lean comparison campaign."""
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
import random

from common import ROOT, run_logged, sbt_command
from elaborate_chisel import elaborate
from firrtl2lean import translate_firrtl
from firrtl_simulate import simulate_firrtl
from rtl import get_value, run_emitted_rtl
from verify_modern_firrtl import alu, counters, handshake, prefetch, signed_arithmetic
from yosys2lean import translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def read(path):
    return json.loads(path.read_text(encoding="utf-8"))


def queue(entries):
    rng=random.Random(62000+entries)
    def trace(_):
        rows=[]
        for i in range(640):
            rows.append({"reset":i%157==0,"inputs":{"io.in.valid":int(i>0 and (i%32<20 if i<160 else rng.randrange(2))),
                "io.in.bits":rng.randrange(256),"io.out.ready":int(i%32>=12) if i<160 else rng.randrange(2)}})
        return rows
    def spec(rows,_):
        fifo=[];results=[]
        def observe():
            r={"io.in.ready":int(len(fifo)<entries),"io.out.valid":int(bool(fifo)),"io.count":len(fifo)}
            if fifo:r["io.out.bits"]=fifo[0]
            return r
        for row in rows:
            pre=observe();v=row["inputs"]
            enq=pre["io.in.ready"] and v["io.in.valid"]
            deq=pre["io.out.valid"] and v["io.out.ready"]
            if deq:fifo.pop(0)
            if enq:fifo.append(v["io.in.bits"])
            if row["reset"]:fifo=[]
            results.append({"pre":pre,"post":observe()})
        return results
    return trace,spec


def run_case(name,module,constructor,cp,evidence,make_trace,specification,cross=True):
    folder=evidence/name; original=folder/"original"; model=folder/"model"
    provenance=elaborate(module,constructor,cp,original,folder/"elaboration")
    metadata=read(original/"ports.json")
    relative=translate_yosys(original/(metadata["top"]+".v"),model,metadata["top"],"Yosys."+name,evidence=folder/"translation")
    ir_path=model/relative;ir=read(ir_path)
    trace=make_trace(metadata);write(folder/"trace.json",trace)
    mapping={p["name"]:p["rtl_name"] for p in metadata["ports"]}
    converted=[]
    for row in trace:
        values={p["rtl_name"]:int(0 if p["name"]=="clock" else row.get("reset",False) if p["name"]=="reset" else get_value(row["inputs"],p["name"]))
                for p in metadata["ports"] if p["direction"]=="input" and p["rtl_name"]!=ir["clock"]}
        values.update({p["name"]:0 for p in ir["arbitrary_inputs"]})
        converted.append({"inputs":values})
    initial=experiment_initial(ir)
    code,lean=simulate_yosys(ir_path,converted,initial,folder/"lean")
    if code:raise RuntimeError("Lean execution failed: "+name+"; "+str(folder/"lean/execution"))
    code,rtl=run_emitted_rtl(original,metadata,trace,folder/"reference")
    if code:raise RuntimeError("Official RTL execution failed: "+name)
    integer=specification(trace,metadata)
    comparisons=checks=0
    for i,(actual,expected,spec) in enumerate(zip(lean,rtl,integer)):
        for phase in ("pre","post"):
            mapped={n:actual[phase][mapping[n]] for n in expected[phase]}
            if mapped!=expected[phase] or any(mapped[n]!=v for n,v in spec[phase].items()):
                write(folder/"mismatch.json",{"cycle":i,"phase":phase,"trace":trace[i],"lean":mapped,"rtl":expected[phase],"integer":spec[phase]})
                raise RuntimeError("Differential mismatch: "+name)
            comparisons+=len(mapped);checks+=len(spec[phase])
    if len(lean)!=len(trace) or len(rtl)!=len(trace) or len(integer)!=len(trace):raise RuntimeError("Incomplete trace")
    cross_comparisons=0
    if cross:
        other=folder/"firrtl-model"
        if translate_firrtl(original/"design.fir",other,namespace="Cross."+name,frontend="circt",evidence=folder/"firrtl-translation"):
            raise RuntimeError("FIRRTL cross conversion failed")
        other_ir=other/"Cross"/(name+".ir.json"); f=read(other_ir)
        expected_names={s["name"] for s in f["signals"] if s["kind"]=="input"}
        rows=[{"inputs":{n:v for n,v in row["inputs"].items() if n in expected_names}} for row in converted]
        initial_f={s["name"]:0 for s in f["signals"] if s["kind"]=="reg"}
        code,result=simulate_firrtl(other_ir,rows,initial_f,folder/"firrtl-lean")
        if code:raise RuntimeError("FIRRTL cross execution failed")
        for i,(y,f) in enumerate(zip(lean,result)):
            for phase in ("pre","post"):
                if y[phase]!=f[phase]:raise RuntimeError(f"Yosys/FIRRTL mismatch: {name} {i} {phase}")
                cross_comparisons+=len(y[phase])
    summary={"status":"PASS","case":name,"module":module,"constructor":constructor,"cycles":len(trace),
             "output_comparisons":comparisons,"independent_integer_checks":checks,"firrtl_cross_comparisons":cross_comparisons,
             "nodes":len(ir["nodes"]),"state_fields":len(ir["states"]),"hardware":ir["hardware"],
             "initial_state":initial,"experiment_contract":"Unknown initial bits and explicit arbitrary inputs zero in this experiment; known Yosys auxiliary constraints retained. RTL --x-initial 0/--x-assign 0. No hardware power-on claim.",
             "official_elaboration":provenance,"manifest":read(model/"manifest.json"),"formal_translation_equivalence":False}
    write(folder/"summary.json",summary)
    print(f'PASS {name}: {comparisons} RTL output comparisons, {cross_comparisons} FIRRTL cross comparisons',flush=True)
    return summary


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument("--case",action="append");p.add_argument("--skip-build",action="store_true")
    p.add_argument("--evidence",type=Path,default=ROOT/"experiments/yosys-7.3")
    args=p.parse_args();evidence=args.evidence.resolve()
    if not args.skip_build:
        command,env=sbt_command(["reference/writeReferenceClasspath","classicFirrtl/writeFirrtlClasspath","xiangshanFramework/writeXiangshanClasspath"])
        if code:=run_logged(command,evidence/"build",env=env):return code
    reference=ROOT/".cache/reference-classpath.txt";xs=ROOT/".cache/xiangshan-classpath.txt"
    upstream=ROOT/".cache/xiangshan-dependencies-7.3/xiangshan/src/main/scala/xiangshan"
    cfg=[{"class":"xiangshan.validation.NanhuCoreConfig","args":[]}]
    definitions=[("Counter4","probes.Counter",[4],reference,counters(4),True),
                 ("Handshake65x3","modernfixtures.HandshakeTop",[65,3],reference,handshake(65,3),True),
                 ("Signed65","probes.SignedArithmetic",[65],reference,signed_arithmetic(65),True),
                 ("XSAlu","xiangshan.backend.fu.AluDataModule",cfg,xs,alu(upstream),True),
                 ("XSPrefetch","xiangshan.cache.mmu.L2TlbPrefetch",cfg,xs,prefetch(),True),
                 ("Queue3","modernfixtures.QueueTop",[8,3,False],reference,queue(3),False),
                 ("SyncQueue3","modernfixtures.QueueTop",[8,3,True],reference,queue(3),False)]
    results=[]
    for name,module,constructor,cp,pair,cross in definitions:
        if args.case and name not in args.case:continue
        results.append(run_case(name,module,constructor,cp,evidence,*pair,cross))
    if not results:raise ValueError("No matching case")
    summary={"status":"PASS","complete_suite":not bool(args.case),"chisel_version":"7.3.0","lean_version":"4.19.0",
             "configurations":len(results),"cycles":sum(r["cycles"] for r in results),
             "output_comparisons":sum(r["output_comparisons"] for r in results),
             "independent_integer_checks":sum(r["independent_integer_checks"] for r in results),
             "firrtl_cross_comparisons":sum(r["firrtl_cross_comparisons"] for r in results),"cases":results}
    write(evidence/"summary.json",summary)
    if summary["complete_suite"]:write(ROOT/"docs/validation-yosys-7.3.json",summary)
    print(json.dumps({k:v for k,v in summary.items() if k!="cases"},indent=2))
    return 0


if __name__=="__main__":raise SystemExit(main())
