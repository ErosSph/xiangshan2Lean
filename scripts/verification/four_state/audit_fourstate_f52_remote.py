"""F5.2 Guard-owned data acquisition, environment checks and finite probes."""
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

import hashlib
import json
import os
from pathlib import Path
import shutil
import socket
import subprocess
import sys
import time
import threading
import stat
from fourstate_sync_common import WORKSPACE, encoded, identifier, relative, sha
from fourstate_sync_remote import Guard, verify_release
from audit_fourstate_remote import Reader, RTL, signature


def resources(g):
    disk=os.fstatvfs(g.root)
    mem={}
    with open('/proc/meminfo') as stream:
        for line in stream:
            key,value=line.split(':',1)
            if key in ('MemTotal','MemAvailable','SwapFree'):mem[key]=int(value.split()[0])*1024
    return dict(hostname=socket.gethostname(),logical_cpus=os.cpu_count(),load_average=os.getloadavg(),
                memory=mem,free_disk_bytes=disk.f_bavail*disk.f_frsize)


def preflight(g, request):
    candidates=[]
    for name in ('python3','python3.9','python3.10','python3.11','python3.12','python3.13','yosys','iverilog'):
        p=shutil.which(name)
        if not p:continue
        command=[p,'-I','-B','-c',"import sys,importlib.util,json; s=importlib.util.find_spec('pyslang'); print(json.dumps(dict(python=sys.version,pyslang=None if s is None else s.origin)))"] if name.startswith('python') else [p,'-V']
        result=subprocess.run(command,cwd=WORKSPACE,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        candidates.append(dict(name=name,command=command,exit_code=result.returncode,stdout=result.stdout.decode(errors='replace'),stderr=result.stderr.decode(errors='replace')))
    entries={}
    for base in ('','toolchains','tools','.tools'):
        try:entries[base]=g.listing(base)
        except FileNotFoundError:pass
    return dict(status='PREFLIGHT',resources=resources(g),tools=candidates,workspace_entries=entries)


def environment_details(g, request):
    rows={}
    for name in ('runs/f31-audit-20261017t132101z-eb28641fbd74/tool',
                 'runs/f31-audit-20261017t132101z-eb28641fbd74/tool/libexec',
                 'runs/f45-memory-20261017t173407z-1118f143/linux/tool',
                 'runs/f46-20261017t182304z-84b51ec0/tool'):
        try:rows[name]=g.listing(name)
        except FileNotFoundError:rows[name]=None
    system={}
    for name in ('/usr/local/bin','/opt'):
        with os.scandir(name) as entries:
            system[name]=sorted(e.name for e in entries if 'python' in e.name.lower() or 'conda' in e.name.lower())
    return dict(resources=resources(g),private_tool_entries=rows,system_runtime_candidates=system)


def read_original(reader, name):
    fd=reader.file(name)
    try:
        before=signature(os.fstat(fd));chunks=[]
        while True:
            data=os.read(fd,1024**2)
            if not data:break
            chunks.append(data)
        after=signature(os.fstat(fd));data=b''.join(chunks)
        if before!=after or len(data)!=before['bytes']:raise ValueError('original changed: '+name)
        return data,before
    finally:os.close(fd)


def acquire(g, request):
    snapshot=identifier(request['snapshot_id']);verify_release(g,snapshot)
    old='runs/f31-audit-20261017t132101z-eb28641fbd74'
    receipt=g.read(old+'/reports/inputs.json',None)
    if sha(receipt)!=request['f31_inputs_sha256']:raise ValueError('historical inventory differs')
    files=json.loads(receipt)['files'];reader=Reader()
    base='runs/'+identifier(request['run_id'])
    with g.directory(base,create=True,exclusive=True):pass
    before=resources(g);rows=[]
    try:
        for row in files:
            name=row['name'];relative(name)
            data,info=read_original(reader,RTL+'/'+name)
            if sha(data)!=row['sha256'] or len(data)!=row['bytes']:raise ValueError('frozen RTL mismatch: '+name)
            g.new_file(base+'/reports/inputs/'+name,data)
            rows.append(dict(name=name,bytes=len(data),sha256=sha(data),source_stat=info,source=RTL+'/'+name))
        metadata=[]
        for name in request['metadata_paths']:
            try:
                data,info=read_original(reader,name)
                target='reports/provenance/m'+str(len(metadata))+'.json'
                g.new_file(base+'/'+target,data)
                metadata.append(dict(path=name,copy=target,sha256=sha(data),bytes=len(data),stat=info))
            except FileNotFoundError:metadata.append(dict(path=name,missing=True))
        for name in ('reports/modules-v3.json.gz','reports/hierarchy-v2.json'):
            data=g.read(old+'/'+name,None)
            if sha(data)!=request['f31_facts_sha256'][name]:raise ValueError('historical facts differ')
            g.new_file(base+'/reports/frozen/'+name.rsplit('/',1)[-1],data)
        result=dict(status='FROZEN_INPUTS_MATCH',files=rows,bytes=sum(r['bytes'] for r in rows),
                    metadata=metadata,resource_before=before,resource_after=resources(g),snapshot_id=snapshot,
                    original_access='O_RDONLY|O_NOFOLLOW|O_NOATIME; stable before/after; all files match F3.1')
        g.new_file(base+'/reports/input-receipt.json',encoded(result))
        return dict(status=result['status'],files=len(rows),bytes=result['bytes'],metadata=metadata,resources=resources(g))
    finally:os.close(reader.root)


def hierarchy(g, request):
    base='runs/'+identifier(request['run_id']);old='runs/f31-audit-20261017t132101z-eb28641fbd74'
    snap=identifier(request['snapshot_id']);verified=verify_release(g,snap)
    inputs=json.loads(g.read(base+'/reports/input-receipt.json',None))
    files=[r['name'] for r in inputs['files'] if r['name'].lower().endswith(('.sv','.v'))]
    for row in inputs['files']:
        if sha(g.read(base+'/reports/inputs/'+row['name'],None))!=row['sha256']:raise ValueError('copied input changed')
    filelist=('\n'.join(files)+'\n').encode()
    if g.exists(base+'/reports/inputs/audit-files.f'):
        if g.read(base+'/reports/inputs/audit-files.f',None)!=filelist:raise ValueError('file list changed')
    else:g.new_file(base+'/reports/inputs/audit-files.f',filelist)
    label=identifier(request.get('label','cli-hierarchy'));work=base+'/work/'+label
    with g.directory(work,create=True,exclusive=True):pass
    tools={}
    for sub in ('lib','libexec'):
        for r in g.listing(old+'/tool/'+sub):
            name=old+'/tool/'+sub+'/'+r['name'];tools[name]=sha(g.read(name,None))
    tool=WORKSPACE+'/'+old+'/tool'
    command=[tool+'/lib/ld-linux-x86-64.so.2','--inhibit-cache','--inhibit-rpath','','--library-path',tool+'/lib',
             tool+'/libexec/slang-hier','--top','XSTop','--custom-format','{inst}|{module}|{file}',
             '-f','audit-files.f']
    env=dict(os.environ,PYTHONDONTWRITEBYTECODE='1',HOME=WORKSPACE+'/'+base+'/work',TMPDIR=WORKSPACE+'/'+base+'/work',
             XDG_CACHE_HOME=WORKSPACE+'/'+base+'/work')
    start=time.monotonic();samples=[]
    with open(WORKSPACE+'/'+work+'/stdout.log','xb') as out,open(WORKSPACE+'/'+work+'/stderr.log','xb') as err:
        p=subprocess.Popen(command,cwd=WORKSPACE+'/'+base+'/reports/inputs',env=env,stdout=out,stderr=err)
        while p.poll() is None:
            rss={}
            try:
                with open('/proc/'+str(p.pid)+'/status') as stream:
                    for line in stream:
                        key,value=line.split(':',1)
                        if key in ('VmRSS','VmHWM','VmSize'):rss[key]=int(value.split()[0])*1024
            except FileNotFoundError:pass
            samples.append(dict(seconds=time.monotonic()-start,pid=p.pid,process=rss,system=resources(g)))
            time.sleep(1)
        code=p.wait()
    lines=(Path(WORKSPACE)/work/'stdout.log').read_text().splitlines();rows=[]
    for line in lines:
        parts=line.split('|')
        if len(parts)==3:rows.append(dict(zip(('path','module','file'),parts)))
    previous=json.loads(g.read(old+'/reports/hierarchy-v2.json',None))['instances']
    pairs=lambda rr:sorted((r['path'],r['module']) for r in rr)
    report=dict(status='ELABORATED' if code==0 else 'REJECTED',command=command,exit_code=code,seconds=time.monotonic()-start,
                hostname=socket.gethostname(),tool_hashes=tools,resources=samples,peak_rss_bytes=max((s['process'].get('VmHWM',0) for s in samples),default=0),
                instances=rows,historical_hierarchy_match=pairs(rows)==pairs(previous),source_snapshot=verified,
                semantic_verification='NOT_RUN',limits='No added CPU, memory, time, file or transfer cap')
    for name in ('stdout.log','stderr.log'):g.new_file(base+'/reports/'+label+'-'+name,g.read(work+'/'+name,None))
    g.new_file(base+'/reports/'+label+'.json',encoded(report))
    return dict(status=report['status'],instances=len(rows),historical_hierarchy_match=report['historical_hierarchy_match'],
                seconds=report['seconds'],peak_rss_bytes=report['peak_rss_bytes'],exit_code=code)


def index(g, request):
    base='runs/'+identifier(request['run_id']);rows=[]
    def walk(name):
        for row in g.listing(base+'/'+name):
            target=name+'/'+row['name']
            if stat.S_ISDIR(row['mode']):walk(target)
            elif stat.S_ISREG(row['mode']):rows.append(dict(path=target,bytes=row['bytes'],sha256=sha(g.read(base+'/'+target,None))))
            else:raise ValueError('nonregular evidence path')
    walk('reports')
    return dict(files=rows,unrestricted=True)


def runtime_metadata(g, request):
    import urllib.request
    urls=['https://pypi.org/pypi/pyslang/12.0.0/json',
          'https://pypi.org/pypi/nanobind-backend/1.0.0/json',
          'https://api.github.com/repos/astral-sh/python-build-standalone/releases/tags/20250317']
    result=[];base='runs/'+identifier(request['run_id'])
    for i,url in enumerate(urls):
        try:
            response=urllib.request.urlopen(urllib.request.Request(url,headers={'User-Agent':'F52-private-environment'}))
            data=response.read();g.new_file(base+'/reports/environment/metadata-'+str(i)+'.json',data)
            value=json.loads(data)
            if i<2:
                selected=[r for r in value['urls'] if r['filename'].endswith('.whl') and ('manylinux' in r['filename'] and 'x86_64' in r['filename'] and ('cp311' in r['filename'] or 'abi3' in r['filename']) or 'none-any' in r['filename'])]
                result.append(dict(url=url,sha256=sha(data),requires_python=value['info']['requires_python'],requires_dist=value['info']['requires_dist'],files=selected))
            else:result.append(dict(url=url,sha256=sha(data),files=[r for r in value['assets'] if 'cpython-3.11.' in r['name'] and 'x86_64-unknown-linux-gnu-install_only' in r['name']]))
        except Exception as error:result.append(dict(url=url,error=repr(error)))
    g.new_file(base+'/reports/environment/metadata-result.json',encoded(result))
    return result


def setup_runtime(g, request):
    import urllib.request
    import tarfile
    import zipfile
    import io
    import posixpath
    base='runs/'+identifier(request['run_id']);metadata=json.loads(g.read(base+'/reports/environment/metadata-result.json',None))
    runtime=base+'/tool/python311-api'
    with g.directory(runtime,create=True,exclusive=True):pass
    def download(url):
        original_url=url
        if url.startswith('https://github.com/'):
            url=next(r['url'] for r in metadata[2]['files'] if r['browser_download_url']==url)
        if not url.startswith(('https://github.com/astral-sh/python-build-standalone/releases/download/20250317/',
                               'https://api.github.com/repos/astral-sh/python-build-standalone/releases/assets/',
                               'https://files.pythonhosted.org/')):raise ValueError('unapproved runtime download URL')
        # Socket inactivity timeout is a transport error detector, not a
        # computation wall-clock/resource budget.
        return urllib.request.urlopen(urllib.request.Request(url,headers={'Accept':'application/octet-stream','User-Agent':'F52'}),timeout=45).read()
    asset=next(r for r in metadata[2]['files'] if r['name']=='cpython-3.11.11+20250317-x86_64-unknown-linux-gnu-install_only_stripped.tar.gz')
    checksum_url=next(r['browser_download_url'] for r in metadata[2]['files'] if r['name']==asset['name']+'.sha256')
    raw_sum=download(checksum_url);expected=raw_sum.decode().split()[0]
    archive=download(asset['browser_download_url'])
    if sha(archive)!=expected:raise ValueError('Python archive SHA256 mismatch')
    g.new_file(base+'/tool/downloads/'+asset['name'],archive);g.new_file(base+'/reports/environment/python-checksum.txt',raw_sum)
    rows=[]
    def create(name,data,executable=False):
        relative(name);target=runtime+'/'+name;g.new_file(target,data)
        if executable:
            with g.directory(target.rsplit('/',1)[0]) as fd:
                f=os.open(target.rsplit('/',1)[1],os.O_RDONLY|os.O_NOFOLLOW,dir_fd=fd)
                try:os.fchmod(f,0o500)
                finally:os.close(f)
        rows.append(dict(path=name,sha256=sha(data),bytes=len(data),executable=executable))
    with tarfile.open(fileobj=io.BytesIO(archive),mode='r:gz') as tar:
        members={r.name.rstrip('/'):r for r in tar.getmembers()}
        if len(members)!=len(tar.getmembers()):raise ValueError('duplicate Python archive member')
        regular={m.name:(tar.extractfile(m).read(),bool(m.mode&0o111)) for m in sorted(members.values(),key=lambda m:m.offset_data) if m.isfile()}
        def contents(member,seen=()):
            if member.name in seen:raise ValueError('archive link cycle')
            if member.isfile():return regular[member.name]
            if member.issym() or member.islnk():
                target=posixpath.normpath(posixpath.join(posixpath.dirname(member.name),member.linkname) if member.issym() else member.linkname)
                if not target.startswith('python/'):raise ValueError('archive link escapes Python root')
                return contents(members[target],(*seen,member.name))
            raise ValueError('special archive member')
        for name,member in sorted(members.items()):
            relative(name)
            if not name.startswith('python/') and name!='python':raise ValueError('unexpected archive prefix')
            if member.isdir():continue
            data,exe=contents(member);create(name,data,exe)
    packages=[]
    for pkg in metadata[:2]:
        wheel=next(r for r in pkg['files'] if 'cp311' in r['filename'])
        data=download(wheel['url'])
        if sha(data)!=wheel['digests']['sha256']:raise ValueError('wheel SHA256 mismatch')
        g.new_file(base+'/tool/downloads/'+wheel['filename'],data)
        with zipfile.ZipFile(io.BytesIO(data)) as z:
            seen=set()
            for member in z.infolist():
                name=member.filename.rstrip('/');relative(name)
                if name in seen:raise ValueError('duplicate wheel member')
                seen.add(name)
                if member.is_dir():continue
                mode=(member.external_attr>>16)&0o170000
                if mode not in (0,stat.S_IFREG):raise ValueError('nonregular wheel entry')
                create('site/'+name,z.read(member))
        packages.append(dict(filename=wheel['filename'],url=wheel['url'],sha256=sha(data),bytes=len(data)))
    receipt=dict(status='PRIVATE_RUNTIME_READY',python_archive=dict(url=asset['browser_download_url'],sha256=sha(archive),bytes=len(archive)),
                 packages=packages,files=rows,base=runtime,symlinks='Archive links materialized as separately owned regular bytes; none installed',
                 original_project_writes=False,system_environment_writes=False)
    g.new_file(base+'/reports/environment/runtime.json',encoded(receipt))
    command=[WORKSPACE+'/'+runtime+'/python/bin/python3.11','-I','-B','-c',
             'import sys,json;sys.path.insert(0,'+repr(WORKSPACE+'/'+runtime+'/site')+');import pyslang;print(json.dumps(dict(python=sys.version,pyslang=pyslang.__version__,parser=pyslang.__file__)))']
    result=subprocess.run(command,cwd=WORKSPACE+'/'+base,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    check=dict(command=command,exit_code=result.returncode,stdout=result.stdout.decode(errors='replace'),stderr=result.stderr.decode(errors='replace'),resources=resources(g))
    g.new_file(base+'/reports/environment/runtime-check.json',encoded(check))
    return dict(status=receipt['status'],files=len(rows),bytes=sum(r['bytes'] for r in rows),check=check)


def network_probe(g,request):
    import urllib.request
    results=[]
    for url in request['urls']:
        if not url.startswith(('https://api.github.com/repos/astral-sh/python-build-standalone/releases/assets/',
                               'https://github.com/astral-sh/python-build-standalone/releases/download/20250317/',
                               'https://repo.anaconda.com/miniconda/')):raise ValueError('unapproved network probe URL')
        started=time.monotonic()
        try:
            req=urllib.request.Request(url,headers={'Accept':'application/octet-stream','User-Agent':'F52'})
            r=urllib.request.urlopen(req,timeout=15);data=r.read(1024)
            results.append(dict(url=url,redirect_url=r.geturl(),headers=dict(r.headers),sample=data.decode(errors='replace'),seconds=time.monotonic()-started))
        except Exception as error:results.append(dict(url=url,error=repr(error),seconds=time.monotonic()-started))
    return results


def run_worker(g,request):
    base='runs/'+identifier(request['run_id']);snap=identifier(request['snapshot_id']);label=identifier(request['label'])
    verified=verify_release(g,snap)
    runtime=json.loads(g.read(base+'/reports/environment/runtime.json',None))
    for row in runtime['files']:
        if sha(g.read(runtime['base']+'/'+row['path'],None))!=row['sha256']:raise ValueError('private runtime changed')
    work=base+'/work/'+label
    with g.directory(work,create=True,exclusive=True):pass
    with g.directory(base+'/reports'):pass
    out=base+'/reports/'+label
    if g.exists(out):raise ValueError('probe identity already used')
    req=dict(run=WORKSPACE+'/'+base)
    if request.get('modules'):req['modules']=request['modules']
    g.new_file(work+'/request.json',encoded(req))
    source=WORKSPACE+'/releases/'+snap+'/src/scripts'
    command=[WORKSPACE+'/'+runtime['base']+'/python/bin/python3.11','-I','-B','-c',
             'import sys,runpy;sys.path.insert(0,'+repr(source)+');runpy.run_path('+repr(source+'/audit_fourstate_f52_worker.py')+',run_name="__main__")',
             '--request',WORKSPACE+'/'+work+'/request.json','--out',WORKSPACE+'/'+out]
    if request.get('tests'):command.append('--tests')
    env=dict(os.environ,PYTHONDONTWRITEBYTECODE='1',HOME=WORKSPACE+'/'+work,TMPDIR=WORKSPACE+'/'+work,XDG_CACHE_HOME=WORKSPACE+'/'+work)
    start=time.monotonic();samples=[]
    g.new_file(work+'/command.json',encoded(dict(command=command,source_snapshot=verified,resources=resources(g))))
    with open(WORKSPACE+'/'+work+'/stdout.log','xb') as stdout,open(WORKSPACE+'/'+work+'/stderr.log','xb') as stderr,open(WORKSPACE+'/'+work+'/monitor.jsonl','x') as monitor:
        p=subprocess.Popen(command,cwd=WORKSPACE+'/'+work,env=env,stdout=stdout,stderr=stderr)
        g.new_file(work+'/pid.json',encoded(dict(pid=p.pid,command=command)))
        while p.poll() is None:
            rss={}
            try:
                with open('/proc/'+str(p.pid)+'/status') as stream:
                    for line in stream:
                        key,value=line.split(':',1)
                        if key in ('VmRSS','VmHWM','VmSize'):rss[key]=int(value.split()[0])*1024
            except FileNotFoundError:pass
            row=dict(seconds=time.monotonic()-start,pid=p.pid,process=rss,system=resources(g));samples.append(row)
            monitor.write(json.dumps(row)+'\n');monitor.flush();time.sleep(1)
        code=p.wait()
    result=dict(exit_code=code,seconds=time.monotonic()-start,command=command,resources=samples,
                peak_rss_bytes=max((s['process'].get('VmHWM',0) for s in samples),default=0),hostname=socket.gethostname(),
                limits='No additional CPU, memory, execution-time, file or transfer caps',source_snapshot=verified)
    for name in ('command.json','stdout.log','stderr.log','monitor.jsonl'):
        g.new_file(base+'/reports/'+label+'-'+name,g.read(work+'/'+name,None))
    g.new_file(base+'/reports/'+label+'-execution.json',encoded(result))
    return {k:v for k,v in result.items() if k!='resources'}


def analyze(g,request):
    from collections import Counter
    import gzip
    base='runs/'+identifier(request['run_id']);label=identifier(request['label']);probe=base+'/reports/'+label
    batch=json.loads(g.read(probe+'/batch-results.json',None));inv=json.loads(g.read(probe+'/typed-inventory.json',None))
    for r in batch:r.setdefault('artifact_root',label)
    if request.get('supplement'):
        sub=identifier(request['supplement']);extra=json.loads(g.read(base+'/reports/'+sub+'/batch-results.json',None))
        byname={r['module']:r for r in batch}
        for r in extra:byname[r['module']]=r
        batch=[byname[n] for n in sorted(byname)]
    definitions=inv['definitions'];counts=Counter(inv['module_counts'])
    facts={r['name']:r for r in json.loads(gzip.decompress(g.read(base+'/reports/frozen/modules-v3.json.gz',None)))}
    old={r['module']:r for r in json.loads(g.read(base+'/reports/frozen/f44-ledger.json',None))['results']}
    h=json.loads(g.read(base+'/reports/cli-hierarchy-v2.json',None))
    if sorted((r['path'],r['module']) for r in h['instances'])!=sorted((r['path'],r['module']) for r in inv['instances']):raise ValueError('typed/CLI hierarchy mismatch')
    import types
    a=types.ModuleType('f52_structural_analysis')
    exec(g.read('releases/'+identifier(request['snapshot_id'])+'/src/scripts/audit_fourstate_analysis.py',None).decode(),a.__dict__)
    structural=a.aggregate(list(facts.values()),dict(status='ELABORATED',instances=h['instances']),[])
    if not g.exists(base+'/reports/f52-structural.json'):g.new_file(base+'/reports/f52-structural.json',encoded(structural))
    import copy
    resets=copy.deepcopy(list(facts.values()))
    for m in resets:
        m['features'].pop('multiple_local_clock_expressions',None)
        for p in m['processes']:p['clock_events']=p['async_control_candidates']
    reset_trace=a.aggregate(resets,dict(status='ELABORATED',instances=h['instances']),[])['clocks']
    reset_trace['method']='Direct identifier/alias trace of CST async-control candidates; not a proof of reset polarity, event semantics or architectural domains'
    if not g.exists(base+'/reports/f52-async-control-trace.json'):g.new_file(base+'/reports/f52-async-control-trace.json',encoded(reset_trace))
    inputs=json.loads(g.read(base+'/reports/input-receipt.json',None));sources={r['name']:r for r in inputs['files']}
    byfile={v['file']:k for k,v in facts.items()};ledger=[]
    for r in batch:
        r=dict(r);name=r['module'];r['xstop_instances']=counts[name]
        r['historical_f44_status']=old[name]['status'];r['historical_f44_category']=old[name].get('category')
        d=r.get('diagnostic',{})
        message=d.get('message','')
        if 'process locals require' in message or 'blocking assignment' in message or 'named procedural' in message:
            d['category']='process_scope'
        elif any(w in message for w in ('$error string','ImmediateAssertion','immediate assertion','immediate assertions')):
            d['category']='assertion_diagnostic'
        elif ('common direct posedge clock' in message or 'all processes must' in message) and r['options'].get('bounded_memories'):
            d['category']='memory_event_composition'
        elif 'unsized data literal' in message:d['category']='literal_width'
        elif 'one-bit procedural if' in message:d['category']='procedural_condition'
        elif 'static memory word slice' in message:d['category']='memory_slice'
        elif 'at least one assigned register' in message:d['category']='standalone_no_state'
        if d.get('file'):
            file=Path(d['file']).name
            if file not in sources:raise ValueError('diagnostic outside verified RTL files')
            data=g.read(base+'/reports/inputs/'+file,None)
            if sha(data)!=sources[file]['sha256']:raise ValueError('diagnostic source changed')
            r['first_source']=dict(file=file,module=byfile.get(file),line=d['line'],column=d['column'],text=data.decode().splitlines()[d['line']-1])
            if d['category']=='memory_declaration' and not any(m['source']['line']==d['line'] for m in definitions[byfile[file]]['memories']):
                d['category']='packed_declaration'
        r['category']=d.get('category','none');ledger.append(r)
    own_memory={n for n,d in definitions.items() if d['memories']}
    own_oversize={n for n,d in definitions.items() if sum(m['bits'] for m in d['memories'])>1024 or any(
        len(m['shape'])!=1 or m['shape'][0]['words']>32 for m in d['memories'])}
    own_event={n for n,d in facts.items() if any(d['features'].get(k) for k in ('multi_event_process','always_latch'))}
    closure={}
    subtree={}
    def visit(n):
        if n in closure:return
        closure[n]={n};d=definitions[n]
        totals=dict(instances=1,scalar_state_bits=d['scalar_state_bits'],memory_bits=d['memory_bits'],processes=len(d['processes']),memory_arrays=len(d['memories']))
        for i in facts[n]['instances']:
            target=i['module'];visit(target);closure[n]|=closure[target]
            for key in totals:totals[key]+=subtree[target][key]
        subtree[n]=totals
    for name in facts:visit(name)
    if subtree['XSTop']['instances']!=sum(counts.values()):raise ValueError('graph/hierarchy size mismatch')
    impacts={}
    for label_,selected in [('own_memory',own_memory),('own_memory_exceeds_f45',own_oversize),('own_async_or_latch',own_event)]:
        parents={n for n,c in closure.items() if c&selected}
        impacts[label_]=dict(definitions=len(selected),instances=sum(counts[n] for n in selected),modules=sorted(selected),
                              dependent_hierarchy_definitions=len(parents),weighted_root_occurrences=sum(counts[n] for n in parents),
                              scope='Own-feature instance weights and overlapping ancestor-root impact, not verified coverage')
    mixed={n for n,c in closure.items() if c&own_memory and c&own_event}
    impacts['memory_event_combination']=dict(definitions=len(mixed),weighted_root_occurrences=sum(counts[n] for n in mixed),modules=sorted(mixed))
    categories={}
    for category in sorted({r['category'] for r in ledger if not r['encoded_rtl']}):
        rows=[r for r in ledger if not r['encoded_rtl'] and r['category']==category]
        origins={r.get('first_source',{}).get('module') for r in rows}-{None}
        categories[category]=dict(definitions=len(rows),weighted_root_occurrences=sum(r['xstop_instances'] for r in rows),
                                  diagnostic_origin_definitions=len(origins),diagnostic_origin_instances=sum(counts[n] for n in origins),
                                  examples=[dict(module=r['module'],error=r.get('error'),source=r.get('first_source')) for r in rows[:5]])
    encoded_rows=[r for r in ledger if r['encoded_rtl']];leaves=[r for r in ledger if not facts[r['module']]['instances']]
    summary=dict(status='F52_ANALYZED',definitions=len(ledger),instances=sum(counts.values()),
        attempted_dependency_hierarchies=len(ledger),encoded_dependency_hierarchies=len(encoded_rows),
        fourstate_ir_hierarchies=sum(r['fourstate_ir'] for r in ledger),
        encoding_failures_after_ir=[r['module'] for r in ledger if r['fourstate_ir'] and not r['encoded_rtl']],
        encoded_weighted_root_occurrences=sum(r['xstop_instances'] for r in encoded_rows),
        individually_tested_leaf_definitions=len(leaves),encoded_leaf_definitions=sum(r['encoded_rtl'] for r in leaves),
        rejected=sum(r['status']=='REJECTED' for r in ledger),tool_failures=sum(r['status']=='TOOL_FAILURE' for r in ledger),
        own_only_nonleaf_conversion='NOT_MEASURED: no dependency stubs or RTL rewriting',
        behavior_verified_definitions_this_stage=0,whole_xstop_encoded=False,whole_xstop_ir='NOT_PRODUCED',
        functional_ir='NOT_RUN',lean='NOT_RUN',categories=categories,structural_impacts=impacts,
        typed_size={k:inv[k] for k in ('scalar_state_bits','memory_bits','scalar_state_variables','memory_arrays','processes')},
        subtree_sizes={n:subtree[n] for n in ('XSTop','SoCMisc','XSTile','XSCore') if n in subtree},
        historical_comparison=dict(f44_encoded=sum(r['status']=='COMPLETED' for r in old.values()),
            newly_encoded=[r['module'] for r in encoded_rows if old[r['module']]['status']!='COMPLETED'],
            prior_encoded_now_rejected=[dict(module=r['module'],diagnostic=r.get('diagnostic')) for r in ledger if old[r['module']]['status']=='COMPLETED' and not r['encoded_rtl']]),
        encoding_size=dict(total_ir_nodes=sum(r.get('nodes',0) for r in encoded_rows),total_ir_bytes=sum(r.get('ir_bytes',0) for r in encoded_rows),
                           total_encoded_bytes=sum(r.get('encoded_bytes',0) for r in encoded_rows),
                           largest=sorted([dict(module=r['module'],nodes=r['nodes'],state_bits=r['state_bits'],encoded_bytes=r['encoded_bytes'],seconds=r['seconds']) for r in encoded_rows],key=lambda r:r['encoded_bytes'],reverse=True)[:10]),
        clock_propagation=structural['clocks'],typed_and_cli_hierarchy='EXACT_PATH_TYPE_MATCH',
        async_control_propagation=reset_trace,
        scope='Each entry is one freshly bound complete dependency hierarchy. Instance multiplicities are potential root occurrences, never whole-machine or per-instance behavioral coverage.')
    suffix='-'+identifier(request['analysis_version']) if request.get('analysis_version') else ''
    g.new_file(base+'/reports/f52-ledger'+suffix+'.json',encoded(ledger));g.new_file(base+'/reports/f52-analysis'+suffix+'.json',encoded(summary))
    return summary


def import_provenance(g,request):
    import base64
    base='runs/'+identifier(request['run_id']);rows=[]
    allowed={'elaboration-summary.json','lowering-summary.json','generator-command.json','lowering-command.json',
             'generator-exit.txt','lowering-exit.txt','generator-stdout.log','generator-stderr.log','lowering-stdout.log','lowering-stderr.log'}
    for r in request['files']:
        if r['name'] not in allowed:raise ValueError('not an authorized provenance receipt')
        data=base64.b64decode(r['base64'],validate=True)
        if sha(data)!=r['sha256']:raise ValueError('provenance transfer SHA mismatch')
        target=base+'/reports/provenance-local/'+r['name']
        if g.exists(target):
            if g.read(target,None)!=data:raise ValueError('refuse changed provenance receipt')
        else:g.new_file(target,data)
        rows.append(dict(name=r['name'],local_source=r['local_source'],bytes=len(data),sha256=sha(data)))
    get=lambda n:json.loads(g.read(base+'/reports/provenance-local/'+n,None))
    elab=get('elaboration-summary.json');lower=get('lowering-summary.json');gen=get('generator-command.json');cmd=get('lowering-command.json')
    inputs=json.loads(g.read(base+'/reports/input-receipt.json',None));model=json.loads(g.read(base+'/reports/provenance/m0.json',None))
    model_hash={Path(n.replace('\\','/')).name:h for n,h in model['source_files_sha256'].items()}
    expected={n:r['sha256'] for n,r in lower['files'].items()}
    expected['DifftestMacros.v']=elab['files']['build/generated-src/DifftestMacros.v']['sha256']
    comparisons=[dict(name=r['name'],actual=r['sha256'],lowering=expected.get(r['name']),model=model_hash.get(r['name'])) for r in inputs['files']]
    a=gen['command'];command_config=a[a.index('--config')+1];cores=a[a.index('--num-cores')+1]
    result=dict(status='HISTORICAL_COMMAND_HASH_CHAIN_RECOVERED',files=rows,
         recorded_config=command_config,cores=int(cores),generator_exit=int(g.read(base+'/reports/provenance-local/generator-exit.txt',None)),
         lowering_exit=int(g.read(base+'/reports/provenance-local/lowering-exit.txt',None)),
         firtool_version=lower['firtool_version'],firrtl_recorded_sha256=lower['source_sha256'],
         firrtl_receipt_chain_matches=lower['source_sha256']==elab['files']['rtl/XSTop.fir']['sha256'],
         rtl_hash_matches=sum(r['actual']==r['lowering']==r['model'] for r in comparisons),rtl_files=len(comparisons),comparisons=comparisons,
         intermediates_freshly_rehashed=False,missing_local_intermediate=request['missing_local_intermediate'],
         scope='Actual historical DefaultConfig/1-core command and linked hash receipts recovered locally; no generator rerun. FIRRTL bytes are absent in the present local copy, so the entire source/tool/binary chain is not independently rehashed or proved.')
    g.new_file(base+'/reports/provenance-conclusion.json',encoded(result));return {k:v for k,v in result.items() if k not in ('files','comparisons')}


def protect_original(g,request):
    base='runs/'+identifier(request['run_id']);inputs=json.loads(g.read(base+'/reports/input-receipt.json',None));reader=Reader();rows=[]
    try:
        for r in inputs['files']:
            data,info=read_original(reader,r['source'])
            rows.append(dict(name=r['name'],hash_match=sha(data)==r['sha256'],stat_match=info==r['source_stat']))
        result=dict(status='PASS' if all(r['hash_match'] and r['stat_match'] for r in rows) else 'MISMATCH',files=rows,
                    original_access='O_RDONLY|O_NOFOLLOW|O_NOATIME',resources=resources(g))
        g.new_file(base+'/reports/original-protection.json',encoded(result));return dict(status=result['status'],files=len(rows),resources=result['resources'])
    finally:os.close(reader.root)


def private_probe_permissions(g,request):
    # Only fresh F52 outputs created in this run, never historical inputs.
    base='runs/'+identifier(request['run_id'])+'/reports';label=identifier(request['label']);changed=[]
    with g.directory(base) as parent:
        def visit(parent,name,path):
            fd=os.open(name,g.flags,dir_fd=parent)
            try:
                info=os.fstat(fd)
                if info.st_uid!=os.geteuid() or info.st_dev!=g.device:raise ValueError('unowned output directory')
                if info.st_mode&0o077:os.fchmod(fd,0o700);changed.append(path)
                with os.scandir(fd) as entries:
                    for e in entries:
                        st=e.stat(follow_symlinks=False)
                        if stat.S_ISDIR(st.st_mode):visit(fd,e.name,path+'/'+e.name)
                        elif not stat.S_ISREG(st.st_mode):raise ValueError('unexpected output symlink/special entry')
            finally:os.close(fd)
        visit(parent,label,label)
    version=identifier(request.get('version','v2'))
    g.new_file(base+'/'+label+'-directory-repair-'+version+'.json',encoded(dict(changed=changed,reason='Private output permissions; inherited server umask was group-writable, no file content changed')))
    return dict(directories_normalized=len(changed))


def sizes(g,request):
    base='runs/'+identifier(request['run_id']);label=identifier(request['label'])
    v=json.loads(g.read(base+'/reports/'+label+'/typed-inventory.json',None));definitions=v['definitions'];counts=v['module_counts']
    memories=[dict(module=n,instances=counts[n],**m) for n,d in definitions.items() for m in d['memories']]
    result=dict(totals={k:v[k] for k in ('scalar_state_bits','memory_bits','scalar_state_variables','memory_arrays','processes')},
                memory_definitions=sum(bool(d['memories']) for d in definitions.values()),
                memory_occurrence_modules=sum(counts[n] for n,d in definitions.items() if d['memories']),
                largest_arrays=sorted(memories,key=lambda m:m['bits'],reverse=True)[:10],
                static_note='Typed module-scope assigned state and declared memory, weighted by the actual hierarchy; not encoded IR or behavioral coverage')
    g.new_file(base+'/reports/typed-sizes.json',encoded(result));return result


def versions(g,request):
    import resource
    base='runs/'+identifier(request['run_id']);tool=WORKSPACE+'/runs/f31-audit-20261017t132101z-eb28641fbd74/tool'
    command=[tool+'/lib/ld-linux-x86-64.so.2','--inhibit-cache','--inhibit-rpath','','--library-path',tool+'/lib',tool+'/libexec/slang','--version']
    result=subprocess.run(command,cwd=WORKSPACE+'/'+base,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    value=dict(command=command,exit_code=result.returncode,stdout=result.stdout.decode(errors='replace'),stderr=result.stderr.decode(errors='replace'),
       existing_system_limits={n:resource.getrlimit(getattr(resource,n)) for n in ('RLIMIT_CPU','RLIMIT_AS','RLIMIT_FSIZE','RLIMIT_NOFILE')},
       existing_cpu_affinity=sorted(os.sched_getaffinity(0)),resources=resources(g),limits_modified=False)
    g.new_file(base+'/reports/environment/versions-and-system-limits.json',encoded(value));return value


def acceptance(g,request):
    base='runs/'+identifier(request['run_id']);label=identifier(request['label']);probe=base+'/reports/'+label
    suffix='-'+identifier(request['analysis_version']) if request.get('analysis_version') else ''
    summary=json.loads(g.read(probe+'/worker-summary.json',None));analysis=json.loads(g.read(base+'/reports/f52-analysis'+suffix+'.json',None))
    ledger=json.loads(g.read(base+'/reports/f52-ledger'+suffix+'.json',None));checks={};details=[]
    checks['completed_981_unique_definitions']=len(ledger)==analysis['definitions']==981 and len({r['module'] for r in ledger})==981
    checks['worker_completed_without_tool_failures']=summary['status']=='PROBE_FINISHED' and summary['tool_failures']==0 and analysis['tool_failures']==0
    if request.get('supplement'):
        extra=json.loads(g.read(base+'/reports/'+identifier(request['supplement'])+'/worker-summary.json',None))
        checks['profile_supplement_completed']=extra['status']=='PROBE_FINISHED' and extra['tool_failures']==0
    checks['binding_and_hierarchy']=analysis['typed_and_cli_hierarchy']=='EXACT_PATH_TYPE_MATCH' and analysis['instances']==21024
    checks['whole_not_promoted']=all(not r['encoded_rtl'] and not r['fourstate_ir'] and r['status']=='REJECTED' for r in summary['whole'])
    checks['no_simulation_or_lean']=summary['behavioral_verification']=='NOT_RUN' and all(r['lean']=='NOT_RUN' and r['semantic_verification']=='NOT_RUN' for r in ledger)
    for r in ledger:
        if not r['encoded_rtl']:continue
        artifact=base+'/reports/'+identifier(r.get('artifact_root',label))+'/'+r['artifact_directory']
        ir=json.loads(g.read(artifact+'/fourstate.ir.json',None));rtl=g.read(artifact+'/encoded.sv',None)
        if len(ir['nodes'])!=r['nodes'] or len(rtl)!=r['encoded_bytes']:raise ValueError('artifact size/count mismatch: '+r['module'])
        details.append(dict(module=r['module'],encoded_sha256=sha(rtl),ir_sha256=sha(g.read(artifact+'/fourstate.ir.json',None)),
                            instances=len(ir['elaboration']['instances'])))
    checks['all_encoded_artifacts_rehashed']=len(details)==analysis['encoded_dependency_hierarchies']
    controls=json.loads(g.read(probe+'/cache-controls.json',None));byname={r['module']:r for r in ledger};parity=[]
    for r in controls:
        selected=byname[r['module']];fresh=json.loads(g.read(probe+'/fresh-'+r['module']+'/result.json',None))
        ok=selected['status']==fresh['status'] and fresh['status'] in ('ENCODED','REJECTED')
        if ok and fresh['encoded_rtl']:
            ok=g.read(base+'/reports/'+identifier(selected.get('artifact_root',label))+'/'+selected['artifact_directory']+'/encoded.sv',None)==g.read(probe+'/fresh-'+r['module']+'/encoded.sv',None)
        elif ok:ok=fresh['diagnostic']['message']==selected['diagnostic']['message']
        parity.append(dict(module=r['module'],match=ok,status=fresh['status']))
    checks['fresh_parser_cache_controls']=len(parity)==5 and all(r['match'] for r in parity)
    tests=json.loads(g.read(base+'/reports/tests-v3/tests.json',None));checks['focused_linux_units']=tests['status']=='PASS' and tests['tests']==36
    protection=json.loads(g.read(base+'/reports/original-protection.json',None));checks['original_rtl_unchanged']=protection['status']=='PASS' and len(protection['files'])==982
    p=json.loads(g.read(base+'/reports/provenance-conclusion.json',None));checks['frozen_source_receipt_chain']=p['rtl_hash_matches']==p['rtl_files']==982 and p['firrtl_receipt_chain_matches']
    tap=next((r for r in details if r['module']=='JtagTapController'),None)
    tap_match=tap is not None and tap['encoded_sha256']==request['f51a_tap_lf_sha256']
    checks['tap_linux_encoding_matches_f51a_lf']=tap_match
    result=dict(status='F52_PROBE_PASS' if all(checks.values()) else 'F52_PARTIAL',checks=checks,encoded_artifact_hashes=details,
                cache_parity=parity,semantic_verification='NOT_RUN',whole_conversion='REJECTED_WITH_LOCATED_EVIDENCE',
                tap_encoding_check=dict(linux_sha256=None if tap is None else tap['encoded_sha256'],
                    expected_lf_sha256=request['f51a_tap_lf_sha256'],windows_raw_sha256=request['f51a_tap_encoded_sha256'],
                    scope='Only CRLF-to-LF serialization normalized; all RTL characters retained. No behavioral comparison was relaxed.'),
                scope='Feasibility audit acceptance only; no claim of whole-machine encoding, FunctionalIR, Lean or behavior equivalence',
                source_snapshot=verify_release(g,identifier(request['snapshot_id'])))
    g.new_file(base+'/reports/f52-acceptance.json',encoded(result));return {k:v for k,v in result.items() if k not in ('encoded_artifact_hashes','source_snapshot')}


def plan_supplement(g,request):
    import types,gzip
    base='runs/'+identifier(request['run_id']);label=identifier(request['label']);snap=identifier(request['snapshot_id'])
    verify_release(g,snap)
    module=types.ModuleType('f52_profile_planner');module.__file__=WORKSPACE+'/releases/'+snap+'/src/scripts/audit_fourstate_f52_worker.py'
    exec(g.read('releases/'+snap+'/src/scripts/audit_fourstate_f52_worker.py',None).decode(),module.__dict__)
    facts={m['name']:m for m in json.loads(gzip.decompress(g.read(base+'/reports/frozen/modules-v3.json.gz',None)))}
    batch=json.loads(g.read(base+'/reports/'+label+'/batch-results.json',None));selected=[]
    for r in batch:
        options,static=module.profile(facts,r['module'])
        if not r['encoded_rtl'] and options!=r['options']:
            selected.append(dict(module=r['module'],before=r['options'],after=options,previous_status=r['status']))
    result=dict(modules=[r['module'] for r in selected],changes=selected,
          reason='Recheck all rejected roots whose explicit options omitted existing assertion/derived-clock event opt-in; no SV semantics or memory/event contract changed')
    g.new_file(base+'/reports/profile-supplement-plan.json',encoded(result));return result


def main(request):
    g=Guard()
    try:
        op=request['operation']
        if op=='preflight':value=preflight(g,request)
        elif op=='environment-details':value=environment_details(g,request)
        elif op=='acquire':value=acquire(g,request)
        elif op=='hierarchy':value=hierarchy(g,request)
        elif op=='index':value=index(g,request)
        elif op=='runtime-metadata':value=runtime_metadata(g,request)
        elif op=='setup-runtime':value=setup_runtime(g,request)
        elif op=='run-worker':value=run_worker(g,request)
        elif op=='analyze':value=analyze(g,request)
        elif op=='import-provenance':value=import_provenance(g,request)
        elif op=='protect-original':value=protect_original(g,request)
        elif op=='private-probe-permissions':value=private_probe_permissions(g,request)
        elif op=='sizes':value=sizes(g,request)
        elif op=='versions':value=versions(g,request)
        elif op=='acceptance':value=acceptance(g,request)
        elif op=='plan-supplement':value=plan_supplement(g,request)
        elif op=='import-f44':
            import base64
            data=base64.b64decode(request['base64'],validate=True)
            if sha(data)!=request['sha256']:raise ValueError('F44 transfer SHA256 mismatch')
            name='runs/'+identifier(request['run_id'])+'/reports/frozen/f44-ledger.json';g.new_file(name,data)
            value=dict(status='SHA256_READBACK_MATCH',path=name,sha256=sha(g.read(name,None)),bytes=len(data))
        elif op=='network-probe':value=network_probe(g,request)
        elif op=='runtime-status':
            base='runs/'+identifier(request['run_id']);value={}
            for n in ('tool','tool/downloads','tool/python311','tool/python311-api','tool/python311-api/python/bin','reports/environment'):
                try:value[n]=g.listing(base+'/'+n)
                except FileNotFoundError:value[n]=None
            value['bootstrap_processes']=[]
            for p in Path('/proc').iterdir():
                if not p.name.isdigit() or int(p.name)==os.getpid():continue
                try:
                    if p.stat().st_uid!=os.geteuid():continue
                    args=(p/'cmdline').read_bytes().rstrip(b'\0').split(b'\0')
                    if len(args)==5 and args[1:]==[b'-I',b'-B',b'-S',b'-']:
                        value['bootstrap_processes'].append(dict(pid=int(p.name),io=(p/'io').read_text(),wchan=(p/'wchan').read_text()))
                except (FileNotFoundError,PermissionError,ProcessLookupError):pass
        elif op=='inspect':
            value={}
            for n in request['files']:
                target='runs/'+identifier(request['run_id'])+'/reports/'+n
                value[n]=g.read(target,None).decode() if g.exists(target) else None
        elif op=='progress':
            base='runs/'+identifier(request['run_id'])+'/work/'+identifier(request['label']);value={}
            for n in ('stdout.log','stderr.log','monitor.jsonl'):
                value[n]='\n'.join(g.read(base+'/'+n,None).decode().splitlines()[-8:])
        else:raise ValueError('unsupported F52 operation: '+op)
        print(encoded(value).decode(),end='')
    finally:g.close()
