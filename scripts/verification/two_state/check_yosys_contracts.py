"""Execute boundary checks and a semantic mutation against the new RTL route."""
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


import json
from pathlib import Path
import random

from common import ROOT, lean_executable, run_logged
from functional_ir import emit_lean
from rtl import run_emitted_rtl
from yosys2lean import translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def main():
    base=ROOT/"experiments/yosys-contracts";results=[]
    rejected={
        "AsyncReset":'module T(input clock, reset, d, output reg q); always @(posedge clock or posedge reset) if(reset) q<=0; else q<=d; endmodule',
        "TwoClocks":'module T(input clock, clock2, d, output reg q, r); always @(posedge clock) q<=d; always @(posedge clock2) r<=d; endmodule',
        "GatedClock":'module T(input clock, en, d, output reg q); wire g=clock&en; always @(posedge g) q<=d; endmodule',
        "NegativeEdge":'module T(input clock, d, output reg q); always @(negedge clock) q<=d; endmodule',
        "Latch":'module T(input en, d, output reg q); always_latch if(en) q<=d; endmodule',
        "Assertion":'module T(input clock, d, output q); assign q=d; always @(posedge clock) assert(d); endmodule',
        "BlackBox":'module T(input d, output q); Unknown u(.d(d),.q(q)); endmodule',
        "MemoryOffset":'module T(input clock, en, input [2:0] a, input [7:0] d, output [7:0] q); reg [7:0] m[1:4]; always @(posedge clock) if(en) m[a]<=d; assign q=m[a]; endmodule',
        "SingleWordMemory":'module T(input clock, en, input [7:0] d, output [7:0] q); reg [7:0] m[0:0]; always @(posedge clock) if(en) m[0]<=d; assign q=m[0]; endmodule',
    }
    for name,source in rejected.items():
        folder=base/name;folder.mkdir(parents=True,exist_ok=True);rtl=folder/"T.v";rtl.write_text(source,encoding="utf-8")
        try:translate_yosys(rtl,folder/"model","T","Contract."+name,evidence=folder/"translation")
        except (ValueError,RuntimeError) as e:results.append({"case":name,"status":"PASS","diagnostic":str(e)})
        else:raise RuntimeError("Accepted unsupported case: "+name)
    for name,source in {
        "ExplicitUnknown":'module T(input d, output q); assign q=1\'bx; endmodule',
        "Division":'module T(input en, input [3:0] a,b, output [3:0] q); assign q=en ? a/b : a; endmodule',
        "PartialInitial":'module T(input clock, en, output reg [3:0] q); initial q=4\'b1x0x; always @(posedge clock) if(en) q<=q+1; endmodule',
    }.items():
        folder=base/name;folder.mkdir(parents=True,exist_ok=True);rtl=folder/"T.v";rtl.write_text(source,encoding="utf-8")
        relative=translate_yosys(rtl,folder/"model","T","Contract."+name,evidence=folder/"translation")
        path=folder/"model"/relative;ir=json.loads(path.read_text());initial=experiment_initial(ir)
        if name=="ExplicitUnknown":
            arbitrary=ir["arbitrary_inputs"]
            if len(arbitrary)!=1:raise RuntimeError("Unknown value was not exposed")
            key=arbitrary[0]["name"]
            code,rows=simulate_yosys(path,[{"inputs":{"d":0,key:v}} for v in (0,1)],initial,folder/"run")
            if code or [r["pre"]["q"] for r in rows]!=[0,1]:raise RuntimeError("Unknown input was silently fixed")
        elif name=="Division":
            code,rows=simulate_yosys(path,[{"inputs":{"en":0,"a":7,"b":0}},{"inputs":{"en":1,"a":9,"b":2}}],initial,folder/"valid")
            if code or [r["pre"]["q"] for r in rows]!=[7,4]:raise RuntimeError("Division definedness mismatch")
            code,_=simulate_yosys(path,[{"inputs":{"en":1,"a":7,"b":0}}],initial,folder/"invalid")
            if not code:raise RuntimeError("Active division by zero accepted")
        else:
            candidates=[f for f in ir["states"] if f["sort"]["kind"]=="bits" and f["initial"]["mask"]==10 and f["initial"]["value"]==8]
            if len(candidates)!=1:raise RuntimeError("Partial initial mask lost")
            field=candidates[0]["name"]
            row={"inputs":{"en":0,**{f["name"]:0 for f in ir["arbitrary_inputs"]}}}
            observed=[]
            for v in (8,13):
                state={**initial,field:v};code,rows=simulate_yosys(path,[row],state,folder/str(v))
                if code:raise RuntimeError("Legal unknown initial bits rejected")
                observed.append(rows[0]["pre"]["q"])
            if observed!=[8,13]:raise RuntimeError("Unknown initial bits fixed")
            code,_=simulate_yosys(path,[row],{**initial,field:0},folder/"bad-known-bit")
            if not code:raise RuntimeError("Known initial constraint ignored")
        results.append({"case":name,"status":"PASS"})

    # Two masked write ports, same-address priority, and asynchronous read.
    folder=base/"MaskedMemory";folder.mkdir(parents=True,exist_ok=True)
    source='''module MaskedMemory(input clock, input [1:0] addr0,addr1,readAddr,
 input en0,en1, input [1:0] mask0,mask1, input [7:0] data0,data1, output [7:0] q);
 reg [7:0] mem[0:3];
 always @(posedge clock) begin
  for(integer j=0;j<2;j=j+1) begin
   if(en0 && mask0[j]) mem[addr0][4*j+:4] <= data0[4*j+:4];
   if(en1 && mask1[j]) mem[addr1][4*j+:4] <= data1[4*j+:4];
  end
 end
 assign q=mem[readAddr]; endmodule'''
    rtl=folder/"MaskedMemory.v";rtl.write_text(source,encoding="utf-8")
    relative=translate_yosys(rtl,folder/"model","MaskedMemory","Contract.MaskedMemory",evidence=folder/"translation")
    ir_path=folder/"model"/relative;ir=json.loads(ir_path.read_text())
    rng=random.Random(66000);trace=[]
    for i in range(128):
        values={"addr0":rng.randrange(4),"addr1":rng.randrange(4),"readAddr":rng.randrange(4),"en0":rng.randrange(2),"en1":rng.randrange(2),
                "mask0":rng.randrange(4),"mask1":rng.randrange(4),"data0":rng.randrange(256),"data1":rng.randrange(256)}
        if i<32:values.update(addr0=i%4,addr1=i%4,readAddr=i%4,en0=1,en1=1)
        trace.append({"inputs":values})
    lean_trace=[{"inputs":{**r["inputs"],**{a["name"]:0 for a in ir["arbitrary_inputs"]}}} for r in trace]
    code,lean=simulate_yosys(ir_path,lean_trace,experiment_initial(ir),folder/"lean")
    if code:raise RuntimeError("Masked memory Lean run failed")
    widths={"clock":1,"addr0":2,"addr1":2,"readAddr":2,"en0":1,"en1":1,"mask0":2,"mask1":2,"data0":8,"data1":8,"q":8}
    metadata={"top":"MaskedMemory","clocked":True,"ports":[{"name":n,"rtl_name":n,"width":w,"direction":"output" if n=="q" else "input"} for n,w in widths.items()]}
    code,golden=run_emitted_rtl(folder,metadata,trace,folder/"rtl-reference")
    if code:raise RuntimeError("Masked memory RTL run failed")
    memory=[0]*4
    for i,(l,r,row) in enumerate(zip(lean,golden,trace)):
        v=row["inputs"];pre=memory[v["readAddr"]]
        for port in (0,1):
            if v[f"en{port}"]:
                for nibble in range(2):
                    if v[f"mask{port}"]>>nibble&1:
                        mask=15<<(4*nibble);addr=v[f"addr{port}"]
                        memory[addr]=(memory[addr]&~mask)|(v[f"data{port}"]&mask)
        post=memory[v["readAddr"]]
        if l["pre"]["q"]!=pre or l["post"]["q"]!=post or l["pre"]!=r["pre"] or l["post"]!=r["post"]:
            raise RuntimeError(f"Masked memory priority mismatch at {i}")
    results.append({"case":"MaskedMemory","status":"PASS","cycles":128,"comparisons":256})

    # Mutation uses the actual generated Counter and the recorded official RTL oracle.
    counter=ROOT/"experiments/yosys-7.3/Counter4"
    ir=json.loads((counter/"model/Yosys/Counter4.ir.json").read_text())
    add=next(n for n in ir["nodes"] if n["op"]=="bvadd");add["op"]="bvsub"
    ir["namespace"]="Mutation.Counter";folder=base/"Mutation";model=folder/"model"
    path=model/"Mutation/Counter.ir.json";write(path,ir)
    lean=path.with_suffix("").with_suffix(".lean");lean.write_text(emit_lean(ir),encoding="utf-8")
    if run_logged([lean_executable(),"-o",str(lean.with_suffix(".olean")),str(lean)],folder/"check",echo=False):raise RuntimeError("Mutant did not compile")
    request=json.loads((counter/"lean/request.json").read_text())
    rows=[{"inputs":{n:v for n,v in r["inputs"].items() if n!=ir["clock"]}} for r in request["trace"]]
    code,mutant=simulate_yosys(path,rows,request["initial"],folder/"run")
    original=json.loads((counter/"lean/result.json").read_text())
    if code or mutant==original:raise RuntimeError("Semantic mutation was not detected")
    results.append({"case":"AddToSubMutation","status":"PASS","detected":True})
    summary={"status":"PASS","checks":len(results),"results":results}
    write(base/"summary.json",summary);write(ROOT/"docs/validation-yosys-contracts-7.3.json",summary)
    print(json.dumps(summary,indent=2))
    return 0


if __name__=="__main__":raise SystemExit(main())
