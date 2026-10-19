"""Bounded F3.1 worker. Source Reader is read-only; Guard writes only our workspace."""
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
import resource
import stat
import struct
import subprocess
import sys
import time
import gzip
import re
from audit_fourstate_remote import Reader, RTL, ROOT as ORIGINAL, signature
from fourstate_sync_remote import Guard
from fourstate_sync_common import WORKSPACE, encoded, identifier, sha

TOOL = '.tools/oss-cad-suite-20261014'
TOOL_LIMIT = 256*1024**2


def needed(data):
    if data[:6] != b'\x7fELF\x02\x01':
        raise ValueError('ELF64 little-endian input required')
    offset = struct.unpack_from('<Q',data,40)[0]
    stride,count = struct.unpack_from('<HH',data,58)
    sections=[struct.unpack_from('<IIQQQQIIQQ',data,offset+i*stride) for i in range(count)]
    result=[]
    for row in sections:
        if row[1]!=6:continue
        strings=sections[row[6]]; table=data[strings[4]:strings[4]+strings[5]]
        for at in range(row[4],row[4]+row[5],16):
            tag,value=struct.unpack_from('<qQ',data,at)
            if tag==1:
                name=table[value:table.index(b'\0',value)].decode('ascii')
                if '/' in name or name in ('.','..'):raise ValueError('unsafe ELF dependency')
                result.append(name)
    return result


def original_bytes(reader,name,limit):
    fd=reader.file(name)
    try:
        before=signature(os.fstat(fd))
        if before['bytes']>limit:raise ValueError('source byte limit: '+name)
        chunks=[];total=0
        while True:
            chunk=os.read(fd,1024**2)
            if not chunk:break
            total+=len(chunk)
            if total>limit:raise ValueError('growing source')
            chunks.append(chunk)
        if before!=signature(os.fstat(fd)):raise ValueError('source changed: '+name)
        return b''.join(chunks),before
    finally:os.close(fd)


def bounded(command,cwd,seconds=60,memory=4*1024**3,file_limit=512*1024**2):
    def restrict():
        os.nice(10)
        resource.setrlimit(resource.RLIMIT_AS,(memory,memory))
        resource.setrlimit(resource.RLIMIT_CPU,(seconds,seconds+1))
        resource.setrlimit(resource.RLIMIT_FSIZE,(file_limit,file_limit))
        resource.setrlimit(resource.RLIMIT_CORE,(0,0))
        if hasattr(os,'sched_setaffinity'):
            allowed=sorted(os.sched_getaffinity(0));os.sched_setaffinity(0,set(allowed[:2]))
    env=dict(os.environ,TMPDIR=cwd,TMP=cwd,TEMP=cwd,PYTHONDONTWRITEBYTECODE='1')
    start=time.monotonic()
    try:
        p=subprocess.run(command,cwd=cwd,env=env,capture_output=True,timeout=seconds+10,preexec_fn=restrict)
        return dict(command=command,exit_code=p.returncode,seconds=time.monotonic()-start,
                    stdout=p.stdout.decode('utf-8',errors='replace'),stderr=p.stderr.decode('utf-8',errors='replace'))
    except subprocess.TimeoutExpired as e:
        return dict(command=command,exit_code=None,timeout=True,seconds=time.monotonic()-start,
                    stdout=(e.stdout or b'').decode('utf-8',errors='replace'),stderr=(e.stderr or b'').decode('utf-8',errors='replace'))


def tool_command(base,args):
    return [WORKSPACE+'/'+base+'/tool/lib/ld-linux-x86-64.so.2','--inhibit-cache','--inhibit-rpath','',
            '--library-path',WORKSPACE+'/'+base+'/tool/lib',WORKSPACE+'/'+base+'/tool/libexec/slang',*args]


