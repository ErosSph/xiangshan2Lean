"""F1.1: execute the official no-local-variable Nanhu prefetch RTL in three paths."""
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
from collections import Counter
import datetime as dt
import json
from pathlib import Path
import shutil
import subprocess
import sys
import traceback
import uuid

from common import ROOT, run_logged
from fourstate2lean import digest, fresh_directory, provenance, write
from fourstate_simulate import load, simulate
from fourstate_sequential import validate
from verify_fourstate import tools_record
from verify_fourstate_sequential import run_rtl

FIXTURE = ROOT / 'verification/fourstate/xiangshan-prefetch-smoke.json'
FIRTOOL = ROOT / '.tools/firtool-1.135.0/firtool-1.135.0/bin/firtool.exe'


class SmokeFailure(ValueError):
    def __init__(self, detail):
        self.detail = detail
        super().__init__(json.dumps(detail, ensure_ascii=False))


def require(condition, reason, **detail):
    if not condition:
        raise SmokeFailure({'kind': 'contract', 'reason': reason, 'sample': None, **detail})


def read(path):
    return json.loads(Path(path).read_text(encoding='utf-8'))


def protected_files(folder):
    tracked = subprocess.check_output(['git', '--no-optional-locks', 'ls-files', '-z'], cwd=ROOT)
    files = [ROOT / p.decode('utf-8') for p in tracked.split(b'\0') if p]
    files = [p for p in files if p.relative_to(ROOT).parts[0] not in ('experiments', 'generated', '.cache', '.tools')]
    files += [p for p in (ROOT / 'experiments/fourstate').rglob('summary.json') if not p.is_relative_to(folder)]
    return {p.relative_to(ROOT).as_posix(): digest(p) for p in sorted(set(files)) if p.is_file()}


def unchanged(hashes):
    return [name for name, expected in hashes.items()
            if not (ROOT / name).is_file() or digest(ROOT / name) != expected]


def verify_audit(fixture, folder):
    spec = fixture['sources']
    audit = ROOT / spec['audit']
    old_manifest = audit / 'official-no-locals/conversion/fourstate-manifest.json'
    pinned = [(ROOT/spec['chirrtl'], spec['chirrtl_sha256']),
              (ROOT/spec['default_rtl'], spec['default_rtl_sha256']),
              (audit/'summary.json', spec['audit_summary_sha256']),
              (audit/'official-no-locals/Chisel2LeanReference.v', spec['official_rtl_sha256']),
              (old_manifest, spec['audit_manifest_sha256']), (FIRTOOL, spec['firtool_sha256'])]
    for source, expected in pinned:
        require(source.is_file() and digest(source) == expected, 'Pinned input hash mismatch', path=str(source))
    old = read(old_manifest)
    require(old['format'] == 'chisel2lean-fourstate-manifest-v5', 'Audited manifest must be v5')
    load(old_manifest)  # Existing loader checks every saved artifact and the encoded interface.
    core = {name: h for name, h in old['source_snapshot_sha256'].items() if name.startswith('scripts/')}
    require(not unchanged(core), 'Existing four-state implementation differs from audited snapshot', files=unchanged(core))
    audit_assets = read(audit/'artifact-sha256.json')
    require(all((audit/name).is_file() and digest(audit/name) == h for name, h in audit_assets.items()),
            'Prior audit asset hash mismatch')
    write(folder/'prior-audit-check.json', {'status': 'MATCH', 'pinned_files': {str(p): h for p, h in pinned},
          'audited_artifacts_checked': len(old['artifact_sha256']), 'audit_assets_checked': len(audit_assets),
          'existing_script_snapshots_checked': len(core)})
    return audit, audit_assets


