"""Compile Chisel source through Chicala's typed frontend to checked Lean 4.

Examples:
  python scripts/chisel2lean.py audit/src/main/scala/Probes.scala --module probes.Counter
  python scripts/chisel2lean.py MyDesign.scala --out generated --check
"""
from __future__ import annotations

import argparse
import datetime as dt
import json
import hashlib
import os
from pathlib import Path
import shutil
import sys
import uuid
from common import ROOT, java_executable, lean_executable, run_logged, sbt_command


def check_lean(output: Path, log: Path) -> int:
    lean = lean_executable()
    env = os.environ.copy()
    env["LEAN_PATH"] = str(output)
    runtime = output / "Chisel2Lean" / "Runtime.lean"
    files = [runtime] + sorted(p for p in output.rglob("*.lean") if p != runtime)
    for index, source in enumerate(files):
        code = run_logged([lean, "-o", str(source.with_suffix(".olean")), str(source)],
                          log / f"{index:03d}-{source.stem}", cwd=output, env=env)
        if code:
            return code
    return 0


def translate(sources: list[Path], output: Path, module: str | None,
              extra_classpath: str | None, check: bool, rebuild: bool = False) -> int:
    attempt = dt.datetime.now(dt.timezone.utc).strftime("%Y%m%dT%H%M%SZ") + "-" + uuid.uuid4().hex[:8]
    log = ROOT / "experiments" / "translation" / attempt
    stage = log / "artifacts"
    stage.mkdir(parents=True)
    classpath_file = ROOT / ".cache" / "tool-classpath.txt"
    if rebuild or not classpath_file.is_file():
        command, env = sbt_command(["writeToolClasspath"])
        if result := run_logged(command, log / "build", env=env):
            return result
    classpath = classpath_file.read_text(encoding="utf-8").strip()
    if extra_classpath:
        classpath += os.pathsep + extra_classpath
    # One immutable jar snapshot supplies both JVM classes and the Scala plugin.
    plugin = Path(classpath.split(os.pathsep)[0])
    classes = stage / "classes"
    classes.mkdir()
    options = ["-usejavacp", "-language:reflectiveCalls", "-deprecation", "-feature",
               "-Ystop-after:chiselToScala", f"-Xplugin:{plugin}", "-Xplugin-require:chicala",
               "-P:chicala:backend:lean", f"-P:chicala:out:{stage}", "-d", str(classes)]
    if module:
        options.append(f"-P:chicala:module:{module}")
    command = [java_executable(), "-Xmx2g", "-Dfile.encoding=UTF-8", "-cp", classpath,
               "scala.tools.nsc.Main", *options, *(str(s.resolve()) for s in sources)]
    result = run_logged(command, log / "compiler")
    if result:
        print(f"Translation failed; evidence: {log}", file=sys.stderr)
        return result
    ir_files = sorted(stage.rglob("*.ir.json"))
    if not ir_files:
        print(f"No target module was translated: {module or 'input files'}", file=sys.stderr)
        return 2
    if module and "." not in module and len(ir_files) != 1:
        print("Ambiguous short module name; use the fully qualified name", file=sys.stderr)
        return 2
    runtime = stage / "Chisel2Lean" / "Runtime.lean"
    runtime.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(ROOT / "lean" / "Chisel2Lean" / "Runtime.lean", runtime)
    if check and (result := check_lean(stage, log / "lean")):
        print(f"Lean check failed; evidence: {log}", file=sys.stderr)
        return result
    modules = []
    for ir_path in ir_files:
        ir = json.loads(ir_path.read_text(encoding="utf-8"))
        modules.append({"module": ir["module"], "namespace": ir["namespace"],
                        "ir": ir_path.relative_to(stage).as_posix(),
                        "lean": ir_path.with_suffix("").with_suffix(".lean").relative_to(stage).as_posix()})
    manifest = {"format": "chisel2lean-manifest-v2", "version": "0.2.0",
                "lean_version": "4.19.0", "chisel_version": "3.5.6",
                "sources": [str(s.resolve()) for s in sources], "modules": modules,
                "source_sha256": {str(s.resolve()): hashlib.sha256(s.read_bytes()).hexdigest() for s in sources},
                "compiler_sha256": hashlib.sha256(plugin.read_bytes()).hexdigest(),
                "lean_checked": check, "evidence": str(log)}
    (stage / "manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    output.mkdir(parents=True, exist_ok=True)
    for path in stage.rglob("*"):
        if path.is_file() and path.suffix in {".lean", ".olean", ".json"}:
            destination = output / path.relative_to(stage)
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(path, destination)
    print(f"Generated {len(modules)} parameterized Lean model(s) in {output}")
    print(f"Evidence: {log}")
    return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("sources", nargs="+", type=Path)
    parser.add_argument("--module", help="qualified or unambiguous short module name")
    parser.add_argument("--out", default=ROOT / "generated", type=Path)
    parser.add_argument("--classpath", help="extra source dependencies, separated by the OS path separator")
    parser.add_argument("--check", action=argparse.BooleanOptionalAction, default=True,
                        help="type-check generated Lean with the pinned compiler (default: yes)")
    parser.add_argument("--rebuild", action="store_true", help="rebuild compiler/plugin first")
    args = parser.parse_args()
    for source in args.sources:
        if not source.is_file():
            parser.error(f"Source file not found: {source}")
    return translate(args.sources, args.out.resolve(), args.module, args.classpath, args.check, args.rebuild)


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except RuntimeError as error:
        print(str(error), file=sys.stderr)
        raise SystemExit(2)
