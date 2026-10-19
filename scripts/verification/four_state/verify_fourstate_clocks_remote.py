"""Python 3.8, Guard-owned Linux execution for F4.6 only; no installation."""
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
import subprocess
import stat
import struct
import time
from audit_fourstate_remote import Reader, RTL
from audit_fourstate_server import original_bytes, needed, TOOL
from fourstate_sync_common import WORKSPACE, encoded, identifier, relative, sha, INPUT_ARCHIVE_LIMIT
from fourstate_sync_remote import Guard, verify_release
from verify_fourstate_prioritymux_remote import main as archive, AUDIT_RUN
from fourstate_bounded_events import runner_source, validate_trace, decode_results
from verify_fourstate_clocks import benches, parse_rtl, compare

RUNTIME='runs/f45-memory-20261017t173407z-1118f143/linux/tool/lean'


def prepare_reference(g,request):
    """Copy already-installed runtime assets, with O_NOATIME source access."""
    r=Reader();base='runs/'+identifier(request['run_id'])+'/tool/iverilog-v3'
    with g.directory(base,create=True,exclusive=True):pass
    queue=['bin/iverilog','bin/vvp','lib/ivl/ivl','lib/ivl/ivlpp','lib/ivl/vvp.conf','lib/ivl/vvp-s.conf',
           'lib/ivl/vvp.tgt','lib/ivl/system.vpi','lib/ivl/v2009.vpi','lib/ivl/v2005_math.vpi',
           'libexec/iverilog','libexec/vvp','libexec/ivl','libexec/ivlpp','lib/ld-linux-x86-64.so.2']
    seen=set();rows=[];total=0
    try:
        while queue:
            name=queue.pop(0)
            if name in seen:continue
            seen.add(name);source_name=name
            # Do not read or follow source symlinks. A required soname can be
            # materialized from the unique regular versioned ELF whose own
            # DT_SONAME matches it. Every file read still uses Reader.file.
            if name.startswith('lib/') and '/' not in name[4:]:
                entries=r.listing(TOOL+'/lib');entry=next((x for x in entries if x['name']==name[4:]),None)
                if entry is not None and stat.S_ISLNK(entry['mode']):
                    choices=[x['name'] for x in entries if x['name'].startswith(name[4:]+'.') and stat.S_ISREG(x['mode'])]
                    if len(choices)!=1:raise ValueError('ambiguous regular soname asset')
                    source_name='lib/'+choices[0]
            data,info=original_bytes(r,TOOL+'/'+source_name,64*1024**2);total+=len(data)
            if source_name!=name:
                offset=struct.unpack_from('<Q',data,40)[0];stride,count=struct.unpack_from('<HH',data,58)
                sections=[struct.unpack_from('<IIQQQQIIQQ',data,offset+i*stride) for i in range(count)]
                sonames=[]
                for section in sections:
                    if section[1]!=6:continue
                    strings=sections[section[6]];table=data[strings[4]:strings[4]+strings[5]]
                    for at in range(section[4],section[4]+section[5],16):
                        tag,value=struct.unpack_from('<qQ',data,at)
                        if tag==14:sonames.append(table[value:table.index(b'\0',value)].decode('ascii'))
                if sonames!=[name[4:]]:raise ValueError('ELF soname mismatch')
            if total>128*1024**2:raise ValueError('reference runtime copy exceeds 128 MiB')
            g.new_file(base+'/'+name,data)
            with g.directory(base+'/'+name.rsplit('/',1)[0]) as fd:
                f=os.open(name.rsplit('/',1)[1],os.O_RDONLY|os.O_NOFOLLOW,dir_fd=fd)
                try:os.fchmod(f,0o500 if name.startswith(('bin/','libexec/')) or name in ('lib/ivl/ivl','lib/ivl/ivlpp','lib/ld-linux-x86-64.so.2') else 0o400)
                finally:os.close(f)
            rows.append(dict(source=TOOL+'/'+source_name,copy=base+'/'+name,bytes=len(data),sha256=sha(data),source_stat=info))
            if data[:4]==b'\x7fELF':queue.extend('lib/'+n for n in needed(data) if 'lib/'+n not in seen)
    finally:os.close(r.root)
    result=dict(status='EXISTING_REFERENCE_RUNTIME_COPIED',files=rows,bytes=total,scope='existing tool assets only; no installation or original-project execution')
    g.new_file('runs/'+identifier(request['run_id'])+'/reports/reference-runtime-v3.json',encoded(result))
    return result