def inventory(folder, manifest, fixture):
    mapping, ir_path = load(manifest)
    sources = [mapping, read(manifest.parent/'fourstate.ir.json'), read(manifest.parent/'elaboration.json')]
    fields = ('width', 'signed', 'left', 'right')
    for source in sources:
        actual = {p['name']: [p[k] for k in fields] for p in source['states']}
        require(len(source['states']) == 11 and actual == fixture['states'], 'Independent register inventory mismatch', actual=actual)
    ports = {p['name']: [p['direction'], *[p[k] for k in fields]] for p in mapping['ports']}
    require(ports == fixture['ports'] and len(mapping['ports']) == 9, 'Independent port inventory mismatch')
    for p in mapping['states']:
        require(p['rtl_path'] == p['name'].split('.', 1)[1], 'Original state observation path mismatch', state=p['name'])
        require(p['bit_indices'] == list(range(p['width'])), 'State bit order mismatch', state=p['name'])
    elaboration = sources[2]
    require([(p['path'], p['module']) for p in elaboration['instances']] == [(fixture['top'], fixture['top'])],
            'Unexpected child instance or selected top')
    model = read(ir_path)
    require(not model['states'] and model['clock'] is None and not model.get('arbitrary_inputs'),
            'Unexpected backend hidden state, clock, or arbitrary inputs')
    result = {'status': 'MATCH', 'ports': 9, 'outputs': 2, 'output_bits': 28, 'registers': 11, 'state_bits': 142,
              'format': read(manifest)['format'], 'fourstate_nodes': len(sources[1]['nodes']),
              'functional_nodes': len(model['nodes']), 'states': fixture['states'], 'ports_expected': fixture['ports']}
    write(folder/'inventory-result.json', result)
    return mapping, result


def make_trace(fixture):
    trace, plan = [], []
    previous = fixture['cycles'][0]['inputs']
    for cycle, spec in enumerate(fixture['cycles']):
        data = spec['inputs']
        high = dict(data, reset=spec['high_reset']) if 'high_reset' in spec else data
        for name, values, clock in [('fall', previous, '0'), ('drive-low', data, '0'),
                                   ('hold-low', data, '0'), ('rise', data, '1'), ('hold-high', high, '1')]:
            plan.append({'sample': len(trace), 'cycle': cycle, 'name': spec['name'], 'sampling': name})
            trace.append({'inputs': {**values, fixture['clock']: clock}})
        previous = high
    return trace, plan


def compare_all(folder, fixture, trace, plan, reference, encoded, lean):
    widths = {'outputs': {n: p[1] for n, p in fixture['ports'].items() if p[0] == 'output'},
              'states': {n: p[0] for n, p in fixture['states'].items()}}
    paths = {'reference': reference, 'encoded': encoded, 'lean': lean}
    counts = {'outputs': Counter(), 'states': Counter()}
    for path, rows in paths.items():
        require(len(rows) == len(trace), 'Incomplete trajectory', path=path, actual=len(rows), expected=len(trace))
    for i, row in enumerate(trace):
        expected_meta = {'sample': i, 'clock': int(row['inputs']['clock']),
                         'rising': i > 0 and trace[i-1]['inputs']['clock'] == '0' and row['inputs']['clock'] == '1'}
        for path, rows in paths.items():
            require(set(rows[i]) == {'sample', 'clock', 'rising', 'pre', 'post'} and
                    {k: rows[i][k] for k in expected_meta} == expected_meta, 'Sampling metadata mismatch', path=path, sample=i)
            for phase in ('pre', 'post'):
                require(set(rows[i][phase]) == set(widths), 'Missing observation group', path=path, sample=i, phase=phase)
                for group, names in widths.items():
                    observed = rows[i][phase][group]
                    require(set(observed) == set(names), 'Observation inventory mismatch', path=path, sample=i, phase=phase, group=group)
                    for name, width in names.items():
                        bits = observed[name]
                        require(isinstance(bits, str) and len(bits) == width and set(bits) <= set('01xz'),
                                'Malformed four-state value', path=path, sample=i, phase=phase, group=group, name=name)
        for phase in ('pre', 'post'):
            for group, names in widths.items():
                for name, width in names.items():
                    a, b, c = (paths[p][i][phase][group][name] for p in paths)
                    for offset, (x, y, z) in enumerate(zip(a, b, c)):
                        if x != y or x != z:
                            raise SmokeFailure({'kind': 'three_way_mismatch', **plan[i], 'phase': phase, 'group': group,
                                  'name': name, 'bit': width-1-offset, 'reference': x, 'encoded': y, 'lean': z,
                                  'reference_value': a, 'encoded_value': b, 'lean_value': c})
                    counts[group].update(a)
    result = {'status': 'MATCH', 'samples': len(trace), 'cycles': len(fixture['cycles']), 'rising_edges': sum(r['rising'] for r in reference),
              'phases': ['pre', 'post'], 'output_bit_positions': 2*len(trace)*28, 'state_bit_positions': 2*len(trace)*142,
              'total_bit_positions': 2*len(trace)*170, 'state_histograms': {k: dict(v) for k,v in counts.items()},
              'counting': 'One reference bit position per sample/phase; comparison edges and tag/value rails are not double-counted.',
              'first_failure': None}
    write(folder/'comparison.json', result)
    return result