def probe(request):
    guard,reader=Guard(),Reader()
    base='runs/'+identifier(request['run_id'])
    with guard.directory(base,create=True,exclusive=True):pass
    with guard.directory(base+'/work',create=True,exclusive=True) as fd:
        disk=os.fstatvfs(fd)
    free=disk.f_bavail*disk.f_frsize
    if free<4*1024**3:raise ValueError('less than 4 GiB free space')
    inventory=[];queue=['libexec/slang','lib/ld-linux-x86-64.so.2'];seen=set();total=0
    while queue:
        name=queue.pop(0)
        if name in seen:continue
        seen.add(name)
        data,info=original_bytes(reader,TOOL+'/'+name,128*1024**2)
        total+=len(data)
        if total>TOOL_LIMIT:raise ValueError('existing runtime copy exceeds 256 MiB')
        guard.new_file(base+'/tool/'+name,data)
        # Only newly created copies become executable; no source metadata changes.
        with guard.directory(base+'/tool/'+name.rsplit('/',1)[0]) as fd:
            executable=os.open(name.rsplit('/',1)[1],os.O_RDONLY|os.O_NOFOLLOW,dir_fd=fd)
            try:os.fchmod(executable,0o500)
            finally:os.close(executable)
        inventory.append(dict(source=ORIGINAL+'/'+TOOL+'/'+name,copy=base+'/tool/'+name,bytes=len(data),sha256=sha(data),source_stat=info))
        queue.extend('lib/'+n for n in needed(data) if 'lib/'+n not in seen)
    report=dict(status='PROBED',run_id=request['run_id'],free_bytes=free,
                available_ram_bytes=os.sysconf('SC_AVPHYS_PAGES')*os.sysconf('SC_PAGE_SIZE'),
                runtime_copy_bytes=total,runtime_files=inventory,
                help=bounded(tool_command(base,['--help']),WORKSPACE+'/'+base+'/work',10),
                version=bounded(tool_command(base,['--version']),WORKSPACE+'/'+base+'/work',10))
    guard.new_file(base+'/reports/probe.json',encoded(report))
    print(encoded(report).decode(),end='')


def fixtures(request):
    guard,reader=Guard(),Reader();base='runs/'+identifier(request['run_id'])
    if request.get('hier_help'):
        data,info=original_bytes(reader,TOOL+'/libexec/slang-hier',128*1024**2)
        guard.new_file(base+'/tool/libexec/slang-hier',data)
        with guard.directory(base+'/tool/libexec') as fd:
            f=os.open('slang-hier',os.O_RDONLY|os.O_NOFOLLOW,dir_fd=fd)
            try:os.fchmod(f,0o500)
            finally:os.close(f)
        command=tool_command(base,['--help']);command[-2]=WORKSPACE+'/'+base+'/tool/libexec/slang-hier'
        result=bounded(command,WORKSPACE+'/'+base+'/work',10)
        guard.new_file(base+'/reports/hier-help.json',encoded(result));print(encoded(result).decode(),end='');return
    src='''// always @(negedge bogus) initial memory[3]; module Fake(); endmodule
module Leaf #(parameter W=4)(input clk,rst,input [W-1:0]d, output reg [W-1:0]q);
reg [3:0] mem [0:7];
always @(posedge clk or negedge rst) if(!rst) q<=4'b0; else q<=d;
always @(posedge clk) mem[d[2:0]] <= d;
initial mem[0]=4'bx;
endmodule
module Top(input clk,rst,input [3:0]d,output [3:0]q);
wire [3:0] x; Leaf a(clk,rst,d,x); Leaf b(clk,rst,x,q);
endmodule
'''
    guard.new_file(base+'/work/fixture.sv',src.encode())
    result=bounded(tool_command(base,['--top','Top','--ast-json','fixture.ast.json','--ast-json-source-info',
                                    '--cst-json','fixture.cst.json','--cst-json-mode','simple-tokens','fixture.sv']),WORKSPACE+'/'+base+'/work',20)
    result['ast']=json.loads(guard.read(base+'/work/fixture.ast.json',16*1024**2))
    result['cst']=json.loads(guard.read(base+'/work/fixture.cst.json',16*1024**2))
    guard.new_file(base+'/reports/fixture-result.json',encoded(result));print(encoded(result).decode(),end='')


