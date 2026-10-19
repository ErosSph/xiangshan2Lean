"""F5.1 bounded reset alias assets; Windows conversion, guarded server execution."""
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

import itertools
import json
from pathlib import Path
import random
from fourstate2lean import translate, write, digest
from fourstate_simulate import load
from fourstate_bounded_events import runner_source, validate_trace
from verify_fourstate_clocks import corpus

ROOT = _PROJECT_ROOT


def tap_trace(mapping):
    now = {p['name']: '0' * p['width'] for p in mapping['ports'] if p['direction'] == 'input'}
    trace = [dict(inputs=dict(now))]
    def setone(n, v):
        now[n] = v
        trace.append(dict(inputs=dict(now)))
    def reset():
        setone('clock', '0')
        setone('io_control_jtag_reset', '0')
        setone('io_control_jtag_reset', '1')
        setone('io_control_jtag_reset', '0')
    nexts = {0:(2,5),1:(3,5),2:(2,1),3:(3,0),4:(14,15),5:(12,7),6:(2,1),7:(6,4),
             8:(10,13),9:(11,13),10:(10,9),11:(11,8),12:(12,7),13:(12,7),14:(10,9),15:(12,15)}
    paths = {15: []};todo = [15]
    for state in todo:
        for tms, dest in enumerate(nexts[state]):
            if dest not in paths:
                paths[dest] = paths[state] + [str(tms)];todo.append(dest)
    assert len(paths) == 16
    for state, tms, data in itertools.product(range(16), '01xz', '01xz'):
        reset()
        setone('reset', '0');setone('io_jtag_TDI', data);setone('io_dataChainIn_data', data)
        for choice in paths[state] + [tms]:
            setone('io_jtag_TMS', choice);setone('clock', '1');setone('clock', '0')
    # Every 4-state clock/reset transition, with contexts varied independently.
    for control in ['clock', 'io_control_jtag_reset', 'reset']:
        for ctx in itertools.product('01xz', repeat=2):
            setone('clock', '0');setone('io_jtag_TMS', ctx[0]);setone('io_jtag_TDI', ctx[1])
            for a, b in itertools.product('01xz', repeat=2):setone(control, a);setone(control, b)
    rng = random.Random(510018)
    for _ in range(512):setone(rng.choice(list(now)), rng.choice('01xz'))
    assert len(trace) <= 12000
    return trace


def prepare(source, top, folder):
    from fourstate_elaborated import source_files
    folder = Path(folder);folder.mkdir(parents=True, exist_ok=False)
    clock = 'clock' if top == 'JtagTapController' else 'clk'
    manifest = translate(source, top, folder/'translation', 'sequential', clock,
                         bounded_events=True, immediate_assertions=(top == 'JtagTapController'))
    mapping, model = load(manifest);ir = json.loads(model.read_text())
    trace = tap_trace(mapping) if top == 'JtagTapController' else corpus(mapping)
    initials = [{s['name']: c*s['width'] for s in mapping['states']} for c in '01xz']
    for initial in initials:validate_trace(mapping, trace, initial)
    assets = folder/'assets';assets.mkdir()
    files = {'ports.json': json.dumps(mapping).encode(), 'trace.json': json.dumps(trace).encode(),
             'initials.json': json.dumps(initials).encode(),
             'encoded.sv': (manifest.parent/'encoded.sv').read_bytes(),
             'RunEvents.lean': runner_source(ir, mapping).encode(),
             'model/FourState/Model.lean': model.with_name('Model.lean').read_bytes(),
             'deposit4.c': (ROOT/'verification/fourstate/deposit4.c').read_bytes()}
    originals = []
    for i, p in enumerate(source_files(source)):
        n = 'original-'+str(i)+'.sv';originals.append(n);files[n] = p.read_bytes()
    for n, data in files.items():
        f = assets/n;f.parent.mkdir(parents=True, exist_ok=True);f.write_bytes(data)
    write(assets/'plan.json', dict(top=top, original_sources=originals, compact_bench=True,
          files=[dict(path=n, bytes=len(d), sha256=digest(assets/n)) for n,d in files.items()]))
    write(folder/'prepared.json', dict(manifest=str(manifest), functional_nodes=len(ir['nodes']),
          state_bits=sum(s['width'] for s in mapping['states']), trace_samples=len(trace),
          samples=len(trace)*4, events=mapping['events'], assertions=mapping.get('assertions',[]),
          sources=[dict(path=str(p), sha256=digest(p)) for p in source_files(source)]))
    return assets


if __name__ == '__main__':
    import argparse
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--source',type=Path,required=True);p.add_argument('--top',required=True)
    p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    print(prepare(a.source,a.top,a.out))
