"""Check the native Lean executable against completed bytecode/RTL traces."""
from __future__ import annotations

import json
import os
from pathlib import Path
import argparse

from common import ROOT, lean_executable, run_logged
from yosys2lean import digest, write


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--runner', type=Path, default=ROOT / 'experiments/lean-table-native-7.3')
    args = parser.parse_args()
    runner_folder = args.runner.resolve()
    report = json.loads((runner_folder / 'manifest.json').read_text(encoding='utf-8'))
    executable = Path(report['executable'])
    assert report['status'] == 'PASS' and digest(executable) == report['executable_sha256']
    tools = Path(lean_executable()).parent
    for name, expected in report['tools_sha256'].items():
        assert digest(tools / name) == expected
    env = os.environ.copy()
    env['PATH'] = str(tools) + os.pathsep + env.get('PATH', '')
    base = ROOT / ('experiments/yosys-table-native-stream-7.3' if report.get('request_format') == 'jsonl-v1' else 'experiments/yosys-table-native-7.3')
    cases = []
    for index in range(13):
        reference = ROOT / 'experiments/yosys-table-7.3' / str(index)
        model = reference / 'model'
        binary = next(model.rglob('*.circuit.bin'))
        log = base / str(index) / 'execution'
        request = reference / 'request.json'
        if report.get('request_format') == 'jsonl-v1':
            data = json.loads(request.read_text(encoding='utf-8'))
            request = base / str(index) / 'request.jsonl'
            request.parent.mkdir(parents=True, exist_ok=True)
            with request.open('w', encoding='utf-8') as stream:
                stream.write(json.dumps({'initial': data['initial']}) + '\n')
                for row in data['trace']:
                    stream.write(json.dumps(row) + '\n')
        code = run_logged([str(executable), str(binary), str(request)], log,
                          cwd=model, env=env, echo=False)
        assert code == 0, str(log)
        actual = [json.loads(line) for line in (log / 'stdout.log').read_text(encoding='utf-8').splitlines() if line.strip()]
        expected = [json.loads(line) for line in (reference / 'execution/stdout.log').read_text(encoding='utf-8').splitlines() if line.strip()]
        assert actual == expected, str(reference)
        cases.append({'case': index, 'steps': len(actual), 'data_sha256': digest(binary),
                      'reference_runtime_sha256': digest(model / 'Chisel2Lean/Functional.lean'),
                      'reference_sha256': digest(reference / 'execution/stdout.log')})
        print('PASS native Lean case ' + str(index), flush=True)
    result = {'status': 'PASS', 'cases': cases, 'runner_manifest_sha256': digest(runner_folder / 'manifest.json'),
              'scope': 'The same Lean definitions compiled by the pinned Lean/Clang toolchain reproduce every output and observation of the bytecode models and their RTL/initial-state contract references.'}
    write(base / 'summary.json', result)
    write(ROOT / ('docs/validation-lean-table-native-stream-7.3.json' if report.get('request_format') == 'jsonl-v1' else 'docs/validation-lean-table-native-7.3.json'), result)
    print(json.dumps({'status': 'PASS', 'cases': len(cases), 'steps': sum(case['steps'] for case in cases)}, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