def formats(request):
    guard=Guard();base='runs/'+identifier(request['run_id']);out={}
    for mode in ('full','no-trivia'):
        name='fixture.'+mode+'.json'
        if guard.exists(base+'/work/'+name):raise FileExistsError(name)
        result=bounded(tool_command(base,['--parse-only','--cst-json',name,'--cst-json-mode',mode,'fixture.sv']),WORKSPACE+'/'+base+'/work',10)
        result['sample']=json.loads(guard.read(base+'/work/'+name,16*1024**2))
        out[mode]=result
    command=tool_command(base,['--top','Top','--custom-format','{inst}|{module}|{file}','fixture.sv'])
    command[command.index(WORKSPACE+'/'+base+'/tool/libexec/slang')]=WORKSPACE+'/'+base+'/tool/libexec/slang-hier'
    out['hierarchy']=bounded(command,WORKSPACE+'/'+base+'/work',15)
    print(encoded(out).decode(),end='')


def prepare_inputs(request):
    guard,reader=Guard(),Reader();base='runs/'+identifier(request['run_id'])
    probe_report=json.loads(guard.read(base+'/reports/probe.json',1024**2))
    with guard.directory(base+'/work') as fd:
        if os.fstatvfs(fd).f_bavail*os.fstatvfs(fd).f_frsize<4*1024**3:raise ValueError('disk reserve below 4 GiB')
    inventory=reader.inventory()
    guard.new_file(base+'/reports/original-inventory.json',encoded(inventory))
    files=[];total=0
    for entry in inventory['files']:
        if not entry['path'].lower().endswith(('.sv','.v','.svh','.vh')):continue
        data,info=original_bytes(reader,entry['path'],16*1024**2)
        if any(info[k]!=entry[k] for k in info):raise ValueError('frozen inventory changed')
        total+=len(data)
        if total>512*1024**2:raise ValueError('RTL payload exceeds 512 MiB first-round budget')
        relative_name=entry['path'][len(RTL)+1:]
        text=data.decode('utf-8')
        # Do not allow the official parser to open unapproved include paths.
        for match in re.finditer(r'(?m)^\s*`include\s+([^\n]+)',text):
            target=match.group(1).strip()
            if not (target.startswith('"') and target.endswith('"')):raise ValueError('macro include needs separate review')
            name=target[1:-1]
            if '/' in name or '\\' in name or ':' in name or '..' in name:raise ValueError('nonlocal include refused')
            if not any(r['path']==RTL+'/'+name for r in inventory['files']):raise ValueError('include absent from input set')
        guard.new_file(base+'/inputs/'+relative_name,data)
        files.append(dict(name=relative_name,source=ORIGINAL+'/'+entry['path'],bytes=len(data),sha256=sha(data),stat=info))
    if reader.inventory()!=inventory:raise ValueError('source inventory changed after copy')
    metadata=[];missing=[];metadata_total=0
    paths=['runs/20261016-linux-01/model/manifest.json','xiangshan2lean-server/SERVER-BUNDLE.json',
           'xiangshan2lean-server/model/origin-manifest.json',
           'source/20261016-full-local-project/ICT/chisel2lean4/docs/validation-xiangshan-full-7.3.json',
           'source/20261016-full-local-project/ICT/chisel2lean4/docs/validation-xiangshan-native-import-7.3.json',
           'source/20261016-full-local-project/ICT/chisel2lean4/docs/validation-server-linux-7.3.json']
    for index,name in enumerate(paths):
        try:data,info=original_bytes(reader,name,min(16*1024**2,20*1024**2-metadata_total))
        except FileNotFoundError:missing.append(name);continue
        metadata_total+=len(data);value=json.loads(data)
        target=base+'/metadata/'+str(index)+'.json';guard.new_file(target,data)
        metadata.append(dict(source=ORIGINAL+'/'+name,copy=target,bytes=len(data),sha256=sha(data),value=value))
        # Follow only the explicitly recorded elaboration receipt in the known source copy.
        if 'validation-xiangshan-full' in name:
            old=value.get('evidence',{}).get('elaboration','').replace('\\','/')
            prefix='E:/ICT/chisel2lean4/'
            if old.startswith(prefix):
                candidate='source/20261016-full-local-project/ICT/chisel2lean4/'+old[len(prefix):]
                if '..' not in candidate.split('/'):paths.append(candidate)
    model=next(m['value'] for m in metadata if m['source'].endswith('/runs/20261016-linux-01/model/manifest.json'))
    expected=model.get('source_files_sha256',{})
    normalized={name.replace('\\','/').rsplit('/',1)[-1]:value for name,value in expected.items()}
    compared=[dict(file=r['name'],actual=r['sha256'],expected=normalized.get(r['name']),match=normalized.get(r['name'])==r['sha256']) for r in files]
    receipt=dict(status='INPUTS_COPIED',files=files,bytes=total,metadata=[{k:v for k,v in m.items() if k!='value'} for m in metadata],
                 missing_metadata=missing,model_hash_comparisons=compared,model_nodes=model.get('nodes'),
                 model_lean_version=model.get('lean_version'),runtime_copy_bytes=probe_report['runtime_copy_bytes'])
    guard.new_file(base+'/reports/inputs.json',encoded(receipt))
    print(encoded(dict(status=receipt['status'],rtl_files=len(files),rtl_bytes=total,
                       manifest_entries=len(expected),hash_matches=sum(r['match'] for r in compared),
                       missing_metadata=missing,metadata_bytes=metadata_total,
                       xstop=next(r for r in compared if r['file']=='XSTop.sv'))).decode(),end='')