def check_rails(folder, mapping, trace):
    raw_encoded = read(folder/'encoded/encoded-result.json')
    raw_lean = read(folder/'lean/encoded-result.json')
    widths = {'outputs': {p[k]: p['width'] for p in mapping['ports'] if p['direction'] == 'output' for k in ('tag', 'value')},
              'states': {p['current_'+k]: p['width'] for p in mapping['states'] for k in ('tag', 'value')}}
    checked = 0
    require(len(raw_encoded) == 2*len(trace) and len(raw_lean) == len(trace), 'Raw rail trajectory length mismatch')
    for i in range(len(trace)):
        for j, phase in enumerate(('pre', 'post')):
            a, b = raw_encoded[2*i+j], raw_lean[i][phase]
            for group, names in widths.items():
                require(set(a[group]) == set(b[group]) == set(names), 'Raw rail inventory mismatch', sample=i, phase=phase, group=group)
                for name, width in names.items():
                    x, y = a[group][name], b[group][name]
                    require(type(x) is int and type(y) is int and 0 <= x < 1 << width and 0 <= y < 1 << width,
                            'Invalid binary rail', sample=i, phase=phase, name=name, encoded=x, lean=y)
                    require(x == y, 'Encoded RTL/Lean rail mismatch', sample=i, phase=phase, name=name, encoded=x, lean=y)
                    checked += width
    result = {'status': 'BINARY_AND_MATCH', 'rtl_vs_lean_rail_bit_positions': checked,
              'binary_rail_bit_values_checked': 2*checked,
              'scope': 'Observed output and current-register tag/value rails at every pre/post sample. Icarus helper checks literal 01 strings before integer parsing.'}
    write(folder/'rail-check.json', result)
    return result


def coverage(folder, fixture, trace, reference):
    checks = []
    def checked(name, ok):
        require(ok, 'Required smoke coverage check failed', check=name)
        checks.append(name)
    checked('all_eleven_initial_values_deposited_exactly', reference[0]['pre']['states'] == fixture['initial'])
    checked('initial_output_retains_z', reference[0]['pre']['outputs']['io_out_valid'] == 'z' and
            reference[0]['pre']['outputs']['io_out_bits_vpn'] == fixture['initial']['L2TlbPrefetch.next_req'])
    for i, record in enumerate(reference):
        if i:
            checked('old_state_before_sample_'+str(i), record['pre']['states'] == reference[i-1]['post']['states'])
        if not record['rising']:
            checked('no_edge_hold_'+str(i), record['pre']['states'] == record['post']['states'])
        elif trace[i]['inputs']['reset'] == '1':
            checked('synchronous_control_reset_'+str(i), all(record['post']['states'][n] == '0'*fixture['states'][n][0] for n in fixture['reset_states']))
    checked('sixteen_real_rising_edges', sum(r['rising'] for r in reference) == 16)
    checked('reset_assertion_without_edge_does_not_clear', trace[4]['inputs']['reset'] == '1' and
            reference[4]['post']['states']['L2TlbPrefetch.old_index'] == 'xz')
    checked('reset_release_without_edge_holds_zero_controls', trace[9]['inputs']['reset'] == '0' and
            all(reference[9]['post']['states'][n] == '0'*fixture['states'][n][0] for n in fixture['reset_states']))
    r = reference[5*3+3]
    checked('backpressure_holds_all_registers', r['pre']['states'] == r['post']['states'])
    r = reference[5*6+3]
    checked('simultaneous_consume_uses_old_next_req', r['post']['states']['L2TlbPrefetch.old_reqs_1'] == r['pre']['states']['L2TlbPrefetch.next_req'] and
            r['post']['states']['L2TlbPrefetch.next_req'] != r['pre']['states']['L2TlbPrefetch.next_req'])
    r = reference[5*9+3]
    checked('unreset_data_can_update_during_reset', r['post']['states']['L2TlbPrefetch.next_req'] == '0'*27 and
            r['pre']['states']['L2TlbPrefetch.next_req'] != '0'*27)
    r = reference[5*14+3]
    checked('z_procedural_enable_holds_data', r['post']['states']['L2TlbPrefetch.next_req'] == r['pre']['states']['L2TlbPrefetch.next_req'])
    write(folder/'coverage.json', {'status': 'OBSERVED', 'checks': checks, 'count': len(checks),
          'scope': 'Deterministic F1.1 smoke anchors, not exhaustive semantic coverage.'})
    return {'status': 'OBSERVED', 'count': len(checks)}


