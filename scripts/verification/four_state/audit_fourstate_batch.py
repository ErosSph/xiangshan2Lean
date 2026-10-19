"""F4.4 bounded module conversion probes; no frontend semantics are changed.

Windows Job Objects constrain the worker and its compiler children. Acquisition
and synchronization use the existing Reader/Guard/sync tools, separately.
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
import csv
import ctypes as C
import hashlib
import itertools
import json
import os
from pathlib import Path
import random
import subprocess
import sys
import time
import traceback

ROOT=_PROJECT_ROOT
STAGES=('preprocessed','fourstate_ir','encoded_rtl','functional_ir','lean_compiled','lean_executed','three_way')


def write(path,value):
    path=Path(path);path.parent.mkdir(parents=True,exist_ok=True)
    path.write_text(json.dumps(value,indent=2,ensure_ascii=False)+'\n',encoding='utf8')


def category(error):
    import re
    # Paths and identifiers can contain words such as "macro", "dpi" and
    # "port". Classify the diagnostic message, never the evidence path.
    text=re.sub(r'^.*?:\d+:\d+:\s*','',error).lower()
    rules=[('standalone_no_output',('at least one top output',)),
           ('fixed_vector_requirement',('fixed four-state packed vector required',)),
           ('memory',('unpacked','memory','array_procedural')),
           ('async_event_scope',('async process','async reset requires','async events','async reset','asynchronous','two direct posedge','event inputs')),
           ('latch_or_nonclocked',('initial/nonclocked','clocked process requires')),
           ('preprocessor',('preprocessor','macro','include')),
           ('dynamic_select',('dynamic selection','range select','indexed')),
           ('packed_dimensions',('packed dimensions',)),
           ('named_process_scope',('named procedural blocks',)),
           ('process_local',('process local','automatic','blocking assignment','declaration initializer')),
           ('unsupported_operator',('expression','unsized','arithmetic')),
           ('external_or_system',('dpi','system call','unsupported active elaborated symbol')),
           ('interface_or_binding',('input port','output port','port binding','unknown module','connection','must be connected','driver'))]
    return next((name for name,needles in rules if any(n in text for n in needles)),'unclassified')


def bounded(argv,folder,seconds=20,memory=2*1024**3,output_limit=64*1024**2):
    """Worker blocks on stdin until its entire process tree is assigned a job."""
    if os.name!='nt':raise RuntimeError('This bounded local driver requires Windows Job Objects')
    folder=Path(folder);folder.mkdir(parents=True,exist_ok=False)
    class Basic(C.Structure):
        _fields_=[('ProcessTime',C.c_longlong),('JobTime',C.c_longlong),('Flags',C.c_uint32),
                  ('MinimumWorkingSet',C.c_size_t),('MaximumWorkingSet',C.c_size_t),('ActiveProcesses',C.c_uint32),
                  ('Affinity',C.c_size_t),('PriorityClass',C.c_uint32),('SchedulingClass',C.c_uint32)]
    class IO(C.Structure):_fields_=[(n,C.c_ulonglong) for n in ('ReadOps','WriteOps','OtherOps','ReadBytes','WriteBytes','OtherBytes')]
    class Extended(C.Structure):
        _fields_=[('Basic',Basic),('IO',IO),('ProcessMemoryLimit',C.c_size_t),('JobMemoryLimit',C.c_size_t),
                  ('PeakProcessMemoryUsed',C.c_size_t),('PeakJobMemoryUsed',C.c_size_t)]
    k=C.WinDLL('kernel32',use_last_error=True)
    k.CreateJobObjectW.argtypes=[C.c_void_p,C.c_wchar_p];k.CreateJobObjectW.restype=C.c_void_p
    k.SetInformationJobObject.argtypes=[C.c_void_p,C.c_int,C.c_void_p,C.c_uint32]
    k.QueryInformationJobObject.argtypes=[C.c_void_p,C.c_int,C.c_void_p,C.c_uint32,C.c_void_p]
    k.AssignProcessToJobObject.argtypes=[C.c_void_p,C.c_void_p]
    k.TerminateJobObject.argtypes=[C.c_void_p,C.c_uint32];k.CloseHandle.argtypes=[C.c_void_p]
    handle=k.CreateJobObjectW(None,None)
    if not handle:raise C.WinError(C.get_last_error())
    limit=Extended();limit.Basic.Flags=0x2000|0x100|0x200|0x8
    limit.Basic.ActiveProcesses=16;limit.ProcessMemoryLimit=memory;limit.JobMemoryLimit=memory
    k.GetCurrentProcess.restype=C.c_void_p
    k.GetProcessAffinityMask.argtypes=[C.c_void_p,C.POINTER(C.c_size_t),C.POINTER(C.c_size_t)]
    allowed,system=C.c_size_t(),C.c_size_t()
    if not k.GetProcessAffinityMask(k.GetCurrentProcess(),C.byref(allowed),C.byref(system)):raise C.WinError(C.get_last_error())
    cores=[1<<i for i in range(C.sizeof(C.c_size_t)*8) if allowed.value&(1<<i)]
    limit.Basic.Affinity=sum(cores[:2]);limit.Basic.Flags|=0x10
    process=None;start=time.monotonic();reason=None
    env=dict(os.environ,PYTHONDONTWRITEBYTECODE='1')
    try:
        if not k.SetInformationJobObject(handle,9,C.byref(limit),C.sizeof(limit)):raise C.WinError(C.get_last_error())
        with (folder/'stdout.log').open('wb') as stdout,(folder/'stderr.log').open('wb') as stderr:
            process=subprocess.Popen(argv,cwd=ROOT,env=env,stdin=subprocess.PIPE,stdout=stdout,stderr=stderr)
            if not k.AssignProcessToJobObject(handle,C.c_void_p(int(process._handle))):raise C.WinError(C.get_last_error())
            process.stdin.write(b'GO\n');process.stdin.close()
            while process.poll() is None:
                if time.monotonic()-start>seconds:reason='TIMEOUT';break
                size=sum(p.stat().st_size for p in folder.rglob('*') if p.is_file())
                if size>output_limit:reason='OUTPUT_LIMIT';break
                time.sleep(0.1)
            if reason:k.TerminateJobObject(handle,124)
            process.wait(timeout=10)
        observed=Extended()
        if not k.QueryInformationJobObject(handle,9,C.byref(observed),C.sizeof(observed),None):raise C.WinError(C.get_last_error())
        result=dict(argv=argv,exit_code=process.returncode,seconds=time.monotonic()-start,termination=reason,
                    peak_job_committed_bytes=observed.PeakJobMemoryUsed,
                    memory_measurement='Windows Job Object PeakJobMemoryUsed (committed memory, not RSS)',
                    limits=dict(wall_seconds=seconds,job_committed_bytes=memory,output_bytes=output_limit,parallel_workers=1,cpu_cores=min(2,len(cores))),
                    output_bytes=sum(p.stat().st_size for p in folder.rglob('*') if p.is_file()))
        write(folder/'execution.json',result);return result
    finally:
        if process is not None and process.poll() is None:k.TerminateJobObject(handle,125);process.wait(timeout=10)
        k.CloseHandle(handle)


def worker(request,folder):
    # No hardware/parser work before the parent's resource envelope is active.
    if sys.stdin.readline().strip()!='GO':raise RuntimeError('Missing resource-envelope handshake')
    from fourstate_frontend import parse
    from fourstate_encode import encode
    stages={name:'NOT_RUN' for name in STAGES};report=dict(module=request['module'],stages=stages,status='RUNNING')
    pp={};active='fourstate_ir'
    try:
        for path,expected in {**request.get('input_hashes',{}),**request.get('frontend_hashes',{})}.items():
            from fourstate_preprocess import stable_bytes
            if hashlib.sha256(stable_bytes(path)).hexdigest()!=expected:
                report['status']='INPUT_HASH_MISMATCH'
                raise ValueError('input source hash mismatch: '+path)
        args=dict(mode=request['mode'],clock=request.get('clock'),async_reset=request.get('async_reset'),preprocessing=pp,bounded_memories=request.get('bounded_memories',False))
        ir=parse(Path(request['source']),request['module'],**args)
        stages['preprocessed']='PASS';stages['fourstate_ir']='PASS'
        write(folder/'fourstate.ir.json',ir)
        active='encoded_rtl'
        rtl,mapping=encode(ir);(folder/'encoded.sv').write_text(rtl,encoding='utf8');write(folder/'ports.json',mapping)
        stages['encoded_rtl']='PASS';report.update(ir_nodes=len(ir['nodes']),original_state_bits=sum(s['width'] for s in ir['states']),
                                                   capabilities=ir.get('capabilities',[]))
        if request.get('backend'):
            active='functional_ir'
            from fourstate2lean import translate
            from fourstate_simulate import load,simulate
            from verify_fourstate import run_rtl,compare
            manifest=translate(Path(request['source']),request['module'],folder/'converted',request['mode'],request.get('clock'),async_reset=request.get('async_reset'))
            mapping,model=load(manifest);stages['functional_ir']='PASS';stages['lean_compiled']='PASS'
            report['functional_nodes']=len(json.loads(model.read_text())['nodes'])
            if request['mode']!='combinational':raise ValueError('Pilot behavioral driver is combinational only; no invented state/clock contract')
            inputs=[p for p in mapping['ports'] if p['direction']=='input'];bits=sum(p['width'] for p in inputs)
            rng=random.Random(440018)
            if bits<=4:
                vectors=itertools.product('01xz',repeat=bits);trace=[]
                for vector in vectors:
                    pos=0;values={}
                    for p in inputs:values[p['name']]=''.join(vector[pos:pos+p['width']]);pos+=p['width']
                    trace.append(dict(inputs=values))
            else:
                trace=[dict(inputs={p['name']:v*p['width'] for p in inputs}) for v in '01xz']
                trace += [dict(inputs={p['name']:''.join(rng.choice('01xz') for _ in range(p['width'])) for p in inputs}) for _ in range(60)]
            write(folder/'trace.json',trace)
            active='original_rtl'
            raw=run_rtl(Path(request['source']),mapping,trace,folder/'original')
            report['original_rtl_executed']=True
            active='encoded_rtl_execution'
            encoded=run_rtl(manifest.parent/'encoded.sv',mapping,trace,folder/'encoded',True)
            report['encoded_rtl_executed']=True
            active='lean_executed'
            lean=simulate(manifest,trace,folder/'lean');stages['lean_executed']='PASS'
            active='three_way'
            compared=compare(mapping,raw,encoded,[r['outputs'] for r in lean]);stages['three_way']='PASS'
            report.update(samples=len(trace),compared_output_bit_positions=compared,behavior_scope='Finite scalar exhaustive or 64-vector four-state corpus; one definition, not all instances')
        report['status']='COMPLETED'
    except Exception as e:
        if pp.get('status')=='PREPROCESSED':stages['preprocessed']='PASS'
        elif pp.get('status')=='REJECTED':stages['preprocessed']='FAIL'
        if active in STAGES and (stages['preprocessed']=='PASS' or active!='fourstate_ir'):stages[active]='FAIL'
        integrity='parser' in str(e).lower() and any(x in str(e).lower() for x in ('mismatch','file changed','lock'))
        report.update(status=report['status'] if report['status']=='INPUT_HASH_MISMATCH' else 'TOOL_INTEGRITY_MISMATCH' if integrity else 'SEMANTIC_MISMATCH' if active=='three_way' else 'REJECTED' if isinstance(e,ValueError) else 'TOOL_FAILURE',error=str(e),category='behavior_difference' if active=='three_way' else category(str(e)),failure_stage=active,traceback=traceback.format_exc())
        # Preserve real partial backend progress rather than treating later
        # Lean failure as a failure to generate FunctionalIR.
        model=folder/'converted/model/yosys.ir.json'
        converted=folder/'converted'
        if converted.exists():
            candidates=list((converted/'model').rglob('*.ir.json'))
            for candidate in candidates:
                try:
                    value=json.loads(candidate.read_text())
                    if (isinstance(value,dict) and value.get('format')=='chisel2lean-functional-v1' and
                            all(k in value for k in ('nodes','inputs','outputs'))):stages['functional_ir']='PASS'
                except (ValueError,UnicodeError):pass
            check=converted/'lean-check/result.json'
            if check.exists():
                r=json.loads(check.read_text());stages['lean_compiled']='PASS' if r['status']=='PASS' else 'FAIL'
    write(folder/'preprocessing.json',pp);write(folder/'result.json',report)
    return 0 if report['status']=='COMPLETED' else 2


def campaign(plan,out):
    out=Path(out).resolve();out.mkdir(parents=True,exist_ok=False)
    plan=json.loads(Path(plan).read_text(encoding='utf8'));write(out/'plan.json',plan)
    results=[];start=time.monotonic()
    for i,row in enumerate(plan['modules']):
        if time.monotonic()-start>plan.get('total_seconds',900):break
        if sum(p.stat().st_size for p in out.rglob('*') if p.is_file())>plan.get('total_output_bytes',512*1024**2):break
        request=dict(row);request_file=out/('request-'+str(i)+'.json');write(request_file,request)
        folder=out/('m'+format(i,'04d'))
        command=[sys.executable,'-B',str(Path(__file__).resolve()),'worker','--request',str(request_file),'--out',str(folder)]
        execution=bounded(command,folder,seconds=120 if row.get('backend') else 20)
        p=folder/'result.json'
        result=json.loads(p.read_text(encoding='utf8')) if p.exists() else dict(module=row['module'],stages={s:'UNKNOWN_RESOURCE_TERMINATION' for s in STAGES},status='RESOURCE_TERMINATED',category='resource',error=execution['termination'] or 'worker terminated before result receipt')
        result.update(source_sha256=row['source_sha256'],known_xstop_instances=row['instances'],execution=execution)
        results.append(result);write(folder/'result-with-receipt.json',result)
        print(row['module'],result['status'],result.get('category',''),flush=True)
        if result['status'] in ('INPUT_HASH_MISMATCH','TOOL_INTEGRITY_MISMATCH'):break
    summary=dict(status='BATCH_COMPLETED' if len(results)==len(plan['modules']) else 'BATCH_PARTIAL_BUDGET',
                 scope='Selected definitions only; instance weights are audit multiplicities, not per-instance conversion or verification',
                 requested=len(plan['modules']),attempted=len(results),seconds=time.monotonic()-start,results=results,
                 stages={s:dict(definitions=sum(r['stages'][s]=='PASS' for r in results),weighted_instances=sum(r['known_xstop_instances'] for r in results if r['stages'][s]=='PASS')) for s in STAGES})
    write(out/'summary.json',summary)
    with (out/'gaps.csv').open('w',encoding='utf8',newline='') as f:
        fields=['module','source_sha256','known_xstop_instances','status','category','error',*STAGES];writer=csv.DictWriter(f,fields);writer.writeheader()
        for r in results:writer.writerow({**{k:r.get(k,'') for k in fields if k not in STAGES},**r['stages']})
    return summary


def select_modules(facts,inventory,hierarchy,out):
    """Select bounded dependency closures; clock flags follow actual port bindings.

    This reuses frozen F3.1 syntax facts. It neither reparses the complete RTL nor
    claims all discovered clock expressions are equivalent physical domains.
    """
    import gzip
    from collections import Counter
    facts=Path(facts)
    modules=json.loads(gzip.decompress(facts.read_bytes()) if facts.suffix=='.gz' else facts.read_bytes())
    modules={m['name']:m for m in modules}
    inv={f['name']:f for f in json.loads(Path(inventory).read_text())['files']}
    counts=Counter(r['module'] for r in json.loads(Path(hierarchy).read_text())['instances'])
    ledger=[];needed=set()
    for name,m in sorted(modules.items()):
        seen=set();pending=[name]
        while pending:
            n=pending.pop()
            if n in seen:continue
            if n not in modules:raise ValueError('Unknown frozen dependency: '+n)
            seen.add(n);pending.extend(i['module'] for i in modules[n]['instances'])
        files=sorted({modules[n]['file'] for n in seen});size=sum(inv[n]['bytes'] for n in files)
        row=dict(module=name,file=m['file'],source_sha256=inv[m['file']]['sha256'],source_bytes=inv[m['file']]['bytes'],
                 source_hash_evidence='F3.1 inventory; fresh byte verification only for acquired/attempted inputs',
                 instances=counts[name],files=files,closure_types=len(seen),closure_bytes=size,
                 audit_features=m['features'],backend=False)
        if name=='XSTop':row['selection']='SKIPPED_FULL_TOP_GATE'
        elif len(files)>16 or size>128*1024:row['selection']='SKIPPED_CLOSURE_BUDGET'
        else:
            endpoints=set();unknown=[];visited=set();process_count=0
            def descend(module,bindings):
                nonlocal process_count
                key=(module,tuple(sorted(bindings.items())))
                if key in visited:return
                visited.add(key);definition=modules[module]
                for p in definition['processes']:
                    if not p.get('events'):continue
                    process_count+=1
                    clocks=p.get('clock_events') or p['events'][:1]
                    for event in clocks:
                        resolved=bindings.get(event['expr'])
                        if resolved:endpoints.add(resolved)
                        else:unknown.append(dict(module=module,expression=event['expr']))
                for instance in definition['instances']:
                    child={}
                    for b in instance['bindings']:
                        if b.get('expr_kind')=='IdentifierName' and b.get('formal'):
                            value=bindings.get(b['expr'])
                            if value:child[b['formal']]=value
                    descend(instance['module'],child)
            top_inputs={p['name']:p['name'] for p in m['ports'] if p['direction']=='input'}
            descend(name,top_inputs)
            row.update(clock_roots=sorted(endpoints),unresolved_clock_bindings=unknown)
            if process_count and not endpoints:row['selection']='SKIPPED_UNRESOLVED_CLOCK_PROFILE'
            else:
                clock=sorted(endpoints)[0] if endpoints else None
                reset=None
                if not m['instances'] and len(m['processes'])==1:
                    proc=m['processes'][0];asyncs=proc.get('async_control_candidates',[])
                    if len(proc.get('events',[]))==2 and len(asyncs)==1 and asyncs[0]['expr'] in top_inputs:
                        reset=asyncs[0]['expr']
                row.update(selection='ELIGIBLE',mode='sequential' if process_count else 'combinational',clock=clock,async_reset=reset)
                needed.update(files)
        ledger.append(row)
    # A known macro-only file is available to literal include resolution; it is
    # not added as a compilation unit to every module.
    if 'DifftestMacros.v' in inv:needed.add('DifftestMacros.v')
    result=dict(format='fourstate-batch-selection-v1',ledger=ledger,
                files=[{k:inv[n][k] for k in ('name','bytes','sha256')} for n in sorted(needed)],
                source_facts_sha256=hashlib.sha256(facts.read_bytes()).hexdigest(),
                limits=dict(max_closure_files=16,max_closure_bytes=128*1024,total_seconds=1200,total_output_bytes=512*1024**2),
                global_definitions=len(modules),global_instances=sum(counts.values()))
    write(out,result);return result


def aggregate(selection,result_files,out,facts=None):
    """A full definition ledger: preserve skips and never infer behavior PASS."""
    from collections import defaultdict
    import gzip
    selection=json.loads(Path(selection).read_text());by_name={};allowed_inputs={}
    for path in result_files:
        data=json.loads(Path(path).read_text())
        plan=Path(path).parent/'plan.json'
        if plan.exists():
            for request in json.loads(plan.read_text()).get('modules',[]):allowed_inputs.update(request.get('input_hashes',{}))
        for row in data['results']:
            item=dict(row);item['result_receipt']=str(Path(path).resolve());by_name[row['module']]=item
    definitions={}
    if facts:
        p=Path(facts);definitions={m['file']:m for m in json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())}
    rows=[];groups=defaultdict(list)
    for source in selection['ledger']:
        row=dict(source)
        if source['selection']!='ELIGIBLE':
            row.update(status=source['selection'],stages={s:'NOT_RUN' for s in STAGES})
        elif source['module'] not in by_name:
            row.update(status='NOT_ATTEMPTED_WITHIN_BUDGET',stages={s:'NOT_RUN' for s in STAGES})
        else:
            result=by_name[source['module']];row.update(result)
            if row.get('error'):
                if row.get('status')=='REJECTED':row['category']=category(row['error'])
                import re
                match=re.match(r'^(.*?):(\d+):(\d+):',row['error'])
                if match:
                    file,line,column=match.groups();p=Path(file)
                    # Only paths named by actual worker requests are accepted.
                    # Diagnostics remain data; no arbitrary diagnostic path is read.
                    if file in allowed_inputs:
                        from fourstate_preprocess import stable_bytes
                        data=stable_bytes(p)
                        if hashlib.sha256(data).hexdigest()!=allowed_inputs[file]:raise ValueError('Diagnostic source hash mismatch: '+file)
                        text=data.decode('utf8').splitlines()[int(line)-1]
                        row['first_source']=dict(file=file,line=int(line),column=int(column),text=text)
                        definition=definitions.get(p.name,{})
                        memories=definition.get('memories',[])
                        names=[m.get('name') for m in memories if isinstance(m,dict)]
                        if row.get('category')=='fixed_vector_requirement' and any(n and text[int(column)-1:].startswith(n) for n in names):
                            row['category']='unpacked_memory_declaration'
                            row['classification_evidence']='Typed Variable diagnostic at an audited memory declaration identifier'
            if row.get('status')!='COMPLETED':groups[row.get('category','unknown')].append(row)
        rows.append(row)
    summary=dict(status='F44_LEDGER_COMPLETED',scope='All definitions accounted for; only selected resource-bounded closures executed. Instance weights are potential occurrence counts, not per-instance verification.',
                 definitions=len(rows),known_xstop_instances=selection['global_instances'],
                 attempted=sum('result_receipt' in r for r in rows),
                 statuses={s:sum(r['status']==s for r in rows) for s in sorted({r['status'] for r in rows})},
                 stages={s:dict(definitions=sum(r['stages'][s]=='PASS' for r in rows),weighted_instances=sum(r['instances'] for r in rows if r['stages'][s]=='PASS')) for s in STAGES},
                 gaps=[dict(category=name,definitions=len(items),weighted_instances=sum(r['instances'] for r in items),
                            representative=dict(module=items[0]['module'],error=items[0].get('error'),source=items[0].get('first_source')))
                       for name,items in sorted(groups.items(),key=lambda x:(-sum(r['instances'] for r in x[1]),-len(x[1])))],results=rows)
    executed=[r['execution'] for r in rows if 'execution' in r]
    summary['resources']=dict(peak_job_committed_bytes=max((r['peak_job_committed_bytes'] for r in executed),default=0),
                              max_worker_seconds=max((r['seconds'] for r in executed),default=0),
                              measured_output_bytes=sum(r['output_bytes'] for r in executed),
                              measurement='Actual Job Object committed-memory high water mark; actual worker time/output, not RSS')
    out=Path(out);out.mkdir(parents=True,exist_ok=False);write(out/'summary.json',summary)
    fields=['module','instances','selection','status','category','source_sha256','error',*STAGES]
    with (out/'gaps.csv').open('w',encoding='utf8',newline='') as f:
        w=csv.DictWriter(f,fields);w.writeheader()
        for r in rows:w.writerow({**{k:r.get(k,'') for k in fields if k not in STAGES},**r['stages']})
    return summary


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('action',choices=['worker','run','select','aggregate']);p.add_argument('--request',type=Path);p.add_argument('--plan',type=Path);p.add_argument('--out',type=Path,required=True)
    p.add_argument('--facts',type=Path);p.add_argument('--inventory',type=Path);p.add_argument('--hierarchy',type=Path)
    p.add_argument('--result',type=Path,action='append',default=[])
    a=p.parse_args()
    if a.action=='worker':return worker(json.loads(a.request.read_text()),a.out)
    if a.action=='select':
        r=select_modules(a.facts,a.inventory,a.hierarchy,a.out)
        print(json.dumps(dict(definitions=r['global_definitions'],eligible=sum(x['selection']=='ELIGIBLE' for x in r['ledger']),files=len(r['files']))));return 0
    if a.action=='aggregate':
        r=aggregate(a.plan,a.result,a.out,a.facts)
        print(json.dumps(dict(status=r['status'],definitions=r['definitions'],attempted=r['attempted'],stages=r['stages'])));return 0
    r=campaign(a.plan,a.out);print(json.dumps(dict(status=r['status'],attempted=r['attempted'],stages=r['stages'])));return 0 if r['status']=='BATCH_COMPLETED' else 1


if __name__=='__main__':raise SystemExit(main())
