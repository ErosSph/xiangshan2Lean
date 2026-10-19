"""F53 server launcher. Only Guard-owned fresh output paths may be executed."""
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

import os,json,time,subprocess
from pathlib import Path
from fourstate_sync_common import WORKSPACE,identifier,encoded,sha
from fourstate_sync_remote import Guard,verify_release
from audit_fourstate_f52_remote import resources,index,protect_original
OLD='runs/f52-20261018t053126z-afe34e29'

def main(request):
    os.umask(0o077);g=Guard()
    try:
        op=request['operation'];run=identifier(request['run_id']);base='runs/'+run
        if op=='init':
            with g.directory(base,create=True,exclusive=True):pass
            for name in ('input-receipt.json','environment/runtime.json'):
                g.new_file(base+'/reports/'+name,g.read(OLD+'/reports/'+name,None))
            result=dict(status='INITIALIZED',resources=resources(g),frozen_input_root=OLD+'/reports/inputs')
            g.new_file(base+'/reports/preflight.json',encoded(result))
        elif op=='execute':
            snap=identifier(request['snapshot_id']);verified=verify_release(g,snap);label=identifier(request['label'])
            mode=request.get('mode','probe')
            if mode not in ('probe','inventory','tests','regressions','compare'):raise ValueError('Unknown worker mode')
            work=base+'/work/'+label;out=base+'/reports/'+label
            for name in (work,out):
                with g.directory(name,create=True,exclusive=True):pass
            runtime=json.loads(g.read(base+'/reports/environment/runtime.json',None))
            for row in runtime['files']:
                if sha(g.read(runtime['base']+'/'+row['path'],None))!=row['sha256']:raise ValueError('Runtime hash differs')
            source=WORKSPACE+'/releases/'+snap+'/src/scripts'
            req=dict(request,run=WORKSPACE+'/'+base,input_run=WORKSPACE+'/'+OLD)
            g.new_file(work+'/request.json',encoded(req))
            command=[WORKSPACE+'/'+runtime['base']+'/python/bin/python3.11','-I','-B','-c',
                'import sys,runpy;sys.path.insert(0,'+repr(source)+');runpy.run_path('+repr(source+'/verify_fourstate_f53.py')+',run_name="__main__")',
                '--request',WORKSPACE+'/'+work+'/request.json','--out',WORKSPACE+'/'+out]
            env=dict(os.environ,PYTHONDONTWRITEBYTECODE='1',HOME=WORKSPACE+'/'+work,TMPDIR=WORKSPACE+'/'+work,XDG_CACHE_HOME=WORKSPACE+'/'+work)
            start=time.monotonic();peak=0
            g.new_file(out+'/launch.json',encoded(dict(argv=command,source_snapshot=verified,resources=resources(g))))
            with open(WORKSPACE+'/'+out+'/stdout.log','xb') as stdout,open(WORKSPACE+'/'+out+'/stderr.log','xb') as stderr,open(WORKSPACE+'/'+out+'/monitor.jsonl','x') as monitor:
                p=subprocess.Popen(command,cwd=WORKSPACE+'/'+work,env=env,stdout=stdout,stderr=stderr)
                while p.poll() is None:
                    rss={}
                    try:
                        for line in Path('/proc/'+str(p.pid)+'/status').read_text().splitlines():
                            k,_,v=line.partition(':')
                            if k in ('VmRSS','VmHWM'):rss[k]=int(v.split()[0])*1024
                    except FileNotFoundError:pass
                    peak=max(peak,rss.get('VmHWM',0));monitor.write(json.dumps(dict(seconds=time.monotonic()-start,pid=p.pid,rss=rss,system=resources(g)))+'\n');monitor.flush();time.sleep(1)
            result=dict(exit_code=p.wait(),seconds=time.monotonic()-start,peak_rss_bytes=peak,source_snapshot=verified,mode=mode,limits='No additional resource or timeout caps',resources=resources(g))
            g.new_file(out+'/execution.json',encoded(result))
        elif op=='index':
            import stat
            rows=[];refused=[]
            def walk(name):
                for row in g.listing(base+'/'+name):
                    target=name+'/'+row['name']
                    if stat.S_ISDIR(row['mode']):walk(target)
                    elif stat.S_ISREG(row['mode']):rows.append(dict(path=target,bytes=row['bytes'],sha256=sha(g.read(base+'/'+target,None))))
                    elif target.startswith('reports/tests-') and '/project/' in target:
                        refused.append(dict(path=target,mode=row['mode'],reason='Negative-test nonregular artifact; never followed or exported'))
                    else:raise ValueError('Unexpected nonregular evidence '+target)
            walk('reports');result=dict(files=rows,unrestricted=True,nonregular_test_artifacts=refused)
        elif op=='reference-supplement':
            import base64
            from fourstate_sync_common import relative
            label=identifier(request['label']);target=base+'/reports/'+label
            with g.directory(target,create=True,exclusive=True):pass
            rows=[]
            for row in request['files']:
                relative(row['path']);data=base64.b64decode(row['base64'],validate=True)
                if sha(data)!=row['sha256']:raise ValueError('Reference upload hash mismatch')
                g.new_file(target+'/'+row['path'],data);rows.append({k:v for k,v in row.items() if k!='base64'})
            g.new_file(target+'/receipt.json',encoded(dict(files=rows)))
            result=dict(status='HASH_VERIFIED_REFERENCE_SUPPLEMENT',files=len(rows))
        elif op=='protect':result=protect_original(g,request)
        else:raise ValueError('Unknown F53 operation')
        print(json.dumps(result))
    finally:g.close()
