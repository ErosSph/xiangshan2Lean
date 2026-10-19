"""Windows reference rendering after server-side full hardware comparisons."""
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

from pathlib import Path
import argparse
import gzip
import json
from verify_fourstate_machine_native import compare_native_diagnostics


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--mapping',type=Path,required=True)
    parser.add_argument('--payload',type=Path,required=True)
    parser.add_argument('--console',type=Path,required=True)
    parser.add_argument('--out',type=Path,required=True)
    parser.add_argument('--tools',type=Path,default=Path('E:/quartus/modelsim_ase/win32aloem'))
    args=parser.parse_args();out=args.out.absolute();out.mkdir()
    with gzip.open(args.mapping,'rt') as stream:mapping=json.load(stream)
    payload=json.loads(args.payload.read_bytes());arguments={}
    for row in payload['arguments']:
        key=tuple(row[k] for k in ('sample','site','ordinal','argument'))
        if key in arguments:raise ValueError('Repeated diagnostic argument')
        arguments[key]=row['bits']
    result=compare_native_diagnostics(mapping,dict(events=payload['events'],arguments=arguments),args.console,out,args.tools)
    (out/'summary.json').write_text(json.dumps(result,indent=2))
    print(json.dumps(result),flush=True)


if __name__=='__main__':main()
