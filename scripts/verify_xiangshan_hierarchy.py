"""Check CDE propagation and original XSBundle fields through small real-framework test tops."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import random
from pathlib import Path

from chisel2lean import translate
from common import ROOT, lean_executable, run_logged, sbt_command
from fetch_xiangshan_dependencies import CACHE, LOCK, main as fetch_dependencies
from materialize_config import materialize
from rtl import run_emitted_rtl
from simulate import simulate


def write(path: Path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2), encoding="utf-8")


def check_model_proof(output: Path, evidence: Path):
    proof = ROOT / "verification/xiangshan/config/SfencePipelineProof.lean"
    env = os.environ.copy()
    env["LEAN_PATH"] = str(output)
    if run_logged([lean_executable(), str(proof)], evidence / "model-proof", env=env):
        raise RuntimeError("Sfence Bundle model theorems failed")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skip-build", action="store_true")
    parser.add_argument("--evidence", type=Path, default=ROOT / "experiments/xiangshan-hierarchy-7.3")
    args = parser.parse_args()
    args.evidence = args.evidence.resolve()
    if not args.skip_build:
        fetch_dependencies()
        command, env = sbt_command(["writeToolClasspath", "xiangshanFramework/writeXiangshanClasspath"])
        if code := run_logged(command, args.evidence / "build", env=env):
            return code

    upstream = CACHE / "xiangshan/src/main/scala/xiangshan"
    harness = ROOT / "verification/xiangshan/config/reference/Hierarchy.scala"
    sources = [harness, upstream / "backend/fu/Alu.scala", upstream / "Bundle.scala",
               upstream / "XSCore.scala", upstream / "Parameters.scala"]
    classpath = ROOT / ".cache/xiangshan-classpath.txt"
    output = ROOT / "generated/xiangshan-hierarchy"
    for name in ["ShiftHierarchy", "SfencePipeline"]:
        if code := translate(sources, output, "xiangshan.validation." + name, classpath.read_text().strip(), True):
            return code
    check_model_proof(output, args.evidence)
    cases = []

    def check(name, factory, trace, expected, expected_fields, label):
        ir_path = output / "xiangshan/validation" / (name + ".ir.json")
        ir = json.loads(ir_path.read_text())
        actual_fields = {(f["root"], f["key"], tuple(f["selectors"])) for f in ir["configuration"]["fields"]}
        wanted = {("p", "xiangshan.XSCoreParamsKey", (field,)) for field in expected_fields}
        if actual_fields != wanted:
            raise RuntimeError(f"Unexpected transitive configuration fields: {actual_fields}")
        folder = args.evidence / label
        write(folder / "trace.json", trace)
        snapshot = materialize(ir_path, {"p": factory}, {}, folder / "configuration.json", classpath,
                               folder / "config", folder / "rtl")
        code, lean = simulate(ir_path, snapshot["parameters"], trace, None, folder / "lean")
        code2, rtl = run_emitted_rtl(folder / "rtl", json.loads((folder / "rtl/ports.json").read_text()), trace, folder / "reference")
        if code or code2 or len(lean) != len(trace) or len(rtl) != len(trace):
            raise RuntimeError(f"Execution failed: {folder}")
        for index, (a, b, spec) in enumerate(zip(lean, rtl, expected(trace))):
            for sampling in ["pre", "post"]:
                if a[sampling] != b[sampling] or a[sampling] != spec[sampling]:
                    write(folder / "mismatch.json", {"cycle": index, "lean": a, "rtl": b, "expected": spec})
                    raise RuntimeError(f"Real-framework hierarchy/Bundle mismatch: {folder}")
        result = {"status": "PASS", "test_top": ir["module"], "parameters": snapshot["parameters"],
                  "cycles": len(trace), "output_comparisons": sum(len(r["post"]) * 2 for r in rtl),
                  "comparison": "executed Lean == original-class official RTL == independent integer specification"}
        write(folder / "summary.json", result)
        cases.append(result)
        print(f"{label}: PASS", flush=True)

    for width in [8, 32, 64]:
        mask = (1 << width) - 1
        rng = random.Random(20261014 + width)
        values = [0, 1, mask, 1 << (width - 1)]
        trace = [{"inputs": {"source": value, "amount": amount, "reverse": (64 - amount) % 64}}
                 for amount in range(64) for value in values]
        trace += [{"inputs": {"source": rng.randrange(mask + 1), "amount": rng.randrange(64), "reverse": rng.randrange(64)}}
                  for _ in range(256)]
        def expected(entries):
            records = []
            for entry in entries:
                data = entry["inputs"]
                source, amount, reverse = data["source"], data["amount"], data["reverse"]
                signed = source - (1 << width) if source >> (width - 1) else source
                values = {"left": (source << amount) & mask, "logical": source >> amount,
                          "arithmetic": (signed >> amount) & mask,
                          "combined": ((source << amount) | (source >> reverse)) & mask}
                records.append({"pre": values, "post": values})
            return records
        factory = {"class": "xiangshan.validation.NanhuCoreConfig", "args": []} if width == 64 else {
            "class": "xiangshan.validation.NanhuWidthConfig", "args": [width, True]}
        check("ShiftHierarchy", factory, trace, expected, ["XLEN"], f"shifts-XLEN-{width}")

    fields = {"valid": 1, "bits.rs1": 1, "bits.rs2": 1, "bits.addr": None, "bits.asid": None}
    for address_width, asid_width in [(39, 16), (32, 8), (48, 12)]:
        sizes = {**fields, "bits.addr": address_width, "bits.asid": asid_width}
        rng = random.Random(20261014 + address_width)
        trace = []
        for index in range(192):
            inputs = {"enable": bool(index % 3)}
            for field, width in sizes.items():
                value = [0, (1 << width) - 1, 1 << (width - 1)][index % 3] if index < 12 else rng.randrange(1 << width)
                inputs["request." + field] = value
            trace.append({"reset": index in [0, 71, 143], "inputs": inputs})
        def expected(entries):
            state, records = {field: 0 for field in fields}, []
            for entry in entries:
                pre = {"result." + field: state[field] for field in fields}
                if entry.get("reset") or entry["inputs"]["enable"]:
                    state = {field: entry["inputs"]["request." + field] for field in fields}
                records.append({"pre": pre, "post": {"result." + field: state[field] for field in fields}})
            return records
        factory = {"class": "xiangshan.validation.NanhuCoreConfig", "args": []} if (address_width, asid_width) == (39, 16) else {
            "class": "xiangshan.validation.NanhuAddressConfig", "args": [address_width, asid_width]}
        check("SfencePipeline", factory, trace, expected, ["VAddrBits", "AsidLength"], f"sfence-{address_width}-{asid_width}")

    proof_evidence = args.evidence / "model-proof/result.json"
    proof_reference = proof_evidence.relative_to(ROOT) if proof_evidence.is_relative_to(ROOT) else proof_evidence
    summary = {"status": "PASS", "toolchain": json.loads(LOCK.read_text()),
               "harnesses": "local validation tops; not upstream processor modules",
               "unchanged_upstream_classes": ["xiangshan.backend.fu.LeftShiftModule", "xiangshan.backend.fu.RightShiftModule", "xiangshan.SfenceBundle"],
               "original_source_sha256": {str(path.relative_to(CACHE)): hashlib.sha256(path.read_bytes()).hexdigest() for path in sources[1:]},
               "harness_sha256": hashlib.sha256(harness.read_bytes()).hexdigest(),
               "cases": cases, "configurations": len(cases), "cycles": sum(c["cycles"] for c in cases),
               "output_comparisons": sum(c["output_comparisons"] for c in cases),
               "generated_model_theorems_checked": 3,
               "model_proof_evidence": proof_reference.as_posix(),
               "formal_source_to_lean_equivalence_proof": False}
    write(args.evidence / "summary.json", summary)
    write(ROOT / "docs/validation-xiangshan-hierarchy-7.3.json", summary)
    print(f"PASS: {len(cases)} real-framework hierarchy/Bundle configurations")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