def scan(request):
    from audit_fourstate_syntax import facts,hierarchy_output
    guard=Guard();base='runs/'+identifier(request['run_id']);cwd=WORKSPACE+'/'+base+'/inputs'
    from fourstate_sync_remote import verify_release
    deployed=verify_release(guard,identifier(request['snapshot_id']))
    for name,expected in request['workers_sha256'].items():
        content=guard.read('releases/'+request['snapshot_id']+'/src/scripts/'+name+'.py',1024**2)
        if sha(content)!=expected:raise ValueError('executed worker differs from deployed snapshot: '+name)
    resource.setrlimit(resource.RLIMIT_AS,(8*1024**3,8*1024**3))
    receipt=json.loads(guard.read(base+'/reports/inputs.json',8*1024**2))
    modules=[];records=[];compressed_total=0;started=time.monotonic()
    for index,row in enumerate(receipt['files']):
        if not row['name'].lower().endswith(('.sv','.v')):continue
        if time.monotonic()-started>1800:raise RuntimeError('30 minute scan wall budget reached')
        source=guard.read(base+'/inputs/'+row['name'],16*1024**2).decode('utf-8')
        command=tool_command(base,['--parse-only','-q','--threads','1','--cst-json','-',
                                  '--cst-json-mode','simple-tokens',row['name']])
        result=bounded(command,cwd,45,memory=3*1024**3)
        stdout=result.pop('stdout');result['file']=row['name'];result['stdout_sha256']=sha(stdout.encode())
        result['stdout_bytes']=len(stdout.encode())
        if len(stdout)>128*1024**2:raise ValueError('per-file CST exceeds 128 MiB')
        compressed=gzip.compress(stdout.encode(),compresslevel=3);compressed_total+=len(compressed)
        if compressed_total>1024**3:raise ValueError('compressed CST budget exceeds 1 GiB')
        guard.new_file(base+'/work/cst/'+row['name']+'.json.gz',compressed)
        result['cst_gzip_sha256']=sha(compressed)
        if result['exit_code']==0:
            try:found=facts(json.loads(stdout),source,row['name'])
            except Exception as error:
                result['analysis_error']=repr(error);found=[]
            modules.extend(found);result['definitions']=len(found)
        guard.new_file(base+'/logs/parse-'+str(index)+'.json',encoded(result));records.append(result)
        if index%50==0:
            guard.new_file(base+'/logs/progress-'+str(index)+'.json',encoded(dict(files=index+1,elapsed=time.monotonic()-started)))
    guard.new_file(base+'/reports/modules.json',encoded(modules))
    guard.new_file(base+'/reports/parse-results.json',encoded(records))
    names=[r['name'] for r in receipt['files'] if r['name'].lower().endswith(('.sv','.v'))]
    guard.new_file(base+'/inputs/audit-files.f',('\n'.join(names)+'\n').encode())
    command=tool_command(base,['--top','XSTop','-q','--threads','1','--disable-analysis','--custom-format','{inst}|{module}|{file}',
                              '-f','audit-files.f'])
    command[command.index(WORKSPACE+'/'+base+'/tool/libexec/slang')]=WORKSPACE+'/'+base+'/tool/libexec/slang-hier'
    hierarchy=bounded(command,cwd,900,memory=6*1024**3,file_limit=64*1024**2)
    guard.new_file(base+'/logs/hierarchy-command.json',encoded(hierarchy))
    paths=hierarchy_output(hierarchy['stdout']) if hierarchy['exit_code']==0 else []
    guard.new_file(base+'/reports/hierarchy.json',encoded(dict(status='ELABORATED' if hierarchy['exit_code']==0 else 'UNCONFIRMED',
                                                            instances=paths,command_exit_code=hierarchy['exit_code'])))
    result=dict(status='STATIC_SCAN_COMPLETED',parsed_files=len(records),parse_exit_zero=sum(r['exit_code']==0 for r in records),
                analysis_errors=sum('analysis_error' in r for r in records),definitions=len(modules),
                hierarchy_exit_code=hierarchy['exit_code'],hierarchy_instances=len(paths),
                elapsed_seconds=time.monotonic()-started,cst_gzip_bytes=compressed_total,
                source_snapshot_id=request['snapshot_id'],source_manifest_sha256=deployed['manifest_sha256'])
    guard.new_file(base+'/reports/scan-result.json',encoded(result));print(encoded(result).decode(),end='')


