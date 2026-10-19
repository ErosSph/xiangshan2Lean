"""Exercise generic inheritance, trait overrides, CDE field projection and rejection diagnostics."""
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
HIERARCHY = ROOT / "tests/fixtures/configuration/Hierarchy.scala"


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2), encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skip-build", action="store_true")
    parser.add_argument("--evidence", type=Path, default=ROOT / "experiments/configuration-hierarchy-widths-7.3")
    args = parser.parse_args()
    args.evidence = args.evidence.resolve()
    if not args.skip_build:
        cmd, env = sbt_command(["writeToolClasspath", "reference/writeReferenceClasspath"])
        if code := run_logged(cmd, args.evidence / "build", env=env):
            return code
    output = ROOT / "generated/configuration"
    classpath = ROOT / ".cache/reference-classpath.txt"
    if code := translate([SOURCE, HIERARCHY], output, None, classpath.read_text().strip(), True):
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
                  "label": label,
                  "output_comparisons": sum(len(e["pre"]) * 2 for e in rtl),
                  "comparison": "executed Lean == original official RTL == independent specification"}
        write(folder / "summary.json", result)
        cases.append(result)
        print(f"{label}: PASS", flush=True)
        return ir_path, parameters, lean

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

    binding_witness = None
    for width, other_width in [(2, 5), (5, 2)]:
        for enabled, other_enabled in [(True, True), (False, True), (True, False)]:
            inc, offset, other_offset = 1, 1, 3
            rng = random.Random(20261014 + width * 10 + int(enabled))
            trace = [{"reset": i in [0, 31], "inputs": {"data": rng.randrange(256)}} for i in range(72)]
            mask, other_mask = (1 << width) - 1, (1 << other_width) - 1
            def expected(entries):
                left, right, records = 0, 0, []
                for entry in entries:
                    pre = (right + other_offset) & other_mask
                    left_out = (left + offset) & mask
                    if entry.get("reset"):
                        left, right = 0, 0
                    else:
                        left = (entry["inputs"]["data"] + inc + 1) & mask if enabled else left
                        right = ((left_out & other_mask) + inc + 2) & other_mask if other_enabled else right
                    records.append({"pre": {"out": pre}, "post": {"out": (right + other_offset) & other_mask}})
                return records
            factories = {root: {"class": "configuration.TestConfig", "args": [w, en, off]}
                         for root, w, en, off in [("p", width, enabled, offset), ("other", other_width, other_enabled, other_offset)]}
            result = check("ConfiguredHierarchy", factories, {"inc": inc}, trace, expected,
                           f"hierarchy-{width}-{other_width}-{enabled}-{other_enabled}")
            if binding_witness is None:
                binding_witness = (*result, trace)

    packet_fields = {"payload": 0, "tag": 1, "tail": None, "header.code": 0, "header.valid": "bool"}
    for width, other_width in [(2, 5), (5, 2), (4, 4)]:
        for extra in [0, 2]:
            rng = random.Random(20261014 + width * 10 + extra)
            trace = []
            for i in range(64):
                inputs = {"en": bool(rng.randrange(2))}
                for field, addition in packet_fields.items():
                    size = 1 if addition == "bool" else width + (extra if addition is None else addition)
                    inputs["data." + field] = 0 if i == 0 else rng.randrange(1 << size)
                trace.append({"reset": i in [0, 27], "inputs": inputs})
            def expected(entries):
                state, records = {field: 0 for field in packet_fields}, []
                def output():
                    result = {}
                    for field, addition in packet_fields.items():
                        size = 1 if addition == "bool" else other_width + (extra if addition is None else addition)
                        result["out." + field] = state[field] & ((1 << size) - 1)
                    return result
                for entry in entries:
                    pre = output()
                    if entry.get("reset") or entry["inputs"]["en"]:
                        state = {field: entry["inputs"]["data." + field] for field in packet_fields}
                    records.append({"pre": pre, "post": output()})
                return records
            factories = {root: {"class": "configuration.TestConfig", "args": [w, True, 0]}
                         for root, w in [("p", width), ("other", other_width)]}
            check("ConfiguredBundlePipeline", factories, {"extra": extra}, trace, expected,
                  f"bundle-{width}-{other_width}-extra{extra}")

    ir_path, parameters, correct, trace = binding_witness
    descriptor = json.loads(ir_path.read_text())["configuration"]["fields"]
    names = {(f["root"], f["key"], tuple(f["selectors"])): f["name"] for f in descriptor}
    wrong = dict(parameters)
    for field in descriptor:
        other_root = "other" if field["root"] == "p" else "p"
        wrong[field["name"]] = parameters[names[(other_root, field["key"], tuple(field["selectors"]))]]
    code, faulty = simulate(ir_path, wrong, trace, None, args.evidence / "negative-root-binding")
    binding_error_detected = code == 0 and any(a["post"] != b["post"] for a, b in zip(correct, faulty))
    if not binding_error_detected:
        raise RuntimeError("Swapped child configuration roots were not detected")

    rejections = []
    rejection_sources = [(name, [SOURCE, ROOT / "tests/fixtures/configuration/Rejected.scala"])
                         for name in ["DynamicKey", "CollectionField", "EagerInherited", "ForwardValue", "ExplicitSuper", "RecursiveGetter", "OverloadedGetter", "OverrideVal"]]
    rejected_hierarchy = ROOT / "tests/fixtures/configuration/RejectedHierarchy.scala"
    rejection_sources += [("LocalChildConfiguration", [SOURCE, HIERARCHY, rejected_hierarchy]),
                          ("MissingBundleSource", [SOURCE, rejected_hierarchy])]
    for name, sources in rejection_sources:
        destination = args.evidence / "rejected" / name
        generated_attempt = destination / ("generated-" + uuid.uuid4().hex[:10])
        command = [sys.executable, str(ROOT / "scripts/chisel2lean.py"), *(str(p) for p in sources), "--module", "rejectedconfiguration." + name,
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
               "evidence_directory": str(args.evidence),
               "source_sha256": {p.relative_to(ROOT).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest() for p in [SOURCE, HIERARCHY]},
               "compiler_sha256": json.loads((output / "manifest.json").read_text())["compiler_sha256"],
               "cycles": sum(c["cycles"] for c in cases), "output_comparisons": sum(c["output_comparisons"] for c in cases),
               "swapped_child_configuration_roots_detected": binding_error_detected,
               "formal_source_to_lean_equivalence_proof": False}
    write(args.evidence / "summary.json", summary)
    write(ROOT / "docs/validation-configuration-7.3.json", summary)
    print(f"PASS: {len(cases)} configurations, {len(rejections)} explicit rejections")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
