"""Exercise four-state-only backend cleanup and explicit Lean compilation stack."""
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
import datetime as dt
import itertools
import json
from pathlib import Path
import random
import shutil
import sys
import traceback
import uuid

from common import ROOT, run_logged
from fourstate2lean import digest, fresh_directory, provenance, write
from fourstate_simulate import load
from verify_fourstate import run_rtl, tools_record
from verify_fourstate_operators import literal_checks, run_case, sampled


def stress_source():
    # Fixed generator: same 24 expressions as the recorded default-stack failure.
    rng = random.Random(510719)
    def expr(depth):
        if not depth:
            return rng.choice(['a', 'b', 't', "5'b00101", "5'b11001"])
        op = rng.choice(['+', '-', '^', '&', '|', 'mux'])
        left, right = expr(depth-1), expr(depth-1)
        return f'(c ? {left} : {right})' if op == 'mux' else f'({left} {op} {right})'
    expressions = [expr(3) for _ in range(24)]
    return ('module ExprStress(input [4:0] a,b,t,input c,output [4:0] ' +
            ','.join('y'+str(i) for i in range(24)) + ');\n' +
            ''.join(f'assign y{i} = {e};\n' for i, e in enumerate(expressions)) + 'endmodule\n')


def inputs(seed, count, names):
    rng = random.Random(seed)
    rows = []
    for i in range(count):
        alphabet = '01' if i < count//2 else '01xz'
        values = {name: ''.join(rng.choice(alphabet) for _ in range(width)) for name, width in names.items()}
        rows.append({'inputs': values})
    return rows


def dead_cone_trace():
    trace = inputs(171017, 512, {'a':5, 'b':5, 'c':1, 'd':1})
    trace += [{'inputs': {'a':a*5, 'b':b*5, 'c':c, 'd':d}}
              for a,b,c,d in itertools.product('01xz', repeat=4)]
    return trace


def verify_preparation(folder, case, trace):
    base = folder/case['name']
    manifest = base/'translation/fourstate-manifest.json'
    mapping, ir_path = load(manifest)
    ir = json.loads(ir_path.read_text(encoding='utf-8'))
    if ir['arbitrary_inputs']:
        raise AssertionError('Four-state model acquired arbitrary inputs')
    compiled = json.loads((manifest.parent/'lean-check/result.json').read_text())
    if compiled['status'] != 'PASS' or compiled['exit_code'] != 0 or compiled['stack_kib'] != 65536:
        raise AssertionError('Explicit-stack compilation did not succeed')
    if mapping['mode'] == 'combinational':
        # Also execute the exact normalized copy used by the Lean backend.
        normalized = run_rtl(manifest.parent/'backend/design.sv', mapping, trace, base/'normalized', True)
        original_encoded = json.loads((base/'encoded/result.json').read_text())
        if normalized != original_encoded:
            raise AssertionError('Cleanup changed an observed encoded rail')
    case.update(arbitrary_inputs=0, compilation_stack_kib=65536, functional_nodes=len(ir['nodes']))


def campaign(folder):
    report = {'status':'RUNNING', 'cases':[], 'scope':'Finite backend-integration regression; no new SystemVerilog semantics.'}
    write(folder/'summary.json', report)
    try:
        report['tools'] = tools_record(folder/'tools')
        source_root = folder/'inputs'; source_root.mkdir()
        stress = source_root/'ExprStress.sv'; stress.write_text(stress_source(), encoding='utf-8')
        traces = {'BackendDeadCone':dead_cone_trace(),
                  'ExprStress':inputs(710723, 512, {'a':5, 'b':5, 't':5, 'c':1})}
        controls = [{'reset':r, 'en':e, 'd':d, 'a':a, 'b':b} for r,e,d,a,b in [
            ('0','0','0','00000','00001'), ('0','1','z','11111','00001'),
            ('1','1','x','00011','00101'), ('x','1','x','x0001','00001'),
            ('z','0','1','zzzzz','00000'), ('0','x','0','00001','00001'),
            ('0','z','z','00000','00000'), ('0','1','1','00001','00001')]]
        traces['BackendDeadState'] = sampled(controls)
        initial = {'q':'z', 'r':'x01z0'}
        for top in ('BackendDeadCone','BackendDeadState','ExprStress'):
            source = stress if top == 'ExprStress' else ROOT/'verification/fourstate'/(top+'.sv')
            expanded = source_root/(top+'-expanded'); expanded.mkdir()
            shutil.copyfile(source, expanded/(top+'.sv'))
            for label, path in [('flat',source), ('expanded',expanded)]:
                name = top+'-'+label
                trace = traces[top]
                state = ({top+'.'+key:value for key,value in initial.items()} if label == 'expanded' else initial)
                case = run_case(folder, top, trace, state if top == 'BackendDeadState' else None,
                                source=path, label=name)
                verify_preparation(folder, case, trace)
                if top == 'BackendDeadCone':
                    expected = []
                    for i, row in enumerate(trace):
                        p = row['inputs']; known = all(c in '01' for c in p['a']+p['b'])
                        known_amount = all(c in '01' for c in p['a'])
                        expected.append({'sample':i, 'outputs':{
                            'add_const':'1', 'mux_bit':p['d'], 'low_x':'x', 'low_z':'z',
                            'shift_bit':str(int(int(p['a'],2) == 0)) if known_amount else 'x',
                            'sum':format((int(p['a'],2)+int(p['b'],2)) & 31,'05b') if known else 'xxxxx'}})
                    literal_checks(folder/name, trace, expected)
                    case['independent_checks'] = len(trace)*6
                elif top == 'BackendDeadState':
                    # q/r literals check old state, reset priority, unknown controls and NBA updates.
                    expected_states = [('z','x01z0'),('z','00000'),('0','01000'),('x','xxxxx'),
                                       ('x','xxxxx'),('x','xxxxx'),('x','xxxxx'),('1','00010')]
                    literal_checks(folder/name, trace, [
                        {'sample':4*i+3,'outputs':{'q':q,'r':r}} for i,(q,r) in enumerate(expected_states)], True)
                    case['independent_checks'] = len(expected_states)*2
                report['cases'].append(case)
                write(folder/'summary.json', report)
        report['source_snapshot_sha256'] = provenance(folder)
        report['status'] = 'BACKEND_INTEGRATION_PASS'
    except Exception:
        report.update(status='FAIL', error=traceback.format_exc())
    finally:
        report['artifact_sha256'] = {p.relative_to(folder).as_posix():digest(p) for p in folder.rglob('*')
                                     if p.is_file() and p != folder/'summary.json'}
        write(folder/'summary.json', report)
    return report


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--evidence',type=Path,default=ROOT/'experiments/fourstate/backend-integration')
    p.add_argument('--run',type=Path,help=argparse.SUPPRESS)
    args = p.parse_args()
    if args.run:
        report = campaign(args.run)
        print(args.run/'summary.json', report['status'], flush=True)
        if report['status'] != 'BACKEND_INTEGRATION_PASS':
            print(report['error'], file=sys.stderr)
            raise SystemExit(1)
        return
    run = dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ')+'-'+uuid.uuid4().hex[:8]
    folder = fresh_directory(args.evidence/run)
    code = run_logged([sys.executable,'-B',str(Path(__file__).resolve()),'--run',str(folder)],folder/'invocation')
    raise SystemExit(code)


if __name__ == '__main__':
    main()
