"""F5.1a fresh translations, immutable frozen corpora, and IEEE conditional checks."""
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
import itertools
import json
from pathlib import Path
import re
import shutil
import time
from fourstate2lean import translate, write, digest
from fourstate_simulate import load
from fourstate_bounded_events import runner_source, validate_trace
from verify_fourstate_clocks import benches, parse_rtl
from verify_fourstate_structures import modelsim_worker

ROOT = _PROJECT_ROOT


def read(p):
    return json.loads(Path(p).read_text(encoding='utf8'))


def regenerate(manifest, out):
    """Re-enter RTL, encoder, Yosys FunctionalIR and Lean emission/compilation."""
    manifest = Path(manifest)
    old = read(manifest.parent/'fourstate.ir.json')
    pp = old.get('preprocessing', {})
    caps = old.get('capabilities', [])
    options = dict(defines=pp.get('predefines', []), include_dirs=pp.get('include_dirs', []),
                   bounded_memories='unpacked_memory' in caps,
                   immediate_assertions='immediate_assertions' in caps)
    if 'bounded_events' in caps:
        options.update(bounded_events=True, event_clocks=old['events']['roots'])
    elif 'async_posedge' in caps:
        options['async_reset'] = old['events']['reset']
    start = time.monotonic()
    result = translate(Path(old['source']), old['top'], Path(out), old.get('mode','combinational'), old.get('clock'), **options)
    write(Path(out).parent/'regeneration.json', dict(old_manifest=str(manifest), new_manifest=str(result),
          seconds=time.monotonic()-start, old_encoded_sha256=digest(manifest.parent/'encoded.sv'),
          new_encoded_sha256=digest(result.parent/'encoded.sv'),
          scope='fresh RTL -> private four-state IR -> encoded RTL -> FunctionalIR -> Lean'))
    return result


def prepare_event(manifest, frozen, folder):
    frozen, folder = Path(frozen), Path(folder)
    folder.mkdir(parents=True, exist_ok=False)
    new = regenerate(manifest, folder/'translation')
    mapping, model = load(new)
    assert mapping == read(frozen/'ports.json'), 'Frozen interface changed'
    assets = folder/'assets';assets.mkdir()
    oldplan = read(frozen/'plan.json')
    names = ['trace.json', 'initials.json', 'deposit4.c', *oldplan['original_sources']]
    for n in names:
        shutil.copyfile(frozen/n, assets/n)
    originals = {r['sha256'] for r in read(new.parent/'sources.json')['files']}
    assert all(digest(assets/n) in originals for n in oldplan['original_sources'])
    for initial in read(assets/'initials.json'):
        validate_trace(mapping, read(assets/'trace.json'), initial)
    (assets/'ports.json').write_bytes((new.parent/'ports.json').read_bytes())
    (assets/'encoded.sv').write_bytes((new.parent/'encoded.sv').read_bytes())
    (assets/'RunEvents.lean').write_text(runner_source(read(model), mapping), encoding='utf8')
    (assets/'model/FourState').mkdir(parents=True)
    shutil.copyfile(model.with_name('Model.lean'), assets/'model/FourState/Model.lean')
    plan = dict(top=mapping['top'], source_manifest=str(new), original_sources=oldplan['original_sources'],
                compact_bench=True, regeneration='fresh', frozen_assets=str(frozen))
    refresh_plan(assets, plan)
    return assets


def refresh_plan(assets, plan):
    plan['files'] = [dict(path=p.relative_to(assets).as_posix(), bytes=p.stat().st_size, sha256=digest(p))
                     for p in sorted(assets.rglob('*')) if p.is_file() and p.name != 'plan.json']
    write(assets/'plan.json', plan)


