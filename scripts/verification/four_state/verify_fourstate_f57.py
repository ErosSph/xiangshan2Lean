"""Frozen-XSTop encoding and explicitly requested validation, with stage evidence.

All writes are in the Guard-created current run; previously verified inputs and
tools are read through the existing no-follow/no-atime workspace guard.
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

from pathlib import Path
import argparse
import gzip
import hashlib
import io
import json
import os
import resource
import signal
import subprocess
import sys
import time
import traceback

from fourstate_sync_common import WORKSPACE, identifier, relative
from fourstate_sync_remote import Guard
from audit_fourstate_f52_worker import setup, closure, profile, write


def digest(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b''):
            h.update(chunk)
    return h.hexdigest()


def dump_gzip(path, value):
    with Path(path).open('xb') as raw:
        with gzip.GzipFile(filename='', mode='wb', fileobj=raw, mtime=0, compresslevel=1) as compressed:
            with io.TextIOWrapper(compressed, encoding='ascii', newline='\n') as text:
                json.dump(value, text, separators=(',', ':'), ensure_ascii=True)
    return dict(bytes=path.stat().st_size, sha256=digest(path))


def stage(out, event, **data):
    row = dict(event=event, unix=time.time(), worker_peak_rss_bytes=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss * 1024, **data)
    with (out / 'stages.jsonl').open('a') as f:
        f.write(json.dumps(row) + '\n')
    print(json.dumps(row), flush=True)


def encode(request, out):
    import fourstate_preprocess as pp
    import fourstate_scalable as scalable
    from fourstate_extended import parse_extended, encode_extended
    source = out / 'original'
    source.mkdir()
    g = Guard()
    try:
        old = str(Path(request['input_run']).relative_to(WORKSPACE)).replace('\\', '/')
        receipt = json.loads(g.read(str(Path(request['run']).relative_to(WORKSPACE)) + '/reports/input-receipt.json', None))
        rows = []
        for row in receipt['files']:
            relative(row['name'])
            data = g.read(old + '/reports/inputs/' + row['name'], None)
            if hashlib.sha256(data).hexdigest() != row['sha256']:
                raise ValueError('Frozen source mismatch: ' + row['name'])
            (source / row['name']).write_bytes(data)
            rows.append(dict(name=row['name'], bytes=len(data), sha256=row['sha256']))
        modules = {m['name']: m for m in json.loads(gzip.decompress(g.read(old + '/reports/frozen/modules-v3.json.gz', None)))}
    finally:
        g.close()
    write(out / 'inputs.json', rows)
    pp.MAX_FILES = len(rows)
    pp.MAX_BYTES = sum(r['bytes'] for r in rows)
    top = identifier(request.get('top', 'XSTop'))
    names = closure(modules, top)
    options, features = profile(modules, top)
    roots = tuple(features['clock_roots'])
    clock = options['clock']
    if clock and clock not in roots:
        roots = (clock, *roots)
    write(out / 'scope.json', dict(top=top, clock=clock, roots=roots, closure_definitions=len(names), frozen_files=len(rows), limits='No added CPU, memory, runtime or file-size limits; input whitelist is the frozen receipt', excluded=['FunctionalIR import', 'Lean', 'simulation']))
    stage(out, 'parse_begin', top=top)
    start = time.monotonic()
    ir = parse_extended(source, top, clock, event_clocks=roots)
    summary = dict(top=top, nodes=len(ir['nodes']), states=len(ir['states']), instances=len(ir['elaboration']['instances']), memories=len(ir['memories']), processes=len(ir['events']['processes']), diagnostics=len(ir.get('assertions', [])), storage=ir['storage'], parse_seconds=time.monotonic()-start)
    write(out / 'ir-summary.json', summary)
    stage(out, 'parse_complete', **summary)
    original_kernel = scalable.scalar_kernel
    passes = []
    def observed_kernel(model):
        begin = time.monotonic()
        stage(out, 'kernel_begin', pass_number=len(passes)+1, nodes=len(model['nodes']))
        result = original_kernel(model)
        row = dict(seconds=time.monotonic()-begin, rtl_bytes=len(result[0]), reads=len(result[2]), writes=len(result[3]))
        passes.append(row)
        stage(out, 'kernel_complete', pass_number=len(passes), **row)
        return result
    scalable.scalar_kernel = observed_kernel
    try:
        stage(out, 'encode_begin')
        start = time.monotonic()
        rtl, mapping = encode_extended(ir)
        summary.update(encode_seconds=time.monotonic()-start, kernel_passes=passes, encoded_top=mapping['encoded_top'])
    finally:
        scalable.scalar_kernel = original_kernel
    stage(out, 'encode_complete', **summary)
    rtl_path = out / 'encoded.sv'
    with rtl_path.open('x', encoding='ascii', newline='\n') as f:
        f.write(rtl)
    summary.update(rtl_bytes=rtl_path.stat().st_size, rtl_sha256=digest(rtl_path))
    del rtl
    stage(out, 'rtl_saved', bytes=summary['rtl_bytes'], sha256=summary['rtl_sha256'])
    summary['mapping'] = dump_gzip(out / 'mapping.json.gz', mapping)
    stage(out, 'mapping_saved', **summary['mapping'])
    del mapping
    summary['ir'] = dump_gzip(out / 'ir.json.gz', ir)
    stage(out, 'ir_saved', **summary['ir'])
    summary.update(status='ENCODED', behavior='NOT_RUN', functional_ir='NOT_RUN', compile='NOT_RUN', worker_peak_rss_bytes=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss*1024)
    write(out / 'summary.json', summary)


def process_tree(pid):
    result = []
    pending = [pid]
    while pending:
        n = pending.pop()
        base = Path('/proc') / str(n)
        try:
            status = {}
            for line in (base / 'status').read_text().splitlines():
                k, _, v = line.partition(':')
                if k in ('VmRSS', 'VmHWM'):
                    status[k] = int(v.split()[0])*1024
            result.append(dict(pid=n, cmdline=(base/'cmdline').read_bytes().replace(b'\0', b' ').decode(errors='replace'), **status))
            pending.extend(map(int, (base/'task'/str(n)/'children').read_text().split()))
        except FileNotFoundError:
            pass
    return result


def memory_groups():
    """Read actual inherited Linux cgroup policy, without changing any limit."""
    rows=[]
    for line in Path('/proc/self/cgroup').read_text().splitlines():
        parts=line.split(':',2)
        if len(parts)!=3 or 'memory' not in parts[1].split(','):continue
        root=Path('/sys/fs/cgroup/memory');current=root/parts[2].lstrip('/')
        current.resolve().relative_to(root.resolve())
        for directory in (current,*current.parents):
            if directory!=root and root not in directory.parents:break
            try:
                row=dict(path=str(directory),limit=int((directory/'memory.limit_in_bytes').read_text()),usage=int((directory/'memory.usage_in_bytes').read_text()),failcnt=int((directory/'memory.failcnt').read_text()),oom=(directory/'memory.oom_control').read_text())
                rows.append(row)
            except (FileNotFoundError,PermissionError):pass
            if directory==root:break
    return rows


def execute_command(out, argv, environment=None, *, compressed_stdout=False):
    import threading,shutil
    command = ['/usr/bin/time', '-v', '-o', str(out/'time.txt'), *argv] if Path('/usr/bin/time').is_file() else argv
    write(out/'command.json', dict(argv=command, cwd=str(out), environment=environment or {}))
    stage(out, 'command_begin', argv=command)
    begin = time.monotonic()
    peak = 0
    groups=memory_groups();policy=min(groups,key=lambda r:r['limit']) if groups else None
    write(out/'actual-memory-policy.json',dict(groups=groups,selected=policy,added_limits=False))
    pressure=None
    stdout_name='stdout.log.gz' if compressed_stdout else 'compiler-stdout.log'
    with (out/stdout_name).open('xb') as stdout, (out/'compiler-stderr.log').open('xb') as stderr, (out/'compiler-resources.jsonl').open('x') as monitor:
        p = subprocess.Popen(command, cwd=out, stdout=subprocess.PIPE if compressed_stdout else stdout, stderr=stderr, env=dict(os.environ, **(environment or {})))
        if compressed_stdout:
            compressed=gzip.GzipFile(filename='',mode='wb',fileobj=stdout,mtime=0,compresslevel=1)
            pump=threading.Thread(target=shutil.copyfileobj,args=(p.stdout,compressed))
            pump.start()
        while p.poll() is None:
            rows = process_tree(p.pid)
            rss = sum(r.get('VmRSS',0) for r in rows)
            peak = max(peak,rss)
            current=memory_groups()
            memory_stat=None
            if policy:
                try:memory_stat=dict(path=policy['path'],values={line.split()[0]:int(line.split()[1]) for line in (Path(policy['path'])/'memory.stat').read_text().splitlines()})
                except (FileNotFoundError,PermissionError):pass
            monitor.write(json.dumps(dict(seconds=time.monotonic()-begin,tree_rss_bytes=rss,processes=rows,cgroups=current,cgroup_memory_stat=memory_stat))+'\n')
            monitor.flush()
            if policy:
                active=next((r for r in current if r['path']==policy['path']),None)
                if active and active['failcnt']>policy['failcnt']:
                    pressure=dict(reason='Allocation failure at the actual inherited cgroup memory limit',initial=policy,current=active)
                    write(out/'actual-memory-pressure.json',pressure)
                    stage(out,'actual_memory_pressure',**pressure)
                    for row in reversed(rows):
                        if WORKSPACE not in row['cmdline']:raise ValueError('Refuse to signal a process outside the private workspace')
                        try:os.kill(row['pid'],signal.SIGTERM)
                        except ProcessLookupError:pass
                    p.wait()
                    break
            time.sleep(1)
        if compressed_stdout:
            pump.join();compressed.close()
    result = dict(exit_code=p.returncode, seconds=time.monotonic()-begin, peak_tree_rss_bytes=peak)
    if pressure:result['actual_memory_pressure']=pressure
    write(out/'execution-result.json', result)
    stage(out, 'command_complete', **result)
    return result


def encoded_receipt(source):
    if (source/'summary.json').is_file():
        return json.loads((source/'summary.json').read_bytes())
    # RTL/mapping are immutable once their save records have been emitted;
    # full IR archival may still be running and is not a compile dependency.
    events=[json.loads(line) for line in (source/'stages.jsonl').read_text().splitlines()]
    rtl=next(row for row in events if row['event']=='rtl_saved')
    mapping=next(row for row in events if row['event']=='mapping_saved')
    if digest(source/'mapping.json.gz')!=mapping['sha256']:
        raise ValueError('Mapping receipt mismatch')
    with gzip.open(source/'mapping.json.gz','rt') as f:
        model=json.load(f)
    return dict(status='ENCODED',encoded_top=model['encoded_top'],rtl_sha256=rtl['sha256'],rtl_bytes=rtl['bytes'],ir_archival='IN_PROGRESS')


def reencode(request,out):
    from fourstate_extended import encode_extended
    old=Path(request['run'])/'reports'/identifier(request['checkpoint_label'])
    receipt=json.loads((old/'summary.json').read_bytes())
    checkpoint=old/'ir.json.gz'
    if receipt['status']!='ENCODED' or digest(checkpoint)!=receipt['ir']['sha256']:
        raise ValueError('Fresh private-IR checkpoint receipt mismatch')
    stage(out,'checkpoint_load_begin',sha256=receipt['ir']['sha256'])
    with gzip.open(checkpoint,'rt') as f:
        ir=json.load(f)
    stage(out,'checkpoint_load_complete',nodes=len(ir['nodes']))
    start=time.monotonic()
    options=dict(shallow_memory=True,inline_kernel=request.get('inline_kernel',False),compact_observation=request.get('compact_observation',False),compact_forwarding=request.get('compact_forwarding',False))
    stage(out,'encode_begin',**options)
    rtl,mapping=encode_extended(ir,**options)
    result=dict(status='ENCODED',top=ir['top'],nodes=len(ir['nodes']),states=len(ir['states']),memories=len(ir['memories']),processes=len(ir['events']['processes']),encoded_top=mapping['encoded_top'],encode_seconds=time.monotonic()-start,shallow_memory=True,checkpoint=dict(path=str(checkpoint),**receipt['ir']),input_receipt_sha256=digest(old/'inputs.json'),behavior='NOT_RUN',compile='NOT_RUN',functional_ir='NOT_RUN')
    result['codegen_options']=options
    if options['compact_forwarding']:
        from collections import defaultdict
        groups=defaultdict(list)
        for w in mapping['writes']:groups[w['memory']].append(w)
        optimized=[]
        for memory,group in groups.items():
            addresses=[ir['nodes'][w['address']] for w in group]
            same=all(n['op']=='ref' and (n['name'],n['width'],n.get('signed',False))==(addresses[0]['name'],addresses[0]['width'],addresses[0].get('signed',False)) for n in addresses)
            if same and len(group)>1:optimized.append(dict(memory=memory,writes=len(group),address=dict(name=addresses[0]['name'],width=addresses[0]['width'],signed=addresses[0].get('signed',False))))
        result['forwarding_layout']=dict(groups=optimized,eliminated_full_word_muxes=sum(len(groups[r['memory']])*(len(groups[r['memory']])-1) for r in optimized),domain='Explicit initialized state; binary physical rails including logical 0/1/X/Z; identical bound address reference only')
    if options['compact_observation']:
        from fourstate_observation_layout import widths
        layout=widths(mapping)
        result['observation_layout']=dict(wires=len(layout),old_bits=len(layout)*mapping['observation']['width'],new_bits=sum(layout.values()))
    stage(out,'encode_complete',seconds=result['encode_seconds'])
    path=out/'encoded.sv'
    with path.open('x',encoding='ascii',newline='\n') as f:
        f.write(rtl)
    del rtl
    result.update(rtl_bytes=path.stat().st_size,rtl_sha256=digest(path))
    stage(out,'rtl_saved',bytes=result['rtl_bytes'],sha256=result['rtl_sha256'])
    result['mapping']=dump_gzip(out/'mapping.json.gz',mapping)
    result['worker_peak_rss_bytes']=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss*1024
    write(out/'summary.json',result)


def inline_kernel(request,out):
    from fourstate_inline_kernel import inline_stream
    source=Path(request['run'])/'reports'/identifier(request['encode_label'])
    old=encoded_receipt(source);path=source/'encoded.sv'
    if digest(path)!=old['rtl_sha256']:raise ValueError('Encoded input hash mismatch')
    stage(out,'inline_begin',source_sha256=old['rtl_sha256'])
    begin=time.monotonic()
    with path.open('r',encoding='ascii') as src,(out/'kernel-body.svpart').open('x+',encoding='ascii',newline='\n') as body,(out/'encoded.sv').open('x',encoding='ascii',newline='\n') as dst:
        stats=inline_stream(src,body,dst,old['encoded_top'])
    result=dict(old,inline_kernel=True,inline_stats=stats,inline_seconds=time.monotonic()-begin,source_encoded_sha256=old['rtl_sha256'],status='ENCODED',rtl_bytes=(out/'encoded.sv').stat().st_size,rtl_sha256=digest(out/'encoded.sv'),compile='NOT_RUN',functional_ir='NOT_RUN',behavior='NOT_RUN')
    (out/'mapping.json.gz').write_bytes((source/'mapping.json.gz').read_bytes())
    write(out/'summary.json',result)
    stage(out,'inline_complete',**stats,bytes=result['rtl_bytes'],sha256=result['rtl_sha256'])


def compact_observation(request,out):
    from fourstate_observation_layout import narrow_stream,buffer_selector_stream,balance_guards_stream
    source=Path(request['run'])/'reports'/identifier(request['encode_label'])
    old=encoded_receipt(source)
    if digest(source/'encoded.sv')!=old['rtl_sha256'] or digest(source/'mapping.json.gz')!=old['mapping']['sha256']:
        raise ValueError('Encoded source receipt differs')
    with gzip.open(source/'mapping.json.gz','rt') as f:mapping=json.load(f)
    begin=time.monotonic()
    with (source/'encoded.sv').open('r',encoding='ascii') as src,(out/'encoded.sv').open('x',encoding='ascii',newline='\n') as dst:
        if request.get('group_commits'):
            from fourstate_commit_layout import group_stream
            stats=group_stream(src,dst,mapping)
        elif request.get('balance_guards'):stats=balance_guards_stream(src,dst)
        else:stats=(buffer_selector_stream if request.get('selector_buffers') else narrow_stream)(src,dst,mapping)
    result=dict(old,compact_observation=True,selector_buffers=old.get('selector_buffers',False) or request.get('selector_buffers',False),balanced_guards=old.get('balanced_guards',False) or request.get('balance_guards',False),grouped_commits=request.get('group_commits',False),observation_layout=stats,layout_seconds=time.monotonic()-begin,source_encoded_sha256=old['rtl_sha256'],rtl_bytes=(out/'encoded.sv').stat().st_size,rtl_sha256=digest(out/'encoded.sv'),compile='NOT_RUN',functional_ir='NOT_RUN',behavior='NOT_RUN')
    (out/'mapping.json.gz').write_bytes((source/'mapping.json.gz').read_bytes())
    write(out/'summary.json',result);stage(out,'layout_complete',**stats)


def observation_check(request,out):
    from fourstate_observation_check import bench
    from verify_fourstate_f53 import command
    old=Path(request['run'])/'reports'/identifier(request['check_label'])/'Mixed'
    mapping=json.loads((old/'mapping.json').read_bytes())
    base=Path(WORKSPACE)/'runs/f56-20261018t090815z-2c037d10/tool/iverilog-complete-v1'
    (out/'tb.sv').write_text(bench(mapping,(old/'flat.sv').read_text(),(old/'shallow.sv').read_text()))
    command(out,'compile',[base/'bin/iverilog','-B',base/'lib/ivl','-g2012','-s','tb','-o',out/'test.vvp',out/'tb.sv'])
    command(out,'execute',[base/'bin/vvp',out/'test.vvp'])
    write(out/'summary.json',dict(status='EXHAUSTIVE_NATIVE_SELECTOR_PASS',object_selectors=4**mapping['observation']['object_width'],word_selectors=4**mapping['observation']['index_width'],data_fills=4))


def guard_check(request,out):
    from fourstate_observation_layout import balance_guards_text
    from verify_fourstate_f53 import command
    raw="""wire bad_latch=((a) || (b) || (c)); wire bad_initial=!seeded && bad_latch;
