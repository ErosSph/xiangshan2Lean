"""Windows F5.3 controller: explicit source snapshot, guarded SSH, no remote Codex."""
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
import argparse,json,sys,subprocess,uuid,datetime
ROOT=_PROJECT_ROOT

def regression_selection():
    """Use accepted F51a executions, excluding its retained failed trials."""
    import hashlib
    old=ROOT/'experiments/fourstate/f51a-20261018t041550z-80afd4fe';configs=[]
    executions=json.loads((old/'execution-final.json').read_bytes())
    for row in [*executions,dict(group='cases',case='JtagTapController',server_case='jtagtapcontroller')]:
        prepared=json.loads((old/row['group']/row['case']/'prepared.json').read_bytes()) if row['group']!='cases' else {}
        assets=Path(prepared['assets']) if prepared else old/'cases/JtagTapController/assets'
        plan=json.loads((assets/'plan.json').read_bytes())
        manifest=Path(plan.get('source_manifest',prepared.get('manifest','')))
        ir=json.loads((manifest.parent/'fourstate.ir.json').read_bytes());sources=[]
        for name in ir.get('sources',[ir['source']]):
            if Path(name).suffix.lower() not in ('.sv','.v'):continue
            h=hashlib.sha256(Path(name).read_bytes()).hexdigest()
            matches=[v['path'] for v in plan['files'] if v['sha256']==h and v['path'].endswith(('.sv','.v'))]
            if not matches:raise ValueError('Accepted source missing '+name)
            sources.append(matches[0])
        caps=ir.get('capabilities',[]);pp=ir.get('preprocessing',{})
        options=dict(mode=ir.get('mode','combinational'),clock=ir.get('clock'),bounded_memories='unpacked_memory' in caps,
            bounded_events='bounded_events' in caps,immediate_assertions='immediate_assertions' in caps,defines=pp.get('predefines',[]))
        if options['bounded_events']:options['event_clocks']=ir['events']['roots']
        elif 'async_posedge' in caps:options['async_reset']=ir['events']['reset']
        configs.append(dict(case=row['server_case'],top=ir['top'],source_files=sources,source_is_dir=Path(ir['source']).is_dir(),options=options,
            accepted_execution=row,manifest_sha256=hashlib.sha256(manifest.read_bytes()).hexdigest()))
    return configs

def modelsim_case(case,folder):
    """Local fallback only: untouched RTL, external deposits, full observations."""
    import re,time,shutil,copy
    from common import run_logged
    from verify_fourstate_clocks import parse_rtl,compare
    case=Path(case).resolve();folder=Path(folder).resolve();folder.mkdir()
    mapping=json.loads((case/'ports.json').read_bytes());trace=json.loads((case/'trace.json').read_bytes())
    initials=json.loads((case/'initials.json').read_bytes());plan=json.loads((case/'plan.json').read_bytes());rows=[]
    latches=[s for s in mapping['states'] if mapping['events']['processes'][s['process']]['kind']=='latch']
    for i,initial in enumerate(initials):
        f=folder/f'initial-{i}';f.mkdir();text=(case/f'initial-{i}/original-tb.sv').read_text()
        # always_latch permits only its own HDL writer. Use simulator deposit
        # through Tcl rather than add an illegal second procedural assignment.
        for s in latches:
            text=re.sub(r'\$fourstate_deposit\(dut\.'+re.escape(s['rtl_path'])+r',[^;]+\);','',text)
        text=re.sub(r'\$fourstate_deposit\((dut\.[A-Za-z0-9_.$\[\]]+),([^;]+)\);',r'\1 = \2;',text)
        if '$fourstate_deposit' in text:raise ValueError('Unknown deposit shape')
        (f/'tb.sv').write_text(text)
        action='onerror {quit -code 1}; '
        if latches:
            action+='run 2; '
            for s in latches:
                path='/tb/dut/'+s['rtl_path'].replace('.','/')
                # ModelSim 10.1d rejects force -deposit on variables. Force and
                # immediately release a variable without advancing time: the
                # value remains until its next procedural assignment.
                action+='force -freeze '+path+" "+str(s['width'])+"'b"+initial[s['name']]+'; noforce '+path+'; '
        action+='run -all; quit -code 0'
        commands=[('ini',[shutil.which('vmap'),'-c']),('library',[shutil.which('vlib'),'work']),('version',[shutil.which('vsim'),'-version']),
            ('compile',[shutil.which('vlog'),'-sv','-work','work',*[str(case/n) for n in plan['original_sources']],str(f/'tb.sv')]),
            ('execute',[shutil.which('vsim'),'-c','-onfinish','stop','-lib','work','tb','-l','transcript.log','-wlf','sim.wlf','-do',action])]
        start=time.monotonic()
        for label,args in commands:
            if run_logged(args,f/label,cwd=f,echo=False):raise RuntimeError('ModelSim '+str(f)+' '+label+' failed')
        raw=(f/'execute/stdout.log').read_text()
        if '** Error:' in raw or '** Fatal:' in raw:raise ValueError('Raw reference diagnostics contain error')
        canonical='\n'.join(l.lstrip('# ') for l in raw.splitlines() if re.match(r'^\d+ (?:pre|post) ',l.lstrip('# ')))+'\n'
        desc=json.loads((case/f'initial-{i}/descriptors.json').read_bytes())['original_descriptors']
        original=parse_rtl(mapping,canonical,desc,len(trace));encoded=json.loads((case/f'initial-{i}/encoded-result.json').read_bytes())
        result=compare(mapping,original,encoded,copy.deepcopy(encoded));result.update(status='MODELSIM_ENCODED_PASS',top=plan['top'],initial=i,seconds=time.monotonic()-start)
        (f/'reference.json').write_text(json.dumps(original));rows.append(result)
    (folder/'summary.json').write_text(json.dumps(rows,indent=2));return rows

