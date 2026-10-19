"""F1.3: compiled isolated prefetch RTL faults, using the F1.1/F1.2 framework."""
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
import datetime as dt
import difflib
import json
import os
from pathlib import Path
import re
import shutil
import sys
import traceback
import uuid

from common import ROOT, run_logged
from fourstate2lean import digest, fresh_directory, provenance, write
from fourstate_simulate import load
from verify_fourstate import tools_record
from verify_fourstate_prefetch_smoke import (
    SmokeFailure, compare_all, protected_files, read, require, unchanged,
)
from verify_fourstate_sequential import run_rtl

FIXTURE = ROOT / 'verification/fourstate/xiangshan-prefetch-faults.json'
DRIVER = Path(__file__).resolve()


def relative(path, folder):
    return Path(os.path.relpath(path, folder)).as_posix()


def verify_report(path, status):
    report = read(path)
    require(report['status'] == status and report['invocation_exit_code'] == 0,
            'Prerequisite report did not pass', report=str(path))
    checked = {}
    for key in ('artifact_sha256', 'external_artifact_sha256'):
        for name, expected in report.get(key, {}).items():
            source = (path.parent / name).resolve()
            require(source.is_file() and digest(source) == expected,
                    'Prerequisite asset hash mismatch', path=str(source))
            checked[source.relative_to(ROOT).as_posix()] = expected
    checked[path.relative_to(ROOT).as_posix()] = digest(path)
    return report, checked


def compare_job(job_path):
    """Expose the unchanged exact comparator as a logged process with distinct exits."""
    job = read(job_path)
    try:
        fixture = read(job['base_fixture'])
        case = read(job['case'])
        fixture = {**fixture, 'cycles': case['cycles'], 'initial': case['initial']}
        trace = [json.loads(row) for row in Path(job['trace']).read_text(encoding='utf-8').splitlines()]
        result = compare_all(job_path.parent, fixture, trace, read(job['plan']),
                             read(job['reference']), read(job['encoded']), read(job['lean']))
        result = {'status': 'MATCH', 'exit_code': 0, 'first_difference': None, 'comparison': result}
        code = 0
    except SmokeFailure as exc:
        mismatch = exc.detail.get('kind') == 'three_way_mismatch'
        code = 2 if mismatch else 1
        result = {'status': 'MISMATCH' if mismatch else 'ERROR', 'exit_code': code,
                  'first_difference': exc.detail}
    except Exception:
        code = 1
        result = {'status': 'ERROR', 'exit_code': code, 'error': traceback.format_exc()}
    write(job_path.parent/'comparison-result.json', result)
    print(json.dumps(result, ensure_ascii=False, indent=2), flush=True)
    return code


def compare_process(folder, base, case, encoded):
    folder.mkdir(parents=True)
    job = {'base_fixture': str(ROOT/base), 'case': str(case/'case.json'),
           'trace': str(case/'trace.jsonl'), 'plan': str(case/'sampling-plan.json'),
           'reference': str(case/'reference-run/result.json'),
           'encoded': str(encoded), 'lean': str(case/'lean/fourstate-result.json')}
    write(folder/'job.json', job)
    code = run_logged([sys.executable, '-B', str(DRIVER), '--compare', str(folder/'job.json')],
                      folder/'command', echo=False)
    result = read(folder/'comparison-result.json')
    require(result['exit_code'] == code, 'Comparator process exit disagrees with result')
    return result


