"""Independent inventory and three-way hierarchy / parameter / generate validation."""
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
import json
from pathlib import Path
import random
import re
import shutil
import sys
import traceback
import uuid

from common import ROOT
from fourstate2lean import digest, fresh_directory, provenance, translate, write
from fourstate_frontend import parse
from fourstate_encode import encode
from fourstate_simulate import load, simulate
from verify_fourstate import run_rtl as run_comb, compare as compare_comb, tools_record
from verify_fourstate_sequential import run_rtl as run_seq, compare as compare_seq
from verify_fourstate_operators import sampled

SEED = 410171
FIXTURES = ROOT / 'verification/fourstate'
EXPECTED = FIXTURES / 'hierarchy-expected.json'


def inventory(ir, mapping, elaboration, expected):
    fields = ('width', 'signed', 'left', 'right')
    for source in (ir, mapping, elaboration):
        actual = {p['name']: [p[k] for k in fields] for p in source.get('states', [])}
        if len(actual) != len(source.get('states', [])) or actual != expected['states']:
            raise ValueError('Independent expected register inventory mismatch: ' + repr(actual))
    for state in mapping.get('states', []):
        w, _, left, right = expected['states'][state['name']]
        if state.get('bit_indices') != [right + (i if left >= right else -i) for i in range(w)]:
            raise ValueError('Independent register bit order mismatch: ' + state['name'])
    instances = {p['path']: p for p in elaboration['instances']}
    for path, params in expected['instance_parameters'].items():
        actual = {p['name']: int(p['bits'], 2) - ((1 << p['width']) if p['signed'] and p['bits'][0] == '1' else 0)
                  for p in instances[path]['parameters']}
        if actual != params:
            raise ValueError('Independent expected instance parameters mismatch: ' + path)
    params = {p['path']: p for p in elaboration['parameters']}
    for path, value in expected['local_parameters'].items():
        if int(params[path]['bits'], 2) != value:
            raise ValueError('Independent localparam mismatch: ' + path)
    ports = {p['name']: p for p in mapping['ports']}
    for name, value in expected['ports'].items():
        if [ports[name][k] for k in fields] != value:
            raise ValueError('Independent declaration range mismatch: ' + name)
    names = [p[k] for p in mapping.get('states', []) for k in ('current_tag', 'current_value', 'next_tag', 'next_value')]
    if len(names) != len(set(names)):
        raise ValueError('State rail names collide')


def first_difference(expected, actual):
    if len(expected) != len(actual):
        return {'expected_samples': len(expected), 'actual_samples': len(actual)}
    for i, (a, b) in enumerate(zip(expected, actual)):
        for phase in ('pre', 'post'):
            for group in ('outputs', 'states'):
                for name in sorted(set(a[phase][group]) | set(b[phase][group])):
                    x, y = a[phase][group].get(name), b[phase][group].get(name)
                    if x != y:
                        return {'sample': i, 'phase': phase, 'kind': group, 'name': name, 'expected': x, 'actual': y}
    raise AssertionError('Semantic fault was not detected')


def run_case(folder, top, source, trace, expected, initial=None):
    case = folder / top
    case.mkdir()
    write(case / 'expected-inventory.json', expected)
    write(case / 'trace.json', trace)
    (case / 'trace.jsonl').write_text(''.join(json.dumps(r) + '\n' for r in trace), encoding='utf-8')
    mode = 'sequential' if initial is not None else 'combinational'
    if initial is not None:
        write(case / 'initial.json', initial)
    manifest = translate(source, top, case / 'translation', mode, 'clk' if initial is not None else None)
    mapping, _ = load(manifest)
    ir = json.loads((manifest.parent / 'fourstate.ir.json').read_text())
    elaboration = json.loads((manifest.parent / 'elaboration.json').read_text())
    inventory(ir, mapping, elaboration, expected)
    write(case / 'inventory-result.json', {'status': 'PASS', 'states': expected['states'],
                                          'instance_parameters': expected['instance_parameters']})
    if initial is not None:
        original = run_seq(source, mapping, trace, initial, case / 'original')
        encoded = run_seq(manifest.parent / 'encoded.sv', mapping, trace, initial, case / 'encoded', True)
        lean = simulate(manifest, trace, case / 'lean', initial)
        compare_seq(original, encoded, lean)
        output_bits = 2 * len(trace) * sum(p['width'] for p in mapping['ports'] if p['direction'] == 'output')
        state_bits = 2 * len(trace) * sum(p['width'] for p in mapping['states'])
    else:
        original = run_comb(source, mapping, trace, case / 'original')
        encoded = run_comb(manifest.parent / 'encoded.sv', mapping, trace, case / 'encoded', True)
        lean = simulate(manifest, trace, case / 'lean')
        output_bits = compare_comb(mapping, original, encoded, [r['outputs'] for r in lean])
        state_bits = 0
    return {'name': top, 'status': 'PASS', 'samples': len(trace), 'states': len(expected['states']),
            'output_bit_positions': output_bits, 'state_bit_positions': state_bits,
            'manifest': manifest.relative_to(folder).as_posix(), 'manifest_sha256': digest(manifest)}


