"""Independent official-Chisel RTL generation and Verilator trace execution."""
from __future__ import annotations

import csv
import json
import os
from pathlib import Path
import shutil
from common import ROOT, java_executable, run_logged


def native_environment():
    env = os.environ.copy()
    if os.name == "nt":
        mingw = Path("C:/msys64/mingw64/bin")
        msys = Path("C:/msys64/usr/bin")
        if mingw.is_dir() and msys.is_dir():
            env["PATH"] = os.pathsep.join([str(mingw), str(msys), env.get("PATH", "")])
    return env


def verilator_command():
    if os.name == "nt" and Path("C:/msys64/usr/bin/perl.exe").is_file():
        return ["C:/msys64/usr/bin/perl.exe", "/mingw64/bin/verilator"]
    executable = shutil.which("verilator")
    if not executable:
        raise RuntimeError("Verilator not found")
    return [executable]


def get_value(values: dict, path: str):
    if path in values:
        return values[path]
    key = path
    indices = []
    while key not in values and "." in key:
        key, index = key.rsplit(".", 1)
        if not index.isdigit():
            raise ValueError(f"Missing input {path}")
        indices.insert(0, int(index))
    value = values[key]
    for index in indices:
        value = value[index]
    return value


def run_rtl(ir_path: Path, parameters: dict, trace: list[dict], evidence: Path) -> tuple[int, list[dict]]:
    ir = json.loads(ir_path.read_text(encoding="utf-8"))
    classpath_file = ROOT / ".cache" / "reference-classpath.txt"
    if not classpath_file.is_file():
        raise RuntimeError("Build reference/writeReferenceClasspath first")
    evidence.mkdir(parents=True, exist_ok=True)
    directory = evidence / "rtl"
    directory.mkdir(exist_ok=True)
    values = []
    for parameter in ir["parameters"]:
        v = parameters[parameter["name"]]
        values.append(str(v).lower() if isinstance(v, bool) else str(v))
    command = [java_executable(), "-Xmx2g", "-cp", classpath_file.read_text(encoding="utf-8").strip(),
               "reference.GenerateRTL", ir["module"], str(directory), *values]
    if code := run_logged(command, evidence / "elaboration", echo=False):
        return code, []
    metadata = json.loads((directory / "ports.json").read_text(encoding="utf-8"))
    ports = metadata["ports"]
    has_clock = metadata["clocked"] and any(p["name"] == "clock" for p in ports)
    has_reset = metadata["clocked"] and any(p["name"] == "reset" for p in ports)
    implicit = ({"clock"} if has_clock else set()) | ({"reset"} if has_reset else set())
    inputs = [p for p in ports if p["direction"] == "input" and p["name"] not in implicit]
    outputs = [p for p in ports if p["direction"] == "output"]
    with (directory / "trace.csv").open("w", encoding="utf-8", newline="") as output:
        writer = csv.writer(output)
        writer.writerow(["reset", *(p["name"] for p in inputs)])
        for entry in trace:
            values = [int(entry.get("reset", False))]
            for port in inputs:
                value = int(get_value(entry["inputs"], port["name"]))
                values.append(value % (1 << port["width"]))
            writer.writerow(values)
    top = metadata["top"]
    poke = "\n    ".join(
        f"readWide(values[{i + 1}], dut.{p['rtl_name']}.data(), {(p['width'] + 31) // 32});" if p["width"] > 64
        else f"dut.{p['rtl_name']} = std::stoull(values[{i + 1}]);"
        for i, p in enumerate(inputs) if p["width"])
    sample = ", ".join(
        f"wideHex(dut.{p['rtl_name']}.data(), {(p['width'] + 31) // 32})" if p["width"] > 64
        else f"std::to_string(static_cast<uint64_t>(dut.{p['rtl_name']}))" if p["width"] else 'std::string("0")'
        for p in outputs)
    header = ["cycle", *("pre:" + p["name"] for p in outputs), *("post:" + p["name"] for p in outputs)]
    code = f"""#include "V{top}.h"
#include "verilated.h"
#include <array>
#include <cstdint>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <string>
#include <vector>
void readWide(const std::string& decimal, WData* words, size_t count) {{
  for (size_t i = 0; i < count; ++i) words[i] = 0;
  for (char digit : decimal) {{
    uint64_t carry = static_cast<unsigned>(digit - '0');
    for (size_t i = 0; i < count; ++i) {{
      uint64_t value = uint64_t(words[i]) * 10 + carry;
      words[i] = static_cast<WData>(value);
      carry = value >> 32;
    }}
  }}
}}
std::string wideHex(const WData* words, size_t count) {{
  std::ostringstream result;
  result << "0x" << std::hex << std::setfill('0');
  for (size_t i = count; i > 0; --i) result << std::setw(8) << words[i - 1];
  return result.str();
}}
int main(int argc, char** argv) {{
  Verilated::commandArgs(argc, argv);
  V{top} dut;
  std::ifstream input("trace.csv");
  std::ofstream output("rtl-results.csv");
  output << "{','.join(header)}\\n";
  std::string line;
  std::getline(input, line);
  size_t cycle = 0;
  while (std::getline(input, line)) {{
    std::stringstream row(line);
    std::string token;
    std::array<std::string, {len(inputs) + 1}> values;
    size_t field = 0;
    while (std::getline(row, token, ',')) values.at(field++) = token;
    {'dut.clock = 0;' if has_clock else ''}
    {'dut.reset = std::stoull(values[0]);' if has_reset else ''}
    {poke}
    dut.eval();
    std::array<std::string, {len(outputs)}> pre = {{{sample}}};
    {'dut.clock = 1;' if has_clock else ''}
    dut.eval();
    std::array<std::string, {len(outputs)}> post = {{{sample}}};
    output << cycle++;
    for (auto value : pre) output << ',' << value;
    for (auto value : post) output << ',' << value;
    output << '\\n';
    {'dut.clock = 0; dut.eval();' if has_clock else ''}
  }}
  dut.final();
  return 0;
}}
"""
    (directory / "trace.cpp").write_text(code, encoding="utf-8")
    env = native_environment()
    command = [*verilator_command(), "--cc", "--exe", "--build", "-j", "2",
               "-Wno-fatal", "--x-initial", "0", "--x-assign", "0",
               "-CFLAGS", "-O2 -DVL_TIME_CONTEXT", "--top-module", top,
               "--Mdir", "obj_dir", top + ".v", "trace.cpp"]
    if result := run_logged(command, evidence / "verilator-build", cwd=directory, env=env, echo=False):
        return result, []
    executable = directory / "obj_dir" / ("V" + top + (".exe" if os.name == "nt" else ""))
    if result := run_logged([str(executable)], evidence / "verilator-run", cwd=directory, env=env, echo=False):
        return result, []
    rows = []
    with (directory / "rtl-results.csv").open(encoding="utf-8", newline="") as output:
        for row in csv.DictReader(output):
            item = {"cycle": int(row["cycle"]), "pre": {}, "post": {}}
            for port in outputs:
                for sampling in ("pre", "post"):
                    item[sampling][port["name"]] = int(row[sampling + ":" + port["name"]], 0)
            rows.append(item)
    (evidence / "result.json").write_text(json.dumps(rows, indent=2), encoding="utf-8")
    return 0, rows
