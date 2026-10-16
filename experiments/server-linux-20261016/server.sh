#!/usr/bin/env bash
set -euo pipefail
C2L_ROOT="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export CHISEL2LEAN_LEAN="$C2L_ROOT/.tools/lean-4.19.0-linux/bin/lean"
export CHISEL2LEAN_VERILATOR="$C2L_ROOT/.tools/verilator-v5.048/bin/verilator"
export VERILATOR_ROOT="$C2L_ROOT/.tools/verilator-v5.048"
C2L_PYTHON="${CHISEL2LEAN_PYTHON:-/data2/home/lvhongqing/miniconda3/bin/python}"
cd "$C2L_ROOT/xiangshan2lean-server"
exec "$C2L_PYTHON" scripts/server.py "$@"
