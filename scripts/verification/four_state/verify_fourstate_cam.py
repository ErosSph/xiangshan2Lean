"""F4.1 finite raw RTL / Boolean RTL / Lean checks, with ModelSim raw reference.

The installed Icarus rejects explicit automatic lifetime declarations. ModelSim
executes the untouched reference. Encoded RTL and Lean use existing runners.
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

import argparse
from collections import Counter
import itertools
import json
from pathlib import Path
import random
import shutil
import sys
import traceback

from common import ROOT, run_logged
from fourstate2lean import digest, fresh_directory, translate, write, provenance
from fourstate_sequential import validate
from fourstate_simulate import load, simulate
from verify_fourstate import tools_record
from verify_fourstate_sequential import run_rtl, compare

CAM_SHA='391c15027554668dd69525390ad7208de6910adf46ba9309b229f27e9ed6bcc3'
ALPHABET='01xz'


def modelsim(source,mapping,trace,initial,folder,*,deposit_initial=True):
    """No source rewrites or forces; one explicit initial deposit, then NBA steps."""
    validate(mapping,trace,initial);folder.mkdir(parents=True,exist_ok=False)
    lines=['`timescale 1ns/1ps','module tb;'];connections=[];inputs={};observed=[]
    for i,p in enumerate(mapping['ports']):
        name='p'+str(i);direction=p['direction']
        lines.append(f"{'reg' if direction=='input' else 'wire'} [{p['left']}:{p['right']}] {name};")
        connections.append('.'+p['name']+'('+name+')')
        if direction=='input':inputs[p['name']]=name
        else:observed.append(('outputs',p['name'],name,p['width']))
    for p in mapping['states']:observed.append(('states',p['name'],'dut.'+p['rtl_path'],p['width']))
    lines+=[' '+mapping['top']+' dut('+','.join(connections)+');','initial begin']
    lines.append(inputs[mapping['clock']]+" = 1'b0;")
    for p in mapping['ports']:
        if p['direction']=='input' and p.get('role')!='clock':
            lines.append(f"{inputs[p['name']]} = {p['width']}'b{trace[0]['inputs'][p['name']]};")
    lines.append('#1;')
    if not deposit_initial and any(set(v)-{'x'} for v in initial.values()):
        raise ValueError('Natural uninitialized reference requires an explicit all-X expected initial state')
    if deposit_initial:
        for p in mapping['states']:
            lines.append(f"dut.{p['rtl_path']} = {p['width']}'b{initial[p['name']]};")
    lines.append('#1;')
    for sample,row in enumerate(trace):
        for p in mapping['ports']:
            if p['direction']=='input' and p.get('role')!='clock':
                lines.append(f"{inputs[p['name']]} = {p['width']}'b{row['inputs'][p['name']]};")
        for phase in ('pre','post'):
            if phase=='post':lines.append(f"{inputs[mapping['clock']]} = 1'b{row['inputs'][mapping['clock']]};")
            lines.append('#1;')
            lines.append('$display("F41 '+str(sample)+' '+phase+' '+' '.join('%b' for _ in observed)+'", '+','.join(n for _,_,n,_ in observed)+');')
    lines+=['$finish;','end','endmodule']
    bench=folder/'tb.sv';bench.write_text('\n'.join(lines)+'\n',encoding='utf-8')
    commands=[('ini',[shutil.which('vmap'),'-c']),('library',[shutil.which('vlib'),'work']),
        ('compile',[shutil.which('vlog'),'-sv','-work','work',source.as_posix(),bench.as_posix()]),
        ('execute',[shutil.which('vsim'),'-c','-onfinish','stop','-lib','work','tb','-l','transcript.log',
                    '-wlf','sim.wlf','-do','onerror {quit -code 1}; run -all; quit -code 0'])]
    for label,command in commands:
        if any(x is None for x in command):raise RuntimeError('Existing ModelSim executables required; no installation attempted')
        if run_logged(command,folder/label,cwd=folder,echo=False):raise RuntimeError('ModelSim '+label+' failed: '+str(folder))
    text=(folder/'execute/stdout.log').read_text(encoding='utf-8')
    if '** Error:' in text or '** Fatal:' in text:raise RuntimeError('ModelSim reported a simulation error')
    raw=[]
    for line in text.splitlines():
        clean=line[2:] if line.startswith('# ') else line
        if not clean.startswith('F41 '):continue
        fields=clean.split();sample=len(raw)//2;phase=('pre','post')[len(raw)%2]
        if fields[:3]!=['F41',str(sample),phase] or len(fields)!=3+len(observed):raise ValueError('Malformed ModelSim sample: '+line)
        value={'outputs':{},'states':{}}
        for (section,name,_,width),bits in zip(observed,fields[3:]):
            if len(bits)!=width or any(c not in ALPHABET for c in bits):raise ValueError('Invalid ModelSim four-state value')
            value[section][name]=bits
        raw.append(value)
    if len(raw)!=2*len(trace):raise ValueError('Incomplete ModelSim reference output')
    result=[];previous='0'
    for sample,row in enumerate(trace):
        clock=row['inputs'][mapping['clock']]
        result.append(dict(sample=sample,clock=int(clock),rising=previous=='0' and clock=='1',pre=raw[2*sample],post=raw[2*sample+1]))
        previous=clock
    write(folder/'result.json',result);return result


def samples(values,clock):
    trace=[]
    for row in values:
        previous={k:v for k,v in trace[-1]['inputs'].items() if k!=clock} if trace else row
        trace.extend([{'inputs':{**previous,clock:'0'}},{'inputs':{**row,clock:'0'}},
                      {'inputs':{**row,clock:'1'}},{'inputs':{**row,clock:'1'}}])
    return trace


def bit_xor(a,b):return ''.join(str(int(x)^int(y)) if x in '01' and y in '01' else 'x' for x,y in zip(a,b))
def mux(c,a,b):return a if c=='1' else b if c=='0' else ''.join(x if x==y else 'x' for x,y in zip(a,b))
def bit_and(a,b):return '0' if '0' in (a,b) else '1' if a==b=='1' else 'x'
def equal(a,b):return '0' if any(x in '01' and y in '01' and x!=y for x,y in zip(a,b)) else 'x' if any(c in 'xz' for c in a+b) else '1'


def oracle(top,states,inputs):
    s=dict(states);p=inputs
    if top=='ProceduralLocals':
        t=p['a'] if p['en']=='1' else bit_xor(s[top+'.q'],p['b'])
        return {top+'.q':t,top+'.r':s[top+'.q'],top+'.fresh':'xx',
                top+'.s':p['b'] if p['choose']=='1' else p['a']}
    if top=='LocalWidths':
        extended=p['a'][0]*2+p['a']
        return {top+'.q':p['a']*2 if p['en']=='1' else extended,top+'.r':extended}
    if top=='CAMTemplate':
        index=p['io_w_bits_index']
        if p['io_w_valid']=='1' and all(c in '01' for c in index):
            s[top+'.array_'+str(int(index,2))]=p['io_w_bits_data_idx']+p['io_w_bits_data_tag']
        return s
    raise ValueError(top)


def expected_outputs(top,states,p):
    if top!='CAMTemplate':return {name.split('.',1)[1]:value for name,value in states.items()}
    request=p['io_r_req_0_idx']+p['io_r_req_0_tag']
    return {'io_r_resp_0_'+str(i):equal(states[top+'.array_'+str(i)],request) for i in range(8)}


def check_oracle(top,initial,trace,paths,folder):
    state=dict(initial);previous='0';checks=0
    coverage={'inputs':{},'states':{},'outputs':{},'state_bit_symbols':{n:[set() for _ in bits] for n,bits in initial.items()},'events':Counter()}
    write_pairs=set();read_index=set()
    clock='clock' if top=='CAMTemplate' else 'clk'
    for sample,row in enumerate(trace):
        p=row['inputs'];rising=previous=='0' and p[clock]=='1'
        for name,value in p.items():coverage['inputs'].setdefault(name,Counter()).update(value)
        for phase in ('pre','post'):
            if phase=='post' and rising:state=oracle(top,state,p)
            expected=dict(outputs=expected_outputs(top,state,p),states=state)
            for label,actual in paths.items():
                if actual[sample][phase]!=expected:raise ValueError(f'Independent oracle mismatch: {top}/{label}/{sample}/{phase}: {expected} != {actual[sample][phase]}')
            checks+=sum(len(v) for v in expected['outputs'].values())+sum(len(v) for v in state.values())
            for name,value in state.items():
                coverage['states'].setdefault(name,Counter()).update(value)
                for index,symbol in enumerate(value):coverage['state_bit_symbols'][name][index].add(symbol)
            for name,value in expected['outputs'].items():coverage['outputs'].setdefault(name,Counter()).update(value)
        if top=='CAMTemplate':
            read_index.add(p['io_r_req_0_idx'])
            if rising:write_pairs.add((p['io_w_valid'],p['io_w_bits_index']))
        coverage['events']['rising' if rising else 'hold']+=1
        previous=p[clock]
    if paths['original'][0]['pre']['states']!=initial:raise ValueError('Explicit initial state not observed exactly')
    coverage['independent_bit_positions']=checks;coverage['implementations_checked']=3
    coverage['state_bit_symbols']={name:[''.join(c for c in ALPHABET if c in seen) for seen in positions]
                                   for name,positions in coverage['state_bit_symbols'].items()}
    if top=='CAMTemplate':
        coverage['write_enable_index_combinations']=len(write_pairs)
        coverage['read_index_symbols']=''.join(c for c in ALPHABET if c in read_index)
        coverage['all_72_state_bits_observed_01xz']=all(seen==ALPHABET for positions in coverage['state_bit_symbols'].values() for seen in positions)
        if len(write_pairs)!=256 or len(read_index)!=4 or not coverage['all_72_state_bits_observed_01xz']:
            raise ValueError('CAM required coverage incomplete')
    write(folder/'coverage.json',coverage);return coverage


def case(folder,top,source,trace,initial,manifest=None,reference_backend='modelsim'):
    folder.mkdir();write(folder/'initial.json',initial)
    (folder/'trace.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in trace),encoding='utf-8')
    if manifest is None:
        command=[sys.executable,'-B',str(ROOT/'scripts/fourstate2lean.py'),str(source),'--top',top,
                 '--mode','sequential','--clock','clock' if top=='CAMTemplate' else 'clk','--out',str(folder/'converted')]
        if run_logged(command,folder/'conversion-command',echo=False):raise RuntimeError('Conversion failed: '+top)
        manifest=folder/'converted/fourstate-manifest.json'
    mapping,irpath=load(manifest)
    reference=(modelsim(source,mapping,trace,initial,folder/'original') if reference_backend=='modelsim'
               else run_rtl(source,mapping,trace,initial,folder/'original'))
    encoded=run_rtl(manifest.parent/'encoded.sv',mapping,trace,initial,folder/'encoded',True)
    lean=simulate(manifest,trace,folder/'lean',initial)
    compare(reference,encoded,lean)
    coverage=check_oracle(top,initial,trace,dict(original=reference,encoded=encoded,lean=lean),folder)
    result=dict(status='THREE_WAY_PASS',top=top,source_sha256=digest(source),manifest=str(manifest),
        reference_backend=reference_backend,
        manifest_sha256=digest(manifest),samples=len(trace),cycles=coverage['events']['rising'],
        state_bits=sum(p['width'] for p in mapping['states']),
        output_bits=sum(p['width'] for p in mapping['ports'] if p['direction']=='output'),coverage=coverage)
    write(folder/'result.json',result);return result


def cam_values():
    rows=[]
    def row(valid='0',index='000',data='000000000',request=None):
        request=data if request is None else request
        return dict(io_w_valid=valid,io_w_bits_index=index,io_w_bits_data_idx=data[0],io_w_bits_data_tag=data[1:],
                    io_r_req_0_idx=request[0],io_r_req_0_tag=request[1:])
    # Every physical state bit is written to 0/1/X/Z, with a settled matching read.
    for symbol,index in itertools.product(ALPHABET,range(8)):
        rows.append(row('1',format(index,'03b'),symbol*9))
        rows.append(row('0',format(index,'03b'),symbol*9))
    # Every enable and 3-bit four-state write-index combination, explicitly testing
    # unknown procedural guards. The binary-data payload distinguishes hold/write.
    for valid,digits in itertools.product(ALPHABET,itertools.product(ALPHABET,repeat=3)):
        index=''.join(digits);data='101010101'
        rows.append(row(valid,index,data,request='010101010'))
    # Full scalar four-state read index with diverse tags and stored words.
    for request_idx,tag in itertools.product(ALPHABET,['00000000','11111111','xxxxxxxx','zzzzzzzz','01xz10zx']):
        rows.append(row('0','000',data='01xz01xz0',request=request_idx+tag))
    # Deterministic multi-cycle mixed data, controls and arbitrary tag bits.
    rng=random.Random(410171)
    for i in range(128):
        data=''.join(rng.choice(ALPHABET) for _ in range(9));req=''.join(rng.choice(ALPHABET) for _ in range(9))
        rows.append(row(rng.choice(ALPHABET),format(i%8,'03b') if i%3 else ''.join(rng.choice(ALPHABET) for _ in range(3)),data,req))
    return rows


def campaign(out,source,stage):
    out=fresh_directory(out);report=dict(status='RUNNING',stage=stage,cases=[],
        raw_reference='ModelSim: exact saved original CAM / explicit automatic local fixtures; no ternary in this new reference corpus',normalization=False)
    try:
        report['tools']=tools_record(out/'tools')
        for name in ('vlog','vsim','vlib','vmap'):
            binary=shutil.which(name)
            if binary is None:raise RuntimeError('Installed ModelSim required')
            report['tools'][name]=dict(path=binary,sha256=digest(Path(binary)))
            if name in ('vlog','vsim'):
                if run_logged([binary,'-version'],out/'tools'/name,echo=False):raise RuntimeError('ModelSim version probe failed')
        if stage=='fixtures':
            words=[''.join(x) for x in itertools.product(ALPHABET,repeat=2)]
            specs=[('ProceduralLocals',[dict(a=a,b=b,en=e,choose=c) for a,b,e,c in itertools.product(words,words,ALPHABET,ALPHABET)],
                    dict(q='z1',r='x0',s='1z',fresh='x0')),
                   ('LocalWidths',[dict(a=a,en=e) for a,e in itertools.product(words,ALPHABET)],dict(q='xz10',r='z01x'))]
            for top,rows,initial in specs:
                print('Validating',top,flush=True)
                report['cases'].append(case(out/top,top,ROOT/'verification/fourstate/procedural'/(top+'.sv'),samples(rows,'clk'),{top+'.'+n:v for n,v in initial.items()}))
        else:
            if source is None or digest(source)!=CAM_SHA:raise ValueError('F3.2.2 raw CAM input hash mismatch')
            target=out/'CAMTemplate.sv';target.write_bytes(source.read_bytes());source=target
            trace=samples(cam_values(),'clock');manifest=None
            for label in ('mixed','all-x'):
                initial={'CAMTemplate.array_'+str(i):(''.join(ALPHABET[(i+j)%4] for j in range(9)) if label=='mixed' else 'x'*9) for i in range(8)}
                print('Validating CAMTemplate',label,flush=True)
                result=case(out/label,'CAMTemplate',source,trace,initial,manifest)
                manifest=Path(result['manifest']);report['cases'].append(result)
        report['source_snapshot_sha256']=provenance(out)
        report['status']='CAM_THREE_WAY_PASS' if stage=='cam' else 'PROCEDURAL_THREE_WAY_PASS'
    except Exception:report.update(status='FAIL',error=traceback.format_exc())
    write(out/'summary.json',report);return report


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--stage',choices=['fixtures','cam'],required=True)
    p.add_argument('--source',type=Path);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    report=campaign(a.out.resolve(),a.source.resolve() if a.source else None,a.stage)
    print(json.dumps(dict(status=report['status'],error=report.get('error'))))
    return 0 if report['status'] in ('CAM_THREE_WAY_PASS','PROCEDURAL_THREE_WAY_PASS') else 1


if __name__=='__main__':raise SystemExit(main())
