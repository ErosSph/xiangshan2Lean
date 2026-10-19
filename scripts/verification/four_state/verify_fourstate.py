"""Independent Icarus/original, Icarus/encoded and executable Lean validation."""
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
import re
import shutil
import sys
import traceback
import uuid

from bootstrap_fourstate import INSTALL as PARSER, load_parser
from bootstrap_native_yosys import INSTALL as NATIVE, environment
from common import ROOT, lean_executable, run_logged
from fourstate_frontend import parse
from fourstate2lean import digest, fresh_directory, provenance, translate, write
from fourstate_simulate import decode, encode_trace, load, simulate
from yosys2lean import translate_yosys
from yosys_simulate import simulate_yosys

SEED = 410161


def run_rtl(source, mapping, trace, folder, encoded=False, *, defines=(), include_dirs=()):
    folder.mkdir(parents=True)
    ports = mapping['ports']
    declarations, connections, inputs, outputs = [], [], [], []
    for i, p in enumerate(ports):
        keys = ('tag', 'value') if encoded else ('name',)
        for j, key in enumerate(keys):
            local = f's{i}_{j}'
            bounds = f"[{p['width']-1}:0]" if encoded else f"[{p['left']}:{p['right']}]"
            declarations.append(('reg' if p['direction'] == 'input' else 'wire') + f' {bounds} {local};')
            connections.append(f'.{p[key]}({local})')
            (inputs if p['direction'] == 'input' else outputs).append((p[key], local, p['width']))
    top = mapping['encoded_top'] if encoded else mapping['top']
    lines = ['module tb;', *declarations, f'{top} dut(' + ', '.join(connections) + ');', 'initial begin']
    rows = encode_trace(mapping, trace) if encoded else trace
    for i, row in enumerate(rows):
        for name, local, width in inputs:
            bits = format(row['inputs'][name], f'0{width}b') if encoded else row['inputs'][name]
            lines.append(f"{local} = {width}'b{bits};")
        lines.append('#1;')
        lines.append('$display("' + str(i) + ' ' + ' '.join('%b' for _ in outputs) + '", ' + ', '.join(p[1] for p in outputs) + ');')
    lines.extend(['$finish;', 'end', 'endmodule'])
    bench = folder / 'tb.sv'; bench.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    image = folder / 'sim.vvp'
    compiler, runner = shutil.which('iverilog'), shutil.which('vvp')
    if not compiler or not runner:
        raise RuntimeError('Icarus iverilog and vvp required on PATH')
    from fourstate_elaborated import source_files
    if run_logged([compiler, '-g2012', '-s', 'tb', '-o', str(image),
                   *['-D' + d for d in defines], *['-I' + str(p) for p in include_dirs],
                   *[str(p) for p in source_files(source)], str(bench)], folder / 'compile', echo=False):
        raise RuntimeError('Icarus compilation failed: ' + str(folder))
    if run_logged([runner, str(image)], folder / 'execute', echo=False):
        raise RuntimeError('Icarus execution failed: ' + str(folder))
    result = []
    for line in (folder / 'execute/stdout.log').read_text().splitlines():
        if line.startswith(str(bench)) and '$finish called' in line:
            continue
        if '$finish called at' in line:
            continue
        fields = line.split()
        if len(fields) != len(outputs) + 1 or fields[0] != str(len(result)):
            raise ValueError('Malformed/missing Icarus output: ' + line)
        values = {}
        for (name, _, width), bits in zip(outputs, fields[1:]):
            if len(bits) != width or any(c not in ('01' if encoded else '01xz') for c in bits):
                raise ValueError('Unknown encoded rail or malformed output: ' + bits)
            values[name] = int(bits, 2) if encoded else bits
        result.append(values)
    if len(result) != len(trace):
        raise ValueError('Incomplete Icarus trace')
    write(folder / 'result.json', result)
    return result


def compare(mapping, original, encoded, lean):
    if len(original) != len(encoded) or len(original) != len(lean) or not original:
        raise ValueError('Trace length mismatch')
    expected = {p['name'] for p in mapping['ports'] if p['direction'] == 'output'}
    comparisons = 0
    for i, (a, b, c) in enumerate(zip(original, encoded, lean)):
        if set(a) != expected or set(c) != expected or a != decode(mapping, b) or a != c:
            raise ValueError(f'Three-way mismatch at sample {i}: original={a}, encoded={b}, lean={c}')
        comparisons += sum(p['width'] for p in mapping['ports'] if p['direction'] == 'output')
    return comparisons