def reference(assets, folder):
    """Uncapped fresh original ModelSim execution, including native diagnostics."""
    assets, folder = Path(assets), Path(folder)
    mapping = read(assets/'ports.json');trace = read(assets/'trace.json')
    plan = read(assets/'plan.json');receipts = []
    for i, initial in enumerate(read(assets/'initials.json')):
        f = folder/('initial-'+str(i));f.mkdir(parents=True, exist_ok=False)
        b = benches(mapping, trace, initial, compact=True)
        text = re.sub(r'\$fourstate_deposit\((dut\.[A-Za-z0-9_.$]+),([^;]+)\);', r'\1 = \2;', b['original'])
        assert '$fourstate_deposit' not in text
        (f/'tb.sv').write_text(text, encoding='utf8')
        config = dict(folder=str(f.absolute()), sources=[str((assets/n).absolute()) for n in plan['original_sources']])
        write(f/'config.json', config)
        start = time.monotonic();modelsim_worker(config)
        raw = (f/'execute/stdout.log').read_bytes()
        canonical=raw if mapping.get('assertions') else ('\n'.join(l.lstrip('# ') for l in raw.decode('ascii').splitlines()
            if re.match(r'^\d+ (?:pre|post) ',l.lstrip('# ')))+'\n').encode('ascii')
        parsed = parse_rtl(mapping, canonical.decode('ascii'), b['original_descriptors'], len(trace))
        name = 'reference-'+str(i)+'.log';(assets/name).write_bytes(canonical)
        receipts.append(dict(status='RAW_MODELSIM_PASS', file=name, sha256=digest(assets/name),
              samples=len(trace), seconds=time.monotonic()-start, resource_caps=None,
              assertion_failures=sum(len(r.get('assertions', [])) for r in parsed),
              sources=[dict(path=n,sha256=digest(assets/n)) for n in plan['original_sources']],
              bench_sha256=digest(f/'tb.sv'), raw_stdout_sha256=digest(f/'execute/stdout.log')))
    plan['windows_references'] = receipts;refresh_plan(assets, plan)
    return receipts


def standard_assets(top, folder):
    folder = Path(folder);folder.mkdir(parents=True, exist_ok=False)
    manifest = translate(ROOT/'verification/fourstate/operators/ConditionalIEEE.sv', top,
                         folder/'translation', 'sequential', 'clk', bounded_events=True)
    mapping, model = load(manifest);w = 1 if top.endswith('Scalar') else 2
    now = dict(clk='0',sel='0',a='0'*w,b='0'*w);trace = [dict(inputs=dict(now))]
    def setone(n,v):
        now[n]=v;trace.append(dict(inputs=dict(now)))
    words = [''.join(x) for x in itertools.product('01xz',repeat=w)]
    for c,a,b in itertools.product('01xz',words,words):
        setone('clk','0');setone('sel',c);setone('a',a);setone('b',b);setone('clk','1');setone('clk','1')
    for a,b in itertools.product('01xz',repeat=2):setone('clk',a);setone('clk',b)
    initials = [{s['name']:c*s['width'] for s in mapping['states']} for c in '01xz']
    assets = folder/'assets';(assets/'model/FourState').mkdir(parents=True)
    write(assets/'ports.json', mapping);write(assets/'trace.json', trace);write(assets/'initials.json', initials)
    shutil.copyfile(manifest.parent/'encoded.sv',assets/'encoded.sv')
    shutil.copyfile(model.with_name('Model.lean'),assets/'model/FourState/Model.lean')
    shutil.copyfile(ROOT/'verification/fourstate/deposit4.c',assets/'deposit4.c')
    shutil.copyfile(ROOT/'verification/fourstate/operators/ConditionalIEEE.sv',assets/'original-0.sv')
    (assets/'RunEvents.lean').write_text(runner_source(read(model),mapping),encoding='utf8')
    refresh_plan(assets,dict(top=top,source_manifest=str(manifest),original_sources=['original-0.sv'],compact_bench=True))
    return assets


