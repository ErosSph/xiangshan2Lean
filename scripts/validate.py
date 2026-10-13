"""Build, translate, execute the independent release suite, and aggregate evidence."""
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
    args = parser.parse_args()
    def run(script, *arguments):
        cmd = [sys.executable, str(ROOT / "scripts" / script), *map(str, arguments)]
        result = subprocess.run(cmd, cwd=ROOT)
        if result.returncode:
            raise SystemExit(result.returncode)
    if not args.skip_build:
        run("sbt.py", "--log", "experiments/build/release-v0.2", "writeToolClasspath",
            "reference/writeReferenceClasspath", "publishLocal", "testcase/clean", "testcase/compile")
    sources = sorted((ROOT / "audit" / "src" / "main" / "scala").glob("*.scala"))
    run("chisel2lean.py", *sources)
    run("chisel2lean.py", "examples/Counter.scala", "--module", "Counter")
    env = os.environ.copy()
    env["LEAN_PATH"] = str(ROOT / "generated")
    code = run_logged([lean_executable(), str(ROOT / "examples" / "CounterProof.lean")],
                      ROOT / "experiments" / "client-proof-v0.2", env=env)
    if code:
        return code
    for suite in ["full", "edge", "control", "extension"]:
        flags = ["--resume"] if args.resume else []
        run("differential.py", "--suite", suite, "--evidence", "experiments/differential-v0.2-" + suite, *flags)
    run("check_rejections.py")
    run("check_mutation.py")
    run("report.py")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