def rejected_cases():
    wrap = lambda body: 'module T(input a,b, output y); ' + body + ' endmodule'
    return {
        'Register': wrap('always @(posedge a) y <= b;'),
        'Memory': wrap('reg m[0:1]; assign y=m[0];'),
        'Procedural': wrap('always_comb y=a;'),
        'Hierarchy': wrap('T child(a,b,y);'),
        'MultipleDrivers': wrap('assign y=a; assign y=b;'),
        'Undriven': wrap('wire n; assign y=n;'),
        'Cycle': wrap('wire n; assign n=y; assign y=n;'),
        'Inout': 'module T(inout a, output y); assign y=a; endmodule',
        'Strength': wrap('assign (strong1,pull0) y=a;'),
        'Delay': wrap('assign #1 y=a;'),
        'DeadMultiply': wrap("assign y=1'b0 ? (a*b) : a;"),
        # F4.2 promotes source macros and inactive missing includes to positive
        # tests in test_fourstate_preprocess / verify_fourstate_preprocess.
        'Unsized': wrap('assign y=1;'),
        'ConditionWidth': 'module T(input [1:0] a, output y); assign y=a ? 1\'b1 : 1\'b0; endmodule',
        'PartialLvalue': 'module T(input a, output [1:0] y); assign y[0]=a; endmodule',
        'DynamicSelect': 'module T(input [1:0] a, input b, output y); assign y=a[b]; endmodule',
        'OutOfRange': 'module T(input [1:0] a, output y); assign y=a[2]; endmodule',
        'Collision': 'module T(input a,a__tag, output y); assign y=a; endmodule',
        'NonAnsi': 'module T(a,y); input a; output y; assign y=a; endmodule',
        'TwoStateType': 'module T(input bit a, output y); assign y=a; endmodule',
        'TriNet': wrap('tri n; assign n=a; assign y=n;'),
        'NoOutput': 'module T(input a); endmodule',
        'NegativeRange': 'module T(input [-1:-4] a, output [3:0] y); assign y=a; endmodule',
        'ArrayPort': 'module T(input a[0:1], output y); assign y=a[0]; endmodule',
        'PackedDimensions': 'module T(input [1:0][1:0] a, output [3:0] y); assign y=a; endmodule',
        'OutputInitializer': 'module T(input a, output logic y=0); endmodule',
        'Attribute': wrap('(* keep *) wire n; assign n=a; assign y=n;'),
        'Function': wrap('function f(input x); f=x; endfunction assign y=f(a);'),
    }


def expect_failure(name, action, results):
    try:
        action()
    except (ValueError, RuntimeError) as exc:
        results.append({'case': name, 'status': 'PASS', 'diagnostic': str(exc)})
        return
    raise AssertionError('Expected failure not detected: ' + name)


def tools_record(folder):
    versions = {}
    commands = {'python': [sys.executable, '--version'], 'iverilog': [shutil.which('iverilog'), '-V'],
                'vvp': [shutil.which('vvp'), '-V'], 'lean': [lean_executable(), '--version'],
                'yosys': [str(NATIVE / 'bin/yosys.exe'), '-V']}
    for name, cmd in commands.items():
        if not cmd[0]:
            raise RuntimeError('Missing tool: ' + name)
        path = folder / name
        if run_logged(cmd, path, env=environment() if name == 'yosys' else None, echo=False):
            raise RuntimeError('Tool probe failed: ' + name)
        versions[name] = {'executable': cmd[0], 'sha256': digest(cmd[0]),
                          'output': (path / 'stdout.log').read_text() + (path / 'stderr.log').read_text()}
    versions['pyslang'] = {'version': load_parser().__version__,
                          'install': json.loads((PARSER / 'fourstate-install.json').read_text())}
    return versions


