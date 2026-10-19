"""F4.7 supplement: untouched RTL / encoded RTL / Lean + native $error channel."""
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

import itertools,json,re,shutil,sys
from pathlib import Path
from fourstate2lean import translate,write,digest
from fourstate_simulate import load
from fourstate_bounded_events import runner_source,validate_trace
from verify_fourstate_clocks import corpus,benches,parse_rtl
ROOT=_PROJECT_ROOT

def capture_trace(mapping):
    now={p['name']:'0'*p['width'] for p in mapping['ports'] if p['direction']=='input'}
    now['reset']='1';trace=[dict(inputs=dict(now))]
    def setone(n,v):now[n]=v;trace.append(dict(inputs=dict(now)))
    names=[p['name'] for p in mapping['ports'] if p['direction']=='input' and p['name']!='clock']
    for values in itertools.product('01xz',repeat=len(names)):
        setone('clock','0')
        for n,v in zip(names,values):setone(n,v)
        setone('clock','1');setone('clock','0')
    for reset in '01xz':
        setone('clock','0');setone('reset',reset)
        for n,v in [('io_chainIn_shift','1'),('io_chainIn_capture','1'),('io_chainIn_update','0'),('io_chainIn_data','z')]:setone(n,v)
        for a,b in itertools.product('01xz',repeat=2):setone('clock',a);setone('clock',b)
    return trace

def prepare(source,top,folder):
    from fourstate_elaborated import source_files
    folder=Path(folder);folder.mkdir(parents=True,exist_ok=False)
    clock='clock' if top=='CaptureUpdateChain_2' else 'clk'
    manifest=translate(source,top,folder/'translation','sequential',clock,bounded_events=True,immediate_assertions=True)
    mapping,model=load(manifest);ir=json.loads(model.read_text());assets=folder/'assets';assets.mkdir()
    trace=capture_trace(mapping) if top=='CaptureUpdateChain_2' else corpus(mapping)
    if top=='AssertionOrder':
        # Explicit non-triggering seed. Preserve every generated corpus row;
        # its former seed now becomes the first real, observed rising edge.
        trace.insert(0,dict(inputs={**trace[0]['inputs'],'clk':'0'}))
    initials=[{s['name']:c*s['width'] for s in mapping['states']} for c in '01xz']
    for initial in initials:validate_trace(mapping,trace,initial)
    files={'ports.json':json.dumps(mapping).encode(),'trace.json':json.dumps(trace).encode(),'initials.json':json.dumps(initials).encode(),
        'encoded.sv':(manifest.parent/'encoded.sv').read_bytes(),'RunEvents.lean':runner_source(ir,mapping).encode(),
        'model/FourState/Model.lean':model.with_name('Model.lean').read_bytes(),'deposit4.c':(ROOT/'verification/fourstate/deposit4.c').read_bytes()}
    originals=[]
    for i,p in enumerate(source_files(source)):
        name='original-'+str(i)+'.sv';originals.append(name);files[name]=p.read_bytes()
    for n,d in files.items():
        f=assets/n;f.parent.mkdir(parents=True,exist_ok=True);f.write_bytes(d)
    write(assets/'plan.json',dict(top=top,original_sources=originals,files=[dict(path=n,bytes=len(d),sha256=digest(assets/n)) for n,d in files.items()]))
    write(folder/'prepared.json',dict(manifest=str(manifest),functional_nodes=len(ir['nodes']),state_bits=sum(s['width'] for s in mapping['states']),
          trace_samples=len(trace),samples=len(trace)*4,assertion_sites=mapping['assertions'],sources=[dict(path=str(p),sha256=digest(p)) for p in source_files(source)]))
    return assets

def modelsim_reference(assets,folder):
    from audit_fourstate_batch import bounded
    assets=Path(assets);folder=Path(folder);folder.mkdir(parents=True,exist_ok=False)
    m=json.loads((assets/'ports.json').read_text());trace=json.loads((assets/'trace.json').read_text());initials=json.loads((assets/'initials.json').read_text())
    plan=json.loads((assets/'plan.json').read_text());receipts=[]
    for i,initial in enumerate(initials):
        case=folder/('initial-'+str(i));case.mkdir();b=benches(m,trace,initial)
        text=re.sub(r'\$fourstate_deposit\((dut\.[A-Za-z0-9_.$]+),([^;]+)\);',r'\1 = \2;',b['original'])
        if '$fourstate_deposit' in text:raise ValueError('unsupported deposit shape')
        (case/'tb.sv').write_text(text,encoding='utf8')
        cfg=case/'config.json';write(cfg,dict(folder=str(case.absolute()),sources=[str((assets/n).absolute()) for n in plan['original_sources']]))
        code="import sys,json;assert sys.stdin.readline().strip()=='GO';sys.path.insert(0,'scripts');from pathlib import Path;from verify_fourstate_structures import modelsim_worker;modelsim_worker(json.loads(Path(sys.argv[1]).read_text()))"
        execution=bounded([sys.executable,'-B','-c',code,str(cfg.absolute())],case/'command',seconds=60)
        if execution['exit_code']:raise RuntimeError('ModelSim reference failed '+str(case))
        raw=(case/'execute/stdout.log').read_bytes();parsed=parse_rtl(m,raw.decode('utf8'),b['original_descriptors'],len(trace))
        name='reference-'+str(i)+'.log';(assets/name).write_bytes(raw)
        plan['files'].append(dict(path=name,bytes=len(raw),sha256=digest(assets/name)))
        write(case/'parsed.json',parsed)
        receipts.append(dict(status='RAW_MODELSIM_PASS',file=name,sha256=digest(assets/name),samples=len(trace),command=execution,
            assertion_failures=sum(len(x['assertions']) for x in parsed),bench_sha256=digest(case/'tb.sv'),raw_stdout_sha256=digest(case/'execute/stdout.log')))
    plan['windows_references']=receipts;write(assets/'plan.json',plan);return receipts

def main():
    import argparse
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('action',choices=['prepare','modelsim','send'])
    p.add_argument('--source',type=Path);p.add_argument('--top');p.add_argument('--out',type=Path,required=True);p.add_argument('--assets',type=Path)
    p.add_argument('--run-id');p.add_argument('--snapshot-id');p.add_argument('--case-id');a=p.parse_args()
    if a.action=='prepare':print(prepare(a.source,a.top,a.out))
    elif a.action=='modelsim':print(json.dumps(modelsim_reference(a.assets,a.out)))
    else:
        from verify_fourstate_structures import send
        a.out.mkdir(parents=True,exist_ok=False);r=send(a.assets,a.run_id,a.snapshot_id,a.case_id,a.out)
        print(json.dumps(dict(status=r['status'],samples=sum(c['samples'] for c in r['cases']),failures=sum(c['assertion_failures'] for c in r['cases']))))

if __name__=='__main__':main()
