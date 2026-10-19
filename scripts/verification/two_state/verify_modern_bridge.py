"""Kernel-check a same-source, same-Chisel-version fixed-configuration bridge."""
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

import hashlib
import json
import os
from pathlib import Path

from chisel2lean import translate
from common import ROOT, lean_executable, run_logged


def main():
    evidence = ROOT / "experiments/modern-counter-bridge-7.3"
    modern = ROOT / "experiments/modern-firrtl-7.3/Counter4/model"
    source = ROOT / "audit/src/main/scala/Probes.scala"
    original = ROOT / "experiments/modern-firrtl-7.3/Counter4/summary.json"
    case = json.loads(original.read_text(encoding="utf-8"))
    if case["status"] != "PASS" or case["constructor"] != [4]:
        raise ValueError("Run the fresh Counter4 modern validation first")
    source_hash = hashlib.sha256(source.read_bytes()).hexdigest()
    if case["original_sources_sha256"][source.relative_to(ROOT).as_posix()] != source_hash:
        raise ValueError("Counter source changed since official elaboration")
    output = evidence / "source-model"
    if code := translate([source], output, "probes.Counter", None, True):
        return code
    env = os.environ.copy()
    env["LEAN_PATH"] = os.pathsep.join([str(output), str(modern)])
    proof = ROOT / "verification/firrtl/ModernCounterBridge.lean"
    if code := run_logged([lean_executable(), str(proof)], evidence / "kernel-check", env=env):
        return code
    summary = {"status": "PASS", "chisel_version": "7.3.0", "source_sha256": source_hash,
               "configuration": {"n": 4}, "model_theorems": 3,
               "scope": "all initial counter states, all enable/reset inputs, all finite input sequence lengths",
               "proof": proof.relative_to(ROOT).as_posix(),
               "official_chisel_elaboration": case["elaboration"],
               "modern_model_manifest": case["manifest"],
               "source_model_manifest": json.loads((output / "manifest.json").read_text(encoding="utf-8")),
               "general_compiler_correctness_proved": False}
    evidence.mkdir(parents=True, exist_ok=True)
    for path in [evidence / "summary.json", ROOT / "docs/validation-modern-bridge-7.3.json"]:
        path.write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print("PASS: modern/source Counter4 models agree for every initial state and finite input/reset sequence")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
