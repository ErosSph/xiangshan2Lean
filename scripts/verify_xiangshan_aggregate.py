"""Check Vec of original XiangShan SfenceBundle under real XSModule/CDE configuration."""
from __future__ import annotations

import argparse
from copy import deepcopy
import hashlib
import json
from pathlib import Path
import random

from chisel2lean import translate
from common import ROOT, run_logged, sbt_command
from differential import flat_outputs
from fetch_xiangshan_dependencies import CACHE, main as fetch_dependencies
from materialize_config import materialize
from rtl import run_emitted_rtl
from simulate import simulate
from verify_aggregate import write


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skip-build", action="store_true")
    parser.add_argument("--evidence", type=Path, default=ROOT / "experiments/xiangshan-aggregate-7.3")
    args = parser.parse_args()
    args.evidence = args.evidence.resolve()
    if not args.skip_build:
        fetch_dependencies()
        command, env = sbt_command(["writeToolClasspath", "xiangshanFramework/writeXiangshanClasspath"])
        if code := run_logged(command, args.evidence / "build", env=env):
            return code
    upstream = CACHE / "xiangshan/src/main/scala/xiangshan"
    sources = [ROOT / "verification/xiangshan/config/reference/Vector.scala",
               upstream / "Bundle.scala", upstream / "XSCore.scala", upstream / "Parameters.scala"]
    classpath = ROOT / ".cache/xiangshan-classpath.txt"
    output = ROOT / "generated/xiangshan-aggregate"
    if code := translate(sources, output, "xiangshan.validation.SfenceVectorPipeline", classpath.read_text().strip(), True):
        return code
    ir_path = output / "xiangshan/validation/SfenceVectorPipeline.ir.json"
    ir = json.loads(ir_path.read_text())
    projected = {(f["root"], f["key"], tuple(f["selectors"])) for f in ir["configuration"]["fields"]}
    if projected != {("p", "xiangshan.XSCoreParamsKey", (f,)) for f in ["VAddrBits", "AsidLength"]}:
        raise RuntimeError(f"Unexpected XSBundle configuration projections: {projected}")
    cases = []
    for n, address_width, asid_width in [(1, 39, 16), (3, 32, 8), (4, 48, 12)]:
        label = f"sfence-n{n}-addr{address_width}-asid{asid_width}"
        folder = args.evidence / label
        factory = {"class": "xiangshan.validation.NanhuCoreConfig", "args": []} if address_width == 39 else {
            "class": "xiangshan.validation.NanhuAddressConfig", "args": [address_width, asid_width]}
        snapshot = materialize(ir_path, {"p": factory}, {"n": n}, folder / "configuration.json", classpath,
                               folder / "config", folder / "rtl")
        fields = {"valid": 1, "bits.rs1": 1, "bits.rs2": 1, "bits.addr": address_width, "bits.asid": asid_width}
        rng = random.Random(20261014 + n)
        trace = []
        for cycle in range(64):
            width = (n - 1).bit_length()
            values = {"enable": bool(cycle & 1), "overrideAddress": bool(cycle & 2),
                      "index": (cycle % n) + ((cycle % (1 << (8 - width))) << width)}
            for f, bits in fields.items():
                values["request." + f] = [rng.randrange(1 << bits) for _ in range(n)]
                values["patch." + f] = (1 << bits) - 1 if cycle < 8 else rng.randrange(1 << bits)
            trace.append({"reset": cycle in (0, 31, 63), "inputs": values})
        write(folder / "trace.json", trace)
        code, lean = simulate(ir_path, snapshot["parameters"], trace, None, folder / "lean")
        code2, rtl = run_emitted_rtl(folder / "rtl", json.loads((folder / "rtl/ports.json").read_text()), trace, folder / "reference")
        if code or code2 or len(lean) != len(trace) or len(rtl) != len(trace):
            raise RuntimeError(f"Execution failed: {folder}")
        state = {f: deepcopy(trace[0]["inputs"]["request." + f]) for f in fields}
        compared = 0
        for cycle, (entry, a, b) in enumerate(zip(trace, lean, rtl)):
            values = entry["inputs"]
            index = values["index"] & ((1 << (n - 1).bit_length()) - 1)
            def observe(current):
                return {"result." + f: deepcopy(current[f]) for f in fields} | {
                    "selected." + f: current[f][index] for f in fields}
            pre = observe(state)
            nxt = deepcopy(state)
            if entry.get("reset"):
                nxt = {f: deepcopy(values["request." + f]) for f in fields}
            else:
                if values["enable"]:
                    for f in fields:
                        nxt[f][index] = values["patch." + f]
                if values["overrideAddress"]:
                    nxt["bits.addr"][index] = (state["bits.addr"][index] + 1) % (1 << address_width)
            state = nxt
            expected = {"pre": pre, "post": observe(state)}
            for sampling in ("pre", "post"):
                actual = flat_outputs(a[sampling], ir["signals"])
                spec = flat_outputs(expected[sampling], ir["signals"])
                compare_rtl = not (cycle == 0 and sampling == "pre")
                if actual != spec or (compare_rtl and actual != b[sampling]):
                    write(folder / "mismatch.json", {"cycle": cycle, "sampling": sampling, "lean": actual, "rtl": b[sampling], "expected": spec})
                    raise RuntimeError(f"Original XSBundle vector mismatch: {folder}")
                if compare_rtl:
                    compared += len(actual)
        result = {"status": "PASS", "test_top": ir["module"], "parameters": snapshot["parameters"],
                  "cycles": len(trace), "output_comparisons": compared,
                  "configuration_snapshot": str((folder / "configuration.json").relative_to(ROOT))}
        write(folder / "summary.json", result)
        cases.append(result)
        print(label + ": PASS", flush=True)
    report = {"status": "PASS", "configurations": len(cases), "cycles": sum(c["cycles"] for c in cases),
              "output_comparisons": sum(c["output_comparisons"] for c in cases),
              "comparison": "executed Lean == original SfenceBundle official RTL == independent specification",
              "original_bundle": "xiangshan.SfenceBundle", "local_test_top": True,
              "upstream_dependencies": "verification/xiangshan/config-dependencies.json",
              "source_sha256": {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in sources},
              "compiler_sha256": json.loads((output / "manifest.json").read_text())["compiler_sha256"],
              "formal_equivalence_proof": False, "cases": cases}
    write(args.evidence / "summary.json", report)
    write(ROOT / "docs/validation-xiangshan-aggregate-7.3.json", report)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
