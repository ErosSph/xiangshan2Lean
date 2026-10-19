"""Reject unsupported aggregate layouts and execute Vec[Bundle] definedness contracts."""
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
import os
from pathlib import Path
import subprocess
import sys

from common import ROOT
from simulate import simulate
from verify_aggregate import make_trace, write


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--generated", type=Path, default=ROOT / "generated/aggregate-validation")
    parser.add_argument("--evidence", type=Path, default=ROOT / "experiments/aggregate-contracts-7.3")
    args = parser.parse_args()
    args.generated, args.evidence = args.generated.resolve(), args.evidence.resolve()
    cases = []
    source = ROOT / "tests/fixtures/aggregate/Rejected.scala"
    for name, expected in [("MismatchBundleFields", "matching Bundle fields"),
                           ("MismatchAggregateShape", "matching Bundle fields and Vec structure"),
                           ("WriteThroughAlias", "Connections through value aliases")]:
        folder = args.evidence / name
        folder.mkdir(parents=True, exist_ok=True)
        command = [sys.executable, str(ROOT / "scripts/chisel2lean.py"), str(source), "--module", "aggregateRejected." + name,
                   "--out", str(folder / "generated"), "--no-check"]
        proc = subprocess.run(command, cwd=ROOT, capture_output=True, encoding="utf-8", errors="replace")
        (folder / "stdout.log").write_text(proc.stdout, encoding="utf-8")
        (folder / "stderr.log").write_text(proc.stderr, encoding="utf-8")
        diagnostic = proc.stdout + proc.stderr
        good = proc.returncode != 0 and "Rejected.scala:" in diagnostic and expected in diagnostic and not (folder / "generated/manifest.json").exists()
        cases.append({"kind": "source-rejection", "name": name, "status": "PASS" if good else "FAIL"})

    contract_source = ROOT / "tests/fixtures/aggregate/Contracts.scala"
    for name, message in [("MuxClassMismatch", "same Bundle/Vec element classes"),
                           ("VecInitClassMismatch", "same Bundle/Vec element classes"),
                           ("MuxKindMismatch", "same Bundle/Vec element classes"),
                           ("EmptyBundleContract", "Empty Bundles"),
                           ("MuxLengthContract", "identical symbolic Vec lengths"),
                           ("VecInitLengthContract", "identical symbolic Vec lengths")]:
        folder = args.evidence / name
        folder.mkdir(parents=True, exist_ok=True)
        proc = subprocess.run([sys.executable, str(ROOT / "scripts/chisel2lean.py"), str(contract_source),
                               "--module", "aggregateContracts." + name, "--no-check", "--out", str(folder / "generated")],
                              cwd=ROOT, capture_output=True, encoding="utf-8", errors="replace")
        diagnostic = proc.stdout + proc.stderr
        (folder / "diagnostic.log").write_text(diagnostic, encoding="utf-8")
        good = proc.returncode != 0 and "Contracts.scala:" in diagnostic and message in diagnostic
        cases.append({"kind": "source-rejection", "name": name, "status": "PASS" if good else "FAIL"})
    from chisel2lean import translate
    for name, parameters in [("MuxWidthContract", {"wi": 1, "wo": 5}),
                              ("VecInitWidthContract", {"wi": 5, "wo": 2})]:
        folder = args.evidence / name
        good = False
        if translate([contract_source], folder / "generated", "aggregateContracts." + name, None, True) == 0:
            try:
                simulate(folder / "generated/aggregateContracts" / (name + ".ir.json"), parameters, [{"inputs": {}}], None, folder / "invalid")
            except ValueError as error:
                good = "legal domain" in str(error)
        cases.append({"kind": "aggregate-choice-domain", "name": name, "status": "PASS" if good else "FAIL"})

    paths = {name: args.generated / "aggregate" / (name + ".ir.json") for name in (
        "BundleVectorPipeline", "BundleVectorWrites", "NestedBundleVector")}
    parameters = {"n": 3, "w": 2, "m": 3}
    for name, replacements in [("zero-n", {"n": 0}), ("zero-w", {"w": 0}), ("zero-m", {"m": 0}),
                               ("overflow-w", {"w": 2147483647}), ("out-of-int-range", {"n": 2147483648})]:
        good = False
        try:
            simulate(paths["BundleVectorPipeline"], parameters | replacements, [{"inputs": {}}], None, args.evidence / name)
        except ValueError as error:
            good = "legal domain" in str(error)
        cases.append({"kind": "invalid-domain", "name": name, "status": "PASS" if good else "FAIL"})

    scenarios = [
        ("outer-write", "BundleVectorWrites", {"index": 3, "write": True}, False, False, "Undefined transition operation"),
        ("inner-write", "BundleVectorWrites", {"lane": 3, "updateLanes": True}, False, False, "Undefined transition operation"),
        ("outer-read", "BundleVectorPipeline", {"index": 3}, False, False, "Undefined output operation"),
        ("inner-read", "NestedBundleVector", {"lane": 3}, False, False, "Undefined output operation"),
        ("inactive-write", "BundleVectorWrites", {"index": 3, "lane": 3, "other": 3, "otherLane": 3}, False, True, ""),
        ("reset-priority", "BundleVectorWrites", {"index": 3, "lane": 3, "other": 3, "otherLane": 3,
                                                  "write": True, "overrideData": True, "updateLanes": True}, True, True, "")]
    for label, name, replacements, reset, should_pass, message in scenarios:
        ir = json.loads(paths[name].read_text())
        entry = make_trace(ir, parameters, 1, 20261014)[0]
        entry["inputs"].update({k: False for k in ("write", "overrideData", "updateLanes") if k in entry["inputs"]})
        entry["inputs"].update({k: 0 for k in ("index", "other", "lane", "otherLane") if k in entry["inputs"]})
        entry["inputs"].update(replacements)
        entry["reset"] = reset
        folder = args.evidence / label
        code, _ = simulate(paths[name], parameters, [entry], None, folder)
        stderr = (folder / "execution/stderr.log").read_text(encoding="utf-8")
        good = code == 0 if should_pass else code != 0 and message in stderr
        cases.append({"kind": "definedness", "name": label, "status": "PASS" if good else "FAIL"})

    ir = json.loads(paths["BundleVectorPipeline"].read_text())
    entry = make_trace(ir, parameters, 1, 20261014)[0]
    entry["inputs"]["data.data"] = [0, 1]
    good = False
    try:
        simulate(paths["BundleVectorPipeline"], parameters, [entry], None, args.evidence / "bad-column-length")
    except ValueError as error:
        good = "exactly 3 elements" in str(error)
    cases.append({"kind": "trace-layout", "name": "bad-column-length", "status": "PASS" if good else "FAIL"})
    report = {"status": "PASS" if all(c["status"] == "PASS" for c in cases) else "FAIL",
              "passed": sum(c["status"] == "PASS" for c in cases), "total": len(cases),
              "compiler_sha256": hashlib.sha256(Path((ROOT / ".cache/tool-classpath.txt").read_text().strip().split(os.pathsep)[0]).read_bytes()).hexdigest(),
              "model_compiler_sha256": json.loads((args.generated / "manifest.json").read_text())["compiler_sha256"], "cases": cases}
    write(args.evidence / "summary.json", report)
    write(ROOT / "docs/validation-aggregate-contracts-7.3.json", report)
    print(json.dumps(report, indent=2))
    return int(report["status"] != "PASS")


if __name__ == "__main__":
    raise SystemExit(main())