def campaign(folder):
    report = {'status': 'RUNNING', 'task': 'F1.1', 'first_failure': None,
              'scope': 'Finite three-way smoke of the official disallowLocalVariables RTL; no default/normalized RTL equivalence claim.'}
    write(folder/'summary.json', report)
    before = None
    audit_assets = None
    stage = 'input-and-audit-check'
    try:
        fixture = read(FIXTURE)
        before = protected_files(folder)
        write(folder/'protected-before.json', before)
        audit, audit_assets = verify_audit(fixture, folder)
        inputs = folder/'inputs'; inputs.mkdir()
        for name, src in [('design.fir', ROOT/fixture['sources']['chirrtl']), ('default.v', ROOT/fixture['sources']['default_rtl']),
                          ('fixture.json', FIXTURE), ('audit-summary.json', audit/'summary.json'),
                          ('audit-reference-contract.json', audit/'official-no-locals/reference-contract.json')]:
            shutil.copyfile(src, inputs/name)
        report['source_snapshot_sha256'] = provenance(folder)
        report['tools'] = tools_record(folder/'tools')
        require(run_logged([str(FIRTOOL), '--version'], folder/'tools/firtool', echo=False) == 0, 'firtool version probe failed')
        stage = 'official-codegen'
        reference = folder/'reference/Chisel2LeanReference.v'; reference.parent.mkdir()
        command = [str(FIRTOOL), str(inputs/'design.fir'), '--disable-all-randomization',
                   '--default-layer-specialization=enable', '--lowering-options=disallowLocalVariables', '-o', str(reference)]
        require(run_logged(command, folder/'official-codegen', echo=False) == 0, 'Official codegen failed')
        require(digest(reference) == fixture['sources']['official_rtl_sha256'], 'Regenerated official RTL differs from audited RTL')
        contract = {'configuration': fixture['configuration'], 'upstream_commit': fixture['upstream_commit'],
                    'top': fixture['top'], 'sources': fixture['sources'], 'firtool_command': command,
                    'firtool_sha256': digest(FIRTOOL), 'reference_rtl_sha256': digest(reference),
                    'conversion_input': reference.relative_to(folder).as_posix(), 'simulation_reference': reference.relative_to(folder).as_posix(),
                    'default_rtl_executed': False, 'manual_rtl_edits': False,
                    'claim': 'Both conversion and reference simulation use the same official no-local-variable RTL; not full four-state equivalence to default RTL.'}
        write(folder/'reference-contract.json', contract); report['reference_contract'] = contract
        stage = 'v5-conversion-and-model-compilation'
        print('Converting official L2TlbPrefetch RTL', flush=True)
        require(run_logged([sys.executable, '-B', str(ROOT/'scripts/fourstate2lean.py'), str(reference), '--top', fixture['top'],
                           '--mode', 'sequential', '--clock', fixture['clock'], '--out', str(folder/'convert')],
                          folder/'conversion-cli', echo=False) == 0, 'Existing four-state conversion failed')
        manifest = folder/'convert/fourstate-manifest.json'
        mapping, report['inventory'] = inventory(folder, manifest, fixture)
        trace, plan = make_trace(fixture)
        validate(mapping, trace, fixture['initial'])
        write(folder/'initial.json', fixture['initial']); write(folder/'sampling-plan.json', plan)
        (folder/'trace.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in trace), encoding='utf-8')
        # Exercise the actual JSONL/initial-file representations, not just in-memory fixtures.
        trace = [json.loads(line) for line in (folder/'trace.jsonl').read_text().splitlines()]
        initial = read(folder/'initial.json')
        stage = 'reference-rtl-execution'
        print('Running reference RTL with one-shot VPI initial state and NBA-settled samples', flush=True)
        ref = run_rtl(reference, mapping, trace, initial, folder/'reference-run')
        stage = 'encoded-rtl-execution'
        print('Running encoded RTL with the existing simultaneous state driver', flush=True)
        enc = run_rtl(manifest.parent/'encoded.sv', mapping, trace, initial, folder/'encoded', True)
        stage = 'lean-wrapper-compilation-and-execution'
        print('Compiling and executing RunSequential.lean', flush=True)
        lean = simulate(manifest, trace, folder/'lean', initial)
        stage = 'all-output-and-state-comparison'
        report['comparison'] = compare_all(folder, fixture, trace, plan, ref, enc, lean)
        report['rails'] = check_rails(folder, mapping, trace)
        report['coverage'] = coverage(folder, fixture, trace, ref)
        require(not unchanged(before), 'Protected source or historical report changed', files=unchanged(before))
        require(all(digest(audit/name) == h for name, h in audit_assets.items()), 'Historical audit artifact changed')
        report['status'] = 'SMOKE_PASS'
        write(folder/'first-failure.json', {'status': 'NO_FAILURE', 'first_failure': None})
        return 0
    except Exception as exc:
        detail = exc.detail if isinstance(exc, SmokeFailure) else {'kind': 'execution', 'sample': None, 'reason': str(exc)}
        report.update(status='BLOCKED', blocked_stage=stage, first_failure=detail, error=traceback.format_exc())
        write(folder/'first-failure.json', {'status': 'BLOCKED', 'stage': stage, 'first_failure': detail, 'traceback': report['error']})
        print(report['error'], file=sys.stderr, flush=True)
        return 1
    finally:
        if before is not None:
            write(folder/'integrity.json', {'protected_files_checked': len(before), 'changed': unchanged(before),
                  'default_rtl_and_chirrtl_unchanged': all(digest(ROOT/fixture['sources'][k]) == fixture['sources'][k+'_sha256'] for k in ('default_rtl', 'chirrtl')),
                  'prior_audit_assets_checked': len(audit_assets) if audit_assets else 0,
                  'prior_audit_changed': [n for n,h in (audit_assets or {}).items() if digest(audit/n) != h]})
        write(folder/'summary.json', report)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--evidence', type=Path, default=ROOT/'experiments/fourstate/pf-smoke')
    parser.add_argument('--run', type=Path, help=argparse.SUPPRESS)
    args = parser.parse_args()
    if args.run:
        folder = args.run.resolve()
        allowed = (ROOT/'experiments/fourstate').resolve()
        require(folder.is_relative_to(allowed) and not (folder/'summary.json').exists() and
                {p.name for p in folder.iterdir()} <= {'invocation'}, 'Internal run directory must be new')
        raise SystemExit(campaign(folder))
    run = dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ')+'-'+uuid.uuid4().hex[:8]
    folder = fresh_directory(args.evidence/run)
    print('Evidence:', folder, flush=True)
    code = run_logged([sys.executable, '-B', str(Path(__file__).resolve()), '--run', str(folder)], folder/'invocation')
    report = read(folder/'summary.json')
    if code:
        report['status'] = 'BLOCKED'
    report['invocation_exit_code'] = code
    report['artifact_sha256'] = {p.relative_to(folder).as_posix(): digest(p) for p in sorted(folder.rglob('*'))
                                 if p.is_file() and p != folder/'summary.json'}
    write(folder/'summary.json', report)
    print(json.dumps({k:report.get(k) for k in ('status', 'invocation_exit_code', 'comparison', 'first_failure')}, indent=2))
    raise SystemExit(code)


if __name__ == '__main__':
    main()
