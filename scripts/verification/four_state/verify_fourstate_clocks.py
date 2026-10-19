"""F4.6 bounded event benches, traces and exact three-way comparison.

Windows creates authoritative parse/encoding/FunctionalIR assets. Linux runs
unmodified reference RTL, encoded transition RTL and the generated Lean model.
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
import random
from fourstate_bounded_events import ALPHABET, validate_trace, decode_results, rail_decode


def corpus(mapping, seed=460018):
    inputs = [p for p in mapping['ports'] if p['direction']=='input']
    current = {p['name']:'0'*p['width'] for p in inputs}
    # History seed has opaque latches. Explicit deposits occur after settling.
    for root in mapping['events']['roots']:current[root]='1'
    trace=[dict(inputs=dict(current))]
    def setone(name,value):
        current[name]=value;trace.append(dict(inputs=dict(current)))
    names=list(current)
    # Every single-input four-state transition with every setting of the other
    # scalar inputs; Gray-like walk from prior setting, never simultaneous data.
    for name in names:
        others=[n for n in names if n!=name]
        for values in itertools.product(ALPHABET,repeat=len(others)):
            for n,v in zip(others,values):setone(n,v)
            for a,b in itertools.product(ALPHABET,repeat=2):
                setone(name,a);setone(name,b)
    rng=random.Random(seed)
    for _ in range(128):setone(rng.choice(names),rng.choice(ALPHABET))
    return trace


def benches(mapping,trace,initial,compact=False):
    encoded,init=validate_trace(mapping,trace,initial)
    procs=mapping['events']['processes'];edges=[p for p in procs if p['kind']=='edge']
    states=mapping['states'];monitors=mapping['monitors']
    def make(binary):
        lines=['module tb;'];connections=[];ins={};outs=[];regs=[];mons=[];nexts={};curr={};assert_flags=[]
        for i,p in enumerate(mapping['ports']):
            for k in (('tag','value') if binary else ('name',)):
                name=f'p{i}_{k}';lines.append(f'{"reg" if p["direction"]=="input" else "wire"} [{p["width"]-1}:0] {name};')
                connections.append(f'.{p[k]}({name})')
                (ins if p['direction']=='input' else {}).update({p[k]:(name,p['width'])})
                if p['direction']=='output':outs.append((p[k],name,p['width']))
        for i,s in enumerate(states):
            if binary:
                for k in ('current_tag','current_value','next_tag','next_value'):
                    n=f's{i}_{k}';lines.append(f'{"reg" if k.startswith("current") else "wire"} [{s["width"]-1}:0] {n};')
                    connections.append(f'.{s[k]}({n})')
                    if k.startswith('current'):
                        curr[s[k]]=n;regs.append((s[k],n,s['width']))
                    else:nexts[s[k]]=n
            else:regs.append((s['name'],'dut.'+s['rtl_path'],s['width']))
        for i,m in enumerate(monitors):
            if binary:
                for k in ('tag','value'):
                    n=f'm{i}_{k}';lines.append(f'wire {n};');connections.append(f'.{m[k]}({n})');mons.append((m[k],n,1))
            else:mons.append((m['name'],'dut.'+m['name'].split('.',1)[1],1))
        if binary and mapping.get('assertions'):
            from fourstate_assertions import FIELDS
            for i,a in enumerate(mapping['assertions']):
                for k in FIELDS:
                    n=f'a{i}_{k}';lines.append(f'wire {n};');connections.append(f'.{a[k]}({n})');assert_flags.append((a[k],n,1))
        lines.append(f'{mapping["encoded_top"] if binary else mapping["top"]} dut('+','.join(connections)+');')
        for p in edges:
            lines.append(f'integer count{p["id"]}=0;')
            if not binary:
                terms=['%s dut.%s'%('posedge' if t['edge']=='PosEdge' else 'negedge',t.get('original_signal',t['signal']).split('.',1)[1]) for t in p['triggers']]
                lines.append('always @('+ ' or '.join(terms)+f') count{p["id"]}=count{p["id"]}+1;')
        if binary:
            lines+=['integer delta;','reg changed;']
            for i,m in enumerate(monitors):lines.append(f'integer old{i}; integer early{i};')
            for p in edges:lines.append(f'reg fire{p["id"]};')
            lines+=['function rise4; input integer a,b; begin rise4=(a==0 && b!=0)||((a==2||a==3)&&b==1); end endfunction',
                    'function fall4; input integer a,b; begin fall4=rise4(b,a); end endfunction']
        initial_at=len(lines)
        compact_body=None
        lines+=['initial begin']
        def assign_inputs(values):
            for n,(local,w) in ins.items():
                bits=format(values[n],f'0{w}b') if binary else values[n]
                lines.append(f'{local}={w}\'b{bits};')
        assign_inputs(encoded[0]['inputs'] if binary else trace[0]['inputs'])
        if binary:
            for s in states:
                for k in ('current_tag','current_value'):lines.append(f'{curr[s[k]]}={s["width"]}\'d{init[s[k]]};')
        lines.append('#2;')
        if not binary:
            for kind in ('latch','edge'):
                for s in states:
                    if procs[s['process']]['kind']==kind:
                        lines.append(f'$fourstate_deposit(dut.{s["rtl_path"]},{s["width"]}\'b{initial[s["name"]]});')
                lines.append('#1;')
        for p in edges:lines.append(f'count{p["id"]}=0;')
        def monvalue(i):return f'(m{i}_tag*2+m{i}_value)'
        if binary:
            for i in range(len(monitors)):lines.append(f'old{i}={monvalue(i)};')
        observe=outs+regs+mons+assert_flags
        descriptors=[dict(name=n,width=w,section='outputs' if i<len(outs) else 'states' if i<len(outs)+len(regs) else 'monitors' if i<len(outs)+len(regs)+len(mons) else 'assert_flags') for i,(n,_,w) in enumerate(observe)]
        def display(i,phase):
            terms=[f'count{p["id"]}' for p in edges]+[n for _,n,_ in observe]
            fmt=' '.join(['%0d']*len(edges)+['%b']*len(observe))
            return '$display("'+f'{i} {phase} '+fmt+'",'+','.join(terms)+');'
        for sample,row in enumerate(trace):
            if mapping.get('assertions'):lines.append(f'$display("F47_STEP {sample}");')
            assign_inputs(encoded[sample]['inputs'] if binary else row['inputs'])
            body_at=len(lines)
            lines+=['#0;']*4
            if binary:
                for i in range(len(monitors)):lines.append(f'early{i}={monvalue(i)};')
                for p in edges:
                    checks=[]
                    for t in p['triggers']:
                        i=mapping['events']['monitors'].index(t['signal']);func='rise4' if t['edge']=='PosEdge' else 'fall4'
                        checks.append(f'{func}(old{i},early{i})')
                    lines.append(f'fire{p["id"]}='+('1\'b0' if sample==0 else '('+'||'.join(checks)+')')+';')
                latches=[s for s in states if procs[s['process']]['kind']=='latch']
                lines+=['changed=1;', 'for(delta=0;delta<8;delta=delta+1) begin','#0;']
                differences=[f'{curr[s[k]]}!={nexts[s[k.replace("current_","next_")]]}' for s in latches for k in ('current_tag','current_value')]
                lines.append('changed='+('||'.join(differences) or '0')+';')
                if sample==0:lines.append('if(changed) $fatal(1,"inconsistent initial latch");')
                if latches:
                    lines.append('{'+','.join(curr[s[k]] for s in latches for k in ('current_tag','current_value'))+'}={'+','.join(nexts[s[k]] for s in latches for k in ('next_tag','next_value'))+'};')
                lines+=['#0;','end','if(changed) $fatal(1,"delta budget");']
                for p in edges:
                    checks=[]
                    for t in p['triggers']:
                        i=mapping['events']['monitors'].index(t['signal']);func='rise4' if t['edge']=='PosEdge' else 'fall4'
                        checks.append(f'{func}(early{i},{monvalue(i)})')
                    if sample!=0:
                        lines.append('if('+'||'.join(checks)+f') begin if(fire{p["id"]}) $fatal(1,"repeated activation"); fire{p["id"]}=1; end')
                    lines.append(f'if(fire{p["id"]}) count{p["id"]}=count{p["id"]}+1;')
            lines.append(display(sample,'pre'))
            if binary:
                # Nonblocking assignment in harness: every process candidate
                # is sampled before any register commits.
                for p in edges:
                    for s in states:
                        if s['process']==p['id']:
                            for k in ('current_tag','current_value'):
                                lines.append(f'if(fire{p["id"]}) {curr[s[k]]} <= {nexts[s[k.replace("current_","next_")]]};')
            lines+=['#1;',display(sample,'post')]
            if binary:
                for i in range(len(monitors)):lines.append(f'old{i}={monvalue(i)};')
            if binary and compact and sample>0:
                body=lines[body_at:]
                # Only the displayed sample number varies; all inputs remain
                # explicit ordered assignments before each task call.
                body=[line.replace(f'$display("{sample} ', '$display("%0d ').replace('",','",sample_index,')
                      if line.startswith('$display(') else line for line in body]
                if compact_body is None:compact_body=body
                if body!=compact_body:raise ValueError('nonuniform compact event sample')
                del lines[body_at:]
                lines.append(f'event_sample({sample});')
        lines+=['$finish;','end','endmodule']
        if compact_body is not None:
            lines[initial_at:initial_at]=['task event_sample; input integer sample_index; begin',*compact_body,'end endtask']
        return '\n'.join(lines)+'\n',descriptors
    a,ad=make(False);b,bd=make(True)
    return dict(original=a,encoded=b,original_descriptors=ad,encoded_descriptors=bd)


def parse_rtl(mapping,stdout,descriptors,trace_count,binary=False):
    edges=[p for p in mapping['events']['processes'] if p['kind']=='edge']
    lines=[l for l in stdout.splitlines() if '$finish called' not in l]
    diagnostics=None
    if mapping.get('assertions'):
        import re
        if not binary:
            from fourstate_assertions import reference_events
            diagnostics=reference_events(mapping,stdout,trace_count)
        lines=[l.lstrip('# ') for l in lines if re.match(r'^\d+ (?:pre|post) ',l.lstrip('# '))]
    if len(lines)!=trace_count*2:raise ValueError('Incomplete RTL observations')
    results=[];previous={p['id']:0 for p in edges}
    for i in range(trace_count):
        r=dict(sample=i)
        for j,phase in enumerate(('pre','post')):
            parts=lines[2*i+j].split()
            if parts[:2]!=[str(i),phase] or len(parts)!=2+len(edges)+len(descriptors):raise ValueError('Malformed RTL observation')
            counts=dict(zip((p['id'] for p in edges),map(int,parts[2:2+len(edges)])))
            fired=[p['id'] for p in edges if counts[p['id']]-previous[p['id']]==1]
            if any(counts[k]-previous[k] not in (0,1) for k in previous):raise ValueError('Repeated native process event')
            if j==0:r['fired']=fired
            elif r['fired']!=fired:raise ValueError('Unexpected post-NBA event activation')
            row=dict(outputs={},states={},monitors={})
            if mapping.get('assertions') and binary:row['assert_flags']={}
            for d,bits in zip(descriptors,parts[2+len(edges):]):
                if len(bits)!=d['width'] or set(bits)-set('01' if binary else ALPHABET):raise ValueError('Invalid observed four-state/binary value')
                row[d['section']][d['name']]=int(bits,2) if binary else bits
            if binary:
                flags=row.get('assert_flags')
                row=dict(outputs=rail_decode([p for p in mapping['ports'] if p['direction']=='output'],row['outputs']),states=rail_decode(mapping['states'],row['states'],True),
                         monitors={m['name']:ALPHABET[row['monitors'][m['tag']]*2+row['monitors'][m['value']]] for m in mapping['monitors']})
                if flags is not None:
                    from fourstate_assertions import FIELDS,flags_events
                    observed=[[flags[a[k]] for k in FIELDS] for a in mapping['assertions']]
                    found=flags_events(mapping,i,r['fired'] if j==0 else [],observed)
                    if j==0:r['assertions']=found
            r[phase]=row
        if diagnostics is not None:r['assertions']=diagnostics[i]
        previous=counts;results.append(r)
    return results


def compare(mapping,original,encoded,lean):
    if not original or len(original)!=len(encoded) or len(original)!=len(lean):raise ValueError('Three-way trace length mismatch')
    comparisons=0;states={s['name']:[set() for _ in range(s['width'])] for s in mapping['states']}
    events={str(p['id']):0 for p in mapping['events']['processes'] if p['kind']=='edge'}
    for i,(a,b,c) in enumerate(zip(original,encoded,lean)):
        # Native process observer counts determine activations; independent NBA
        # process execution order is deliberately not claimed observable.
        for x in (a,b,c):x['fired']=sorted(x['fired'])
        if a!=b or a!=c:raise ValueError(f'Event three-way mismatch at {i}: original={a}, encoded={b}, Lean={c}')
        for p in a['fired']:events[str(p)]+=1
        for phase in ('pre','post'):
            for section,values in a[phase].items():
                comparisons+=sum(map(len,values.values()))
                if section=='states':
                    for n,v in values.items():
                        for k,ch in enumerate(v):states[n][k].add(ch)
    result=dict(status='THREE_WAY_PASS',samples=len(original),bit_positions=comparisons,
                state_symbols={n:[''.join(sorted(s)) for s in bits] for n,bits in states.items()},native_process_events=events)
    if mapping.get('assertions'):result['assertion_failures']=sum(len(r['assertions']) for r in original)
    return result


def reset_fault_bench(mapping, text, mutation):
    """Six fixed F5.1 execution faults; no effect on normal benches or models."""
    if mutation=='xz_edges':
        old='rise4=(a==0 && b!=0)||((a==2||a==3)&&b==1);'
        assert text.count(old)==1
        return text.replace(old,'rise4=(a==0 && b==1);')
    if mutation not in ('omit_reset','duplicate_reset','synchronous_reset','wrong_source'):
        raise ValueError('Unsupported reset execution fault')
    reset=next(t for p in mapping['events']['processes'] for t in p['triggers'] if t['source']['form']=='reset')
    ri=mapping['events']['monitors'].index(reset['signal'])
    ci=mapping['events']['monitors'].index(mapping['top']+'.'+mapping['events']['roots'][0])
    terms=[f'rise4(old{ri},early{ri})',f'rise4(early{ri},(m{ri}_tag*2+m{ri}_value))']
    if mutation=='duplicate_reset':
        # Count a second activation only on a real asynchronous reset event.
        lines=text.splitlines();out=[]
        for line in lines:
            out.append(line)
            for p in mapping['events']['processes']:
                target=f'if(fire{p["id"]}) count{p["id"]}=count{p["id"]}+1;'
                if line==target:
                    out.append(f'if({terms[0]}) count{p["id"]}=count{p["id"]}+1;')
        return '\n'.join(out)+'\n'
    for term in terms:
        assert term in text
        replacement="1'b0" if mutation=='omit_reset' else (
            f'({term} && (m{ci}_tag*2+m{ci}_value)==1)' if mutation=='synchronous_reset'
            else term.replace(f'old{ri}',f'old{ci}').replace(f'early{ri}',f'early{ci}').replace(f'm{ri}_',f'm{ci}_'))
        text=text.replace(term,replacement)
    return text


def prepare_case(source,top,clock,roots,folder):
    from fourstate2lean import translate,write,digest
    from fourstate_simulate import load
    from fourstate_elaborated import source_files
    from fourstate_bounded_events import runner_source
    manifest=translate(source,top,folder/'translation','sequential',clock,bounded_events=True,event_clocks=roots)
    mapping,ir_path=load(manifest);ir=json.loads(ir_path.read_text())
    trace=corpus(mapping)
    initials=[{s['name']:symbol*s['width'] for s in mapping['states']} for symbol in ALPHABET]
    assets=folder/'assets';assets.mkdir()
    files={'ports.json':json.dumps(mapping).encode(),'trace.json':json.dumps(trace).encode(),
           'initials.json':json.dumps(initials).encode(),'encoded.sv':(manifest.parent/'encoded.sv').read_bytes(),
           'RunEvents.lean':runner_source(ir,mapping).encode(),
           'model/FourState/Model.lean':(manifest.parent/'model/FourState/Model.lean').read_bytes(),
           'deposit4.c':(_PROJECT_ROOT/'verification/fourstate/deposit4.c').read_bytes()}
    originals=[]
    for i,src in enumerate(source_files(source)):
        name='original-'+str(i)+'.sv';originals.append(name);files[name]=src.read_bytes()
    for name,data in files.items():
        p=assets/name;p.parent.mkdir(parents=True,exist_ok=True);p.write_bytes(data)
    plan=dict(top=top,original_sources=originals,files=[dict(path=n,bytes=len(d),sha256=digest(assets/n)) for n,d in files.items()])
    write(assets/'plan.json',plan)
    write(folder/'prepared.json',dict(status='PREPARED',manifest=str(manifest),functional_nodes=len(ir['nodes']),
          state_bits=sum(s['width'] for s in mapping['states']),trace_samples=len(trace),initial_count=len(initials),
          original_sources=[dict(path=str(p),sha256=digest(p)) for p in source_files(source)]))
    return assets


def send_case(assets,run,snapshot,case,folder,operation='run-clocks'):
    import base64
    from fourstate2lean import digest,write
    from verify_fourstate_blockers import remote_call
    version='input-'+case
    files=[]
    for p in sorted(Path(assets).rglob('*')):
        if p.is_file():files.append(dict(path=p.relative_to(assets).as_posix(),sha256=digest(p),base64=base64.b64encode(p.read_bytes()).decode()))
    a=remote_call(folder,dict(operation='archive',run_id=run,snapshot_id=snapshot,version=version,files=files),entry='verify_fourstate_clocks_remote')
    write(Path(folder)/'archive.json',a)
    r=remote_call(folder,dict(operation=operation,run_id=run,snapshot_id=snapshot,input_version=version,case_id=case),entry='verify_fourstate_clocks_remote')
    write(Path(folder)/'linux-result.json',r)
    return r


def main():
    import argparse
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('source',type=Path);p.add_argument('--top',required=True);p.add_argument('--clock',required=True)
    p.add_argument('--event-clock',action='append',default=[]);p.add_argument('--out',type=Path,required=True)
    p.add_argument('--run-id',required=True);p.add_argument('--snapshot-id',required=True);p.add_argument('--case-id',required=True)
    a=p.parse_args()
    from fourstate2lean import fresh_directory
    folder=fresh_directory(a.out)
    assets=prepare_case(a.source,a.top,a.clock,a.event_clock,folder)
    r=send_case(assets,a.run_id,a.snapshot_id,a.case_id,folder)
    print(json.dumps(dict(status=r['status'],top=r['top'],samples=sum(x['samples'] for x in r['cases']),seconds=r['seconds'])))


if __name__=='__main__':main()
