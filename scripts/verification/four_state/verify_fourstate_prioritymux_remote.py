"""Python 3.8 data-only acquisition/archive helper for the single F3.2.1 module.

No compiler, simulator, tool installation, deletion, or source-project writes.
Existing Reader and Guard enforce the two fixed server directory boundaries.
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

import base64
import json
import os
from audit_fourstate_remote import Reader, RTL
from fourstate_sync_remote import Guard, verify_release
from fourstate_sync_common import (encoded, identifier, relative, sha, checksum,
                                  INPUT_ARCHIVE_LIMIT, check_workspace_space)

AUDIT_RUN='f31-audit-20261017t132101z-eb28641fbd74'
MODULE='PriorityMuxModule_25.sv'
EXPECTED='715a865bece5513803c58422766b2b499b12dca89a5d829a66f5524e8da95a52'


def archive_preflight(guard,request):
    run=identifier(request['run_id']);version=identifier(request['version'])
    verified=verify_release(guard,identifier(request['snapshot_id']))
    files=request['files'];seen=set();total=0
    if not isinstance(files,list) or not 1<=len(files)<=100:raise ValueError('invalid file whitelist')
    for row in files:
        name=row['path'];relative(name);checksum(row['sha256'])
        if name.casefold() in seen:raise ValueError('duplicate archive path')
        seen.add(name.casefold())
        if type(row['bytes']) is not int or row['bytes']<0:raise ValueError('invalid archive byte count')
        total+=row['bytes']
        if not request.get('unrestricted') and total>INPUT_ARCHIVE_LIMIT:raise ValueError('128 MiB archive budget exceeded')
    for name in seen:
        parts=name.split('/')
        if any('/'.join(parts[:i]) in seen for i in range(1,len(parts))):raise ValueError('archive file/directory collision')
    target='runs/'+run+'/reports/'+version
    if guard.exists(target):raise FileExistsError('archive target already exists: '+target)
    space=check_workspace_space(guard,total+1024**2)
    return dict(status='ARCHIVE_READY',run_id=run,version=version,snapshot_id=request['snapshot_id'],
                manifest_sha256=verified['manifest_sha256'],bytes=total,files=files,
                archive_limit_bytes=None if request.get('unrestricted') else INPUT_ARCHIVE_LIMIT,space=space)


def archive_files(guard,request):
    files=request['files'];payloads={};total=0
    if not isinstance(files,list) or not 1<=len(files)<=100:raise ValueError('invalid file whitelist')
    for row in files:
        name=row['path'];relative(name)
        if name.casefold() in {n.casefold() for n in payloads}:raise ValueError('duplicate archive path')
        data=base64.b64decode(row['base64'],validate=True);total+=len(data)
        if not request.get('unrestricted') and total>INPUT_ARCHIVE_LIMIT:raise ValueError('128 MiB archive budget exceeded')
        if sha(data)!=row['sha256']:raise ValueError('archive payload hash mismatch')
        payloads[name]=data
    metadata=[dict(path=n,bytes=len(v),sha256=sha(v)) for n,v in payloads.items()]
    ready=archive_preflight(guard,dict(request,files=metadata))
    target='runs/'+ready['run_id']+'/reports/'+ready['version']
    with guard.directory(target,create=True,exclusive=True):pass
    for name,data in payloads.items():guard.new_file(target+'/'+name,data)
    # Read actual files back through Guard, not just the received memory buffer.
    for row in metadata:
        if sha(guard.read(target+'/'+row['path'],row['bytes']))!=row['sha256']:
            raise ValueError('written archive SHA256 mismatch: '+row['path'])
    result=dict(status='ARCHIVED',run_id=ready['run_id'],version=ready['version'],snapshot_id=request['snapshot_id'],
                manifest_sha256=ready['manifest_sha256'],bytes=total,
                files=[dict(row,path='reports/'+ready['version']+'/'+row['path']) for row in metadata],
                verification='SHA256_READBACK_MATCH',archive_limit_bytes=ready['archive_limit_bytes'],space=ready['space'])
    guard.new_file(target+'/archive-receipt.json',encoded(result))
    return result


def main(request):
    guard=Guard();run=identifier(request['run_id']);base='runs/'+run
    if request['operation']=='acquire':
        reader=Reader();record=reader.read(RTL+'/'+MODULE,1024**2)
        data=record['text'].encode('utf-8')
        audit='runs/'+AUDIT_RUN
        inventory=json.loads(guard.read(audit+'/reports/inputs.json',8*1024**2))
        item=next(r for r in inventory['files'] if r['name']==MODULE)
        copied=guard.read(audit+'/inputs/'+MODULE,1024**2)
        if data!=copied or sha(data)!=EXPECTED or item['sha256']!=EXPECTED:
            raise ValueError('original RTL / audited copy / expected hash differ')
        disk=os.fstatvfs(guard.root);free=disk.f_bavail*disk.f_frsize
        if free<1024**3:raise ValueError('less than 1 GiB free')
        with guard.directory(base,create=True,exclusive=True):pass
        guard.new_file(base+'/reports/source/'+MODULE,data)
        receipt=dict(status='SOURCE_ACQUIRED',run_id=run,audit_run=AUDIT_RUN,module=MODULE,
                     sha256=sha(data),bytes=len(data),original_record=record,
                     audited_source=item,free_bytes=free,
                     original_read_flags='O_RDONLY|O_NOFOLLOW|O_NOATIME; no fallback',
                     source_copy='reports/source/'+MODULE,execution_location='Windows; server data acquisition/archive only')
        guard.new_file(base+'/reports/input-receipt.json',encoded(receipt))
        result={k:v for k,v in receipt.items() if k not in ('original_record','audited_source')}
    elif request['operation']=='archive-preflight':result=archive_preflight(guard,request)
    elif request['operation']=='archive':result=archive_files(guard,request)
    else:raise ValueError('unsupported operation')
    guard.close();print(encoded(result).decode(),end='')
