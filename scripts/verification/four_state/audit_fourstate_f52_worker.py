"""F5.2 diagnostic worker; imports the unchanged private converter only."""
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
from collections import Counter
import gzip
import hashlib
import json
import os
from pathlib import Path
import resource
import socket
import sys
import time
import traceback


def write(path, value):
    with Path(path).open('x',encoding='utf8') as stream:
        json.dump(value,stream,ensure_ascii=True,indent=2);stream.write('\n')


def kind(n):return str(n.kind).split('.')[-1]


def setup(run):
    """Only the parser loader is adapted to the separately pinned Linux wheel."""
    runtime=json.loads((run/'reports/environment/runtime.json').read_bytes())
    runtime_root=run.parents[1]/runtime['base']
    for row in runtime['files']:
        if row['path'].startswith('site/'):
            p=runtime_root/row['path']
            if p.is_symlink() or hashlib.sha256(p.read_bytes()).hexdigest()!=row['sha256']:
                raise ValueError('parser runtime file changed: '+str(p))
    sys.path.insert(0,str(runtime_root/'site'))
    import pyslang
    if pyslang.__version__!='12.0.0':raise ValueError('pinned parser version mismatch')
    import bootstrap_fourstate
    bootstrap_fourstate.load_parser=lambda:pyslang
    return pyslang


def closure(modules, name):
    result=set();todo=[name]
    while todo:
        n=todo.pop()
        if n in result:continue
        result.add(n);todo.extend(i['module'] for i in modules[n]['instances'])
    return result


def profile(modules, name):
    """Static routing only proposes options; the unchanged importer adjudicates."""
    root=modules[name];inputs={p['name'] for p in root['ports'] if p['direction']=='input'}
    roots=set();unknown=[];seen=set();features=Counter();processes=0
    def descend(n,bindings):
        nonlocal processes
        key=n,tuple(sorted(bindings.items()))
        if key in seen:return
        seen.add(key);m=modules[n];features.update(m['features'])
        aliases={a['target']:a['source'] for a in m['aliases']}
        def resolve(e):
            chain=set()
            while e not in bindings and e in aliases and e not in chain:
                chain.add(e);e=aliases[e]
            return bindings.get(e)
        for p in m['processes']:
            processes+=1
            for e in p['clock_events']:
                v=resolve(e['expr'])
                if v:roots.add(v)
                else:unknown.append(dict(module=n,expression=e['expr']))
        for i in m['instances']:
            b={}
            for c in i['bindings']:
                if c.get('formal') and c.get('expr_kind')=='IdentifierName':
                    v=resolve(c['expr'])
                    if v:b[c['formal']]=v
            descend(i['module'],b)
    descend(name,{n:n for n in inputs})
    latch=bool(features.get('always_latch'))
    clock=('CK' if name=='ClockGate' else 'clock' if 'clock' in inputs else sorted(roots)[0] if roots else
           next((n for n in ('W0_clk','RW0_clk','clk','CK') if n in inputs),None))
    sequential=processes>0
    options=dict(mode='sequential' if sequential else 'combinational',clock=clock if sequential else None)
    memory=bool(features.get('unpacked_array'))
    event=bool(features.get('multi_event_process') or latch or len(roots)>1 or features.get('immediate_assert') or unknown)
    # No memory/event combination, hidden expansion or limit relaxation.
    if memory:options['bounded_memories']=True
    elif event and clock:
        event_roots=sorted(roots|{clock})
        if 1<=len(event_roots)<=2:
            options.update(bounded_events=True,event_clocks=event_roots,immediate_assertions=True)
    return options,dict(clock_roots=sorted(roots),unresolved_clock_bindings=unknown,memory=memory,event=event,
                        static_processes=processes,closure_features=dict(features))


