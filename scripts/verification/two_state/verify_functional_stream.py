"""Compare streamed imports with checked models, including exact Lean source."""
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


import copy
import json

from common import ROOT
from functional_ir import emit_lean, import_functional, import_functional_file, import_metadata
from yosys_effects import attach_effects
from yosys2lean import digest, write, write_ir


def main():
    base = ROOT / 'experiments/functional-stream-7.3'
    base.mkdir(parents=True, exist_ok=True)
    folders = ['yosys-full-adaptation-7.3', 'yosys-clocks-7.3', 'xiangshan-sram-7.3',
               'yosys-effects-7.3', 'yosys-contracts', 'xiangshan-layers-7.3',
               'yosys-native-7.3', 'yosys-exposure-7.3', 'yosys-chunks-7.3']
    paths = sorted({p for folder in folders for p in (ROOT / 'experiments' / folder).rglob('model/manifest.json')})
    checked = []
    for serial, path in enumerate(paths):
        model = path.parent
        manifest = json.loads(path.read_text(encoding='utf-8'))
        original = json.loads((model / manifest['ir']).read_text(encoding='utf-8'))
        module = json.loads((model / 'exposed.json').read_text(encoding='utf-8'))['modules'][original['top']]
        metadata = import_metadata(module)
        ordinary = import_functional((model / 'functional.smt2').read_text(encoding='utf-8'), metadata,
                                     original['namespace'], original['clock'])
        streamed = import_functional_file(model / 'functional.smt2', metadata,
                                         original['namespace'], original['clock'])
        assert ordinary == streamed, 'Streamed FunctionalIR differs: ' + str(path)
        packed = import_functional_file(model / 'functional.smt2', metadata,
                                       original['namespace'], original['clock'], compact_nodes=True)
        assert packed == ordinary, 'Packed typed nodes differ: ' + str(path)
        packed_json = base / (str(serial) + '.ir.json')
        write_ir(packed_json, packed)
        assert json.loads(packed_json.read_text(encoding='utf-8')) == ordinary, str(path)
        streamed = packed
        attach_effects(streamed, copy.deepcopy(manifest.get('effects', [])))
        for field in ('inputs', 'outputs', 'states', 'nodes'):
            assert streamed[field] == original[field], (str(path), field)
        for key in ('lean_record_group_size', 'lean_field_paths'):
            if key in original:
                streamed[key] = original[key]
        legacy = emit_lean(streamed, bounded_shifts=False)
        assert legacy == (model / manifest['lean']).read_text(encoding='utf-8'), str(path)
        checked.append({'manifest': str(path.relative_to(ROOT)), 'nodes': len(streamed['nodes']),
                        'manifest_sha256': digest(path), 'packed_node_column_bytes': packed['nodes'].storage_bytes()})
        print('PASS ' + str(path.relative_to(ROOT)), flush=True)
    # Rejection is part of the format contract, including the ignored init tail.
    reference = paths[0].parent / 'functional.smt2'
    text = reference.read_text(encoding='utf-8')
    rejected = []
    for name, malformed in [('unclosed tail', text + '\n(assert ('),
                            ('extra closing parenthesis', text + '\n)'),
                            ('quoted atom', text + '\n(assert "unexpected")')]:
        damaged = base / (name.replace(' ', '-') + '.smt2')
        damaged.write_text(malformed, encoding='utf-8')
        try:
            import_functional_file(damaged, metadata, original['namespace'], original['clock'])
        except ValueError:
            rejected.append(name)
        else:
            raise AssertionError('Malformed stream accepted: ' + name)
    report = {'status': 'PASS', 'models_compared': len(checked), 'models': checked,
              'rejected': rejected, 'reader_sha256': digest(ROOT / 'scripts/functional_stream.py'),
              'scope': 'Streaming and packed-node imports, serialized IR values and generated Lean source all equal the checked artifacts, including initial constraints and line locations. No initial SMT assertion is treated as hardware initialization.'}
    write(base / 'summary.json', report)
    write(ROOT / 'docs/validation-functional-stream-7.3.json', report)
    print(json.dumps({key: report[key] for key in ('status', 'models_compared', 'rejected')}, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