def mutate(source, folder, spec, mapping):
    entries = mapping['states'] if spec['category'] == 'state' else mapping['ports']
    matches = [p for p in entries if p['name'] == spec['target']]
    require(len(matches) == 1, 'Fault mapping target is ambiguous', fault=spec['id'])
    port = matches[0]; rail = port[spec['rail']]
    text = source.read_bytes().decode('utf-8')
    pattern = re.compile(r'^assign ' + re.escape(rail) + r' = ([^;\r\n]+);(?=\r?$)', re.MULTILINE)
    found = list(pattern.finditer(text))
    require(len(found) == 1, 'Fault assignment must be unique', rail=rail)
    match = found[0]
    mask = port['tag'] if spec['operation'] == 'xor-tag' else str(port['width']) + "'d1"
    replacement = 'assign ' + rail + ' = (' + match[1] + ') ^ ' + mask + ';'
    mutant = text[:match.start()] + replacement + text[match.end():]
    folder.mkdir(parents=True)
    before = folder/'original-encoded.sv'; after = folder/'mutated-encoded.sv'
    shutil.copyfile(source, before); after.write_bytes(mutant.encode('utf-8'))
    require(digest(before) == digest(source) and digest(before) != digest(after), 'Mutation did not change isolated source')
    (folder/'mutation.diff').write_text(''.join(difflib.unified_diff(text.splitlines(True), mutant.splitlines(True),
        fromfile='original-encoded.sv', tofile='mutated-encoded.sv')), encoding='utf-8')
    result = {'id': spec['id'], 'source': str(source), 'target': spec['target'], 'mapped_rail': rail,
              'line': text.count('\n', 0, match.start())+1, 'before': match[0], 'after': replacement,
              'original_sha256': digest(before), 'mutant_sha256': digest(after),
              'mapping_entry': port, 'changed_assignments': 1}
    write(folder/'mutation.json', result)
    return after, result


def causality(folder, spec, case, reference, encoded, lean, raw, mapping, first):
    """Targeted injection guards; differential acceptance remains compare_all's job."""
    require(all(first.get(k) == v for k, v in spec['expected_first'].items()),
            'Unexpected first difference', expected=spec['expected_first'], actual=first)
    require(reference[0]['pre']['states'] == encoded[0]['pre']['states'] ==
            lean[0]['pre']['states'] == read(case/'initial.json'), 'Initial state changed')
    require(digest(folder/'encoded/tb.sv') == digest(case/'encoded/tb.sv'),
            'Mutant bench differs from baseline sampling/initialization')
    category = spec['category']; target = spec['target']
    affected = 0; output_positions_unchanged = 0
    for a, b, c in zip(reference, encoded, lean):
        for phase in ('pre', 'post'):
            if category == 'state':
                require(a[phase]['outputs'] == b[phase]['outputs'] == c[phase]['outputs'],
                        'State fault must remain invisible to outputs', sample=a['sample'], phase=phase)
                output_positions_unchanged += 28
            else:
                require(a[phase]['states'] == b[phase]['states'] == c[phase]['states'],
                        'Output-only fault changed register states')
            group = 'states' if category == 'state' else 'outputs'
            for name, value in a[phase][group].items():
                other = b[phase][group][name]
                require(value == c[phase][group][name], 'Correct paths disagree')
                if name != target:
                    require(value == other, 'Unexpected non-target change', name=name)
                    continue
                if category == 'xz':
                    require(other == value.translate(str.maketrans('xz', 'zx')), 'Fault is not an exact X/Z swap')
                elif category == 'output':
                    require(value in ('0', '1') and other == str(1-int(value)), 'Output fault did not flip known bit')
                else:
                    require(value[:-1] == other[:-1] and value[-1] in '01' and other[-1] in '01',
                            'State fault escaped bit zero')
                affected += sum(x != y for x, y in zip(value, other))
    require(affected > 0, 'Mutation never triggered')
    sample = first['sample']; phase = first['phase']
    row = {'fault': spec['id'], 'case': spec['case'], 'status': 'TRIGGERED', 'first_difference': first,
           'initial_state_exact': True, 'bench_identical': True, 'affected_target_bit_positions': affected,
           'all_output_bit_positions_unchanged': output_positions_unchanged,
           'inputs': json.loads((case/'trace.jsonl').read_text().splitlines()[sample])['inputs'],
           'observed': {'reference': reference[sample], 'encoded': encoded[sample], 'lean': lean[sample]}}
    if category == 'state':
        require(reference[sample]['rising'] and phase == 'post', 'State difference was not after an edge')
        require(reference[sample]['pre']['states'][target] == reference[sample]['post']['states'][target],
                'Baseline target was not holding')
        require(reference[sample]['pre']['states']['L2TlbPrefetch.old_v_2'] == '0', 'History slot was not invalid')
        row['state_witness'] = {'baseline_holds': True, 'slot_valid': '0', 'output_match_entire_trajectory': True}
    if category == 'xz':
        require(all(set(v) <= set('01') for v in read(case/'initial.json').values()),
                'Reachable unknown case must start entirely known')
        require(reference[sample]['rising'] and phase == 'post' and
                row['inputs']['io_in_valid'] == '1' and row['inputs']['io_in_bits_vpn'][0] == 'x',
                'Unknown VPN input did not trigger the state update')
        require(reference[sample]['pre']['states']['L2TlbPrefetch.next_req'] == '000000000000000000000011000' and
                reference[sample]['post']['states']['L2TlbPrefetch.next_req'] == 'x'*24+'000' and
                reference[sample]['post']['outputs']['io_out_valid'] == '1', 'Unknown result was not reached as expected')
        port = next(p for p in mapping['ports'] if p['name'] == target)
        bits = raw[2*sample+(phase == 'post')]['outputs']
        original_raw = read(case/'encoded/encoded-result.json')[2*sample+(phase == 'post')]['outputs']
        mask = 1 << first['bit']
        pairs = {'baseline': [int(bool(original_raw[p] & mask)) for p in (port['tag'], port['value'])],
                 'mutant': [int(bool(bits[p] & mask)) for p in (port['tag'], port['value'])]}
        require(pairs == {'baseline': [1, 0], 'mutant': [1, 1]}, 'Physical rails did not encode X to Z')
        row['xz_witness'] = {'known_initial_state': True, 'reachable_by_input_and_edge': True,
                             'bit': first['bit'], 'tag_value_pairs': pairs, 'known_values_preserved': True}
    write(folder/'trigger-evidence.json', row)
    return row