def inspect_scan(request):
    """Small bounded diagnostics from this run only; never launch another scan."""
    guard=Guard();base='runs/'+identifier(request['run_id']);out={}
    for name in ('scan-result.json','modules.json','parse-results.json','hierarchy.json'):
        path=base+'/reports/'+name
        if not guard.exists(path):continue
        value=json.loads(guard.read(path,192*1024**2))
        if name=='modules.json':
            from collections import Counter
            kinds=Counter();features=Counter()
            for module in value:kinds.update(module['kind_counts']);features.update(module['features'])
            out[name]=dict(definitions=len(value),kinds=kinds,features=features,
                           samples=[m for m in value if m['name'] in request.get('modules',[])])
        elif name=='parse-results.json':
            out[name]=dict(files=len(value),errors=[r for r in value if r['exit_code']!=0 or 'analysis_error' in r])
        elif name=='hierarchy.json':
            out[name]=dict(status=value['status'],instances=len(value['instances']),sample=value['instances'][:5])
        else:out[name]=value
    if not out:
        with guard.directory(base+'/logs') as fd:
            names=[n for n in os.listdir(fd) if re.fullmatch(r'progress-\d+\.json',n)]
        if names:out['progress']=json.loads(guard.read(base+'/logs/'+max(names,key=lambda n:int(n[9:-5])),1024))
    if guard.exists(base+'/logs/hierarchy-command.json'):
        value=json.loads(guard.read(base+'/logs/hierarchy-command.json',64*1024**2))
        out['hierarchy_command']={k:(v[:18000] if isinstance(v,str) else v) for k,v in value.items()}
    if request.get('cst_file'):
        receipt=json.loads(guard.read(base+'/reports/inputs.json',8*1024**2))
        name=request['cst_file']
        if name not in {r['name'] for r in receipt['files']}:raise ValueError('file not in RTL inventory')
        cst=json.loads(gzip.decompress(guard.read(base+'/work/cst/'+name+'.json.gz',32*1024**2)))
        from audit_fourstate_syntax import walk
        out['cst_samples']={kind:[n for n in walk(cst) if n.get('kind')==kind][:2] for kind in request.get('kinds',[])}
    print(encoded(out).decode(),end='')


