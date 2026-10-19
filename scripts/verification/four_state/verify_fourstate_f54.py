"""F54 private server probes; immutable inputs, native-array encoding, no Lean run."""
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
import argparse,copy,gzip,hashlib,json,os,re,sys,time,traceback
from verify_fourstate_f53 import write,digest,command,runtime


def selected_sources(source,top,target):
    target.mkdir();todo=[top];done=set()
    while todo:
        name=todo.pop()
        if name in done:continue
        done.add(name);p=source/(name+'.sv')
        data=p.read_bytes();(target/p.name).write_bytes(data)
        for child in re.findall(rb'(?:^|;)\s*([A-Za-z_][A-Za-z0-9_$]*)\s+[A-Za-z_][A-Za-z0-9_$]*\s*\(',data,re.M):
            s=child.decode()
            if (source/(s+'.sv')).is_file() and s not in done:todo.append(s)
    return sorted(target.glob('*.sv'))


def generate(source,top,clock,case,roots=()):
    from fourstate_scalable import parse_scalable,encode_scalable
    case.mkdir();originals=selected_sources(source,top,case/'original');start=time.monotonic()
    ir=parse_scalable(case/'original',top,clock,event_clocks=roots,immediate_assertions=True)
    rtl,mapping=encode_scalable(ir)
    write(case/'ir.json',ir);write(case/'mapping.json',mapping);(case/'encoded.sv').write_text(rtl)
    result=dict(top=top,status='GENERATED',seconds=time.monotonic()-start,nodes=len(ir['nodes']),processes=len(ir['events']['processes']),
        monitors=len(ir['events']['monitors']),storage=ir['storage'],rtl_bytes=len(rtl.encode()),ir_bytes=(case/'ir.json').stat().st_size,
        source_hashes={p.name:digest(p) for p in originals})
    return ir,mapping,result


def probe(request,out,iv):
    source=Path(request['input_run'])/'reports/inputs';results=[]
    cases=[('array_0_6144x64','RW0_clk'),('array_4096x96','RW0_clk'),('Queue1_AXI4BundleW','clock'),('AXI4Buffer','clock'),
           ('ram_2x273','W0_clk'),('Queue2_AXI4BundleR','clock'),('Queue2_AXI4BundleAW_3','clock')]
    for top,clock in cases:
        case=out/top
        try:
            ir,m,r=generate(source,top,clock,case)
            row,_=command(case,'encoded-compile',[iv/'bin/iverilog','-B',iv/'lib/ivl','-g2012','-s',m['encoded_top'],'-o',case/'encoded.vvp',case/'encoded.sv'],required=False)
            r['compile_exit_code']=row['exit_code'];r['status']='COMPILED' if row['exit_code']==0 else 'COMPILE_FAILED'
        except Exception as e:r=dict(top=top,status='REJECTED',error=str(e),traceback=traceback.format_exc());write(case/'error.json',r)
        results.append(r);write(out/(top+'-result.json'),r)
    write(out/'summary.json',results)