def remote(folder,operation,request):
    import fourstate_sync as sync
    code='import sys,types\n'
    for name in ('fourstate_sync_common','fourstate_sync_remote','audit_fourstate_remote','audit_fourstate_f52_remote','run_fourstate_f53_remote'):
        raw=(ROOT/'scripts'/(name+'.py')).read_text(encoding='utf8')
        code+='m=types.ModuleType('+repr(name)+');sys.modules['+repr(name)+']=m\nexec('+ascii(raw)+',m.__dict__)\n'
    code+="sys.modules['run_fourstate_f53_remote'].main("+ascii(dict(request,operation=operation))+')\n'
    log=Path(folder)/('ssh-'+operation+'-'+uuid.uuid4().hex[:8]);log.mkdir()
    (log/'stdin.py').write_text(code,encoding='ascii')
    command=['C:/Windows/System32/OpenSSH/ssh.exe','-T','-a','-x',*sync.OPTIONS,'amax','/usr/bin/python3 -I -B -S -']
    (log/'command.json').write_text(json.dumps(dict(argv=command,request=request,start_utc=datetime.datetime.now(datetime.timezone.utc).isoformat()),indent=2))
    with (log/'stdout.json').open('wb') as out,(log/'stderr.log').open('wb') as err:
        p=subprocess.run(command,input=code.encode('ascii'),stdout=out,stderr=err)
    (log/'result.json').write_text(json.dumps(dict(exit_code=p.returncode)))
    if p.returncode:raise RuntimeError(str(log)+' '+(log/'stderr.log').read_text())
    return json.loads((log/'stdout.json').read_bytes())

def pack():
    import fourstate_sync as sync
    from fourstate_sync_common import sha,encoded,make_zip
    paths={p for p in (ROOT/'scripts').rglob('*.py') if p.is_file()}|set(ROOT.glob('tests/test_fourstate*.py'))|set(ROOT.glob('verification/fourstate/**/*'))
    paths|={ROOT/n for n in ('AGENTS.md','TASKS.md','docs/fourstate-frontend.md','lean/Chisel2Lean/Functional.lean')}
    names=sorted(str(p.relative_to(ROOT)).replace('\\','/') for p in paths if p.is_file())
    snapshot=sync.fresh_id('f53-source');base=sync.new_directory(ROOT/'.cache/fourstate-sync'/snapshot)
    payloads={n:sync.stable_read(sync.checked(ROOT,n),None) for n in names}
    rows=[dict(path=n,bytes=len(d),sha256=sha(d)) for n,d in payloads.items()]
    manifest=dict(format='fourstate-sync-source-v1',snapshot_id=snapshot,profile='f5.3',unrestricted=True,
        files=rows,bytes=sum(r['bytes'] for r in rows),scope='Private compact state and raw/encoded validation; no public backend execution',
        git=dict(head=sync.git('rev-parse','HEAD').decode().strip()))
    data=make_zip(manifest,payloads,'source')
    for n,d in payloads.items():sync.new_file(base/'source'/n,d)
    sync.new_file(base/'manifest.json',encoded(manifest));sync.new_file(base/'bundle.zip',data)
    receipt=dict(snapshot_id=snapshot,manifest_sha256=sha(encoded(manifest)),archive_sha256=sha(data),archive_bytes=len(data),files=len(rows))
    sync.new_file(base/'receipt.json',encoded(receipt));sync.new_file(base/'COMPLETE',encoded(dict(receipt_sha256=sha(encoded(receipt)))))
    return dict(pack=receipt,push=sync.push(snapshot))

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('operation');p.add_argument('--out',type=Path,required=True);p.add_argument('--request',type=Path)
    a=p.parse_args();request=json.loads(a.request.read_bytes()) if a.request else {}
    value=pack() if a.operation=='pack' else remote(a.out,a.operation,request)
    target=a.out/(a.operation+'-'+uuid.uuid4().hex[:8]+'.json');target.write_text(json.dumps(value,indent=2))
    print(json.dumps(value))
if __name__=='__main__':main()
