"""Temporary bridge to modules that still live in the legacy scripts folder."""
from __future__ import annotations

from pathlib import Path
import sys

REPOSITORY_ROOT = Path(__file__).resolve().parents[2]
LEGACY_SCRIPTS = REPOSITORY_ROOT / "scripts"


def enable_legacy_script_imports() -> None:
    """Keep old bare imports working while implementation modules are migrated."""
    scripts = str(LEGACY_SCRIPTS)
    if scripts not in sys.path:
        sys.path.insert(0, scripts)
