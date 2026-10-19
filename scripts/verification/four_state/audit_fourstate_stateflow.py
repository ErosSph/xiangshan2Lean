"""Bound-AST XSTop storage ownership inventory; explicitly not semantic IR."""
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

from pathlib import Path
from collections import Counter,defaultdict
import gzip,json,time

def inventory(request,out):
    from verify_fourstate_f53 import write
    import fourstate_preprocess as pp
    from fourstate_preprocess import location
    source=Path(request['input_run'])/'reports/inputs'
    receipt=json.loads((Path(request['run'])/'reports/input-receipt.json').read_bytes())
    pp.MAX_FILES=len(receipt['files']);pp.MAX_BYTES=sum(r['bytes'] for r in receipt['files'])
    started=time.monotonic();s,sm,trees,files=pp.parse_sources(source,report={})
    opts=s.ast.CompilationOptions();opts.topModules={'XSTop'};opts.maxInstanceDepth=128;opts.maxGenerateSteps=65536
    comp=s.ast.Compilation(s.Bag([opts]))
    for tree in trees:comp.addSyntaxTree(tree)
    root=comp.getRoot();diags=comp.getAllDiagnostics()
    if any(d.isError() for d in diags):raise ValueError(s.DiagnosticEngine.reportAll(sm,diags))
    def kind(n):return str(n.kind).split('.')[-1]
    def loc(n):
        p=n.sourceRange.start if hasattr(n,'sourceRange') else n.location
        v=location(sm,p);v['file']=Path(v['file']).name;return v
    def expr(e,prefix):
        if e is None:return dict(form='unconnected')
        while kind(e)=='Conversion' and e.isImplicit and e.type.bitWidth==e.operand.type.bitWidth:e=e.operand
        k=kind(e)
        if k=='NamedValue':return dict(form='ref',name=prefix+'.'+e.symbol.name)
        if k=='HierarchicalValue':return dict(form='expression',kind=k,bound_target=e.symbol.hierarchicalPath,source=loc(e))
        if k=='UnaryOp':return dict(form=str(e.op).split('.')[-1],arg=expr(e.operand,prefix))
        if k=='BinaryOp':return dict(form=str(e.op).split('.')[-1],args=[expr(e.left,prefix),expr(e.right,prefix)])
        return dict(form='expression',kind=k,source=loc(e))
    def triggers(t,prefix):
        if kind(t)=='EventList':return [v for e in t.events for v in triggers(e,prefix)]
        if kind(t)=='SignalEvent':return [dict(edge=str(t.edge).split('.')[-1],expression=expr(t.expr,prefix),source=loc(t))]
        return [dict(edge='unsupported',source=loc(t))]
    drivers=defaultdict(list);latches={};processes=[];objects=[];instances=[];counts=Counter();template={};top_inputs=set()
    def visit(inst):
        prefix=inst.hierarchicalPath;module=inst.definition.name;instances.append(dict(path=prefix,module=module));counts[module]+=1
        vars={n.name:n for n in inst.body if kind(n) in ('Variable','Net')};writers=defaultdict(list)
        for n in inst.body:
            if kind(n)=='Net' and n.initializer is not None:drivers[prefix+'.'+n.name].append(dict(expression=expr(n.initializer,prefix),source=loc(n)))
            if kind(n)=='ContinuousAssign':
                left=expr(n.assignment.left,prefix)
                if left['form']=='ref':drivers[left['name']].append(dict(expression=expr(n.assignment.right,prefix),source=loc(n)))
            if kind(n)!='ProceduralBlock':continue
            pid=prefix+'@'+str(len(processes));body=n.body
            event=triggers(body.timing,prefix) if kind(body)=='Timed' else []
            statement=body.stmt if kind(body)=='Timed' else body
            reset=None;first=statement
            while kind(first)=='Block':first=first.body
            if kind(first)=='Conditional':
                c=first.conditions[0].expr if len(first.conditions)==1 else None
                if c is not None and kind(c)=='NamedValue' and len(event)>1:reset=prefix+'.'+c.symbol.name
            proc=dict(id=pid,instance=prefix,module=module,kind=str(n.procedureKind).split('.')[-1],source=loc(n),triggers=event,reset_signal=reset,objects=[])
            assigned=set()
            def assignment(e):
                if kind(e)!='Assignment':return
                v=e.left
                while kind(v) in ('Conversion','ElementSelect','RangeSelect','MemberAccess'):v=v.operand if kind(v)=='Conversion' else v.value
                if kind(v)=='NamedValue' and v.symbol.name in vars and v.symbol==vars[v.symbol.name]:assigned.add(v.symbol.name)
            statement.visit(assignment)
            for name in sorted(assigned):writers[name].append(pid);proc['objects'].append(prefix+'.'+name)
            if proc['kind']=='AlwaysLatch' and kind(first)=='Conditional' and len(first.conditions)==1:
                guard=expr(first.conditions[0].expr,prefix)
                proc['latch_guard']=guard
                if guard['form']=='LogicalNot' and len(assigned)==1:latches[prefix+'.'+next(iter(assigned))]=guard['arg']
            processes.append(proc)
        for name,n in vars.items():
            t=n.type;shape=[]
            while t.isUnpackedArray:
                r=t.fixedRange;shape.append(dict(left=r.left,right=r.right));t=t.elementType
            if not shape and (kind(n)!='Variable' or name not in writers):continue
            depth=1
            for a in shape:depth*=abs(a['left']-a['right'])+1
            objects.append(dict(name=prefix+'.'+name,module=module,kind='memory' if shape else 'scalar',shape=shape,width=t.bitWidth,
                bits=depth*t.bitWidth,writers=writers[name],source=loc(n)))
        for p in inst.body.portList:
            if prefix=='XSTop' and str(p.direction).endswith('.In'):top_inputs.add(prefix+'.'+p.name)
        for child in inst.body:
            if kind(child)!='Instance':continue
            for c in child.portConnections:
                formal=child.hierarchicalPath+'.'+c.port.name;actual=c.expression
                if str(c.port.direction).endswith('.In'):drivers[formal].append(dict(expression=expr(actual,prefix),source=loc(child)))
                elif actual is not None and kind(actual)=='Assignment':
                    target=expr(actual.left,prefix)
                    if target['form']=='ref':drivers[target['name']].append(dict(expression=dict(form='ref',name=formal),source=loc(child)))
            visit(child)
    visit(root.topInstances[0]);memo={}
    def resolve_expression(e,active):
        if e['form']=='ref':return resolve(e['name'],active)
        if e['form'] in ('BitwiseNot','LogicalNot'):
            a=resolve_expression(e['arg'],active)
            if a['status']=='resolved':return dict(status='resolved',form='inverted',root=a['root'],path=a.get('path',[]),base=a)
        if e['form']=='BinaryAnd':
            for a,b in (e['args'],list(reversed(e['args']))):
                x=resolve_expression(a,active)
                if b.get('name') in latches:
                    y=resolve_expression(latches[b['name']],active)
                    if x['status']==y['status']=='resolved' and x['root']==y['root']:
                        return dict(status='resolved',form='structural_latched_and',root=x['root'],latch=b['name'],path=x.get('path',[]))
        return dict(status='unresolved',reason='non-admitted expression or state-derived source',expression=e)
    def resolve(name,active=()):
        if name in memo:return memo[name]
        if name in active:return dict(status='unresolved',reason='alias cycle',signal=name)
        if name in top_inputs:return dict(status='resolved',form='direct',root=name,path=[name])
        ds=drivers[name]
        if len(ds)!=1:return dict(status='unresolved',reason='driver count '+str(len(ds)),signal=name)
        result=resolve_expression(ds[0]['expression'],(*active,name))
        if result['status']=='resolved':result=dict(result,path=[name,*result.get('path',[])])
        memo[name]=result;return result
    bypid={p['id']:p for p in processes};sources=Counter();roots=Counter()
    for p in processes:
        if p.get('latch_guard'):
            guard=p['latch_guard'];p['latch_attribution']=resolve_expression(guard.get('arg',guard),())
        for t in p['triggers']:
            e=t.get('expression',{});t['role']='reset' if e.get('name')==p['reset_signal'] else 'clock'
            t['attribution']=resolve_expression(e,());sources[(t['role'],t['attribution']['status'],t['attribution'].get('form',t['attribution'].get('reason')))]+=1
            if t['attribution']['status']=='resolved':roots[(t['role'],t['attribution']['root'])]+=1
    for obj in objects:
        obj['ownership']='single_writer' if len(obj['writers'])==1 else 'no_writer' if not obj['writers'] else 'multiple_writers'
        obj['process_triggers']=[bypid[w]['triggers'] for w in obj['writers']]
    summary=dict(scope='Full bound storage/trigger inventory, not semantic conversion or clock-domain proof',instances=len(instances),definitions=len(counts),
        scalars=sum(o['kind']=='scalar' for o in objects),scalar_bits=sum(o['bits'] for o in objects if o['kind']=='scalar'),
        memories=sum(o['kind']=='memory' for o in objects),memory_bits=sum(o['bits'] for o in objects if o['kind']=='memory'),processes=len(processes),
        ownership=dict(Counter(o['ownership'] for o in objects)),trigger_attribution=[dict(role=k[0],status=k[1],form_or_reason=k[2],count=v) for k,v in sorted(sources.items())],
        roots=[dict(role=k[0],root=k[1],endpoints=v) for k,v in sorted(roots.items())],seconds=time.monotonic()-started,diagnostic_count=len(diags))
    with gzip.open(out/'ownership.json.gz','xt',encoding='utf8') as f:json.dump(dict(summary=summary,objects=objects,processes=processes,instances=instances,drivers=dict(drivers)),f,separators=(',',':'))
    write(out/'inventory-summary.json',summary)
    if (summary['scalars'],summary['scalar_bits'],summary['memories'],summary['memory_bits'],summary['processes'])!=(152643,807990,920,64313918,4417):raise ValueError('F52 inventory parity differs; inspect actual counts')
    return summary
