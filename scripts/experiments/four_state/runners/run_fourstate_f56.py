"""Windows control of F56 experiments, using guarded personal-server paths."""
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

import argparse,json,uuid
from pathlib import Path
from run_fourstate_f54 import remote,pack


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('operation');p.add_argument('--out',type=Path,required=True);p.add_argument('--request',type=Path)
    a=p.parse_args();r=json.loads(a.request.read_bytes()) if a.request else {}
    if a.operation=='pack':v=pack(profile='f5.6',scope='Private hierarchy/expression/process/diagnostic extensions and raw/encoded acceptance; no whole-machine Lean execution')
    else:
        if a.operation=='execute':r['worker']='verify_fourstate_f56'
        v=remote(a.out,a.operation,r)
    with (a.out/(a.operation+'-'+uuid.uuid4().hex[:8]+'.json')).open('x') as f:json.dump(v,f,indent=2)
    print(json.dumps(v))


if __name__=='__main__':main()
