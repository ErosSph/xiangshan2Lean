"""Fresh Chisel 7.3 -> CIRCT SSA -> Lean vs independent official RTL and integer specs."""
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
from pathlib import Path
import random
import re

from common import ROOT, run_logged, sbt_command
from elaborate_chisel import elaborate
from firrtl2lean import translate_firrtl
from firrtl_simulate import simulate_firrtl
from rtl import get_value, run_emitted_rtl
from verify_xiangshan_firrtl import alu_spec, signed


def read(path):
    return json.loads(path.read_text(encoding="utf-8"))


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2), encoding="utf-8")


def run_case(name, module, constructor, cp, evidence, make_trace, specification, source_files=()):
    folder = evidence / name
    original, model = folder / "original", folder / "model"
    provenance = elaborate(module, constructor, cp, original, folder / "elaboration")
    if translate_firrtl(original / "design.fir", model, namespace="Modern." + name, frontend="circt"):
        raise RuntimeError("Modern translation failed: " + name)
    ir_path = model / "Modern" / (name + ".ir.json")
    ir, metadata = read(ir_path), read(original / "ports.json")
    trace = make_trace(metadata)
    write(folder / "trace.json", trace)
    mapping = {p["name"]: p["rtl_name"] for p in metadata["ports"] if p["name"] != "clock"}
    expected_inputs = {s["name"] for s in ir["signals"] if s["kind"] == "input"}
    converted = []
    for row in trace:
        values = {p["rtl_name"]: int(row.get("reset", False) if p["name"] == "reset" else get_value(row["inputs"], p["name"]))
                  for p in metadata["ports"] if p["direction"] == "input" and p["name"] != "clock"}
        if set(values) != expected_inputs:
            raise RuntimeError("Modern port mapping is not total")
        converted.append({"inputs": values})
    initial = {s["name"]: 0 for s in ir["signals"] if s["kind"] == "reg"}
    code, lean = simulate_firrtl(ir_path, converted, initial, folder / "lean")
    if code:
        raise RuntimeError("Lean execution failed: " + name)
    code, rtl = run_emitted_rtl(original, metadata, trace, folder / "reference")
    if code or len(lean) != len(trace) or len(rtl) != len(trace):
        raise RuntimeError("Incomplete official RTL/Lean execution: " + name)
    spec = specification(trace, metadata)
    if len(spec) != len(trace):
        raise RuntimeError("Incomplete integer specification")
    comparisons = math_checks = 0
    for i, (actual, expected, integer) in enumerate(zip(lean, rtl, spec)):
        for phase in ("pre", "post"):
            mapped = {n: actual[phase][mapping[n]] for n in expected[phase]}
            if mapped != expected[phase] or any(mapped[n] != v for n, v in integer[phase].items()):
                write(folder / "mismatch.json", {"cycle": i, "trace": trace[i], "lean": mapped,
                                                "rtl": expected[phase], "integer": integer[phase], "phase": phase})
                raise RuntimeError(f"Modern differential mismatch: {name}, cycle {i}, {phase}")
            comparisons += len(mapped)
            math_checks += len(integer[phase])
    source_hashes = {p.relative_to(ROOT).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest() for p in source_files}
    payload = read(model / "circt.json")
    modules = [o for o in payload["circuit"]["regions"][0]["operations"] if o["name"] == "firrtl.module"]
    instances = sum(op["name"] == "firrtl.instance" for m in modules for op in m["regions"][0]["operations"])
    result = {"status": "PASS", "case": name, "module": module, "constructor": constructor,
              "cycles": len(trace), "output_comparisons": comparisons, "independent_integer_checks": math_checks,
              "state_fields": len(initial), "submodule_instances": instances, "signals": len(ir["signals"]),
              "initial_state": initial, "initialization_claim": "explicit zero experiment state; RTL --x-initial 0; no power-on guarantee",
              "comparison": "executed Lean == independently elaborated official Chisel RTL; integer spec checks listed outputs",
              "original_sources_sha256": source_hashes, "elaboration": provenance,
              "manifest": read(model / "manifest.json"), "formal_translation_equivalence": False}
    write(folder / "summary.json", result)
    print(f"PASS {name}: {len(trace)} cycles, {comparisons} comparisons, {math_checks} integer checks", flush=True)
    return result


def counters(width):
    rng = random.Random(14000 + width)
    def trace(_):
        return [{"reset": i % 67 == 0, "inputs": {"io.en": int(i < 32 or rng.randrange(2))}} for i in range(256)]
    def spec(rows, _):
        state, results = 0, []
        for row in rows:
            pre = {"io.q": state}
            state = 0 if row["reset"] else (state + row["inputs"]["io.en"]) % (1 << width)
            results.append({"pre": pre, "post": {"io.q": state}})
        return results
    return trace, spec


