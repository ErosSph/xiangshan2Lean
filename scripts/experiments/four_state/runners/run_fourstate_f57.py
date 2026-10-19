"""Guarded control for full-XSTop encoding and explicitly requested validation."""
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
import json
import uuid
from pathlib import Path
from run_fourstate_f54 import remote, pack


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('operation')
    p.add_argument('--out', type=Path, required=True)
    p.add_argument('--request', type=Path)
    a = p.parse_args()
    request = json.loads(a.request.read_bytes()) if a.request else {}
    if a.operation == 'pack':
        result = pack(profile='f5.7', scope='Full-XSTop private v9 encoding, compilation and user-authorized three-way validation; unchanged public backend')
    else:
        if a.operation == 'execute':
            request['worker'] = 'verify_fourstate_f57'
        result = remote(a.out, a.operation, request)
    with (a.out / (a.operation + '-' + uuid.uuid4().hex[:8] + '.json')).open('x') as f:
        json.dump(result, f, indent=2)
    visible = {k: (len(v) if k in ('files','source_files') and isinstance(v, list) else v) for k, v in result.items()} if isinstance(result,dict) else result
    print(json.dumps(visible))


if __name__ == '__main__':
    main()
