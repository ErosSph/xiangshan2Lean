"""Expose categorized script modules to tests that import their CLI modules."""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
for relative in (
    "scripts",
    "scripts/verification/two_state",
    "scripts/verification/four_state",
    "scripts/experiments/four_state/runners",
):
    path = str(ROOT / relative)
    if path not in sys.path:
        sys.path.insert(0, path)