def comb_runner(ir):
    from lean_records import access_paths,record_expression
    group=ir.get('lean_record_group_size',128)
    paths=access_paths((f['field'] for f in ir['outputs']),group)
    lines=[];bindings=[]
    for i,p in enumerate(ir['inputs']):
        lines.append(f'  let v{i} ← j.getObjValAs? Nat {json.dumps(p["name"])}')
        bindings.append((p['field'],f'BitVec.ofNat {p["sort"]["width"]} v{i}'))
    lines.append('  return '+record_expression(bindings,group))
    out='Lean.Json.mkObj ['+', '.join(f'({json.dumps(p["name"])}, Lean.toJson o.{paths[p["field"]]}.toNat)' for p in ir['outputs'])+']'
    assert not ir['states'] and not ir['clock'] and not ir.get('effects')
    return f'''import {ir['namespace']}
set_option maxRecDepth 65536
set_option maxHeartbeats 0
open {ir['namespace']}
def decodeInputs (j : Lean.Json) : Except String Inputs := do
{chr(10).join(lines)}
def encodeOutputs (o : Outputs) : Lean.Json := {out}
def unwrap (r : Except String α) : IO α :=
  match r with
  | .ok x => pure x
  | .error e => throw (IO.userError e)
def main (args : List String) : IO Unit := do
  let [path] := args | throw (IO.userError "request path required")
  let j ← unwrap (Lean.Json.parse (← IO.FS.readFile path))
  let rows ← unwrap (j.getObjValAs? (Array Lean.Json) "trace")
  let mut cycle : Nat := 0
  for row in rows do
    let inputs ← unwrap (decodeInputs (← unwrap (row.getObjVal? "inputs")))
    let r := evaluate inputs ⟨⟩
    if !r.outputDefined || !r.transitionDefined then throw (IO.userError "Undefined operation")
    let o := encodeOutputs r.outputs
    IO.println ((Lean.Json.mkObj [("cycle",Lean.toJson cycle),("pre",o),("post",o)]).compress)
    cycle := cycle + 1
'''


def legacy_bench(mapping, request, binary):
    """Add the absent native/encoded streams to the four old Lean-only corpora."""
    from verify_fourstate_conditional_compare import bits
    ports=mapping['ports'];states=mapping.get('states',[]);seq=mapping.get('mode')=='sequential'
    lines=['module tb;'];connections=[];inputs={};current={};nexts=[];observe=[]
    def port(name,w,direction,visible=False):
        local='p'+str(len(connections));lines.append(f'{"reg" if direction=="input" else "wire"} [{w-1}:0] {local};')
        connections.append(f'.{name}({local})')
        if visible:observe.append(local)
        return local
    for p in ports:
        if binary and p.get('role')=='clock':continue
        for k in ('tag','value') if binary else ('name',):
            local=port(p[k],p['width'],p['direction'],p['direction']=='output')
            if p['direction']=='input':inputs[p[k]]=(local,p['width'])
    for p in states:
        if binary:
            for k in ('tag','value'):
                key=p['current_'+k];current[key]=(port(key,p['width'],'input',True),p['width'])
                nexts.append(port(p['next_'+k],p['width'],'output'))
        else:observe.append('dut.'+p.get('rtl_path',p['name']))
    lines.append((mapping['encoded_top'] if binary else mapping['top'])+' dut('+','.join(connections)+');')
    lines+=['initial begin']
    def assign(row):
        for p in ports:
            if p['direction']!='input' or p.get('role')=='clock':continue
            for k in ('tag','value') if binary else ('name',):
                v=format(row['inputs'][p[k]],f'0{p["width"]}b') if binary else bits(row['inputs'][p['tag']],row['inputs'][p['value']],p['width'])
                lines.append(f"{inputs[p[k]][0]}={p['width']}'b{v};")
    assign(request['trace'][0])
    if seq and not binary:lines.append(inputs[mapping['clock']][0]+"=1'b0;")
    lines.append('#1;')
    for p in states:
        if binary:
            for k in ('current_tag','current_value'):
                lines.append(f"{current[p[k]][0]}={p['width']}'d{request['initial'][p[k]]};")
        else:
            v=bits(request['initial'][p['current_tag']],request['initial'][p['current_value']],p['width'])
            lines.append(f"dut.{p.get('rtl_path',p['name'])}={p['width']}'b{v};")
    lines.append('#1;');previous=0
    def display(i,phase=None):
        prefix=str(i)+(' '+phase if phase else '')
        return '$display("'+prefix+' '+' '.join('%b' for _ in observe)+'",'+','.join(observe)+');'
    for i,row in enumerate(request['trace']):
        assign(row);lines.append('#1;')
        if seq:
            lines.append(display(i,'pre'));clock=row['clock']
            if binary:
                if previous==0 and clock==1:lines.append('{'+','.join(v[0] for v in current.values())+'}={'+','.join(nexts)+'};')
            else:lines.append(f"{inputs[mapping['clock']][0]}=1'b{clock};")
            lines+=['#1;',display(i,'post')];previous=clock
        else:lines.append(display(i))
    lines+=['$finish;','end','endmodule']
    return '\n'.join(lines)+'\n'


