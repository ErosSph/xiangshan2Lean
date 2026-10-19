"""Re-run RTL-checked clock, memory and observation traces with native Yosys."""
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
import json
from pathlib import Path

from bootstrap_native_yosys import load_lock
from common import ROOT
from yosys2lean import digest, translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def observations(rows, ir):
    """Generated cell IDs may change; compare every observation by meaning."""
    identities = {}
    for effect in ir.get('effects', []):
        source = effect['source'].removeprefix('work/').removeprefix('./')
        identities[effect['index']] = {key: effect[key] for key in
            ('kind', 'format', 'argument_width', 'stream', 'file_descriptor') if key in effect}
        identities[effect['index']]['source'] = source
    result = []
    for row in rows:
        item = dict(row)
        for phase in ('effects_pre', 'effects_post'):
            if phase in item:
                values = [{**{k: v for k, v in event.items() if k != 'index'},
                           'identity': identities[event['index']]} for event in item[phase]]
                item[phase] = sorted(values, key=lambda value: json.dumps(value, sort_keys=True))
        result.append(item)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--json-io', choices=['auto', 'stream', 'memory'], default='auto')
    args = parser.parse_args()
    base = ROOT / 'experiments/yosys-native-7.3'
    cases = [('Clocks', 'experiments/yosys-clocks-7.3'),
             ('MaskedMemory', 'experiments/yosys-contracts/MaskedMemory'),
             ('Stdio', 'experiments/yosys-stdio-7.3')]
    results = []
    for name, reference in cases:
        old = ROOT / reference
        manifest = json.loads((old / 'model/manifest.json').read_text(encoding='utf-8'))
        previous_ir = json.loads((old / 'model' / manifest['ir']).read_text(encoding='utf-8'))
        request = json.loads((old / 'lean/request.json').read_text(encoding='utf-8'))
        expected = json.loads((old / 'lean/result.json').read_text(encoding='utf-8'))
        folder = base / name
        relative = translate_yosys(Path(manifest['source']), folder / 'model', previous_ir['top'],
            'Native.' + name, evidence=folder / 'translation',
            preserve_effects=bool(manifest.get('effects')), clock_mode=previous_ir.get('clock_mode', 'single'),
            keep_hierarchy=True, stdio_compat=bool(manifest.get('stdio_compatibility', {}).get('markers')),
            yosys_engine='native', json_io=args.json_io)
        path = folder / 'model' / relative
        ir = json.loads(path.read_text(encoding='utf-8'))
        rows = []
        for row in request['trace']:
            inputs = {n: v for n, v in row['inputs'].items() if not n.startswith('c2l_undefined_')
                      and (ir.get('clock_mode') == 'global' or n != ir['clock'])}
            inputs.update({p['name']: 0 for p in ir['arbitrary_inputs']})
            rows.append({'inputs': inputs})
        code, actual = simulate_yosys(path, rows, experiment_initial(ir), folder / 'lean')
        if code or len(actual) != len(expected) or observations(actual, ir) != observations(expected, previous_ir):
            raise AssertionError('Native Lean trace differs from independently RTL-checked reference: ' + name)
        results.append({'case': name, 'status': 'PASS', 'steps': len(rows),
                        'reference_sha256': digest(old / 'lean/result.json'),
                        'model_manifest_sha256': digest(folder / 'model/manifest.json')})
        print('PASS native Yosys: ' + name, flush=True)
    lock = load_lock()
    report = {'status': 'PASS', 'yosys_version': lock['yosys_version'],
              'json_io': args.json_io,
              'archive_sha256': lock['archive_sha256'], 'cases': results,
              'scope': 'Actual native-Yosys-generated Lean replays independently RTL-checked traces. Outputs compare exactly; observations compare kind, source, format, stream, predicates and argument values with local generated IDs normalized. Fixed initial and arbitrary-input choices; no full-chip or universal equivalence claim.'}
    write(base / 'summary.json', report)
    write(ROOT / 'docs/validation-yosys-native-7.3.json', report)
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
