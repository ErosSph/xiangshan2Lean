"""F4.6 complete frozen-corpus regression transport (stdlib on Linux).

Current frontend must reproduce every prior encoded byte before backend/model
reuse. All original corpus rows are replayed, never sampled or truncated.
"""
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


def sha(data):return hashlib.sha256(data).hexdigest()


def canonical(text,kind):
    if kind=='lean':return json.dumps([json.loads(l) for l in text.splitlines() if l.strip()],sort_keys=True,separators=(',',':')).encode()
    if 'F41 ' in text:return ('\n'.join(l.lstrip('# ') for l in text.splitlines() if l.lstrip('# ').startswith('F41 '))+'\n').encode('ascii')
    return ('\n'.join(l for l in text.splitlines() if '$finish called' not in l)+'\n').encode('ascii')


def prepare(manifest,folder):
    from fourstate_simulate import load
    from fourstate_frontend import parse
    from fourstate_encode import encode
    from fourstate2lean import write
    manifest=Path(manifest);base=manifest.parent;mapping,model=load(manifest)
    old=json.loads((base/'fourstate.ir.json').read_text())
    pp=old.get('preprocessing',{});options=dict(defines=pp.get('predefines',[]),include_dirs=pp.get('include_dirs',[]),
       async_reset=old.get('events',{}).get('reset'),bounded_memories='unpacked_memory' in old.get('capabilities',[]))
    current=parse(Path(old['source']),old['top'],old['mode'],old.get('clock'),**options)
    rtl,_=encode(current)
    rtl_bytes=rtl.replace('\n',os.linesep).encode()
    if rtl_bytes!= (base/'encoded.sv').read_bytes():raise ValueError('Current encoder differs from frozen regression RTL: '+str(base))
    design=base.parent
    if design.name=='mixed' and mapping['top']=='CAMTemplate':design=design.parent
    assets=Path(folder)/'assets';assets.mkdir(parents=True)
    payloads={'encoded.sv':rtl_bytes,'ports.json':json.dumps(mapping).encode(),
              'model/FourState/Model.lean':model.with_name('Model.lean').read_bytes(),
              'deposit4.c':(_PROJECT_ROOT/'verification/fourstate/deposit4.c').read_bytes()}
    source_map={}
    sources=json.loads((base/'sources.json').read_text())['files'] if (base/'sources.json').exists() else []
    if not sources:
        sources=[dict(path=old['source'],snapshot='original.sv',sha256=sha((base/'original.sv').read_bytes()))]
    for row in sources:
        data=(base/row['snapshot']).read_bytes()
        if sha(data)!=row['sha256']:raise ValueError('Frozen original source mismatch')
        name='rtl/'+row['snapshot'];payloads[name]=data;source_map[str(Path(row['path']).resolve())]=name
    tests=[]
    candidates=[]
    for name in ['RunSequential.lean','RunAsync.lean','Run.lean']:
        for runner in design.rglob(name):
            if 'source-snapshot' in runner.parts or not (runner.parent/'request.json').exists():continue
            if not runner.read_text(encoding='utf8').startswith('import FourState.Model'):continue
            if any(part.startswith(('fault','mutated','two-state','corrupt','loader-check')) for part in runner.relative_to(design).parts):continue
            candidates.append(runner)
    for number,runner in enumerate(sorted(candidates)):
        testbase=runner.parent
        def directories(parent):
            return next(((parent/a,parent/b) for a,b in [('original','encoded'),('original-run','encoded-run')]
                         if (parent/a/'tb.sv').exists() and (parent/b/'tb.sv').exists()),None)
        while testbase!=design and directories(testbase) is None:testbase=testbase.parent
        found=directories(testbase)
        if found is None:continue
        original_dir,encoded_dir=found
        request=json.loads((runner.parent/'request.json').read_text());n='t'+str(number)
        lean_log=runner.parent/('lean-execution' if runner.name!='Run.lean' else 'execution')/'stdout.log'
        if not lean_log.exists():raise ValueError('Missing prior actual Lean stdout')
        lean_source=runner.read_bytes()
        ir=json.loads(model.read_text())
        if runner.name=='RunSequential.lean':
            from fourstate_sequential import runner_source
            lean_source=runner_source(ir,mapping).encode()
        elif runner.name=='RunAsync.lean':
            from fourstate_events import runner_source
            lean_source=runner_source(ir,mapping).encode()
        payloads[n+'/Run.lean']=lean_source;payloads[n+'/request.json']=(runner.parent/'request.json').read_bytes()
        command=json.loads((original_dir/'compile/command.json').read_text())['command']
        windows_reference=None
        if Path(command[0]).stem.lower()=='vlog':
            # Exact automatic process locals still require the installed
            # Windows ModelSim. Re-run every original sample there; execute
            # encoded RTL and Lean on Linux. Never rewrite the original RTL.
            import sys
            from audit_fourstate_batch import bounded
            config=dict(source=old['source'],mapping=mapping,request=str(runner.parent/'fourstate-request.json'),out=str(Path(folder).absolute()/('windows-reference-'+n)))
            cfg=Path(folder)/('reference-'+n+'.json');write(cfg,config)
            code="import sys,json;assert sys.stdin.readline().strip()=='GO';sys.path.insert(0,'scripts');from pathlib import Path;from verify_fourstate_cam import modelsim;c=json.loads(Path(sys.argv[1]).read_text());r=json.loads(Path(c['request']).read_text());modelsim(Path(c['source']),c['mapping'],r['trace'],r['initial'],Path(c['out']));print('RAW_MODELSIM_PASS')"
            execution=bounded([sys.executable,'-B','-c',code,str(cfg.absolute())],Path(folder)/('windows-command-'+n),seconds=60)
            if execution['exit_code']:raise RuntimeError('Windows raw ModelSim regression failed')
            log=Path(config['out'])/'execute/stdout.log'
            if canonical(log.read_text(), 'original')!=canonical((original_dir/'execute/stdout.log').read_text(),'original'):raise ValueError('Raw ModelSim regression differs')
            windows_reference=dict(status='RAW_MODELSIM_REPLAY_PASS',execution=execution,log=str(log),sha256=sha(canonical(log.read_text(),'original')))
            command=[command[0],'-g2012','-s','tb',*[str(Path(row['path'])) for row in sources if row['path'].endswith(('.sv','.v'))],str(testbase/'original/tb.sv')]
        args=[];i=1
        while i<len(command):
            arg=command[i];i+=1
            if arg=='-o':i+=1;continue
            if arg.startswith('-I'):
                directory=Path(arg[2:]).resolve();mapped=[]
                for src,dest in source_map.items():
                    try:rel=Path(src).relative_to(directory)
                    except ValueError:continue
                    target=Path(dest)
                    for _ in rel.parts:target=target.parent
                    mapped.append(target.as_posix())
                if not mapped or len(set(mapped))!=1:raise ValueError('Ambiguous include replay root')
                args+=['-I'+mapped[0]]
            elif arg.startswith('-'):args.append(arg)
            elif arg=='tb':args.append(arg)
            elif Path(arg).resolve()==(original_dir/'tb.sv').resolve():args.append(n+'/original-tb.sv')
            else:
                key=str(Path(arg).resolve())
                if key not in source_map:
                    digest=sha(Path(arg).read_bytes());matches=[dest for dest in source_map.values() if sha(payloads[dest])==digest]
                    if len(matches)!=1:raise ValueError('Unmatched original reference source')
                    source_map[key]=matches[0]
                args.append(source_map[key])
        for kind in ['original','encoded']:
            payloads[n+'/'+kind+'-tb.sv']=((original_dir if kind=='original' else encoded_dir)/'tb.sv').read_bytes()
        expected={k:sha(canonical((lean_log if k=='lean' else (original_dir if k=='original' else encoded_dir)/'execute/stdout.log').read_text(),k)) for k in ['original','encoded','lean']}
        tests.append(dict(name=n,original_args=args,expected=expected,samples=len(request['trace']),runner=str(runner),
                          windows_reference=windows_reference,
                          references=[str(original_dir/'execute/stdout.log'),str(encoded_dir/'execute/stdout.log'),str(lean_log)]))
    if not tests:raise ValueError('No complete prior corpus found: '+str(manifest))
    for name,data in payloads.items():
        path=assets/name;path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
    plan=dict(top=mapping['top'],kind='regression',tests=tests,source_manifest=str(manifest),
              current_frontend='byte-identical encoded RTL; current loader verified original manifest; all prior trace rows',
              files=[dict(path=n,bytes=len(d),sha256=sha(d)) for n,d in payloads.items()])
    write(assets/'plan.json',plan);return assets,plan


