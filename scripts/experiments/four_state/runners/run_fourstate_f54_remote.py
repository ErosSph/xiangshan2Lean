"""F54 server launcher. Only Guard-owned fresh output paths may be executed."""
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
        if op=='audit-release':
            import stat
            snap=identifier(request['snapshot_id']);manifest=json.loads(g.read('releases/'+snap+'/manifest.json',None));expected={r['path']:r for r in manifest['files']};mismatch=[];extra=[]
            for n,row in expected.items():
                if sha(g.read('releases/'+snap+'/src/'+n,None))!=row['sha256']:mismatch.append(n)
            parents={str(Path(n).parent).replace('\\','/') for n in expected}
            parents|={str(p).replace('\\','/') for n in expected for p in Path(n).parents};parents.add('.')
            def walk(sub):
                for row in g.listing('releases/'+snap+'/src'+('/'+sub if sub else '')):
                    name=(sub+'/' if sub else '')+row['name']
                    if stat.S_ISDIR(row['mode']):
                        if name not in parents:extra.append(dict(path=name,kind='directory'))
                        else:walk(name)
                    elif name not in expected:extra.append(dict(path=name,kind='nonmanifest entry'))
            walk('');result=dict(snapshot=snap,files_checked=len(expected),content_mismatches=mismatch,extra_entries=extra)
            g.new_file(base+'/reports/source-audit-'+snap+'.json',encoded(result))
        elif op in ('progress','cancel'):
            label=identifier(request['label']);last=json.loads(g.read(base+'/reports/'+label+'/monitor.jsonl',None).splitlines()[-1]);pid=last['pid']
            def info(n):
                path=Path('/proc')/str(n)
                try:
                    usage=(path/'stat').read_text().rpartition(') ')[2].split();ticks=os.sysconf('SC_CLK_TCK')
                    positions=[]
                    if request.get('file_positions'):
                        for descriptor in (path/'fd').iterdir():
                            try:
                                target=os.readlink(descriptor)
                                if target.startswith(WORKSPACE+'/'):
                                    data=dict(line.split(':',1) for line in (path/'fdinfo'/descriptor.name).read_text().splitlines() if ':' in line)
                                    positions.append(dict(path=target,offset=int(data['pos'])))
                            except (FileNotFoundError,PermissionError,ProcessLookupError):pass
                    return dict(pid=n,uid=path.stat().st_uid,cwd=os.readlink(path/'cwd'),ppid=int(usage[1]),start_ticks=int(usage[19]),cmdline=(path/'cmdline').read_bytes().replace(b'\0',b' ').decode(),status=[l for l in (path/'status').read_text().splitlines() if l.startswith(('State:','VmRSS:','VmHWM:'))],children=list(map(int,(path/'task'/str(n)/'children').read_text().split())),cpu_seconds=(int(usage[11])+int(usage[12]))/ticks,file_positions=positions)
                except FileNotFoundError:return dict(pid=n,finished=True,children=[])
            result=info(pid);result['resource']=resources(g);result['monitor']=last;result['child_info']=[info(n) for n in result['children']]
            pending=list(result['child_info']);result['descendants']=[]
            while pending:
                row=pending.pop();result['descendants'].append(row);pending.extend(info(n) for n in row['children'])
            result['stdout_tail']=g.read(base+'/reports/'+label+'/stdout.log',None).decode(errors='replace')[-3000:]
            result['stderr_tail']=g.read(base+'/reports/'+label+'/stderr.log',None).decode(errors='replace')[-5000:]
            if request.get('observation_stream'):
                import zlib
                from fourstate_sync_common import relative
                sub=request['observation_stream'];relative(sub)
                if not sub.startswith('reports/'+label+'/') or not sub.endswith('/stdout.log.gz'):raise ValueError('Only the selected current observation stream may be monitored')
                raw=g.read(base+'/'+sub,None);decoder=zlib.decompressobj(16+zlib.MAX_WBITS);tail=b'';decoded=0
                for i in range(0,len(raw),65536):
                    piece=decoder.decompress(raw[i:i+65536]);decoded+=len(piece);tail=(tail+piece)[-1500:]
                result['observations']=dict(path=sub,compressed_bytes=len(raw),decoded_bytes=decoded,complete=decoder.eof,tail=tail.decode(errors='replace'))
            if op=='cancel':
                import signal
                if base not in result.get('cmdline',''):raise ValueError('Worker identity mismatch')
                pending=list(result['child_info']);owned=[]
                while pending:
                    row=pending.pop();owned.append(row);pending.extend(info(n) for n in row['children'])
                if request.get('expected_processes'):
                    expected={row['pid']:row['start_ticks'] for row in request['expected_processes']}
                    live=[result,*owned]
                    if {row['pid'] for row in live if not row.get('finished')}!=set(expected):raise ValueError('Process tree changed before cancellation')
                    for row in live:
                        if row.get('finished'):continue
                        if row['uid']!=os.geteuid() or row['start_ticks']!=expected[row['pid']]:raise ValueError('Process owner or start identity changed')
                        Path(row['cwd']).resolve(strict=True).relative_to(Path(WORKSPACE+'/'+base).resolve(strict=True))
                        if base not in row['cmdline']:raise ValueError('Process not tied to selected run')
                for row in reversed(owned):
                    if row.get('finished'):continue
                    if WORKSPACE not in row['cmdline']:raise ValueError('Child outside private workspace')
                    if request.get('expected_processes'):
                        current=info(row['pid'])
                        if current.get('finished'):continue
                        if current['uid']!=row['uid'] or current['start_ticks']!=row['start_ticks']:raise ValueError('Process identity changed before signal')
                    os.kill(row['pid'],signal.SIGTERM)
                if request.get('expected_processes'):
                    current=info(pid)
                    if not current.get('finished'):
                        if current['uid']!=result['uid'] or current['start_ticks']!=result['start_ticks']:raise ValueError('Worker identity changed before signal')
                        os.kill(pid,signal.SIGTERM)
                else:os.kill(pid,signal.SIGTERM)
                result['cancelled_reason']=request['reason']
                g.new_file(base+'/reports/cancel-'+label+'.json',encoded(result))
        elif op=='cancel-status':
            label=identifier(request['label']);sample=identifier(request['sample'])
            stopped=json.loads(g.read(base+'/reports/cancel-'+label+'.json',None))
            targets=[]
            for prior in [stopped,*stopped.get('descendants',[])]:
                path=Path('/proc')/str(prior['pid'])
                try:
                    fields=(path/'stat').read_text().rpartition(') ')[2].split()
                    current=int(fields[19])
                    targets.append(dict(pid=prior['pid'],original_start_ticks=prior.get('start_ticks'),current_start_ticks=current,original_alive=current==prior.get('start_ticks'),state=fields[0]))
                except FileNotFoundError:targets.append(dict(pid=prior['pid'],original_alive=False))
            result=dict(label=label,targets=targets,all_original_processes_gone=all(not r['original_alive'] for r in targets),resources=resources(g))
            g.new_file(base+'/reports/cancel-status-'+sample+'.json',encoded(result))
        elif op=='compiler-symbol':
            label=identifier(request['label']);sample=identifier(request['sample']);offset=request['offset']
            if type(offset) is not int or offset<0:raise ValueError('Nonnegative executable offset required')
            runtime=json.loads(g.read('runs/f56-20261018t090815z-2c037d10/reports/icarus-runtime.json',None))
            row=next(r for r in runtime['files'] if r['path']=='libexec/ivl');path=runtime['base']+'/libexec/ivl'
            if sha(g.read(path,None))!=row['sha256']:raise ValueError('Icarus executable hash changed')
            done=subprocess.run(['/usr/bin/readelf','-Ws',WORKSPACE+'/'+path],capture_output=True)
            matches=[]
            for line in done.stdout.decode(errors='replace').splitlines():
                parts=line.split()
                if len(parts)>=8 and parts[3]=='FUNC':
                    start=int(parts[1],16);size=int(parts[2])
                    if start<=offset<start+size:matches.append(dict(name=parts[7],start=start,size=size))
            for item in matches:
                demangled=subprocess.run(['/usr/bin/c++filt',item['name']],capture_output=True);item['demangled']=demangled.stdout.decode().strip()
            result=dict(offset=offset,matches=matches,executable_sha256=row['sha256'],exit_code=done.returncode,stderr=done.stderr.decode(errors='replace'))
            g.new_file(base+'/reports/'+label+'/symbol-'+sample+'.json',encoded(result))
        elif op=='compiler-stack':
            import shutil
            label=identifier(request['label']);sample=identifier(request['sample']);target=base+'/reports/'+label
            monitor=g.read(target+'/compiler-resources.jsonl',None).decode().splitlines()
            rows=json.loads(monitor[-1])['processes'];candidates=[r for r in rows if '/libexec/ivl ' in r['cmdline']]
            if len(candidates)!=1:raise ValueError('One active private Icarus worker required')
            pid=candidates[0]['pid'];live=Path('/proc/'+str(pid)+'/cmdline').read_bytes().replace(b'\0',b' ').decode()
            if live!=candidates[0]['cmdline'] or WORKSPACE not in live:raise ValueError('Compiler identity changed')
            if not Path('/usr/bin/gdb').is_file():result=dict(status='GDB_UNAVAILABLE',pid=pid,install_attempted=False)
            else:
                directory=WORKSPACE+'/'+base+'/work/'+label
                command=['/usr/bin/gdb','-nx','-nh','-batch','-iex','set auto-load off','-iex','set debuginfod enabled off','-ex','attach '+str(pid),'-ex','bt 12','-ex','detach']
                if request.get('symbols'):
                    import re
                    mappings=(Path('/proc')/str(pid)/'maps').read_text().splitlines()
                    matching=[line.split() for line in mappings if line.split()[-1].endswith('/libexec/ivl')]
                    executable=matching[0][-1]
                    if not executable.startswith(WORKSPACE+'/'):raise ValueError('Private executable required')
                    image=min(int(row[0].split('-')[0],16)-int(row[2],16) for row in matching)
                    sections=subprocess.run(['/usr/bin/readelf','-WS',executable],capture_output=True)
                    text=re.search(r'\]\s+\.text\s+PROGBITS\s+([0-9a-fA-F]+)',sections.stdout.decode())
                    if not text:raise ValueError('Executable text section unavailable')
                    command[8:8]=['-ex','add-symbol-file '+executable+' '+hex(image+int(text[1],16))]
                if request.get('instructions'):
                    command[-2:-2]=['-ex','info proc mappings','-ex','x/12i $pc']
                if request.get('connection'):
                    command[-2:-2]=['-ex','set print elements 12','-ex','frame 2','-ex','p *sig','-ex','frame 5','-ex','p *this']
                if request.get('event'):
                    command[-2:-2]=['-ex','set print elements 12','-ex','frame 2','-ex','p *this','-ex','info locals']
                if request.get('ports'):
                    command[-2:-2]=['-ex','set print elements 12','-ex','frame 2','-ex','info args','-ex','info locals','-ex','p *scop','-ex','frame 1','-ex','info args','-ex','info locals','-ex','p *scop']
                done=subprocess.run(command,cwd=directory,env=dict(os.environ,HOME=directory,XDG_CACHE_HOME=directory,TMPDIR=directory),capture_output=True)
                result=dict(status='STACK_SAMPLED' if done.returncode==0 else 'STACK_UNAVAILABLE',pid=pid,argv=command,exit_code=done.returncode,stdout=done.stdout.decode(errors='replace'),stderr=done.stderr.decode(errors='replace'))
            g.new_file(target+'/stack-'+sample+'.json',encoded(result))
        elif op=='backend-hotspot':
            label=identifier(request['label']);sample=identifier(request['sample']);target=base+'/reports/'+label
            rows=json.loads(g.read(target+'/compiler-resources.jsonl',None).decode().splitlines()[-1])['processes']
            candidates=[r for r in rows if '/libexec/yosys ' in r['cmdline']]
            if len(candidates)!=1:raise ValueError('One active private native Yosys required')
            pid=candidates[0]['pid'];proc=Path('/proc')/str(pid)
            live=(proc/'cmdline').read_bytes().replace(b'\0',b' ').decode()
            if live!=candidates[0]['cmdline'] or WORKSPACE+'/' not in live or proc.stat().st_uid!=os.geteuid():raise ValueError('Private Yosys identity changed')
            before=(proc/'stat').read_text();tasks=[]
            for task in (proc/'task').iterdir():
                tasks.append(dict(tid=task.name,stat=(task/'stat').read_text(),schedstat=(task/'schedstat').read_text()))
            result=dict(pid=pid,cmdline=live,proc_stat=before,threads=tasks,status=(proc/'status').read_text(),io=(proc/'io').read_text(),resources=resources(g))
            if Path('/usr/bin/gdb').is_file():
                command=['/usr/bin/gdb','-nx','-nh','-batch','-iex','set auto-load off','-iex','set debuginfod enabled off','-ex','attach '+str(pid),'-ex','bt 16','-ex','detach']
                import re
                matching=[line.split() for line in (proc/'maps').read_text().splitlines() if line.split()[-1].endswith('/libexec/yosys')]
                if matching:
                    executable=matching[0][-1]
                    if not executable.startswith(WORKSPACE+'/'):raise ValueError('Private Yosys symbols required')
                    image=min(int(row[0].split('-')[0],16)-int(row[2],16) for row in matching)
                    sections=subprocess.run(['/usr/bin/readelf','-WS',executable],capture_output=True)
                    section=re.search(r'\]\s+\.text\s+PROGBITS\s+([0-9a-fA-F]+)',sections.stdout.decode())
                    if section:command[8:8]=['-ex','add-symbol-file '+executable+' '+hex(image+int(section[1],16))]
                done=subprocess.run(command,cwd=WORKSPACE+'/'+target,capture_output=True)
                result['stack']=dict(argv=command,exit_code=done.returncode,stdout=done.stdout.decode(errors='replace'),stderr=done.stderr.decode(errors='replace'))
            else:result['stack']=dict(status='GDB_UNAVAILABLE')
            after=(proc/'stat').read_text()
            if before.rsplit(')',1)[1].split()[19]!=after.rsplit(')',1)[1].split()[19]:raise ValueError('Yosys process replaced during sample')
            g.new_file(target+'/hotspot-'+sample+'.json',encoded(result))
        elif op=='backend-diagnose':
            parent=base+'/reports/'+identifier(request['label'])+'/'+identifier(request['top'])+'/translation'
            attempt=g.listing(parent)[0]['name'];module=json.loads(g.read(parent+'/'+attempt+'/artifacts/unconstrained.json',None))['modules'][request['top']+'__scalable']
            rows=[]
            for name,c in module['cells'].items():
                if c['type']!='$anyseq':continue
                bits=set(c['connections']['Y']);nets=[n for n,w in module['netnames'].items() if bits.intersection(w['bits'])]
                uses=[dict(name=n,type=v['type'],ports=[p for p,b in v['connections'].items() if bits.intersection(b)],attributes=v['attributes'],connections=v['connections']) for n,v in module['cells'].items() if n!=name and any(bits.intersection(b) for b in v['connections'].values())]
                rows.append(dict(cell=name,nets=nets,uses=uses[:4]))
            result=dict(count=len(rows),examples=rows[:5])
        elif op=='rtl-witness':
            import stat
            label=identifier(request['label']);name=base+'/reports/'+label+'/encoded.sv'
            center=request['line']
            if type(center) is not int or center<1:raise ValueError('Positive RTL line required')
            with g.directory(name.rsplit('/',1)[0]) as parent:
                fd=os.open('encoded.sv',os.O_RDONLY|os.O_NOFOLLOW|os.O_NOATIME,dir_fd=parent)
            info=os.fstat(fd)
            if not stat.S_ISREG(info.st_mode) or info.st_uid!=os.geteuid() or info.st_dev!=g.device:raise ValueError('Owned regular RTL required')
            rows=[]
            with os.fdopen(fd,'r',encoding='ascii') as stream:
                for line,text in enumerate(stream,1):
                    if center-2<=line<=center+2:rows.append(dict(line=line,bytes=len(text),sha256=sha(text.encode()),prefix=text[:1600],suffix=text[-400:],logical_or_terms=text.count(' || '),add_terms=text.count(' + ')))
                    if line>=center+2:break
            result=dict(path=name,rows=rows)
            g.new_file(base+'/reports/'+label+'-line-'+str(center)+'.json',encoded(result))
        elif op=='compare-backend-artifacts':
            from fourstate_sync_common import relative
            import stat,hashlib
            pairs=request['pairs'];rows=[]
            if len(pairs)!=7:raise ValueError('Exactly seven public backend artifacts required')
            for pair in pairs:
                descriptors=[]
                try:
                    for name in pair:
                        parts=relative(name)
                        if parts[0]!='reports':raise ValueError('Only private current-run reports admitted')
                        with g.directory(base+'/'+'/'.join(parts[:-1])) as parent:
                            fd=os.open(parts[-1],os.O_RDONLY|os.O_NOFOLLOW|os.O_NOATIME,dir_fd=parent)
                        descriptors.append(fd);info=os.fstat(fd)
                        if not stat.S_ISREG(info.st_mode) or info.st_uid!=os.geteuid() or info.st_dev!=g.device or info.st_nlink!=1:raise ValueError('Owned single-link artifact required')
                    same=True;count=0;hashes=[hashlib.sha256(),hashlib.sha256()]
                    while True:
                        blocks=[os.read(fd,1024*1024) for fd in descriptors]
                        same=same and blocks[0]==blocks[1]
                        for h,block in zip(hashes,blocks):h.update(block)
                        count+=len(blocks[0])
                        if not any(blocks):break
                    rows.append(dict(paths=pair,bytes=count,byte_identical=same,sha256=[h.hexdigest() for h in hashes]))
                finally:
                    for fd in descriptors:os.close(fd)
            result=dict(status='SEVEN_ARTIFACTS_BYTE_IDENTICAL' if all(r['byte_identical'] for r in rows) else 'ARTIFACT_MISMATCH',files=rows)
            g.new_file(base+'/reports/'+identifier(request['label'])+'.json',encoded(result))
        elif op=='run-processes':
            rows=[]
            for proc in Path('/proc').iterdir():
                if not proc.name.isdigit():continue
                try:
                    if proc.stat().st_uid!=os.geteuid():continue
                    command=(proc/'cmdline').read_bytes().replace(b'\0',b' ').decode(errors='replace')
                    if WORKSPACE not in command:continue
                    rows.append(dict(pid=int(proc.name),cmdline=command,status=[line for line in (proc/'status').read_text().splitlines() if line.startswith(('State:','VmRSS:','VmHWM:'))]))
                except (FileNotFoundError,PermissionError,ProcessLookupError):pass
            result=dict(processes=rows,resources=resources(g))
            g.new_file(base+'/reports/run-processes-'+identifier(request['sample'])+'.json',encoded(result))
        elif op=='runtime-modules':
            runtime=json.loads(g.read(base+'/reports/environment/runtime.json',None))
            executable=WORKSPACE+'/'+runtime['base']+'/python/bin/python3.11'
            code="import importlib.util,json,shutil,sys\nrows={}\nfor n in ('ijson','ijson.backends.python','ijson.backends.yajl2_c','orjson'):\n try:\n  s=importlib.util.find_spec(n);rows[n]=None if s is None else s.origin\n except ImportError:rows[n]=None\nprint(json.dumps(dict(python=sys.version,modules=rows,commands={n:shutil.which(n) for n in ('jq','gcc','g++')})))"
            done=subprocess.run([executable,'-I','-B','-c',code],cwd=WORKSPACE+'/'+base,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
            result=dict(argv=[executable,'-I','-B','-c',code],exit_code=done.returncode,stdout=done.stdout.decode(),stderr=done.stderr.decode(),resources=resources(g))
            g.new_file(base+'/reports/runtime-modules-'+identifier(request['sample'])+'.json',encoded(result))
        elif op=='threeway-tools':
            # Reuse only the already-owned, hash-receipted Lean runtime.
            old='runs/f45-memory-20261017t173407z-1118f143/linux'
            receipt=json.loads(g.read(old+'/runtime-receipt.json',None));verified=[]
            for row in receipt['files']:
                if not row['copy'].startswith(old+'/tool/lean/'):continue
                data=g.read(row['copy'],None)
                if sha(data)!=row['sha256']:raise ValueError('Private Lean runtime changed: '+row['copy'])
                verified.append(dict(path=row['copy'],bytes=len(data),sha256=row['sha256']))
            lean=WORKSPACE+'/'+old+'/tool/lean/bin/lean'
            if not any(r['path']==old+'/tool/lean/bin/lean' for r in verified):raise ValueError('Lean executable missing from receipt')
            version=subprocess.run([lean,'--version'],cwd=WORKSPACE+'/'+base,stdout=subprocess.PIPE,stderr=subprocess.PIPE,
                env=dict(os.environ,LEAN_SYSROOT=WORKSPACE+'/'+old+'/tool/lean',HOME=WORKSPACE+'/'+base,TMPDIR=WORKSPACE+'/'+base))
            result=dict(status='VERIFIED' if version.returncode==0 else 'VERSION_FAILED',lean=lean,files=verified,
                argv=version.args,exit_code=version.returncode,stdout=version.stdout.decode(errors='replace'),stderr=version.stderr.decode(errors='replace'),resources=resources(g))
            g.new_file(base+'/reports/threeway-tools.json',encoded(result))
        elif op=='workspace-cache-inventory':
            import ctypes,stat
            scope=request.get('scope','current-run')
            if scope not in ('current-run','private-runs','private-workspace'):raise ValueError('Only explicitly owned private workspace admitted')
            root=base if scope=='current-run' else ('runs' if scope=='private-runs' else '')
            active=set()
            for proc in Path('/proc').iterdir():
                if not proc.name.isdigit():continue
                try:
                    if proc.stat().st_uid!=os.geteuid():continue
                    for fd in (proc/'fd').iterdir():
                        try:
                            name=os.readlink(fd)
                            if name.startswith(WORKSPACE+'/'):active.add(name)
                        except (FileNotFoundError,PermissionError,ProcessLookupError):pass
                    for line in (proc/'maps').read_text().splitlines():
                        fields=line.split(None,5)
                        if len(fields)==6 and fields[5].startswith(WORKSPACE+'/'):active.add(fields[5])
                except (FileNotFoundError,PermissionError,ProcessLookupError):pass
            library=ctypes.CDLL(None,use_errno=True)
            library.mmap.restype=ctypes.c_void_p
            library.mmap.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_longlong]
            library.mincore.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_void_p]
            library.munmap.argtypes=[ctypes.c_void_p,ctypes.c_size_t]
            page=os.sysconf('SC_PAGESIZE');rows=[];counts=dict(regular=0,empty=0,nonregular=0,unsafe=0,changed=0,unavailable=0)
            def walk(directory):
                try:entries=g.listing(directory)
                except (FileNotFoundError,PermissionError):counts['unavailable']+=1;return
                for entry in entries:
                    name=(directory+'/' if directory else '')+entry['name']
                    if stat.S_ISDIR(entry['mode']):walk(name);continue
                    if not stat.S_ISREG(entry['mode']):counts['nonregular']+=1;continue
                    fd=None;address=None
                    try:
                        with g.directory(directory) as parent:
                            fd=os.open(entry['name'],os.O_RDONLY|os.O_NOFOLLOW|os.O_NOATIME|os.O_NONBLOCK,dir_fd=parent)
                        before=os.fstat(fd)
                        if not stat.S_ISREG(before.st_mode) or before.st_uid!=os.geteuid() or before.st_dev!=g.device or before.st_nlink!=1:counts['unsafe']+=1;continue
                        counts['regular']+=1
                        if not before.st_size:counts['empty']+=1;continue
                        address=library.mmap(None,before.st_size,0,1,fd,0)
                        if address==ctypes.c_void_p(-1).value:raise OSError(ctypes.get_errno(),'mmap failed')
                        vector=(ctypes.c_ubyte*((before.st_size+page-1)//page))()
                        if library.mincore(address,before.st_size,vector):raise OSError(ctypes.get_errno(),'mincore failed')
                        resident=min(before.st_size,sum(bool(value&1) for value in vector)*page)
                        after=os.fstat(fd)
                        stable=all(getattr(before,k)==getattr(after,k) for k in ('st_dev','st_ino','st_size','st_mtime_ns','st_ctime_ns'))
                        if not stable:counts['changed']+=1
                        if resident:
                            full=WORKSPACE+'/'+name
                            rows.append(dict(path=name,bytes=before.st_size,resident_bytes=resident,inode=before.st_ino,mtime_ns=before.st_mtime_ns,ctime_ns=before.st_ctime_ns,active=full in active,stable=stable))
                    except (FileNotFoundError,PermissionError,ProcessLookupError):counts['unavailable']+=1
                    finally:
                        if address is not None and address!=ctypes.c_void_p(-1).value:library.munmap(address,before.st_size)
                        if fd is not None:os.close(fd)
            walk(root)
            result=dict(scope=root,files=sorted(rows,key=lambda row:row['resident_bytes'],reverse=True),counts=counts,
                resident_bytes=sum(r['resident_bytes'] for r in rows),
                eligible_resident_bytes=sum(r['resident_bytes'] for r in rows if r['stable'] and not r['active']),
                method='Read-only owned private-run mincore inventory; no data reads or cache changes; active open/mapped files marked',resources=resources(g))
            g.new_file(base+'/reports/workspace-cache-'+identifier(request['sample'])+'.json',encoded(result))
        elif op=='release-private-cache-inventory':
            import stat
            from fourstate_sync_remote import stamp
            from fourstate_sync_common import relative
            name=request['inventory'];parts=relative(name)
            if parts[0]!='reports' or not parts[-1].startswith('workspace-cache-'):raise ValueError('Sealed private cache inventory required')
            raw=g.read(base+'/'+name,None);inventory=json.loads(raw)
            if not inventory['method'].startswith('Read-only owned private-run mincore'):raise ValueError('Unknown cache inventory')
            excluded=[]
            for prefix in request.get('exclude_prefixes',[]):
                relative(prefix);excluded.append(prefix.rstrip('/')+'/')
            active=set()
            for proc in Path('/proc').iterdir():
                if not proc.name.isdigit():continue
                try:
                    if proc.stat().st_uid!=os.geteuid():continue
                    for fd in (proc/'fd').iterdir():
                        try:active.add(os.readlink(fd))
                        except (FileNotFoundError,PermissionError,ProcessLookupError):pass
                    for line in (proc/'maps').read_text().splitlines():
                        fields=line.split(None,5)
                        if len(fields)==6:active.add(fields[5])
                except (FileNotFoundError,PermissionError,ProcessLookupError):pass
            def usage():
                root=Path('/sys/fs/cgroup/memory/user.slice/user-1025.slice')
                return {n:(root/n).read_text() for n in ('memory.usage_in_bytes','memory.failcnt','memory.oom_control','memory.stat')}
            before=usage();released=[];skipped=[]
            for row in inventory['files']:
                path=row['path'];parts=relative(path)
                if not row['stable'] or row['active'] or WORKSPACE+'/'+path in active or any(path.startswith(prefix) for prefix in excluded):
                    skipped.append(dict(path=path,reason='active, mutable, or excluded live task'));continue
                fd=None
                try:
                    with g.directory('/'.join(parts[:-1])) as parent:
                        fd=os.open(parts[-1],os.O_RDONLY|os.O_NOFOLLOW|os.O_NOATIME|os.O_NONBLOCK,dir_fd=parent)
                    info=os.fstat(fd)
                    if not stat.S_ISREG(info.st_mode) or info.st_dev!=g.device or info.st_uid!=os.geteuid() or info.st_nlink!=1:raise ValueError('Owned same-device single-link file required')
                    if (info.st_ino,info.st_size,info.st_mtime_ns,info.st_ctime_ns)!=(row['inode'],row['bytes'],row['mtime_ns'],row['ctime_ns']):
                        skipped.append(dict(path=path,reason='metadata changed since read-only inventory'));continue
                    os.fdatasync(fd);os.posix_fadvise(fd,0,0,os.POSIX_FADV_DONTNEED)
                    after=os.fstat(fd)
                    if stamp(after)!=stamp(info):raise ValueError('File metadata changed during cache advice')
                    released.append(dict(path=path,bytes=info.st_size,inode=info.st_ino,previous_resident_bytes=row['resident_bytes']))
                except FileNotFoundError:skipped.append(dict(path=path,reason='file no longer at inventoried path'))
                finally:
                    if fd is not None:os.close(fd)
            result=dict(inventory=name,inventory_sha256=sha(raw),before=before,after=usage(),files=released,skipped=skipped,
                previously_resident_bytes=sum(r['previous_resident_bytes'] for r in released),
                policy='User-authorized scoped private-workspace cache advice; no data deletion, shared-project access, global cache changes, or cgroup edits',resources=resources(g))
            g.new_file(base+'/reports/private-cache-release-'+identifier(request['sample'])+'.json',encoded(result))
        elif op=='release-artifact-cache':
            import sys
            from fourstate_sync_common import relative
            snap=identifier(request['snapshot_id']);verified=verify_release(g,snap)
            sys.path.insert(0,WORKSPACE+'/releases/'+snap+'/src/scripts')
            from fourstate_backend_cache import advise
            def usage():
                root=Path('/sys/fs/cgroup/memory/user.slice/user-1025.slice')
                return {n:(root/n).read_text() for n in ('memory.usage_in_bytes','memory.failcnt','memory.oom_control','memory.stat')}
            before=usage();rows=[]
            for name in request['paths']:
                parts=relative(name)
                if parts[0]!='reports':raise ValueError('Private current-run reports only')
                rows.append(advise(Path(WORKSPACE)/base/name,Path(WORKSPACE)/base))
            result=dict(snapshot=verified,before=before,after=usage(),files=rows,
                policy='Explicit owned private artifact file cache only; no deletion, cgroup edit, or global drop_caches',resources=resources(g))
            g.new_file(base+'/reports/cache-release-'+identifier(request['sample'])+'.json',encoded(result))
        elif op=='artifact-cache-residency':
            import ctypes,stat
            from fourstate_sync_common import relative
            library=ctypes.CDLL(None,use_errno=True)
            library.mmap.restype=ctypes.c_void_p
            library.mmap.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_longlong]
            library.mincore.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_void_p]
            library.munmap.argtypes=[ctypes.c_void_p,ctypes.c_size_t]
            page=os.sysconf('SC_PAGESIZE');rows=[]
            for name in request['paths']:
                parts=relative(name)
                if parts[0]!='reports':raise ValueError('Current private run reports only')
                with g.directory(base+'/'+'/'.join(parts[:-1])) as parent:
                    fd=os.open(parts[-1],os.O_RDONLY|os.O_NOFOLLOW|os.O_NOATIME,dir_fd=parent)
                address=None
                try:
                    info=os.fstat(fd)
                    if not stat.S_ISREG(info.st_mode) or info.st_uid!=os.geteuid() or info.st_dev!=g.device or info.st_nlink!=1:raise ValueError('Owned single-link regular artifact required')
                    if not info.st_size:rows.append(dict(path=name,bytes=0,resident_bytes=0));continue
                    address=library.mmap(None,info.st_size,0,1,fd,0)
                    if address==ctypes.c_void_p(-1).value:raise OSError(ctypes.get_errno(),'mmap failed')
                    count=(info.st_size+page-1)//page
                    vector=(ctypes.c_ubyte*count)()
                    if library.mincore(address,info.st_size,vector):raise OSError(ctypes.get_errno(),'mincore failed')
                    resident=sum(bool(value&1) for value in vector)*page
                    rows.append(dict(path=name,bytes=info.st_size,resident_bytes=min(info.st_size,resident)))
                finally:
                    if address is not None and address!=ctypes.c_void_p(-1).value:library.munmap(address,info.st_size)
                    os.close(fd)
            result=dict(files=rows,method='Read-only mincore with PROT_NONE mappings; no file data read, cache eviction, or policy modification',resources=resources(g))
            g.new_file(base+'/reports/artifact-cache-'+identifier(request['sample'])+'.json',encoded(result))
        elif op=='resource-limits':
            import resource
            group=Path('/proc/self/cgroup').read_text();rows=[]
            for line in group.splitlines():
                if not line.startswith('0::'):continue
                root=Path('/sys/fs/cgroup');current=root/line[3:].lstrip('/')
                current.resolve().relative_to(root.resolve())
                for directory in (current,*current.parents):
                    if directory!=root and root not in directory.parents:break
                    data={}
                    for name in ('memory.max','memory.high','memory.current','memory.events','memory.stat','cpu.max','pids.max'):
                        try:data[name]=(directory/name).read_text()
                        except (FileNotFoundError,PermissionError):pass
                    rows.append(dict(path=str(directory),values=data))
                    if directory==root:break
            for line in group.splitlines():
                parts=line.split(':',2)
                if len(parts)!=3 or 'memory' not in parts[1].split(','):continue
                root=Path('/sys/fs/cgroup/memory');current=root/parts[2].lstrip('/')
                current.resolve().relative_to(root.resolve())
                for directory in (current,*current.parents):
                    if directory!=root and root not in directory.parents:break
                    data={}
                    for name in ('memory.limit_in_bytes','memory.memsw.limit_in_bytes','memory.usage_in_bytes','memory.max_usage_in_bytes','memory.failcnt','memory.oom_control','memory.stat'):
                        try:data[name]=(directory/name).read_text()
                        except (FileNotFoundError,PermissionError):pass
                    rows.append(dict(controller='memory-v1',path=str(directory),values=data))
                    if directory==root:break
            result=dict(cgroup=group,controllers=rows,rlimits={n:resource.getrlimit(getattr(resource,n)) for n in ('RLIMIT_CPU','RLIMIT_AS','RLIMIT_DATA','RLIMIT_STACK','RLIMIT_FSIZE')},resources=resources(g))
            g.new_file(base+'/reports/resource-limits-'+identifier(request['label'])+'.json',encoded(result))
        elif op=='cleanup-exact-duplicates':
            import stat,hashlib
            from fourstate_sync_common import relative
            from fourstate_sync_remote import stamp
            label=identifier(request['label']);rows=[]
            allowed={'xstop-backend-endtoend-v9','xstop-backend-stream-v12','xstop-backend-compact-v4','xstop-backend-archive-v2','xstop-backend-selector-v5','xstop-backend-selector-v5-after-trace','xstop-backend-guard-v6b','xstop-backend-commit-v7'}
            active=set()
            for proc in Path('/proc').iterdir():
                if not proc.name.isdigit():continue
                try:
                    if proc.stat().st_uid!=os.geteuid():continue
                    for fd in (proc/'fd').iterdir():
                        try:active.add(os.readlink(fd))
                        except (FileNotFoundError,PermissionError,ProcessLookupError):pass
                    for line in (proc/'maps').read_text().splitlines():
                        fields=line.split(None,5)
                        if len(fields)==6:active.add(fields[5])
                except (FileNotFoundError,PermissionError,ProcessLookupError):pass
            initial=resources(g)
            for item in request['files']:
                name=item['path'];replacement=item['replacement'];parts=relative(name);rep=relative(replacement)
                if len(parts)!=6 or parts[0]!='reports' or parts[1] not in allowed or parts[2]!='translation' or parts[4]!='artifacts':raise ValueError('Explicit stopped backend artifact required')
                if parts[-1] not in ('before.il','before.json.gz','design.v'):raise ValueError('Only duplicate backend inputs admitted')
                if rep[0]!='reports' or name==replacement or 'xstop-backend-cache-v17' in parts or 'xstop-backend-cache-v17' in rep:raise ValueError('Keep live task isolated')
                if WORKSPACE+'/'+base+'/'+name in active:raise ValueError('Source is open or mapped by a live process')
                handles=[]
                try:
                    for path in (parts,rep):
                        with g.directory(base+'/'+'/'.join(path[:-1])) as parent:fd=os.open(path[-1],os.O_RDONLY|os.O_NOFOLLOW|os.O_NOATIME|os.O_NONBLOCK,dir_fd=parent)
                        handles.append(fd)
                    source,twin=handles;before=os.fstat(source);other=os.fstat(twin)
                    for info in (before,other):
                        if not stat.S_ISREG(info.st_mode) or info.st_uid!=os.geteuid() or info.st_dev!=g.device or info.st_nlink!=1:raise ValueError('Owned private regular single-link file required')
                    if before.st_size!=item['bytes'] or other.st_size!=before.st_size or before.st_ino==other.st_ino:raise ValueError('Duplicate identity or size mismatch')
                    digest=hashlib.sha256();offset=0
                    while True:
                        block=os.read(source,1024*1024);copy=os.read(twin,1024*1024)
                        if block!=copy:raise ValueError('Duplicate bytes differ')
                        if not block:break
                        digest.update(block);offset+=len(block)
                        # Reclaim only clean pages already read, keeping cache pressure bounded.
                        os.posix_fadvise(source,0,offset,os.POSIX_FADV_DONTNEED)
                        os.posix_fadvise(twin,0,offset,os.POSIX_FADV_DONTNEED)
                    if stamp(os.fstat(source))!=stamp(before) or stamp(os.fstat(twin))!=stamp(other):raise ValueError('Duplicate changed while comparing')
                    with g.directory(base+'/'+'/'.join(rep[:-1])) as parent:
                        if stamp(os.stat(rep[-1],dir_fd=parent,follow_symlinks=False))!=stamp(other):raise ValueError('Replacement path changed')
                    row=dict(path=name,bytes=before.st_size,sha256=digest.hexdigest(),replacement=replacement,comparison='BYTE_FOR_BYTE',restore='Copy retained replacement to original path',reason=item['reason'])
                    with g.directory(base+'/'+'/'.join(parts[:-1])) as parent:
                        if stamp(os.stat(parts[-1],dir_fd=parent,follow_symlinks=False))!=stamp(before):raise ValueError('Source path changed')
                        g.new_file(base+'/reports/cleanup-'+label+'-'+str(len(rows))+'.json',encoded(dict(action='DELETE_EXACT_DUPLICATE',user_authorized=True,file=row)))
                        os.unlink(parts[-1],dir_fd=parent);os.fsync(parent)
                    rows.append(row)
                finally:
                    for fd in handles:os.close(fd)
            result=dict(status='EXACT_DUPLICATES_REMOVED',files=rows,deleted_bytes=sum(r['bytes'] for r in rows),resources_before=initial,resources=resources(g))
            g.new_file(base+'/reports/cleanup-'+label+'-summary.json',encoded(result))
        elif op=='cleanup-intermediates':
            import stat,hashlib
            from fourstate_sync_common import relative
            from fourstate_sync_remote import stamp
            # Exact file list only. Never recurse or remove a directory.
            label=identifier(request['label']);rows=[]
            allowed=('xstop-backend-v1','xstop-backend-shallow-v2','xstop-backend-compact-v4','xstop-encode-v1','xstop-encode-shallow-v2','xstop-inline-v3')
            for item in request['files']:
                name=item['path'];parts=relative(name)
                if len(parts)<3 or parts[0]!='reports' or parts[1] not in allowed:raise ValueError('Cleanup path not whitelisted')
                if parts[-1] not in ('encoded.sv','design.v','kernel-body.svpart','unconstrained.il','unconstrained.json','before.il','before.json'):raise ValueError('Cleanup file kind not whitelisted')
                if parts[-1] in ('before.il','before.json'):
                    expected='reports/xstop-backend-compact-v4/translation/20261018T122853Z-3f90db28/artifacts/'+parts[-1]
                    replacement='reports/xstop-backend-archive-v2/translation/20261018T133811Z-fc9a1b7d/artifacts/'+parts[-1]+('.gz' if parts[-1]=='before.json' else '')
                    if name!=expected or item.get('replacement')!=replacement:raise ValueError('Only exact stopped-attempt checkpoint duplicates admitted')
                elif parts[1]=='xstop-backend-compact-v4' and parts[-1] not in ('unconstrained.il','unconstrained.json'):raise ValueError('Keep staged source')
                with g.directory(base+'/'+'/'.join(parts[:-1])) as parent:
                    fd=os.open(parts[-1],os.O_RDONLY|os.O_NOFOLLOW|os.O_NOATIME|os.O_NONBLOCK,dir_fd=parent)
                    try:
                        before=os.fstat(fd)
                        if not stat.S_ISREG(before.st_mode) or before.st_uid!=os.geteuid() or before.st_dev!=g.device or before.st_nlink!=1 or before.st_size!=item['bytes']:raise ValueError('Cleanup file identity changed')
                        digest=hashlib.sha256()
                        while True:
                            chunk=os.read(fd,1024*1024)
                            if not chunk:break
                            digest.update(chunk)
                        if stamp(os.fstat(fd))!=stamp(before) or stamp(os.stat(parts[-1],dir_fd=parent,follow_symlinks=False))!=stamp(before):raise ValueError('Cleanup target changed')
                        row=dict(path=name,bytes=before.st_size,sha256=digest.hexdigest(),reason=item['reason'])
                        if item.get('replacement'):
                            import gzip
                            rep=relative(item['replacement'])
                            with g.directory(base+'/'+'/'.join(rep[:-1])) as other:
                                twin=os.open(rep[-1],os.O_RDONLY|os.O_NOFOLLOW|os.O_NOATIME|os.O_NONBLOCK,dir_fd=other)
                            with os.fdopen(twin,'rb') as raw:
                                twin_before=os.fstat(raw.fileno())
                                if not stat.S_ISREG(twin_before.st_mode) or twin_before.st_uid!=os.geteuid() or twin_before.st_dev!=g.device or twin_before.st_nlink!=1:raise ValueError('Unsafe replacement')
                                stream=gzip.GzipFile(fileobj=raw,mode='rb') if rep[-1].endswith('.gz') else raw
                                twin_hash=hashlib.sha256();count=0
                                while True:
                                    block=stream.read(1024*1024)
                                    if not block:break
                                    twin_hash.update(block);count+=len(block)
                                if stamp(os.fstat(raw.fileno()))!=stamp(twin_before) or count!=before.st_size or twin_hash.hexdigest()!=row['sha256']:raise ValueError('Replacement is not byte-exact')
                            row['replacement']=dict(path=item['replacement'],decoded_bytes=count,decoded_sha256=twin_hash.hexdigest(),restore='Decompress the .gz or copy the uncompressed canonical file back to the original logical path')
                            if stamp(os.fstat(fd))!=stamp(before) or stamp(os.stat(parts[-1],dir_fd=parent,follow_symlinks=False))!=stamp(before):raise ValueError('Cleanup source changed during replacement check')
                        g.new_file(base+'/reports/cleanup-'+label+'-'+str(len(rows))+'.json',encoded(dict(action='DELETE_REGENERABLE_INTERMEDIATE',file=row,user_authorized=True)))
                        os.unlink(parts[-1],dir_fd=parent);os.fsync(parent);rows.append(row)
                    finally:os.close(fd)
            result=dict(status='CLEANED_EXPLICIT_INTERMEDIATES',files=rows,deleted_bytes=sum(r['bytes'] for r in rows),resources=resources(g))
            g.new_file(base+'/reports/cleanup-'+label+'-summary.json',encoded(result))
        elif op=='storage-inventory':
            import stat
            rows=[];largest=[];nonregular=[]
            scope=request.get('scope','current-run')
            if scope not in ('current-run','private-workspace'):raise ValueError('Private storage scope required')
            inventory_root=base+'/reports' if scope=='current-run' else ''
            def walk(name):
                count=0;size=0
                for item in g.listing(name):
                    path=name+'/'+item['name']
                    if stat.S_ISDIR(item['mode']):
                        n,b=walk(path);count+=n;size+=b
                    elif stat.S_ISREG(item['mode']):
                        count+=1;size+=item['bytes'];largest.append(dict(path=path,bytes=item['bytes']))
                    else:nonregular.append(dict(path=path,mode=item['mode'],reason='Not followed'))
                return count,size
            for item in g.listing(inventory_root):
                if stat.S_ISDIR(item['mode']):
                    path=(inventory_root+'/' if inventory_root else '')+item['name'];n,b=walk(path);rows.append(dict(path=path,files=n,bytes=b))
            result=dict(directories=sorted(rows,key=lambda r:-r['bytes']),largest=sorted(largest,key=lambda r:-r['bytes'])[:50],nonregular=nonregular,resources=resources(g))
            g.new_file(base+'/reports/storage-inventory-'+identifier(request['label'])+'.json',encoded(result))
        elif op=='file-io-probe':
            import fcntl,hashlib
            label=identifier(request['label']);target=base+'/reports/'+label
            with g.directory(target,create=True,exclusive=True):pass
            payload=b'fourstate-private-cow-probe\n'*4096
            g.new_file(target+'/source.bin',payload)
            with g.directory(target) as parent:
                src=os.open('source.bin',os.O_RDONLY|os.O_NOFOLLOW|os.O_NOATIME,dir_fd=parent)
                dst=os.open('clone.bin',os.O_RDWR|os.O_CREAT|os.O_EXCL|os.O_NOFOLLOW,0o600,dir_fd=parent)
                try:
                    result=dict(status='REFLINK_UNAVAILABLE',resources=resources(g))
                    try:
                        fcntl.ioctl(dst,0x40049409,src)
                        os.fsync(dst)
                        before=os.fstat(src);after=os.fstat(dst)
                        clone=os.pread(dst,len(payload),0)
                        if clone!=payload or before.st_ino==after.st_ino or before.st_nlink!=1 or after.st_nlink!=1:raise ValueError('Unsafe clone result')
                        os.pwrite(dst,b'COW!',0);os.fsync(dst)
                        if os.pread(src,len(payload),0)!=payload:raise ValueError('Clone write changed source')
                        result.update(status='REFLINK_COW_PASS',bytes=len(payload),sha256=hashlib.sha256(clone).hexdigest(),independent_inodes=True,nlink=1,write_isolation=True)
                    except OSError as error:result.update(errno=error.errno,error=str(error))
                finally:os.close(src);os.close(dst)
            g.new_file(target+'/result.json',encoded(result))
        elif op=='storage-feasibility':
            import stat
            label=identifier(request['label']);attempt=identifier(request['attempt'])
            source=base+'/reports/'+label+'/translation/'+attempt+'/artifacts';rows=[]
            def inventory(path):
                for entry in g.listing(path):
                    target=path+'/'+entry['name']
                    if stat.S_ISDIR(entry['mode']):inventory(target)
                    elif stat.S_ISREG(entry['mode']):rows.append(dict(path=target,bytes=entry['bytes']))
                    else:raise ValueError('Unexpected nonregular backend artifact')
            inventory(source)
            try:
                g.listing(base+'/reports/'+label+'/model');fresh_output=False
            except FileNotFoundError:fresh_output=True
            filesystem=os.fstatvfs(g.root);required=sum(r['bytes'] for r in rows)
            available=filesystem.f_bavail*filesystem.f_frsize
            status=('CURRENT_COPY_FITS' if required<=available else 'MANDATORY_COPY_EXCEEDS_AVAILABLE_STORAGE') if fresh_output else 'OUTPUT_COPY_ALREADY_STARTED'
            result=dict(status=status,fresh_output=fresh_output,
                existing_artifact_bytes=required,available_filesystem_bytes=available,files=rows,
                backend_source_sha256=sha(g.read(base+'/work/backend-project/scripts/yosys2lean.py',None)),
                contract='Unchanged yosys2lean.py copies every artifact to the fresh --out directory at completion; this is a lower bound before further outputs. No added file-size or transfer cap.',
                captured_unix=time.time())
            g.new_file(base+'/reports/'+label+'/storage-feasibility-'+identifier(request['sample'])+'.json',encoded(result))
        elif op=='list-reports':
            from fourstate_sync_common import relative
            result=[]
            for name in request['paths']:
                relative(name)
                if not name.startswith('reports/'):raise ValueError('Only current-run report directories admitted')
                result.append(dict(path=name,entries=g.listing(base+'/'+name)))
        elif op=='inspect':
            from fourstate_sync_common import relative
            result=[]
            for name in request['paths']:
                relative(name)
                if not name.startswith('reports/'):raise ValueError('Only current-run reports may be inspected')
                data=g.read(base+'/'+name,None)
                text=data.decode(errors='replace')
                result.append(dict(path=name,sha256=sha(data),bytes=len(data),text=text if request.get('complete_text') else text[-6000:]))
        elif op=='backend-inspect':
            from audit_fourstate_remote import Reader
            import stat
            reader=Reader();root='.tools/oss-cad-suite-20261014';rows=[]
            try:
                for sub in ('bin','libexec','lib','share/yosys'):
                    rows.append(dict(path=sub,files=[x['name'] for x in reader.listing(root+'/'+sub) if sub!='libexec' or 'yosys' in x['name']]))
                value=reader.read(root+'/bin/yosys',float('inf'))
                result=dict(rows=rows,launcher=value)
            finally:os.close(reader.root)
        elif op=='inspect-icarus':
            previous='runs/f46-20261017t182304z-84b51ec0';old=previous+'/tool/iverilog-v3'
            receipt=json.loads(g.read(previous+'/reports/reference-runtime-v3.json',None))
            result=dict(receipt=receipt,configs={name:g.read(old+'/lib/ivl/'+name,None).decode() for name in ('vvp.conf','vvp-s.conf')})
        elif op=='complete-icarus-runtime':
            from audit_fourstate_remote import Reader
            import re
            old='runs/f46-20261017t182304z-84b51ec0/tool/iverilog-v3';receipt=json.loads(g.read('runs/f46-20261017t182304z-84b51ec0/reports/reference-runtime-v3.json',None))
            target=base+'/tool/iverilog-complete-v1';rows=[];seen=set()
            with g.directory(target,create=True,exclusive=True):pass
            def save(name,data,expected):
                if sha(data)!=expected:raise ValueError('Icarus runtime hash mismatch: '+name)
                g.new_file(target+'/'+name,data)
                if name.startswith(('bin/','libexec/')) or name in ('lib/ivl/ivl','lib/ivl/ivlpp','lib/ld-linux-x86-64.so.2'):os.chmod(WORKSPACE+'/'+target+'/'+name,0o700)
                seen.add(name);rows.append(dict(path=name,sha256=expected,bytes=len(data)))
            for row in receipt['files']:
                if not row['copy'].startswith(old+'/'):raise ValueError('Unexpected private Icarus path')
                name=row['copy'][len(old)+1:];save(name,g.read(row['copy'],None),row['sha256'])
            reader=Reader();root='.tools/oss-cad-suite-20261014'
            try:
                lock=json.loads(reader.read(root+'/chisel2lean-lock.json',float('inf'))['text']);hashes={r['name']:r['sha256'] for r in lock['files']}
                todo=['lib/ivl/'+n+'.vpi' for n in ('vhdl_sys','vhdl_textio','va_math')]
                while todo:
                    name=todo.pop()
                    if name in seen:continue
                    fd=reader.file(root+'/'+name)
                    try:
                        meta=subprocess.run(['/usr/bin/readelf','-d','/proc/self/fd/'+str(fd)],pass_fds=(fd,),stdout=subprocess.PIPE,stderr=subprocess.PIPE)
                        for lib in re.findall(rb'Shared library: \[([^]]+)\]',meta.stdout):todo.append('lib/'+lib.decode())
                        chunks=[]
                        while True:
                            chunk=os.read(fd,1024*1024)
                            if not chunk:break
                            chunks.append(chunk)
                    finally:os.close(fd)
                    save(name,b''.join(chunks),hashes[name])
                result=dict(base=target,files=rows,scope='Complete dependency closure of existing official Icarus assets; original verified executables unchanged; missing VHDL/VA plugins restored rather than ignored',original_lock_sha256=sha(reader.read(root+'/chisel2lean-lock.json',float('inf'))['text'].encode()))
                g.new_file(base+'/reports/icarus-runtime.json',encoded(result))
            finally:os.close(reader.root)
        elif op=='reuse-backend-runtime':
            previous='runs/'+identifier(request['source_run']);old=json.loads(g.read(previous+'/reports/backend-runtime.json',None))
            target=base+'/tool/yosys-'+identifier(request.get('runtime_label','v1'))
            with g.directory(target,create=True,exclusive=True):pass
            for row in old['files']:
                data=g.read(old['base']+'/'+row['path'],None)
                if sha(data)!=row['sha256']:raise ValueError('Private backend runtime changed')
                g.new_file(target+'/'+row['path'],data)
                if row['path'].startswith(('bin/','libexec/')) or row['path']=='lib/ld-linux-x86-64.so.2':os.chmod(WORKSPACE+'/'+target+'/'+row['path'],0o700)
            result=dict(old,base=target,source='SHA256-verified existing private runtime copy; collaborator project not accessed')
            g.new_file(base+'/reports/backend-runtime.json',encoded(result))
        elif op=='backend-runtime':
            from audit_fourstate_remote import Reader
            import stat,re
            reader=Reader();root='.tools/oss-cad-suite-20261014';target=base+'/tool/yosys-'+identifier(request.get('runtime_label','v2'))
            try:
                lock=json.loads(reader.read(root+'/chisel2lean-lock.json',float('inf'))['text'])
                hashes={r['name']:r['sha256'] for r in lock['files']}
                todo=['bin/yosys','libexec/yosys','lib/ld-linux-x86-64.so.2']
                todo += ['share/yosys/'+r['name'] for r in reader.listing(root+'/share/yosys') if stat.S_ISREG(r['mode'])]
                todo += ['share/yosys/plugins/'+r['name'] for r in reader.listing(root+'/share/yosys/plugins') if 'slang' in r['name'] and stat.S_ISREG(r['mode'])]
                with g.directory(target,create=True,exclusive=True):pass
                rows=[];seen=set()
                while todo:
                    name=todo.pop()
                    if name in seen:continue
                    seen.add(name)
                    fd=reader.file(root+'/'+name)
                    try:
                        result=subprocess.run(['/usr/bin/readelf','-d','/proc/self/fd/'+str(fd)],pass_fds=(fd,),stdout=subprocess.PIPE,stderr=subprocess.PIPE)
                        for lib in re.findall(rb'Shared library: \[([^]]+)\]',result.stdout):todo.append('lib/'+lib.decode())
                        chunks=[]
                        while True:
                            b=os.read(fd,1024*1024)
                            if not b:break
                            chunks.append(b)
                        data=b''.join(chunks)
                    finally:os.close(fd)
                    if sha(data)!=hashes[name]:raise ValueError('Native runtime lock mismatch: '+name)
                    g.new_file(target+'/'+name,data)
                    os.chmod(WORKSPACE+'/'+target+'/'+name,0o700 if name.startswith(('bin/','libexec/')) or name=='lib/ld-linux-x86-64.so.2' else 0o600)
                    rows.append(dict(path=name,sha256=sha(data),bytes=len(data)))
                version=subprocess.run([WORKSPACE+'/'+target+'/bin/yosys','-V'],cwd=WORKSPACE+'/'+base,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
                result=dict(base=target,files=rows,version=version.stdout.decode(),stderr=version.stderr.decode(),exit_code=version.returncode,public_lock_sha256=sha(reader.read(root+'/chisel2lean-lock.json',float('inf'))['text'].encode()),source='Verified existing official runtime; dependency-closure copy, no system installation')
                g.new_file(base+'/reports/backend-runtime.json',encoded(result))
            finally:os.close(reader.root)
        elif op=='backend-project':
            snap=identifier(request['snapshot_id']);verified=verify_release(g,snap);target=base+'/work/backend-project'
            with g.directory(target,create=True,exclusive=True):pass
            manifest=json.loads(g.read('releases/'+snap+'/manifest.json',None))
            copied=[]
            for row in manifest['files']:
                n=row['path']
                if not n.startswith('scripts/') and n!='lean/Chisel2Lean/Functional.lean':continue
                data=g.read('releases/'+snap+'/src/'+n,None)
                if sha(data)!=row['sha256']:raise ValueError('Backend source changed')
                g.new_file(target+'/'+n,data);copied.append(dict(path=n,sha256=sha(data)))
            runtime=json.loads(g.read(base+'/reports/backend-runtime.json',None));install=target+'/.tools/oss-cad-suite-20261014'
            for row in runtime['files']:
                data=g.read(runtime['base']+'/'+row['path'],None)
                if sha(data)!=row['sha256']:raise ValueError('Backend runtime changed')
                g.new_file(install+'/'+row['path'],data)
                if row['path'].startswith(('bin/','libexec/')) or row['path']=='lib/ld-linux-x86-64.so.2':os.chmod(WORKSPACE+'/'+install+'/'+row['path'],0o700)
            lock=dict(release='2026-10-14',archive_sha256='a6ccc6b96b2d985336a1061c78b2fd2bdd73e0f68690da17db88e00457881a11',yosys_version=runtime['version'].strip(),files=[dict(name=r['path'],sha256=r['sha256']) for r in runtime['files']],scope='Hash-verified Yosys dependency closure copied from existing installation',original_lock_sha256=runtime['public_lock_sha256'])
            g.new_file(install+'/chisel2lean-lock.json',encoded(lock))
            result=dict(project=target,source_snapshot=verified,source_files=copied,runtime=runtime['base'])
            g.new_file(base+'/reports/backend-project.json',encoded(result))
        elif op=='copy-reference':
            import stat
            old='runs/f53-20261018t061308z-4f19d009/reports/reference-supplement-v1';target=base+'/reports/reference-supplement-v1';rows=[]
            with g.directory(target,create=True,exclusive=True):pass
            def copy_reference(sub):
                for row in g.listing(old+('/'+sub if sub else '')):
                    path=(sub+'/' if sub else '')+row['name']
                    if stat.S_ISDIR(row['mode']):copy_reference(path)
                    elif stat.S_ISREG(row['mode']):
                        data=g.read(old+'/'+path,None);g.new_file(target+'/'+path,data);rows.append(dict(path=path,sha256=sha(data),bytes=len(data)))
                    else:raise ValueError('Nonregular historical reference')
            copy_reference('');result=dict(source=old,files=rows,scope='Frozen native reference only; all encoded RTL regenerated and executed')
            g.new_file(base+'/reports/reference-copy.json',encoded(result))
        elif op=='init':
            with g.directory(base,create=True,exclusive=True):pass
            for name in ('input-receipt.json','environment/runtime.json'):
                g.new_file(base+'/reports/'+name,g.read(OLD+'/reports/'+name,None))
            result=dict(status='INITIALIZED',resources=resources(g),frozen_input_root=OLD+'/reports/inputs')
            g.new_file(base+'/reports/preflight.json',encoded(result))
        elif op=='execute':
            snap=identifier(request['snapshot_id']);verified=verify_release(g,snap);label=identifier(request['label'])
            mode=request.get('mode','probe')
            worker=request.get('worker','verify_fourstate_f54')
            if worker not in ('verify_fourstate_f54','verify_fourstate_f55','verify_fourstate_f56','verify_fourstate_f57'):raise ValueError('Worker not explicitly whitelisted')
            if mode not in ('probe','inventory','tests','regressions','compare','scale','compat','faults','regenerate','audit','reseed'):raise ValueError('Unknown worker mode')
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
                'import sys,runpy;sys.path.insert(0,'+repr(source)+');runpy.run_path('+repr(source+'/'+worker+'.py')+',run_name="__main__")',
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
        elif op in ('index','index-stream'):
            import stat,hashlib
            from fourstate_sync_common import relative
            from fourstate_sync_remote import stamp
            rows=[];refused=[]
            def fingerprint(path):
                if op=='index':return sha(g.read(path,None))
                parts=relative(path)
                with g.directory('/'.join(parts[:-1])) as parent:
                    fd=os.open(parts[-1],os.O_RDONLY|os.O_NOFOLLOW|os.O_NOATIME|os.O_NONBLOCK,dir_fd=parent)
                try:
                    before=os.fstat(fd)
                    if not stat.S_ISREG(before.st_mode) or before.st_dev!=g.device or before.st_uid!=os.geteuid() or before.st_nlink!=1:raise ValueError('Owned same-device regular artifact required')
                    digest=hashlib.sha256();count=0
                    while True:
                        block=os.read(fd,1024*1024)
                        if not block:break
                        digest.update(block);count+=len(block)
                    if stamp(os.fstat(fd))!=stamp(before) or count!=before.st_size:raise ValueError('Artifact changed during streaming index')
                    return digest.hexdigest()
                finally:os.close(fd)
            def walk(name):
                for row in g.listing(base+'/'+name):
                    target=name+'/'+row['name']
                    if stat.S_ISDIR(row['mode']):walk(target)
                    elif stat.S_ISREG(row['mode']):rows.append(dict(path=target,bytes=row['bytes'],sha256=fingerprint(base+'/'+target)))
                    elif target.startswith('reports/tests-') and '/project/' in target:
                        refused.append(dict(path=target,mode=row['mode'],reason='Negative-test nonregular artifact; never followed or exported'))
                    else:raise ValueError('Unexpected nonregular evidence '+target)
            selected='reports/'+identifier(request['label']) if request.get('label') else 'reports'
            if request.get('top'):selected+='/'+identifier(request['top'])
            walk(selected);result=dict(files=rows,unrestricted=True,nonregular_test_artifacts=refused)
        elif op=='prepare-reference-stream':
            from fourstate_sync_common import relative,checksum
            label=identifier(request['label']);target=base+'/reports/'+label
            rows=request['files'];seen=set()
            if not rows:raise ValueError('Explicit reference file whitelist required')
            for row in rows:
                parts=relative(row['path']);checksum(row['sha256'])
                if row['path'] in seen or row['path'] in ('upload-manifest.json','receipt.json') or type(row['bytes']) is not int or row['bytes']<0:
                    raise ValueError('Invalid reference whitelist')
                seen.add(row['path'])
            filesystem=os.fstatvfs(g.root);available=filesystem.f_bavail*filesystem.f_frsize
            if sum(r['bytes'] for r in rows)>available:raise ValueError('Reference bytes exceed available filesystem space')
            with g.directory(target,create=True,exclusive=True):pass
            for row in rows:
                parent='/'.join(relative(row['path'])[:-1])
                with g.directory(target+('/'+parent if parent else ''),create=True):pass
            ticket=dict(files=rows,workspace_device=g.device,workspace_inode=g.inode)
            g.new_file(target+'/upload-manifest.json',encoded(ticket))
            result=dict(status='REFERENCE_STREAM_READY',root=WORKSPACE+'/'+target,files=rows)
        elif op=='seal-reference-stream':
            import stat,hashlib
            from fourstate_sync_common import relative
            from fourstate_sync_remote import stamp,exact_tree
            label=identifier(request['label']);target=base+'/reports/'+label
            ticket=json.loads(g.read(target+'/upload-manifest.json',None));rows=[]
            if (ticket['workspace_device'],ticket['workspace_inode'])!=(g.device,g.inode):raise ValueError('Reference workspace identity changed')
            exact_tree(g,target,['upload-manifest.json',*[r['path'] for r in ticket['files']]])
            for row in ticket['files']:
                parts=relative(row['path'])
                with g.directory(target+('/'+'/'.join(parts[:-1]) if len(parts)>1 else '')) as parent:
                    fd=os.open(parts[-1],os.O_RDONLY|os.O_NOFOLLOW|os.O_NOATIME|os.O_NONBLOCK,dir_fd=parent)
                try:
                    before=os.fstat(fd);value=hashlib.sha256();count=0
                    if not stat.S_ISREG(before.st_mode) or before.st_nlink!=1 or before.st_dev!=g.device or before.st_uid!=os.geteuid():raise ValueError('Unsafe reference file')
                    for block in iter(lambda:os.read(fd,1024*1024),b''):value.update(block);count+=len(block)
                    if stamp(os.fstat(fd))!=stamp(before) or (count,value.hexdigest())!=(row['bytes'],row['sha256']):raise ValueError('Reference stream SHA256 or identity mismatch: '+row['path'])
                    os.fchmod(fd,0o400)
                    rows.append(dict(row,inode=before.st_ino,device=before.st_dev))
                finally:os.close(fd)
            result=dict(status='HASH_VERIFIED_STREAM_REFERENCE',files=rows,resources=resources(g))
            g.new_file(target+'/receipt.json',encoded(result))
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
        else:raise ValueError('Unknown F54 operation')
        print(json.dumps(result))
    finally:g.close()