def compat(request,out):
    run=Path(request['run']);project=run/'work/backend-project';origin=run/'reports'/request.get('probe_label','probe-v1');results=[]
    for top in request.get('tops',['array_0_6144x64','array_4096x96','Queue1_AXI4BundleW','AXI4Buffer']):
        case=out/top;case.mkdir();encoded=origin/top/'encoded.sv';mapping=json.loads((origin/top/'mapping.json').read_bytes())
        # As in the legacy private entry, purge dead public process temporaries
        # before the unchanged shared undef-exposure pipeline.
        prepare=case/'prepare.ys';normalized=case/'normalized.sv'
        preparation=request.get('prepare_profile','baseline')
        if preparation not in ('baseline','memory_share','direct'):raise ValueError('Unknown private preparation profile')
        extra='memory_share; opt_clean -purge; ' if preparation=='memory_share' else ''
        prepare.write_text(f'read_slang --threads 1 --no-proc --no-synthesis-define --no-default-translate-off-format {encoded} --top {mapping["encoded_top"]}; hierarchy -check -top {mapping["encoded_top"]}; proc -noopt; opt_clean -purge; {extra}check -assert; write_verilog -noattr {normalized}\n')
        if preparation=='direct':
            normalized=encoded
            write(case/'direct-input.json',dict(path=str(encoded),sha256=digest(encoded),reason='Avoid word-memory to per-bit Verilog write-port round trip; unchanged public entry reads the original encoded RTL'))
        else:command(case,'prepare',[project/'.tools/oss-cad-suite-20261014/bin/yosys','-Q','-T','-s',prepare])
        launch='import sys,runpy;sys.path.insert(0,'+repr(str(project/'scripts'))+');runpy.run_path('+repr(str(project/'scripts/yosys2lean.py'))+',run_name="__main__")'
        row,_=command(case,'backend',[sys.executable,'-I','-B','-c',launch,normalized,'--top',mapping['encoded_top'],
            '--out',case/'model','--evidence',case/'translation','--clock','exec_clk','--yosys-engine','native','--no-check',
            '--json-io','memory','--functional-io','memory','--lean-backend','table'],required=False)
        result=dict(top=top,exit_code=row['exit_code'],seconds=row['seconds'])
        if row['exit_code']==0:
            manifests=list((case/'model').glob('manifest.json'))
            manifest=json.loads(manifests[0].read_bytes());ir=json.loads((case/'model'/manifest['ir']).read_bytes())
            memories=[s for s in ir['states'] if s['sort']['kind']=='memory'];expected=sum('memory' in s for s in mapping['states'])*2
            if len(memories)!=expected:raise ValueError('Memory states not preserved: '+top)
            if ir['arbitrary_inputs']:raise ValueError('Unexpected arbitrary input: '+top)
            for s in mapping['states']:
                if 'memory' not in s:continue
                for bank in ('bank_tag','bank_value'):
                    if not any(s[bank] in m['name'] and m['sort']==dict(kind='memory',address_width=s['memory']['address_width'],width=s['width']) for m in memories):
                        raise ValueError('Memory object/sort mapping incomplete: '+s[bank])
            result.update(status='FUNCTIONAL_IR_PASS',nodes=len(ir['nodes']),states=len(ir['states']),memory_states=len(memories),
                memory_sorts=[dict(name=m['name'],sort=m['sort']) for m in memories],arbitrary_inputs=ir['arbitrary_inputs'],lean_checked=manifest['lean_checked'],
                operations=dict(__import__('collections').Counter(n['op'] for n in ir['nodes'])))
        else:result['status']='BACKEND_FAILED'
        results.append(result);write(case/'result.json',result)
    write(out/'summary.json',results)


def directed_trace(mapping):
    from verify_fourstate_f53 import trace_for
    if not mapping['top'].startswith('array_'):return trace_for(mapping)
    ports=[p for p in mapping['ports'] if p['direction']=='input'];now={p['name']:'0'*p['width'] for p in ports};now['RW0_clk']='1';rows=[dict(inputs=dict(now))]
    def setone(n,v):
        if now[n]!=v:now[n]=v;rows.append(dict(inputs=dict(now)))
    def edge():setone('RW0_clk','0');setone('RW0_clk','1')
    memory=next(s['memory'] for s in mapping['states'] if 'memory' in s);aw=next(p['width'] for p in ports if p['name']=='RW0_addr');dw=memory['width']
    for c in '01xz':
        setone('RW0_wdata',c*dw);setone('RW0_en','1');setone('RW0_wmode','1')
        if 'RW0_wmask' in now:setone('RW0_wmask','111111')
        for address in (0,1,memory['depth']-2,memory['depth']-1):setone('RW0_addr',format(address,f'0{aw}b'));edge()
        setone('RW0_wmode','0');edge()
    for bits in ('x'*aw,'z'*aw,format((1<<aw)-1,f'0{aw}b')):
        setone('RW0_addr',bits);setone('RW0_wmode','1');edge();setone('RW0_wmode','0');edge()
    for en in '01xz':setone('RW0_en',en);edge()
    if 'RW0_wmask' in now:
        setone('RW0_addr','0'*aw);setone('RW0_en','1');setone('RW0_wmode','1')
        for mask in ('000000','000001','100000','010101','101010','xxxxxx','zzzzzz'):setone('RW0_wmask',mask);edge()
    for a in '01xz':
        for b in '01xz':setone('RW0_clk',a);setone('RW0_clk',b)
    return rows


