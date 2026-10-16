"""Run staged four-state width and operator RTL / encoded RTL / Lean checks."""
from __future__ import annotations

import argparse
import datetime as dt
import itertools
import json
from pathlib import Path
import random
import re
import sys
import traceback
import uuid

from common import ROOT
from fourstate2lean import digest, fresh_directory, provenance, translate, write
from fourstate_frontend import parse
from fourstate_simulate import load, simulate
from verify_fourstate import compare as compare_comb, run_rtl as run_comb, tools_record
from verify_fourstate_sequential import compare as compare_seq, run_rtl as run_seq
from yosys2lean import translate_yosys
from yosys_simulate import experiment_initial, simulate_yosys


def vectors(seed, count=36):
    rng = random.Random(seed)
    rows = []
    for i in range(count):
        choice = '01xz'[i % 4]
        def bits(width):
            return choice * width if i < 4 else ''.join(rng.choice('01xz') for _ in range(width))
        rows.append({'inputs': {'s': bits(4), 'u': bits(4), 'short_u': bits(2), 'asc': bits(4),
                                'wide': bits(65), 'choose': choice}})
    return rows


def sampled(values):
    rows = []
    for value in values:
        rows.extend({'inputs': {**value, 'clk': clock}} for clock in ('0', '0', '1', '1'))
    return rows


def run_case(folder, top, trace, initial=None):
    source = ROOT / 'verification/fourstate' / (top + '.sv')
    case = folder / top
    case.mkdir()
    write(case / 'trace.json', trace)
    (case / 'trace.jsonl').write_text(''.join(json.dumps(x) + '\n' for x in trace), encoding='utf-8')
    if initial is not None:
        write(case / 'initial.json', initial)
    mode = 'sequential' if initial is not None else 'combinational'
    manifest = translate(source, top, case / 'translation', mode, 'clk' if initial is not None else None)
    mapping, _ = load(manifest)
    if initial is None:
        original = run_comb(source, mapping, trace, case / 'original')
        encoded = run_comb(manifest.parent / 'encoded.sv', mapping, trace, case / 'encoded', True)
        lean = simulate(manifest, trace, case / 'lean')
        output_bits = compare_comb(mapping, original, encoded, [x['outputs'] for x in lean])
        rails = json.loads((case / 'lean/lean/result.json').read_text(encoding='utf-8'))
        if [x['pre'] for x in rails] != encoded:
            raise ValueError('Encoded RTL and Lean rails differ')
        state_bits = 0
    else:
        original = run_seq(source, mapping, trace, initial, case / 'original')
        encoded = run_seq(manifest.parent / 'encoded.sv', mapping, trace, initial, case / 'encoded', True)
        lean = simulate(manifest, trace, case / 'lean', initial)
        compare_seq(original, encoded, lean)
        output_bits = 2 * len(trace) * sum(p['width'] for p in mapping['ports'] if p['direction'] == 'output')
        state_bits = 2 * len(trace) * sum(p['width'] for p in mapping['states'])
    return {'name': top, 'status': 'PASS', 'samples': len(trace), 'output_bit_positions': output_bits,
            'state_bit_positions': state_bits, 'source_sha256': digest(source),
            'manifest': str(manifest.relative_to(folder)), 'manifest_sha256': digest(manifest)}


def width_cases(folder):
    result = [run_case(folder, 'WidthTypes', vectors(410163))]
    values = [{'d': c * 4, 'en': e} for c in '01xz' for e in '01xz']
    result.append(run_case(folder, 'WidthState', sampled(values), {'q': 'z101', 'expanded': 'x1010101'}))
    return result


