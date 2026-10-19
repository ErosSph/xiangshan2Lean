"""F5.2 local SSH controller. No semantic extensions or Lean invocation.

Remote bootstrap helpers are sent from reviewed local bytes; all project
reads/writes use the established Reader/Guard. Python subprocesses use -B.
"""
from __future__ import annotations
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
import datetime
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import uuid

ROOT = _PROJECT_ROOT


def write(path, value):
    Path(path).write_text(json.dumps(value, indent=2, ensure_ascii=True)+'\n', encoding='utf8')


def remote(folder, operation, request):
    import fourstate_sync as sync
    names = ['fourstate_sync_common', 'fourstate_sync_remote', 'audit_fourstate_remote', 'audit_fourstate_f52_remote']
    code = 'import sys,types\n'
    hashes = {}
    for name in names:
        raw = (ROOT/'scripts'/(name+'.py')).read_text(encoding='utf8')
        hashes[name] = hashlib.sha256(raw.encode()).hexdigest()
        code += 'm=types.ModuleType('+repr(name)+');sys.modules['+repr(name)+']=m\nexec('+ascii(raw)+',m.__dict__)\n'
    code += "sys.modules['audit_fourstate_f52_remote'].main("+ascii(dict(request, operation=operation))+')\n'
    log = Path(folder)/('ssh-'+operation+'-'+uuid.uuid4().hex[:8]);log.mkdir()
    (log/'stdin.py').write_bytes(code.encode('ascii'))
    command = ['ssh.exe','-T','-a','-x',*sync.OPTIONS,'amax','/usr/bin/python3 -I -B -S -']
    write(log/'command.json', dict(argv=command, workers_sha256=hashes, request=request,
                                 start_utc=datetime.datetime.now(datetime.timezone.utc).isoformat()))
    with (log/'stdout.json').open('wb') as out, (log/'stderr.log').open('wb') as err:
        result = subprocess.run(command, input=code.encode('ascii'), stdout=out, stderr=err)
    write(log/'result.json', dict(exit_code=result.returncode))
    if result.returncode:
        raise RuntimeError('remote operation failed: '+str(log))
    return json.loads((log/'stdout.json').read_bytes())


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('operation');p.add_argument('--out',type=Path,required=True)
    p.add_argument('--request',type=Path)
    a=p.parse_args();request=json.loads(a.request.read_bytes()) if a.request else {}
    if a.operation=='pack':
        import fourstate_sync as sync
        from fourstate_sync_common import sha, encoded, make_zip
        config=json.loads((ROOT/'verification/fourstate/sync-profile-f5.1a.json').read_bytes())
        # Frozen profile paths are also the remote archive layout. source_file()
        # reads each migrated implementation locally while preserving these keys.
        names=sorted(set(config['files']+['scripts/audit_fourstate_f52.py','scripts/audit_fourstate_f52_remote.py',
                         'scripts/audit_fourstate_f52_worker.py','scripts/audit_fourstate_analysis.py','scripts/audit_fourstate_syntax.py',
                         'scripts/common.py','scripts/verify_fourstate.py','scripts/verify_fourstate_sequential.py',
                         'scripts/verify_fourstate_cam.py','scripts/verify_fourstate_memory.py','scripts/verify_fourstate_memory_remote.py']))
        # Freeze the explicit local Python import closure, including unchanged
        # backend source needed by unit-test imports; never execute its CLI.
        import ast
        backend_tree=ast.parse((ROOT/'scripts/yosys2lean.py').read_text(encoding='utf8'))
        bridge=next(n.value for n in backend_tree.body if isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='BRIDGE_FILES' for t in n.targets))
        names+=['scripts/'+n for n in ast.literal_eval(bridge).values()]+['lean/Chisel2Lean/Functional.lean']
        pending=list(names);seen=set(names)
        while pending:
            name=pending.pop()
            if not name.endswith('.py'):continue
            source_path=sync.source_file(name)
            tree=ast.parse(source_path.read_text(encoding='utf8'))
            for node in ast.walk(tree):
                imported=([node.module] if isinstance(node,ast.ImportFrom) and node.module else
                          [a.name for a in node.names] if isinstance(node,ast.Import) else [])
                for module in imported:
                    key='scripts/'+module.split('.')[0]+'.py'
                    if sync.source_file(key).is_file() and key not in seen:seen.add(key);pending.append(key)
        names=sorted(seen)
        snapshot=sync.fresh_id('f52-source');base=sync.new_directory(ROOT/'.cache/fourstate-sync'/snapshot)
        payloads={n:sync.stable_read(sync.source_file(n),None) for n in names}
        rows=[dict(path=n,bytes=len(d),sha256=sha(d)) for n,d in sorted(payloads.items())]
        manifest=dict(format='fourstate-sync-source-v1',snapshot_id=snapshot,profile='f5.2',unrestricted=True,
                      files=rows,bytes=sum(r['bytes'] for r in rows),scope='F52 audit only; no semantic changes',
                      git=dict(head=sync.git('rev-parse','HEAD').decode().strip()))
        data=make_zip(manifest,payloads,'source')
        for name,d in payloads.items():sync.new_file(base/'source'/name,d)
        sync.new_file(base/'manifest.json',encoded(manifest));sync.new_file(base/'bundle.zip',data)
        patch=sync.git('diff','--binary','--',*names);sync.new_file(base/'selected-working-tree.patch',patch)
        receipt=dict(status='PACKED',snapshot_id=snapshot,manifest_sha256=sha(encoded(manifest)),
                     archive_sha256=sha(data),archive_bytes=len(data),files=len(rows),uncompressed_bytes=manifest['bytes'],git_diff_sha256=sha(patch))
        sync.new_file(base/'receipt.json',encoded(receipt));sync.new_file(base/'COMPLETE',encoded(dict(receipt_sha256=sha(encoded(receipt)))))
        value=dict(pack=receipt,push=sync.push(snapshot))
    else:value=remote(a.out,a.operation,request)
    write(a.out/(a.operation+'-receipt-'+uuid.uuid4().hex[:8]+'.json'),value)
    print(json.dumps(value,ensure_ascii=True))


if __name__=='__main__':main()