def handshake(width, stages):
    rng = random.Random(24000 + width + stages)
    def trace(_):
        return [{"reset": i % 83 == 0,
                 "inputs": {"io.in.valid": 0 if i == 0 else rng.randrange(2),
                            "io.in.bits": rng.getrandbits(width),
                            "io.out.ready": int(i % 32 >= 12) if i < 128 else rng.randrange(2)}} for i in range(384)]
    def spec(rows, _):
        valids, data, result = [0] * stages, [0] * stages, []
        def observe(row):
            ready = int(row["inputs"]["io.out.ready"])
            for v in reversed(valids):
                ready = int(not v or ready)
            return {"io.in.ready": ready, "io.out.valid": valids[-1], "io.out.bits": data[-1]}
        for row in rows:
            pre = observe(row)
            ready, next_valids, next_data = int(row["inputs"]["io.out.ready"]), valids.copy(), data.copy()
            for i in reversed(range(stages)):
                ready = int(not valids[i] or ready)
                valid_in = valids[i - 1] if i else row["inputs"]["io.in.valid"]
                data_in = data[i - 1] if i else row["inputs"]["io.in.bits"]
                if ready:
                    next_valids[i] = valid_in
                    if valid_in:
                        next_data[i] = data_in
                if row["reset"]:
                    next_valids[i] = 0
            valids, data = next_valids, next_data
            result.append({"pre": pre, "post": observe(row)})
        return result
    return trace, spec


def signed_arithmetic(width):
    rng = random.Random(34000 + width)
    mask = (1 << width) - 1
    patterns = [0, 1, mask, 1 << (width - 1), (1 << (width - 1)) - 1]
    def trace(_):
        pairs = [(a, b) for a in patterns for b in patterns] + [(rng.getrandbits(width), rng.getrandbits(width)) for _ in range(128)]
        return [{"inputs": {"io.a": a, "io.b": b}} for a, b in pairs]
    def spec(rows, _):
        result = []
        for row in rows:
            a, b = [signed(row["inputs"][n], width) for n in ("io.a", "io.b")]
            values = {"io.sum": (a + b) & mask, "io.wide": (a + b) % (1 << (width + 1)),
                      "io.product": (a * b) % (1 << (width * 2)), "io.extended": a % (1 << (width + 2)),
                      "io.shr": (a >> 1) & mask, "io.less": int(a < b)}
            result.append({"pre": values, "post": values})
        return result
    return trace, spec


