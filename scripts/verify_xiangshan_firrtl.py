"""Verify ORIGINAL XiangShan v2.1 modules elaborated with the full parameter framework."""
import argparse
import hashlib
import json
from pathlib import Path
import random
import re

from common import ROOT
from firrtl2lean import translate_firrtl
from firrtl_simulate import simulate_firrtl
from rtl import run_emitted_rtl
from prepare_xiangshan_firrtl import WORK, REVISION


def read(p):
    return json.loads(p.read_text(encoding="utf-8"))


def write(p, value):
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(json.dumps(value, indent=2), encoding="utf-8")


MASK = (1 << 64) - 1


def signed(v, w=64):
    v %= 1 << w
    return v if v < 1 << (w - 1) else v - (1 << w)


def extend32(v):
    return signed(v, 32) & MASK


def alu_spec(label, a, b):
    k, kw = b & 63, b & 31
    operations = {
        "add": lambda: a + b, "sub": lambda: a - b, "adduw": lambda: (a & 0xffffffff) + b,
        "sll": lambda: a << k, "slliuw": lambda: (a & 0xffffffff) << k,
        "srl": lambda: a >> k, "sra": lambda: signed(a) >> k,
        "rol": lambda: (a << k) | (a >> ((64 - k) % 64)),
        "ror": lambda: (a >> k) | (a << ((64 - k) % 64)),
        "addw": lambda: extend32(a + b), "subw": lambda: extend32(a - b),
        "sllw": lambda: extend32(a << kw), "srlw": lambda: extend32((a & 0xffffffff) >> kw),
        "sraw": lambda: extend32(signed(a, 32) >> kw),
        "slt": lambda: int(signed(a) < signed(b)), "sltu": lambda: int(a < b),
        "max": lambda: max(signed(a), signed(b)), "min": lambda: min(signed(a), signed(b)),
        "maxu": lambda: max(a, b), "minu": lambda: min(a, b),
        "and": lambda: a & b, "or": lambda: a | b, "xor": lambda: a ^ b,
        "andn": lambda: a & ~b, "orn": lambda: a | ~b, "xnor": lambda: ~(a ^ b),
        "bclr": lambda: a & ~(1 << k), "bset": lambda: a | (1 << k),
        "binv": lambda: a ^ (1 << k), "bext": lambda: (a >> k) & 1,
        "sextb": lambda: signed(a, 8), "sexth": lambda: signed(a, 16),
        "packh": lambda: ((b & 0xff) << 8) | (a & 0xff),
        "packw": lambda: extend32(((b & 0xffff) << 16) | (a & 0xffff)),
        "pack": lambda: ((b & 0xffffffff) << 32) | (a & 0xffffffff),
        "orcb": lambda: sum((255 if (a >> (8 * i)) & 255 else 0) << (8 * i) for i in range(8)),
        "rev8": lambda: int.from_bytes(a.to_bytes(8, "little"), "big"),
        "revb": lambda: sum(int(f'{(a >> (8 * i)) & 255:08b}'[::-1], 2) << (8 * i) for i in range(8)),
    }
    return None if label not in operations else operations[label]() & MASK


def metadata(top, verilog):
    text = verilog.read_text()
    match = re.search(r"module\s+" + re.escape(top) + r"\s*\((.*?)\);", text, re.S)
    if not match:
        raise RuntimeError("Original RTL top interface not found")
    ports = []
    for m in re.finditer(r"\b(input|output)\s+(?:wire\s+)?(?:\[(\d+):0\]\s+)?(\w+)", match[1]):
        ports.append({"name": m[3], "rtl_name": m[3], "direction": m[1], "width": int(m[2]) + 1 if m[2] else 1, "signed": False})
    return {"top": top, "clocked": any(p["name"] == "clock" for p in ports), "ports": ports}


