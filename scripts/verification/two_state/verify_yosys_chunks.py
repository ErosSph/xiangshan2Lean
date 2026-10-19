"""Validate bounded Lean emission using previous RTL oracles and a larger fresh circuit."""
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
import random

from common import ROOT, lean_executable, run_logged
from functional_ir import emit_lean
from rtl import run_emitted_rtl
from yosys2lean import digest, translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--small-only', action='store_true')
    args = parser.parse_args()
    base = ROOT / 'experiments/yosys-chunks-7.3'
    sources = [('Clocks', ROOT / 'experiments/yosys-clocks-7.3', 'lean'),
               ('MaskedMemory', ROOT / 'experiments/yosys-contracts/MaskedMemory', 'lean'),
               ('Observed', ROOT / 'experiments/yosys-effects-7.3/Observed', 'valid-lean'),
               ('DisabledCheck', ROOT / 'experiments/yosys-effects-7.3/DisabledCheck', 'lean')]
    results = []
    for name, old, executor in sources:
        manifest = json.loads((old / 'model/manifest.json').read_text(encoding='utf-8'))
        ir = json.loads((old / 'model' / manifest['ir']).read_text(encoding='utf-8'))
        folder = base / name
        path = folder / 'model' / manifest['ir']
        write(path, ir)
        lean = folder / 'model' / manifest['lean']
        lean.write_text(emit_lean(ir, chunk_size=8), encoding='utf-8')
        if run_logged([lean_executable(), '-o', str(lean.with_suffix('.olean')), str(lean)], folder / 'check', echo=False):
            raise RuntimeError('Forced chunk model did not compile: ' + name)
        request = json.loads((old / executor / 'request.json').read_text(encoding='utf-8'))
        rows = [{'inputs': {n: v for n, v in row['inputs'].items() if n != ir['clock']}} for row in request['trace']]
        code, actual = simulate_yosys(path, rows, request['initial'], folder / 'lean')
        expected = json.loads((old / executor / 'result.json').read_text(encoding='utf-8'))
        assert code == 0 and actual == expected, name
        results.append({'case': name, 'status': 'PASS', 'steps': len(rows), 'chunk_size': 8,
                        'reference': str(old / executor / 'result.json'), 'source_manifest_sha256': digest(old / 'model/manifest.json')})
        print('PASS forced chunks: ' + name, flush=True)
    if not args.small_only:
        folder = base / 'Large'
        folder.mkdir(parents=True, exist_ok=True)
        source = folder / 'Large.sv'
        source.write_text('''module Large(input clock, reset, en, input [15:0] d, output [8191:0] q);
for(genvar i=0;i<512;i++) begin: lane
  reg [15:0] value=0;
  always @(posedge clock) if(reset) value<=0;
    else if(en) value<=((value+d+i) ^ (value<<1));
  assign q[i*16+:16]=value;
end
endmodule
''', encoding='utf-8')
        relative = translate_yosys(source, folder / 'model', 'Large', 'Chunks.Large', evidence=folder / 'translation')
        path = folder / 'model' / relative
        ir = json.loads(path.read_text(encoding='utf-8'))
        assert len(ir['nodes']) > 8192, 'Scale circuit did not exercise automatic chunking'
        assert 'C2LChunk' in (folder / 'model/Chunks/Large.lean').read_text(encoding='utf-8')
        rng = random.Random(730531)
        rows = [{'inputs': {'reset': int(i % 17 == 0), 'en': rng.randrange(2), 'd': rng.randrange(65536)}} for i in range(64)]
        lean_rows = [{'inputs': {**r['inputs'], **{p['name']: 0 for p in ir['arbitrary_inputs']}}} for r in rows]
        code, actual = simulate_yosys(path, lean_rows, experiment_initial(ir), folder / 'lean')
        assert code == 0, 'Large generated Lean did not execute'
        widths = {'clock': 1, 'reset': 1, 'en': 1, 'd': 16, 'q': 8192}
        metadata = {'top': 'Large', 'clocked': True, 'rtl_sources': ['Large.sv'],
                    'ports': [{'name': n, 'rtl_name': n, 'width': w, 'direction': 'output' if n == 'q' else 'input'}
                              for n, w in widths.items()]}
        native_rows = [{'reset': r['inputs']['reset'], 'inputs': {n: v for n, v in r['inputs'].items() if n != 'reset'}} for r in rows]
        code, native = run_emitted_rtl(folder, metadata, native_rows, folder / 'reference')
        assert code == 0, 'Large RTL reference failed'
        state = [0] * 512
        def packed():
            return sum(value << (i * 16) for i, value in enumerate(state))
        for index, (row, a, b) in enumerate(zip(rows, actual, native)):
            assert a['pre'] == b['pre'] == {'q': packed()}, index
            i = row['inputs']
            if i['reset']:
                state = [0] * 512
            elif i['en']:
                state = [((value + i['d'] + lane) ^ (value << 1)) % 65536 for lane, value in enumerate(state)]
            assert a['post'] == b['post'] == {'q': packed()}, index
        results.append({'case': 'Large', 'status': 'PASS', 'nodes': len(ir['nodes']), 'state_fields': len(ir['states']),
                        'cycles': len(rows), 'output_bits': 8192, 'output_comparisons': len(rows) * 2,
                        'scope': 'Fresh 512-lane stateful RTL; actual Lean, Verilator and integer comparison.'})
    report = {'status': 'PASS', 'complete_suite': not args.small_only, 'cases': results,
              'emitter_sha256': digest(ROOT / 'scripts/lean_chunks.py'),
              'scope': 'Chunk cuts preserve values and domain predicates. Small cases replay prior RTL-checked traces; scale case uses a fresh RTL reference. No claim of whole-XiangShan capacity or universal equivalence.'}
    write(base / 'summary.json', report)
    if not args.small_only:
        write(ROOT / 'docs/validation-yosys-chunks-7.3.json', report)
    print(json.dumps(report, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
