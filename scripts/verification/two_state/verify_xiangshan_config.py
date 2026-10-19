"""Validate original Nanhu RightShiftModule with real, complete XSModule/CDE dependencies."""
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
import shutil
from pathlib import Path

from chisel2lean import translate
from common import ROOT, lean_executable, run_logged, sbt_command
from fetch_xiangshan_dependencies import CACHE, LOCK, main as fetch_dependencies
from materialize_config import materialize
from rtl import run_emitted_rtl
from verify_xiangshan_right_shift import make_trace, run_lean_trace, compare, write_json

MODULE = "xiangshan.backend.fu.RightShiftModule"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skip-build", action="store_true")
    parser.add_argument("--widths", type=int, nargs="+", default=[8, 32, 64])
    parser.add_argument("--random-cycles", type=int, default=512)
    parser.add_argument("--evidence", type=Path, default=ROOT / "experiments" / "xiangshan-config-7.3" / "validation")
    args = parser.parse_args()
    if not args.skip_build:
        fetch_dependencies()
        command, env = sbt_command(["writeToolClasspath", "xiangshanFramework/writeXiangshanClasspath"])
        if code := run_logged(command, args.evidence / "build", env=env):
            return code
    upstream = CACHE / "xiangshan" / "src/main/scala/xiangshan"
    sources = [upstream / "backend/fu/Alu.scala", upstream / "XSCore.scala", upstream / "Parameters.scala"]
    # The full original source file, original base class and complete trait are
    # typed. No replacement class declaration or shortened framework is used.
    old = ROOT / "verification/xiangshan/right-shift/upstream/Alu.scala"
    if sources[0].read_bytes() != old.read_bytes():
        raise RuntimeError("Original selected module's full source no longer matches the pinned source")
    output = ROOT / "generated/xiangshan-config"
    classpath = ROOT / ".cache/xiangshan-classpath.txt"
    if code := translate(sources, output, MODULE, classpath.read_text().strip(), True):
        return code
    ir_path = output / "xiangshan/backend/fu/RightShiftModule.ir.json"
    ir = json.loads(ir_path.read_text(encoding="utf-8"))
    fields = ir["configuration"]["fields"]
    if len(fields) != 1 or fields[0]["key"] != "xiangshan.XSCoreParamsKey" or fields[0]["selectors"] != ["XLEN"]:
        raise RuntimeError("Unexpected automatic configuration projection")
    results = []
    for width in args.widths:
        folder = args.evidence / f"XLEN-{width}"
        descriptor = {"class": "xiangshan.validation.NanhuCoreConfig", "args": []} if width == 64 else {
            "class": "xiangshan.validation.NanhuWidthConfig", "args": [width, True]}
        snapshot = materialize(ir_path, {"p": descriptor}, {}, folder / "configuration.json", classpath, folder / "config", folder / "rtl")
        parameters = snapshot["parameters"]
        if parameters[fields[0]["name"]] != width:
            raise RuntimeError("Real CDE configuration does not have the requested XLEN")
        trace = make_trace(width, args.random_cycles, 20261013)
        write_json(folder / "trace.json", trace)
        lean = run_lean_trace(ir_path, width, trace, folder / "lean", parameters)
        code, rtl = run_emitted_rtl(folder / "rtl", json.loads((folder / "rtl/ports.json").read_text()), trace, folder / "reference")
        if code:
            raise RuntimeError(f"Original real-framework RTL failed: {folder}")
        result = compare(width, trace, lean, rtl, folder)
        result.update(lean_parameters=parameters, real_CDE=True, original_full_source=True,
                      actual_processor_configuration=width == 64)
        write_json(folder / "summary.json", result)
        results.append(result)
    proof = ROOT / "verification/xiangshan/right-shift/RightShiftProof.lean"
    env = os.environ.copy()
    env["LEAN_PATH"] = str(output)
    if run_logged([lean_executable(), str(proof)], args.evidence / "model-proof", env=env):
        raise RuntimeError("Generic generated-model specification theorems did not check")
    # Independently generated original RTL detects a wrong configuration mapping.
    if 64 in args.widths:
        folder = args.evidence / "negative-mapping"
        witness = make_trace(64, 0, 20261013)[:64]
        correct = {fields[0]["name"]: 64}
        wrong = {fields[0]["name"]: 32}
        actual = run_lean_trace(ir_path, 64, witness, folder / "correct", correct)
        faulty = run_lean_trace(ir_path, 32, witness, folder / "wrong", wrong)
        detected = any(a["post"] != b["post"] for a, b in zip(actual, faulty))
        if not detected:
            # The first pattern may be zero; use a signed high-bit witness.
            from verify_xiangshan_right_shift import entry
            witness = [entry(1 << 63, 1 << 63, 1, 63)]
            actual = run_lean_trace(ir_path, 64, witness, folder / "correct", correct)
            faulty = run_lean_trace(ir_path, 32, witness, folder / "wrong", wrong)
            detected = actual[0]["post"] != faulty[0]["post"]
        rtl_dir = folder / "rtl"
        rtl_dir.mkdir(parents=True, exist_ok=True)
        original_rtl = args.evidence / "XLEN-64/rtl"
        for path in [*(original_rtl.glob("*.v")), original_rtl / "ports.json"]:
            shutil.copy2(path, rtl_dir / path.name)
        code, reference = run_emitted_rtl(rtl_dir, json.loads((rtl_dir / "ports.json").read_text()), witness, folder / "reference")
        if code or actual != [{**r, "state": {}} for r in reference] or not detected:
            raise RuntimeError("Negative configuration-mapping control did not detect the error")
        write_json(folder / "summary.json", {"status": "PASS", "wrong_XLEN_mapping_detected": True})
    summary = {"status": "PASS", "module": MODULE, "toolchain": json.loads(LOCK.read_text()),
               "configuration_framework": "real CDE + original XSModule + complete HasXSParameter + original MinimalConfig/XSCoreParameters",
               "source_sha256": {str(s.relative_to(CACHE)): hashlib.sha256(s.read_bytes()).hexdigest() for s in sources},
               "cases": results, "cycles": sum(r["cycles"] for r in results),
               "compared_output_values": sum(r["compared_output_values"] for r in results),
               "generated_model_specification_theorems": 3, "formal_source_to_lean_equivalence_proof": False}
    write_json(args.evidence / "summary.json", summary)
    write_json(ROOT / "docs/validation-xiangshan-config-7.3.json", summary)
    print(json.dumps({k: summary[k] for k in ["status", "cycles", "compared_output_values", "generated_model_specification_theorems"]}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
