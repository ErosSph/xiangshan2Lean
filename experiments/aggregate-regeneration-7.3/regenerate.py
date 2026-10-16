"""Regenerate previously verified CDE/XS models and require byte-identical artifacts."""
from pathlib import Path
import hashlib
import json
import os
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))
from chisel2lean import translate
from common import lean_executable, run_logged
from fetch_xiangshan_dependencies import CACHE

evidence = Path(__file__).resolve().parent
output = ROOT / "generated/aggregate-regeneration"
records = []


def check(sources, old, module, classpath):
    expected = {p.relative_to(old): p.read_bytes() for p in old.rglob("*")
                if p.name.endswith((".ir.json", ".lean")) and "Chisel2Lean" not in p.parts}
    if module:
        selected = Path(*module.split("."))
        expected = {p: data for p, data in expected.items() if str(p) in (str(selected) + ".ir.json", str(selected) + ".lean")}
    if not expected:
        raise RuntimeError("No previous artifacts to compare")
    if translate(sources, output, module, classpath.read_text().strip(), True):
        raise RuntimeError("Regeneration failed")
    for relative, data in expected.items():
        fresh = (output / relative).read_bytes()
        record = {"artifact": relative.as_posix(), "unchanged": fresh == data,
                  "previous_sha256": hashlib.sha256(data).hexdigest(), "regenerated_sha256": hashlib.sha256(fresh).hexdigest()}
        records.append(record)
        if not record["unchanged"]:
            raise RuntimeError("Previously verified artifact changed: " + str(relative))


check([ROOT / "tests/fixtures/configuration/Supported.scala", ROOT / "tests/fixtures/configuration/Hierarchy.scala"],
      ROOT / "generated/configuration", None, ROOT / ".cache/reference-classpath.txt")
upstream = CACHE / "xiangshan/src/main/scala/xiangshan"
sources = [ROOT / "verification/xiangshan/config/reference/Hierarchy.scala", upstream / "backend/fu/Alu.scala",
           upstream / "Bundle.scala", upstream / "XSCore.scala", upstream / "Parameters.scala"]
for name in ["ShiftHierarchy", "SfencePipeline"]:
    check(sources, ROOT / "generated/xiangshan-hierarchy", "xiangshan.validation." + name, ROOT / ".cache/xiangshan-classpath.txt")
check(sources, ROOT / "generated/xiangshan-config", "xiangshan.backend.fu.RightShiftModule", ROOT / ".cache/xiangshan-classpath.txt")
check([ROOT / "verification/xiangshan/config/reference/Vector.scala", upstream / "Bundle.scala",
       upstream / "XSCore.scala", upstream / "Parameters.scala"], ROOT / "generated/xiangshan-aggregate",
      "xiangshan.validation.SfenceVectorPipeline", ROOT / ".cache/xiangshan-classpath.txt")
env = os.environ.copy()
env["LEAN_PATH"] = str(output)
proof = ROOT / "verification/xiangshan/config/SfencePipelineProof.lean"
if run_logged([lean_executable(), str(proof)], evidence / "sfence-proof", env=env):
    raise RuntimeError("Previous parametric Sfence model proofs failed")
report = {"status": "PASS", "compiler_sha256": json.loads((output / "manifest.json").read_text())["compiler_sha256"],
          "identical_artifacts": len(records), "artifacts": records,
          "meaning": "Previously tested IR and Lean source are byte-identical under the new compiler; previous RTL traces were not rerun here."}
(evidence / "summary.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
print(f"PASS: {len(records)} previously verified artifacts unchanged", flush=True)