def acquire(g,request):
    r=Reader();rows=[]
    try:
        inventory=json.loads(g.read('runs/'+AUDIT_RUN+'/reports/inputs.json',8*1024**2))
        for n in ['ClockGate.sv','JtagTapController.sv','JtagStateMachine.sv','CaptureUpdateChain_2.sv']:
            data=r.read(RTL+'/'+n,1024**2)
            audited=next(x for x in inventory['files'] if x['name']==n)
            if data['sha256']!=audited['sha256'] or data['text'].encode()!=g.read('runs/'+AUDIT_RUN+'/inputs/'+n,1024**2):
                raise ValueError('F3.1 source hash/copy mismatch')
            rows.append(dict(original=data,audited=audited))
    finally:os.close(r.root)
    return dict(status='F31_SOURCES_MATCH',files=rows)


def run(g,request):
    verify_release(g,identifier(request['snapshot_id']))
    run=identifier(request['run_id']);case=identifier(request['case_id']);version=identifier(request['input_version'])
    source='runs/'+run+'/reports/'+version
    plan=json.loads(g.read(source+'/plan.json',1024**2))
    payloads={}
    for row in plan['files']:
        name=row['path'];relative(name);data=g.read(source+'/'+name,None if request.get('unrestricted') else 16*1024**2)
        if name in payloads or sha(data)!=row['sha256']:raise ValueError('duplicate or changed case asset')
        payloads[name]=data
    if not request.get('unrestricted') and sum(map(len,payloads.values()))>INPUT_ARCHIVE_LIMIT:raise ValueError('128 MiB case byte budget exceeded')
    references=plan.get('windows_references',[])
    if references and (len(references)!=len(json.loads(payloads['initials.json'])) or
                       any(x.get('status')!='RAW_MODELSIM_PASS' for x in references)):
        raise ValueError('invalid explicit Windows reference receipts')
    reference_files={x['file'] for x in references}
    if set(payloads)-{'ports.json','model/FourState/Model.lean','RunEvents.lean','encoded.sv','trace.json','initials.json','deposit4.c'}-set(plan['original_sources'])-reference_files:
        raise ValueError('unexpected case asset')
    mapping=json.loads(payloads['ports.json']);trace=json.loads(payloads['trace.json']);initials=json.loads(payloads['initials.json'])
    if len(trace)>12000 or not 1<=len(initials)<=4:raise ValueError('event sample budget exceeded')
    for initial in initials:validate_trace(mapping,trace,initial)
    # Reuse the prior safe, immutable runtime copy; verify executable bytes.
    receipt=json.loads(g.read('runs/f45-memory-20261017t173407z-1118f143/linux/runtime-receipt.json',1024**2))
    lean_bytes=g.read(RUNTIME+'/bin/lean',16*1024**2)
    item=next(x for x in receipt['files'] if x['copy']==RUNTIME+'/bin/lean')
    if sha(lean_bytes)!=item['sha256']:raise ValueError('reused Lean runtime executable changed')
    with g.directory(RUNTIME+'/lib/lean'):pass
    base='runs/'+run+'/work/'+case;report='runs/'+run+'/reports/linux-'+case
    with g.directory(base,create=True,exclusive=True):pass
    with g.directory(report,create=True,exclusive=True):pass
    for n,data in payloads.items():g.new_file(base+'/'+n,data)
    for n in ('tmp','cache'):
        with g.directory(base+'/'+n,create=True,exclusive=True):pass
    cwd=WORKSPACE+'/'+base;lean=WORKSPACE+'/'+RUNTIME+'/bin/lean'
    reference_run=identifier(request.get('reference_run_id',run))
    reference='runs/'+reference_run+'/tool/iverilog-v3'
    runtime=json.loads(g.read('runs/'+reference_run+'/reports/reference-runtime-v3.json',1024**2))
    for x in runtime['files']:
        if sha(g.read(x['copy'],64*1024**2))!=x['sha256']:raise ValueError('reference tool asset changed')
    iv=WORKSPACE+'/'+reference+'/bin/iverilog';vp=WORKSPACE+'/'+reference+'/bin/vvp'
    ivl=WORKSPACE+'/'+reference+'/lib/ivl'
    env=dict(os.environ,TMPDIR=cwd+'/tmp',TEMP=cwd+'/tmp',TMP=cwd+'/tmp',XDG_CACHE_HOME=cwd+'/cache',
             HOME=cwd+'/cache',LEAN_SYSROOT=WORKSPACE+'/'+RUNTIME,LEAN_PATH=cwd+'/model',PYTHONDONTWRITEBYTECODE='1')
    commands=[];start=time.monotonic()
    def command(label,argv,seconds=60):
        log=report+'/'+identifier(label)
        with g.directory(log,create=True,exclusive=True) as fd:
            out=os.open('stdout.log',os.O_WRONLY|os.O_CREAT|os.O_EXCL|os.O_NOFOLLOW,0o600,dir_fd=fd)
            err=os.open('stderr.log',os.O_WRONLY|os.O_CREAT|os.O_EXCL|os.O_NOFOLLOW,0o600,dir_fd=fd)
        def restrict():
            os.setsid();os.nice(10)
            # F5.1 user authorization removes imposed CPU, memory, file and time caps.
            resource.setrlimit(resource.RLIMIT_CORE,(0,0))
        if len(argv)>2 and argv[0]==lean and argv[1:3]==['-j','2']:
            argv=[argv[0],*argv[3:]]
        began=time.monotonic();p=subprocess.Popen(argv,cwd=cwd,env=env,stdout=out,stderr=err,preexec_fn=restrict)
        timeout=False
        try:p.wait()
        finally:os.close(out);os.close(err)
        row=dict(label=label,argv=argv,cwd=cwd,exit_code=p.returncode,seconds=time.monotonic()-began,timeout=timeout)
        g.new_file(log+'/command.json',encoded(row));commands.append(row)
        if p.returncode or timeout:raise RuntimeError('command failed: '+label+'; '+g.read(log+'/stderr.log',64*1024**2).decode('utf8',errors='replace')[:4000])
        return g.read(log+'/stdout.log',None if request.get('unrestricted') else 64*1024**2).decode('utf8')
    try:
        versions=dict(lean=command('version-lean',[lean,'--version'],10),iverilog=command('version-iverilog',[iv,'-B',ivl,'-V'],10))
        if '4.19.0' not in versions['lean']:raise ValueError('Lean version mismatch')
        command('model-compile',[lean,'-j','2','-s','65536','-o',cwd+'/model/FourState/Model.olean',cwd+'/model/FourState/Model.lean'])
        command('vpi-compile',['/usr/bin/gcc','-shared','-fPIC','-O2','-Wall','-Wextra','-Werror','-I/usr/include/iverilog',cwd+'/deposit4.c','-o',cwd+'/deposit4.vpi'])
        cases=[]
        for i,initial in enumerate(initials):
            name='initial-'+str(i);b=benches(mapping,trace,initial,compact=plan.get('compact_bench',False))
            if request.get('reset_fault'):
                from verify_fourstate_clocks import reset_fault_bench
                b['encoded']=reset_fault_bench(mapping,b['encoded'],request['reset_fault'])
            g.new_file(base+'/'+name+'/original-tb.sv',b['original'].encode())
            g.new_file(base+'/'+name+'/encoded-tb.sv',b['encoded'].encode())
            rows,init=validate_trace(mapping,trace,initial)
            g.new_file(base+'/'+name+'/request.json',encoded(dict(trace=rows,initial=init)))
            if references:
                ref=references[i];data=payloads[ref['file']]
                if sha(data)!=ref['sha256']:raise ValueError('Windows reference SHA256 mismatch')
                a=parse_rtl(mapping,data.decode('ascii'),b['original_descriptors'],len(trace))
            else:
                command(name+'-original-compile',[iv,'-B',ivl,'-g2012','-s','tb','-o',cwd+'/'+name+'/original.vvp',*[cwd+'/'+n for n in plan['original_sources']],cwd+'/'+name+'/original-tb.sv'])
                a=parse_rtl(mapping,command(name+'-original-run',[vp,'-M',ivl,'-M',cwd,'-m','deposit4',cwd+'/'+name+'/original.vvp']),b['original_descriptors'],len(trace))
            command(name+'-encoded-compile',[iv,'-B',ivl,'-g2012','-s','tb','-o',cwd+'/'+name+'/encoded.vvp',cwd+'/encoded.sv',cwd+'/'+name+'/encoded-tb.sv'])
            c=parse_rtl(mapping,command(name+'-encoded-run',[vp,'-M',ivl,cwd+'/'+name+'/encoded.vvp']),b['encoded_descriptors'],len(trace),True)
            raw=[json.loads(line) for line in command(name+'-lean-run',[lean,'-j','2','-s','65536','--run',cwd+'/RunEvents.lean',cwd+'/'+name+'/request.json']).splitlines() if line.strip()]
            d=decode_results(mapping,raw)
            if len(d)!=len(trace):raise ValueError('Incomplete actual Lean trace')
            result=compare(mapping,a,c,d);result['initial']=initial;cases.append(result)
        result=dict(status='THREE_WAY_PASS',top=mapping['top'],cases=cases,commands=commands,versions=versions,
                    seconds=time.monotonic()-start,child_peak_rss_bytes=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss*1024,
                    parent_peak_rss_bytes=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss*1024,
                    limits=dict(address_space_bytes=None,cpu_cores=None,parallel_jobs=1,per_command_seconds=None,case_seconds=None,
                                imposed_single_file_bytes=None),
                    inputs=plan['files'],runtime=RUNTIME,reference_runtime=reference,
                    windows_references=references,
                    scope='Windows pinned frontend/FunctionalIR; actual raw RTL reference (explicit Windows ModelSim receipts if provided), Linux encoded RTL and Lean; stable single-input event steps')
        g.new_file(report+'/result.json',encoded(result));return result
    except BaseException as e:
        g.new_file(report+'/failure.json',encoded(dict(status='FAIL',error=str(e),commands=commands,seconds=time.monotonic()-start)))
        raise