def prepare_regression(frozen, folder):
    """Retain every old request and bench; refresh affected models and references."""
    from verify_fourstate_clocks_regression import canonical,sha
    frozen,folder=Path(frozen),Path(folder);oldplan=read(frozen/'plan.json')
    folder.mkdir(parents=True,exist_ok=True)
    oldmanifest=Path(oldplan['source_manifest']);oldmapping,_=load(oldmanifest)
    manifest=folder/'translation/fourstate-manifest.json'
    if not manifest.exists():manifest=regenerate(oldmanifest,folder/'translation')
    mapping,model=load(manifest)
    # Names, widths and rails of all frozen stimulus/observation fields are fixed.
    for k in ('ports','states'):
        keys=('name','width','direction','tag','value') if k=='ports' else ('name','width','current_tag','current_value','next_tag','next_value')
        assert [{x:p.get(x) for x in keys} for p in mapping.get(k,[])]==[{x:p.get(x) for x in keys} for p in oldmapping.get(k,[])],k
    assets=folder/'assets'
    if not assets.exists():
        if oldplan.get('legacy_only'):assets.mkdir()
        else:shutil.copytree(frozen,assets)
    (assets/'model/FourState').mkdir(parents=True,exist_ok=True)
    shutil.copyfile(model.with_name('Model.lean'),assets/'model/FourState/Model.lean')
    shutil.copyfile(manifest.parent/'encoded.sv',assets/'encoded.sv');write(assets/'ports.json',mapping)
    shutil.copyfile(ROOT/'verification/fourstate/deposit4.c',assets/'deposit4.c')
    ir=read(model)
    if mapping.get('mode')=='sequential':
        from fourstate_sequential import runner_source as seq_runner
        from fourstate_events import runner_source as async_runner
        runner=(async_runner if 'events' in mapping else seq_runner)(ir,mapping)
    else:runner=comb_runner(ir)
    tests=[]
    for t in oldplan['tests']:
        n=t['name'];d=assets/n;d.mkdir(exist_ok=True)
        shutil.copyfile(frozen/n/'request.json',d/'request.json')
        (d/'Run.lean').write_text(runner,encoding='utf8')
        if oldplan.get('legacy_only'):
            request=read(d/'request.json')
            for binary,label in [(False,'original'),(True,'encoded')]:
                (d/(label+'-tb.sv')).write_text(legacy_bench(mapping,request,binary),encoding='utf8')
            src=read(oldmanifest.parent/'fourstate.ir.json')['source']
            shutil.copyfile(src,assets/'original.sv')
            args=['-g2012','-s','tb','original.sv',n+'/original-tb.sv']
        else:args=t['original_args']
        ref=folder/('modelsim-'+n)
        if ref.exists():ref=folder/('modelsim-'+n+'-retry')
        ref.mkdir()
        text=(d/'original-tb.sv').read_text(encoding='utf8')
        text=re.sub(r'\$fourstate_deposit\((dut\.[A-Za-z0-9_.$\[\]]+),([^;]+)\);',r'\1 = \2;',text)
        assert '$fourstate_deposit' not in text
        (ref/'tb.sv').write_text(text,encoding='utf8')
        sources=[str((assets/x).absolute()) for x in args[3:] if x.endswith(('.sv','.v')) and x!=n+'/original-tb.sv']
        config=dict(folder=str(ref.absolute()),sources=sources)
        # Preserve predefines/include roots, required by frozen preprocessing corpora.
        extra=['+define+'+x[2:] if x.startswith('-D') else '+incdir+'+str((assets/x[2:]).absolute()) for x in args if x.startswith(('-D','-I'))]
        config['compile_args']=extra
        write(ref/'config.json',config);start=time.monotonic();modelsim_worker(config)
        log=ref/'execute/stdout.log';raw=log.read_bytes();refname=n+'/reference.log';(assets/refname).write_bytes(raw)
        tests.append(dict(name=n,samples=t['samples'],original_args=args,
            expected=dict(original=sha(canonical(raw.decode('ascii'),'original'))),
            windows_reference=dict(status='RAW_MODELSIM_REPLAY_PASS',sha256=sha(canonical(raw.decode('ascii'),'original')),
                file=refname,raw_sha256=digest(log),seconds=time.monotonic()-start),
            frozen_request_sha256=digest(frozen/n/'request.json'),frozen_test=t))
    plan=dict(top=mapping['top'],kind='regression',fresh_comparison=True,tests=tests,
              source_manifest=str(manifest),frozen_assets=str(frozen),regeneration='fresh')
    refresh_plan(assets,plan);return assets