def diagnostic(error):
    import re
    text=str(error);m=re.match(r'^(.*?):(\d+):(\d+): (.*)',text,re.S)
    message=m.group(4) if m else text
    rules=[('memory_event_composition',('binary single-clock mode','no memory opt-in')),
           ('memory_capacity',('bounded memory budget',)),('memory_shape',('one-dimensional','simple packed four-state element')),
           ('memory_declaration',('fixed four-state packed vector required',)),
           ('event_capacity',('bounded event budget','monitor budget')),
           ('event_clock_reset',('event','clock','async','latch')),
           ('open_port',('every input/output must be connected',)),('standalone_no_output',('at least one top output',)),
           ('packed_declaration',('packed dimensions','packed vector','declaration')),
           ('process_scope',('process local','blocking assignment','clocked statement','procedural block')),
           ('expression',('expression','selection','syntax'))]
    result=dict(category=next((c for c,words in rules if any(w in message for w in words)),'other'),message=message)
    if m:result.update(file=m.group(1),line=int(m.group(2)),column=int(m.group(3)))
    return result


def typed_inventory(s,sm,root,modules,out):
    definitions={};instances=[]
    def loc(n):
        pos=n.location
        return dict(file=Path(str(sm.getFullPath(pos.buffer))).name,line=sm.getLineNumber(pos),column=sm.getColumnNumber(pos))
    def visit(inst):
        name=inst.definition.name;instances.append(dict(path=inst.hierarchicalPath,module=name))
        if name not in definitions:
            scalars=[];memories=[];ports=[];assigned=set();nba=set();processes=[]
            def assignment(n):
                if kind(n)!='Assignment':return
                left=n.left
                while kind(left) in ('Conversion','ElementSelect','RangeSelect','MemberAccess'):
                    left=left.operand if kind(left)=='Conversion' else left.value
                if kind(left)=='NamedValue':
                    assigned.add(left.symbol.name)
                    if n.isNonBlocking:nba.add(left.symbol.name)
            for n in inst.body:
                if kind(n)=='ProceduralBlock':
                    n.body.visit(assignment);processes.append(dict(kind=str(n.procedureKind),source=loc(n)))
            for n in inst.body:
                if kind(n) in ('Variable','Net'):
                    t=n.type
                    if t.isUnpackedArray:
                        shape=[]
                        while t.isUnpackedArray:
                            r=t.fixedRange;shape.append(dict(left=r.left,right=r.right,words=abs(r.left-r.right)+1));t=t.elementType
                        words=1
                        for d in shape:words*=d['words']
                        memories.append(dict(name=n.name,shape=shape,element_bits=t.bitWidth,bits=words*t.bitWidth,
                                             assigned=n.name in assigned,nba=n.name in nba,source=loc(n)))
                    elif kind(n)=='Variable' and n.name in assigned:
                        scalars.append(dict(name=n.name,width=t.bitWidth,nba=n.name in nba,source=loc(n)))
            for p in inst.body.portList:ports.append(dict(name=p.name,width=p.type.bitWidth,direction=str(p.direction)))
            definitions[name]=dict(module=name,scalars=scalars,memories=memories,processes=processes,ports=ports,
                                   scalar_state_bits=sum(x['width'] for x in scalars),memory_bits=sum(x['bits'] for x in memories),
                                   note='Module-scope assignment targets; process locals excluded; no synthesized-cell claim')
        for n in inst.body:
            if kind(n)=='Instance':visit(n)
    visit(root.topInstances[0]);counts=Counter(r['module'] for r in instances)
    result=dict(definitions=definitions,instances=instances,module_counts=dict(counts),
                scalar_state_bits=sum(counts[n]*v['scalar_state_bits'] for n,v in definitions.items()),
                memory_bits=sum(counts[n]*v['memory_bits'] for n,v in definitions.items()),
                scalar_state_variables=sum(counts[n]*len(v['scalars']) for n,v in definitions.items()),
                memory_arrays=sum(counts[n]*len(v['memories']) for n,v in definitions.items()),
                processes=sum(counts[n]*len(v['processes']) for n,v in definitions.items()))
    write(out/'typed-inventory.json',result);return result


