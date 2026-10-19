"""Execute the frozen complete original-XSTop short trace in existing ModelSim."""
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
import hashlib
import json
import os
import shutil
import stat
from verify_fourstate_f57_native import command


def digest(path):
    h=hashlib.sha256()
    with path.open('rb') as f:
        for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
    return h.hexdigest()


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--out',type=Path,required=True)
    p.add_argument('--source',type=Path,required=True)
    p.add_argument('--inputs',type=Path,required=True)
    p.add_argument('--prepared',type=Path,required=True)
    p.add_argument('--tools',type=Path,default=Path('E:/quartus/modelsim_ase/win32aloem'))
    a=p.parse_args();out=a.out.absolute();out.mkdir();original=out/'original';original.mkdir()
    expected=json.loads(a.inputs.read_bytes())
    for row in expected:
        name=row['name']
        if Path(name).name!=name:raise ValueError('Only flat frozen input names admitted')
        source=a.source/name
        if source.is_symlink() or digest(source)!=row['sha256']:raise ValueError('Frozen input mismatch: '+name)
        (original/name).write_bytes(source.read_bytes())
    (out/'inputs.json').write_text(json.dumps(expected,indent=2))
    receipt=json.loads((a.prepared/'summary.json').read_bytes())
    for row in receipt['files']:
        if digest(a.prepared/row['path'])!=row['sha256']:raise ValueError('Prepared reference hash differs')
    with gzip.open(a.prepared/'original-tb.sv.gz','rb') as src,(out/'original-tb.sv').open('xb') as dst:shutil.copyfileobj(src,dst)
    for name in ('original-inputs.mem','trace.json','initial-schema.json'):
        (out/name).write_bytes((a.prepared/'native'/name).read_bytes())
    files=sorted(f for f in original.iterdir() if f.suffix.lower() in ('.sv','.v'))+[out/'original-tb.sv']
    (out/'files.f').write_text('\n'.join('"'+str(f).replace('\\','/')+'"' for f in files)+'\n')
    rows=[];simulations=[]
    for name,argv in [('vlib',[a.tools/'vlib.exe','work']),('vlog',[a.tools/'vlog.exe','-sv','-work','work','+incdir+'+str(original).replace('\\','/'),'-f',out/'files.f'])]:
        r=command(out,name,argv);rows.append(r)
        if r['exit_code']:
            (out/'summary.json').write_text(json.dumps(dict(status='REFERENCE_COMPILE_FAILED',commands=rows),indent=2));return
    for code,fill in enumerate('01xz'):
        folder=out/('case-'+fill);folder.mkdir()
        argv=[a.tools/'vsim.exe','-c','-onfinish','stop','-novopt','-lib','work','tb','+FILL='+str(code),'-l',folder/'transcript.log','-wlf',folder/'sim.wlf','-do','run -all; quit -f']
        r=command(out,'execute-'+fill,argv)
        raw=out/'observations.log';target=folder/'observations.log'
        if raw.exists():
            if not stat.S_ISREG(raw.lstat().st_mode) or raw.is_symlink():raise ValueError('Observation is not a regular owned output')
            raw.resolve().relative_to(out.resolve());target.resolve().relative_to(out.resolve())
            if target.exists():raise ValueError('Refuse overwrite of a prior observation')
            os.rename(raw,target)
            with target.open('rb') as src,gzip.open(folder/'observations.log.gz','wb',compresslevel=1) as dst:shutil.copyfileobj(src,dst)
            r['observations']=dict(bytes=target.stat().st_size,sha256=digest(target),gzip_sha256=digest(folder/'observations.log.gz'))
        r['fill']=fill;simulations.append(r)
        (folder/'receipt.json').write_text(json.dumps(r,indent=2))
        if r['exit_code'] or 'observations' not in r:break
    result=dict(status='RAW_TRACES_EXECUTED' if len(simulations)==4 and all(r['exit_code']==0 for r in simulations) else 'REFERENCE_PARTIAL',prepared_mapping_sha256=receipt['mapping_sha256'],initial_schema=receipt['initial_schema'],commands=rows,simulations=simulations,scope='Original RTL reference only; no encoded/Lean equivalence claim')
    (out/'summary.json').write_text(json.dumps(result,indent=2))


if __name__=='__main__':main()
