"""Download pinned public tool binaries into this project, never globally."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import urllib.request
import zipfile
from common import ROOT, LEAN_VERSION, SBT_VERSION


def download(url: str, path: Path):
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.is_file():
        print(f"Using cached {path.name}", flush=True)
        return
    temporary = path.with_suffix(path.suffix + ".part")
    digest = hashlib.sha256()
    size = 0
    next_report = 50_000_000
    request = urllib.request.Request(url, headers={"User-Agent": "Chisel2Lean-bootstrap"})
    with urllib.request.urlopen(request, timeout=120) as response, temporary.open("wb") as output:
        while chunk := response.read(1024 * 1024):
            output.write(chunk)
            digest.update(chunk)
            size += len(chunk)
            if size >= next_report:
                print(f"{path.name}: {size // 1_000_000} MB", flush=True)
                next_report += 50_000_000
    temporary.replace(path)
    path.with_suffix(path.suffix + ".json").write_text(json.dumps(
        {"url": url, "bytes": size, "sha256": digest.hexdigest()}, indent=2), encoding="utf-8")
    print(f"Downloaded {path.name} ({size} bytes)", flush=True)


parser = argparse.ArgumentParser()
parser.add_argument("--sbt", action="store_true")
parser.add_argument("--lean", action="store_true")
args = parser.parse_args()
if not (args.sbt or args.lean):
    args.sbt = args.lean = True
tools = ROOT / ".tools"
if args.sbt:
    download(f"https://repo.maven.apache.org/maven2/org/scala-sbt/sbt-launch/{SBT_VERSION}/sbt-launch-{SBT_VERSION}.jar",
             tools / f"sbt-launch-{SBT_VERSION}.jar")
if args.lean:
    platform = "windows" if os.name == "nt" else "linux"
    stem = f"lean-{LEAN_VERSION}-{platform}"
    executable = tools / stem / "bin" / ("lean.exe" if os.name == "nt" else "lean")
    if not executable.is_file():
        extension = "zip" if os.name == "nt" else "tar.zst"
        archive = tools / "downloads" / f"{stem}.{extension}"
        download(f"https://github.com/leanprover/lean4/releases/download/v{LEAN_VERSION}/{archive.name}", archive)
        print("Extracting pinned Lean toolchain", flush=True)
        if extension == "zip":
            with zipfile.ZipFile(archive) as package:
                for member in package.infolist():
                    destination = (tools / member.filename).resolve()
                    if not destination.is_relative_to(tools.resolve()):
                        raise RuntimeError("Unsafe path in release archive")
                package.extractall(tools)
        else:
            subprocess.run(["tar", "-xf", str(archive), "-C", str(tools)], check=True)
    subprocess.run([str(executable), "--version"], check=True)
