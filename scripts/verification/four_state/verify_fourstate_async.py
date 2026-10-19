"""F4.3: native SV events / encoded RTL / actual Lean async differential tests."""
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
from collections import Counter
import itertools
import json
from pathlib import Path
import shutil
import sys
import traceback

from common import ROOT, run_logged
from fourstate2lean import digest, fresh_directory, write, provenance
from fourstate_events import ALPHABET, POSEDGE, validate
from fourstate_simulate import load, simulate, decode
from fourstate_sequential import state_ports
from verify_fourstate import tools_record
from verify_fourstate_sequential import build_deposit, compare

LEVEL_SHA = '8a8f4f473cee700f629101b49d50668c507a90791781929a23cfdac6e975f089'


def run_rtl(source, mapping, trace, initial, folder, encoded=False):
    """Native posedge controls, single atomic vector stimulus, #0 pre-NBA sample.

    Encoded reset rails settle before separate event controls are applied. The
    native SV event block commits all candidate rails with a single NBA. Python
    does not decide whether the RTL register update executes.
    """
    rows, init = validate(mapping, trace, initial)
    folder.mkdir(parents=True)
    lines = ['module tb;']
    connections, inputs, outputs, states, current, next_ = [], {}, [], [], [], []
    def port(name, width, direction, bounds=None):
        local = 'p' + str(len(connections))
        bounds = bounds or (width-1,0)
        lines.append(f"{'reg' if direction=='input' else 'wire'} [{bounds[0]}:{bounds[1]}] {local};")
        connections.append(f'.{name}({local})')
        return local
    for p in mapping['ports']:
        if encoded and p.get('role') == 'clock':
            continue
        for key in ('tag','value') if encoded else ('name',):
            local = port(p[key], p['width'], p['direction'], None if encoded else (p['left'],p['right']))
            if p['direction']=='input':
                inputs[p[key]]=(local,p['width'])
            else:
                outputs.append((p[key],local,p['width']))
    for p in mapping['states']:
        if encoded:
            for rail in ('tag','value'):
                cur,nxt=p['current_'+rail],p['next_'+rail]
                local=port(cur,p['width'],'input');current.append((local,cur,p['width']))
                next_.append(port(nxt,p['width'],'output'));states.append((cur,local,p['width']))
        else:
            states.append((p['name'],'dut.'+p['rtl_path'],p['width']))
    lines.append((mapping['encoded_top'] if encoded else mapping['top'])+' dut('+','.join(connections)+');')
    clock,reset=mapping['clock'],mapping['events']['reset']
    if encoded:
        lines.append('reg event_clock,event_reset;')
        ec,er='event_clock','event_reset'
    else:
        ec,er=inputs[clock][0],inputs[reset][0]
    lines += ['integer clock_count=0, reset_count=0, fire_count=0;',
              f'always @(posedge {ec}) clock_count=clock_count+1;',
              f'always @(posedge {er}) reset_count=reset_count+1;',
              f'always @(posedge {ec} or posedge {er}) begin', 'fire_count=fire_count+1;']
    if encoded:
        lines.append('{'+','.join(x[0] for x in current)+'} <= {'+','.join(next_)+'};')
    lines += ['end','initial begin',f"{{{ec},{er}}}=2'b00;"]
    first = rows[0]['inputs'] if encoded else trace[0]['inputs']
    for name,(local,width) in inputs.items():
        if not encoded and name in (clock,reset):continue
        bits=format(first[name],f'0{width}b') if encoded else first[name]
        lines.append(f"{local}={width}'b{bits};")
    if encoded:
        lines.extend(f"{local}={width}'d{init[name]};" for local,name,width in current)
    lines.append('#1;')
    if not encoded:
        lines.extend(f"$fourstate_deposit(dut.{p['rtl_path']},{p['width']}'b{initial[p['name']]});" for p in mapping['states'])
    lines.append('#1;')
    observe=outputs+states
    def display(i,phase):
        return '$display("'+f'{i} {phase} %0d %0d %0d '+' '.join('%b' for _ in observe)+'",clock_count,reset_count,fire_count,'+','.join(x[1] for x in observe)+');'
    for i,row in enumerate(trace):
        values=rows[i]['inputs'] if encoded else row['inputs']
        for name,(local,width) in inputs.items():
            if not encoded and name in (clock,reset):continue
            bits=format(values[name],f'0{width}b') if encoded else values[name]
            lines.append(f"{local}={width}'b{bits};")
        lines += ['#1;',f"{{{ec},{er}}}=2'b{row['inputs'][clock]}{row['inputs'][reset]};",'#0;',display(i,'pre'),'#1;',display(i,'post')]
    lines += ['$finish;','end','endmodule']
    bench=folder/'tb.sv';bench.write_text('\n'.join(lines)+'\n',encoding='utf8')
    image=folder/'sim.vvp'
    from fourstate_elaborated import source_files
    if run_logged([shutil.which('iverilog'),'-g2012','-s','tb','-o',str(image),*[str(p) for p in source_files(source)],str(bench)],folder/'compile',echo=False):
        raise RuntimeError('Async Icarus compilation failed: '+str(folder))
    plugin=build_deposit(folder/'deposit') if not encoded else None
    command=[shutil.which('vvp')]+(['-M',str(plugin.parent),'-m',plugin.stem] if plugin else [])+[str(image)]
    if run_logged(command,folder/'execute',echo=False):raise RuntimeError('Async RTL execution failed')
    result,counts,previous,previous_counts=[],[],('0','0'),[0,0,0]
    raw=[line for line in (folder/'execute/stdout.log').read_text().splitlines() if '$finish called at' not in line]
    if len(raw)!=2*len(trace):raise ValueError('Incomplete async RTL trace')
    for i,row in enumerate(trace):
        c,r=row['inputs'][clock],row['inputs'][reset]
        cr,rr=(previous[0],c) in POSEDGE,(previous[1],r) in POSEDGE
        record=dict(sample=i,clock=ALPHABET.index(c),reset=ALPHABET.index(r),clock_rising=cr,reset_rising=rr,fired=cr or rr)
        count_rows=[]
        for j,phase in enumerate(('pre','post')):
            fields=raw[2*i+j].split()
            if len(fields)!=5+len(observe) or fields[:2]!=[str(i),phase]:raise ValueError('Malformed async sample: '+raw[2*i+j])
            native=list(map(int,fields[2:5]));count_rows.append(native)
            expected=[previous_counts[0]+int(cr),previous_counts[1]+int(rr),previous_counts[2]+int(cr or rr)]
            if native!=expected:raise ValueError(f'Native SV edge/activation table mismatch sample {i}: {native} != {expected}')
            values=[]
            for (_,_,width),bits in zip(observe,fields[5:]):
                if len(bits)!=width or any(b not in ('01' if encoded else ALPHABET) for b in bits):raise ValueError('Invalid observed async bits')
                values.append(int(bits,2) if encoded else bits)
            outs=dict(zip((x[0] for x in outputs),values[:len(outputs)]));regs=dict(zip((x[0] for x in states),values[len(outputs):]))
            record[phase]=dict(outputs=decode(mapping,outs),states=decode({'ports':state_ports(mapping)},regs)) if encoded else dict(outputs=outs,states=regs)
        counts.append(dict(sample=i,pre=count_rows[0],post=count_rows[1]));previous_counts=count_rows[1]
        result.append(record);previous=(c,r)
    write(folder/'native-event-counts.json',counts);write(folder/'result.json',result)
    return result