def provenance_more(request):
    guard,reader=Guard(),Reader();base='runs/'+identifier(request['run_id']);out={}
    for index in (0,1,2,3,4,5):
        name=base+'/metadata/'+str(index)+'.json'
        if not guard.exists(name):continue
        value=json.loads(guard.read(name,16*1024**2))
        out[str(index)]={k:(v if len(encoded(v))<24000 else dict(omitted=True,entries=len(v))) for k,v in value.items()}
    root='source/20261016-full-local-project/ICT/chisel2lean4/experiments'
    for name in ('xiangshan-whole-lean-7.3','xiangshan-whole-differential-7.3'):
        try:out[name]=reader.listing(root+'/'+name)
        except FileNotFoundError:out[name]='missing'
    print(encoded(out).decode(),end='')


def hierarchy_retry(request):
    from audit_fourstate_syntax import hierarchy_output
    guard=Guard();base='runs/'+identifier(request['run_id'])
    command=tool_command(base,['--top','XSTop','--threads','1','--custom-format','{inst}|{module}|{file}',
                              '-f','audit-files.f'])
    command[command.index(WORKSPACE+'/'+base+'/tool/libexec/slang')]=WORKSPACE+'/'+base+'/tool/libexec/slang-hier'
    result=bounded(command,WORKSPACE+'/'+base+'/inputs',900,memory=6*1024**3,file_limit=64*1024**2)
    guard.new_file(base+'/logs/hierarchy-v2-command.json',encoded(result))
    paths=hierarchy_output(result['stdout']) if result['exit_code']==0 else []
    guard.new_file(base+'/reports/hierarchy-v2.json',encoded(dict(status='ELABORATED' if result['exit_code']==0 else 'UNCONFIRMED',
                                                               instances=paths,command_exit_code=result['exit_code'])))
    print(encoded(dict(exit_code=result['exit_code'],seconds=result['seconds'],instances=len(paths),
                       stderr=result['stderr'][:20000],stdout_sample=result['stdout'][:2000])).decode(),end='')


def reanalyze(request):
    """Offline replay of retained CST; no compiler, no source-project access."""
    from audit_fourstate_syntax import facts,preprocessing_facts
    guard=Guard();base='runs/'+identifier(request['run_id']);version=identifier(request['version'])
    resource.setrlimit(resource.RLIMIT_AS,(8*1024**3,8*1024**3))
    receipt=json.loads(guard.read(base+'/reports/inputs.json',8*1024**2))
    records=json.loads(guard.read(base+'/reports/parse-results.json',8*1024**2));byfile={r['file']:r for r in records}
    modules=[];preprocessing=[];start=time.monotonic()
    for row in receipt['files']:
        if row['name'] not in byfile:continue
        if time.monotonic()-start>1800:raise RuntimeError('offline replay exceeded 30 minutes')
        source=guard.read(base+'/inputs/'+row['name'],16*1024**2)
        if sha(source)!=row['sha256']:raise ValueError('input copy changed')
        data=guard.read(base+'/work/cst/'+row['name']+'.json.gz',32*1024**2)
        if sha(data)!=byfile[row['name']]['cst_gzip_sha256']:raise ValueError('CST changed')
        source=source.decode('utf-8');tree=json.loads(gzip.decompress(data))
        modules.extend(facts(tree,source,row['name']));preprocessing.append(preprocessing_facts(source,row['name']))
    payload=encoded(modules);compressed=gzip.compress(payload,compresslevel=3)
    guard.new_file(base+'/reports/modules-'+version+'.json.gz',compressed)
    guard.new_file(base+'/reports/preprocessing-'+version+'.json',encoded(preprocessing))
    from collections import Counter
    features=Counter();definition_counts=Counter();calls=Counter()
    for m in modules:
        features.update(m['features']);definition_counts.update(m['features'].keys());calls.update(m['system_calls'])
    result=dict(version=version,definitions=len(modules),features=features,definition_counts=definition_counts,system_calls=calls,
                special_modules=[dict(name=m['name'],file=m['file'],features=m['features'],processes=m['processes']) for m in modules if m['features'].get('always_latch')],
                elapsed_seconds=time.monotonic()-start,facts_bytes=len(payload),facts_gzip_bytes=len(compressed),facts_sha256=sha(payload),
                facts_gzip_sha256=sha(compressed),workers_sha256=request['workers_sha256'])
    guard.new_file(base+'/reports/reanalysis-'+version+'.json',encoded(result));print(encoded(result).decode(),end='')