def cases(folder):
    expected = json.loads(EXPECTED.read_text())
    rng = random.Random(SEED)
    initial = {name: ''.join('xz01'[(i+j) % 4] for j in range(spec[0]))
               for i, (name, spec) in enumerate(expected['HierarchyTop']['states'].items())}
    values = []
    for i in range(48):
        known = i < 12
        alphabet = '01' if known else '01xz'
        values.append({'reset': ('1' if i == 0 else '0') if known else '01xz'[i % 4],
                       'en': '1' if known else '01xz'[(i // 4) % 4],
                       'a': ''.join(rng.choice(alphabet) for _ in range(4)),
                       'b': ''.join(rng.choice(alphabet) for _ in range(8)),
                       'wide': ''.join(rng.choice(alphabet) for _ in range(65))})
    result = [run_case(folder, 'HierarchyTop', FIXTURES / 'hierarchy', sampled(values), expected['HierarchyTop'], initial)]
    result.append(run_case(folder, 'HierarchySwap', FIXTURES / 'HierarchySwap.sv',
                           sampled([{} for _ in range(12)]), expected['HierarchySwap'],
                           {'HierarchySwap.u0.q': 'x', 'HierarchySwap.u1.q': 'z'}))
    result.append(run_case(folder, 'PathCollision', FIXTURES / 'PathCollision.sv',
                           sampled([{'d0': a, 'd1': b} for a in '01xz' for b in '01xz']), expected['PathCollision'],
                           {'PathCollision.a.b.q': 'x', 'PathCollision.a_b.q': 'z'}))
    trace = [{'inputs': {'a': ''.join(rng.choice('01xz') for _ in range(4)),
                         'b': ''.join(rng.choice('01xz') for _ in range(8)), 'choose': '01xz'[i % 4]}}
             for i in range(32)]
    result.append(run_case(folder, 'HierarchyComb', FIXTURES / 'HierarchyComb.sv', trace, expected['HierarchyComb']))
    result.append(run_case(folder, 'GenerateAudit', FIXTURES / 'GenerateAudit.sv',
                           [{'inputs': {'a': ''.join('01xz'[(i+j) % 4] for j in range(4))}} for i in range(4)],
                           {'states': {}, 'instance_parameters': {'GenerateAudit': {'N': 3, 'ZERO': 0}},
                            'local_parameters': {}, 'ports': {'a': [4, False, 3, 0], 'y': [4, False, 3, 0]}}))
    return result


def semantic_faults(folder):
    faults = []
    for name, top in [('SharedInstanceState', 'HierarchySwap'), ('WrongSpecializationWidth', 'HierarchyTop'),
                      ('SequentialModuleCommit', 'HierarchySwap')]:
        case = folder / top
        manifest = case / 'translation/fourstate-manifest.json'
        mapping, _ = load(manifest)
        trace = json.loads((case / 'trace.json').read_text())
        initial = json.loads((case / 'initial.json').read_text())
        original = json.loads((case / 'original/result.json').read_text())
        lean = json.loads((case / 'lean/fourstate-result.json').read_text())
        raw = (manifest.parent / 'encoded.sv').read_text()
        if name == 'SequentialModuleCommit':
            source = manifest.parent / 'encoded.sv'
            altered = run_seq(source, mapping, trace, initial, case / name, True, 'update-order')
            mutation = 'Commit one instance register then settle before evaluating the other instance.'
        else:
            a, b = mapping['states'][:2]
            mutation = []
            for rail in ('tag', 'value'):
                target = b['current_' + rail] if name == 'SharedInstanceState' else a['current_' + rail]
                replacement = a['current_' + rail] if name == 'SharedInstanceState' else '{{2{' + target + '[1]}}, ' + target + '[1:0]}'
                pattern = r'= ' + re.escape(target) + r';'
                raw, count = re.subn(pattern, '= ' + replacement + ';', raw)
                if count != 1:
                    raise AssertionError('Semantic fault target missing: ' + name)
                mutation.append({'before': '= ' + target + ';', 'after': '= ' + replacement + ';'})
            source = case / (name + '.sv')
            source.write_text(raw, encoding='utf-8')
            altered = run_seq(source, mapping, trace, initial, case / name, True)
        diff = first_difference(original, altered)
        try:
            compare_seq(original, altered, lean)
        except ValueError:
            faults.append({'case': name, 'status': 'PASS', 'classification': 'executed semantic differential',
                           'mutation': mutation, 'source_sha256': digest(source), 'first_difference': diff})
        else:
            raise AssertionError('Semantic fault not detected')
    return faults


def rejection_sources():
    wrap = lambda body: 'module T #(parameter W=1)(input clk,clk2,a,b,output logic q);' + body + ' endmodule'
    cell = 'module C(input clk,d,output logic q);always_ff @(posedge clk)q<=d;endmodule\n'
    result = {
        'ActiveMemory': (wrap('if(W) begin:bad reg m[0:1];initial m[0]=0;end always_ff @(posedge clk)q<=a;'), True),
        'DeadRuntimeMultiply': (wrap("always_ff @(posedge clk) if(1'b0)q<=a*b;else q<=a;"), True),
        'UnsizedData': (wrap('always_ff @(posedge clk)q<=a+1;'), True),
        'DerivedClock': (wrap('always_ff @(posedge (clk&a))q<=a;'), True),
        'SecondClock': (wrap('always_ff @(posedge clk2)q<=a;'), True),
        'AsyncReset': (wrap('always @(posedge clk or posedge a)if(a)q<=1\'b0;else q<=b;'), True),
        'Negedge': (wrap('always @(negedge clk)q<=a;'), True),
        'ClockAsDataOutput': (wrap('assign q=clk;always_ff @(posedge clk)begin end'), True),
        'Undriven': (wrap('wire n;always_ff @(posedge clk)q<=n;'), True),
        'MultipleDrivers': (cell + wrap('C u0(clk,a,q);C u1(clk,b,q);'), True),
        'OutputSlice': (cell + 'module T(input clk,a,output [1:0]q);C u(clk,a,q[0]);assign q[1]=a;endmodule', True),
        'OutputConcat': (cell + 'module T(input clk,a,output [1:0]q);C u(clk,a,{q[0]});assign q[1]=a;endmodule', True),
        'Wildcard': (cell + 'module T(input clk,d,output q);C u(.*);endmodule', True),
        'OpenPort': (cell + 'module T(input clk,a,output q);C u(.clk(clk),.d(),.q(q));endmodule', True),
        'MissingModule': (wrap('Missing u(clk,a,q);'), True),
        'Recursive': ('module T(input clk,a,output q);T u(clk,a,q);endmodule', True),
        'Inout': ('module T #(parameter W=1)(inout a,output q);assign q=a;endmodule', False),
        'CombCycle': ('module T #(parameter W=1)(input a,output q);wire n;assign n=q;assign q=n;endmodule', False),
        'EscapedIdentifier': ('module T #(parameter W=1)(input a,output q);wire \\bad.name ;assign \\bad.name =a;assign q=\\bad.name ;endmodule', False),
        'CrossModuleReference': (cell + 'module T(input clk,a,output q);wire n;C u(clk,a,n);assign q=u.q;endmodule', True),
        'CrossModuleAssignmentTarget': ('module D(input a,output y);wire n;assign y=n;endmodule\n'
                                      'module T(input a,output y);D u(a,y);assign u.n=a;endmodule', False),
        'CrossModuleOutputTarget': ('module D(input a,output y);assign y=a;endmodule\n'
                                   'module S(input a,output y);wire n;assign y=n;endmodule\n'
                                   'module T(input a,output y);S u(a,y);D v(a,u.n);endmodule', False),
        'CrossModuleEventClock': ('module D(input clk);endmodule\n'
                                 'module T(input clk,a,output logic q);D u(clk);always @(posedge u.clk)q<=a;endmodule', True),
        'CrossModuleClockAlias': ('module D(input clk);endmodule\n'
                                 'module T(input clk,a,output logic q);wire c;D u(clk);assign c=u.clk;always @(posedge c)q<=a;endmodule', True),
        'CrossModuleClockPort': (cell + 'module T(input clk,a,output q);wire n;C u(clk,a,n);C v(u.clk,a,q);endmodule', True),
        'TypeParameter': ('module T #(parameter type D=logic)(input a,output q);assign q=a;endmodule', False),
        'UnknownGenerate': ("module T #(parameter P=1'bx)(input a,output q);if(P)assign q=~a;else assign q=a;endmodule", False),
        'UnknownRange': ("module T #(parameter P=1'bx)(input [P:0]a,output q);assign q=a[0];endmodule", False),
        'InstanceArray': (cell + 'module T(input clk,a,output [1:0]q);C u[1:0](clk,a,q);endmodule', True),
        'Defparam': ('module T #(parameter W=1)(input a,output q);defparam W=2;assign q=a;endmodule', False),
        'Bind': ('module C(input a);endmodule\nmodule T #(parameter W=1)(input a,output q);assign q=a;endmodule\nbind T C u(a);', False),
    }
    for state in ('x', 'z'):
        for part, loop in [('Initial', 'i=P;i<1;i=i+1'), ('Bound', 'i=0;i<P;i=i+1'),
                           ('Step', 'i=0;i<1;i=i+P'), ('ZeroStep', 'i=0;i<0;i=i+P'),
                           ('MaskedBound', "i=0;i<(P & 1'b0);i=i+1")]:
            result['UnknownFor' + part + state.upper()] = (
                f"module T #(parameter P=1'b{state})(input a,output q);"
                f'for(genvar {loop})begin:g wire n;assign n=a;end assign q=a;endmodule', False)
    return result


def reject_tests(folder):
    checks = []
    for name, (raw, seq) in rejection_sources().items():
        source = folder / 'rejections' / (name + '.sv')
        source.parent.mkdir(exist_ok=True)
        source.write_text(raw, encoding='utf-8')
        try:
            encode(parse(source, 'T', 'sequential' if seq else 'combinational', 'clk' if seq else None))
        except (ValueError, RuntimeError) as exc:
            if not re.search(re.escape(str(source)) + r':\d+:\d+:', str(exc)):
                raise AssertionError('Missing rejection source location: ' + name) from exc
            if name.startswith('CrossModule') and 'cross-module' not in str(exc):
                raise AssertionError('Cross-instance input rejected for an unrelated reason: ' + name) from exc
            checks.append({'case': name, 'status': 'PASS', 'diagnostic': str(exc)})
        else:
            raise AssertionError('Unsupported input accepted: ' + name)
    source = folder / 'syntax-error'
    source.mkdir()
    (source / 'Top.sv').write_text('module T(input a,output q);assign q=a;endmodule')
    (source / 'Unrelated.sv').write_text('module Unrelated( BAD SYNTAX ! endmodule')
    try:
        parse(source, 'T')
    except ValueError as exc:
        checks.append({'case': 'UnrelatedSyntaxError', 'status': 'PASS', 'diagnostic': str(exc)})
    else:
        raise AssertionError('Unrelated file syntax error ignored')
    return checks


def loader_tests(folder):
    checks = []
    original = folder / 'HierarchyTop/translation'
    for asset in ('sources.json', 'ports.json', 'elaboration.json', 'original/HierarchyLeaf.sv'):
        for action in ('missing', 'damaged'):
            case = folder / 'loader-checks' / (asset.replace('/', '-').replace('.', '-') + '-' + action)
            shutil.copytree(original, case)
            if action == 'missing':
                (case / asset).unlink()
            else:
                with (case / asset).open('ab') as stream:
                    stream.write(b'corrupted')
            try:
                load(case / 'fourstate-manifest.json')
            except (ValueError, RuntimeError) as exc:
                checks.append({'case': asset + '-' + action, 'status': 'PASS', 'diagnostic': str(exc)})
            else:
                raise AssertionError('Missing/damaged provenance accepted')
    for name in ('mode', 'mapping-version', 'missing-required', 'state-inventory'):
        case = folder / 'loader-checks' / name
        shutil.copytree(original, case)
        manifest_path = case / 'fourstate-manifest.json'
        manifest = json.loads(manifest_path.read_text())
        if name == 'mode':
            manifest['mode'] = 'invalid'
        elif name == 'missing-required':
            del manifest['sources']
        else:
            mapping_path = case / 'ports.json'
            mapping = json.loads(mapping_path.read_text())
            if name == 'mapping-version':
                mapping['format'] = 'chisel2lean-fourstate-ports-v3'
            else:
                mapping['states'].pop()
            write(mapping_path, mapping)
            manifest['artifact_sha256']['ports.json'] = digest(mapping_path)
        write(manifest_path, manifest)
        try:
            load(manifest_path)
        except ValueError as exc:
            checks.append({'case': name, 'status': 'PASS', 'diagnostic': str(exc)})
        else:
            raise AssertionError('Malformed v4 contract accepted: ' + name)
    # This independent oracle also catches an importer that omits a hidden state in all three assets.
    ir = json.loads((original / 'fourstate.ir.json').read_text())
    mapping = json.loads((original / 'ports.json').read_text())
    elaboration = json.loads((original / 'elaboration.json').read_text())
    for data in (ir, mapping, elaboration):
        data['states'] = data['states'][:-1]
    try:
        inventory(ir, mapping, elaboration, json.loads(EXPECTED.read_text())['HierarchyTop'])
    except ValueError as exc:
        checks.append({'case': 'IndependentMissingState', 'status': 'PASS', 'diagnostic': str(exc)})
    else:
        raise AssertionError('Independent register oracle failed')
    return checks


def legacy_replays(folder):
    from verify_fourstate_operators import legacy_replay
    checks = legacy_replay(folder)
    for mode, model, case_path, expected_path in [
        ('combinational', 'operator-cli-20261016-final', '20261016T152016Z-280a6c90/WidthTypes',
         'operator-cli-20261016-final/replay/fourstate-result.json'),
        ('sequential', 'operator-sequential-cli-20261016-final', '20261016T152158Z-bce78ca8/Counter4',
         'operator-cli-20261016-final/replay-sequential/fourstate-result.json')]:
        prefix = ROOT / 'experiments/fourstate/operators' / case_path
        trace = json.loads((prefix / 'trace.json').read_text())
        initial = json.loads((prefix / 'initial.json').read_text()) if mode == 'sequential' else None
        manifest = ROOT / 'generated/fourstate' / model / 'fourstate-manifest.json'
        result = simulate(manifest, trace, folder / ('replay-v3-' + mode), initial)
        expected = json.loads((ROOT / 'experiments/fourstate' / expected_path).read_text())
        if result != expected:
            raise AssertionError('Legacy v3 replay differs')
        checks.append({'version': 'v3', 'mode': mode, 'status': 'PASS', 'samples': len(trace),
                       'manifest_sha256': digest(manifest)})
    return checks


def campaign(folder):
    report = {'status': 'RUNNING', 'seed': SEED, 'command': [sys.executable, *sys.argv],
              'cases': [], 'rejections': [], 'loader_checks': [], 'semantic_faults': [], 'legacy_replays': [],
              'scope': 'Finite elaborated single-clock four-state tests; not a general equivalence proof.'}
    write(folder / 'summary.json', report)
    try:
        report['tools'] = tools_record(folder / 'tools')
        report['source_snapshot_sha256'] = provenance(folder)
        report['cases'] = cases(folder)
        report['semantic_faults'] = semantic_faults(folder)
        report['rejections'] = reject_tests(folder)
        report['loader_checks'] = loader_tests(folder)
        report['legacy_replays'] = legacy_replays(folder)
        report['status'] = 'PASS'
    except Exception:
        report['status'] = 'FAIL'
        report['error'] = traceback.format_exc()
    finally:
        report['artifact_sha256'] = {p.relative_to(folder).as_posix(): digest(p) for p in folder.rglob('*')
                                    if p.is_file() and p.name != 'summary.json'}
        write(folder / 'summary.json', report)
    return report


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--evidence', type=Path, default=ROOT / 'experiments/fourstate/hierarchy')
    args = p.parse_args()
    run_id = dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ') + '-' + uuid.uuid4().hex[:8]
    folder = fresh_directory(args.evidence / run_id)
    report = campaign(folder)
    print(folder / 'summary.json', report['status'])
    if report['status'] != 'PASS':
        print(report['error'], file=sys.stderr)
        raise SystemExit(1)


if __name__ == '__main__':
    main()
