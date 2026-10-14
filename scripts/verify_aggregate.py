"""Compare parameterized Vec[Bundle] models with official RTL and integer specifications."""
from __future__ import annotations

import argparse
from copy import deepcopy
import hashlib
import json
import os
from pathlib import Path
import random

from chisel2lean import translate
from common import ROOT, java_executable, lean_executable, rtl_environment, run_logged, sbt_command
from differential import flat_outputs, random_value
from rtl import run_rtl
from simulate import simulate

SOURCE = ROOT / "tests/fixtures/aggregate/Supported.scala"
FIELDS = ("data", "lanes", "meta.code", "meta.flag", "signed", "valid")


def write(path: Path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2), encoding="utf-8")


def packet(values, root):
    return {f: deepcopy(values[root + "." + f]) for f in FIELDS}


def ports(root, values):
    return {root + "." + f: deepcopy(value) for f, value in values.items()}


def resize_packet(values, source_width, target_width):
    def convert(value, field):
        if isinstance(value, list):
            return [convert(v, field) for v in value]
        if field in ("meta.flag", "valid"):
            return bool(value)
        extra = int(field in ("meta.code", "signed"))
        if field == "signed" and value >= 1 << source_width:
            value -= 1 << (source_width + 1)
        return value % (1 << (target_width + extra))
    return {f: convert(values[f], f) for f in FIELDS}


def specification(name, params, trace):
    state = packet(trace[0]["inputs"], "data") if name in (
        "BundleVectorPipeline", "BundleVectorWrites", "NestedBundleVector", "BundleVectorHierarchy") else None
    records = []

    def observe(values, current):
        n, m = params.get("n", 1), params.get("m", 2)
        index = values.get("index", 0) & ((1 << (n - 1).bit_length()) - 1)
        if name == "BundleVectorPipeline":
            selected = {f: current[f][index] for f in FIELDS}
            mixed = packet(values, "data") if values["choose"] else current
            return ports("out", current) | ports("selected", selected) | ports("mixed", mixed)
        if name in ("BundleVectorWrites", "BundleVectorHierarchy"):
            return ports("out", current)
        if name == "NestedBundleVector":
            lane = values["lane"] & ((1 << (m - 1).bit_length()) - 1)
            return ports("out", current) | ports("selected", {f: current[f][index][lane] for f in FIELDS})
        if name == "BundleVectorConstruct":
            data, one = packet(values, "data"), packet(values, "packet")
            repeated = {f: [deepcopy(one[f]) for _ in range(n)] for f in FIELDS}
            pair = {f: [data[f][0], one[f]] for f in FIELDS}
            generated = deepcopy(data)
            generated["valid"] = [not v for v in data["valid"]]
            return ports("repeated", repeated) | ports("tabulated", data) | ports("literal", pair) | ports("generated", generated)
        if name == "BundleVectorResize":
            return ports("out", resize_packet(packet(values, "data"), params["wi"], params["wo"]))
        if name == "BundleVectorMux":
            a = resize_packet(packet(values, "a"), params["wi"], params["wo"])
            b = resize_packet(packet(values, "b"), params["wi"], params["wo"])
            pair = {f: [a[f][0], b[f][0]] for f in FIELDS}
            return ports("out", a if values["choose"] else b) | ports("pair", pair)
        raise ValueError(name)

    for entry in trace:
        values = entry["inputs"]
        pre = observe(values, state)
        if state is not None:
            old, nxt = state, deepcopy(state)
            if entry.get("reset"):
                nxt = packet(values, "data")
            elif name == "BundleVectorPipeline":
                if values["enable"]:
                    nxt = packet(values, "data")
            elif name == "BundleVectorHierarchy":
                nxt = packet(values, "data")
            elif name == "BundleVectorWrites":
                n, m = params["n"], params["m"]
                index_mask, lane_mask = (1 << (n - 1).bit_length()) - 1, (1 << (m - 1).bit_length()) - 1
                i, j = values["index"] & index_mask, values["other"] & index_mask
                a, b = values["lane"] & lane_mask, values["otherLane"] & lane_mask
                patch, data = packet(values, "patch"), packet(values, "data")
                if values["write"]:
                    for f in FIELDS:
                        nxt[f][i] = deepcopy(patch[f])
                if values["overrideData"]:
                    nxt["data"][i] = (old["data"][i] + 1) % (1 << params["w"])
                    nxt["meta.code"][j] = patch["meta.code"]
                if values["updateLanes"]:
                    nxt["lanes"][i][a] = patch["lanes"][a]
                    nxt["lanes"][j][b] = data["lanes"][j][b]
            elif name == "NestedBundleVector":
                i = values["index"] & ((1 << (params["n"] - 1).bit_length()) - 1)
                j = values["lane"] & ((1 << (params["m"] - 1).bit_length()) - 1)
                if values["write"]:
                    patch = packet(values, "patch")
                    for f in FIELDS:
                        nxt[f][i][j] = deepcopy(patch[f])
                    nxt["meta.flag"][0][0] = not old["meta.flag"][0][0]
                    nxt["lanes"][i][j][1] = old["lanes"][i][j][0]
            state = nxt
        records.append({"pre": pre, "post": observe(values, state)})
    return records