def run(request,out):
    run=Path(request['run']);s=setup(run);source=run/'reports/inputs'
    receipt=json.loads((run/'reports/input-receipt.json').read_bytes());hashes={r['name']:r['sha256'] for r in receipt['files']}
    def verify():
        for name,expected in hashes.items():
            p=source/name
            if p.is_symlink() or hashlib.sha256(p.read_bytes()).hexdigest()!=expected:raise ValueError('input changed: '+name)
    verify()
    modules={m['name']:m for m in json.loads(gzip.decompress((run/'reports/frozen/modules-v3.json.gz').read_bytes()))}
    import fourstate_preprocess as pp
    from fourstate_frontend import parse
    from fourstate_encode import encode
    stages=[];start=time.monotonic()
    try:
        parse(source,'XSTop',mode='sequential',clock='io_clock',preprocessing={})
        raise AssertionError('Expected unchanged default file-admission gate')
    except ValueError as error:stages.append(dict(stage='native_full_entry',status='REJECTED',error=str(error),seconds=time.monotonic()-start))
    # Diagnostic-only admission of the exact, separately verified finite corpus.
    # Does not change expressions, event/memory semantics, limits, or RTL bytes.
    pp.MAX_FILES=len(hashes);pp.MAX_BYTES=sum(r['bytes'] for r in receipt['files'])
    preprocessed={};beg=time.monotonic();s,sm,trees,files=pp.parse_sources(source,report=preprocessed)
    preprocessed['active_units']=[dict(root=u['root'],bytes=len(u['text'].encode()),sha256=hashlib.sha256(u['text'].encode()).hexdigest()) for u in preprocessed['active_units']]
    preprocessed['active_units_storage']='Hashes and byte counts; original source and parser version retained separately'
    write(out/'preprocessing.json',preprocessed)
    stages.append(dict(stage='verified_corpus_preprocess',status='PASS',seconds=time.monotonic()-beg,files=len(files),bytes=pp.MAX_BYTES))
    opts=s.ast.CompilationOptions();opts.topModules={'XSTop'};opts.maxInstanceDepth=128;opts.maxGenerateSteps=65536
    beg=time.monotonic();comp=s.ast.Compilation(s.Bag([opts]))
    for t in trees:comp.addSyntaxTree(t)
    root=comp.getRoot();diags=comp.getAllDiagnostics();errors=[d for d in diags if d.isError()]
    if errors:raise ValueError(s.DiagnosticEngine.reportAll(sm,diags))
    write(out/'binding-diagnostics.json',dict(errors=0,diagnostics=len(diags),text=s.DiagnosticEngine.reportAll(sm,diags)))
    stages.append(dict(stage='full_typed_binding',status='PASS',seconds=time.monotonic()-beg,diagnostics=len(diags)))
    inv=typed_inventory(s,sm,root,modules,out)
    stages.append(dict(stage='full_typed_inventory',status='PASS',definitions=len(inv['definitions']),instances=len(inv['instances'])))
    del inv,root,comp
    # Reuse immutable official syntax trees; binding and conversion remain fresh
    # per requested top. No frozen FunctionalIR or previous conversion is read.
    roots=[Path(p) for p in preprocessed['roots']]
    if len(roots)!=len(trees):raise ValueError('syntax cache root/tree count differs')
    tree_map={p.name:t for p,t in zip(roots,trees)};file_map={p.name:p for p in roots};active={'names':set(file_map)}
    def cached(source,defines=(),include_dirs=(),report=None):
        if defines or include_dirs:raise ValueError('cache permits only the frozen default macro profile')
        names=sorted(active['names']);selected=[file_map[n] for n in names]
        if report is not None:report.update(status='PREPROCESSED',source='SHA256-verified immutable syntax cache',roots=[str(p) for p in selected],
            directives=[d for d in preprocessed['directives'] if Path(d['compilation_unit']).name in names],
            files=[r for r in preprocessed['files'] if Path(r['path']).name in names],
            cache_evidence=str(out/'preprocessing.json'))
        return s,sm,[tree_map[n] for n in names],selected
    original_parse_sources=pp.parse_sources;pp.parse_sources=cached
    write(out/'stages.json',stages)
    def attempt(name,label,options,names):
        active['names']=set(names);case=out/label;case.mkdir();beg=time.monotonic();pp_report={}
        result=dict(module=name,options=options,files=sorted(names),fourstate_ir=False,encoded_rtl=False,semantic_verification='NOT_RUN',
                    functional_ir='NOT_RUN',lean='NOT_RUN',scope='Complete selected dependency hierarchy, unchanged importer/encoder')
        def progress(frame,event,arg):
            if not frame.f_code.co_filename.endswith('fourstate_elaborated.py'):return None
            frame.f_trace_lines=False
            if event=='exception' and frame.f_code.co_name in ('collect','parse') and frame.f_code.co_filename.endswith('fourstate_elaborated.py'):
                for key in ('signals','processes','memories','ir_nodes','hierarchy'):
                    value=frame.f_locals.get(key)
                    if value is not None:
                        result.setdefault('partial',{})[key]=len(value.get('instances',[])) if key=='hierarchy' else len(value)
            return progress
        try:
            sys.settrace(progress)
            ir=parse(source,name,preprocessing=pp_report,**options)
            sys.settrace(None);result['fourstate_ir']=True
            write(case/'fourstate.ir.json',ir);result.update(nodes=len(ir['nodes']),state_bits=sum(v['width'] for v in ir.get('states',[])),
                 states=len(ir.get('states',[])),memories=len(ir.get('memories',[])),processes=len(ir.get('events',{}).get('processes',[])))
            rtl,mapping=encode(ir)
            with (case/'encoded.sv').open('x',encoding='utf8') as stream:stream.write(rtl)
            write(case/'ports.json',mapping);result.update(encoded_rtl=True,encoded_bytes=len(rtl.encode()),ir_bytes=(case/'fourstate.ir.json').stat().st_size,status='ENCODED')
        except Exception as error:
            sys.settrace(None);result.update(status='REJECTED' if isinstance(error,ValueError) else 'TOOL_FAILURE',error=str(error),diagnostic=diagnostic(error),traceback=traceback.format_exc())
        finally:sys.settrace(None)
        result.update(seconds=time.monotonic()-beg,peak_rss_bytes=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss*1024)
        write(case/'result.json',result);return result
    results=[]
    whole=[('full-default',dict(mode='sequential',clock='io_clock')),
           ('full-memory',dict(mode='sequential',clock='io_clock',bounded_memories=True)),
           ('full-events',dict(mode='sequential',clock='io_clock',bounded_events=True,event_clocks=['io_clock','io_systemjtag_jtag_TCK'],immediate_assertions=True))]
    for label,options in ([] if request.get('modules') else whole):
        # Root spelling is obtained from actual bound top ports below if needed.
        if label=='full-events':
            top_inputs={p['name'] for p in modules['XSTop']['ports'] if p['direction']=='input'}
            jtag=next((n for n in sorted(top_inputs) if n.lower().endswith('tck')),None)
            options['event_clocks']=['io_clock']+([jtag] if jtag and jtag!='io_clock' else [])
        results.append(attempt('XSTop',label,options,set(file_map)))
    write(out/'whole-results.json',results)
    batch=[]
    old_ledger={r['module']:r for r in json.loads((run/'reports/frozen/f44-ledger.json').read_bytes())['results']}
    for i,name in enumerate(sorted(request.get('modules') or modules)):
        types=closure(modules,name);names={modules[n]['file'] for n in types}
        options,static=profile(modules,name)
        r=attempt(name,'m'+format(i,'04d'),options,names)
        old=old_ledger[name]
        legacy={k:old[k] for k in ('mode','clock','async_reset') if k in old}
        if r['status']=='REJECTED' and old.get('status')=='COMPLETED' and legacy and legacy!=options:
            fallback=attempt(name,'legacy-m'+format(i,'04d'),legacy,names)
            fallback['primary_attempt']=r
            r=fallback
        r['static_profile']=static;r['closure_types']=len(types)
        r['artifact_directory']=('legacy-m' if 'primary_attempt' in r else 'm')+format(i,'04d')
        r['artifact_root']=out.name
        r['own_definition_only']=len(types)==1
        batch.append(r)
        if i%25==0:print(json.dumps(dict(definitions=i+1,last=name,seconds=time.monotonic()-start)),flush=True)
    write(out/'batch-results.json',batch)
    controls=[];byname={r['module']:r for r in batch}
    for name in (() if request.get('modules') else ('AMOALU','ram_2x75','ClockGate','JtagTapController','TLClientsMerger')):
        selected=byname[name];names=selected['files'];rawdir=out/('fresh-input-'+name);rawdir.mkdir()
        for n in set(names)|({'DifftestMacros.v'} if 'DifftestMacros.v' in hashes else set()):
            (rawdir/n).write_bytes((source/n).read_bytes())
        old_source=source;source=rawdir;pp.parse_sources=original_parse_sources
        try:fresh=attempt(name,'fresh-'+name,selected['options'],names)
        finally:source=old_source;pp.parse_sources=cached
        same=selected['status']==fresh['status'] and fresh['status'] in ('ENCODED','REJECTED')
        if same and fresh['encoded_rtl']:
            cached_dir=out/selected['artifact_directory']
            same=(cached_dir/'encoded.sv').read_bytes()==(out/('fresh-'+name)/'encoded.sv').read_bytes()
        elif same:
            same=selected.get('diagnostic',{}).get('message')==fresh.get('diagnostic',{}).get('message')
        controls.append(dict(module=name,status='PASS' if same else 'FAIL',cached=selected['status'],fresh=fresh['status'],
                             scope='Fresh source preprocessing/binding versus cached immutable syntax; exact encoded RTL or exact diagnostic message'))
    write(out/'cache-controls.json',controls)
    if any(r['status']!='PASS' for r in controls):raise ValueError('syntax cache parity failure')
    verify()
    write(out/'worker-summary.json',dict(status='PROBE_FINISHED',hostname=socket.gethostname(),python=sys.version,pyslang=s.__version__,
          seconds=time.monotonic()-start,peak_rss_bytes=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss*1024,
          whole=results,definitions=len(batch),encoded=sum(r['encoded_rtl'] for r in batch),
          rejected=sum(r['status']=='REJECTED' for r in batch),tool_failures=sum(r['status']=='TOOL_FAILURE' for r in batch),
          parser_cache='Immutable default-profile syntax reused; each top freshly bound/imported/encoded',
          source_inputs_after='ALL_SHA256_MATCH',semantic_changes=False,behavioral_verification='NOT_RUN'))