def verify(top, random_cycles):
    evidence = ROOT / "experiments" / "xiangshan-firrtl" / top
    original = evidence / "original"
    provenance = read(evidence / "provenance.json")
    if provenance["commit"] != REVISION or provenance["framework_shim"]:
        raise RuntimeError("This experiment requires the original full-project configuration")
    alu = WORK / "src/main/scala/xiangshan/backend/fu/Alu.scala"
    if hashlib.sha256(alu.read_bytes()).hexdigest() != provenance["Alu.scala_sha256"]:
        raise RuntimeError("Original source changed after elaboration")
    if translate_firrtl(original / (top + ".fir"), evidence / "model"):
        raise RuntimeError("FIRRTL conversion failed")
    ir_path = evidence / "model" / "FIRRTL" / (top + ".ir.json")
    interface = metadata(top, original / (top + ".v"))
    write(original / "ports.json", interface)
    rng = random.Random(20261013)
    patterns = [0, 1, 2, 31, 32, 63, 64, 0xffffffff, 1 << 31, 1 << 63, (1 << 63) - 1, MASK,
                0xaaaaaaaaaaaaaaaa, 0x5555555555555555]
    trace = []
    labels = {}
    if top == "RightShiftModule":
        for a in patterns:
            for k in range(64):
                trace.append({"inputs": {"reset": 0, "io_srlSrc": a, "io_sraSrc": a,
                              "io_shamt": k, "io_revShamt": 63 - k}})
        for _ in range(random_cycles):
            trace.append({"inputs": {"reset": rng.randrange(2), "io_srlSrc": rng.getrandbits(64),
                          "io_sraSrc": rng.getrandbits(64), "io_shamt": rng.randrange(64), "io_revShamt": rng.randrange(64)}})
    else:
        package = (WORK / "src/main/scala/xiangshan/package.scala").read_text()
        body = package.split("object ALUOpType", 1)[1].split("object MDUOpType", 1)[0]
        labels = {int(bits.replace("_", ""), 2): label for label, bits in re.findall(r'def\s+(\w+)\s*=\s*"b([01_]+)"\.U', body)}
        for func in range(128):
            for a in patterns:
                for b in patterns:
                    trace.append({"inputs": {"reset": 0, "io_src_0": a, "io_src_1": b,
                                  "io_func": func, "io_pred_taken": (a ^ b) & 1, "io_isBranch": int(func >= 112)}})
        for _ in range(random_cycles):
            trace.append({"inputs": {"reset": rng.randrange(2), "io_src_0": rng.getrandbits(64), "io_src_1": rng.getrandbits(64),
                          "io_func": rng.randrange(128), "io_pred_taken": rng.randrange(2), "io_isBranch": rng.randrange(2)}})
    code, lean = simulate_firrtl(ir_path, trace, {}, evidence / "lean")
    if code:
        raise RuntimeError("Lean execution failed")
    native_trace = [e | {"reset": bool(e["inputs"]["reset"])} for e in trace]
    code, rtl = run_emitted_rtl(original, interface, native_trace, evidence / "reference")
    if code:
        raise RuntimeError("Original XiangShan RTL execution failed")
    if len(lean) != len(rtl) or len(lean) != len(trace):
        raise RuntimeError("Incomplete trace")
    comparisons = math_checks = 0
    for entry, a, b in zip(trace, lean, rtl):
        inputs = entry["inputs"]
        for phase in ["pre", "post"]:
            if a[phase] != b[phase]:
                raise RuntimeError(f"Original XiangShan mismatch: {entry}, {a}, {b}")
            comparisons += len(a[phase])
            if top == "RightShiftModule":
                expected = {"io_srl": inputs["io_srlSrc"] >> inputs["io_shamt"],
                            "io_sra": (signed(inputs["io_sraSrc"]) >> inputs["io_shamt"]) & MASK,
                            "io_revSrl": inputs["io_srlSrc"] >> inputs["io_revShamt"]}
            else:
                x, y, func = (inputs[k] for k in ["io_src_0", "io_src_1", "io_func"])
                kind = (func >> 2) & 3
                # The equality signal comes from xor with logicSrc2, which is
                # inverted for selected non-branch operations (andn/orn/xnor).
                # For branch encodings bit 5 is set, so this is ordinary x == y.
                logic_y = y ^ (MASK if not (func & 32) and (func & 1) else 0)
                taken = {0: int(x == logic_y), 2: int(signed(x) < signed(y)), 3: int(x < y)}.get(kind, 0) ^ ((func >> 1) & 1)
                expected = {"io_taken": taken, "io_mispredict": (taken ^ inputs["io_pred_taken"]) & inputs["io_isBranch"]}
                value = alu_spec(labels.get(func), x, y)
                if value is not None:
                    expected["io_result"] = value
            for name, value in expected.items():
                if a[phase][name] != value:
                    raise RuntimeError(f"Independent arithmetic mismatch {labels.get(inputs.get('io_func'))}: {entry}, {name}, {a[phase][name]}, {value}")
                math_checks += 1
    ir = read(ir_path)
    summary = {"passed": True, "module": top, "commit": REVISION, "framework_shim": False,
               "configuration": provenance["configuration"], "signals": len(ir["signals"]),
               "submodule_instances": len(re.findall(r'^\s+inst ', (original / (top + ".fir")).read_text(), re.M)),
               "cycles": len(trace), "output_comparisons": comparisons, "independent_math_checks": math_checks,
               "opcode_values_covered": 128 if top == "AluDataModule" else None,
               "formal_translation_equivalence": False}
    write(evidence / "summary.json", summary)
    return summary


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--module", choices=["RightShiftModule", "AluDataModule", "all"], default="all")
    parser.add_argument("--random-cycles", type=int, default=512)
    args = parser.parse_args()
    targets = ["RightShiftModule", "AluDataModule"] if args.module == "all" else [args.module]
    summaries = [verify(top, args.random_cycles) for top in targets]
    write(ROOT / "docs" / "validation-xiangshan-firrtl.json", {"passed": True, "modules": summaries,
          "cycles": sum(s["cycles"] for s in summaries), "output_comparisons": sum(s["output_comparisons"] for s in summaries)})
    print(json.dumps(summaries, indent=2))
