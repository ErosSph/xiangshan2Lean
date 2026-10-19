"""Stream the frozen native reference to an exclusive Guard-approved server path."""
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
from fourstate_sync import checked,scp,new_file,stable_read
from fourstate_sync_common import WORKSPACE,encoded,identifier
from run_fourstate_f54 import remote


def digest(path):
    value=hashlib.sha256()
    with checked(path).open('rb') as source:
        before=os.fstat(source.fileno())
        for block in iter(lambda:source.read(1024*1024),b''):value.update(block)
        after=os.fstat(source.fileno())
    if (before.st_ino,before.st_size,before.st_mtime_ns)!=(after.st_ino,after.st_size,after.st_mtime_ns):raise ValueError('Native reference changed')
    return value.hexdigest()


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--out',type=Path,required=True)
    parser.add_argument('--label',required=True)
    args=parser.parse_args();out=checked(args.out.absolute());label=identifier(args.label)
    folder=out/label;folder.mkdir();source=out/'modelsim-trace-v1'
    summary=json.loads(stable_read(source/'summary.json',None))
    if summary['status']!='RAW_TRACES_EXECUTED':raise ValueError('Complete original reference required')
    rows=[];sources={}
    for fill,row in zip('01xz',summary['simulations'],strict=True):
        if row['fill']!=fill or row['exit_code']:raise ValueError('Native fill receipt differs')
        path=source/('case-'+fill)/'observations.log.gz';sha=digest(path)
        if sha!=row['observations']['gzip_sha256']:raise ValueError('Frozen reference archive changed')
        name='case-'+fill+'/observations.log.gz';sources[name]=path
        rows.append(dict(path=name,bytes=path.stat().st_size,sha256=sha,logical_bytes=row['observations']['bytes'],logical_sha256=row['observations']['sha256']))
        console=folder/('console-'+fill+'.log.gz')
        with checked(source/('execute-'+fill)/'stdout.log').open('rb') as src,console.open('xb') as raw:
            with gzip.GzipFile(filename='',mode='wb',fileobj=raw,compresslevel=1,mtime=0) as dst:shutil.copyfileobj(src,dst)
        name='case-'+fill+'/console.log.gz';sources[name]=console
        rows.append(dict(path=name,bytes=console.stat().st_size,sha256=digest(console)))
    sources['summary.json']=source/'summary.json'
    rows.append(dict(path='summary.json',bytes=sources['summary.json'].stat().st_size,sha256=digest(sources['summary.json'])))
    request=dict(run_id=out.name,label=label,files=rows)
    new_file(folder/'request.json',encoded(request))
    ready=remote(out,'prepare-reference-stream',request)
    expected=WORKSPACE+'/runs/'+out.name+'/reports/'+label
    if ready['status']!='REFERENCE_STREAM_READY' or ready['root']!=expected or ready['files']!=rows:raise ValueError('Unexpected reference staging destination')
    for i,row in enumerate(rows):
        log=folder/('scp-'+str(i));log.mkdir()
        if digest(sources[row['path']])!=row['sha256']:raise ValueError('Reference changed before transfer')
        scp(sources[row['path']],'amax:'+expected+'/'+row['path'],log,unrestricted=True)
        print(json.dumps(dict(event='reference_transferred',path=row['path'],bytes=row['bytes'])),flush=True)
    result=remote(out,'seal-reference-stream',dict(run_id=out.name,label=label))
    new_file(folder/'receipt.json',encoded(result))
    print(json.dumps(dict(status=result['status'],files=len(result['files']),bytes=sum(r['bytes'] for r in rows))),flush=True)


if __name__=='__main__':main()
