"""Compare actual Lean table execution with independently checked RTL traces."""
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


import json
import os
import shutil
import argparse

from common import ROOT, lean_executable, run_logged
from lean_table import emit_table
from yosys2lean import digest, write


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--start', type=int, default=0, help='Continue after already recorded cases with an identical runtime')
    args = parser.parse_args()
    base = ROOT / 'experiments/yosys-table-7.3'
    references = [ROOT / p for p in [
        'experiments/yosys-full-adaptation-7.3/Counter4',
        'experiments/yosys-full-adaptation-7.3/Signed65',
        'experiments/yosys-full-adaptation-7.3/Handshake65x3',
        'experiments/yosys-full-adaptation-7.3/Queue3',
        'experiments/yosys-full-adaptation-7.3/SyncQueue3',
        'experiments/yosys-clocks-7.3', 'experiments/yosys-contracts/MaskedMemory',
        'experiments/yosys-contracts/PartialInitial', 'experiments/yosys-effects-7.3/Observed',
        'experiments/yosys-effects-7.3/DisabledCheck', 'experiments/yosys-stdio-7.3',
        'experiments/xiangshan-sram-7.3/SramArray1P', 'experiments/xiangshan-sram-7.3/SramArray2P',
        'experiments/yosys-full-adaptation-7.3/XSAlu', 'experiments/yosys-full-adaptation-7.3/XSPrefetch',
        'experiments/yosys-chunks-7.3/Large', 'experiments/yosys-records-7.3']]
    results = []
    negative_cases = []
    runtime_cache = None
    if args.start:
        recorded = json.loads((base / 'summary.json').read_text(encoding='utf-8'))
        assert recorded['status'] == 'PASS' and len(recorded['cases']) == args.start
        assert recorded['runtime_sha256'] == digest(ROOT / 'lean/Chisel2Lean/Functional.lean')
        results, negative_cases = recorded['cases'], recorded['negative_cases']
        runtime_cache = base / '0/model/Chisel2Lean/Functional.lean'
        assert digest(runtime_cache) == recorded['runtime_sha256']
    for index, reference in enumerate(references):
        if index < args.start:
            assert results[index]['reference'] == str(reference.relative_to(ROOT))
            continue
        previous = json.loads((reference / 'model/manifest.json').read_text(encoding='utf-8'))
        ir = json.loads((reference / 'model' / previous['ir']).read_text(encoding='utf-8'))
        reference_run = reference / ('13' if reference.name == 'PartialInitial' else 'valid-lean' if reference.name == 'Observed' else 'lean')
        request = json.loads((reference_run / 'request.json').read_text(encoding='utf-8'))
        expected = json.loads((reference_run / 'result.json').read_text(encoding='utf-8'))
        folder = base / str(index)
        model = folder / 'model'
        ir['namespace'] = 'Table.Case' + str(index)
        lean, info = emit_table(ir, model)
        env = os.environ.copy()
        env['LEAN_PATH'] = str(model.resolve())
        runtime = model / info['runtime']
        if runtime_cache is None:
            code = run_logged([lean_executable(), '-o', str(runtime.with_suffix('.olean').resolve()), str(runtime.resolve())],
                              folder / 'runtime-check', cwd=model.resolve(), env=env, echo=False)
            runtime_cache = runtime
        else:
            assert digest(runtime) == digest(runtime_cache)
            shutil.copy2(runtime_cache.with_suffix('.olean'), runtime.with_suffix('.olean'))
            write(folder / 'runtime-reused.json', {'source': str(runtime_cache), 'sha256': digest(runtime_cache),
                                                  'olean_sha256': digest(runtime_cache.with_suffix('.olean'))})
            code = 0
        if code:
            raise RuntimeError('Table runtime failed: ' + str(folder))
        code = run_logged([lean_executable(), '-o', str(lean.with_suffix('.olean').resolve()), str(lean.resolve())],
                          folder / 'model-check', cwd=model.resolve(), env=env, echo=False)
        if code:
            raise RuntimeError('Table model or data validation failed: ' + str(folder))
        request_path = folder / 'request.json'
        write(request_path, request)
        runner = folder / 'Run.lean'
        runner.write_text(f'''import {ir['namespace']}
def main (args : List String) : IO Unit := do
  let [path] := args | throw (IO.userError "Supply request")
  let request ← Chisel2Lean.Functional.unwrap (Lean.Json.parse (← IO.FS.readFile path))
  let circuit ← Chisel2Lean.Functional.unwrap {ir['namespace']}.circuit
  Chisel2Lean.Functional.runRequest circuit request
''', encoding='utf-8')
        code = run_logged([lean_executable(), '--run', str(runner.resolve()), str(request_path.resolve())],
                          folder / 'execution', cwd=model.resolve(), env=env, echo=False)
        if code:
            raise RuntimeError('Table replay failed: ' + str(folder))
        actual = [json.loads(line) for line in (folder / 'execution/stdout.log').read_text(encoding='utf-8').splitlines() if line.strip()]
        assert actual == expected, 'Table trace differs from RTL-checked Lean: ' + str(reference)
        results.append({'reference': str(reference.relative_to(ROOT)), 'steps': len(actual),
                        'nodes': len(ir['nodes']), 'data_bytes': info['binary_bytes'],
                        'reference_sha256': digest(reference_run / 'result.json'),
                        'reference_kind': 'partial-initial-state contract' if reference.name == 'PartialInitial' else 'RTL-checked trace'})
        invalid = [('bad-known-bit', 'Initial state violates known bits')] if reference.name == 'PartialInitial' else [
            ('assert-lean', 'Assertion or assumption failed'), ('assume-lean', 'Assertion or assumption failed')] if reference.name == 'Observed' else []
        for case, message in invalid:
            bad_request = json.loads((reference / case / 'request.json').read_text(encoding='utf-8'))
            path = folder / (case + '.json')
            write(path, bad_request)
            log = folder / case
            code = run_logged([lean_executable(), '--run', str(runner.resolve()), str(path.resolve())],
                              log, cwd=model.resolve(), env=env, echo=False)
            output = (log / 'stdout.log').read_text(encoding='utf-8') + (log / 'stderr.log').read_text(encoding='utf-8')
            assert code != 0 and message in output, (str(reference), case)
            negative_cases.append(str(reference.relative_to(ROOT)) + '/' + case)
        print('PASS table ' + str(reference.relative_to(ROOT)), flush=True)
    report = {'status': 'PASS', 'cases': results,
              'runtime_sha256': digest(ROOT / 'lean/Chisel2Lean/Functional.lean'),
              'negative_cases': negative_cases,
              'scope': 'Compiled, decoded and type-validated Lean table models execute existing RTL-checked traces and the partial-initial-state contract, comparing every output and observation. Invalid known bits, assertions and assumptions are rejected. Not a universal equivalence proof.'}
    write(base / 'summary.json', report)
    write(ROOT / 'docs/validation-yosys-table-7.3.json', report)
    print(json.dumps({'status': 'PASS', 'cases': len(results), 'steps': sum(r['steps'] for r in results)}, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
