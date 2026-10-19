"""F3.1 static-only audit: guarded SSH collection and offline pyslang analysis.

No conversion, simulator, firtool, Yosys, Lean or remote project code is invoked.
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
import datetime as dt
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time
import uuid

ROOT = _PROJECT_ROOT
REMOTE = ROOT / 'scripts/verification/four_state/audit_fourstate_remote.py'
SSH = ['ssh.exe', '-T', '-a', '-x', '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=yes',
       '-o', 'UpdateHostKeys=no', '-o', 'ClearAllForwardings=yes', '-o', 'PermitLocalCommand=no',
       '-o', 'ConnectTimeout=15', '-o', 'ServerAliveInterval=15', '-o', 'ServerAliveCountMax=2', 'amax']


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def read(path):
    return json.loads(path.read_text(encoding='utf-8'))


def digest(path):
    h = hashlib.sha256()
    with path.open('rb') as stream:
        for data in iter(lambda: stream.read(1024 * 1024), b''):
            h.update(data)
    return h.hexdigest()


def local_path(base, name):
    from audit_fourstate_remote import relative
    parts = relative(name)
    if not parts or any(':' in p for p in parts):
        raise ValueError('invalid local mirror path')
    path = base.joinpath(*parts)
    if not path.resolve().is_relative_to(base.resolve()):
        raise ValueError('local path escaped')
    return path


def baseline():
    parent = ROOT / 'experiments/fourstate/f3-1-audit'
    folder = parent / (dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ') + '-' + uuid.uuid4().hex[:8])
    folder.mkdir(parents=True, exist_ok=False)
    for name, args in [('head', ['rev-parse', 'HEAD']), ('status', ['status', '--porcelain=v1', '-uall']),
                       ('diff', ['diff', '--binary']), ('tracked', ['ls-files', '-z'])]:
        result = subprocess.run(['git', *args], cwd=ROOT, capture_output=True, check=True)
        (folder / ('baseline-' + name + '.txt')).write_bytes(result.stdout)
    names = subprocess.check_output(['git', 'ls-files', '-z'], cwd=ROOT).decode().split('\x00')
    tracked = {name: digest(ROOT / name) for name in names if name and (ROOT / name).is_file()}
    write(folder / 'baseline-tracked-hashes.json', tracked)
    snapshot = {}
    for path in [*((ROOT / 'scripts').rglob('*fourstate*.py')),
                 ROOT / 'docs/fourstate-frontend.md',
                 ROOT / 'AGENTS.md', ROOT / 'verification/fourstate/parser-lock.json']:
        if path.is_file():
            target = folder / 'source-snapshot' / path.relative_to(ROOT)
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(path.read_bytes())
            snapshot[path.relative_to(ROOT).as_posix()] = digest(path)
    write(folder / 'source-snapshot.json', snapshot)
    write(folder / 'scope.json', dict(phase='F3.1', conversion=False, simulation=False,
          remote_root='/data2/home/lvhongqing/cgt/chisel2lean', remote_project_writes=False,
          ssh_system_records_allowed=True, noatime_required=True, max_rtl_bytes=2*1024**3,
          max_metadata_bytes=20*1024**2, elaboration_seconds=1800,
          elaboration_memory='min(50% physical RAM, 16 GiB)', created_utc=dt.datetime.now(dt.timezone.utc).isoformat()))
    print(folder, flush=True)


def collect(folder, mode, request):
    attempts = folder / 'ssh'
    attempts.mkdir(exist_ok=True)
    log = attempts / ('%03d-%s' % (len(list(attempts.glob('*/command.json'))), mode))
    log.mkdir()
    data = read(request) if request else {}
    if mode == 'metadata':
        used = sum(p.stat().st_size for p in (folder / 'metadata').rglob('*') if p.is_file()) if (folder / 'metadata').exists() else 0
        if used >= 20 * 1024**2:
            raise ValueError('cumulative metadata budget reached')
    source = 'REQUEST = ' + repr(data) + '\n' + REMOTE.read_text(encoding='utf-8')
    (log / 'stdin.py').write_text(source, encoding='utf-8')
    command = SSH + ['/usr/bin/python3 -I -B -S - ' + mode]
    write(log / 'command.json', dict(argv=command, stdin_sha256=digest(log/'stdin.py'),
          request=data, start_utc=dt.datetime.now(dt.timezone.utc).isoformat()))
    started = time.monotonic()
    with (log / 'stderr.log').open('wb') as errors:
        process = subprocess.Popen(command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=errors)
        # Input is <1 MiB for this corpus; send it on a writer thread to avoid pipe deadlock.
        import threading
        def send():
            try:
                process.stdin.write(source.encode('utf-8'))
                process.stdin.close()
            except BrokenPipeError:
                pass
        sender = threading.Thread(target=send)
        sender.start()
        try:
            if mode == 'stream':
                receive_stream(folder, process.stdout, log, data['inventory'])
            else:
                output = process.stdout.read(25 * 1024**2 + 1)
                (log / 'stdout.json').write_bytes(output)
                if len(output) > 25 * 1024**2:
                    raise ValueError('metadata stdout budget exceeded')
            code = process.wait(timeout=60)
        except BaseException:
            process.kill()
            process.wait()
            raise
        finally:
            sender.join(timeout=10)
            write(log / 'result.json', dict(exit_code=process.poll(), seconds=time.monotonic()-started,
                 stderr_sha256=digest(log/'stderr.log')))
    if code:
        raise RuntimeError('SSH read failed; see ' + str(log))
    if mode != 'stream':
        result = read(log / 'stdout.json')
        write(folder / (mode + '.json'), result)
        if mode == 'metadata':
            for item in result['files']:
                target = local_path(folder / 'metadata', item['path'])
                target.parent.mkdir(parents=True, exist_ok=True)
                content = item['text'].encode('utf-8')
                if hashlib.sha256(content).hexdigest() != item['sha256']:
                    raise ValueError('metadata byte mismatch')
                if target.exists() and target.read_bytes() != content:
                    raise ValueError('metadata changed across reads')
                target.write_bytes(content)
            used = sum(p.stat().st_size for p in (folder/'metadata').rglob('*') if p.is_file())
            if used > 20 * 1024**2:
                raise ValueError('cumulative metadata budget exceeded')
    print(json.dumps(dict(mode=mode, log=str(log), exit_code=code), ensure_ascii=False), flush=True)


def receive_stream(folder, stream, log, inventory):
    frames, expected = [], {r['path']: r for r in inventory['files']}
    seen, complete = set(), None
    while True:
        line = stream.readline(1024*1024)
        if not line:
            break
        frame = json.loads(line)
        frames.append(frame)
        if frame['type'] == 'complete':
            complete = frame
            if stream.read(1):
                raise ValueError('trailing stream bytes')
            break
        if frame['type'] != 'file' or frame['path'] in seen or frame['path'] not in expected:
            raise ValueError('unexpected stream file')
        if frame['bytes'] != expected[frame['path']]['bytes']:
            raise ValueError('stream size differs from frozen inventory')
        target = local_path(folder / 'mirror', frame['path'])
        target.parent.mkdir(parents=True, exist_ok=True)
        if target.exists():
            raise ValueError('refusing to overwrite mirror')
        checksum, remaining = hashlib.sha256(), frame['bytes']
        with target.open('xb') as output:
            while remaining:
                chunk = stream.read(min(1024*1024, remaining))
                if not chunk:
                    raise EOFError('incomplete RTL')
                remaining -= len(chunk)
                checksum.update(chunk)
                output.write(chunk)
        receipt = json.loads(stream.readline(1024*1024))
        frames.append(receipt)
        if receipt['type'] != 'digest' or receipt['path'] != frame['path'] or receipt['sha256'] != checksum.hexdigest():
            raise ValueError('stream checksum mismatch')
        seen.add(frame['path'])
        if len(seen) % 50 == 0:
            print('received', len(seen), '/', len(expected), flush=True)
    write(log / 'stdout-frames.json', frames)
    if not complete or seen != set(expected) or complete['bytes'] != inventory['bytes']:
        raise ValueError('incomplete corpus')
    write(folder / 'transfer.json', dict(status='PASS', completion=complete,
          files=[f for f in frames if f['type']=='digest']))


def server_call(folder, operation, request):
    """Send versioned stdlib workers in memory; all server writes use fixed Guard."""
    import fourstate_sync
    names=['fourstate_sync_common','fourstate_sync_remote','audit_fourstate_remote','audit_fourstate_syntax','audit_fourstate_analysis','audit_fourstate_server']
    code='import sys,types\n'
    hashes={}
    for name in names:
        content=(ROOT/'scripts'/(name+'.py')).read_text(encoding='utf-8')
        hashes[name]=hashlib.sha256(content.encode()).hexdigest()
        code+='m=types.ModuleType('+repr(name)+');sys.modules['+repr(name)+']=m\n'
        code+='exec('+repr(content)+',m.__dict__)\n'
    request=dict(request,workers_sha256=hashes)
    code+='getattr(sys.modules[\'audit_fourstate_server\'],'+repr(operation)+')('+repr(request)+')\n'
    # Windows OpenSSH / remote stdin encoding can split non-ASCII source bytes.
    # Escape only the transport representation; Python reconstructs exact strings.
    code=code.encode('ascii','backslashreplace').decode('ascii')
    log=folder/('server-'+operation+'-'+uuid.uuid4().hex[:8]);log.mkdir()
    (log/'stdin.py').write_bytes(code.encode('ascii'))
    command=['ssh.exe','-T','-a','-x',*fourstate_sync.OPTIONS,'amax','/usr/bin/python3 -I -B -S -']
    write(log/'command.json',dict(argv=command,workers_sha256=hashes,request=request))
    with (log/'stdout.json').open('wb') as stdout,(log/'stderr.log').open('wb') as stderr:
        result=subprocess.run(command,input=code.encode(),stdout=stdout,stderr=stderr,timeout=2400)
    write(log/'result.json',dict(exit_code=result.returncode))
    if result.returncode:raise RuntimeError('Server audit failed; see '+str(log))
    return read(log/'stdout.json')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='action', required=True)
    sub.add_parser('baseline')
    get = sub.add_parser('collect')
    get.add_argument('folder', type=Path)
    get.add_argument('mode', choices=['preflight', 'metadata', 'inventory', 'stream'])
    get.add_argument('--request', type=Path)
    server=sub.add_parser('server',help='Bounded static audit in the independent Linux workspace')
    server.add_argument('folder',type=Path)
    server.add_argument('operation',choices=['probe','fixtures','formats','prepare_inputs','scan','inspect_scan',
                                            'provenance_more','hierarchy_retry','reanalyze','source_evidence','publish_reports','final_verify'])
    server.add_argument('--request',type=Path,required=True)
    args = parser.parse_args()
    if args.action == 'baseline':
        baseline()
    elif args.action == 'collect':
        collect(args.folder.resolve(), args.mode, args.request)
    elif args.action == 'server':
        print(json.dumps(server_call(args.folder.resolve(),args.operation,read(args.request)),ensure_ascii=True,indent=2))


if __name__ == '__main__':
    main()