def corpus(top):
    data_names = {'AsyncRegister':('enable','d'),'AsyncSwap':('enable',),
                  'LevelGateway':('io_interrupt','io_plic_ready','io_plic_complete')}[top]
    patterns = list(itertools.product(ALPHABET,repeat=len(data_names)))
    trace=[]
    def row(c,r,data):trace.append(dict(inputs=dict(clock=c,reset=r,**dict(zip(data_names,data)))))
    # Four representative data patterns cross every joint control transition.
    selected=[patterns[i] for i in sorted({0,len(patterns)//3,2*len(patterns)//3,len(patterns)-1})]
    for data in selected:
        for c0,r0,c1,r1 in itertools.product(ALPHABET,repeat=4):
            row('0','0',data);row(c0,r0,data);row(c1,r1,data);row(c1,r1,data)
    # Every data combination at known clock edges and asynchronous 0->1/X/Z.
    for data in patterns:
        for r in ALPHABET:
            row('0','0',data);row('0',r,data);row('1',r,data);row('1',r,data);row('0','0',data)
    return trace


def oracle(top,trace,initial,actual):
    state=dict(initial)
    def inv(a):return {'0':'1','1':'0','x':'x','z':'x'}[a]
    def and_(a,b):return '0' if '0' in (a,b) else '1' if a==b=='1' else 'x'
    def or_(a,b):return '1' if '1' in (a,b) else '0' if a==b=='0' else 'x'
    def outputs(v):
        if top=='AsyncRegister':return dict(q=state[top+'.q'],q_n=inv(state[top+'.q']))
        if top=='AsyncSwap':return dict(q=state[top+'.q'],r=state[top+'.r'])
        return dict(io_plic_valid=and_(v['io_interrupt'],inv(state[top+'.inFlight'])))
    for i,(row,observed) in enumerate(zip(trace,actual)):
        v=row['inputs']
        pre=dict(outputs=outputs(v),states=dict(state))
        if observed['fired']:
            if top=='AsyncRegister':
                if v['reset']=='1':state[top+'.q']='0'
                elif v['enable']=='1':state[top+'.q']=v['d']
            elif top=='AsyncSwap':
                if v['reset']=='1':state={top+'.q':'0',top+'.r':'1'}
                elif v['enable']=='1':state={top+'.q':state[top+'.r'],top+'.r':state[top+'.q']}
            else:
                state[top+'.inFlight']='0' if v['reset']=='1' else and_(inv(v['io_plic_complete']),or_(and_(v['io_interrupt'],v['io_plic_ready']),state[top+'.inFlight']))
        if observed['pre']!=pre or observed['post']!=dict(outputs=outputs(v),states=state):
            raise ValueError(f'Independent four-state oracle mismatch {top} sample {i}')


def execute(source,top,folder):
    folder.mkdir()
    command=[sys.executable,'-B',str(ROOT/'scripts/fourstate2lean.py'),str(source),'--top',top,
             '--mode','sequential','--clock','clock','--async-reset','reset','--out',str(folder/'converted'),
             '--preprocess-report',str(folder/'preprocessing.json')]
    if run_logged(command,folder/'conversion-command',echo=False):raise RuntimeError('Async conversion failed: '+top)
    manifest=folder/'converted/fourstate-manifest.json';mapping,_=load(manifest)
    trace=corpus(top);write(folder/'trace.json',trace)
    initials = [dict(zip((p['name'] for p in mapping['states']), ('z','x')))] if top=='AsyncSwap' else [{p['name']:v for p in mapping['states']} for v in ALPHABET]
    cases=[]
    for index,initial in enumerate(initials):
        case=folder/('initial-'+str(index));case.mkdir();write(case/'initial.json',initial)
        print('Three-way',top,'initial',initial,len(trace),'samples',flush=True)
        original=run_rtl(source,mapping,trace,initial,case/'original')
        encoded=run_rtl(manifest.parent/'encoded.sv',mapping,trace,initial,case/'encoded',True)
        lean=simulate(manifest,trace,case/'lean',initial)
        compare(original,encoded,lean)
        for rows in (original,encoded,lean):oracle(top,trace,initial,rows)
        coverage=dict(samples=len(trace),clock_edges=sum(r['clock_rising'] for r in original),reset_edges=sum(r['reset_rising'] for r in original),
                      simultaneous=sum(r['clock_rising'] and r['reset_rising'] for r in original),
                      reset_only=sum(r['reset_rising'] and not r['clock_rising'] for r in original),
                      no_event=sum(not r['fired'] for r in original),
                      observed_states={p['name']:sorted({r[phase]['states'][p['name']] for r in original for phase in ('pre','post')}) for p in mapping['states']})
        result=dict(status='THREE_WAY_PASS',initial=initial,coverage=coverage,source_sha256=digest(source),manifest_sha256=digest(manifest))
        write(case/'summary.json',result);cases.append(result)
    pairs=Counter();clock_pairs=Counter();reset_pairs=Counter()
    prev=('0','0')
    for row in trace:
        cur=(row['inputs']['clock'],row['inputs']['reset']);pairs[''.join(prev+cur)]+=1
        clock_pairs[prev[0]+cur[0]]+=1;reset_pairs[prev[1]+cur[1]]+=1;prev=cur
    if len(pairs)!=256 or len(clock_pairs)!=16 or len(reset_pairs)!=16:raise ValueError('Control transition coverage incomplete')
    result=dict(status=top.upper()+'_THREE_WAY_PASS',top=top,source_sha256=digest(source),state_bits=sum(p['width'] for p in mapping['states']),
                samples=sum(c['coverage']['samples'] for c in cases),cases=cases,events=mapping['events'],
                joint_control_transitions=dict(pairs),clock_transitions=dict(clock_pairs),reset_transitions=dict(reset_pairs),
                scope='Exact saved module, finite settled sampled event contract; not time-zero or arbitrary delta-event equivalence')
    write(folder/'summary.json',result)
    return result


def campaign(out,level):
    out=fresh_directory(out);report=dict(status='RUNNING',command=[sys.executable,*sys.argv],normalization=False,cases=[])
    try:
        report['tools']=tools_record(out/'tools')
        if digest(level)!=LEVEL_SHA:raise ValueError('LevelGateway input hash mismatch')
        # Single-register fixture must pass before multi-NBA fixture or real RTL.
        for top in ('AsyncRegister','AsyncSwap'):
            report['cases'].append(execute(ROOT/'verification/fourstate/async'/(top+'.sv'),top,out/top))
        inputs=out/'inputs';inputs.mkdir();source=inputs/'LevelGateway.sv';source.write_bytes(level.read_bytes())
        report['cases'].append(execute(source,'LevelGateway',out/'LevelGateway'))
        blocked=out/'initial-enabled';blocked.mkdir()
        command=[sys.executable,'-B',str(ROOT/'scripts/fourstate2lean.py'),str(source),'--top','LevelGateway','--mode','sequential',
                 '--clock','clock','--async-reset','reset','-D','ENABLE_INITIAL_REG_','--out',str(blocked/'converted')]
        code=run_logged(command,blocked/'command',echo=False)
        error=(blocked/'command/stderr.log').read_text(encoding='utf8')
        if code==0 or 'initial/nonclocked process execution unsupported' not in error:raise ValueError('Active initial was not rejected')
        report['initial_enabled']=dict(status='EXPECTED_REJECTION',exit_code=code,diagnostic=error.strip().splitlines()[-1])
        report['source_snapshot_sha256']=provenance(out)
        report['status']='LEVELGATEWAY_THREE_WAY_PASS'
    except Exception:report.update(status='FAIL',error=traceback.format_exc())
    write(out/'summary.json',report);return report


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--level-source',type=Path,required=True);p.add_argument('--out',type=Path,required=True)
    args=p.parse_args();result=campaign(args.out.resolve(),args.level_source.resolve())
    print(json.dumps(dict(status=result['status'],error=result.get('error'))))
    return 0 if result['status']=='LEVELGATEWAY_THREE_WAY_PASS' else 1


if __name__=='__main__':raise SystemExit(main())
