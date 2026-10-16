"""Elaborate a compiled Chisel 7.3 module with its real constructor and dependencies.

Writes modern CHIRRTL, independently elaborated official RTL, and stable ports.
The constructor JSON is a positional array; nested {class,args} objects construct
real project configuration objects. No source frontend metadata is required.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

from common import ROOT, java_executable, rtl_environment, run_logged


def elaborate(module: str, constructor: list, classpath_file: Path, output: Path, evidence: Path):
    if not isinstance(constructor, list):
        raise ValueError("Constructor JSON must be a positional array")
    output, evidence = output.resolve(), evidence.resolve()
    evidence.mkdir(parents=True, exist_ok=True)
    args = evidence / "constructor.json"
    args.write_text(json.dumps(constructor, indent=2), encoding="utf-8")
    cp = classpath_file.read_text(encoding="utf-8").strip()
    command = [java_executable(), "-Xmx4g", "-Dfile.encoding=UTF-8", "-cp", cp,
               "reference.ElaborateChisel", module, str(args), str(output)]
    if code := run_logged(command, evidence / "official-elaboration", env=rtl_environment(), echo=False):
        raise RuntimeError(f"Official Chisel elaboration failed ({code}); see {evidence}")
    ports = json.loads((output / "ports.json").read_text(encoding="utf-8"))
    artifacts = [output / "design.fir", output / (ports["top"] + ".v"), output / "ports.json"]
    jvm_metadata = json.loads((output / "jvm-elaboration.json").read_text(encoding="utf-8"))
    manifest = {"format": "chisel2lean-official-elaboration-v1", "module": module,
                "constructor": constructor, "chisel_version": "7.3.0", "configuration": "fixed",
                "classpath_file": str(classpath_file.resolve()),
                "classpath_sha256": hashlib.sha256(cp.encode()).hexdigest(),
                "artifacts_sha256": {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in artifacts},
                "source_frontend_used": False, "independent_chisel_elaborations": 2,
                "evidence": str(evidence), "jvm": jvm_metadata}
    (output / "elaboration.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    return manifest


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--module", required=True)
    parser.add_argument("--constructor", type=Path, help="JSON array of primitive arguments / class+args factories")
    parser.add_argument("--classpath-file", type=Path, default=ROOT / ".cache/reference-classpath.txt")
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--evidence", type=Path, default=ROOT / "experiments/official-elaboration")
    parser.add_argument("--lean-out", type=Path, help="Also translate the resulting modern design.fir into checked Lean")
    args = parser.parse_args()
    constructor = json.loads(args.constructor.read_text(encoding="utf-8")) if args.constructor else []
    elaborate(args.module, constructor, args.classpath_file, args.out, args.evidence)
    if args.lean_out:
        from firrtl2lean import translate_firrtl
        return translate_firrtl(args.out / "design.fir", args.lean_out, frontend="circt")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
