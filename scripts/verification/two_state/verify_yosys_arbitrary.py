"""Check nonzero choices for exposed unknown bits through both transports."""
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
import random

from common import ROOT
from yosys2lean import digest, translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def main():
    folder = ROOT / 'experiments/yosys-arbitrary-7.3'
    folder.mkdir(parents=True, exist_ok=True)
    source = folder / 'Arbitrary.sv'
    source.write_text("module Arbitrary(input [64:0] a, output [64:0] y);\n"
                      "assign y = a ^ 65'bx;\nendmodule\n", encoding='utf-8')
    original = digest(source)
    rng = random.Random(71129)
    choices = [(0, 0), (0, 1 << 64), ((1 << 65) - 1, 1 << 64)]
    choices += [(rng.getrandbits(65), rng.getrandbits(65)) for _ in range(125)]
    models = []
    for transport in ('rtlil', 'json'):
        output = folder / transport
        relative = translate_yosys(source, output, 'Arbitrary', 'Arbitrary.' + transport.capitalize(),
            evidence=folder / (transport + '-translation'), yosys_engine='native',
            yosys_transport=transport, json_io='stream')
        path = output / relative
        ir = json.loads(path.read_text(encoding='utf-8'))
        [arbitrary] = ir['arbitrary_inputs']
        assert arbitrary['width'] == 65
        trace = [{'inputs': {'a': a, arbitrary['name']: value}} for a, value in choices]
        code, actual = simulate_yosys(path, trace, experiment_initial(ir), folder / (transport + '-lean'))
        assert code == 0 and len(actual) == len(choices)
        for row, (a, value) in zip(actual, choices):
            assert row['pre'] == row['post'] == {'y': a ^ value}
        assert digest(source) == original
        models.append({'transport': transport, 'steps': len(choices),
                       'manifest_sha256': digest(output / 'manifest.json')})
    report = {'status': 'PASS', 'original_rtl_sha256': original, 'models': models,
        'scope': 'Actual Lean evaluation of 65 unknown bits as caller-supplied values, including nonzero high bits. Both official bulk RTLIL exposure and JSON cuts match independent XOR arithmetic. This checks two-state completions, not four-state RTL equivalence.'}
    write(folder / 'summary.json', report)
    write(ROOT / 'docs/validation-yosys-arbitrary-7.3.json', report)
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