def behavior(request,out,iv):
    from fourstate_scalable_bench import make_bench,run_stream,compare_streams
    run=Path(request['run']);source=Path(request['input_run'])/'reports/inputs';root=_PROJECT_ROOT
    (out/'deposit4.c').write_bytes((root/'verification/fourstate/deposit4.c').read_bytes())
    command(out,'vpi-compile',['/usr/bin/gcc','-shared','-fPIC','-O2','-Wall','-Wextra','-Werror','-I/usr/include/iverilog',out/'deposit4.c','-o',out/'deposit4.vpi'])
    defaults=[('array_0_6144x64','RW0_clk'),('array_4096x96','RW0_clk'),('Queue1_AXI4BundleW','clock'),('AXI4Buffer','clock'),('ram_2x273','W0_clk'),('Queue2_AXI4BundleR','clock'),('Queue2_AXI4BundleAW_3','clock')]
    historical=Path('/data2/home/lvhongqing/cgt/chisel2lean-fourstate/runs/f53-20261018t061308z-4f19d009/reports')
    extra={}
    for top,clock,label in [('GateRAM','ck','probe-final'),('MemoryOrder','clk','probe-final'),('MemorySlices','clk','probe-slices')]:
        target=out/('fixture-'+top);target.mkdir();p=historical/label/(top+'.sv');(target/p.name).write_bytes(p.read_bytes())
        if top=='GateRAM':
            for n in ('ClockGate','ram_2x273','ram_2x340'):(target/(n+'.sv')).write_bytes((source/(n+'.sv')).read_bytes())
        extra[top]=target;defaults.append((top,clock))
    farm=out/'fixture-GateFarm';farm.mkdir();(farm/'GateFarm.sv').write_text(gate_farm(17))
    for n in ('ClockGate','ram_2x273'):(farm/(n+'.sv')).write_bytes((source/(n+'.sv')).read_bytes())
    extra['GateFarm']=farm;defaults.append(('GateFarm','ck'))
    reset=out/'fixture-TwoReset';reset.mkdir();(reset/'TwoReset.sv').write_text("module TwoReset(input clk,cb,ra,rb,d,output reg q,p);always @(posedge clk or posedge ra)if(ra)q<=1'b0;else q<=d;always @(negedge cb or posedge rb)if(rb)p<=1'b0;else p<=d;endmodule")
    extra['TwoReset']=reset;defaults.append(('TwoReset','clk'))
    results=[]
    for top,clock in defaults:
        if request.get('tops') and top not in request['tops']:continue
        case=out/top
        try:
            ir,m,r=generate(extra.get(top,source),top,clock,case,('ck','cb') if top in ('GateRAM','GateFarm') else ('clk','cb') if top=='TwoReset' else ());trace=directed_trace(m)
            old=Path('/data2/home/lvhongqing/cgt/chisel2lean-fourstate/runs/f53-20261018t061308z-4f19d009/reports/probe-final')/top/'trace.json'
            if top in ('ram_2x273','Queue2_AXI4BundleR','Queue2_AXI4BundleAW_3'):trace=json.loads(old.read_bytes())
            if top in ('GateRAM','MemoryOrder','MemorySlices'):trace=json.loads((historical/('probe-slices' if top=='MemorySlices' else 'probe-final')/top/'trace.json').read_bytes())
            write(case/'trace.json',trace);summaries=[]
            for initial,c in enumerate('01xz'):
                f=case/f'initial-{initial}';f.mkdir();write(f/'initial.json',dict(symbol=c,all_original_objects=[s['name'] for s in m['states']],padding='00'))
                streams={}
                for role in ('original','encoded'):
                    tb,data=make_bench(m,trace,c,role=='encoded');(f/(role+'-tb.sv')).write_text(tb);(f/(role+'-inputs.mem')).write_text(data)
                    sources=[case/'encoded.sv'] if role=='encoded' else sorted((case/'original').glob('*.sv'))
                    cc,_=command(f,role+'-compile',[iv/'bin/iverilog','-B',iv/'lib/ivl','-g2012','-s','tb','-o',f/(role+'.vvp'),*sources,f/(role+'-tb.sv')],required=False)
                    if cc['exit_code']:
                        if role=='encoded':raise ValueError('Encoded bench compile failed: '+str(f))
                        continue
                    argv=[iv/'bin/vvp']+(['-M',str(out),'-m','deposit4'] if role=='original' else [])+[f/(role+'.vvp')]
                    rr=run_stream(f,role+'-execute',argv)
                    if rr['exit_code']:raise ValueError('Runtime failed: '+str(f)+' '+role)
                    streams[role]=f/(role+'-execute/stdout.log.gz')
                if len(streams)==2:
                    try:comparison=compare_streams(streams['original'],streams['encoded'],m,len(trace))
                    except ValueError as error:comparison=dict(status='REFERENCE_DISAGREEMENT',error=str(error),samples=len(trace))
                else:comparison=dict(status='MODELSIM_REFERENCE_REQUIRED',samples=len(trace))
                summaries.append(comparison);write(f/'comparison.json',comparison)
            r.update(initials=summaries,samples=len(trace)*4,status='BEHAVIOR_COMPLETE')
        except Exception as e:r=dict(top=top,status='FAILED',error=str(e),traceback=traceback.format_exc());write(case/'error.json',r)
        results.append(r);write(out/(top+'-result.json'),r)
    write(out/'summary.json',results)


