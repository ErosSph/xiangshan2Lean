"""Check the explicit-state hardware profile against normal CIRCT reset initialization."""
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

from common import ROOT, FIRTOOL_VERSION, run_logged
from rtl import run_emitted_rtl
from yosys2lean import digest, translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def main():
    folder = ROOT / 'experiments/circt-initialization-7.3'
    folder.mkdir(parents=True, exist_ok=True)
    source = folder / 'ResetProbe.fir'
    source.write_text('''FIRRTL version 6.0.0
circuit ResetProbe :
  public module ResetProbe :
    input clock : Clock
    input reset : AsyncReset
    input d : UInt<8>
    output q : UInt<8>
    regreset r : UInt<8>, clock, reset, UInt<8>(0ha7)
    connect r, d
    connect q, r
''', encoding='utf-8')
    firtool = ROOT / '.tools' / ('firtool-' + FIRTOOL_VERSION) / ('firtool-' + FIRTOOL_VERSION) / 'bin/firtool.exe'
    for name, flags in [('original', []), ('explicit-state', ['--disable-all-randomization'])]:
        output = folder / name
        output.mkdir(exist_ok=True)
        assert run_logged([str(firtool), str(source), '--split-verilog', '-o=' + str(output), *flags],
                          folder / (name + '-firtool'), echo=False) == 0
    try:
        translate_yosys(folder / 'original/ResetProbe.sv', folder / 'rejected-model', 'ResetProbe',
                        'Initialization.Rejected', evidence=folder / 'rejected-translation', clock_mode='global')
    except RuntimeError as error:
        logs = list((folder / 'rejected-translation').glob('*/yosys-prepare/stderr.log'))
        assert logs and 'reading net state during design initialization unsupported' in logs[-1].read_text(encoding='utf-8'), str(error)
    else:
        raise AssertionError('Input-dependent initial code should require an explicit initialization contract')
    relative = translate_yosys(folder / 'explicit-state/ResetProbe.sv', folder / 'model', 'ResetProbe',
                               'Initialization.Hardware', evidence=folder / 'translation', clock_mode='global')
    path = folder / 'model' / relative
    ir = json.loads(path.read_text(encoding='utf-8'))
    metadata = {'top': 'ResetProbe', 'clocked': False, 'rtl_sources': ['ResetProbe.sv'],
                'ports': [{'name': n, 'rtl_name': n, 'width': w, 'direction': 'output' if n == 'q' else 'input'}
                          for n, w in [('clock', 1), ('reset', 1), ('d', 8), ('q', 8)]]}
    results = []
    for initially_asserted in (0, 1):
        rows = [{'inputs': {'clock': 0, 'reset': initially_asserted, 'd': 11}},
                {'inputs': {'clock': 0, 'reset': 0, 'd': 11}}]
        for cycle in range(32):
            reset = int(cycle % 11 == 7)
            values = {'clock': 0, 'reset': reset, 'd': (cycle * 17 + 9) % 256}
            rows += [{'inputs': dict(values)}, {'inputs': dict(values)},
                     {'inputs': {**values, 'clock': 1}}, {'inputs': {**values, 'clock': 1}}]
        lean_rows = [{'inputs': {**r['inputs'], **{p['name']: 0 for p in ir['arbitrary_inputs']}}} for r in rows]
        code, actual = simulate_yosys(path, lean_rows, experiment_initial(ir), folder / f'lean-{initially_asserted}')
        assert code == 0
        reference = []
        for name in ('original', 'explicit-state'):
            code, native = run_emitted_rtl(folder / name, metadata, rows, folder / f'{name}-reference-{initially_asserted}')
            assert code == 0, (name, code)
            reference.append(native)
        expected = []
        q = previous_clock = previous_reset = 0
        for row in rows:
            i = row['inputs']
            if i['reset'] and (not previous_reset or not expected):
                q = 0xa7
            elif i['clock'] and not previous_clock:
                q = 0xa7 if i['reset'] else i['d']
            expected.append({'q': q})
            previous_clock, previous_reset = i['clock'], i['reset']
        first_edge = next(index for index, row in enumerate(rows) if row['inputs']['clock'])
        time_zero_differences = []
        for index, (a, b, c, spec) in enumerate(zip(actual, *reference, expected)):
            # The oracle is the original/default RTL, including its reset-at-t0
            # initializer. clk2fflogic's level reset preserves that behavior.
            assert a['post'] == b['post'] == spec, (initially_asserted, index, a, b, spec)
            if c['post'] != b['post']:
                assert index < first_edge, (initially_asserted, index, c, b)
                time_zero_differences.append(index)
        results.append({'initial_reset': initially_asserted, 'steps': len(rows), 'status': 'PASS',
                        'randomization_disabled_rtl_time_zero_difference_steps': time_zero_differences})
    report = {'status': 'PASS', 'cases': results, 'source_sha256': digest(source),
              'profile': 'Official firtool --disable-all-randomization; explicit caller-supplied unknown initial state, reset behavior retained.',
              'time_zero_contract': 'Removing CIRCT initializers can change the emitted RTL before its first clock/reset event when reset starts high. The Lean model uses official clk2fflogic level reset semantics and is checked against the original/default RTL at EVERY sampling step. Randomization-disabled RTL is additionally compared after the first active clock edge.',
              'scope': 'Nonzero asynchronous reset value; reset initially high or low, assertion without clock, and stable release. Actual Lean compared with original/default CIRCT RTL plus integer model at every step. No claim of reproducing randomized power-on simulation or a universal initialization equivalence theorem.'}
    write(folder / 'summary.json', report)
    write(ROOT / 'docs/validation-circt-initialization-7.3.json', report)
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
