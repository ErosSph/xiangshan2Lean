"""Stdlib-only strict comparison for freshly regenerated frozen F4 models."""
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

import json
import re


def bits(tag, value, width):
    if any(type(v) is not int or not 0 <= v < 1 << width for v in (tag, value)):
        raise ValueError('Unknown or out-of-range encoded rail')
    return ''.join('01xz'[(((tag >> i) & 1) << 1) | ((value >> i) & 1)] for i in reversed(range(width)))


def compare_fresh(mapping, request, original, encoded, lean):
    outputs = [p for p in mapping['ports'] if p['direction'] == 'output']
    states = mapping.get('states', [])
    sequential = mapping.get('mode') == 'sequential'
    async_ = 'events' in mapping
    if async_ and mapping['events']['format'] != 'fourstate-async-posedge-v1':
        raise ValueError('Use bounded-event comparator for bounded events')
    fields = outputs + states
    n = len(request['trace'])

    def rtl(text, binary):
        rows = []
        for line in text.splitlines():
            line = line.lstrip('# ')
            if line.startswith('F41 '):line = line[4:]
            if re.match(r'^\d+ ',line):rows.append(line.split())
        phases = ('pre','post') if sequential else ('comb',)
        if len(rows) != n*len(phases):raise ValueError('Incomplete/extra RTL rows')
        result = []
        for i in range(n):
            record = {}
            for j,phase in enumerate(phases):
                row = rows[i*len(phases)+j]
                prefix = [str(i)] + ([phase] if sequential else [])
                if row[:len(prefix)] != prefix:raise ValueError('RTL sample/phase order mismatch')
                data = row[len(prefix):]
                if async_:
                    record[phase+'_events'] = list(map(int,data[:3]));data=data[3:]
                if len(data) != len(fields)*(2 if binary else 1):raise ValueError('RTL output/state coverage mismatch')
                values=[]
                for k,p in enumerate(fields):
                    words = data[2*k:2*k+2] if binary else data[k:k+1]
                    if any(len(w) != p['width'] or set(w)-set('01' if binary else '01xz') for w in words):
                        raise ValueError('Malformed or unknown encoded RTL observation')
                    values.append(bits(int(words[0],2),int(words[1],2),p['width']) if binary else words[0])
                record[phase] = values
            result.append(record)
        return result

    a,b = rtl(original,False),rtl(encoded,True)
    raw = [json.loads(l) for l in lean.splitlines() if l.strip()]
    if len(raw) != n:raise ValueError('Incomplete/extra Lean rows')
    previous=0;previous_reset=0;counts=[0,0,0]
    def decoded(values, ports, state=False):
        keys=('current_tag','current_value') if state else ('tag','value')
        if set(values) != {p[k] for p in ports for k in keys}:raise ValueError('Lean output/state coverage mismatch')
        return [bits(values[p[keys[0]]],values[p[keys[1]]],p['width']) for p in ports]
    for i,r in enumerate(raw):
        expected={}
        if sequential:
            row=request['trace'][i];clock=row['clock']
            cr=(previous==0 and clock==1) if not async_ else ((previous,clock) in ((0,1),(0,2),(0,3),(2,1),(3,1)))
            if async_:
                reset=row['reset'];rr=(previous_reset,reset) in ((0,1),(0,2),(0,3),(2,1),(3,1))
                metadata=dict(sample=i,clock=clock,reset=reset,clock_rising=cr,reset_rising=rr,fired=cr or rr)
                counts=[x+int(y) for x,y in zip(counts,(cr,rr,cr or rr))]
                expected.update(pre_events=counts,post_events=counts)
                previous_reset=reset
            else:metadata=dict(sample=i,clock=clock,rising=cr)
            previous=clock
            if {k:v for k,v in r.items() if k not in ('pre','post')} != metadata:raise ValueError('Lean event metadata mismatch')
            for phase in ('pre','post'):
                if set(r[phase]) != {'outputs','states'}:raise ValueError('Unexpected Lean phase fields')
                expected[phase]=decoded(r[phase]['outputs'],outputs)+decoded(r[phase]['states'],states,True)
        else:
            if set(r) != {'cycle','pre','post'} or r['cycle'] != i:raise ValueError('Lean cycle metadata mismatch')
            pre,post=decoded(r['pre'],outputs),decoded(r['post'],outputs)
            if pre!=post:raise ValueError('Combinational pre/post mismatch')
            expected['comb']=pre
        if a[i] != b[i] or a[i] != expected:
            raise ValueError('Fresh three-way mismatch sample '+str(i)+': '+repr((a[i],b[i],expected)))
    return dict(status='FRESH_THREE_WAY_PASS',samples=n,
                output_state_bit_comparisons=n*(2 if sequential else 1)*sum(p['width'] for p in fields),
                event_counts=counts if async_ else None)