def logic_cases(folder):
    trace = [{'inputs': {'a': a, 'b': b}} for a, b in itertools.product('01xz', repeat=2)]
    result = [run_case(folder, 'LogicBits', trace)]
    words = [''.join(x) for x in itertools.product('01xz', repeat=2)]
    trace = [{'inputs': {'a': a, 'b': b, 'u': words[(i * 7) % len(words)]}}
             for i, (a, b) in enumerate(itertools.product(words, repeat=2))]
    result.append(run_case(folder, 'LogicCompare', trace))
    values = [{'a': a, 'b': b} for a, b in itertools.product('01xz', repeat=2)]
    result.append(run_case(folder, 'LogicState', sampled(values),
                           {'procedural': 'x', 'exact': 'z', 'merged': 'x'}))
    return result


def logic_fault(folder):
    case = folder / 'LogicBits'
    manifest = case / 'translation/fourstate-manifest.json'
    mapping, _ = load(manifest)
    output = next(p for p in mapping['ports'] if p['name'] == 'case_eq_ab')
    original = json.loads((case / 'original/result.json').read_text(encoding='utf-8'))
    lean = json.loads((case / 'lean/fourstate-result.json').read_text(encoding='utf-8'))
    trace = json.loads((case / 'trace.json').read_text(encoding='utf-8'))
    raw = (manifest.parent / 'encoded.sv').read_text(encoding='utf-8')
    pattern = r'assign ' + re.escape(output['value']) + r' = [^;]+;'
    mutated, count = re.subn(pattern, 'assign ' + output['value'] + " = ~(a__tag ^ b__tag);", raw)
    if count != 1:
        raise AssertionError('Case equality fault target missing')
    source = case / 'mutated-case-equality.sv'
    source.write_text(mutated, encoding='utf-8')
    result = run_comb(source, mapping, trace, case / 'mutated-case-equality', True)
    try:
        compare_comb(mapping, original, result, [x['outputs'] for x in lean])
    except ValueError as exc:
        return {'case': 'CaseEqualityIgnoresValue', 'status': 'PASS', 'diagnostic': str(exc),
                'mutated_sha256': digest(source)}
    raise AssertionError('Case equality fault was not detected')


def arithmetic_cases(folder):
    words = [''.join(x) for x in itertools.product('01xz', repeat=2)]
    amounts = ['00', '01', '10', '11', '0x', 'x1', 'z0', 'zz']
    trace = [{'inputs': {'a': a, 'b': b, 'amount': amounts[i % len(amounts)]}}
             for i, (a, b) in enumerate(itertools.product(words, repeat=2))]
    result = [run_case(folder, 'ArithmeticBits', trace)]
    rng = random.Random(410164)
    counter_values = [{'reset': r, 'en': e, 'load': ''.join(rng.choice('01xz') for _ in range(4))}
                      for r, e in itertools.product('01xz', repeat=2) for _ in range(2)]
    counter_values += [{'reset': '0', 'en': '1', 'load': '0000'} for _ in range(20)]
    result.append(run_case(folder, 'Counter4', sampled(counter_values), {'q': '1110'}))
    compare_values = []
    for i in range(40):
        compare_values.append({'reset': '01xz'[i % 4],
                               'a': ''.join(rng.choice('01xz') for _ in range(4)),
                               'b': ''.join(rng.choice('01xz') for _ in range(4)),
                               'u': ''.join(rng.choice('01xz') for _ in range(4))})
    compare_values += [{'reset': '0', 'a': '1111', 'b': '0001', 'u': '0001'},
                       {'reset': '0', 'a': '1000', 'b': '0111', 'u': '1111'}]
    result.append(run_case(folder, 'ComparatorControl', sampled(compare_values), {'selected': 'z101'}))
    shift_amounts = ['0000000', '0000001', '1000000', '1000001', '1111111',
                     '00000x1', '00000z1', 'xxxxxxx', 'zzzzzzz']
    shift_data = ['1' * 65, 'z' + '1010' * 16, 'x' + '0101' * 16,
                  '1' + '0' * 64, '0' * 64 + '1']
    shift_values = []
    for i in range(35):
        data = shift_data[i % len(shift_data)] if i < 20 else ''.join(rng.choice('01xz') for _ in range(65))
        shift_values.append({'reset': '01xz'[i % 4], 'data': data,
                             'amount': shift_amounts[i % len(shift_amounts)]})
    result.append(run_case(folder, 'ShiftPipeline', sampled(shift_values),
                           {'stage': 'z' + '1010' * 16, 'result': 'x' + '0101' * 16}))
    return result


