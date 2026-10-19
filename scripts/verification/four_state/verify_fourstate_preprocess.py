"""F4.2 official preprocessing boundaries and finite three-way regressions."""
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
import itertools
import json
from pathlib import Path
import sys
import traceback

from common import ROOT, run_logged
from fourstate2lean import digest, fresh_directory, provenance, write
from fourstate_simulate import load, simulate
from verify_fourstate import run_rtl, compare, tools_record

LEVEL_HASH = '8a8f4f473cee700f629101b49d50668c507a90791781929a23cfdac6e975f089'


def converted(source, top, folder, *, defines=(), include_dirs=(), sequential=False):
    folder.mkdir(parents=True)
    command = [sys.executable, '-B', str(ROOT / 'scripts/fourstate2lean.py'), str(source),
               '--top', top, '--out', str(folder / 'converted'),
               '--preprocess-report', str(folder / 'preprocessing.json')]
    if sequential:
        command += ['--mode', 'sequential', '--clock', 'clock']
    for value in defines:
        command += ['-D', value]
    for path in include_dirs:
        command += ['-I', str(path)]
    code = run_logged(command, folder / 'conversion-command', echo=False)
    return code, folder / 'converted/fourstate-manifest.json'


def campaign(folder, level):
    folder = fresh_directory(folder)
    report = dict(status='RUNNING', invocation=[sys.executable, *sys.argv], cases=[],
                  scope='Official preprocessing and finite module/fixture tests; no asynchronous reset implementation, no firtool normalization, no XSTop conversion',
                  execution_location='Windows local, existing pinned tools')
    try:
        report['tools'] = tools_record(folder / 'tools')
        code = run_logged([sys.executable, '-B', '-m', 'unittest', 'discover', '-s', 'tests',
                           '-p', 'test_fourstate_preprocess.py', '-v'], folder / 'unit-tests', echo=False)
        report['unit_tests'] = dict(exit_code=code, log='unit-tests/stderr.log')
        if code:
            raise RuntimeError('Preprocessing unit tests failed')
        if digest(level) != LEVEL_HASH:
            raise ValueError('saved audited LevelGateway SHA256 mismatch')
        inputs = folder / 'inputs'; inputs.mkdir()
        (inputs / 'LevelGateway.sv').write_bytes(level.read_bytes())
        source = inputs / 'LevelGateway.sv'
        report['level_source'] = dict(saved_original=str(level), sha256=digest(source), bytes=source.stat().st_size)
        report['level_attempts'] = []
        for name, defines in [('default', []), ('initial-enabled', ['ENABLE_INITIAL_REG_'])]:
            attempt = folder / ('LevelGateway-' + name)
            code, manifest = converted(source, 'LevelGateway', attempt, defines=defines, sequential=True)
            pp = json.loads((attempt / 'preprocessing.json').read_text(encoding='utf-8'))
            stderr = (attempt / 'conversion-command/stderr.log').read_text(encoding='utf-8')
            expected = 'common direct posedge clock required; asynchronous/derived clocks unsupported' if not defines else 'initial/nonclocked process execution unsupported'
            if code == 0 or pp['status'] != 'PREPROCESSED' or expected not in stderr or manifest.exists():
                raise ValueError('unexpected remaining LevelGateway boundary: ' + stderr)
            report['level_attempts'].append(dict(profile=name, defines=defines, exit_code=code,
                status='EXPECTED_SEMANTIC_REJECTION', preprocessing=pp['status'],
                active_initial_count=pp['active_syntax_counts'].get('InitialBlock', 0),
                diagnostic=stderr.strip().splitlines()[-1], manifest_created=manifest.exists()))
        fixture = ROOT / 'verification/fourstate/preprocess/MacroComb.sv'
        inc = [fixture.parent / 'include']
        trace = [dict(inputs=dict(zip(('s', 'a', 'b'), values))) for values in itertools.product('01xz', repeat=3)]
        for name, defines in [('mux', []), ('xor', ['SELECT_XOR']), ('elsif-a', ['SELECT_A'])]:
            print('Three-way preprocessing', name, flush=True)
            case = folder / ('MacroComb-' + name)
            code, manifest = converted(fixture, 'MacroComb', case, defines=defines, include_dirs=inc)
            if code:
                raise RuntimeError('MacroComb conversion failed: ' + name)
            mapping, _ = load(manifest)
            original = run_rtl(fixture, mapping, trace, case / 'original', defines=defines, include_dirs=inc)
            encoded = run_rtl(manifest.parent / 'encoded.sv', mapping, trace, case / 'encoded', True)
            lean = simulate(manifest, trace, case / 'lean')
            checks = compare(mapping, original, encoded, [r['outputs'] for r in lean])
            write(case / 'trace.json', trace)
            result = dict(top='MacroComb', profile=name, defines=defines, include_dirs=[str(p) for p in inc],
                          status='THREE_WAY_PASS', samples=len(trace), output_bit_positions=checks,
                          source_sha256=digest(fixture), manifest_sha256=digest(manifest))
            write(case / 'result.json', result); report['cases'].append(result)
        from verify_fourstate_sequential import run_rtl as run_seq, compare as compare_seq
        fixture = ROOT / 'verification/fourstate/blockers/MacroGuard.sv'
        case = folder / 'MacroGuard-default'
        code, manifest = converted(fixture, 'MacroGuard', case, sequential=True)
        if code:
            raise RuntimeError('MacroGuard inactive-initial conversion failed')
        mapping, _ = load(manifest)
        trace = [dict(inputs=dict(clock=clock, d=data)) for data in '01xz01xz' for clock in '0110']
        initial = {p['name']: 'x' * p['width'] for p in mapping['states']}
        original = run_seq(fixture, mapping, trace, initial, case / 'original')
        encoded = run_seq(manifest.parent / 'encoded.sv', mapping, trace, initial, case / 'encoded', True)
        lean = simulate(manifest, trace, case / 'lean', initial)
        compare_seq(original, encoded, lean)
        write(case / 'trace.json', trace); write(case / 'initial.json', initial)
        result = dict(top='MacroGuard', status='THREE_WAY_PASS', samples=len(trace),
                      initial=initial, state_bits=1, rising_edges=sum(r['rising'] for r in original),
                      source_sha256=digest(fixture), manifest_sha256=digest(manifest))
        write(case / 'result.json', result); report['cases'].append(result)
        report['source_snapshot_sha256'] = provenance(folder)
        report['status'] = 'PREPROCESS_THREE_WAY_PASS'
    except Exception:
        report.update(status='FAIL', error=traceback.format_exc())
    write(folder / 'summary.json', report)
    return report


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--level-source', required=True, type=Path)
    p.add_argument('--out', required=True, type=Path)
    args = p.parse_args()
    result = campaign(args.out.resolve(), args.level_source.resolve())
    print(json.dumps(dict(status=result['status'], error=result.get('error'))))
    return 0 if result['status'] == 'PREPROCESS_THREE_WAY_PASS' else 1


if __name__ == '__main__':
    raise SystemExit(main())
