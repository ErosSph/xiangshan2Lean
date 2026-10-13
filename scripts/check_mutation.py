"""Verify that independent differential testing detects a wrong Lean output."""
import json
import argparse
import os
from pathlib import Path
import shutil
from common import ROOT, lean_executable, run_logged
from differential import run_case

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--generated", type=Path, default=ROOT / "generated/chisel7")
parser.add_argument("--evidence", type=Path, default=ROOT / "experiments/mutation-v0.3")
args = parser.parse_args()
evidence = args.evidence
artifacts = evidence / "artifacts"
(artifacts / "probes").mkdir(parents=True, exist_ok=True)
(artifacts / "Chisel2Lean").mkdir(parents=True, exist_ok=True)
for suffix in (".lean", ".olean"):
    shutil.copy2(args.generated / "Chisel2Lean" / ("Runtime" + suffix), artifacts / "Chisel2Lean" / ("Runtime" + suffix))
shutil.copy2(args.generated / "probes" / "Counter.ir.json", artifacts / "probes" / "Counter.ir.json")
source = (args.generated / "probes" / "Counter.lean").read_text(encoding="utf-8")
needle = "io_q := state.cnt"
if source.count(needle) != 1:
    raise RuntimeError("Counter output mutation site was not unique")
mutated = source.replace(needle, "io_q := state.cnt + 1")
(artifacts / "probes" / "Counter.lean").write_text(mutated, encoding="utf-8")
env = os.environ.copy()
env["LEAN_PATH"] = str(artifacts)
result = run_logged([lean_executable(), "-o", str(artifacts / "probes" / "Counter.olean"),
                     str(artifacts / "probes" / "Counter.lean")], evidence / "compile", cwd=artifacts, env=env)
if result:
    raise SystemExit(result)
case = evidence / "comparison"
case.mkdir(exist_ok=True)
observed = run_case(artifacts / "probes" / "Counter.ir.json", {"n": 3}, case)
detected = observed.get("status") == "FAIL" and observed.get("phase") == "comparison"
summary = {"status": "PASS" if detected else "FAIL", "mutation": "output incremented by one",
           "isolated_artifacts": True, "observed": observed}
(evidence / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
print(json.dumps(summary, indent=2))
raise SystemExit(0 if detected else 1)