def arithmetic_faults(folder):
    case = folder / 'ArithmeticBits'
    manifest = case / 'translation/fourstate-manifest.json'
    mapping, _ = load(manifest)
    original = json.loads((case / 'original/result.json').read_text(encoding='utf-8'))
    lean = json.loads((case / 'lean/fourstate-result.json').read_text(encoding='utf-8'))
    trace = json.loads((case / 'trace.json').read_text(encoding='utf-8'))
    raw = (manifest.parent / 'encoded.sv').read_text(encoding='utf-8')
    faults = []
    for name, before, after in [('AdditionBecomesSubtraction', ' + ', ' - '),
                                ('ArithmeticRightBecomesLogical', ' >>> ', ' >> ')]:
        if before not in raw:
            raise AssertionError('Arithmetic fault target missing: ' + name)
        source = case / (name + '.sv')
        source.write_text(raw.replace(before, after), encoding='utf-8')
        result = run_comb(source, mapping, trace, case / name, True)
        try:
            compare_comb(mapping, original, result, [x['outputs'] for x in lean])
        except ValueError as exc:
            faults.append({'case': name, 'status': 'PASS', 'diagnostic': str(exc),
                           'mutated_sha256': digest(source)})
        else:
            raise AssertionError('Arithmetic fault was not detected: ' + name)
    return faults


def known_cases(folder):
    counter = [{'reset': '1', 'en': '0', 'load': '0000'}]
    counter += [{'reset': '0', 'en': '1', 'load': '0000'} for _ in range(18)]
    counter += [{'reset': '0', 'en': '0', 'load': '1010'},
                {'reset': '0', 'en': '1', 'load': '0000'}]
    compare = [{'reset': '1', 'a': '0000', 'b': '0000', 'u': '0000'}]
    compare += [{'reset': '0', 'a': a, 'b': b, 'u': u}
                for a, b, u in [('1111', '0001', '0001'), ('1000', '0111', '1111'),
                                ('0111', '1000', '0010'), ('0010', '0011', '0100'),
                                ('0000', '0000', '1111')]]
    shift = [{'reset': '1', 'data': '0' * 65, 'amount': '0000000'}]
    shift += [{'reset': '0', 'data': data, 'amount': amount} for data, amount in [
        ('1' + '0' * 64, '0000001'), ('1' * 65, '1000000'),
        ('0' * 64 + '1', '1000001'), ('1' + '0' * 64, '1111111'),
        ('0' + '1' * 64, '0000000')]]
    cases = [('Counter4', counter, {'q': '0000'}),
             ('ComparatorControl', compare, {'selected': '0000'}),
             ('ShiftPipeline', shift, {'stage': '0' * 65, 'result': '0' * 65})]
    result, baselines = [], []
    for top, values, initial in cases:
        trace = sampled(values)
        result.append(run_case(folder, top, trace, initial))
        baselines.append(two_state_case(folder, top, trace))
    return result, baselines