def main(request):
    if request['operation'] in ('archive','archive-preflight'):return archive(request)
    g=Guard()
    try:
        v=os.fstatvfs(g.root);free=v.f_bavail*v.f_frsize
        available=os.sysconf('SC_AVPHYS_PAGES')*os.sysconf('SC_PAGE_SIZE')
        # Record actual resources; no minimum-resource admission threshold.
        if request['operation']=='resources':result=dict(status='RESOURCE_OBSERVATION',load_average=os.getloadavg(),logical_cpus=os.cpu_count())
        elif request['operation']=='acquire-clocks':result=acquire(g,request)
        elif request['operation']=='prepare-reference':result=prepare_reference(g,request)
        elif request['operation']=='run-clocks':result=run(g,request)
        elif request['operation']=='run-regression':
            from verify_fourstate_clocks_regression import run as regression
            result=regression(g,request)
        elif request['operation']=='evidence-index':
            base='runs/'+identifier(request['run_id']);rows=[]
            for case in request['cases']:
                report=base+'/reports/linux-'+identifier(case)
                record='result.json'
                try:value=json.loads(g.read(report+'/'+record,1024**2))
                except FileNotFoundError:
                    if not request.get('include_failures'):raise
                    record='failure.json';value=json.loads(g.read(report+'/'+record,1024**2))
                paths=[report+'/'+record]
                for cmd in value['commands']:
                    label=identifier(cmd['label'])
                    paths.extend(report+'/'+label+'/'+n for n in ('command.json','stderr.log','stdout.log'))
                for path in paths:
                    with g.directory(path.rsplit('/',1)[0]) as fd:
                        info=os.stat(path.rsplit('/',1)[1],dir_fd=fd,follow_symlinks=False)
                    if not stat.S_ISREG(info.st_mode):raise ValueError('nonregular evidence')
                    rows.append(dict(path=path[len(base)+1:],bytes=info.st_size))
            result=dict(status='INDEXED',files=rows,free_bytes=free)
        else:raise ValueError('unsupported bounded clock operation')
        result['resource_preflight']=dict(free_disk_bytes=free,available_memory_bytes=available,load_average=os.getloadavg(),logical_cpus=os.cpu_count())
        print(encoded(result).decode(),end='')
    finally:g.close()