def standard_oracle(assets):
    assets=Path(assets);m=read(assets/'ports.json');trace=read(assets/'trace.json');plan=read(assets/'plan.json')
    def mux(c,a,b):
        return a if c=='1' else b if c=='0' else ''.join(x if x==y and x in '01' else 'x' for x,y in zip(a,b))
    checks=[]
    for i,initial in enumerate(read(assets/'initials.json')):
        b=benches(m,trace,initial,compact=True)
        rows=parse_rtl(m,(assets/plan['windows_references'][i]['file']).read_text(encoding='ascii'),b['original_descriptors'],len(trace))
        state=dict(initial);previous='0'
        def outputs(v):
            a,b,c=v['a'],v['b'],v['sel']
            equal=('0' if any(x in '01' and y in '01' and x!=y for x,y in zip(a,b)) else
                   'x' if set(a+b)&set('xz') else '1')
            result=dict(expr=mux(c,a,b),identical=mux(c,a,a),eq=equal,case_eq='1' if a==b else '0')
            result.update({name:state[next(k for k in state if k.endswith('.'+name))] for name in ('q_if','q_expr','q_old')})
            return result
        for j,(t,r) in enumerate(zip(trace,rows)):
            v=t['inputs'];pre=dict(outputs=outputs(v),states=dict(state))
            if (previous,v['clk']) in (('0','1'),('0','x'),('0','z'),('x','1'),('z','1')):
                old=dict(state)
                for k in state:
                    if k.endswith('.q_if'):state[k]=v['a'] if v['sel']=='1' else v['b']
                    elif k.endswith('.q_expr'):state[k]=mux(v['sel'],v['a'],v['b'])
                    elif k.endswith('.q_old'):state[k]=old[next(x for x in old if x.endswith('.q_expr'))]
                    else:raise ValueError('unreviewed oracle state')
            post=dict(outputs=outputs(v),states=dict(state))
            for phase,expected in [('pre',pre),('post',post)]:
                actual={k:r[phase][k] for k in ('outputs','states')}
                if actual!=expected:raise ValueError('IEEE oracle mismatch '+str((i,j,phase,actual,expected)))
            previous=v['clk']
        checks.append(dict(initial=i,samples=len(rows),status='IEEE_ORACLE_PASS'))
    result=dict(status='IEEE_ORACLE_PASS',cases=checks,table='IEEE 1800-2017 11.4.11 Table 11-20',
                distinction='conditional vs process if, logical vs case equality, NBA old-state reads')
    write(assets.parent/'standard-oracle.json',result);return result


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('action',choices=['event','reference','standard']);p.add_argument('--manifest',type=Path)
    p.add_argument('--frozen',type=Path);p.add_argument('--assets',type=Path);p.add_argument('--out',type=Path,required=True)
    p.add_argument('--top');a=p.parse_args()
    if a.action=='event':print(prepare_event(a.manifest,a.frozen,a.out))
    elif a.action=='reference':print(json.dumps(reference(a.assets,a.out)))
    else:print(standard_assets(a.top,a.out))


if __name__=='__main__':main()
