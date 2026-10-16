"""Check large shift counts against original RTL and independent integers."""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import random

from common import ROOT, lean_executable, run_logged
from rtl import run_emitted_rtl
from yosys2lean import digest, translate_yosys, write
from yosys_simulate import simulate_yosys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--runner', type=Path, required=True)
    parser.add_argument('--evidence', type=Path, default=ROOT / 'experiments/yosys-bounded-shifts-7.3')
    args = parser.parse_args()
    base = args.evidence.resolve()
    base.mkdir(parents=True, exist_ok=True)
    runner = args.runner.resolve()
    runner_manifest = json.loads((runner / 'manifest.json').read_text(encoding='utf-8'))
    assert runner_manifest['runtime_sha256'] == digest(ROOT / 'lean/Chisel2Lean/Functional.lean')
    env = os.environ.copy()
    env['LEAN_PATH'] = str(runner)
    proof = ROOT / 'verification/yosys/BoundedShifts.lean'
    assert run_logged([lean_executable(), str(proof)], base / 'proofs', cwd=ROOT, env=env, echo=False) == 0
    proof_log = (base / 'proofs/stdout.log').read_text(encoding='utf-8')
    assert 'sorryAx' not in proof_log
    assert [line for line in proof_log.splitlines() if line.isdecimal()] == ['0', '0', str((1 << 65) - 1)]

    widths = (1, 8, 65, 127, 256)
    ports = [{'name': name, 'rtl_name': name, 'direction': 'input', 'width': 256}
             for name in ('value', 'amount')]
    declarations = ['input [255:0] value', 'input [255:0] amount']
    statements = []
    for width in widths:
        for kind, expression in [('left', f'value[{width-1}:0] << amount'),
                                 ('right', f'value[{width-1}:0] >> amount'),
                                 ('signed', f'$signed(value[{width-1}:0]) >>> amount')]:
            name = f'w{width}_{kind}'
            ports.append({'name': name, 'rtl_name': name, 'direction': 'output', 'width': width})
            declarations.append(f'output [{width-1}:0] {name}')
            statements.append(f'assign {name} = {expression};')
    source = base / 'BoundedShifts.sv'
    source.write_text('module BoundedShifts(\n' + ',\n'.join(declarations) + '\n);\n' + '\n'.join(statements) + '\nendmodule\n', encoding='utf-8')
    source_hash = digest(source)
    counts = [0, 1, 7, 8, 64, 65, 66, 126, 127, 128, 255, 256, 257, (1 << 64)-1, 1 << 255, (1 << 256)-1]
    values = sorted({0, 1, (1 << 256)-1, *[1 << (width-1) for width in widths]})
    trace = [{'inputs': {'value': value, 'amount': amount}} for value in values for amount in counts]
    rng = random.Random(71643)
    trace += [{'inputs': {'value': rng.getrandbits(256), 'amount': rng.randrange(300)}} for _ in range(96)]
    expected = []
    for row in trace:
        outputs = {}
        value, amount = row['inputs']['value'], row['inputs']['amount']
        for width in widths:
            mask = (1 << width)-1
            word = value & mask
            signed = word - (1 << width) if word & (1 << (width-1)) else word
            outputs[f'w{width}_left'] = 0 if amount >= width else (word << amount) & mask
            outputs[f'w{width}_right'] = 0 if amount >= width else word >> amount
            outputs[f'w{width}_signed'] = ((-int(signed < 0)) if amount >= width else signed >> amount) & mask
        expected.append(outputs)
    write(base / 'trace.json', trace)
    code, rtl = run_emitted_rtl(base, {'top': 'BoundedShifts', 'clocked': False,
        'rtl_sources': [source.name], 'ports': ports}, trace, base / 'reference')
    assert code == 0 and len(rtl) == len(trace)
    for actual, integer in zip(rtl, expected):
        assert actual['pre'] == actual['post'] == integer
    models = []
    for backend in ('source', 'table'):
        model = base / backend
        translate_yosys(source, model, 'BoundedShifts', 'Shift.' + backend.capitalize(),
            evidence=base / (backend + '-translation'), yosys_engine='native', lean_backend=backend)
        manifest = json.loads((model / 'manifest.json').read_text(encoding='utf-8'))
        ir = json.loads((model / manifest['ir']).read_text(encoding='utf-8'))
        assert {'bvshl', 'bvlshr', 'bvashr'} <= {node['op'] for node in ir['nodes']}
        assert not ir['arbitrary_inputs'] and not ir['states']
        path = model / (manifest.get('interface') or manifest['ir'])
        engines = [('bytecode', None)] + ([('native', runner)] if backend == 'table' else [])
        for engine, native in engines:
            code, actual = simulate_yosys(path, trace, {}, base / (backend + '-' + engine), native)
            assert code == 0 and actual == rtl, (backend, engine)
            models.append({'backend': backend, 'engine': engine, 'samples': len(actual),
                'output_comparisons': len(actual) * 2 * len(expected[0]), 'manifest_sha256': digest(model / 'manifest.json')})
        assert digest(source) == source_hash
    report = {'status': 'PASS', 'widths': widths, 'samples': len(trace), 'models': models,
        'maximum_shift_count': max(counts), 'runtime_sha256': runner_manifest['runtime_sha256'],
        'proof_source_sha256': digest(proof), 'proof_log_sha256': digest(base / 'proofs/stdout.log'),
        'original_rtl_sha256': source_hash,
        'scope': 'Lean checks three generic equalities for all widths/counts. Source, table bytecode and native table evaluation match independent Verilator and integer traces, including 256-bit shift counts. This is not whole-chip equivalence.'}
    write(base / 'summary.json', report)
    write(ROOT / 'docs/validation-bounded-shifts-7.3.json', report)
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
