"""F4.4 data-only acquisition; original Reader, own-workspace Guard, no installs."""
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

import os
from audit_fourstate_remote import Reader,RTL
from audit_fourstate_server import original_bytes
from fourstate_sync_remote import Guard,verify_release
from fourstate_sync_common import encoded,identifier,relative,sha


def main(request):
    if request['operation']!='acquire':raise ValueError('acquire only')
    guard,reader=Guard(),Reader()
    verify_release(guard,identifier(request['snapshot_id']))
    disk=os.fstatvfs(guard.root)
    if disk.f_bavail*disk.f_frsize<1024**3:raise ValueError('less than 1 GiB free')
    files=request['files']
    if not 1<=len(files)<=100:raise ValueError('pilot acquisition limit is 100 files')
    payloads={};total=0
    for row in files:
        name=row['name'];relative(name)
        if name in payloads:raise ValueError('duplicate source')
        data,metadata=original_bytes(reader,RTL+'/'+name,2*1024**2)
        if sha(data)!=row['sha256']:raise ValueError('SOURCE_HASH_MISMATCH: '+name)
        total+=len(data)
        if total>8*1024**2:raise ValueError('pilot acquisition exceeds 8 MiB')
        payloads[name]=(data,metadata)
    # All hashes pass before a new run directory is written.
    base='runs/'+identifier(request['run_id'])
    with guard.directory(base,create=True,exclusive=True):pass
    rows=[]
    for name,(data,metadata) in payloads.items():
        target='reports/inputs/'+name;guard.new_file(base+'/'+target,data)
        rows.append(dict(name=name,path=target,sha256=sha(data),bytes=len(data),source=RTL+'/'+name,source_stat=metadata))
    receipt=dict(status='SOURCES_ACQUIRED',run_id=request['run_id'],snapshot_id=request['snapshot_id'],files=rows,bytes=total,
                 original_access='Reader O_RDONLY|O_NOFOLLOW|O_NOATIME; no fallback',original_writes=False,
                 free_bytes=disk.f_bavail*disk.f_frsize)
    guard.new_file(base+'/reports/input-receipt.json',encoded(receipt));guard.close();os.close(reader.root)
    print(encoded(receipt).decode(),end='')
