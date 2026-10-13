"""Check unsupported-source diagnostics and parameter-domain failures."""
from __future__ import annotations

import json
from pathlib import Path
import subprocess
import sys
from common import ROOT
from simulate import simulate
from differential import initial_state


def main():
    output = ROOT / "experiments" / "rejections-v0.2"
    output.mkdir(parents=True, exist_ok=True)
    cases = ["CombinationalCycle", "UnconnectedOutput", "ChangedReset", "ConditionalDeclaration",
             "HostSideEffect", "StringParameter", "MultipleMemoryWrites",
             "UnconnectedChild", "RawState", "NonuniformVector"]
    results = []
    for name in cases:
        directory = output / name
        cmd = [sys.executable, str(ROOT / "scripts" / "chisel2lean.py"),
               str(ROOT / "tests" / "fixtures" / "Rejected.scala"), "--module", "rejected." + name,
               "--out", str(directory / "generated"), "--no-check"]
        proc = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True, encoding="utf-8", errors="replace")
        combined = proc.stdout + proc.stderr
        directory.mkdir(parents=True, exist_ok=True)
        (directory / "stdout.log").write_text(proc.stdout, encoding="utf-8")
        (directory / "stderr.log").write_text(proc.stderr, encoding="utf-8")
        good = proc.returncode != 0 and "Rejected.scala:" in combined and "error:" in combined and not (directory / "generated" / "manifest.json").exists()
        results.append({"module": name, "status": "PASS" if good else "FAIL", "exit_code": proc.returncode,
                        "source_diagnostic": "Rejected.scala:" in combined})
        print(f"{name}: {'rejected with source diagnostic' if good else 'FAIL'}", flush=True)
        if not good:
            print(combined, flush=True)
    domain_cases = [
        ("Counter", {"n": 0}), ("Counter", {"n": 2147483648}),
        ("Counter", {"n": 2147483647}),
        ("HelperWidth", {"n": 2147483647}),
        ("RenamedAccumulator", {"width": 2, "increment": 4}),
        ("VecIndex", {"n": 3, "w": 4, "k": 3}),
        ("VecIndex", {"n": 3, "w": 4, "k": -1}),
        ("Fifo", {"depth": 1, "w": 3}), ("VectorReset", {"n": 0, "w": 3}),
        ("HierarchicalPipeline", {"w": 0})]
    for index, (name, parameters) in enumerate(domain_cases):
        rejected = False
        try:
            simulate(ROOT / "generated" / "probes" / (name + ".ir.json"), parameters,
                     [{"inputs": {}}], None, output / f"domain-{index}")
        except ValueError as error:
            rejected = "legal domain" in str(error)
        results.append({"module": name, "parameters": parameters, "status": "PASS" if rejected else "FAIL", "kind": "invalid-domain"})
        print(f"{name} {parameters}: {'invalid domain rejected' if rejected else 'FAIL'}", flush=True)
    undefined_cases = [
        ("SignedDivision", {"w": 3}, {"a": 2, "b": 0}),
        ("MoreBits", {"w": 3, "repeat": 1}, {"a": 2, "b": 0, "shift": 1}),
        ("RegisterFile", {"n": 3, "w": 4}, {"write": False, "waddr": 0, "raddr": 3, "data": 0})]
    for index, (name, parameters, values) in enumerate(undefined_cases):
        directory = output / f"undefined-{index}"
        code, _ = simulate(ROOT / "generated" / "probes" / (name + ".ir.json"), parameters,
                           [{"inputs": values}], None, directory)
        message = (directory / "execution" / "stderr.log").read_text(encoding="utf-8")
        rejected = code != 0 and "Undefined output operation" in message
        results.append({"module": name, "status": "PASS" if rejected else "FAIL", "kind": "undefined-trace"})
        print(f"{name}: {'undefined input rejected' if rejected else 'FAIL'}", flush=True)
    for label, write, read in [("disabled", False, False), ("collision", True, True)]:
        path = ROOT / "generated" / "probes" / "SyncMemory.ir.json"
        ir = json.loads(path.read_text(encoding="utf-8"))
        params = {"n": 3, "w": 4}
        values = {"write": write, "readEnable": read, "waddr": 1, "raddr": 1, "data": 7}
        directory = output / ("sync-" + label)
        code, _ = simulate(path, params, [{"inputs": values}], initial_state(ir, params), directory, True)
        message = (directory / "execution" / "stderr.log").read_text(encoding="utf-8")
        rejected = code != 0 and "Undefined output operation after clock edge" in message
        results.append({"module": "SyncMemory", "status": "PASS" if rejected else "FAIL", "kind": "undefined-" + label})
        print(f"SyncMemory {label}: {'undefined result rejected' if rejected else 'FAIL'}", flush=True)
    report = {"cases": results, "passed": sum(r["status"] == "PASS" for r in results),
              "failed": sum(r["status"] == "FAIL" for r in results)}
    (output / "summary.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    return int(report["failed"] > 0)


if __name__ == "__main__":
    raise SystemExit(main())
