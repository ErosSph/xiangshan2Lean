"""F3.2.2 data-only server helper; two pinned files, no hardware execution."""
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

import json
import os
from audit_fourstate_remote import Reader, RTL
from fourstate_sync_remote import Guard
from fourstate_sync_common import encoded, identifier, sha
from verify_fourstate_prioritymux_remote import AUDIT_RUN, main as archive

MODULES={
    'CAMTemplate.sv':'391c15027554668dd69525390ad7208de6910adf46ba9309b229f27e9ed6bcc3',
    'LevelGateway.sv':'8a8f4f473cee700f629101b49d50668c507a90791781929a23cfdac6e975f089',
}


def main(request):
    if request['operation'] in ('archive','archive-preflight'):return archive(request)
    if request['operation']!='acquire':raise ValueError('unsupported operation')
    guard,reader=Guard(),Reader();base='runs/'+identifier(request['run_id'])
    audit='runs/'+AUDIT_RUN;inventory=json.loads(guard.read(audit+'/reports/inputs.json',8*1024**2))
    files=[];payloads={}
    for name,expected in MODULES.items():
        record=reader.read(RTL+'/'+name,1024**2);data=record['text'].encode('utf-8')
        item=next(r for r in inventory['files'] if r['name']==name)
        if sha(data)!=expected or item['sha256']!=expected or guard.read(audit+'/inputs/'+name,1024**2)!=data:
            raise ValueError('original / audited input / pinned hash mismatch: '+name)
        payloads[name]=data
        files.append(dict(name=name,sha256=sha(data),bytes=len(data),original=record,audited=item))
    disk=os.fstatvfs(guard.root);free=disk.f_bavail*disk.f_frsize
    if free<1024**3:raise ValueError('less than 1 GiB free')
    with guard.directory(base,create=True,exclusive=True):pass
    for name,data in payloads.items():guard.new_file(base+'/reports/source/'+name,data)
    result=dict(status='SOURCES_ACQUIRED',run_id=request['run_id'],audit_run=AUDIT_RUN,files=files,
                free_bytes=free,original_access='O_RDONLY|O_NOFOLLOW|O_NOATIME; no fallback',
                execution_location='Windows; server acquisition/archive only')
    guard.new_file(base+'/reports/input-receipts.json',encoded(result));guard.close()
    print(encoded(dict(status=result['status'],run_id=request['run_id'],files=[{k:v for k,v in f.items() if k not in ('original','audited')} for f in files])).decode(),end='')