def gate_farm(count):
    outputs=','.join('q'+str(i) for i in range(count))+',r'
    lines=[f'module GateFarm(input ck,cb,te,we,a,input [{count-1}:0] en,input [272:0] d,output [272:0] {outputs});wire inv;assign inv=~cb;']
    for i in range(count):lines.append(f'wire g{i};ClockGate gate{i}(.TE(te),.E(en[{i}]),.CK(ck),.Q(g{i}));ram_2x273 ram{i}(.R0_addr(a),.R0_en(we),.R0_clk(cb),.R0_data(q{i}),.W0_addr(a),.W0_en(we),.W0_clk(g{i}),.W0_data(d));')
    lines.append('ram_2x273 inverted(.R0_addr(a),.R0_en(we),.R0_clk(ck),.R0_data(r),.W0_addr(a),.W0_en(we),.W0_clk(inv),.W0_data(d));endmodule')
    return '\n'.join(lines)


def scale(request,out,iv):
    from fourstate_scalable import parse_scalable,encode_scalable
    rows=[]
    for depth in (2,32,1024,6144):
        case=out/f'depth-{depth}';case.mkdir();p=case/'Scale.sv';p.write_text(f'module Scale(input clk,en,input [12:0] a,input [63:0] d,output [63:0] q);reg [63:0] m[0:{depth-1}];always @(posedge clk)if(en)m[a]<=d;assign q=m[a];endmodule')
        start=time.monotonic();ir=parse_scalable(p,'Scale','clk');rtl,m=encode_scalable(ir);write(case/'ir.json',ir);write(case/'mapping.json',m);(case/'encoded.sv').write_text(rtl)
        rows.append(dict(kind='depth',depth=depth,nodes=len(ir['nodes']),objects=len(ir['states']),rtl_bytes=len(rtl.encode()),ir_bytes=(case/'ir.json').stat().st_size,seconds=time.monotonic()-start,storage=ir['storage']))
    for count in (16,128,1024,4417):
        case=out/f'process-{count}';case.mkdir();p=case/'Scale.sv'
        declarations=''.join(f'reg q{i};always @(posedge clk)q{i}<=d;' for i in range(count))
        parts=[f'q{i}' for i in range(count)]
        while len(parts)>1:parts=['('+parts[i]+'^'+parts[i+1]+')' if i+1<len(parts) else parts[i] for i in range(0,len(parts),2)]
        p.write_text('module Scale(input clk,d,output q);'+declarations+'assign q='+parts[0]+';endmodule');start=time.monotonic()
        ir=parse_scalable(p,'Scale','clk');rtl,m=encode_scalable(ir);write(case/'ir.json',ir);write(case/'mapping.json',m);(case/'encoded.sv').write_text(rtl)
        rows.append(dict(kind='process',processes=count,nodes=len(ir['nodes']),objects=len(ir['states']),rtl_bytes=len(rtl.encode()),ir_bytes=(case/'ir.json').stat().st_size,seconds=time.monotonic()-start,storage=ir['storage'],dependencies=ir['events']['dependency_stats']))
    # Equivalent storage capacity, not a semantic XSTop replacement.
    inventory=Path('/data2/home/lvhongqing/cgt/chisel2lean-fourstate/runs/f53-20261018t061308z-4f19d009/reports/inventory-v4/ownership.json.gz')
    with gzip.open(inventory,'rt') as f:bound=json.load(f)
    memories=[o for o in bound['objects'] if o['kind']=='memory'];scalar_bits=bound['summary']['scalar_bits'];processes=bound['summary']['processes']
    case=out/'capacity-fixture';case.mkdir();declarations=[];parts=[];largest=max(o['width'] for o in memories);remaining=processes-len(memories)
    for i,o in enumerate(memories):
        depth=o['bits']//o['width'];w=o['width'];declarations.append(f'reg [{w-1}:0] m{i}[0:{depth-1}];always @(posedge clk)if(en)m{i}[a]<=d[{w-1}:0];');parts.append(f'm{i}[a][0]')
    for i in range(remaining):
        w=scalar_bits//remaining+(i<scalar_bits%remaining);declarations.append(f'reg [{w-1}:0] q{i};always @(posedge clk)if(en)q{i}<=d[{w-1}:0];');parts.append(f'q{i}[0]')
    while len(parts)>1:parts=['('+parts[i]+'^'+parts[i+1]+')' if i+1<len(parts) else parts[i] for i in range(0,len(parts),2)]
    p=case/'Capacity.sv';p.write_text(f'module Capacity(input clk,en,input [12:0] a,input [{largest-1}:0] d,output q);'+''.join(declarations)+'assign q='+parts[0]+';endmodule');start=time.monotonic()
    ir=parse_scalable(p,'Capacity','clk');rtl,m=encode_scalable(ir);write(case/'ir.json',ir);write(case/'mapping.json',m);(case/'encoded.sv').write_text(rtl)
    rows.append(dict(kind='capacity',scope='Independent equivalent-capacity fixture; scalar objects packed into process groups, not XSTop semantic IR',nodes=len(ir['nodes']),objects=len(ir['states']),processes=len(ir['events']['processes']),storage=ir['storage'],rtl_bytes=len(rtl.encode()),ir_bytes=(case/'ir.json').stat().st_size,seconds=time.monotonic()-start,source_inventory=digest(inventory)))
    write(out/'summary.json',rows)