def prefetch():
    rng = random.Random(44000)
    def trace(metadata):
        names = [p["name"] for p in metadata["ports"] if p["direction"] == "input" and p["name"] not in {"clock", "reset"}]
        width = next(p["width"] for p in metadata["ports"] if p["name"] == "io.in.bits.vpn")
        result = []
        for i in range(768):
            values = dict.fromkeys(names, 0)
            values.update({"io.in.valid": int(i > 0 and (i % 12 < 8 if i < 192 else rng.randrange(2))),
                           "io.in.bits.vpn": ((i // 6) * 8) % (1 << width) if i < 192 else rng.getrandbits(width),
                           "io.out.ready": int(i % 24 >= 12) if i < 192 else rng.randrange(2),
                           "io.sfence.valid": int(i % 101 == 90), "io.csr.satp.changed": int(i % 131 == 120)})
            result.append({"reset": i % 257 == 0, "inputs": values})
        return result
    def spec(rows, metadata):
        # Original MinimalConfig: 64-byte page-table cache line / 64-bit PTE = 8 sectors.
        widths = {p["name"]: p["width"] for p in metadata["ports"]}
        modulus = 1 << widths["io.in.bits.vpn"]
        source = 2 % (1 << widths["io.out.bits.source"])
        old_reqs, old_valids, index, next_req, valid = [0] * 4, [0] * 4, 0, 0, 0
        results = []
        def observe():
            return {"io.out.valid": valid, "io.out.bits.vpn": next_req, "io.out.bits.source": source}
        for row in rows:
            v = row["inputs"]
            pre = observe()
            flush = v["io.sfence.valid"] or v["io.csr.satp.changed"]
            next_line = ((v["io.in.bits.vpn"] // 8 + 1) * 8) % modulus
            have = any(flag and req // 8 == next_line // 8 for req, flag in zip(old_reqs, old_valids))
            input_valid = v["io.in.valid"] and not flush and not have
            fire = valid and v["io.out.ready"]
            if fire:
                old_reqs[index] = next_req
                old_valids[index] = 1
                index = (index + 1) % 4
            if flush:
                old_valids = [0] * 4
            if v["io.in.valid"]:
                next_req = next_line  # RegEnable samples independently of ValidHold/flush.
            if fire:
                valid = 0
            if input_valid:
                valid = 1
            if flush:
                valid = 0
            if row["reset"]:
                old_valids, index, valid = [0] * 4, 0, 0
            results.append({"pre": pre, "post": observe()})
        return results
    return trace, spec


def alu(upstream):
    package = (upstream / "package.scala").read_text(encoding="utf-8")
    body = package.split("object ALUOpType", 1)[1].split("object MDUOpType", 1)[0]
    labels = {int(bits.replace("_", ""), 2): label for label, bits in re.findall(r'def\s+(\w+)\s*=\s*"b([01_]+)"\.U', body)}
    mask, rng = (1 << 64) - 1, random.Random(54000)
    patterns = [0, 1, 31, 32, 63, 64, 0xffffffff, 1 << 31, 1 << 63, (1 << 63) - 1, mask]
    def trace(_):
        result = []
        for func in range(128):
            for a in patterns:
                for b in patterns:
                    result.append({"inputs": {"io.src.0": a, "io.src.1": b, "io.func": func,
                                               "io.pred_taken": (a ^ b) & 1, "io.isBranch": int(func >= 112)}})
        result += [{"inputs": {"io.src.0": rng.getrandbits(64), "io.src.1": rng.getrandbits(64),
                                "io.func": rng.randrange(128), "io.pred_taken": rng.randrange(2), "io.isBranch": rng.randrange(2)}}
                   for _ in range(512)]
        return result
    def spec(rows, _):
        results = []
        for row in rows:
            v = row["inputs"]
            a, b, func = v["io.src.0"], v["io.src.1"], v["io.func"]
            logic_b = b ^ (mask if not (func & 32) and (func & 1) else 0)
            taken = {0: int(a == logic_b), 2: int(signed(a) < signed(b)), 3: int(a < b)}.get((func >> 2) & 3, 0) ^ ((func >> 1) & 1)
            values = {"io.taken": taken, "io.mispredict": (taken ^ v["io.pred_taken"]) & v["io.isBranch"]}
            value = alu_spec(labels.get(func), a, b)
            if value is not None:
                values["io.result"] = value
            results.append({"pre": values, "post": values})
        return results
    return trace, spec


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skip-build", action="store_true")
    parser.add_argument("--case", action="append", help="Run selected case(s); default all")
    parser.add_argument("--evidence", type=Path, default=ROOT / "experiments/modern-firrtl-7.3")
    args = parser.parse_args()
    evidence = args.evidence.resolve()
    if not args.skip_build:
        cmd, env = sbt_command(["classicFirrtl/writeFirrtlClasspath", "reference/writeReferenceClasspath", "xiangshanFramework/writeXiangshanClasspath"])
        if code := run_logged(cmd, evidence / "build", env=env):
            return code
    reference_cp, xs_cp = ROOT / ".cache/reference-classpath.txt", ROOT / ".cache/xiangshan-classpath.txt"
    cases = []
    upstream = ROOT / ".cache/xiangshan-dependencies-7.3/xiangshan/src/main/scala/xiangshan"
    def add(name, module, constructor, cp, trace_and_spec, files):
        if args.case and name not in args.case:
            return
        cases.append(run_case(name, module, constructor, cp, evidence, *trace_and_spec, files))
    constructor = [{"class": "xiangshan.validation.NanhuCoreConfig", "args": []}]
    add("XSAlu", "xiangshan.backend.fu.AluDataModule", constructor, xs_cp, alu(upstream), [upstream / "backend/fu/Alu.scala", upstream / "package.scala"])
    for width in (1, 4, 9):
        add("Counter" + str(width), "probes.Counter", [width], reference_cp, counters(width), [ROOT / "audit/src/main/scala/Probes.scala"])
    for width in (4, 65):
        add("Signed" + str(width), "probes.SignedArithmetic", [width], reference_cp, signed_arithmetic(width), [ROOT / "audit/src/main/scala/Features.scala"])
    for width, stages in ((3, 1), (65, 3)):
        add(f"Handshake{width}x{stages}", "modernfixtures.HandshakeTop", [width, stages], reference_cp, handshake(width, stages),
            [ROOT / "reference/src/main/scala/Handshake.scala"])
    add("XSPrefetch", "xiangshan.cache.mmu.L2TlbPrefetch", constructor, xs_cp, prefetch(),
        [upstream / "cache/mmu/L2TlbPrefetch.scala", upstream / "cache/mmu/MMUConst.scala", upstream / "Parameters.scala"])
    if not cases:
        raise ValueError("No selected verification cases")
    summary = {"status": "PASS", "chisel_version": "7.3.0", "circt_version": "1.135.0", "lean_version": "4.19.0",
               "complete_suite": not bool(args.case), "configurations": len(cases),
               "cycles": sum(c["cycles"] for c in cases), "output_comparisons": sum(c["output_comparisons"] for c in cases),
               "independent_integer_checks": sum(c["independent_integer_checks"] for c in cases),
               "xiangshan_dependency_lock": read(ROOT / "verification/xiangshan/config-dependencies.json"),
               "formal_translation_equivalence": False, "cases": cases}
    write(evidence / "summary.json", summary)
    if summary["complete_suite"]:
        write(ROOT / "docs/validation-modern-firrtl-7.3.json", summary)
    print(json.dumps({k: v for k, v in summary.items() if k not in {"cases", "xiangshan_dependency_lock"}}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
