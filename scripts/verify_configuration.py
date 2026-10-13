"""Exercise generic inheritance, trait overrides, CDE field projection and rejection diagnostics."""
from __future__ import annotations

import argparse
import json
import random
import subprocess
import sys
import uuid
from pathlib import Path

from chisel2lean import translate
from common import ROOT, sbt_command, run_logged
from materialize_config import materialize
from rtl import run_emitted_rtl, run_rtl
from simulate import simulate

SOURCE = ROOT / "tests/fixtures/configuration/Supported.scala"


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2), encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skip-build", action="store_true")
    parser.add_argument("--evidence", type=Path, default=ROOT / "experiments/configuration-7.3")
    args = parser.parse_args()
    if not args.skip_build:
        cmd, env = sbt_command(["writeToolClasspath", "reference/writeReferenceClasspath"])
        if code := run_logged(cmd, args.evidence / "build", env=env):
            return code
    output = ROOT / "generated/configuration"
    classpath = ROOT / ".cache/reference-classpath.txt"
    if code := translate([SOURCE], output, None, classpath.read_text().strip(), True):
        return code
    cases = []

    def check(name, factories, constructor, trace, expected, label):
        ir_path = output / "configuration" / (name + ".ir.json")
        folder = args.evidence / label
        snapshot = materialize(ir_path, factories, constructor, folder / "configuration.json", classpath, folder / "config", folder / "rtl")
        parameters = snapshot["parameters"]
        code, lean = simulate(ir_path, parameters, trace, None, folder / "lean")
        code2, rtl = run_emitted_rtl(folder / "rtl", json.loads((folder / "rtl/ports.json").read_text()), trace, folder / "reference")
        if code or code2 or len(lean) != len(trace) or len(rtl) != len(trace):
            raise RuntimeError(f"Execution failed: {folder}")
        specification = expected(trace)
        for index, (a, b, spec) in enumerate(zip(lean, rtl, specification)):
            for sampling in ("pre", "post"):
                if a[sampling] != b[sampling] or a[sampling] != spec[sampling]:
                    write(folder / "mismatch.json", {"cycle": index, "lean": a, "rtl": b, "expected": spec})
                    raise RuntimeError(f"Configuration/inheritance mismatch: {folder}")
        result = {"status": "PASS", "module": name, "parameters": parameters, "cycles": len(trace),
                  "output_comparisons": sum(len(e["pre"]) * 2 for e in rtl),
                  "comparison": "executed Lean == original official RTL == independent specification"}
        write(folder / "summary.json", result)
        cases.append(result)
        print(f"{label}: PASS", flush=True)

    for width in [1, 4, 8]:
        for enabled in [False, True]:
            for inc in [0, 2]:
                offset = 3
                rng = random.Random(20261013 + width * 10 + inc)
                mask = (1 << (width + 1)) - 1
                trace = [{"reset": i in [0, 27], "inputs": {"data": rng.randrange(mask + 1)}} for i in range(64)]
                def expected(entries):
                    state, records = 0, []
                    for entry in entries:
                        pre = (state + offset) & mask
                        state = 0 if entry.get("reset") else ((entry["inputs"]["data"] + inc + 1) & mask) if enabled else state
                        records.append({"pre": {"out": pre}, "post": {"out": (state + offset) & mask}})
                    return records
                check("ConfiguredPipeline", {"p": {"class": "configuration.TestConfig", "args": [width, enabled, offset]}},
                      {"inc": inc}, trace, expected, f"pipeline-w{width}-en{enabled}-inc{inc}")
    for source_width, destination_width in [(2, 5), (5, 2), (4, 4)]:
        trace = [{"inputs": {"a": i}} for i in range(1 << source_width)]
        def expected(entries):
            return [{sampling: {"y": e["inputs"]["a"] % (1 << destination_width)} for sampling in ["pre", "post"]} for e in entries]
        factories = {root: {"class": "configuration.TestConfig", "args": [width, True, 0]}
                     for root, width in [("p", source_width), ("other", destination_width)]}
        check("TwoConfigurations", factories, {}, trace, expected, f"two-configs-{source_width}-{destination_width}")
    for n in [1, 3, 6]:
        trace = [{"inputs": {"a": i}} for i in range(1 << (n + 1))]
        def expected(entries):
            return [{sampling: {"y": e["inputs"]["a"] ^ ((1 << (n + 1)) - 1)} for sampling in ["pre", "post"]} for e in entries]
        check("InheritedPrimitive", {}, {"n": n}, trace, expected, f"inherited-n{n}")
    for flag in [False, True]:
        trace = [{"inputs": {"a": i}} for i in range(32)]
        def expected(entries):
            return [{sampling: {"y": e["inputs"]["a"] ^ (31 if flag else 0)} for sampling in ["pre", "post"]} for e in entries]
        check("ScalarDefaults", {"p": {"class": "configuration.ScalarConfig", "args": [flag]}}, {}, trace, expected, f"scalar-defaults-{flag}")
    rejections = []
    for name in ["DynamicKey", "CollectionField", "EagerInherited", "ForwardValue", "ExplicitSuper", "RecursiveGetter", "OverloadedGetter", "OverrideVal"]:
        destination = args.evidence / "rejected" / name
        generated_attempt = destination / ("generated-" + uuid.uuid4().hex[:10])
        command = [sys.executable, str(ROOT / "scripts/chisel2lean.py"), str(SOURCE),
                   str(ROOT / "tests/fixtures/configuration/Rejected.scala"), "--module", "rejectedconfiguration." + name,
                   "--classpath-file", str(classpath), "--out", str(generated_attempt), "--no-check"]
        destination.mkdir(parents=True, exist_ok=True)
        proc = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, encoding="utf-8", errors="replace")
        (destination / "stdout.log").write_text(proc.stdout, encoding="utf-8")
        (destination / "stderr.log").write_text(proc.stderr, encoding="utf-8")
        diagnostic = proc.stdout + proc.stderr
        valid = proc.returncode != 0 and ".scala:" in diagnostic and "[chisel2lean]" in diagnostic and not (generated_attempt / "manifest.json").exists()
        result = {"module": name, "status": "PASS" if valid else "FAIL", "source_diagnostic": valid}
        rejections.append(result)
        if not valid:
            raise RuntimeError(f"Expected explicit source rejection: {name}\n{proc.stderr}")
    summary = {"status": "PASS", "configurations": len(cases), "cases": cases, "rejections": rejections,
               "cycles": sum(c["cycles"] for c in cases), "output_comparisons": sum(c["output_comparisons"] for c in cases),
               "formal_source_to_lean_equivalence_proof": False}
    write(args.evidence / "summary.json", summary)
    write(ROOT / "docs/validation-configuration-7.3.json", summary)
    print(f"PASS: {len(cases)} configurations, {len(rejections)} explicit rejections")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
