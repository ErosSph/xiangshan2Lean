"""Compile/elaborate unchanged frozen XSTop in the existing Windows ModelSim.

This is a reference-tool feasibility check, not a behavioral comparison.
All new files are inside a fresh experiment directory; no original is modified.
"""
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
import hashlib
import json
import subprocess
import time


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def command(out, name, argv):
    folder=out/name
    folder.mkdir()
    row=dict(argv=list(map(str,argv)),cwd=str(out),start_unix=time.time())
    (folder/'launch.json').write_text(json.dumps(row,indent=2))
    start=time.monotonic()
    with (folder/'stdout.log').open('wb') as stdout,(folder/'stderr.log').open('wb') as stderr:
        p=subprocess.run(row['argv'],cwd=out,stdout=stdout,stderr=stderr)
    row.update(exit_code=p.returncode,seconds=time.monotonic()-start)
    (folder/'command.json').write_text(json.dumps(row,indent=2))
    print(json.dumps(dict(stage=name,exit_code=p.returncode,seconds=row['seconds'])),flush=True)
    return row


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--out',type=Path,required=True)
    p.add_argument('--source',type=Path,required=True)
    p.add_argument('--tools',type=Path,default=Path('E:/quartus/modelsim_ase/win32aloem'))
    a=p.parse_args()
    out=a.out.absolute();out.mkdir()
    source=out/'original';source.mkdir()
    files=[]
    for f in sorted(a.source.iterdir()):
        if f.is_symlink() or not f.is_file():
            raise ValueError('Only flat regular frozen inputs admitted')
        data=f.read_bytes();target=source/f.name;target.write_bytes(data)
        if sha(target)!=hashlib.sha256(data).hexdigest():
            raise ValueError('Native input copy mismatch')
        files.append(dict(name=f.name,bytes=len(data),sha256=sha(target)))
    (out/'inputs.json').write_text(json.dumps(files,indent=2))
    paths=[str(f).replace('\\','/') for f in source.iterdir() if f.suffix.lower() in ('.v','.sv')]
    (out/'files.f').write_text('\n'.join('"'+n+'"' for n in sorted(paths))+'\n')
    rows=[]
    for name,argv in [('vlib',[a.tools/'vlib.exe','work']),('vlog',[a.tools/'vlog.exe','-sv','-work','work','+incdir+'+str(source).replace('\\','/'),'-f',out/'files.f']),('elaborate',[a.tools/'vsim.exe','-c','-novopt','-lib','work','XSTop','-l',out/'transcript.log','-wlf',out/'design.wlf','-do','quit -f'])]:
        row=command(out,name,argv);rows.append(row)
        if row['exit_code']:
            break
    result=dict(status='ELABORATED' if len(rows)==3 and rows[-1]['exit_code']==0 else 'REFERENCE_TOOL_BLOCKED',commands=rows,files=len(files),scope='Unmodified original XSTop compilation and elaboration only; no time advances or behavioral claim')
    (out/'summary.json').write_text(json.dumps(result,indent=2))


if __name__=='__main__':
    main()
