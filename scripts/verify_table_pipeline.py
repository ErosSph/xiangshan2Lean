"""Verify the real table CLI artifacts, runner and negative data validation."""
from __future__ import annotations

import copy
import json
import os
import shutil

from common import ROOT, lean_executable, run_logged
from lean_table import emit_table
from yosys2lean import digest, write
from yosys_simulate import simulate_yosys


def main():
    base = ROOT / 'experiments/yosys-table-pipeline-7.3'
    model = base / 'model'
    manifest = json.loads((model / 'manifest.json').read_text(encoding='utf-8'))
    assert manifest['lean_checked'] and manifest['lean_backend'] == 'table'
    metadata = json.loads((model / manifest['interface']).read_text(encoding='utf-8'))
    source = ROOT / 'experiments/yosys-exposure-7.3/lean'
    request = json.loads((source / 'request.json').read_text(encoding='utf-8'))
    trace = [{'inputs': {name: value for name, value in row['inputs'].items() if name != metadata['clock']}}
             for row in request['trace']]
    code, actual = simulate_yosys(model / manifest['interface'], trace, request['initial'], base / 'replay')
    assert code == 0 and actual == json.loads((source / 'result.json').read_text(encoding='utf-8'))
    ir = json.loads((model / manifest['ir']).read_text(encoding='utf-8'))
    rejected = []
    for name in ('extra-byte', 'future-argument'):
        bad = copy.deepcopy(ir)
        bad['namespace'] = 'BadTable.Data'
        if name == 'future-argument':
            bad['nodes'][0]['args'] = [len(bad['nodes'])]
        stage = base / name
        lean, info = emit_table(bad, stage)
        if name == 'extra-byte':
            with (stage / info['hexadecimal']).open('a', encoding='ascii') as stream:
                stream.write('00')
        shutil.copy2(model / 'Chisel2Lean/Functional.olean', stage / 'Chisel2Lean/Functional.olean')
        env = os.environ.copy()
        env['LEAN_PATH'] = str(stage)
        log = stage / 'check'
        code = run_logged([lean_executable(), str(lean)], log, cwd=stage, env=env, echo=False)
        output = (log / 'stdout.log').read_text(encoding='utf-8') + (log / 'stderr.log').read_text(encoding='utf-8')
        expected = 'Extra bytes after the circuit' if name == 'extra-byte' else 'out of range'
        assert code != 0 and expected in output, (name, output)
        rejected.append(name)
    report = {'status': 'PASS', 'steps': len(actual), 'rejected_packets': rejected,
              'manifest_sha256': digest(model / 'manifest.json'),
              'reference_sha256': digest(source / 'result.json'),
              'scope': 'Actual CLI-generated table model compiles, validates all data and replays the independently RTL-checked literal-print/property trace. Malformed packet and future-node references fail Lean checking.'}
    write(base / 'summary.json', report)
    write(ROOT / 'docs/validation-yosys-table-pipeline-7.3.json', report)
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