def run(g,request):
    import os,resource,signal,subprocess,time
    from fourstate_sync_common import WORKSPACE,identifier,encoded,relative,INPUT_ARCHIVE_LIMIT
    from fourstate_sync_remote import verify_release
    from verify_fourstate_clocks_remote import RUNTIME
    verify_release(g,identifier(request['snapshot_id']))
    rid=identifier(request['run_id']);case=identifier(request['case_id']);version=identifier(request['input_version'])
    source='runs/'+rid+'/reports/'+version;plan=json.loads(g.read(source+'/plan.json',1024**2))
    if plan.get('kind')!='regression' or not 1<=len(plan['tests'])<=8:raise ValueError('invalid regression plan')
    base='runs/'+rid+'/work/'+case;report='runs/'+rid+'/reports/linux-'+case
    with g.directory(base,create=True,exclusive=True):pass
    with g.directory(report,create=True,exclusive=True):pass
    total=0;names=set()
    for f in plan['files']:
        n=f['path'];relative(n);data=g.read(source+'/'+n,None if request.get('unrestricted') else 16*1024**2);total+=len(data)
        if n in names or sha(data)!=f['sha256'] or (not request.get('unrestricted') and total>INPUT_ARCHIVE_LIMIT):raise ValueError('regression input mismatch/size (128 MiB archive policy)')
        names.add(n);g.new_file(base+'/'+n,data)
    for n in ('tmp','cache'):
        with g.directory(base+'/'+n,create=True,exclusive=True):pass
    reference_run=identifier(request.get('reference_run_id',rid))
    cwd=WORKSPACE+'/'+base;tool=WORKSPACE+'/runs/'+reference_run+'/tool/iverilog-v3'
    for n in (RUNTIME+'/bin',RUNTIME+'/lib/lean','runs/'+reference_run+'/tool/iverilog-v3/bin'):
        with g.directory(n):pass
    receipt=json.loads(g.read('runs/'+reference_run+'/reports/reference-runtime-v3.json',1024**2))
    for item in receipt['files']:
        if sha(g.read(item['copy'],64*1024**2))!=item['sha256']:raise ValueError('Reference runtime hash changed')
    lean=WORKSPACE+'/'+RUNTIME+'/bin/lean';iv=tool+'/bin/iverilog';vp=tool+'/bin/vvp';ivl=tool+'/lib/ivl'
    env=dict(os.environ,TMPDIR=cwd+'/tmp',TMP=cwd+'/tmp',TEMP=cwd+'/tmp',HOME=cwd+'/cache',XDG_CACHE_HOME=cwd+'/cache',
             LEAN_SYSROOT=WORKSPACE+'/'+RUNTIME,LEAN_PATH=cwd+'/model',PYTHONDONTWRITEBYTECODE='1')
    start=time.monotonic();commands=[]
    def command(label,args,seconds=60):
        log=report+'/'+identifier(label)
        with g.directory(log,create=True,exclusive=True) as fd:
            out=os.open('stdout.log',os.O_WRONLY|os.O_CREAT|os.O_EXCL|os.O_NOFOLLOW,0o600,dir_fd=fd)
            err=os.open('stderr.log',os.O_WRONLY|os.O_CREAT|os.O_EXCL|os.O_NOFOLLOW,0o600,dir_fd=fd)
        def restrict():
            os.setsid();os.nice(10)
            # F5.1 user authorization removes imposed CPU, memory, file and time caps.
            resource.setrlimit(resource.RLIMIT_CORE,(0,0))
        if len(args)>2 and args[0]==lean and args[1:3]==['-j','2']:
            args=[args[0],*args[3:]]
        began=time.monotonic();p=subprocess.Popen(args,cwd=cwd,env=env,stdout=out,stderr=err,preexec_fn=restrict);timeout=False
        try:p.wait()
        finally:os.close(out);os.close(err)
        row=dict(label=label,argv=args,cwd=cwd,exit_code=p.returncode,seconds=time.monotonic()-began,timeout=timeout)
        g.new_file(log+'/command.json',encoded(row));commands.append(row)
        if p.returncode or timeout:raise RuntimeError('regression command '+label+': '+g.read(log+'/stderr.log',64*1024**2).decode(errors='replace')[:2000])
        return g.read(log+'/stdout.log',None if request.get('unrestricted') else 64*1024**2).decode()
    try:
        command('model-compile',[lean,'-j','2','-s','65536','-o',cwd+'/model/FourState/Model.olean',cwd+'/model/FourState/Model.lean'])
        if not plan.get('legacy_only'):
            command('vpi-compile',['/usr/bin/gcc','-shared','-fPIC','-O2','-Wall','-Wextra','-Werror','-I/usr/include/iverilog',cwd+'/deposit4.c','-o',cwd+'/deposit4.vpi'])
        results=[]
        for t in plan['tests']:
            n=identifier(t['name'])
            if plan.get('legacy_only'):
                c=command(n+'-lean-run',[lean,'-j','2','-s','65536','--run',cwd+'/'+n+'/Run.lean',cwd+'/'+n+'/request.json'])
                digest=sha(canonical(c,'lean'))
                if digest!=t['expected']['lean']:raise ValueError('Legacy complete-corpus replay mismatch')
                results.append(dict(test=n,status='LEGACY_REPLAY_PASS',samples=t['samples'],sha256=dict(lean=digest)))
                continue
            # Args are data restricted to the frozen source file whitelist and
            # a small reviewed set of iverilog switches, never a shell string.
            args=t['original_args']
            for i,a in enumerate(args):
                if a in ('-g2012','-s','tb'):continue
                if a.startswith('-D'):
                    import re
                    if not re.fullmatch(r'-D[A-Za-z_][A-Za-z0-9_$]*(?:=[^\r\n\x00]*)?',a):raise ValueError('unsafe predefine')
                    continue
                if a.startswith('-I'):
                    relative(a[2:])
                    if not any(n.startswith(a[2:]+'/') for n in names):raise ValueError('unlisted include directory')
                    continue
                if a not in names:raise ValueError('unlisted regression source')
            if t.get('windows_reference'):
                a=None
                if t['windows_reference']['status']!='RAW_MODELSIM_REPLAY_PASS' or t['windows_reference']['sha256']!=t['expected']['original']:
                    raise ValueError('Raw Windows reference receipt mismatch')
            else:
                command(n+'-original-compile',[iv,'-B',ivl,*args[:3],'-o',cwd+'/'+n+'/original.vvp',*args[3:]])
                a=command(n+'-original-run',[vp,'-M',ivl,'-M',cwd,'-m','deposit4',cwd+'/'+n+'/original.vvp'])
            command(n+'-encoded-compile',[iv,'-B',ivl,'-g2012','-s','tb','-o',cwd+'/'+n+'/encoded.vvp',cwd+'/encoded.sv',cwd+'/'+n+'/encoded-tb.sv'])
            b=command(n+'-encoded-run',[vp,'-M',ivl,cwd+'/'+n+'/encoded.vvp'])
            c=command(n+'-lean-run',[lean,'-j','2','-s','65536','--run',cwd+'/'+n+'/Run.lean',cwd+'/'+n+'/request.json'])
            if plan.get('fresh_comparison'):
                from verify_fourstate_conditional_compare import compare_fresh
                if a is None:
                    a=g.read(base+'/'+t['windows_reference']['file'],None).decode('ascii')
                comparison=compare_fresh(json.loads(g.read(base+'/ports.json',None)),
                    json.loads(g.read(base+'/'+n+'/request.json',None)),a,b,c)
                comparison.update(test=n,original_location='Windows ModelSim' if t.get('windows_reference') else 'Linux Icarus')
                results.append(comparison)
                continue
            hashes={k:sha(canonical(v,k)) for k,v in [('encoded',b),('lean',c)]}
            hashes['original']=t['expected']['original'] if a is None else sha(canonical(a,'original'))
            if hashes!=t['expected']:raise ValueError('Frozen complete-corpus stdout mismatch: '+n+' '+str(hashes)+' != '+str(t['expected']))
            results.append(dict(test=n,status='THREE_STREAM_REPLAY_PASS',samples=t['samples'],sha256=hashes,original_location='Windows ModelSim' if a is None else 'Linux Icarus'))
        result=dict(status='FRESH_REGRESSION_PASS' if plan.get('fresh_comparison') else 'REGRESSION_REPLAY_PASS',top=plan['top'],tests=results,commands=commands,seconds=time.monotonic()-start,
                    child_peak_rss_bytes=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss*1024,
                    scope=('Fresh RTL/FunctionalIR/Lean; strict original/encoded/Lean output, state and event comparison for all frozen rows' if plan.get('fresh_comparison') else 'All frozen corpus rows, current frontend encoded bytes equal, original/encoded RTL and actual Lean replay equal all prior raw stdout; no fresh FunctionalIR generation claimed'))
        g.new_file(report+'/result.json',encoded(result));return result
    except BaseException as e:
        g.new_file(report+'/failure.json',encoded(dict(status='FAIL',error=str(e),commands=commands)));raise