def source_evidence(request):
    """Locate representative anchors in the already copied inputs, not counts."""
    from audit_fourstate_syntax import mask
    guard=Guard();base='runs/'+identifier(request['run_id']);version=identifier(request['version'])
    receipt=json.loads(guard.read(base+'/reports/inputs.json',8*1024**2));files={r['name']:r for r in receipt['files']}
    if len(request['examples'])>35:raise ValueError('example budget exceeded')
    out=[]
    for example in request['examples']:
        name=example['file']
        if name not in files:raise ValueError('evidence file not in input inventory')
        raw=guard.read(base+'/inputs/'+name,16*1024**2)
        if sha(raw)!=files[name]['sha256']:raise ValueError('input copy changed')
        source=raw.decode('utf-8');match=re.search(example['pattern'],mask(source),re.M)
        line=source.count('\n',0,match.start())+1 if match else None
        lines=source.splitlines();start=max(1,(line or 1)-2);end=min(len(lines),(line or 1)+12)
        out.append(dict(feature=example['feature'],file=name,line=line,pattern=example['pattern'],sha256=sha(raw),
                        source=files[name]['source'],snippet='\n'.join(str(i)+': '+lines[i-1] for i in range(start,end+1)),
                        method='CST-selected feature, comment/string-filtered representative anchor; not an occurrence count'))
    guard.new_file(base+'/reports/source-evidence-'+version+'.json',encoded(out));print(encoded(out).decode(),end='')


def publish_reports(request):
    guard=Guard();base='runs/'+identifier(request['run_id'])
    allowed={'summary.json','report.md','gaps.csv','support-evidence.json','aggregate.json','audit-tests.json','reproduction.json'}
    if set(request['files'])-allowed:raise ValueError('unapproved report name')
    if sum(len(v.encode('utf-8')) for v in request['files'].values())>16*1024**2:raise ValueError('report byte budget exceeded')
    # Every destination must be absent before the first write; no implicit repair.
    if any(guard.exists(base+'/reports/'+name) for name in request['files']):raise FileExistsError('report already exists')
    for name,content in request['files'].items():guard.new_file(base+'/reports/'+name,content.encode('utf-8'))
    receipt=dict(status='REPORTS_CREATED',files=[dict(path='reports/'+n,sha256=sha(v.encode('utf-8')),bytes=len(v.encode('utf-8'))) for n,v in request['files'].items()],
                 workers_sha256=request['workers_sha256'])
    guard.new_file(base+'/reports/publication-receipt.json',encoded(receipt));print(encoded(receipt).decode(),end='')


def final_verify(request):
    guard,reader=Guard(),Reader();base='runs/'+identifier(request['run_id'])
    frozen=json.loads(guard.read(base+'/reports/original-inventory.json',8*1024**2))
    unchanged=reader.inventory()==frozen
    probes={'scp-test-ba5cab1836a0470a8a3b9ea0e150f3a4.txt':'8e48a91d0924a77d8fafa348199a6d0b5084d1691b9744161bc6893790aa61a5',
            'sync-probe-e36a61fd0ee843f4924fdb636d95ded6.txt':'d9ca5c23019050d6af0264d573bb0f7f54b8ae1c1712453b0a08625686f0b37a'}
    checks=[dict(file=n,sha256=sha(guard.read(n,1024)),matches=sha(guard.read(n,1024))==v) for n,v in probes.items()]
    with guard.directory(base+'/work') as fd:disk=os.fstatvfs(fd)
    result=dict(original_rtl_inventory_and_metadata_unchanged=unchanged,existing_probe_checks=checks,
                free_bytes=disk.f_bavail*disk.f_frsize,
                write_root=WORKSPACE,server_no_delete_or_overwrite=True,
                note='Checks frozen input inventory/stat signatures, not a claim to observe all unrelated server files. Original reads used O_NOATIME/O_NOFOLLOW.')
    if not unchanged or not all(r['matches'] for r in checks):raise ValueError('final integrity check failed')
    guard.new_file(base+'/reports/safety-verification.json',encoded(result));print(encoded(result).decode(),end='')