def campaign(folder):
    report = {'status': 'RUNNING', 'seed': SEED, 'cases': [], 'rejections': [], 'fault_checks': [],
              'scope': 'Finite unsigned combinational four-state subset; not a compiler equivalence proof.'}
    write(folder / 'summary.json', report)
    try:
        report['tools'] = tools_record(folder / 'tools')
        report['source_snapshot_sha256'] = provenance(folder)
        for name, text in rejected_cases().items():
            source = folder / 'rejections' / (name + '.sv')
            source.parent.mkdir(exist_ok=True); source.write_text(text, encoding='utf-8')
            expect_failure(name, lambda: parse(source, 'T'), report['rejections'])
            diagnostic = report['rejections'][-1]['diagnostic']
            if str(source) not in diagnostic or not any(c.isdigit() for c in diagnostic):
                raise AssertionError('Missing source location: ' + name)
        rng = random.Random(SEED)
        cases = [('Operators', [{'inputs': dict(zip(('a', 'b', 'c'), values))} for values in itertools.product('01xz', repeat=3)])]
        vectors = []
        for i in range(132):
            values = {k: (('01xz'[i] * w) if i < 4 else ''.join(rng.choice('01xz') for _ in range(w)))
                      for k, w in [('a', 4), ('b', 4), ('wide_a', 65), ('wide_b', 65)]}
            values['c'] = '01xz'[i % 4]
            vectors.append({'inputs': values})
        cases.append(('Vectors', vectors))
        cases.append(('Literals', [{'inputs': {}}]))
        for name, trace in cases:
            print('Validating', name, flush=True)
            case = folder / name; case.mkdir()
            source = ROOT / 'verification/fourstate' / (name + '.sv')
            source_hash = digest(source)
            manifest = translate(source, name, case / 'translation')
            mapping, ir = load(manifest)
            write(case / 'trace.json', trace)
            (case / 'trace.jsonl').write_text(''.join(json.dumps(row) + '\n' for row in trace), encoding='utf-8')
            original = run_rtl(source, mapping, trace, case / 'original')
            encoded = run_rtl(manifest.parent / 'encoded.sv', mapping, trace, case / 'encoded', True)
            lean = simulate(manifest, trace, case / 'execution')
            count = compare(mapping, original, encoded, [r['outputs'] for r in lean])
            raw_lean = json.loads((case / 'execution/lean/result.json').read_text())
            if [r['pre'] for r in raw_lean] != encoded:
                raise ValueError('Encoded RTL and Lean rails differ')
            if digest(source) != source_hash:
                raise AssertionError('Original source changed')
            result = {'name': name, 'status': 'PASS', 'samples': len(trace), 'compared_bits': count,
                      'source_sha256': source_hash, 'manifest': str(manifest.relative_to(folder)),
                      'manifest_sha256': digest(manifest)}
            report['cases'].append(result)
            if name == 'Operators':
                mutation_source = case / 'mutated-encoded.sv'
                text = (manifest.parent / 'encoded.sv').read_text()
                for port in mapping['ports']:
                    if port['direction'] == 'output':
                        pattern = r'assign ' + re.escape(port['value']) + r' = ([^;]+);'
                        text, count_mutations = re.subn(pattern, lambda m: 'assign ' + port['value'] + ' = (' + m[1] + ') ^ ' + port['tag'] + ';', text)
                        if count_mutations != 1:
                            raise AssertionError('Mutation target missing')
                mutation_source.write_text(text, encoding='utf-8')
                mutated = run_rtl(mutation_source, mapping, trace, case / 'mutated-encoded-run', True)
                write(case / 'mutated-xz-outputs.json', mutated)
                expect_failure('SwapXZ', lambda: compare(mapping, original, mutated, [r['outputs'] for r in lean]), report['fault_checks'])
                expect_failure('MissingSample', lambda: compare(mapping, original[:-1], encoded, [r['outputs'] for r in lean]), report['fault_checks'])
                missing = [dict(row) for row in encoded]; missing[0].pop(mapping['ports'][-1]['tag'])
                expect_failure('MissingOutput', lambda: compare(mapping, original, missing, [r['outputs'] for r in lean]), report['fault_checks'])
                for asset in ['ports.json', 'encoded.sv']:
                    corrupt = case / ('corrupt-' + asset.replace('.', '-'))
                    shutil.copytree(manifest.parent, corrupt)
                    with (corrupt / asset).open('a', encoding='utf-8') as stream:
                        stream.write('\ncorrupted\n')
                    expect_failure('Corrupt-' + asset, lambda: load(corrupt / manifest.name), report['fault_checks'])
                for label, bad in [('MissingInput', [{'inputs': {}}]), ('WrongWidth', [{'inputs': {'a': '00', 'b': '0', 'c': '0'}}]),
                                   ('InvalidSymbol', [{'inputs': {'a': '?', 'b': '0', 'c': '0'}}]),
                                   ('ExtraInput', [{'inputs': {'a': '0', 'b': '0', 'c': '0', 'extra': '0'}}])]:
                    expect_failure(label, lambda: encode_trace(mapping, bad), report['fault_checks'])
                unknown = dict(encoded[0]); unknown[mapping['ports'][-1]['tag']] = 'x'
                expect_failure('UnknownEncodedRail', lambda: decode(mapping, unknown), report['fault_checks'])
                expect_failure('NonemptyOutput', lambda: fresh_directory(manifest.parent), report['fault_checks'])
                known = [row for row in trace if all(x in '01' for x in row['inputs'].values())]
                relative = translate_yosys(source, case / 'two-state-model', name, namespace='FourState.Baseline',
                                           evidence=case / 'two-state-translation', yosys_engine='native', lean_backend='source')
                code, baseline = simulate_yosys(case / 'two-state-model' / relative,
                    [{'inputs': {k: int(v) for k, v in row['inputs'].items()}} for row in known], {}, case / 'two-state-run')
                if code or len(baseline) != len(known):
                    raise ValueError('Two-state compatibility execution failed')
                expected = [original[trace.index(row)] for row in known]
                if [{k: str(v) for k, v in row['pre'].items()} for row in baseline] != expected:
                    raise ValueError('Two-state known-input mismatch')
                report['two_state_compatibility'] = {'status': 'PASS', 'samples': len(known)}
            write(folder / 'summary.json', report)
        report['status'] = 'PASS'
    except Exception:
        report['status'] = 'FAIL'; report['error'] = traceback.format_exc()
        raise
    finally:
        report['artifact_sha256'] = {p.relative_to(folder).as_posix(): digest(p) for p in folder.rglob('*')
                                     if p.is_file() and p != folder / 'summary.json'}
        write(folder / 'summary.json', report)
    return report


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--evidence', type=Path, default=ROOT / 'experiments/fourstate')
    args = p.parse_args()
    run = dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ') + '-' + uuid.uuid4().hex[:8]
    folder = fresh_directory(args.evidence / run)
    print('Evidence:', folder, flush=True)
    report = campaign(folder)
    print(json.dumps({k: report[k] for k in ('status', 'cases', 'two_state_compatibility')}, indent=2))


if __name__ == '__main__':
    main()
