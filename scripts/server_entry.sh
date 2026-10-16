#!/usr/bin/env bash
set -euo pipefail
# Keep the immutable data bundle separate from the editable validation tools.
C2L_ROOT="${CHISEL2LEAN_SERVER_ROOT:?Set CHISEL2LEAN_SERVER_ROOT to the deployed server directory}"
C2L_SOURCE="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
C2L_PYTHON="${CHISEL2LEAN_PYTHON:-python3}"
export CHISEL2LEAN_LEAN="${CHISEL2LEAN_LEAN:-$C2L_ROOT/.tools/lean-4.19.0-linux/bin/lean}"
export CHISEL2LEAN_VERILATOR="${CHISEL2LEAN_VERILATOR:-$C2L_ROOT/.tools/verilator-v5.048/bin/verilator}"
export VERILATOR_ROOT="${VERILATOR_ROOT:-$C2L_ROOT/.tools/verilator-v5.048}"
if [[ "${1:-}" == scenario ]]; then
  shift
  exec "$C2L_PYTHON" "$C2L_SOURCE/scripts/server_scenario.py" --bundle "$C2L_ROOT/xiangshan2lean-server" "$@"
fi
exec "$C2L_PYTHON" "$C2L_SOURCE/scripts/server.py" --bundle "$C2L_ROOT/xiangshan2lean-server" "$@"
