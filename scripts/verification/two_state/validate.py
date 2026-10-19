"""Build, translate, execute the independent release suite, and aggregate evidence."""
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
import os
from pathlib import Path
import subprocess
import sys
from common import ROOT, lean_executable, run_logged


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skip-build", action="store_true")
    parser.add_argument("--resume", action="store_true", help="reuse only fingerprint-matched passed configurations")
    parser.add_argument("--generated", type=Path, default=ROOT / "generated/chisel7")
    args = parser.parse_args()
    def run(script, *arguments):
        cmd = [sys.executable, str(ROOT / "scripts" / script), *map(str, arguments)]
        result = subprocess.run(cmd, cwd=ROOT)
        if result.returncode:
            raise SystemExit(result.returncode)
    if not args.skip_build:
        run("sbt.py", "--log", "experiments/build/release-chisel7", "writeToolClasspath",
            "reference/writeReferenceClasspath", "publishLocal", "testcase/clean", "testcase/compile")
    sources = sorted((ROOT / "audit" / "src" / "main" / "scala").glob("*.scala"))
    run("chisel2lean.py", *sources, "--out", args.generated)
    run("chisel2lean.py", "examples/Counter.scala", "--module", "Counter", "--out", args.generated)
    env = os.environ.copy()
    env["LEAN_PATH"] = str(args.generated.resolve())
    code = run_logged([lean_executable(), str(ROOT / "examples" / "CounterProof.lean")],
                      ROOT / "experiments" / "client-proof-v0.3", env=env)
    if code:
        return code
    for suite in ["full", "edge", "control", "extension"]:
        flags = ["--resume"] if args.resume else []
        run("differential.py", "--suite", suite, "--generated", args.generated, "--evidence", "experiments/differential-v0.3-" + suite, *flags)
    run("check_rejections.py", "--generated", args.generated)
    run("check_mutation.py", "--generated", args.generated)
    run("report_chisel7.py", "--generated", args.generated)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
