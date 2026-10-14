"""Kernel-check properties of a freshly translated fixed four-bit Counter."""
from __future__ import annotations

import hashlib
import json
import os

from common import ROOT, lean_executable, run_logged
from elaborate_chisel import elaborate
from yosys2lean import translate_yosys, write


def main():
    folder=ROOT/"experiments/yosys-counter-proof"
    original=folder/"original";model=folder/"model"
    provenance=elaborate("probes.Counter",[4],ROOT/".cache/reference-classpath.txt",original,folder/"elaboration")
    relative=translate_yosys(original/"Chisel2LeanReference.v",model,"Chisel2LeanReference","Yosys.Counter4",evidence=folder/"translation")
    ir=json.loads((model/relative).read_text())
    # The proof names these generated record fields. Fail if the layout changes.
    if [(f["name"],f["field"]) for f in ir["inputs"]]!=[("reset","i0"),("clock","i1"),("c2l_port_0","i2"),("c2l_undefined_0","i3")]:
        raise RuntimeError("Counter proof input layout changed")
    proof=ROOT/"verification/yosys/Counter.lean"
    env=os.environ.copy();env["LEAN_PATH"]=str(model)
    code=run_logged([lean_executable(),str(proof)],folder/"kernel",cwd=model,env=env)
    if code:return code
    output=(folder/"kernel/stdout.log").read_text(encoding="utf-8")
    if "sorryAx" in output:raise RuntimeError("Proof contains an admitted theorem")
    summary={"status":"PASS","theorems":4,"scope":"Fresh fixed n=4 Counter; arbitrary state with previous sampled clock high, arbitrary inputs including explicit unknown input; arbitrary finite sequences by induction. Not a general compiler proof.",
             "proof_sha256":hashlib.sha256(proof.read_bytes()).hexdigest(),"official_elaboration":provenance,
             "model_manifest":json.loads((model/"manifest.json").read_text()),"kernel_axioms":output}
    write(folder/"summary.json",summary);write(ROOT/"docs/validation-yosys-proof-7.3.json",summary)
    return 0


if __name__=="__main__":raise SystemExit(main())