def focused_tests(run,out):
    import unittest
    import importlib
    setup(run);snapshot=Path(__file__).resolve().parents[2];manifest=json.loads((snapshot/'manifest.json').read_bytes())
    project=out/'project';project.mkdir()
    for row in manifest['files']:
        source=snapshot/'src'/row['path'];target=project/row['path'];target.parent.mkdir(parents=True,exist_ok=True)
        data=source.read_bytes()
        if hashlib.sha256(data).hexdigest()!=row['sha256']:raise ValueError('test source snapshot changed')
        target.write_bytes(data)
    (project/'.cache').mkdir();sys.path.insert(0,str(project/'scripts'));sys.path.insert(0,str(project/'tests'))
    names=['test_fourstate_conditional','test_fourstate_memory','test_fourstate_bounded_events','test_fourstate_reset_alias','test_fourstate_assertions']
    excluded={'test_linux_helper_is_python38_and_has_bounded_fixed_commands','test_linux_helper_uses_existing_reviewed_transport','test_private_lean_compile_uses_system_threads'}
    suite=unittest.TestSuite()
    for name in names:
        module=importlib.import_module(name)
        for group in unittest.defaultTestLoader.loadTestsFromModule(module):
            for test in group:
                if test._testMethodName not in excluded:suite.addTest(test)
    result=unittest.TextTestRunner(verbosity=2).run(suite)
    write(out/'tests.json',dict(status='PASS' if result.wasSuccessful() else 'FAIL',tests=result.testsRun,
          failures=[str(t) for t,e in result.failures],errors=[dict(test=str(t),traceback=e) for t,e in result.errors],
          scope='Focused F45/F46/F47a/F51/F51a semantic/boundary unit tests on the pinned Linux parser; no simulator or Lean invocation',
          excluded_transport_or_mock_backend_tests=sorted(excluded)))
    if not result.wasSuccessful():raise ValueError('focused Linux unit regression failed')


def main():
    os.umask(0o077)
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--request',type=Path,required=True);p.add_argument('--out',type=Path,required=True);p.add_argument('--tests',action='store_true')
    a=p.parse_args();a.out.mkdir(exist_ok=False);request=json.loads(a.request.read_bytes())
    try:
        if a.tests:focused_tests(Path(request['run']),a.out)
        else:run(request,a.out)
    except Exception as error:
        write(a.out/'failure.json',dict(error=str(error),traceback=traceback.format_exc()));raise


if __name__=='__main__':main()