wire bad_repeat=seeded && ((a) || (b) || (c)); wire bad_clock=((a) || (b) || (c));
wire more_work=((a) || (b) || (c)) || bad_latch; wire too_many=(a[0]==1'b1) && more_work;
"""
    balanced,stats=balance_guards_text(raw);write(out/'layout.json',stats)
    tb="""module tb; reg [1:0] a,b,c;reg seeded;integer s,i,k;
function symbol4;input integer c;begin case(c)0:symbol4=0;1:symbol4=1;2:symbol4=1'bx;3:symbol4=1'bz;endcase end endfunction
generate if(1)begin: original
"""+raw+'end if(1)begin: balanced\n'+balanced+"""end endgenerate
initial begin for(s=0;s<4;s=s+1)begin seeded=symbol4(s);for(i=0;i<4096;i=i+1)begin
for(k=0;k<2;k=k+1)begin a[k]=symbol4((i>>(2*k))%4);b[k]=symbol4((i>>(4+2*k))%4);c[k]=symbol4((i>>(8+2*k))%4);end
#1;if({original.bad_latch,original.bad_initial,original.bad_repeat,original.bad_clock,original.more_work,original.too_many}!=={balanced.bad_latch,balanced.bad_initial,balanced.bad_repeat,balanced.bad_clock,balanced.more_work,balanced.too_many})$fatal(1,"Guard factoring changed four-state truth");
end end $display("GUARD_FOURSTATE_PASS 16384");$finish;end endmodule
"""
    (out/'tb.sv').write_text(tb)
    iv=Path(WORKSPACE)/'runs/f56-20261018t090815z-2c037d10/tool/iverilog-complete-v1'
    command(out,'compile',[iv/'bin/iverilog','-B',iv/'lib/ivl','-g2012','-s','tb','-o',out/'test.vvp',out/'tb.sv'])
    command(out,'execute',[iv/'bin/vvp',out/'test.vvp'])
    write(out/'summary.json',dict(status='EXACT_GUARD_FOURSTATE_PASS',cases=16384,layout=stats))


def compile_rtl(request, out):
    run = Path(request['run'])
    source = run / 'reports' / identifier(request['encode_label'])
    summary = encoded_receipt(source)
    rtl = source / 'encoded.sv'
    if summary['status'] != 'ENCODED' or digest(rtl) != summary['rtl_sha256']:
        raise ValueError('Encoded RTL receipt mismatch')
    g = Guard()
    try:
        old = 'runs/' + identifier(request.get('runtime_run', 'f56-20261018t090815z-2c037d10'))
        runtime = json.loads(g.read(old + '/reports/icarus-runtime.json', None))
        for row in runtime['files']:
            if hashlib.sha256(g.read(runtime['base'] + '/' + row['path'], None)).hexdigest() != row['sha256']:
                raise ValueError('Private Icarus runtime mismatch')
    finally:
        g.close()
    iv = Path(WORKSPACE) / runtime['base']
    write(out / 'runtime.json', runtime)
    version = subprocess.run([str(iv/'bin/iverilog'), '-B', str(iv/'lib/ivl'), '-V'], capture_output=True)
    write(out/'version.json', dict(argv=version.args, exit_code=version.returncode, stdout=version.stdout.decode(errors='replace'), stderr=version.stderr.decode(errors='replace')))
    argv = [str(iv/'bin/iverilog'), '-B', str(iv/'lib/ivl'), '-g2012', '-s', summary['encoded_top'], '-o', str(out/'encoded.vvp'), str(rtl)]
    if request.get('verbose_compile'):
        argv.insert(3,'-v')
    result = execute_command(out, argv)
    result.update(status='COMPILED' if result['exit_code']==0 else 'COMPILE_FAILED', input_sha256=summary['rtl_sha256'], behavior='NOT_RUN', functional_ir='NOT_RUN')
    if (out/'encoded.vvp').is_file():
        result['executable']=dict(bytes=(out/'encoded.vvp').stat().st_size,sha256=digest(out/'encoded.vvp'))
    write(out/'summary.json', result)
    stage(out,'compile_complete', **result)


def backend(request, out):
    run = Path(request['run'])
    if request.get('await_label') and not request.get('file_io'):
        dependency=run/'reports'/identifier(request['await_label'])/'execution.json'
        stage(out,'waiting_for_heavy_job',dependency=str(dependency))
        while not dependency.is_file():
            time.sleep(5)
        stage(out,'heavy_job_finished',dependency=json.loads(dependency.read_bytes()))
    source = run/'reports'/identifier(request['encode_label'])
    if request.get('small_probe'):
        source=run/'reports'/identifier(request['probe_label'])/identifier(request['probe_top'])
        rtl=source/'shallow.sv';prior=json.loads((source/'summary.json').read_bytes())
        mapping=json.loads((source/'mapping.json').read_bytes())
        receipt=dict(status='ENCODED',rtl_sha256=prior['shallow_sha256'],encoded_top=mapping['encoded_top'])
    else:
        receipt = encoded_receipt(source)
        rtl = source/'encoded.sv'
    if receipt['status']!='ENCODED' or digest(rtl)!=receipt['rtl_sha256']:
        raise ValueError('Encoded RTL receipt mismatch')
    project = run/'work/backend-project'
    tools = json.loads((run/'reports/threeway-tools.json').read_bytes())
    if tools['status']!='VERIFIED':
        raise ValueError('Verified Lean runtime required')
    launch='import sys,runpy;sys.path.insert(0,'+repr(str(project/'scripts'))+');runpy.run_path('+repr(str(project/'scripts/yosys2lean.py'))+',run_name="__main__")'
    argv=[sys.executable,'-I','-B','-c',launch,str(rtl),'--top',receipt['encoded_top'],'--out',str(out/'model'),'--evidence',str(out/'translation'),'--clock','exec_clk','--yosys-engine','native','--check','--json-io','memory','--functional-io','memory','--lean-backend','table']
    if request.get('flat_checkpoint'):
        checkpoint=run/request['flat_checkpoint']
        checkpoint.resolve(strict=True).relative_to(run.resolve())
        if checkpoint.name!='flat-checkpoint.json':raise ValueError('Only the existing verified flat checkpoint admitted')
        argv.extend(['--flat-checkpoint',str(checkpoint)])
    if request.get('file_io'):
        if request['file_io']!='lossless-archive-reference-v1':raise ValueError('Unknown private storage adapter')
        adapter=Path(__file__).with_name('fourstate_backend_io.py')
        adapted='import sys,runpy;sys.path.insert(0,'+repr(str(adapter.parent))+');runpy.run_path('+repr(str(adapter))+',run_name="__main__")'
        argv=[sys.executable,'-I','-B','-c',adapted,'--project',str(project),'--run',str(run),'--out',str(out),'--',*argv[5:]]
        if request.get('await_label'):
            divider=argv.index('--')
            argv[divider:divider]=['--await-label',identifier(request['await_label'])]
        if request.get('reuse_archive_index'):
            index=run/request['reuse_archive_index']
            index.resolve(strict=True).relative_to(run.resolve())
            if index.name!='artifact-storage.json':raise ValueError('Existing private archive index required')
            divider=argv.index('--')
            argv[divider:divider]=['--reuse-archive-index',str(index)]
        # The public FunctionalIR streaming option reduces parser duplication.
        argv[argv.index('--functional-io')+1]='stream'
        if request.get('stream_json'):
            divider=argv.index('--')
            argv[divider:divider]=['--stream-json']
            argv[argv.index('--json-io')+1]='stream'
        divider=argv.index('--')
        if request.get('stream_output_json'):argv[divider:divider]=['--stream-output-json']
        divider=argv.index('--')
        if request.get('cache_artifacts'):argv[divider:divider]=['--cache-artifacts']
        for name in request.get('release_cache_files',[]):
            relative(name)
            if not name.startswith('reports/'):raise ValueError('Only private run report cache may be advised')
            divider=argv.index('--')
            argv[divider:divider]=['--release-cache-file',str(run/name)]
    environment=dict(CHISEL2LEAN_LEAN=tools['lean'],LEAN_SYSROOT=str(Path(tools['lean']).parent.parent))
    write(out/'input.json',dict(encoded_sha256=receipt['rtl_sha256'],preparation='direct: no normalizing Verilog round trip',backend_source_sha256=digest(project/'scripts/yosys2lean.py'),file_io=request.get('file_io','public-default'),flat_checkpoint=request.get('flat_checkpoint'),scope='FunctionalIR import and actual Lean compilation; behavioral replay is a separate stage'))
    result=execute_command(out,argv,environment)
    result.update(status='LEAN_COMPILED' if result['exit_code']==0 else 'BACKEND_FAILED',behavior='NOT_RUN')
    if (out/'model-reference.json').is_file():
        result['model_root']=json.loads((out/'model-reference.json').read_bytes())['root']
        Path(result['model_root']).resolve(strict=True).relative_to(out.resolve())
        result['manifest']=json.loads((Path(result['model_root'])/'manifest.json').read_bytes())
    if (out/'model/manifest.json').is_file():
        result['manifest']=json.loads((out/'model/manifest.json').read_bytes())
    write(out/'summary.json',result)
    if result['exit_code'] != 0:
        raise RuntimeError('Public backend failed with inner exit code '+str(result['exit_code']))


def forwarding_check(request,out):
    from fourstate_extended import parse_extended,encode_extended
    from fourstate_scalable_bench import make_bench,compare_streams,run_stream,records
    import itertools,re
    from verify_fourstate_f53 import trace_for,command
    g=Guard()
    try:
        runtime=json.loads(g.read('runs/f56-20261018t090815z-2c037d10/reports/icarus-runtime.json',None))
        for row in runtime['files']:
            if hashlib.sha256(g.read(runtime['base']+'/'+row['path'],None)).hexdigest()!=row['sha256']:raise ValueError('Icarus hash mismatch')
        old=str(Path(request['run']).relative_to(WORKSPACE))+'/reports/xstop-encode-v1/'
        source=g.read(old+'original/buffer_7x514.sv',None)
        expected=next(r['sha256'] for r in json.loads(g.read(old+'inputs.json',None)) if r['name']=='buffer_7x514.sv')
        if hashlib.sha256(source).hexdigest()!=expected:raise ValueError('Real RAM source differs')
        saved='releases/f57-source-20261018t110859z-d9caec82109e/'
        baseline=g.read(saved+'src/scripts/fourstate_scalable.py',None)
        saved_manifest=json.loads(g.read(saved+'manifest.json',None))
        baseline_hash=next(r['sha256'] for r in saved_manifest['files'] if r['path']=='scripts/fourstate_scalable.py')
        if hashlib.sha256(baseline).hexdigest()!=baseline_hash:raise ValueError('Baseline encoder hash differs')
    finally:g.close()
    baseline_module=dict(__name__='f57_baseline_scalable',__file__=saved+'src/scripts/fourstate_scalable.py')
    exec(compile(baseline,'<hash-verified pre-fix private encoder>','exec'),baseline_module)
    iv=Path(WORKSPACE)/runtime['base'];rows=[]
    root=_PROJECT_ROOT
    (out/'deposit4.c').write_bytes((root/'verification/fourstate/deposit4.c').read_bytes())
    command(out,'vpi-compile',['/usr/bin/gcc','-shared','-fPIC','-O2','-Wall','-Wextra','-Werror','-I/usr/include/iverilog',out/'deposit4.c','-o',out/'deposit4.vpi'])
    cases=[('buffer_7x514','W0_clk',source),('Overlap','clock',b'module Overlap(input clock,input [1:0] a,b,input [7:0] d,e,input en0,en1,output [7:0] q);reg [7:0] mem[0:2];assign q=mem[a];always @(posedge clock)begin if(en0)mem[a]<=d;if(en1)mem[b][5:2]<=e[3:0];end endmodule\n')]
    if request.get('inline_check'):
        cases=[('Overlap','clock',cases[1][2].replace(b'output [7:0] q)',b'output [7:0] q,output reg [7:0] r)').replace(b'end endmodule',b'end always @(posedge clock)r<=mem[b];endmodule'))]
    if request.get('layout_check'):
        cases=[cases[0]] if cases[0][0]=='buffer_7x514' else [('buffer_7x514','W0_clk',source)]
        cases.append(('Mixed','clock',b'module Mixed(input clock,input [1:0] a,input [7:0] d,e,input en0,en1,output [7:0] q,output reg r,output reg [36:0] wide);reg [7:0] mem[0:2];reg [8:0] extra;assign q=mem[a];always @(posedge clock)begin if(en0)mem[a]<=d;if(en1)mem[a][5:2]<=e[3:0];r<=d[0];wide<={29\'b0,d};extra<={1\'b0,e};end endmodule\n'))
    if request.get('balance_guards'):
        cases.insert(0,('GuardEvents','clock',b'module GuardEvents(input clock,input [1:0] a,input [7:0] d,e,input en0,en1,output [7:0] q,output reg r,output reg [36:0] wide);reg [7:0] mem[0:2];reg [8:0] extra;assign q=mem[a];always @(posedge clock)begin if(en0)mem[a]<=d;if(en1)mem[a][5:2]<=e[3:0];end always @(posedge clock)r<=d[0];always @(posedge clock)wide<={29\'b0,d};always @(posedge clock)extra<={1\'b0,e};endmodule\n'))
    if request.get('group_commits'):
        cases.sort(key=lambda case:case[0]!='Mixed')
    for top,clock,text in cases:
        folder=out/top;folder.mkdir();original=folder/(top+'.sv');original.write_bytes(text)
        ir=parse_extended(original,top,clock,event_clocks=(clock,))
        flat,mapping=encode_extended(ir);shallow,other=encode_extended(ir,shallow_memory=True,inline_kernel=request.get('inline_check',False),compact_observation=request.get('compact_observation',False),compact_forwarding=request.get('compact_forwarding',False))
        if request.get('selector_buffers'):
            from fourstate_observation_layout import buffer_selector_text
            shallow,selector_stats=buffer_selector_text(shallow,other,group_wires=2)
            write(folder/'selector-layout.json',selector_stats)
        if request.get('balance_guards'):
            from fourstate_observation_layout import balance_guards_text
            shallow,guard_stats=balance_guards_text(shallow)
            write(folder/'guard-layout.json',guard_stats)
        if request.get('group_commits'):
            from fourstate_commit_layout import group_text
            shallow,commit_stats=group_text(shallow,other)
            write(folder/'commit-layout.json',commit_stats)
        if mapping!=other:raise ValueError('Forwarding option changed mapping')
        baseline_rtl,baseline_mapping=baseline_module['encode_scalable'](ir,_eventful=True,_extensions=True)
        if flat!=baseline_rtl or mapping!=baseline_mapping:raise ValueError('Default v9 encoding no longer byte-identical')
        (folder/'flat.sv').write_text(flat);(folder/'shallow.sv').write_text(shallow)
        write(folder/'mapping.json',mapping);trace=trace_for(mapping)
        if request.get('layout_check') and top=='Mixed':
            from fourstate_observation_check import bench as observation_bench
            obs=folder/'observation-check';obs.mkdir()
            (obs/'tb.sv').write_text(observation_bench(mapping,flat,shallow))
            command(obs,'compile',[iv/'bin/iverilog','-B',iv/'lib/ivl','-g2012','-s','tb','-o',obs/'test.vvp',obs/'tb.sv'])
            command(obs,'execute',[iv/'bin/vvp',obs/'test.vvp'])
        if top=='buffer_7x514' and request.get('layout_check'):
            # Append directed valid writes; the historical generic trace alone
            # paired all-one masks with address 7 (out of range).
            now=dict(trace[-1]['inputs'])
            def change(name,value):
                if now[name]!=value:now[name]=value;trace.append(dict(inputs=dict(now)))
            change('W0_clk','0');change('R0_en','1');change('W0_en','1')
            for address,symbol,mask in [(0,'1','1'*514),(6,'0','1'*514),(3,'x','01'*257),(3,'z','10'*257),(0,'0','xz'*257),(6,'1','1'*514)]:
                change('W0_addr',format(address,'03b'));change('R0_addr',format(address,'03b'))
                change('W0_data',symbol*514);change('W0_mask',mask)
                change('W0_clk','1');change('W0_clk','0')
            for address,enable in [('xxx','1'),('zzz','1'),('111','1'),('000','x'),('110','z')]:
                change('W0_addr',address);change('W0_en',enable);change('W0_mask','1'*514)
                change('W0_clk','1');change('W0_clk','0')
        if top=='Mixed' and request.get('layout_check'):
            now=dict(trace[-1]['inputs'])
            def change(name,value):
                if now[name]!=value:now[name]=value;trace.append(dict(inputs=dict(now)))
            change('clock','0');change('en0','1');change('en1','1');change('a','00')
            for d,e in [('11111111','00000101'),('00000000','00001010'),('xzxzxzxz','00000011'),('10100101','xxxxzzzz')]:
                change('d',d);change('e',e);change('clock','1');change('clock','0')
            change('a','10');change('d','01010101');change('e','00000110');change('clock','1');change('clock','0')
        write(folder/'trace.json',trace)
        roles=[('original',False),('shallow',True)]+([('flat',True)] if top in ('Overlap','Mixed') else [])
        executables={}
        for role,binary in roles:
            f=folder/role;f.mkdir();bench,data=make_bench(mapping,trace,'x',binary)
            # Compile once; only the explicit all-original-state fill varies.
            # No observation, input, event or trace is removed.
            header='module tb;reg seed_t,seed_v,seed_symbol;integer seed_arg;initial begin if(!$value$plusargs("FILL=%d",seed_arg))$fatal(1,"missing explicit initial fill");seed_t=(seed_arg>=2);seed_v=(seed_arg%2);case(seed_arg)0:seed_symbol=0;1:seed_symbol=1;2:seed_symbol=1\'bx;3:seed_symbol=1\'bz;default:$fatal(1,"invalid fill");endcase end '
            def fill_literal(match):
                w,bits=match.groups()
                if len(bits)!=int(w):return match.group()
                if binary and set(bits)=={'1'}:return '{'+w+'{seed_t}}'
                if binary and set(bits)=={'0'}:return '{'+w+'{seed_v}}'
                if not binary and set(bits)=={'x'}:return '{'+w+'{seed_symbol}}'
                return match.group()
            bench=re.sub(r"(?<![A-Za-z0-9_$])(\d+)'b([01xz]+)(?![01xz])",fill_literal,bench)
            bench=bench.replace('module tb;',header,1)
            (f/'tb.sv').write_text(bench);(f/('encoded-inputs.mem' if binary else 'original-inputs.mem')).write_text(data)
            src=original if not binary else folder/(role+'.sv')
            command(f,'compile',[iv/'bin/iverilog','-B',iv/'lib/ivl','-g2012','-s','tb','-o',f/'test.vvp',src,f/'tb.sv'])
            executables[role]=(f,[iv/'bin/vvp']+(['-M',str(out),'-m','deposit4'] if not binary else [])+[f/'test.vvp'])
        comparisons=[]
        for code,fill in enumerate('01xz'):
            logs={}
            for role,(f,argv) in executables.items():
                result=run_stream(f,'execute-'+fill,[*argv,'+FILL='+str(code)])
                if result['exit_code']:raise ValueError('Forwarding simulation failed: '+role)
                logs[role]=f/('execute-'+fill)/'stdout.log.gz'
            raw=compare_streams(logs['original'],logs['shallow'],mapping,len(trace))
            count=0
            if 'flat' in logs:
                for a,b in itertools.zip_longest(records(logs['flat'],True),records(logs['shallow'],True)):
                    if a is None or b is None or a!=b:raise ValueError('Flat/shallow exact mismatch: '+repr((a,b)))
                    count+=1
            same=dict(status='EXACT_ENCODING_MATCH' if 'flat' in logs else 'DEFAULT_RTL_BYTE_IDENTICAL',records=count)
            comparisons.append(dict(fill=fill,raw=raw,flat=same))
        result=dict(top=top,samples=len(trace)*4,source_sha256=hashlib.sha256(text).hexdigest(),flat_sha256=hashlib.sha256(flat.encode()).hexdigest(),shallow_sha256=hashlib.sha256(shallow.encode()).hexdigest(),baseline_encoder_sha256=baseline_hash,default_encoding='BYTE_IDENTICAL',inline_kernel=request.get('inline_check',False),comparison=comparisons)
        if request.get('layout_check') and top=='buffer_7x514':
            # Detect a lost valid write using the same exact full-state comparator.
            mutant=folder/'missed-write';mutant.mkdir()
            first=mapping['writes'][0]['node']
            broken=re.sub(r'(wire \[513:0\] write'+str(first)+r'_value=)[^;]+;',r'\g<1>write'+str(first)+'_old_value;',shallow,count=1)
            if broken==shallow:raise ValueError('Missed-write injection target absent')
            (mutant/'encoded.sv').write_text(broken)
            (mutant/'encoded-inputs.mem').write_bytes((folder/'shallow/encoded-inputs.mem').read_bytes())
            command(mutant,'compile',[iv/'bin/iverilog','-B',iv/'lib/ivl','-g2012','-s','tb','-o',mutant/'test.vvp',mutant/'encoded.sv',folder/'shallow/tb.sv'])
            run_stream(mutant,'execute',[iv/'bin/vvp',mutant/'test.vvp','+FILL=0'])
            try:compare_streams(folder/'original/execute-0/stdout.log.gz',mutant/'execute/stdout.log.gz',mapping,len(trace))
            except ValueError as error:result['missed_write_detected']=str(error)
            else:raise ValueError('Directed trace missed an injected lost write')
        if request.get('inline_check') and top!='buffer_7x514':
            b=folder/'backend';b.mkdir();run=Path(request['run']);project=run/'work/backend-project';tools=json.loads((run/'reports/threeway-tools.json').read_bytes())
            launch='import sys,runpy;sys.path.insert(0,'+repr(str(project/'scripts'))+');runpy.run_path('+repr(str(project/'scripts/yosys2lean.py'))+',run_name="__main__")'
            args=[sys.executable,'-I','-B','-c',launch,str(folder/'shallow.sv'),'--top',mapping['encoded_top'],'--out',str(b/'model'),'--evidence',str(b/'translation'),'--clock','exec_clk','--yosys-engine','native','--check','--json-io','memory','--functional-io','memory','--lean-backend','table']
            result['backend']=execute_command(b,args,dict(CHISEL2LEAN_LEAN=tools['lean'],LEAN_SYSROOT=str(Path(tools['lean']).parent.parent)))
            if result['backend']['exit_code']:raise ValueError('Inlined kernel backend compatibility failed')
        rows.append(result);write(folder/'summary.json',result)
    write(out/'summary.json',dict(status='PASS',models=rows))


def encoded_replay(request,out):
    from fourstate_machine_replay import config
    from fourstate_scalable_bench import compare_streams
    from verify_fourstate_f53 import command
    run=Path(request['run']);g=Guard()
    try:
        runtime=json.loads(g.read('runs/f56-20261018t090815z-2c037d10/reports/icarus-runtime.json',None))
        for row in runtime['files']:
            if hashlib.sha256(g.read(runtime['base']+'/'+row['path'],None)).hexdigest()!=row['sha256']:raise ValueError('Icarus hash mismatch')
    finally:g.close()
    iv=Path(WORKSPACE)/runtime['base'];root=_PROJECT_ROOT
    (out/'machine_probe.c').write_bytes((root/'verification/fourstate/machine_probe.c').read_bytes())
    command(out,'vpi-compile',['/usr/bin/gcc','-shared','-fPIC','-O2','-Wall','-Wextra','-Werror','-I/usr/include/iverilog',out/'machine_probe.c','-o',out/'machine_probe.vpi'])
    if request.get('small_probe'):
        old=run/'reports'/identifier(request.get('probe_label','inline-check-v1'))/identifier(request.get('probe_top','Overlap'));mapping=json.loads((old/'mapping.json').read_bytes());trace=json.loads((old/'trace.json').read_bytes())
        encoded=old/'shallow.sv';exe=out/'encoded.vvp'
        command(out,'compile',[iv/'bin/iverilog','-B',iv/'lib/ivl','-g2012','-s',mapping['encoded_top'],'-o',exe,encoded])
    else:
        source=run/'reports'/identifier(request['encode_label']);receipt=encoded_receipt(source)
        if digest(source/'mapping.json.gz')!=receipt['mapping']['sha256']:raise ValueError('Mapping hash mismatch')
        with gzip.open(source/'mapping.json.gz','rt') as f:mapping=json.load(f)
        trace=json.loads((run/'reports/behavior-preparation-v1/native/trace.json').read_bytes())
        compiled=run/'reports'/identifier(request['compile_label']);cc=json.loads((compiled/'summary.json').read_bytes())
        exe=compiled/'encoded.vvp'
        if cc['status']!='COMPILED' or cc['input_sha256']!=receipt['rtl_sha256'] or digest(exe)!=cc['executable']['sha256']:raise ValueError('Compiled simulation receipt mismatch')
    write(out/'scope.json',config(mapping,trace,out/'replay.cfg'))
    rows=[]
    for code,fill in enumerate('01xz'):
        folder=out/('initial-'+fill);folder.mkdir()
        result=execute_command(folder,[str(iv/'bin/vvp'),'-M',str(out),'-m','machine_probe',str(exe),'+F57_CONFIG='+str(out/'replay.cfg'),'+FILL='+str(code)],compressed_stdout=True)
        result['fill']=fill
        if result['exit_code']:raise ValueError('Encoded replay execution failed')
        if request.get('small_probe'):
            result['comparison']=compare_streams(old/'original'/('execute-'+fill)/'stdout.log.gz',folder/'stdout.log.gz',mapping,len(trace))
        rows.append(result);write(folder/'summary.json',result)
    write(out/'summary.json',dict(status='RAW_ENCODED_PROBE_PASS' if request.get('small_probe') else 'ENCODED_EXECUTED',samples=len(trace)*4,initials=rows))


def lean_replay(request,out):
    from fourstate_machine_replay import lean_plan,normalize_numeric
    from fourstate_scalable_bench import compare_streams
    run=Path(request['run']);root=_PROJECT_ROOT
    tools=json.loads((run/'reports/threeway-tools.json').read_bytes())
    if request.get('small_probe'):
        old=run/'reports'/identifier(request.get('probe_label','inline-check-v1'))/identifier(request.get('probe_top','Overlap'));model=old/'backend/model';mapping=json.loads((old/'mapping.json').read_bytes());trace=json.loads((old/'trace.json').read_bytes())
        if request.get('backend_label'):
            backend=run/'reports'/identifier(request['backend_label']);status=json.loads((backend/'summary.json').read_bytes())
            if status['status']!='LEAN_COMPILED':raise ValueError('Actual probe backend/Lean compilation required')
            backend_input=json.loads((backend/'input.json').read_bytes())
            if backend_input['encoded_sha256']!=digest(old/'shallow.sv'):raise ValueError('Probe backend imported a different encoded RTL')
            model=Path(status.get('model_root',str(backend/'model')))
            model.resolve(strict=True).relative_to(backend.resolve())
    else:
        source=run/'reports'/identifier(request['encode_label']);receipt=encoded_receipt(source)
        if digest(source/'mapping.json.gz')!=receipt['mapping']['sha256']:raise ValueError('Mapping hash mismatch')
        with gzip.open(source/'mapping.json.gz','rt') as f:mapping=json.load(f)
        trace=json.loads((run/'reports/behavior-preparation-v1/native/trace.json').read_bytes())
        backend=run/'reports'/identifier(request['backend_label']);status=json.loads((backend/'summary.json').read_bytes())
        if status['status']!='LEAN_COMPILED':raise ValueError('Actual complete backend/Lean compilation required')
        backend_input=json.loads((backend/'input.json').read_bytes())
        if backend_input['encoded_sha256']!=receipt['rtl_sha256']:raise ValueError('Backend imported a different encoded RTL')
        model=Path(status.get('model_root',str(backend/'model')))
        model.resolve(strict=True).relative_to(backend.resolve())
    full_trace_count=len(trace)
    prefix=request.get('trace_prefix')
    fills=request.get('initial_fills','01xz')
    if not isinstance(fills,str) or not fills or len(set(fills))!=len(fills) or set(fills)-set('01xz'):
        raise ValueError('Explicit unique initial fills required')
    if prefix is not None:
        if request.get('small_probe') or not request.get('raw_reference_label') or type(prefix) is not int or not 0<prefix<full_trace_count:
            raise ValueError('Explicit native whole-machine prefix must be shorter than the full frozen trace')
        trace=trace[:prefix]
    elif fills!='01xz':raise ValueError('Reduced initial fills require an explicitly scoped native prefix')
    write(out/'trace-scope.json',dict(full_frozen_samples_per_fill=full_trace_count,selected_samples_per_fill=len(trace),initial_fills=fills,prefix_only=prefix is not None,full_frozen_trace_retained=True))
    native_reference=None;native_files={}
    if request.get('raw_reference_label'):
        if request.get('small_probe'):raise ValueError('Whole native reference cannot be used for a small probe')
        native_reference=run/'reports'/identifier(request['raw_reference_label'])
        transfer=json.loads((native_reference/'receipt.json').read_bytes())
        original=json.loads((native_reference/'summary.json').read_bytes())
        if transfer['status']!='HASH_VERIFIED_STREAM_REFERENCE' or original['status']!='RAW_TRACES_EXECUTED' or original['prepared_mapping_sha256']!=receipt['mapping']['sha256']:
            raise ValueError('Native reference is not the exact frozen whole-machine mapping')
        native_files={r['path']:r for r in transfer['files']}
    observer=root/'verification/fourstate/RunMachine.lean'
    native_exe=None;native_receipt=None
    if request.get('native_observer_label'):
        from fourstate_native_replay import native_observer
        native_exe,native_receipt=native_observer(run/'reports'/identifier(request['native_observer_label']),model,observer)
        write(out/'native-engine.json',native_receipt)
    if request.get('prepared_replay_label'):
        from fourstate_native_replay import reuse_preparation
        stage(out,'verify_prepared_replay_begin')
        plan=reuse_preparation(run/'reports'/identifier(request['prepared_replay_label']),model,mapping,trace,request,json.loads((out/'trace-scope.json').read_bytes()),observer,out/'request')
        stage(out,'verify_prepared_replay_complete')
    else:plan=lean_plan(model,mapping,trace,out/'request')
    write(out/'state-map-receipt.json',plan)
    (out/'RunMachine.lean').write_bytes((root/'verification/fourstate/RunMachine.lean').read_bytes())
    environment=dict(LEAN_SYSROOT=str(Path(tools['lean']).parent.parent),LEAN_PATH=str(model))
    compile_out=out/'compile';compile_out.mkdir()
    compiled=execute_command(compile_out,[tools['lean'],'--root='+str(out),'-o',str(out/'RunMachine.olean'),str(out/'RunMachine.lean')],environment)
    if compiled['exit_code']:raise ValueError('Private observation runner failed Lean compilation')
    rows=[]
    for fill in fills:
        folder=out/('initial-'+fill);folder.mkdir()
        if plan.get('unused_input_proof') and digest(Path(plan['binary']))!=plan['unused_input_proof']['binary_sha256']:raise ValueError('Compiled circuit changed after unused-input proof')
        if native_exe is not None and digest(native_exe)!=native_receipt['executable_sha256']:raise ValueError('Native executable changed before replay')
        runner=[str(native_exe)] if native_exe is not None else [tools['lean'],'--root='+str(out),'--run',str(out/'RunMachine.lean')]
        result=execute_command(folder,[*runner,plan['binary'],str(out/'request/plan.json'),str(out/'request'/('request-'+fill+'.json'))],environment,compressed_stdout=True)
        if result['exit_code']:raise ValueError('Actual Lean replay failed')
        if native_exe is not None and digest(native_exe)!=native_receipt['executable_sha256']:raise ValueError('Native executable changed during replay')
        if plan.get('unused_input_proof') and digest(Path(plan['binary']))!=plan['unused_input_proof']['binary_sha256']:raise ValueError('Compiled circuit changed during proved replay')
        normalize_numeric(folder/'stdout.log.gz',folder/'observations.log.gz')
        if request.get('small_probe'):
            result['comparison']=compare_streams(old/'original'/('execute-'+fill)/'stdout.log.gz',folder/'observations.log.gz',mapping,len(trace))
        elif native_reference is not None:
            from fourstate_eventful_bench import compare_activations
            from fourstate_machine_compare import diagnostics,stream_complete,native_prefix
            name='case-'+fill+'/observations.log.gz';original=native_reference/name
            if original.stat().st_size!=native_files[name]['bytes'] or digest(original)!=native_files[name]['sha256']:raise ValueError('Frozen native reference archive changed')
            result['stream_integrity']=stream_complete(folder/'observations.log.gz',mapping,len(trace))
            if prefix is not None:
                derived=folder/'original-prefix.log.gz'
                selected=native_prefix(original,derived,prefix)
                write(folder/'original-prefix-receipt.json',dict(selected,full_archive_sha256=native_files[name]['sha256']))
                original=derived
            result['comparison']=compare_streams(original,folder/'observations.log.gz',dict(mapping,assertions=[]),len(trace))
            result['comparison']['activations']=compare_activations(original,folder/'observations.log.gz')
            abi=diagnostics(folder/'observations.log.gz',mapping)
            if len(abi['flags'])!=len(trace)*len(mapping['assertions']):raise ValueError('Missing complete Lean diagnostic flags')
            write(folder/'diagnostic-payload.json',dict(events=abi['events'],arguments=[dict(sample=k[0],site=k[1],ordinal=k[2],argument=k[3],bits=value) for k,value in sorted(abi['arguments'].items())]))
            result['comparison'].update(status='RAW_LEAN_HARDWARE_AND_ACTIVATIONS_PASS',diagnostic_events=len(abi['events']),diagnostic_arguments=len(abi['arguments']),native_render='PENDING_WINDOWS_MODELSIM')
        else:
            from fourstate_machine_compare import encoded_pair
            result['comparison']=encoded_pair(run/'reports'/identifier(request['replay_label'])/('initial-'+fill)/'stdout.log.gz',folder/'observations.log.gz',mapping,len(trace))
        rows.append(result);write(folder/'summary.json',result)
    status='RAW_ENCODED_LEAN_PROBE_PASS' if request.get('small_probe') else 'RAW_LEAN_PREFIX_NATIVE_RENDER_REQUIRED' if prefix is not None else 'RAW_LEAN_NATIVE_RENDER_REQUIRED' if native_reference is not None else 'ENCODED_LEAN_FINITE_PASS'
    write(out/'summary.json',dict(status=status,samples=len(trace)*len(fills),initials=rows,prefix_only=prefix is not None,full_frozen_samples_per_fill=full_trace_count,scope='Actual existing encoded RTL -> untouched FunctionalIR/table backend -> executed pure Lean; full outputs, RAM words, scalar state and event observations in the explicit selected trace; native diagnostic rendering checked separately',comparison_reference='original four-state RTL' if native_reference is not None else 'encoded RTL'))


def compare_machine(request,out):
    from fourstate_machine_compare import encoded_pair
    run=Path(request['run'])
    old=run/'reports'/identifier(request['probe_label'])/identifier(request['probe_top'])
    mapping=json.loads((old/'mapping.json').read_bytes());trace=json.loads((old/'trace.json').read_bytes())
    rows=[]
    for fill in '01xz':
        vpi=run/'reports'/identifier(request['vpi_label'])/('initial-'+fill)/'stdout.log.gz'
        lean=run/'reports'/identifier(request['lean_label'])/('initial-'+fill)/'observations.log.gz'
        rows.append(dict(fill=fill,**encoded_pair(vpi,lean,mapping,len(trace))))
    write(out/'summary.json',dict(status='EXACT_VPI_LEAN_FULL_ABI_PASS',samples=len(trace)*4,initials=rows))


def compare_whole_encoded_lean(request,out):
    from fourstate_machine_compare import encoded_pair
    run=Path(request['run']);source=run/'reports'/identifier(request['encode_label']);receipt=encoded_receipt(source)
    if digest(source/'mapping.json.gz')!=receipt['mapping']['sha256']:raise ValueError('Mapping receipt mismatch')
    with gzip.open(source/'mapping.json.gz','rt') as stream:mapping=json.load(stream)
    trace=json.loads((run/'reports/behavior-preparation-v1/native/trace.json').read_bytes());rows=[]
    for fill in '01xz':
        rows.append(dict(fill=fill,**encoded_pair(run/'reports'/identifier(request['replay_label'])/('initial-'+fill)/'stdout.log.gz',run/'reports'/identifier(request['lean_label'])/('initial-'+fill)/'observations.log.gz',mapping,len(trace))))
        write(out/('initial-'+fill+'.json'),rows[-1])
    write(out/'summary.json',dict(status='WHOLE_EXACT_ENCODED_LEAN_FULL_ABI_PASS',samples=len(trace)*4,initials=rows))


def check_machine_streams(request,out):
    from fourstate_machine_compare import stream_complete
    run=Path(request['run'])
    if request.get('small_probe'):
        source=run/'reports'/identifier(request['probe_label'])/identifier(request['probe_top'])
        mapping=json.loads((source/'mapping.json').read_bytes());trace=json.loads((source/'trace.json').read_bytes())
    else:
        source=run/'reports'/identifier(request['encode_label']);receipt=encoded_receipt(source)
        if digest(source/'mapping.json.gz')!=receipt['mapping']['sha256']:raise ValueError('Mapping receipt mismatch')
        with gzip.open(source/'mapping.json.gz','rt') as stream:mapping=json.load(stream)
        trace=json.loads((run/'reports/behavior-preparation-v1/native/trace.json').read_bytes())
    rows=[]
    for fill in '01xz':
        result=stream_complete(run/'reports'/identifier(request['replay_label'])/('initial-'+fill)/'stdout.log.gz',mapping,len(trace))
        rows.append(dict(fill=fill,**result));write(out/('initial-'+fill+'.json'),rows[-1])
    write(out/'summary.json',dict(status='PROBE_ENCODED_STREAM_COMPLETE' if request.get('small_probe') else 'WHOLE_ENCODED_STREAM_COMPLETE',initials=rows,samples=len(trace)*4,behavior='NOT_COMPARED'))


def compare_native_machine(request,out):
    from fourstate_scalable_bench import compare_streams
    from fourstate_eventful_bench import compare_activations
    from fourstate_machine_compare import diagnostics
    run=Path(request['run']);source=run/'reports'/identifier(request['encode_label']);receipt=encoded_receipt(source)
    if digest(source/'mapping.json.gz')!=receipt['mapping']['sha256']:raise ValueError('Mapping receipt mismatch')
    with gzip.open(source/'mapping.json.gz','rt') as stream:mapping=json.load(stream)
    trace=json.loads((run/'reports/behavior-preparation-v1/native/trace.json').read_bytes())
    reference=run/'reports'/identifier(request['reference_label'])
    transfer=json.loads((reference/'receipt.json').read_bytes())
    if transfer['status']!='HASH_VERIFIED_STREAM_REFERENCE':raise ValueError('Sealed native reference required')
    original=json.loads((reference/'summary.json').read_bytes())
    if original['status']!='RAW_TRACES_EXECUTED' or original['prepared_mapping_sha256']!=receipt['mapping']['sha256']:raise ValueError('Frozen native reference mapping differs')
    files={r['path']:r for r in transfer['files']};rows=[]
    for fill in '01xz':
        folder=out/('initial-'+fill);folder.mkdir();name='case-'+fill+'/observations.log.gz'
        path=reference/name
        if path.stat().st_size!=files[name]['bytes'] or digest(path)!=files[name]['sha256']:raise ValueError('Native reference archive changed')
        encoded=run/'reports'/identifier(request['replay_label'])/('initial-'+fill)/'stdout.log.gz'
        result=compare_streams(path,encoded,dict(mapping,assertions=[]),len(trace))
        write(folder/'snapshots.json',result)
        result['activations']=compare_activations(path,encoded);write(folder/'activations.json',result['activations'])
        abi=diagnostics(encoded,mapping)
        if len(abi['flags'])!=len(trace)*len(mapping['assertions']):raise ValueError('Missing complete diagnostic flags')
        payload=dict(events=abi['events'],arguments=[dict(sample=k[0],site=k[1],ordinal=k[2],argument=k[3],bits=v) for k,v in sorted(abi['arguments'].items())])
        write(folder/'diagnostic-payload.json',payload)
        result.update(fill=fill,status='RAW_ENCODED_HARDWARE_AND_ACTIVATIONS_PASS',diagnostic_events=len(abi['events']),diagnostic_arguments=len(abi['arguments']),native_render='PENDING_WINDOWS_MODELSIM')
        rows.append(result);write(folder/'summary.json',result)
    write(out/'summary.json',dict(status='WHOLE_RAW_ENCODED_NATIVE_RENDER_REQUIRED',samples=len(trace)*4,initials=rows,scope='All frozen outputs, logical RAM words, scalar state, pre/post, monitors and events plus complete activation old state; typed diagnostic payloads exported for exact native rendering'))


def check_native_streams(request,out):
    from fourstate_machine_compare import stream_complete
    run=Path(request['run']);reference=run/'reports'/identifier(request['reference_label'])
    stage(out,'waiting_for_sealed_reference',path=str(reference/'receipt.json'))
    while not (reference/'receipt.json').is_file():time.sleep(5)
    transfer=json.loads((reference/'receipt.json').read_bytes())
    if transfer['status']!='HASH_VERIFIED_STREAM_REFERENCE':raise ValueError('Sealed native reference required')
    files={r['path']:r for r in transfer['files']}
    source=run/'reports'/identifier(request['encode_label']);receipt=encoded_receipt(source)
    if digest(source/'mapping.json.gz')!=receipt['mapping']['sha256']:raise ValueError('Mapping receipt mismatch')
    with gzip.open(source/'mapping.json.gz','rt') as stream:mapping=json.load(stream)
    original=json.loads((reference/'summary.json').read_bytes())
    if original['prepared_mapping_sha256']!=receipt['mapping']['sha256'] or original['status']!='RAW_TRACES_EXECUTED':raise ValueError('Native frozen mapping differs')
    trace=json.loads((run/'reports/behavior-preparation-v1/native/trace.json').read_bytes());rows=[]
    for fill in '01xz':
        name='case-'+fill+'/observations.log.gz';path=reference/name
        if path.stat().st_size!=files[name]['bytes'] or digest(path)!=files[name]['sha256']:raise ValueError('Native archive differs from sealed transfer')
        stage(out,'native_matrix_begin',fill=fill)
        result=stream_complete(path,mapping,len(trace),binary=False,protocol=False)
        rows.append(dict(fill=fill,**result));write(out/('initial-'+fill+'.json'),rows[-1])
        stage(out,'native_matrix_complete',fill=fill,**result)
    write(out/'summary.json',dict(status='WHOLE_NATIVE_OBSERVATION_MATRIX_COMPLETE',samples=len(trace)*4,initials=rows,behavior='NOT_COMPARED'))


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--request', type=Path, required=True)
    p.add_argument('--out', type=Path, required=True)
    a = p.parse_args()
    request = json.loads(a.request.read_bytes())
    os.umask(0o077)
    setup(Path(request['run']))
    import pyslang
    source_root=_PROJECT_ROOT/'scripts'
    write(a.out/'machine.json', dict(hostname=os.uname().nodename, python=sys.version, pyslang=pyslang.__version__, inherited_limits={n:resource.getrlimit(getattr(resource,n)) for n in ('RLIMIT_CPU','RLIMIT_AS','RLIMIT_FSIZE')},actual_cgroups=memory_groups(), sources={f.relative_to(source_root).as_posix():digest(f) for f in source_root.rglob('*.py') if f.is_file()}))
    try:
        if request.get('resource_after'):
            dependency=Path(request['run'])/'reports'/identifier(request['resource_after'])/'execution.json'
            stage(a.out,'waiting_for_resource_release',dependency=str(dependency),prerequisite_success_required=False)
            while not dependency.is_file():time.sleep(5)
            stage(a.out,'resource_released',result=json.loads(dependency.read_bytes()),note='Scheduling barrier only; does not establish success or equivalence')
        if request.get('wait_for'):
            dependency=Path(request['run'])/'reports'/identifier(request['wait_for'])/'execution.json'
            stage(a.out,'waiting_for_prerequisite',dependency=str(dependency))
            while not dependency.is_file():
                time.sleep(5)
            prerequisite=json.loads(dependency.read_bytes())
            stage(a.out,'prerequisite_finished',result=prerequisite)
            if prerequisite['exit_code']!=0:raise ValueError('Required preceding execution failed')
        if request['action']=='encode':
            encode(request,a.out)
        elif request['action']=='reencode':
            reencode(request,a.out)
        elif request['action']=='inline-kernel':
            inline_kernel(request,a.out)
        elif request['action']=='compact-observation':
            compact_observation(request,a.out)
        elif request['action']=='observation-check':
            observation_check(request,a.out)
        elif request['action']=='guard-check':
            guard_check(request,a.out)
        elif request['action']=='compile':
            compile_rtl(request,a.out)
        elif request['action']=='backend':
            backend(request,a.out)
        elif request['action']=='forwarding-check':
            forwarding_check(request,a.out)
        elif request['action']=='inline-check':
            forwarding_check(dict(request,inline_check=True),a.out)
        elif request['action']=='encoded-replay':
            encoded_replay(request,a.out)
        elif request['action']=='lean-replay':
            lean_replay(request,a.out)
        elif request['action']=='compare-machine':
            compare_machine(request,a.out)
        elif request['action']=='compare-whole-encoded-lean':
            compare_whole_encoded_lean(request,a.out)
        elif request['action']=='check-machine-streams':
            check_machine_streams(request,a.out)
        elif request['action']=='compare-native-machine':
            compare_native_machine(request,a.out)
        elif request['action']=='check-native-streams':
            check_native_streams(request,a.out)
        elif request['action']=='unit-tests':
            from verify_fourstate_f56 import tests
            tests(request,a.out)
            import unittest
            sys.path.insert(0,str(_PROJECT_ROOT/'tests'))
            result=unittest.TextTestRunner(verbosity=2).run(unittest.defaultTestLoader.loadTestsFromNames(['test_fourstate_machine_artifacts','test_fourstate_machine_stream','test_fourstate_unused_inputs']))
            write(a.out/'artifact-tests.json',dict(tests=result.testsRun,failures=len(result.failures),errors=len(result.errors),skipped=len(result.skipped)))
            if not result.wasSuccessful() or result.skipped:raise ValueError('Private artifact integrity tests did not all execute successfully')
        elif request['action']=='json-stream-tests':
            import unittest
            sys.path.insert(0,str(_PROJECT_ROOT/'tests'))
            result=unittest.TextTestRunner(verbosity=2).run(unittest.defaultTestLoader.loadTestsFromNames(['test_fourstate_json_stream','test_fourstate_backend_storage']))
            write(a.out/'summary.json',dict(status='JSON_STREAM_TESTS_PASS' if result.wasSuccessful() else 'JSON_STREAM_TESTS_FAILED',tests=result.testsRun,failures=len(result.failures),errors=len(result.errors),skipped=len(result.skipped)))
            if not result.wasSuccessful() or result.skipped:raise ValueError('Private streaming IO tests failed')
        elif request['action']=='prepare-behavior':
            from fourstate_machine_bench import prepare
            import shutil
            source=Path(request['run'])/'reports'/identifier(request['encode_label'])
            receipt=json.loads((source/'summary.json').read_bytes())
            if digest(source/'mapping.json.gz')!=receipt['mapping']['sha256']:raise ValueError('Mapping checkpoint differs')
            with gzip.open(source/'mapping.json.gz','rt') as f:mapping=json.load(f)
            schema=prepare(mapping,a.out/'native')
            with (a.out/'native/original-tb.sv').open('rb') as src,(a.out/'original-tb.sv.gz').open('xb') as raw:
                with gzip.GzipFile(filename='',mode='wb',fileobj=raw,mtime=0,compresslevel=1) as dst:shutil.copyfileobj(src,dst)
            write(a.out/'summary.json',dict(status='PREPARED',mapping_sha256=receipt['mapping']['sha256'],initial_schema=schema,files=[dict(path=str(p.relative_to(a.out)),bytes=p.stat().st_size,sha256=digest(p)) for p in [a.out/'original-tb.sv.gz',a.out/'native/trace.json',a.out/'native/original-inputs.mem',a.out/'native/initial-schema.json']]))
        else:
            raise ValueError('Unknown explicitly selected F57 action')
    except Exception as e:
        write(a.out/'failure.json', dict(error=str(e),exception=type(e).__name__,traceback=traceback.format_exc()))
        stage(a.out,'failure',error=str(e),exception=type(e).__name__)
        raise


if __name__ == '__main__':
    main()
