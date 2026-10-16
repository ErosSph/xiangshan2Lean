"""Compare the new pure Lean execution backend with saved independent results."""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path

from common import run_logged
from compact_request import write_compact
from server import stamp
from server_bundle import read, write, verify_bundle
from yosys_hierarchy import digest
from lean_table import emit_table


def selector_fixtures():
    bits1, bits8, boolean = {'kind':'bits','width':1}, {'kind':'bits','width':8}, {'kind':'bool'}
    def ir(name, fields, specs, output):
        return {'namespace':'Guarded.'+name, 'clock':None, 'states':[], 'effects':[],
                'inputs':[{'name':key,'field':'i'+str(i),'sort':sort} for i,(key,sort) in enumerate(fields)],
                'outputs':[{'name':'q','field':'o0','node':output,'sort':specs[output]['sort']}],
                'nodes':[{'id':'n'+str(i),'args':[],**node} for i,node in enumerate(specs)]}
    def node(op, sort, args=(), **extra):
        return {'op':op,'sort':sort,'args':list(args),**extra}
    alias = ir('SelectorAlias', [('s',bits1)], [
        node('input',bits1,field='i0'),node('constant',bits1,value=1),node('=',boolean,[0,1]),
        node('constant',boolean,value=0),node('ite',boolean,[2,2,3]),
        node('constant',bits1,value=0),node('ite',bits1,[4,1,5])],6)
    later = ir('LaterArms',[('s',bits1),('a',bits8),('b',bits8)],[
        node('input',bits1,field='i0'),node('constant',bits1,value=1),node('=',boolean,[0,1]),
        node('input',bits8,field='i1'),node('input',bits8,field='i2'),node('ite',bits8,[2,3,4])],5)
    unequal = ir('UnequalDomains',[('s',bits1),('b',bits8)],[
        node('input',bits1,field='i0'),node('constant',bits1,value=1),node('=',boolean,[0,1]),
        node('constant',bits8,value=0),node('input',bits8,field='i1'),node('bvudiv',bits8,[3,4]),
        node('bvand',bits8,[5,3]),node('ite',bits8,[2,3,6])],7)
    condition = ir('ConditionDomain',[('b',bits8)],[
        node('constant',bits8,value=0),node('input',bits8,field='i0'),node('bvudiv',bits8,[0,1]),
        node('constant',bits8,value=1),node('=',boolean,[2,3]),node('ite',bits8,[4,0,0])],5)
    return [('selector-also-data',alias,[{'s':x} for x in [1,0,1,0]],[1,0,1,0],None),
            ('arms-change-after-selector',later,[{'s':1,'a':0,'b':0},{'s':0,'a':7,'b':3},{'s':1,'a':9,'b':9}],[0,3,9],None),
            ('equal-values-unequal-domains',unequal,[{'s':1,'b':0},{'s':0,'b':0}],[0],'Undefined operation'),
            ('selector-domain-only-change',condition,[{'b':1},{'b':0}],[0],'Undefined operation')]


