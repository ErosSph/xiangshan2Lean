"""Bounded F4.5 memory contracts and exact raw RTL / encoded RTL / Lean tests."""
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
import itertools
import json
from pathlib import Path
import random
import sys
import time

from common import ROOT, run_logged
from fourstate2lean import digest, write, translate
from fourstate_simulate import load, simulate
from verify_fourstate_sequential import run_rtl, compare
from verify_fourstate_cam import modelsim, samples

ALPHABET='01xz'


def fixture(top,depth,width,aw):
    return f'''module {top}(input clk, en, en2, ren,
 input [{aw-1}:0] addr, addr2, raddr, input [{width-1}:0] data, data2, output [{width-1}:0] q);
 reg [{width-1}:0] Memory[0:{depth-1}];
 always @(posedge clk) begin
   if (en) Memory[addr] <= data;
   if (en2) Memory[addr2][1:0] <= data2[1:0];
 end
 assign q = ren ? Memory[raddr] : {width}'bx;
endmodule
'''


def reference_mapping(top,depth,width,aw):
    """Explicit reference-only observation interface, not a converted model."""
    ports=[]
    for n,w in [('clk',1),('en',1),('en2',1),('ren',1),('addr',aw),('addr2',aw),('raddr',aw),('data',width),('data2',width),('q',width)]:
        ports.append(dict(name=n,width=w,left=w-1,right=0,direction='output' if n=='q' else 'input',tag=n+'__tag',value=n+'__value',**({'role':'clock'} if n=='clk' else {})))
    states=[dict(name=f'{top}.Memory[{i}]',rtl_path=f'Memory[{i}]',width=width,
                 current_tag=f'm{i}_t',current_value=f'm{i}_v') for i in range(depth)]
    return dict(top=top,mode='sequential',clock='clk',ports=ports,states=states)