def two_state_case(folder, top, trace):
    case = folder / top
    source = ROOT / 'verification/fourstate' / (top + '.sv')
    mapping, _ = load(case / 'translation/fourstate-manifest.json')
    original = json.loads((case / 'original/result.json').read_text(encoding='utf-8'))
    relative = translate_yosys(source, case / 'two-state-model', top,
                               namespace='FourState.OperatorBaseline',
                               evidence=case / 'two-state-translation',
                               yosys_engine='native', lean_backend='source', clock_mode='global')
    ir_path = case / 'two-state-model' / relative
    ir = json.loads(ir_path.read_text(encoding='utf-8'))
    initial = experiment_initial(ir)
    write(case / 'two-state-initial.json', initial)
    input_trace = [{k: int(v, 2) for k, v in row['inputs'].items()} for row in trace]
    ports = [p for p in mapping['ports'] if p['direction'] == 'output']
    for choice in (0, 1):
        extra = {p['name']: ((1 << p['width']) - 1) * choice for p in ir['arbitrary_inputs']}
        request = [{'inputs': {**values, **extra}} for values in input_trace]
        code, baseline = simulate_yosys(ir_path, request, initial, case / ('two-state-run-' + str(choice)))
        if code or len(baseline) != len(trace):
            raise ValueError('Known-value two-state execution failed: ' + top)
        for i, (raw, model) in enumerate(zip(original, baseline)):
            actual = {p['name']: format(model['post'][p['name']], f"0{p['width']}b") for p in ports}
            if actual != raw['post']['outputs']:
                raise ValueError(f'Known-value two-state mismatch: {top} sample {i}, choice {choice}')
    return {'name': top, 'status': 'PASS', 'samples': len(trace),
            'arbitrary_inputs': ir['arbitrary_inputs'], 'arbitrary_choices': [0, 1],
            'initial_choice': 'Original registers and unconstrained Yosys auxiliary bits zero; known constraints retained.'}


def legacy_replay(folder):
    examples = [
        ('v1', ROOT / 'generated/fourstate/operators-example-v1/fourstate-manifest.json',
         ROOT / 'experiments/fourstate/20261016T141220Z-2af4545a/Operators/trace.jsonl',
         None, ROOT / 'experiments/fourstate/cli-20261016-v1/replay/fourstate-result.json'),
        ('v2', ROOT / 'generated/fourstate/sequential-example-v1/fourstate-manifest.json',
         ROOT / 'experiments/fourstate/sequential/20261016T143541Z-a8360f4b/SequentialControl/initial-x/trace.jsonl',
         ROOT / 'experiments/fourstate/sequential/20261016T143541Z-a8360f4b/SequentialControl/initial-x/initial.json',
         ROOT / 'experiments/fourstate/sequential-cli-20261016-v1/replay/fourstate-result.json'),
    ]
    checks = []
    for version, manifest, trace_path, initial_path, expected_path in examples:
        trace = [json.loads(line) for line in trace_path.read_text(encoding='utf-8').splitlines() if line.strip()]
        initial = json.loads(initial_path.read_text(encoding='utf-8')) if initial_path else None
        actual = simulate(manifest, trace, folder / ('replay-' + version), initial)
        expected = json.loads(expected_path.read_text(encoding='utf-8'))
        if actual != expected:
            raise ValueError('Legacy four-state replay changed: ' + version)
        checks.append({'version': version, 'status': 'PASS', 'samples': len(trace),
                       'manifest_sha256': digest(manifest), 'expected_sha256': digest(expected_path)})
    return checks


