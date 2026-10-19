"""Check @LeanParam retention, inheritance/CDE binding, behavior and explicit rejections."""
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
import datetime as dt
import hashlib
import json
from pathlib import Path
import random
import subprocess
import sys
import uuid

from chisel2lean import translate
from common import ROOT, run_logged, sbt_command
from differential import flat_outputs
from materialize_config import materialize
from rtl import run_emitted_rtl, run_rtl
from simulate import eval_param, simulate

SOURCES = [ROOT / "tests/fixtures/leanparam" / name for name in ("Supported.scala", "Lookalike.scala")]


def write(path: Path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2), encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skip-build", action="store_true")
    parser.add_argument("--evidence", type=Path, default=ROOT / "experiments/leanparam-7.3")
    args = parser.parse_args()
    stamp = dt.datetime.now(dt.timezone.utc).strftime("%Y%m%dT%H%M%SZ") + "-" + uuid.uuid4().hex[:8]
    evidence = args.evidence.resolve() / stamp
    if not args.skip_build:
        cmd, env = sbt_command(["writeToolClasspath", "reference/writeReferenceClasspath"])
        if code := run_logged(cmd, evidence / "build", env=env):
            return code
    output = evidence / "generated"
    classpath = ROOT / ".cache/reference-classpath.txt"
    if code := translate(SOURCES, output, None, classpath.read_text().strip(), True):
        return code
    standalone_source = ROOT / "examples/leanparam/Counter.scala"
    standalone = evidence / "standalone"
    if code := translate([standalone_source], standalone, "example.Counter", None, True):
        return code
    standalone_ir = json.loads((standalone / "example/Counter.ir.json").read_text())
    assert standalone_ir["parameters"] == [{"name": "n", "field": "n", "kind": "Int"}]
    assert standalone_ir["leanParameters"]["declarations"][0]["dependencies"] == ["n"]

    def load(name):
        path = output / "leanparam" / (name + ".ir.json")
        return path, json.loads(path.read_text(encoding="utf-8"))

    # Assert semantic relationships as well as the presence of annotation metadata.
    metadata_checks = []
    metadata_checks.append({"module": "example.Counter", "status": "PASS", "extra_classpath": False, "lean_checked": True})
    for name, expressions, params in [
        ("AnnotatedBank", {"n": 3, "w": 4, "extra": True, "width": 5, "lanes": 3}, {"n": 3, "w": 4, "extra": True}),
        ("AnnotatedCounter", {"n": 9}, {"n": 9}),
        ("RenamedParameter", {"n": 4, "width": 5}, {"n": 4}),
    ]:
        _, ir = load(name)
        declarations = ir["leanParameters"]["declarations"]
        assert len(declarations) == len(expressions), name
        assert {p["name"] for p in ir["parameters"]} == set(params), name
        for mark in declarations:
            assert eval_param(mark["expression"], params) == expressions[mark["name"]], mark
            assert mark["dependencies"] and set(mark["dependencies"]) <= set(params), mark
            assert mark["source"]["line"] > 0 and mark["source"]["column"] > 0, mark
        metadata_checks.append({"module": name, "status": "PASS", "declarations": len(declarations)})
    _, hierarchy = load("AnnotatedHierarchy")
    marks = hierarchy["leanParameters"]["declarations"]
    assert len(marks) == 2 and {tuple(m["instance"]) for m in marks} == {(), ("child",)}
    for mark in marks:
        assert eval_param(mark["expression"], {"n": 3}) == (4 if mark["instance"] else 3), mark
    metadata_checks.append({"module": "AnnotatedHierarchy", "status": "PASS", "declarations": 2})
    _, configured = load("AnnotatedConfiguration")
    marks = configured["leanParameters"]["declarations"]
    fields = {f["selectors"][-1]: f for f in configured["configuration"]["fields"]}
    assert {m["name"] for m in marks} == {"width", "enabled"}
    for mark in marks:
        field = fields[mark["name"]]
        assert field["root"] == "p" and field["key"] == "leanparam.SettingsKey"
        assert mark["expression"] == {"kind": "name", "name": field["name"]}, mark
    metadata_checks.append({"module": "AnnotatedConfiguration", "status": "PASS", "declarations": 2})
    for name in ("Unannotated", "IgnoredLookalike"):
        _, ir = load(name)
        assert "leanParameters" not in ir and ir["parameters"][0]["name"] == "n", name
        metadata_checks.append({"module": name, "status": "PASS", "explicit_annotations": 0})

    cases = []

    def check(name, parameters, label, factories=None):
        path, ir = load(name)
        folder = evidence / label
        if factories is not None:
            snapshot = materialize(path, factories, {}, folder / "configuration.json", classpath, folder / "config", folder / "rtl")
            parameters = snapshot["parameters"]
        rng = random.Random(20261014 + len(cases))
        if name == "AnnotatedBank":
            n, width = parameters["n"], parameters["w"] + 1
            trace = [{"reset": i in (0, 31), "inputs": {"data": [rng.randrange(1 << width) for _ in range(n)]}} for i in range(64)]
        elif name in ("AnnotatedCounter", "AnnotatedHierarchy"):
            width = parameters["n"] + int(name == "AnnotatedHierarchy")
            trace = [{"reset": i in (0, 31), "inputs": {"en": i % 7 != 0}} for i in range(64)]
        else:
            width = parameters["n"] + int(name == "RenamedParameter") if factories is None else parameters[fields["width"]["name"]]
            trace = [{"inputs": {"data": rng.randrange(1 << width)}} for _ in range(64)]
        code, lean = simulate(path, parameters, trace, None, folder / "lean")
        if factories is None:
            code2, rtl = run_rtl(path, parameters, trace, folder / "reference")
        else:
            code2, rtl = run_emitted_rtl(folder / "rtl", json.loads((folder / "rtl/ports.json").read_text()), trace, folder / "reference")
        if code or code2 or len(lean) != len(trace) or len(rtl) != len(trace):
            raise RuntimeError(f"Execution failed: {folder}")
        mask, records = (1 << width) - 1, []
        state = [0] * parameters["n"] if name == "AnnotatedBank" else 0
        for entry in trace:
            if name == "AnnotatedBank":
                pre = {"out": state}
                state = [0] * parameters["n"] if entry.get("reset") else [(v + int(parameters["extra"])) & mask for v in entry["inputs"]["data"]]
                records.append({"pre": pre, "post": {"out": state}})
            elif name in ("AnnotatedCounter", "AnnotatedHierarchy"):
                pre = {"out": state}
                state = 0 if entry.get("reset") else (state + int(entry["inputs"]["en"])) & mask
                records.append({"pre": pre, "post": {"out": state}})
            else:
                value = entry["inputs"]["data"]
                if name == "RenamedParameter" or (factories is not None and parameters[fields["enabled"]["name"]]):
                    value ^= mask
                elif name == "IgnoredLookalike":
                    value = (value + 4) & mask
                records.append({"pre": {"out": value}, "post": {"out": value}})
        comparisons = 0
        for i, (a, b, spec) in enumerate(zip(lean, rtl, records)):
            for sampling in ("pre", "post"):
                actual, expected = flat_outputs(a[sampling], ir["signals"]), flat_outputs(spec[sampling], ir["signals"])
                if actual != flat_outputs(b[sampling]) or actual != expected:
                    write(folder / "mismatch.json", {"cycle": i, "lean": a, "rtl": b, "expected": spec})
                    raise RuntimeError(f"Behavior mismatch: {folder}")
                comparisons += len(actual)
        result = {"status": "PASS", "module": name, "parameters": parameters, "cycles": len(trace), "output_comparisons": comparisons,
                  "comparison": "executed Lean == official Chisel 7.3 RTL == independent integer specification"}
        write(folder / "summary.json", result)
        cases.append(result)
        print(label + ": PASS", flush=True)

    for n, w, extra in [(1, 1, False), (3, 4, True), (5, 8, False), (2, 63, True)]:
        check("AnnotatedBank", {"n": n, "w": w, "extra": extra}, f"bank-{n}-{w}-{extra}")
    for n in (1, 9):
        check("AnnotatedCounter", {"n": n}, f"counter-{n}")
    check("AnnotatedHierarchy", {"n": 3}, "hierarchy-3")
    check("RenamedParameter", {"n": 4}, "inherited-4")
    for w, enabled in [(3, False), (9, True)]:
        check("AnnotatedConfiguration", {}, f"configuration-{w}-{enabled}", {"p": {"class": "leanparam.TestConfig", "args": [w, enabled]}})
    check("Unannotated", {"n": 3}, "legacy-unannotated")
    check("IgnoredLookalike", {"n": 4}, "foreign-annotation-symbol")

    rejections = []
    negative_source = ROOT / "tests/fixtures/leanparam/Rejected.scala"
    diagnostics = {
        "WrongScalar": "supports Int and Boolean", "MutableParameter": "mutable constructor", "MutableMember": "mutable",
        "LazyMember": "lazy", "HardwareValue": "supports Int and Boolean", "MethodArgument": "must mark",
        "ClassTarget": "must mark", "LocalTarget": "must mark", "CollectionMember": "supports Int and Boolean",
        "ConstantMember": "constant cannot introduce a parameter family", "UnsupportedComputation": "@LeanParam",
        "ConditionalAllocation": "Conditional register declarations", "RepeatedAllocation": "dependent instance/port/state layout",
        "OptionalPort": "dependent instance/port/state layout",
        "TypeUse": "must annotate a declaration rather than a type use",
        "BundleTarget": "@LeanParam on Bundle declarations is not yet supported",
    }
    for name, expected in diagnostics.items():
        folder = evidence / "rejected" / name
        destination = folder / "generated"
        command = [sys.executable, str(ROOT / "scripts/chisel2lean.py"), *(str(p) for p in SOURCES), str(negative_source),
                   "--module", "rejectedleanparam." + name, "--classpath-file", str(classpath), "--out", str(destination), "--no-check"]
        proc = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, encoding="utf-8", errors="replace")
        diagnostic = proc.stdout + proc.stderr
        valid = (proc.returncode != 0 and ".scala:" in diagnostic and "[chisel2lean]" in diagnostic and expected in diagnostic
                 and not (destination / "manifest.json").exists())
        write(folder / "result.json", {"exit_code": proc.returncode, "expected_diagnostic": expected, "status": "PASS" if valid else "FAIL"})
        (folder / "stdout.log").write_text(proc.stdout, encoding="utf-8")
        (folder / "stderr.log").write_text(proc.stderr, encoding="utf-8")
        if not valid:
            raise RuntimeError(f"Expected explicit rejection of {name}:\n{diagnostic}")
        rejections.append({"module": name, "status": "PASS", "diagnostic": expected})
        print("reject " + name + ": PASS", flush=True)

    manifest = json.loads((output / "manifest.json").read_text())
    report = {"status": "PASS", "format": "chisel2lean-leanparam-validation-v1", "metadata_checks": metadata_checks,
              "configurations": len(cases), "cycles": sum(c["cycles"] for c in cases),
              "output_comparisons": sum(c["output_comparisons"] for c in cases), "cases": cases, "rejections": rejections,
              "compiler_sha256": manifest["compiler_sha256"], "annotation_sha256": manifest["annotation_sha256"],
              "source_sha256": {p.relative_to(ROOT).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest() for p in [*SOURCES, standalone_source, negative_source]},
              "evidence_directory": str(evidence), "formal_source_to_lean_equivalence_proof": False,
              "structural_module_arrays_and_option_layouts_supported": False}
    write(evidence / "summary.json", report)
    write(ROOT / "docs/validation-leanparam-7.3.json", report)
    print(f"PASS: {len(cases)} configurations, {report['cycles']} cycles, {len(rejections)} source rejections")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
