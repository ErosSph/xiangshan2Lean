"""Check every requested original state at both phases of the seeding step."""
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
import json
from fourstate_scalable_bench import records


def check(mapping, path, fill):
    def words():
        for state in mapping['states']:
            memory=state.get('memory')
            indices=range(memory['offset'],memory['offset']+memory['depth']) if memory else [0]
            for index in indices:yield state['object_id'],index,state['width']
    expected=[words(),words()];counts=[0,0];events=[0,0]
    for sample,phase,kind,obj,index,value in records(path,False):
        if sample:break
        if phase not in (0,1):raise ValueError('Unknown observation phase')
        if kind=='S':
            key=next(expected[phase],None)
            if key!=(obj,index,len(value)) or value!=fill*len(value):
                raise ValueError('Native seed changed: '+repr((fill,phase,key,obj,index,value[:80])))
            counts[phase]+=1
        elif kind=='E':
            if value!=0:raise ValueError('Initialization event leaked into sample zero')
            events[phase]+=1
    edge_count=sum(p['kind']=='edge' for p in mapping['events']['processes'])
    if any(next(e,None) is not None for e in expected) or events!=[edge_count,edge_count]:
        raise ValueError('Incomplete initial state/event observation matrix')
    return dict(fill=fill,state_observations=counts,event_counters=events,status='EXACT_PRE_POST_INITIAL_PASS')


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--mapping',type=Path,required=True)
    p.add_argument('--native',type=Path,required=True)
    p.add_argument('--out',type=Path,required=True)
    a=p.parse_args()
    with gzip.open(a.mapping,'rt') as source:mapping=json.load(source)
    rows=[check(mapping,a.native/('case-'+fill)/'observations.log.gz',fill) for fill in '01xz']
    result=dict(status='PASS',fills=rows,mapping_sha256=hashlib.sha256(a.mapping.read_bytes()).hexdigest(),scope='All original scalar states and every logical RAM word exactly equal requested uniform initial fill at sample 0/pre and 0/post; every event count is zero')
    with a.out.open('x') as output:json.dump(result,output,indent=2)
    print(json.dumps(result))


if __name__=='__main__':main()