def validate(root, work, runner, fixtures=None):
    verify_bundle(root)
    engine = read(runner/'manifest.json')
    exe = Path(engine['executable'])
    if digest(exe) != engine['executable_sha256']:
        raise ValueError('Runner executable changed')
    target = work/'incremental-regression'/stamp()
    target.mkdir(parents=True)
    cases = []
    def case(name,binary,request,expected,failure=None):
        log=target/name
        code=run_logged([str(exe),str(binary),str(request)],log,cwd=runner,env=os.environ.copy(),echo=False)
        if failure:
            if code==0 or failure not in (log/'stderr.log').read_text():
                raise AssertionError('Invalid request was not rejected: '+name)
            if expected:
                prefix=[json.loads(s) for s in (log/'stdout.log').read_text().splitlines() if s.strip()]
                if prefix!=expected:raise AssertionError('Wrong valid prefix before rejection: '+name)
            cases.append({'name':name,'status':'PASS','rejected':failure});return
        if code:raise RuntimeError('Incremental execution failed: '+str(log))
        actual=[json.loads(s) for s in (log/'stdout.log').read_text().splitlines() if s.strip()]
        if actual != expected:raise AssertionError('Reference mismatch: '+name)
        cases.append({'name':name,'status':'PASS','samples':len(actual),'result_sha256':digest(log/'stdout.log'),
                      'circuit_sha256':digest(binary)})
        print('PASS',name,len(actual),flush=True)
    fixture=read(root/'fixture/request.json')
    binary=next((root/'fixture/model').rglob('*.circuit.bin'))
    full=target/'fixture-full.jsonl'
    with full.open('w') as stream:
        stream.write(json.dumps({'initial':fixture['initial'],'audit_every':1})+'\n')
        for row in fixture['trace']:stream.write(json.dumps(row)+'\n')
    expected=read(root/'fixture/expected.json')
    case('fixture-full-audit',binary,full,expected)
    names=list(fixture['trace'][0]['inputs'])
    compact=target/'fixture-compact.jsonl'
    write_compact(full,compact,names,(row['inputs'] for row in fixture['trace']),1)
    case('fixture-compact-audit',binary,compact,expected)
    invalid=read(root/'fixture/invalid-request.json');invalid_path=target/'invalid.jsonl'
    with invalid_path.open('w') as stream:
        stream.write(json.dumps({'initial':invalid['initial'],'audit_every':1})+'\n')
        for row in invalid['trace']:stream.write(json.dumps(row)+'\n')
    case('invalid-property',binary,invalid_path,[],failure='Assertion or assumption failed')
    if fixtures:
        for folder in sorted(fixtures.iterdir(),key=lambda p:int(p.name)):
            fixture=read(folder/'request.json');request=target/(folder.name+'.jsonl')
            with request.open('w') as stream:
                stream.write(json.dumps({'initial':fixture['initial'],'audit_every':1})+'\n')
                for row in fixture['trace']:stream.write(json.dumps(row)+'\n')
            expected=[json.loads(line) for line in (folder/'execution/stdout.log').read_text().splitlines() if line.strip()]
            case('case-'+folder.name,next((folder/'model').rglob('*.circuit.bin')),request,expected)
    for name,ir,trace,values,failure in selector_fixtures():
        model=target/name/'model';lean,_=emit_table(ir,model)
        request=target/(name+'.jsonl')
        with request.open('w') as stream:
            stream.write(json.dumps({'initial':{},'audit_every':1})+'\n')
            for inputs in trace:stream.write(json.dumps({'inputs':inputs})+'\n')
        expected=[{'cycle':i,'pre':{'q':v},'post':{'q':v}} for i,v in enumerate(values)]
        case(name,lean.with_suffix('.circuit.bin'),request,expected,failure)
    metadata=read(root/'scenario/ports.json')
    names=[p['name'] for p in metadata['ports'] if p['direction']=='input']
    whole=target/'whole-compact.jsonl'
    write_compact(root/'scenario/request.jsonl',whole,names,
                  (row['inputs'] for row in read(root/'scenario/trace.json')),8)
    expected=read(Path(read(work/'lean.json')['result']))
    case('whole-96-with-full-state-audits',work/'model/XiangShan/Whole.circuit.bin',whole,expected)
    report={'status':'PASS','cases':cases,'runner_manifest_sha256':digest(runner/'manifest.json'),
            'scope':'All outputs/effects match saved references. Full-evaluator audits compare every next-state field, every output, aggregate definedness, properties and shift diagnostics at every small-model evaluation and every eighth whole-model evaluation.'}
    write(target/'summary.json',report)
    print('REGRESSION_DIRECTORY='+str(target),flush=True)
    return report


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    for name in ['bundle','work','runner']:parser.add_argument('--'+name,type=Path,required=True)
    parser.add_argument('--fixtures',type=Path)
    args=parser.parse_args()
    validate(args.bundle.resolve(),args.work.resolve(),args.runner.resolve(),args.fixtures)