def campaign(folder, baseline_report=None):
    report = {'task': 'F1.3', 'status': 'RUNNING', 'faults': [], 'first_failure': None,
              'scope': 'Specified compiled fault detection only, official disallowLocalVariables MinimalConfig(1)/NanhuCoreConfig RTL; no default RTL equivalence or whole-core claim.'}
    write(folder/'summary.json', report)
    stage = 'prerequisites'; before = None
    try:
        fixture = read(FIXTURE); directed = read(ROOT/fixture['directed_fixture'])
        prior = ROOT/fixture['f12_root']/'summary.json'
        require(digest(prior) == fixture['f12_summary_sha256'], 'F1.2 report hash mismatch')
        old, historical = verify_report(prior, 'DIRECTED_PASS')
        require(old['coverage']['hit'] == old['coverage']['required'] == 54, 'Prior coverage incomplete')
        source_checks = {n: h for n, h in old['source_snapshot_sha256'].items()
                         if n.startswith('scripts/') or n.startswith('verification/fourstate/')}
        require(not unchanged(source_checks), 'Existing F1.2 framework or fixture changed')
        before = {**protected_files(folder), **historical, **source_checks}
        write(folder/'protected-before.json', before)
        report['prerequisites'] = {'f12_report': str(prior), 'sha256': digest(prior),
                                  'artifacts_checked': len(historical), 'framework_files_checked': len(source_checks)}
        report['source_snapshot_sha256'] = provenance(folder)
        report['tools'] = tools_record(folder/'tools')
        stage = 'fresh-f12-f11-and-existing-regressions'
        if baseline_report is None:
            root = ROOT/'experiments/fourstate'/('pf-d-'+folder.name[-8:])
            require(not root.exists(), 'Fresh directed evidence root already exists')
            print('Rerunning F1.2 including F1.1, seven regression batches and v4 replay', flush=True)
            code = run_logged([sys.executable, '-B', str(ROOT/'scripts/verification/four_state/verify_fourstate_prefetch_directed.py'),
                               '--evidence', str(root)], folder/'f12-command', echo=False)
            require(code == 0, 'Fresh F1.2/regressions failed', exit_code=code)
            reports = list(root.glob('*/summary.json'))
            require(len(reports) == 1, 'Fresh directed report is ambiguous')
        else:
            require(baseline_report.is_relative_to((ROOT/'experiments/fourstate').resolve()),
                    'Reused baseline must be a local four-state report')
            reports = [baseline_report]; code = read(baseline_report)['invocation_exit_code']
            print('Reusing completed F1.2/regressions after verifying every asset:', baseline_report, flush=True)
        fresh, baseline_hashes = verify_report(reports[0], 'DIRECTED_PASS')
        require(fresh['coverage']['hit'] == fresh['coverage']['required'] == 54 and
                fresh['totals']['samples'] == 255 and fresh['f11_regression']['status'] == 'SMOKE_PASS',
                'Fresh regression acceptance mismatch')
        report['regression'] = {'report': relative(reports[0], folder), 'sha256': digest(reports[0]),
            'exit_code': code, 'status': fresh['status'], 'totals': fresh['totals'],
            'execution': 'reused-completed-run' if baseline_report else 'executed-this-invocation',
            'command_evidence': relative(reports[0].parent/'invocation', folder),
            'coverage': {k: fresh['coverage'][k] for k in ('required', 'hit', 'missing')},
            'f11': fresh['f11_regression'], 'existing_batches': fresh['regressions']}
        before.update(baseline_hashes)
        write(folder/'protected-before.json', before)
        base_folder = reports[0].parent
        manifest = base_folder/'convert/fourstate-manifest.json'
        mapping, _ = load(manifest)
        report['reference_contract'] = fresh['reference_contract']
        report['input_sha256'] = {'reference': digest(base_folder/'reference/Chisel2LeanReference.v'),
            'encoded': digest(manifest.parent/'encoded.sv'), 'manifest': digest(manifest),
            'mapping': digest(manifest.parent/'ports.json')}
        cases = {read(p/'case.json')['id']: p for p in (base_folder/'cases').iterdir() if p.is_dir()}
        baseline_results = {}
        for spec in fixture['faults']:
            stage = 'fault-'+spec['id']; print('Injecting and executing', spec['id'], flush=True)
            case = cases[spec['case']]
            if spec['case'] not in baseline_results:
                result = compare_process(folder/'baseline-compare'/case.name, directed['base_fixture'], case, case/'encoded/result.json')
                require(result['exit_code'] == 0 and result['status'] == 'MATCH', 'Unmodified baseline mismatch')
                baseline_results[spec['case']] = result
            fault = folder/'faults'/spec['id']
            source, mutation = mutate(manifest.parent/'encoded.sv', fault, spec, mapping)
            trace = [json.loads(row) for row in (case/'trace.jsonl').read_text().splitlines()]
            initial = read(case/'initial.json')
            encoded = run_rtl(source, mapping, trace, initial, fault/'encoded', True)
            # Preserve exact correct-path raw results alongside each actual mutant run.
            for name in ('case.json', 'initial.json', 'trace.jsonl', 'sampling-plan.json'):
                shutil.copyfile(case/name, fault/name)
            for name in ('reference-run', 'lean'):
                shutil.copytree(case/name, fault/name)
            result = compare_process(fault/'compare', directed['base_fixture'], fault, fault/'encoded/result.json')
            require(result['exit_code'] == 2 and result['status'] == 'MISMATCH' and
                    result['first_difference']['kind'] == 'three_way_mismatch',
                    'Fault was not rejected by exact comparator', comparator=result)
            witness = causality(fault, spec, case, read(case/'reference-run/result.json'), encoded,
                                read(case/'lean/fourstate-result.json'), read(fault/'encoded/encoded-result.json'),
                                mapping, result['first_difference'])
            exits = {name: read(fault/'encoded'/name/'result.json')['exit_code'] for name in ('compile', 'execute')}
            require(all(v == 0 for v in exits.values()), 'Fault failed to compile/execute')
            item = {'id': spec['id'], 'category': spec['category'], 'case': spec['case'], 'status': 'DETECTED',
                    'compile_execute_exits': exits, 'comparison_exit': result['exit_code'],
                    'first_difference': result['first_difference'], 'mutation': mutation,
                    'affected_target_bit_positions': witness['affected_target_bit_positions'],
                    'trigger_evidence': relative(fault/'trigger-evidence.json', folder),
                    'observed_rails': 'All observed output/current-state rails parsed from actual stdout as literal binary by unchanged run_rtl.'}
            write(fault/'result.json', item); report['faults'].append(item)
            write(folder/'summary.json', report)
        stage = 'integrity'
        require(len(report['faults']) == 3 and {f['category'] for f in report['faults']} == {'output', 'state', 'xz'},
                'All fault categories are required')
        require(not unchanged(before), 'Protected input/framework/history/baseline changed', files=unchanged(before))
        report['baselines'] = baseline_results
        report['detection'] = {'required': 3, 'detected': 3, 'expected_comparator_exit': 2}
        report['status'] = 'FAULT_DETECTION_PASS'
        write(folder/'first-failure.json', {'status': 'NO_UNEXPECTED_FAILURE', 'first_failure': None,
              'expected_fault_differences': {f['id']: f['first_difference'] for f in report['faults']}})
        return 0
    except Exception as exc:
        detail = exc.detail if isinstance(exc, SmokeFailure) else {'kind': 'execution', 'reason': str(exc)}
        report.update(status='BLOCKED', blocked_stage=stage, first_failure=detail, error=traceback.format_exc())
        write(folder/'first-failure.json', {'status': 'BLOCKED', 'stage': stage, 'first_failure': detail, 'traceback': report['error']})
        print(report['error'], file=sys.stderr, flush=True)
        return 1
    finally:
        if before is not None:
            write(folder/'integrity.json', {'protected_files_checked': len(before), 'changed': unchanged(before)})
        write(folder/'summary.json', report)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--evidence', type=Path, default=ROOT/'experiments/fourstate/pf-fault')
    parser.add_argument('--baseline-report', type=Path,
                        help='Reuse a completed F1.2 regression run, checking every saved artifact; default runs it freshly.')
    parser.add_argument('--run', type=Path, help=argparse.SUPPRESS)
    parser.add_argument('--compare', type=Path, help=argparse.SUPPRESS)
    args = parser.parse_args()
    if args.compare:
        raise SystemExit(compare_job(args.compare.resolve()))
    if args.run:
        folder = args.run.resolve()
        require(folder.is_relative_to((ROOT/'experiments/fourstate').resolve()) and
                not (folder/'summary.json').exists() and {p.name for p in folder.iterdir()} <= {'invocation'}, 'Internal run must be new')
        raise SystemExit(campaign(folder, args.baseline_report.resolve() if args.baseline_report else None))
    run = dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ')+'-'+uuid.uuid4().hex[:8]
    folder = fresh_directory(args.evidence/run)
    print('Evidence:', folder, flush=True)
    command = [sys.executable, '-B', str(DRIVER), '--run', str(folder)]
    if args.baseline_report:
        command += ['--baseline-report', str(args.baseline_report.resolve())]
    code = run_logged(command, folder/'invocation')
    report = read(folder/'summary.json'); report['invocation_exit_code'] = code
    if code:
        report['status'] = 'BLOCKED'
    report['artifact_sha256'] = {p.relative_to(folder).as_posix(): digest(p) for p in sorted(folder.rglob('*'))
                                 if p.is_file() and p != folder/'summary.json'}
    # Flatten the fresh F1.2 report and its F1.1/seven-batch short-directory assets.
    external = {}
    root = ((folder/report['regression']['report']).resolve().parent.parent if report.get('regression')
            else ROOT/'experiments/fourstate'/('pf-d-'+folder.name[-8:]))
    for path in sorted(root.rglob('*')) if root.exists() else []:
        if path.is_file():
            external[relative(path, folder)] = digest(path)
    for path in root.glob('*/summary.json') if root.exists() else []:
        for name, expected in read(path).get('external_artifact_sha256', {}).items():
            external[relative((path.parent/name).resolve(), folder)] = expected
    report['external_artifact_sha256'] = external
    write(folder/'summary.json', report)
    print(json.dumps({k: report.get(k) for k in ('task', 'status', 'detection', 'first_failure')}, indent=2))
    raise SystemExit(code)


if __name__ == '__main__':
    main()
