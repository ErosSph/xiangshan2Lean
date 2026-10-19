"""F55 guarded local control; server work remains in the personal directory."""
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
from run_fourstate_f54 import remote,pack as pack_base,modelsim_scalable

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('operation');p.add_argument('--out',type=Path,required=True);p.add_argument('--request',type=Path)
    a=p.parse_args();r=json.loads(a.request.read_bytes()) if a.request else {}
    if a.operation=='pack':v=pack_base(profile='f5.5',scope='Private v8 acyclic state-bit resets and state-fed low-latched gates; real SRAM subsystem raw/encoded acceptance, no whole-XSTop or Lean execution')
    else:
        if a.operation=='execute':r['worker']='verify_fourstate_f55'
        v=remote(a.out,a.operation,r)
    (a.out/(a.operation+'-'+uuid.uuid4().hex[:8]+'.json')).write_text(json.dumps(v,indent=2));print(json.dumps(v))
if __name__=='__main__':main()
