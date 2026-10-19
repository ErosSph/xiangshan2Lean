"""F4.7 bounded procedural fixtures and untouched JTAG reference evidence.

Front-end/FunctionalIR on Windows; simulations and Lean on guarded Linux.
ModelSim fallback changes only the deposit mechanism in the test bench.
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

import itertools
import json
from pathlib import Path
import re
import shutil
import sys
from fourstate2lean import translate, write, digest
from fourstate_simulate import load
from fourstate_bounded_events import runner_source, validate_trace
from verify_fourstate_clocks import benches, parse_rtl, corpus, send_case

ROOT=_PROJECT_ROOT
REFERENCE_RUN='f46-20261017t182304z-84b51ec0'


def trace_for(mapping):
    top=mapping['top']
    if top=='JtagStateMachine':
        trace=corpus(mapping);now=dict(trace[-1]['inputs'])
        def setone(n,v):
            now[n]=v;trace.append(dict(inputs=dict(now)))
        # Test-vector planning only, independently enumerated from the frozen
        # RTL table. No model or reference is rewritten from this graph.
        nexts={0:(2,5),1:(3,5),2:(2,1),3:(3,0),4:(14,15),5:(12,7),6:(2,1),7:(6,4),
               8:(10,13),9:(11,13),10:(10,9),11:(11,8),12:(12,7),13:(12,7),14:(10,9),15:(12,15)}
        paths={15:[]};todo=[15]
        for state in todo:
            for tms,dest in enumerate(nexts[state]):
                if dest not in paths:paths[dest]=paths[state]+[str(tms)];todo.append(dest)
        if len(paths)!=16:raise ValueError('incomplete directed JTAG reachability vectors')
        for state in range(16):
            for choice in '01xz':
                setone('clock','0');setone('reset','0');setone('reset','1');setone('reset','0')
                for tms in paths[state]+[choice]:
                    setone('io_tms',tms);setone('clock','1');setone('clock','0')
        return trace
    now={p['name']:'0'*p['width'] for p in mapping['ports'] if p['direction']=='input'}
    trace=[dict(inputs=dict(now))]
    def setone(n,v):
        now[n]=v;trace.append(dict(inputs=dict(now)))
    def row(values):
        setone('clk','0')
        for n,v in values.items():setone(n,v)
        setone('clk','1');setone('clk','1')
    symbols='01xz'
    words=lambda w:(''.join(x) for x in itertools.product(symbols,repeat=w))
    if top=='NamedProcedural':
        for a,b,c in itertools.product(list(words(2)),list(words(2)),symbols):row(dict(a=a,b=b,choose=c))
    elif top=='PackedProcedural':
        data=['00000000','11111111','xxxxxxxx','zzzzzzzz','01xz10zx','10100101','00110110']
        for i,(idx,bitidx) in enumerate(itertools.product(words(3),list(words(2)))):
            row(dict(data=data[i%len(data)],idx=idx,bitidx=bitidx,en=symbols[i%4]))
        for i,v in enumerate(words(4)):
            row(dict(data=v+v[::-1],idx=str(i%2).zfill(3),bitidx=format(i%4,'02b'),en='1'))
    else:raise ValueError('unreviewed procedural corpus')
    # Every four-state clock transition, with one changed input per row.
    for a,b in itertools.product(symbols,repeat=2):setone('clk',a);setone('clk',b)
    return trace


def prepare(source,top,folder):
    from fourstate_elaborated import source_files
    clock='clock' if top=='JtagStateMachine' else 'clk'
    folder=Path(folder);folder.mkdir(parents=True,exist_ok=False)
    manifest=translate(source,top,folder/'translation','sequential',clock,bounded_events=True,event_clocks=(clock,))
    mapping,model=load(manifest);ir=json.loads(model.read_text())
    trace=trace_for(mapping)
    initials=[{s['name']:c*s['width'] for s in mapping['states']} for c in '01xz']
    for initial in initials:validate_trace(mapping,trace,initial)
    assets=folder/'assets';assets.mkdir()
    files={'ports.json':json.dumps(mapping).encode(),'trace.json':json.dumps(trace).encode(),
           'initials.json':json.dumps(initials).encode(),'encoded.sv':(manifest.parent/'encoded.sv').read_bytes(),
           'RunEvents.lean':runner_source(ir,mapping).encode(),
           'model/FourState/Model.lean':model.with_name('Model.lean').read_bytes(),
           'deposit4.c':(ROOT/'verification/fourstate/deposit4.c').read_bytes()}
    originals=[]
    for i,src in enumerate(source_files(source)):
        n='original-'+str(i)+'.sv';originals.append(n);files[n]=src.read_bytes()
    for n,d in files.items():
        f=assets/n;f.parent.mkdir(parents=True,exist_ok=True);f.write_bytes(d)
    plan=dict(top=top,original_sources=originals,files=[dict(path=n,bytes=len(d),sha256=digest(assets/n)) for n,d in files.items()])
    write(assets/'plan.json',plan)
    write(folder/'prepared.json',dict(manifest=str(manifest),functional_nodes=len(ir['nodes']),trace_samples=len(trace),
          samples=len(trace)*len(initials),state_bits=sum(s['width'] for s in mapping['states']),
          source_sha256=[dict(path=str(s),sha256=digest(s)) for s in source_files(source)]))
    return assets


def modelsim_assets(assets,folder):
    """Full exact raw reference including all initial states, pre/post and events."""
    import subprocess
    from common import run_logged
    from audit_fourstate_batch import bounded
    assets=Path(assets);folder=Path(folder);folder.mkdir(parents=True,exist_ok=False)
    mapping=json.loads((assets/'ports.json').read_text());trace=json.loads((assets/'trace.json').read_text())
    initials=json.loads((assets/'initials.json').read_text());plan=json.loads((assets/'plan.json').read_text())
    receipts=[]
    for i,initial in enumerate(initials):
        case=folder/('initial-'+str(i));case.mkdir()
        bench=benches(mapping,trace,initial)
        text=re.sub(r'\$fourstate_deposit\((dut\.[A-Za-z0-9_.$]+),([^;]+)\);',r'\1 = \2;',bench['original'])
        if '$fourstate_deposit' in text:raise ValueError('unsupported reference deposit shape')
        (case/'tb.sv').write_text(text,encoding='utf8')
        config=dict(folder=str(case.absolute()),sources=[str((assets/n).absolute()) for n in plan['original_sources']])
        write(case/'config.json',config)
        code="import sys,json;assert sys.stdin.readline().strip()=='GO';sys.path.insert(0,'scripts');from pathlib import Path;from verify_fourstate_structures import modelsim_worker;c=json.loads(Path(sys.argv[1]).read_text());modelsim_worker(c)"
        receipt=bounded([sys.executable,'-B','-c',code,str((case/'config.json').absolute())],case/'command',seconds=60)
        if receipt['exit_code']:raise RuntimeError('ModelSim reference failed: '+str(case))
        raw=(case/'execute/stdout.log').read_text(encoding='utf8')
        if '** Error:' in raw or '** Fatal:' in raw:raise ValueError('ModelSim error in raw stdout')
        lines=[l.lstrip('# ') for l in raw.splitlines() if re.match(r'^\d+ (?:pre|post) ',l.lstrip('# '))]
        canonical=('\n'.join(lines)+'\n').encode('ascii')
        parsed=parse_rtl(mapping,canonical.decode('ascii'),bench['original_descriptors'],len(trace))
        write(case/'parsed.json',parsed)
        name='reference-'+str(i)+'.log';(assets/name).write_bytes(canonical)
        plan['files'].append(dict(path=name,bytes=len(canonical),sha256=digest(assets/name)))
        receipts.append(dict(status='RAW_MODELSIM_PASS',file=name,sha256=digest(assets/name),samples=len(trace),
                             command=receipt,source_hashes=[digest(assets/n) for n in plan['original_sources']],
                             bench_sha256=digest(case/'tb.sv'),raw_stdout_sha256=digest(case/'execute/stdout.log')))
    plan['windows_references']=receipts
    write(assets/'plan.json',plan)
    return receipts


def modelsim_worker(c):
    from common import run_logged
    folder=Path(c['folder'])
    commands=[('ini',[shutil.which('vmap'),'-c']),('library',[shutil.which('vlib'),'work']),
        ('version',[shutil.which('vsim'),'-version']),
        ('compile',[shutil.which('vlog'),'-sv','-work','work',*c.get('compile_args',[]),*c['sources'],str(folder/'tb.sv')]),
        ('execute',[shutil.which('vsim'),'-c','-onfinish','stop','-lib','work','tb','-l','transcript.log',
                    '-wlf','sim.wlf','-do','onerror {quit -code 1}; run -all; quit -code 0'])]
    for label,args in commands:
        if any(a is None for a in args):raise RuntimeError('existing ModelSim required')
        if run_logged(args,folder/label,cwd=folder,echo=False):raise RuntimeError('ModelSim '+label+' failed')


def send(assets,run,snapshot,case,folder,operation='run-clocks',unrestricted=False,reset_fault=None):
    import base64
    from verify_fourstate_blockers import remote_call
    files=[dict(path=p.relative_to(assets).as_posix(),sha256=digest(p),base64=base64.b64encode(p.read_bytes()).decode())
           for p in sorted(Path(assets).rglob('*')) if p.is_file()]
    version='input-'+case
    a=remote_call(folder,dict(operation='archive',run_id=run,snapshot_id=snapshot,version=version,files=files,unrestricted=unrestricted),entry='verify_fourstate_clocks_remote')
    write(Path(folder)/'archive.json',a)
    r=remote_call(folder,dict(operation=operation,run_id=run,snapshot_id=snapshot,input_version=version,case_id=case,
                            reference_run_id=REFERENCE_RUN,unrestricted=unrestricted,reset_fault=reset_fault),entry='verify_fourstate_clocks_remote')
    write(Path(folder)/'linux-result.json',r)
    return r


def main():
    import argparse
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('action',choices=['prepare','modelsim','send'])
    p.add_argument('--source',type=Path);p.add_argument('--top');p.add_argument('--out',type=Path,required=True)
    p.add_argument('--assets',type=Path);p.add_argument('--run-id');p.add_argument('--snapshot-id');p.add_argument('--case-id')
    a=p.parse_args()
    if a.action=='prepare':print(prepare(a.source,a.top,a.out))
    elif a.action=='modelsim':print(json.dumps(modelsim_assets(a.assets,a.out)))
    else:
        a.out.mkdir(exist_ok=False)
        r=send(a.assets,a.run_id,a.snapshot_id,a.case_id,a.out)
        print(json.dumps(dict(status=r['status'],samples=sum(c['samples'] for c in r['cases']),seconds=r['seconds'])))


if __name__=='__main__':main()
