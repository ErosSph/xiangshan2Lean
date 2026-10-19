"""Python 3.8: bounded Linux RAM replay, existing tools, Guard-only writes.

The four-state encoding/FunctionalIR/Lean source is produced by the authoritative
Windows frontend. Linux independently compiles original/encoded SV and Lean.
No parser installation or shared two-state backend modification is performed.
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

import json
import os
import resource
import signal
import stat
import subprocess
import time

from audit_fourstate_remote import Reader
from audit_fourstate_server import original_bytes
from fourstate_sync_remote import Guard, verify_release
from fourstate_sync_common import WORKSPACE, encoded, identifier, relative, sha

LEAN_SOURCE='.tools/lean-4.19.0-linux/'


def prepare(request,guard,base):
    reader=Reader();files=request['runtime_files'];total=sum(x['bytes'] for x in files)
    if len(files)>2000 or total>1536*1024**2:raise ValueError('existing Lean runtime copy budget exceeded')
    start=time.monotonic();rows=[]
    with guard.directory(base,create=True,exclusive=True):pass
    try:
        for row in files:
            if time.monotonic()-start>90:raise RuntimeError('runtime copy wall budget exceeded')
            path=row['path'];relative(path)
            if not path.startswith(LEAN_SOURCE):raise ValueError('Lean tool root only')
            tail=path[len(LEAN_SOURCE):]
            if not (tail=='bin/lean' or tail.startswith('lib/lean/') and (tail.endswith('.olean') or '.so' in tail.rsplit('/',1)[-1])):
                raise ValueError('non-runtime tool asset refused')
            data,info=original_bytes(reader,path,160*1024**2)
            if len(data)!=row['bytes']:raise ValueError('tool file size changed')
            dest=base+'/tool/lean/'+tail;guard.new_file(dest,data)
            if tail=='bin/lean':
                with guard.directory(base+'/tool/lean/bin') as fd:
                    f=os.open('lean',os.O_RDONLY|os.O_NOFOLLOW,dir_fd=fd)
                    try:os.fchmod(f,0o500)
                    finally:os.close(f)
            rows.append(dict(source=path,copy=dest,bytes=len(data),sha256=sha(data),source_stat=info))
    finally:os.close(reader.root)
    result=dict(status='EXISTING_RUNTIME_COPIED',files=rows,bytes=total,seconds=time.monotonic()-start,
                scope='Existing installed Lean runtime assets copied without source metadata changes; no download or software installation')
    guard.new_file(base+'/runtime-receipt.json',encoded(result))
    return dict(status=result['status'],files=len(rows),bytes=total,seconds=result['seconds'])


def run(request,guard,base):
    version=identifier(request['input_version']);source='runs/'+identifier(request['run_id'])+'/reports/'+version
    plan=json.loads(guard.read(source+'/plan.json',1024**2));payloads={}
    for row in plan['files']:
        name=row['path'];relative(name)
        if name in payloads:raise ValueError('duplicate replay asset')
        data=guard.read(source+'/'+name,16*1024**2)
        if sha(data)!=row['sha256']:raise ValueError('replay input hash mismatch')
        payloads[name]=data
    required={'original.sv','encoded.sv','ports.json','model/FourState/Model.lean','RunSequential.lean','deposit4.c',
              'explicit/request.json','uninitialized/request.json','explicit/original.sv','explicit/encoded.sv','uninitialized/original.sv','uninitialized/encoded.sv'}
    if set(payloads)!=required or sum(map(len,payloads.values()))>32*1024**2:raise ValueError('unexpected RAM replay file set/size')
    # This remote worker is deliberately scoped to the pinned real RAM.
    if sha(payloads['original.sv'])!='c37a79cbf2b29f890361a32932aa7bba0d2653157cdba299eb2c0bdc8b519b43':raise ValueError('real RAM source mismatch')
    mapping=json.loads(payloads['ports.json'])
    if mapping['top']!='ram_2x3' or len(mapping['states'])!=2 or sum(x['width'] for x in mapping['states'])!=6:raise ValueError('unexpected RAM interface')
    work=base+'/work'
    with guard.directory(work,create=True,exclusive=True):pass
    for name,data in payloads.items():guard.new_file(work+'/'+name,data)
    for path in ['tmp','cache','logs']:
        with guard.directory(work+'/'+path,create=True,exclusive=True):pass
    cwd=WORKSPACE+'/'+work;lean=WORKSPACE+'/'+base+'/tool/lean/bin/lean'
    env=dict(os.environ,TMPDIR=cwd+'/tmp',TMP=cwd+'/tmp',TEMP=cwd+'/tmp',XDG_CACHE_HOME=cwd+'/cache',
             LEAN_SYSROOT=WORKSPACE+'/'+base+'/tool/lean',LEAN_PATH=cwd+'/model',PYTHONDONTWRITEBYTECODE='1')
    commands=[];start=time.monotonic()
    def command(label,argv,seconds=60):
        if time.monotonic()-start>180:raise RuntimeError('Linux RAM total wall budget exceeded')
        for path in ['logs/'+label]:
            with guard.directory(work+'/'+path,create=True,exclusive=True):pass
        def restrict():
            os.setsid();os.nice(10)
            resource.setrlimit(resource.RLIMIT_AS,(4*1024**3,4*1024**3))
            resource.setrlimit(resource.RLIMIT_CPU,(seconds,seconds+1))
            resource.setrlimit(resource.RLIMIT_FSIZE,(64*1024**2,64*1024**2));resource.setrlimit(resource.RLIMIT_CORE,(0,0))
            if hasattr(os,'sched_setaffinity'):os.sched_setaffinity(0,set(sorted(os.sched_getaffinity(0))[:2]))
        with guard.directory(work+'/logs/'+label) as fd:
            out_fd=os.open('stdout.log',os.O_WRONLY|os.O_CREAT|os.O_EXCL|os.O_NOFOLLOW,0o600,dir_fd=fd)
            err_fd=os.open('stderr.log',os.O_WRONLY|os.O_CREAT|os.O_EXCL|os.O_NOFOLLOW,0o600,dir_fd=fd)
        process=subprocess.Popen(argv,cwd=cwd,env=env,stdout=out_fd,stderr=err_fd,preexec_fn=restrict)
        began=time.monotonic();timeout=False
        try:process.wait(timeout=seconds+5)
        except subprocess.TimeoutExpired:
            timeout=True;os.killpg(process.pid,signal.SIGKILL);process.wait()
        finally:os.close(out_fd);os.close(err_fd)
        stdout=guard.read(work+'/logs/'+label+'/stdout.log',64*1024**2)
        stderr=guard.read(work+'/logs/'+label+'/stderr.log',64*1024**2)
        row=dict(label=label,argv=argv,cwd=cwd,exit_code=process.returncode,seconds=time.monotonic()-began,timeout=timeout)
        guard.new_file(work+'/logs/'+label+'/command.json',encoded(row));commands.append(row)
        if process.returncode or timeout:raise RuntimeError('Linux command failed: '+label)
        return stdout
    versions={}
    for name,argv in [('lean',[lean,'--version']),('iverilog',['/usr/bin/iverilog','-V']),('vvp',['/usr/bin/vvp','-V']),('gcc',['/usr/bin/gcc','--version'])]:versions[name]=command('version-'+name,argv,10).decode('utf8',errors='replace')
    if '4.19.0' not in versions['lean']:raise ValueError('Lean version mismatch')
    command('model-compile',[lean,'-j','2','-s','65536','-o',cwd+'/model/FourState/Model.olean',cwd+'/model/FourState/Model.lean'])
    command('vpi-compile',['/usr/bin/gcc','-shared','-fPIC','-O2','-Wall','-Wextra','-Werror','-I/usr/include/iverilog',cwd+'/deposit4.c','-o',cwd+'/deposit4.vpi'])
    ports=[p for p in mapping['ports'] if p['direction']=='output'];states=mapping['states']
    def decode(items,values,state=False):
        result={};expected=set()
        for p in items:
            tk,vk=('current_tag','current_value') if state else ('tag','value');t,v=values[p[tk]],values[p[vk]];expected.update([p[tk],p[vk]])
            if type(t) is not int or type(v) is not int or not 0<=t<(1<<p['width']) or not 0<=v<(1<<p['width']):raise ValueError('invalid binary rail')
            result[p['name']]=''.join('01xz'[(((t>>i)&1)<<1)|((v>>i)&1)] for i in reversed(range(p['width'])))
        if set(values)!=expected:raise ValueError('rail key set mismatch')
        return result
    def rtl_rows(stdout,binary):
        descriptors=[('outputs',p[k],p['width']) for p in ports for k in (('tag','value') if binary else ('name',))]
        descriptors += [('states',p[k],p['width']) for p in states for k in (('current_tag','current_value') if binary else ('name',))]
        rows=[]
        for line in stdout.decode('ascii').splitlines():
            if '$finish called' in line:continue
            fields=line.split()
            if fields[:2]!=[str(len(rows)//2),('pre','post')[len(rows)%2]] or len(fields)!=len(descriptors)+2:raise ValueError('malformed/missing RTL sample')
            row=dict(outputs={},states={})
            for (section,name,width),bits in zip(descriptors,fields[2:]):
                if len(bits)!=width or set(bits)-set('01' if binary else '01xz'):raise ValueError('invalid four-state result')
                row[section][name]=int(bits,2) if binary else bits
            if binary:row=dict(outputs=decode(ports,row['outputs']),states=decode(states,row['states'],True))
            rows.append(row)
        return rows
    results=[]
    for kind in ['explicit','uninitialized']:
        command(kind+'-original-compile',['/usr/bin/iverilog','-g2012','-s','tb','-o',cwd+'/'+kind+'/original.vvp',cwd+'/original.sv',cwd+'/'+kind+'/original.sv'])
        a=rtl_rows(command(kind+'-original-run',['/usr/bin/vvp','-M',cwd,'-m','deposit4',cwd+'/'+kind+'/original.vvp']),False)
        command(kind+'-encoded-compile',['/usr/bin/iverilog','-g2012','-s','tb','-o',cwd+'/'+kind+'/encoded.vvp',cwd+'/encoded.sv',cwd+'/'+kind+'/encoded.sv'])
        b=rtl_rows(command(kind+'-encoded-run',['/usr/bin/vvp',cwd+'/'+kind+'/encoded.vvp']),True)
        lean_stdout=command(kind+'-lean-run',[lean,'-j','2','-s','65536','--run',cwd+'/RunSequential.lean',cwd+'/'+kind+'/request.json'])
        c=[json.loads(line) for line in lean_stdout.decode('utf8').splitlines() if line.strip()]
        if len(a)!=len(b) or len(a)!=2*len(c) or len(c)!=4640:raise ValueError('Linux replay sample count mismatch')
        for i,row in enumerate(c):
            if row['sample']!=i:raise ValueError('Lean sample metadata mismatch')
            for j,phase in enumerate(['pre','post']):
                observed=dict(outputs=decode(ports,row[phase]['outputs']),states=decode(states,row[phase]['states'],True))
                if a[2*i+j]!=b[2*i+j] or a[2*i+j]!=observed:raise ValueError('Linux three-way mismatch at '+str((kind,i,phase)))
        results.append(dict(initial=kind,samples=len(c),status='THREE_WAY_PASS',original_state_bits=6))
    result=dict(status='LINUX_RAM_THREE_WAY_PASS',source_sha256=sha(payloads['original.sv']),cases=results,versions=versions,commands=commands,
                seconds=time.monotonic()-start,child_peak_rss_bytes=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss*1024,
                parent_peak_rss_bytes=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss*1024,
                limits=dict(address_space_bytes=4*1024**3,cpu_cores=2,parallel_jobs=1,per_command_seconds=60,total_seconds=180),
                scope='Windows authoritative frontend/encoded RTL/FunctionalIR/Lean source; Linux independently compiles original and encoded RTL, compiles and executes Lean, compares all outputs/all original memory words; no Linux frontend/FunctionalIR generation claimed')
    guard.new_file(base+'/result.json',encoded(result));return result


def main(request):
    guard=Guard();verify_release(guard,identifier(request['snapshot_id']))
    disk=os.fstatvfs(guard.root)
    if disk.f_bavail*disk.f_frsize<6*1024**3:raise ValueError('less than 6 GiB workspace free')
    if os.sysconf('SC_AVPHYS_PAGES')*os.sysconf('SC_PAGE_SIZE')<4*1024**3:raise ValueError('less than 4 GiB free physical RAM')
    base='runs/'+identifier(request['run_id'])+'/linux'
    try:
        if request['operation']=='prepare-memory-runtime':result=prepare(request,guard,base)
        elif request['operation']=='run-memory-linux':result=run(request,guard,base)
        elif request['operation']=='stage-memory-results':
            receipt=json.loads(guard.read(base+'/result.json',1024**2))
            paths=[base+'/result.json',base+'/runtime-receipt.json']
            for row in receipt['commands']:
                label=identifier(row['label'])
                paths.extend(base+'/work/logs/'+label+'/'+name for name in ['stdout.log','stderr.log','command.json'])
            dest='runs/'+identifier(request['run_id'])+'/reports/linux-evidence'
            with guard.directory(dest,create=True,exclusive=True):pass
            rows=[];total=0
            for i,path in enumerate(paths):
                data=guard.read(path,16*1024**2);total+=len(data)
                if total>64*1024**2:raise ValueError('Linux evidence staging byte budget exceeded')
                name='f'+str(i).zfill(4)+'.'+path.rsplit('.',1)[-1]
                guard.new_file(dest+'/'+name,data);rows.append(dict(path='reports/linux-evidence/'+name,original=path,sha256=sha(data),bytes=len(data)))
            guard.new_file(dest+'/index.json',encoded(rows));result=dict(status='STAGED',files=rows,bytes=total,index='reports/linux-evidence/index.json')
        else:raise ValueError('unsupported memory worker operation')
        print(encoded(result).decode(),end='')
    finally:guard.close()