def tests(request,out):
    import unittest
    from audit_fourstate_f52_worker import focused_tests
    historical=out/'historical';historical.mkdir();focused_tests(Path(request['run']),historical)
    sys.path.insert(0,str(historical/'project/tests'))
    suite=unittest.TestSuite(unittest.defaultTestLoader.loadTestsFromName(name) for name in ('test_fourstate_scalable','test_fourstate_stateflow','test_fourstate_events','test_fourstate_procedural','test_fourstate_packed_procedural','test_fourstate_prioritymux','test_fourstate_preprocess','test_fourstate_blockers'))
    result=unittest.TextTestRunner(verbosity=2).run(suite);old=json.loads((historical/'tests.json').read_bytes())
    write(out/'tests.json',dict(tests=result.testsRun+old['tests'],failures=len(result.failures),errors=len(result.errors),historical_focused=old['tests']))
    if not result.wasSuccessful():raise ValueError('Unit/rejection tests failed')


def legacy_regressions(request,out,iv):
    import verify_fourstate_f53 as legacy
    legacy.IV=iv;legacy.out=out;root=_PROJECT_ROOT
    (out/'deposit4.c').write_bytes((root/'verification/fourstate/deposit4.c').read_bytes())
    command(out,'vpi-compile',['/usr/bin/gcc','-shared','-fPIC','-O2','-Wall','-Wextra','-Werror','-I/usr/include/iverilog',out/'deposit4.c','-o',out/'deposit4.vpi'])
    legacy.regressions(request,out)