def make_trace(ir, parameters, cycles, seed):
    rng = random.Random(seed)
    signals = [s for s in ir["signals"] if s["kind"] == "input"]
    trace = []
    for cycle in range(cycles):
        values = {s["name"]: random_value(s["type"], parameters, rng) for s in signals}
        for names, size in [(('index', 'other'), parameters.get("n", 1)), (('lane', 'otherLane'), parameters.get("m", 2))]:
            width = (size - 1).bit_length()
            for position, name in enumerate(names):
                if name in values:
                    # Include upper bits to test Chisel's index truncation. Cycle
                    # groups force both colliding and noncolliding writes.
                    low = (cycle + (position if cycle % 4 == 0 else 0)) % size
                    values[name] = low + ((cycle % (1 << (8 - width))) << width)
        for bit, name in enumerate(("write", "overrideData", "updateLanes", "enable", "choose")):
            if name in values:
                values[name] = bool((cycle >> bit) & 1)
        trace.append({"reset": cycle in (0, cycles // 2, cycles - 1), "inputs": values})
    return trace


def cached_case(folder, ir_path, ir, parameters, trace):
    saved = folder / "summary.json"
    if not saved.is_file():
        return None
    previous = json.loads(saved.read_text())
    hashes = {"ir_sha256": hashlib.sha256(ir_path.read_bytes()).hexdigest(),
              "lean_sha256": hashlib.sha256(ir_path.with_name(ir_path.name.replace(".ir.json", ".lean")).read_bytes()).hexdigest()}
    if previous.get("status") != "PASS" or any(previous.get(k) != v for k, v in hashes.items()):
        return None
    if json.loads((folder / "trace.json").read_text()) != trace:
        return None
    runtime = ROOT / "experiments/aggregate-mux-contract-7.3/runtime-before.json"
    recorded_runtime = previous.get("runtime_sha256") or (json.loads(runtime.read_text()) if runtime.is_file() else {})
    if not recorded_runtime or any(hashlib.sha256((ROOT / p).read_bytes()).hexdigest() != digest for p, digest in recorded_runtime.items()):
        return None
    target = folder / "regeneration/rtl"
    target.mkdir(parents=True, exist_ok=True)
    classpath = (ROOT / ".cache/reference-classpath.txt").read_text().strip()
    values = [str(parameters[p["name"]]).lower() for p in ir["parameters"]]
    command = [java_executable(), "-Xmx2g", "-cp", classpath, "reference.GenerateRTL", ir["module"], str(target), *values]
    if run_logged(command, folder / "regeneration/elaboration", env=rtl_environment(), echo=False):
        return None
    old = folder / "reference/rtl"
    metadata = json.loads((old / "ports.json").read_text())
    paths = ["ports.json", metadata["top"] + ".v"]
    if any((old / p).read_bytes() != (target / p).read_bytes() for p in paths):
        return None
    lean = json.loads((folder / "lean/result.json").read_text())
    rtl = json.loads((folder / "reference/result.json").read_text())
    if len(lean) != len(trace) or len(rtl) != len(trace):
        return None
    stateful = any(s["kind"] == "reg" for s in ir["signals"])
    for cycle, (a, b, expected) in enumerate(zip(lean, rtl, specification(ir["module"].split(".")[-1], parameters, trace))):
        for sampling in ("pre", "post"):
            actual = flat_outputs(a[sampling], ir["signals"])
            if actual != flat_outputs(expected[sampling], ir["signals"]):
                return None
            if not (stateful and cycle == 0 and sampling == "pre") and actual != b[sampling]:
                return None
    result = previous | {"verification": "reused executed traces after byte-identical IR, Lean, runtime, regenerated official RTL and port-map checks",
                         "previous_source_sha256": previous["source_sha256"],
                         "source_sha256": hashlib.sha256(SOURCE.read_bytes()).hexdigest(), "runtime_sha256": recorded_runtime}
    write(folder / "regeneration/summary.json", result)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skip-build", action="store_true")
    parser.add_argument("--skip-translate", action="store_true")
    parser.add_argument("--evidence", type=Path, default=ROOT / "experiments/aggregate-7.3")
    parser.add_argument("--generated", type=Path, default=ROOT / "generated/aggregate-validation")
    parser.add_argument("--only", help="run one module")
    parser.add_argument("--resume", action="store_true", help="reuse traces only after identical model/runtime and freshly regenerated official RTL checks")
    args = parser.parse_args()
    args.evidence = args.evidence.resolve()
    output = args.generated.resolve()
    classpath = ROOT / ".cache/reference-classpath.txt"
    if not args.skip_build:
        command, env = sbt_command(["writeToolClasspath", "reference/writeReferenceClasspath"])
        if code := run_logged(command, args.evidence / "build", env=env):
            return code
    if not args.skip_translate and (code := translate([SOURCE], output, None, classpath.read_text().strip(), True)):
        return code
    proof = ROOT / "verification/aggregate/VectorPipelineProof.lean"
    env = os.environ.copy()
    env["LEAN_PATH"] = str(output)
    if code := run_logged([lean_executable(), str(proof)], args.evidence / "model-proof", env=env):
        return code
    cases = []
    ordinary = [(1, 1, 1), (3, 3, 5), (4, 2, 65)]
    matrix = [(1, 1, 1), (3, 2, 4), (2, 3, 65)]
    configurations = [(name, {"n": n, "w": w, "m": m})
                      for name in ["BundleVectorPipeline", "BundleVectorWrites", "BundleVectorConstruct", "BundleVectorHierarchy"]
                      for n, m, w in ordinary]
    configurations += [("NestedBundleVector", {"n": n, "m": m, "w": w}) for n, m, w in matrix]
    configurations += [(name, {"n": n, "wi": wi, "wo": wo})
                       for name in ["BundleVectorResize", "BundleVectorMux"]
                       for n, wi, wo in [(1, 1, 5), (3, 5, 2), (2, 65, 7), (3, 2, 65)]]
    for number, (name, parameters) in enumerate(configurations):
        if args.only and name != args.only:
            continue
        label = name + "-" + "-".join(f"{k}{v}" for k, v in parameters.items())
        folder = args.evidence / label
        ir_path = output / "aggregate" / (name + ".ir.json")
        ir = json.loads(ir_path.read_text(encoding="utf-8"))
        trace = make_trace(ir, parameters, 64, 20261014 + number)
        if args.resume and (cached := cached_case(folder, ir_path, ir, parameters, trace)):
            cases.append(cached)
            print(label + ": PASS (identical models/RTL; traces replayed)", flush=True)
            continue
        write(folder / "trace.json", trace)
        code, lean = simulate(ir_path, parameters, trace, None, folder / "lean")
        if code:
            raise RuntimeError(f"Lean execution failed: {folder}")
        code, rtl = run_rtl(ir_path, parameters, trace, folder / "reference")
        if code or len(lean) != len(rtl):
            raise RuntimeError(f"RTL execution failed: {folder}")
        expected = specification(name, parameters, trace)
        compared = 0
        stateful = any(s["kind"] == "reg" for s in ir["signals"])
        for cycle, (a, b, spec) in enumerate(zip(lean, rtl, expected)):
            for sampling in ("pre", "post"):
                x = flat_outputs(a[sampling], ir["signals"])
                y = flat_outputs(spec[sampling], ir["signals"])
                # A register has no specified power-on value before reset.
                compare_rtl = not (stateful and cycle == 0 and sampling == "pre")
                if x != y or (compare_rtl and x != b[sampling]):
                    write(folder / "mismatch.json", {"cycle": cycle, "sampling": sampling, "lean": x, "rtl": b[sampling], "expected": y})
                    raise RuntimeError(f"Aggregate mismatch: {folder}")
                if compare_rtl:
                    compared += len(x)
        result = {"status": "PASS", "module": ir["module"], "parameters": parameters, "cycles": len(trace),
                  "output_comparisons": compared, "source_sha256": hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
                  "ir_sha256": hashlib.sha256(ir_path.read_bytes()).hexdigest(),
                  "lean_sha256": hashlib.sha256(ir_path.with_name(name + ".lean").read_bytes()).hexdigest()}
        result["verification"] = "fresh Lean and official RTL execution"
        result["runtime_sha256"] = {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                                    for p in [ROOT / "lean/Chisel2Lean/Runtime.lean", ROOT / "scripts/simulate.py"]}
        write(folder / "summary.json", result)
        cases.append(result)
        print(label + ": PASS", flush=True)
    report = {"status": "PASS", "chisel_version": "7.3.0", "lean_version": "4.19.0",
              "comparison": "executed Lean == official original Chisel RTL == independent integer specification",
              "configurations": len(cases), "cycles": sum(c["cycles"] for c in cases),
              "output_comparisons": sum(c["output_comparisons"] for c in cases),
              "compiler_sha256": json.loads((output / "manifest.json").read_text())["compiler_sha256"],
              "model_theorems": 3, "model_proof": "verification/aggregate/VectorPipelineProof.lean",
              "formal_equivalence_proof": False, "cases": cases}
    write(args.evidence / "summary.json", report)
    if not args.only:
        write(ROOT / "docs/validation-aggregate-7.3.json", report)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
