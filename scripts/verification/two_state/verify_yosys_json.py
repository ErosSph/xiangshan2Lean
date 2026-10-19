"""Compare streaming netlist edits with the existing checked JSON artifacts."""
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

from common import ROOT
from functional_ir import import_metadata
from yosys2lean import audit_hardware, write
from yosys_json import audit, expose


def main():
    base = ROOT / 'experiments/yosys-stream-json-7.3'
    models = sorted((ROOT / 'experiments/yosys-full-adaptation-7.3').glob('*/model/manifest.json'))
    models += [ROOT / p / 'model/manifest.json' for p in [
        'experiments/yosys-clocks-7.3', 'experiments/xiangshan-sram-7.3/SramArray1P',
        'experiments/xiangshan-sram-7.3/SramArray2P', 'experiments/yosys-effects-7.3/Observed',
        'experiments/yosys-effects-7.3/DisabledCheck', 'experiments/yosys-stdio-7.3',
        'experiments/yosys-contracts/MaskedMemory', 'experiments/yosys-contracts/PartialInitial',
        'experiments/yosys-contracts/ExplicitUnknown']]
    results = []
    for index, path in enumerate(models):
        model = path.parent
        manifest = json.loads(path.read_text(encoding='utf-8'))
        ir = json.loads((model / manifest['ir']).read_text(encoding='utf-8'))
        top = ir['top']
        effects = bool(manifest.get('effects'))
        mode = ir.get('clock_mode', 'single')
        before = json.loads((model / 'before.json').read_text(encoding='utf-8'))['modules'][top]
        clock, hardware, report = audit(model / 'before.json', top, ir['clock'], effects, mode)
        assert report == audit_hardware(before, clock, effects, mode), str(path)
        assert hardware == manifest['hardware'], str(path)
        output = base / str(index) / 'exposed.json'
        output.parent.mkdir(parents=True, exist_ok=True)
        metadata, observations, arbitrary = expose(model / 'unconstrained.json', output, top, effects,
            manifest.get('stdio_compatibility', {}).get('markers', {}))
        expected = json.loads((model / 'exposed.json').read_text(encoding='utf-8'))
        actual = json.loads(output.read_text(encoding='utf-8'))
        assert actual == expected, 'Streaming JSON changed the netlist: ' + str(path)
        assert metadata == import_metadata(expected['modules'][top]), str(path)
        assert arbitrary == manifest['arbitrary_inputs'], str(path)
        # IR attachment adds execution fields; check the originally exposed observation data.
        for new, old in zip(observations, manifest.get('effects', [])):
            for key, value in new.items():
                if key == 'priority_bits' and key not in old:
                    raw = json.loads((model / 'unconstrained.json').read_text(encoding='utf-8'))
                    assert value == raw['modules'][top]['cells'][new['cell']]['parameters']['PRIORITY']
                else:
                    assert old[key] == value, (str(path), key)
        assert len(observations) == len(manifest.get('effects', [])), str(path)
        results.append(str(path.relative_to(ROOT)))
    result = {'status': 'PASS', 'models': results, 'exact_json_models_compared': len(results),
              'scope': 'Every JSON value, wire bit ID, connection, initial constraint and retained cell equals existing RTL-checked artifacts after streaming edits. This checks memory layout changes, not whole-chip or universal equivalence.'}
    write(base / 'summary.json', result)
    write(ROOT / 'docs/validation-yosys-stream-json-7.3.json', result)
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