def faults(request,out,iv):
    from fourstate_scalable import encode_scalable
    from fourstate_scalable_bench import make_bench,run_stream,compare_streams
    base=Path(request['run'])/'reports/behavior-small-v3/MemoryOrder';ir=json.loads((base/'ir.json').read_bytes());m=json.loads((base/'mapping.json').read_bytes());trace=json.loads((base/'trace.json').read_bytes())
    rtl,regenerated=encode_scalable(ir)
    if rtl!=(base/'encoded.sv').read_text():raise ValueError('Fault baseline differs from current encoder')
    rows=[]
    for fault in ('wrong_address','missing_write','write_order','early_commit','missing_trigger','repeated_trigger','xz_confusion'):
        text=rtl;f=out/fault;f.mkdir();initial=3 if fault=='xz_confusion' else 0
        if fault=='wrong_address':
            wid=m['writes'][-1]['node'];pattern=r'(wire \[\d+:0\] write'+str(wid)+r'_addr=)([^;]+);'
            text,n=re.subn(pattern,lambda x:x[1]+'('+x[2]+") ^ 1'b1;",text);assert n==1
        elif fault=='missing_write':text=text.replace('phase==4 && fired',"1'b0 && fired")
        elif fault=='write_order':
            pattern=r'always @\(posedge exec_clk\) begin ((?:bank\d+_[tv]\[write\d+_addr\]<=write\d+_(?:tag|value); ?)+) end'
            text,n=re.subn(pattern,lambda x:'always @(posedge exec_clk) begin '+';'.join(reversed([s.strip() for s in x[1].split(';') if s.strip()]))+'; end',text);assert n
        elif fault=='early_commit':text=text.replace('phase==4 && fired','phase==3 && fired')
        elif fault=='missing_trigger':text,n=re.subn(r'\(phase==1\)\?\(seeded && .*?\):\(phase==3\)',"(phase==1)?1'b0:(phase==3)",text);assert n
        elif fault=='repeated_trigger':
            text,n0=re.subn(r'(fired\[(\d+)\]<=.*?\(phase==0 && accept\)\?)0:',lambda x:x[1]+'fired['+x[2]+']:',text);assert n0
            text,n=re.subn(r'(fired\[(\d+)\]<=.*?\(phase==1\)\?)(.*?)(:\(phase==3\))',lambda x:x[1]+'(fired['+x[2]+'] || '+x[3]+')'+x[4],text);assert n
        elif fault=='xz_confusion':
            text,n=re.subn(r'(wire \[\d+:0\] (write\d+)_value=)([^;]+);',lambda x:x[1]+'('+x[3]+') & ~'+x[2]+'_tag;',text);assert n
        if text==rtl:raise ValueError('Fault did not mutate RTL')
        (f/'mutant.sv').write_text(text);tb,data=make_bench(m,trace,'01xz'[initial],True);(f/'encoded-tb.sv').write_text(tb);(f/'encoded-inputs.mem').write_text(data)
        command(f,'compile',[iv/'bin/iverilog','-B',iv/'lib/ivl','-g2012','-s','tb','-o',f/'mutant.vvp',f/'mutant.sv',f/'encoded-tb.sv'])
        rr=run_stream(f,'execute',[iv/'bin/vvp',f/'mutant.vvp']);reason=None
        if rr['exit_code']!=0:reason='Runtime guard rejected mutated execution'
        else:
            try:compare_streams(base/f'initial-{initial}/original-execute/stdout.log.gz',f/'execute/stdout.log.gz',m,len(trace))
            except ValueError as e:reason=str(e)
        if reason is None:raise ValueError('Fault escaped exact comparator: '+fault)
        row=dict(fault=fault,status='DETECTED',reason=reason,mutant_sha256=digest(f/'mutant.sv'),exit_code=rr['exit_code']);write(f/'result.json',row);rows.append(row)
    gate=Path(request['run'])/'reports/behavior-gates-v1/GateRAM';gm=json.loads((gate/'mapping.json').read_bytes());gt=json.loads((gate/'trace.json').read_bytes())[:1];gt[0]['inputs']['ck']='0'
    f=out/'illegal_initial';f.mkdir();tb,data=make_bench(gm,gt,'1',True);(f/'encoded-tb.sv').write_text(tb);(f/'encoded-inputs.mem').write_text(data)
    command(f,'compile',[iv/'bin/iverilog','-B',iv/'lib/ivl','-g2012','-s','tb','-o',f/'mutant.vvp',gate/'encoded.sv',f/'encoded-tb.sv'])
    rr=run_stream(f,'execute',[iv/'bin/vvp',f/'mutant.vvp'])
    with gzip.open(f/'execute/stdout.log.gz','rt') as stream:text=stream.read()
    if rr['exit_code']==0 or 'controller fault 2' not in text:raise ValueError('Illegal latch seed not rejected')
    rows.append(dict(fault='illegal_initial',status='REJECTED',exit_code=rr['exit_code'],controller_fault=2))
    for guard in ('input_race','latch_settlement'):
        f=out/guard;f.mkdir()
        if guard=='input_race':
            trace2=copy.deepcopy(trace[:1]);row=copy.deepcopy(trace2[0]);row['inputs']['clk']='0';row['inputs']['en']='1';trace2.append(row)
            mapping=m;text=rtl;expected=1
        else:
            seed=copy.deepcopy(json.loads((gate/'trace.json').read_bytes())[0]);seed['inputs']['ck']='1';seed['inputs']['en']='0';seed['inputs']['te']='0'
            row=copy.deepcopy(seed);row['inputs']['en']='1';end=copy.deepcopy(row);end['inputs']['ck']='0';trace2=[seed,row,end]
            mapping=gm;text=(gate/'encoded.sv').read_text().replace('phase==2 && (seeded','phase==6 && (seeded');expected=3
        tb,data=make_bench(mapping,trace2,'0',True);(f/'encoded-tb.sv').write_text(tb);(f/'encoded-inputs.mem').write_text(data);(f/'mutant.sv').write_text(text)
        command(f,'compile',[iv/'bin/iverilog','-B',iv/'lib/ivl','-g2012','-s','tb','-o',f/'mutant.vvp',f/'mutant.sv',f/'encoded-tb.sv'])
        rr=run_stream(f,'execute',[iv/'bin/vvp',f/'mutant.vvp'])
        with gzip.open(f/'execute/stdout.log.gz','rt') as stream:observed=stream.read()
        if rr['exit_code']==0 or ('controller fault '+str(expected)) not in observed:raise ValueError('Guard not detected: '+guard)
        rows.append(dict(fault=guard,status='REJECTED',exit_code=rr['exit_code'],controller_fault=expected,scope='Invalid input contract or injected missing latch update; no arbitrary feedback admission'))
    write(out/'summary.json',rows)