def campaign(folder, batch):
    report = {'status': 'RUNNING', 'batch': batch, 'command': [sys.executable, *sys.argv],
              'cases': [], 'rejections': [], 'fault_checks': [], 'legacy_replays': [],
              'scope': 'Finite four-state operator differential tests; not a general equivalence proof.'}
    write(folder / 'summary.json', report)
    try:
        report['tools'] = tools_record(folder / 'tools')
        report['source_snapshot_sha256'] = provenance(folder)
        if batch == 'width':
            report['cases'] = width_cases(folder)
            rejected = {
                'Unsized': "module T(input [3:0] a, output [3:0] y); assign y=a+1; endmodule",
                'DynamicCast': "module T(input [3:0] a, output [7:0] y); assign y=$bits(a)'(a); endmodule",
            }
            for name, raw in rejected.items():
                source = folder / 'rejections' / (name + '.sv')
                source.parent.mkdir(exist_ok=True)
                source.write_text(raw, encoding='utf-8')
                try:
                    parse(source, 'T')
                except (ValueError, RuntimeError) as exc:
                    if str(source) not in str(exc):
                        raise AssertionError('Missing source position: ' + name) from exc
                    report['rejections'].append({'case': name, 'status': 'PASS', 'diagnostic': str(exc)})
                else:
                    raise AssertionError('Unsupported source accepted: ' + name)
        elif batch == 'logic':
            report['cases'] = logic_cases(folder)
            report['fault_checks'].append(logic_fault(folder))
            rejected = {
                'Multiply': "module T(input a,b,output y); assign y=a*b; endmodule",
                'DeadMultiply': "module T(input a,b,output y); assign y=1'b0 ? (a*b) : a; endmodule",
            }
            for name, raw in rejected.items():
                source = folder / 'rejections' / (name + '.sv')
                source.parent.mkdir(exist_ok=True)
                source.write_text(raw, encoding='utf-8')
                try:
                    parse(source, 'T')
                except (ValueError, RuntimeError) as exc:
                    if str(source) not in str(exc):
                        raise AssertionError('Missing source position: ' + name) from exc
                    report['rejections'].append({'case': name, 'status': 'PASS', 'diagnostic': str(exc)})
                else:
                    raise AssertionError('Unsupported source accepted: ' + name)
        elif batch == 'arithmetic':
            report['cases'] = arithmetic_cases(folder)
            report['fault_checks'] = arithmetic_faults(folder)
            rejected = {
                'Multiplication': "module T(input a,b,output y); assign y=a*b; endmodule",
                'UnsizedCounter': "module T(input clk,output logic [3:0] q); always_ff @(posedge clk) q<=q+1; endmodule",
                'DeadDivision': "module T(input a,b,output y); assign y=1'b0 ? (a/b) : a; endmodule",
            }
            for name, raw in rejected.items():
                source = folder / 'rejections' / (name + '.sv')
                source.parent.mkdir(exist_ok=True)
                source.write_text(raw, encoding='utf-8')
                try:
                    parse(source, 'T', 'sequential' if name == 'UnsizedCounter' else 'combinational',
                          'clk' if name == 'UnsizedCounter' else None)
                except (ValueError, RuntimeError) as exc:
                    if str(source) not in str(exc):
                        raise AssertionError('Missing source position: ' + name) from exc
                    report['rejections'].append({'case': name, 'status': 'PASS', 'diagnostic': str(exc)})
                else:
                    raise AssertionError('Unsupported source accepted: ' + name)
        elif batch == 'compatibility':
            report['cases'], report['two_state_compatibility'] = known_cases(folder)
            report['legacy_replays'] = legacy_replay(folder)
        else:
            raise ValueError('Batch not yet implemented: ' + batch)
        report['status'] = 'PASS'
    except Exception:
        report['status'] = 'FAIL'
        report['error'] = traceback.format_exc()
    finally:
        report['artifact_sha256'] = {p.relative_to(folder).as_posix(): digest(p)
                                     for p in folder.rglob('*') if p.is_file() and p.name != 'summary.json'}
        write(folder / 'summary.json', report)
    return report


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--batch', choices=['width', 'logic', 'arithmetic', 'compatibility'], required=True)
    p.add_argument('--evidence', type=Path, default=ROOT / 'experiments/fourstate/operators')
    args = p.parse_args()
    run_id = dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ') + '-' + uuid.uuid4().hex[:8]
    folder = fresh_directory(args.evidence / run_id)
    report = campaign(folder, args.batch)
    print(folder / 'summary.json', report['status'])
    if report['status'] != 'PASS':
        print(report['error'], file=sys.stderr)
        raise SystemExit(1)


if __name__ == '__main__':
    main()