def vectors(depth,width,aw,*,performance=False):
    addresses=[''.join(x) for x in itertools.product(ALPHABET,repeat=aw)]
    rows=[]
    # All enable/address combinations, every data symbol and every read address.
    selected=addresses if not performance else [format(i,f'0{aw}b') for i in range(depth)]+['x'*aw,'z'*aw,'1'*aw]
    for i,(addr,en,en2,d) in enumerate(itertools.product(selected,ALPHABET,ALPHABET,ALPHABET)):
        rows.append(dict(addr=addr,en=en,en2=en2,ren=ALPHABET[(i//4)%4],data=d*width,
                         data2=ALPHABET[(i//16)%4]*width,addr2=addresses[(i//16)%len(addresses)],raddr=addresses[i%len(addresses)]))
    # Deliberate full-word/partial-write aliasing with last-statement priority;
    # independently sweep both enables, including X/Z, on every legal word.
    for a,en,en2 in itertools.product(range(depth),ALPHABET,ALPHABET):
        rows.append(dict(addr=format(a,f'0{aw}b'),addr2=format(a,f'0{aw}b'),raddr=format(a,f'0{aw}b'),
                         en=en,en2=en2,ren='1',data='1'*width,data2='z'*width))
    if width<=3:
        for a,data in itertools.product(range(depth),itertools.product(ALPHABET,repeat=width)):
            rows.append(dict(addr=format(a,f'0{aw}b'),addr2='0'*aw,raddr=format(a,f'0{aw}b'),en='1',en2='0',ren='1',data=''.join(data),data2='0'*width))
    # Every state bit must actually store each symbol, then be read while enabled.
    for d in ALPHABET:
        for a in range(depth):
            rows.append(dict(addr=format(a,f'0{aw}b'),en='1',en2='0',ren='1',data=d*width,data2='0'*width,
                             addr2='0'*aw,raddr=format(a,f'0{aw}b')))
    rng=random.Random(450018)
    for i in range(128):
        rows.append(dict(addr=''.join(rng.choices(ALPHABET,k=aw)),addr2=''.join(rng.choices(ALPHABET,k=aw)),
                         raddr=''.join(rng.choices(ALPHABET,k=aw)),en=rng.choice(ALPHABET),en2=rng.choice(ALPHABET),
                         ren=rng.choice(ALPHABET),data=''.join(rng.choices(ALPHABET,k=width)),data2=''.join(rng.choices(ALPHABET,k=width))))
    return samples(rows,'clk')


def oracle(mapping,trace,initial,paths,folder):
    state=dict(initial);previous='0';symbols={n:[set() for _ in v] for n,v in initial.items()};counts=dict(unknown_read=0,out_of_range_read=0,unknown_write=0,out_of_range_write=0,same_address=0,partial_write=0,overlapping_writes=0,hold=0)
    top=mapping['top'];depth=len(state);real=top.startswith('ram_');clock=mapping['clock'];checks=0
    def address(value):return int(value,2) if set(value)<=set('01') else None
    for sample,row in enumerate(trace):
        p=row['inputs'];rising=previous=='0' and p[clock]=='1'
        addr=p['W0_addr'] if real else p['addr'];ra=p['R0_addr'] if real else p['raddr'];en=p['W0_en'] if real else p['en'];ren=p['R0_en'] if real else p['ren'];data=p['W0_data'] if real else p['data']
        wa,read=address(addr),address(ra)
        counts['unknown_read']+=read is None;counts['out_of_range_read']+=read is not None and read>=depth
        if rising:
            counts['unknown_write']+=wa is None;counts['out_of_range_write']+=wa is not None and wa>=depth
            counts['same_address']+=wa is not None and wa==read and en=='1'
        else:counts['hold']+=1
        for phase in ('pre','post'):
            if phase=='post' and rising:
                if en=='1' and wa is not None and wa<depth:state[f'{top}.Memory[{wa}]']=data
                if not real and p['en2']=='1':
                    a2=address(p['addr2'])
                    if a2 is not None and a2<depth:
                        n=f'{top}.Memory[{a2}]';state[n]=state[n][:-2]+p['data2'][-2:];counts['partial_write']+=1
                        counts['overlapping_writes']+=en=='1' and wa==a2
            value=state[f'{top}.Memory[{read}]'] if read is not None and read<depth else 'x'*len(data)
            # Conditional expression against all-X: unknown control merges to X.
            value=value if ren=='1' else 'x'*len(data)
            expected=dict(outputs={'R0_data' if real else 'q':value},states=dict(state))
            for label,actual in paths.items():
                if actual[sample][phase]!=expected:raise ValueError(f'Memory oracle mismatch {top}/{label}/{sample}/{phase}: {actual[sample][phase]} != {expected}')
            for n,v in state.items():
                for i,c in enumerate(v):symbols[n][i].add(c)
            checks+=len(value)+sum(map(len,state.values()))
        previous=p[clock]
    coverage=dict(samples=len(trace),bit_positions=checks,events=counts,state_bit_symbols={n:[''.join(c for c in ALPHABET if c in v) for v in positions] for n,positions in symbols.items()},all_state_bits_01xz=all(v==set(ALPHABET) for positions in symbols.values() for v in positions))
    if not coverage['all_state_bits_01xz']:raise ValueError('Not every original memory bit observed as 0/1/X/Z')
    write(folder/'coverage.json',coverage);return coverage


def references(out):
    out.mkdir(parents=True,exist_ok=False);results=[]
    for depth,width,aw in [(2,3,2),(4,5,3)]:
        top=f'Memory{depth}x{width}';folder=out/top;folder.mkdir();source=folder/(top+'.sv');source.write_text(fixture(top,depth,width,aw),encoding='utf8')
        mapping=reference_mapping(top,depth,width,aw);trace=vectors(depth,width,aw)
        for contract in ('explicit','uninitialized'):
            case=folder/contract;case.mkdir();initial={p['name']:(''.join(ALPHABET[(i+j)%4] for j in range(width)) if contract=='explicit' else 'x'*width) for i,p in enumerate(mapping['states'])}
            write(case/'reference-only-mapping.json',mapping);write(case/'initial.json',initial);write(case/'trace.json',trace)
            a=run_rtl(source,mapping,trace,initial,case/'icarus',deposit_initial=contract!='uninitialized');b=modelsim(source,mapping,trace,initial,case/'modelsim',deposit_initial=contract!='uninitialized');compare(a,b,b)
            cov=oracle(mapping,trace,initial,dict(icarus=a,modelsim=b),case)
            results.append(dict(top=top,initial_contract=contract,status='TWO_REFERENCE_CONTRACT_PASS',coverage=cov,source_sha256=digest(source)))
            print(top,contract,'TWO_REFERENCE_CONTRACT_PASS',len(trace),flush=True)
    result=dict(status='TWO_REFERENCE_CONTRACT_PASS',cases=results,contract='Unknown/out-of-range read all X; unknown/out-of-range write no-op; procedural if X/Z false; later NBA wins overlapping slices; data/addresses stable before binary clock; explicit deposit or observed default all-X after time-zero settling. Reference-only mappings are not converted models.')
    write(out/'summary.json',result);return result


def ram_trace(mapping):
    width=next(p['width'] for p in mapping['ports'] if p['name']=='W0_data');aw=next(p['width'] for p in mapping['ports'] if p['name']=='W0_addr');depth=len(mapping['states'])
    addresses=[''.join(v) for v in itertools.product(ALPHABET,repeat=aw)]
    rows=[]
    for d in ALPHABET:
        for a in range(depth):
            rows.append(dict(W0_addr=format(a,f'0{aw}b'),W0_en='1',W0_data=d*width,R0_addr=format(a,f'0{aw}b'),R0_en='1',R0_clk='0'))
    for i,(wa,ra,we,re,d) in enumerate(itertools.product(addresses,addresses,ALPHABET,ALPHABET,ALPHABET)):
        rows.append(dict(W0_addr=wa,W0_en=we,W0_data=d*width,R0_addr=ra,R0_en=re,R0_clk=ALPHABET[i%4]))
    rng=random.Random(450019)
    for i in range(128):
        rows.append(dict(W0_addr=rng.choice(addresses),W0_en=rng.choice(ALPHABET),W0_data=''.join(rng.choices(ALPHABET,k=width)),R0_addr=rng.choice(addresses),R0_en=rng.choice(ALPHABET),R0_clk=rng.choice(ALPHABET)))
    return samples(rows,mapping['clock'])


def three_way(out,source,top,*,depth=None,width=None,aw=None,performance=False):
    out.mkdir(parents=True,exist_ok=False)
    source=Path(source).resolve();start=time.monotonic()
    clock='W0_clk' if top.startswith('ram_') else 'clk'
    command=[sys.executable,'-B',str(ROOT/'scripts/fourstate2lean.py'),str(source),'--top',top,'--mode','sequential','--clock',clock,'--bounded-memories','--out',str(out/'converted')]
    if run_logged(command,out/'conversion-command',echo=False):raise RuntimeError('Memory conversion failed: '+top)
    conversion_seconds=time.monotonic()-start;manifest=out/'converted/fourstate-manifest.json';mapping,model=load(manifest)
    trace=ram_trace(mapping) if top.startswith('ram_') else vectors(depth,width,aw,performance=performance)
    results=[];start=time.monotonic()
    for kind in ('explicit','uninitialized'):
        case=out/kind;case.mkdir();initial={p['name']:(''.join(ALPHABET[(i+j)%4] for j in range(p['width'])) if kind=='explicit' else 'x'*p['width']) for i,p in enumerate(mapping['states'])}
        write(case/'trace.json',trace);write(case/'initial.json',initial)
        original=run_rtl(source,mapping,trace,initial,case/'original',deposit_initial=kind!='uninitialized')
        second=modelsim(source,mapping,trace,initial,case/'modelsim',deposit_initial=kind!='uninitialized')
        compare(original,second,second)
        encoded=run_rtl(manifest.parent/'encoded.sv',mapping,trace,initial,case/'encoded',True)
        lean=simulate(manifest,trace,case/'lean',initial)
        compare(original,encoded,lean)
        cov=oracle(mapping,trace,initial,dict(original=original,modelsim=second,encoded=encoded,lean=lean),case)
        if kind=='uninitialized' and any(v!='x'*len(v) for v in original[0]['pre']['states'].values()):raise ValueError('Natural uninitialized state was not all-X')
        # Exact rail check supplements decoded four-state comparison.
        er=json.loads((case/'encoded/encoded-result.json').read_text());lr=json.loads((case/'lean/encoded-result.json').read_text())
        for i,row in enumerate(lr):
            for j,phase in enumerate(('pre','post')):
                if row[phase]!=er[2*i+j]:raise ValueError('Encoded/Lean rail mismatch')
        result=dict(status='THREE_WAY_PASS',initial_contract=kind,samples=len(trace),coverage=cov)
        write(case/'summary.json',result);results.append(result);print(top,kind,'THREE_WAY_PASS',len(trace),flush=True)
    # Comparator must reject a hidden state corruption and a Z-to-X corruption.
    import copy
    mutation=copy.deepcopy(lean);state=next(iter(mutation[0]['pre']['states']));value=mutation[0]['pre']['states'][state]
    mutation[0]['pre']['states'][state]=('1' if value[0]!='1' else '0')+value[1:]
    try:compare(original,encoded,mutation)
    except ValueError:hidden_detected=True
    else:raise ValueError('Comparator missed hidden memory state mutation')
    mutation=copy.deepcopy(lean);found=False
    for row in mutation:
        for phase in ('pre','post'):
            for name,value in row[phase]['states'].items():
                if 'z' in value:row[phase]['states'][name]=value.replace('z','x',1);found=True;break
            if found:break
        if found:break
    if not found:raise ValueError('No stored Z witness for mutation')
    try:compare(original,encoded,mutation)
    except ValueError:xz_detected=True
    else:raise ValueError('Comparator missed X/Z memory mutation')
    ir=json.loads(model.read_text());lean_source=manifest.parent/'model'/Path(*ir['namespace'].split('.')).with_suffix('.lean')
    result=dict(status='THREE_WAY_PASS',top=top,source=str(source),source_sha256=digest(source),manifest=str(manifest),manifest_sha256=digest(manifest),
                original_state_bits=sum(p['width'] for p in mapping['states']),words=len(mapping['states']),cases=results,
                model_scale=dict(fourstate_nodes=len(json.loads((manifest.parent/'fourstate.ir.json').read_text())['nodes']),functional_nodes=len(ir['nodes']),encoded_bytes=(manifest.parent/'encoded.sv').stat().st_size,lean_source_bytes=lean_source.stat().st_size,functional_ir_bytes=model.stat().st_size),
                timing=dict(conversion_seconds=conversion_seconds,validation_seconds=time.monotonic()-start),
                fault_checks=dict(hidden_state_detected=hidden_detected,xz_corruption_detected=xz_detected),
                contract='Binary stable-before-clock trace; raw Icarus and ModelSim; explicit deposit and natural no-deposit all-X initial state; all outputs/all memory words/pre and post NBA exact; no RTL normalization')
    write(out/'summary.json',result);return result


def hierarchy(out):
    """Two independent memory instances, one aliased clock, old-state sampling."""
    out.mkdir(parents=True,exist_ok=False)
    source=ROOT/'verification/fourstate/memory/MemoryHierarchy.sv'
    manifest=translate(source,'MemoryHierarchy',out/'converted','sequential','clk',bounded_memories=True)
    mapping,_=load(manifest);values=[]
    for i,(a,e0,e1,d) in enumerate(itertools.product(ALPHABET,repeat=4)):
        values.append(dict(a=a,e0=e0,e1=e1,d0=d*3,d1=ALPHABET[(i//4)%4]*3))
    for a,d in itertools.product('01',ALPHABET):values.append(dict(a=a,e0='1',e1='1',d0=d*3,d1=d*3))
    trace=samples(values,'clk');initial={p['name']:('xz0' if '.x.' in p['name'] else 'z10') for p in mapping['states']}
    write(out/'trace.json',trace);write(out/'initial.json',initial)
    raw=run_rtl(source,mapping,trace,initial,out/'original');second=modelsim(source,mapping,trace,initial,out/'modelsim');encoded=run_rtl(manifest.parent/'encoded.sv',mapping,trace,initial,out/'encoded',True);lean=simulate(manifest,trace,out/'lean',initial)
    compare(raw,second,second);compare(raw,encoded,lean)
    state=dict(initial);previous='0';seen={n:set() for n in state}
    for i,row in enumerate(trace):
        p=row['inputs']
        for phase in ('pre','post'):
            if phase=='post' and previous=='0' and p['clk']=='1' and p['a'] in '01':
                for child,en,data in [('x','e0','d0'),('y','e1','d1')]:
                    if p[en]=='1':state[f'MemoryHierarchy.{child}.m[{p["a"]}]']=p[data]
            outputs={q:state[f'MemoryHierarchy.{child}.m[{p["a"]}]'] if p['a'] in '01' else 'xxx' for q,child in [('q0','x'),('q1','y')]}
            if raw[i][phase]!=dict(outputs=outputs,states=state):raise ValueError('Hierarchy memory oracle mismatch')
            for n,v in state.items():seen[n].update(v)
        previous=p['clk']
    if not all(v==set(ALPHABET) for v in seen.values()):raise ValueError('Hierarchy memory state coverage incomplete')
    result=dict(status='THREE_WAY_PASS',samples=len(trace),original_state_bits=12,state_paths=sorted(state),source_sha256=digest(source),manifest_sha256=digest(manifest),scope='Two independent 2x3 memories on one top-level binary clock; raw Icarus/ModelSim, encoded RTL and Lean; all output and memory state samples')
    write(out/'summary.json',result);return result


def nba_reads(out):
    """NBA RHS uses old memory, even after a preceding scheduled write."""
    out.mkdir(parents=True,exist_ok=False);source=ROOT/'verification/fourstate/memory/MemoryNBA.sv'
    manifest=translate(source,'MemoryNBA',out/'converted','sequential','clk',bounded_memories=True);mapping,_=load(manifest)
    values=[];addresses=[''.join(x) for x in itertools.product(ALPHABET,repeat=2)]
    for i,(data,en,en2) in enumerate(itertools.product(itertools.product(ALPHABET,repeat=3),ALPHABET,ALPHABET)):
        values.append(dict(d=''.join(data),en=en,en2=en2,a=addresses[i%16]))
    trace=samples(values,'clk');cases=[]
    for kind in ('explicit','uninitialized'):
        case=out/kind;case.mkdir();initial={p['name']:('xz1' if p['memory_index']==0 else 'z10') if kind=='explicit' else 'xxx' for p in mapping['states']}
        write(case/'trace.json',trace);write(case/'initial.json',initial)
        raw=run_rtl(source,mapping,trace,initial,case/'original',deposit_initial=kind!='uninitialized');second=modelsim(source,mapping,trace,initial,case/'modelsim',deposit_initial=kind!='uninitialized');encoded=run_rtl(manifest.parent/'encoded.sv',mapping,trace,initial,case/'encoded',True);lean=simulate(manifest,trace,case/'lean',initial)
        compare(raw,second,second);compare(raw,encoded,lean);state=dict(initial);previous='0';negative_reads=0;overlaps=0
        for i,row in enumerate(trace):
            p=row['inputs'];address=int(p['a'],2) if set(p['a'])<=set('01') else None
            if address is not None and address>=2:negative_reads+=1
            for phase in ('pre','post'):
                if phase=='post' and previous=='0' and p['clk']=='1':
                    old=dict(state)
                    if p['en']=='1':state['MemoryNBA.m[0]']=p['d'];state['MemoryNBA.m[1]']=old['MemoryNBA.m[0]']
                    if p['en2']=='1':state['MemoryNBA.m[0]']=old['MemoryNBA.m[1]']
                    overlaps+=p['en']=='1' and p['en2']=='1'
                expected=dict(outputs=dict(q0=state['MemoryNBA.m[0]'],q1=state['MemoryNBA.m[1]'],qa=state[f'MemoryNBA.m[{address}]'] if address in (0,1) else 'xxx'),states=state)
                if raw[i][phase]!=expected:raise ValueError('NBA old-memory/signed-address oracle mismatch')
            previous=p['clk']
        result=dict(status='THREE_WAY_PASS',initial_contract=kind,samples=len(trace),negative_read_samples=negative_reads,overlapping_nba_steps=overlaps)
        write(case/'summary.json',result);cases.append(result)
    result=dict(status='THREE_WAY_PASS',top='MemoryNBA',cases=cases,original_state_bits=6,source_sha256=digest(source),manifest_sha256=digest(manifest));write(out/'summary.json',result);return result


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('action',choices=['references','verify','hierarchy','nba']);p.add_argument('--out',type=Path,required=True)
    p.add_argument('--source',type=Path);p.add_argument('--top');p.add_argument('--depth',type=int);p.add_argument('--width',type=int);p.add_argument('--address-width',type=int)
    p.add_argument('--performance',action='store_true',help='Explicit smaller scaling corpus; does not replace full 2/4-word fixture corpora')
    a=p.parse_args()
    if a.action=='references':references(a.out)
    elif a.action=='hierarchy':hierarchy(a.out)
    elif a.action=='nba':nba_reads(a.out)
    else:three_way(a.out,a.source,a.top,depth=a.depth,width=a.width,aw=a.address_width,performance=a.performance)


if __name__=='__main__':main()