def regenerate(request,out):
    from fourstate_scalable import parse_scalable,encode_scalable
    run=Path(request['run']);rows=[]
    specs=[('behavior-small-v3',n) for n in ('Queue1_AXI4BundleW','AXI4Buffer','ram_2x273','Queue2_AXI4BundleR','Queue2_AXI4BundleAW_3','MemoryOrder','MemorySlices')]
    specs += [('behavior-gates-v1',n) for n in ('GateRAM','GateFarm')]
    specs += [('behavior-large-v3',n) for n in ('array_0_6144x64','array_4096x96')]
    specs += [('behavior-two-reset-v1','TwoReset')]
    for label,top in specs:
        base=run/'reports'/label/top;old=json.loads((base/'ir.json').read_bytes());start=time.monotonic()
        ir=parse_scalable(base/'original',top,old['clock'],event_clocks=old['events']['roots'],immediate_assertions=True);rtl,m=encode_scalable(ir)
        if rtl!=(base/'encoded.sv').read_text():raise ValueError('Current regeneration differs: '+top)
        f=out/top;f.mkdir();write(f/'current.ir.json',ir);write(f/'current.mapping.json',m)
        rows.append(dict(top=top,status='CURRENT_SOURCE_EXACT_ENCODING',executed_case=str(base),encoded_sha256=hashlib.sha256(rtl.encode()).hexdigest(),seconds=time.monotonic()-start,original_sha256={p.name:digest(p) for p in (base/'original').glob('*.sv')}))
    write(out/'summary.json',rows)


def main():
    from audit_fourstate_f52_worker import setup
    import resource
    os.umask(0o077);p=argparse.ArgumentParser();p.add_argument('--request',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    request=json.loads(a.request.read_bytes());setup(Path(request['run']));out=a.out
    receipt=json.loads((Path(request['run'])/'reports/input-receipt.json').read_bytes());source=Path(request['input_run'])/'reports/inputs'
    for row in receipt['files']:
        f=source/row['name']
        if f.is_symlink() or digest(f)!=row['sha256']:raise ValueError('Frozen input changed')
    source_root=_PROJECT_ROOT/'scripts'
    write(out/'machine.json',dict(hostname=os.uname().nodename,python=sys.version,inherited_limits={n:resource.getrlimit(getattr(resource,n)) for n in ('RLIMIT_CPU','RLIMIT_AS','RLIMIT_FSIZE')},source_hashes={f.relative_to(source_root).as_posix():digest(f) for f in source_root.rglob('*.py') if f.is_file()}))
    iv=runtime(Path(request['run']),out)
    mode=request.get('mode','probe')
    if mode=='probe':probe(request,out,iv)
    elif mode=='compat':compat(request,out)
    elif mode=='compare':behavior(request,out,iv)
    elif mode=='scale':scale(request,out,iv)
    elif mode=='tests':tests(request,out)
    elif mode=='regressions':legacy_regressions(request,out,iv)
    elif mode=='faults':faults(request,out,iv)
    elif mode=='regenerate':regenerate(request,out)
    else:raise ValueError('Unknown worker mode: '+mode)


if __name__=='__main__':main()
