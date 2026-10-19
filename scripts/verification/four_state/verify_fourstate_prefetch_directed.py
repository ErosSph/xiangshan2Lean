"""F1.2 directed prefetch validation, reusing F1.1 execution and comparison."""
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
import json
import os
from pathlib import Path
import shutil
import sys
import traceback
import uuid

from common import ROOT, run_logged
from fourstate2lean import digest, fresh_directory, provenance, write
from fourstate_simulate import load, simulate
from fourstate_sequential import validate
from verify_fourstate import tools_record
from verify_fourstate_sequential import run_rtl
from verify_fourstate_prefetch_smoke import (
    SmokeFailure, require, read, protected_files, unchanged, inventory,
    make_trace, compare_all, check_rails, verify_audit,
)
from verify_fourstate_xiangshan import regressions

FIXTURE = ROOT / 'verification/fourstate/xiangshan-prefetch-directed.json'


def prepare(folder, fixture, base):
    prior = ROOT / fixture['f11_root']
    summary = prior / 'summary.json'
    manifest = prior / 'convert/fourstate-manifest.json'
    require(digest(summary) == fixture['f11_summary_sha256'], 'F1.1 report hash mismatch')
    require(digest(manifest) == fixture['f11_manifest_sha256'], 'F1.1 v5 manifest hash mismatch')
    old = read(summary)
    require(old['status'] == 'SMOKE_PASS' and old['invocation_exit_code'] == 0 and
            old['comparison']['cycles'] == 16 and old['comparison']['samples'] == 80, 'F1.1 acceptance mismatch')
    for name, expected in old['artifact_sha256'].items():
        require((prior/name).is_file() and digest(prior/name) == expected, 'F1.1 artifact changed', path=name)
    current = {n:h for n,h in old['source_snapshot_sha256'].items()
               if n.startswith('scripts/') or n == fixture['base_fixture']}
    require(not unchanged(current), 'F1.1 driver/framework/fixture changed', files=unchanged(current))
    verify_audit(base, folder)
    load(manifest)
    shutil.copytree(prior/'convert', folder/'convert')
    (folder/'reference').mkdir()
    shutil.copyfile(prior/'reference/Chisel2LeanReference.v', folder/'reference/Chisel2LeanReference.v')
    shutil.copytree(prior/'inputs', folder/'inputs/f11')
    shutil.copyfile(FIXTURE, folder/'inputs/directed.json')
    copied = folder/'convert/fourstate-manifest.json'
    require(digest(copied) == fixture['f11_manifest_sha256'], 'Copied model differs')
    require(digest(folder/'reference/Chisel2LeanReference.v') == base['sources']['official_rtl_sha256'], 'Reference RTL differs')
    mapping, inv = inventory(folder, copied, base)
    contract = {'task':'F1.2','configuration':base['configuration'],'upstream_commit':base['upstream_commit'],
        'reference_rtl_sha256':digest(folder/'reference/Chisel2LeanReference.v'),
        'chirrtl_sha256':base['sources']['chirrtl_sha256'],'default_rtl_sha256':base['sources']['default_rtl_sha256'],
        'prior_smoke':fixture['f11_root'],'prior_report_sha256':digest(summary),'prior_artifacts_checked':len(old['artifact_sha256']),
        'reused_manifest_sha256':digest(copied),'current_script_snapshots_checked':len(current),
        'model_compilation':'Copied F1.1 compiled v5 model and exact artifacts; new sequential wrappers compile/run per directed case. F1.1 is also rerun freshly.',
        'claim':'Official disallowLocalVariables RTL is both conversion source and simulation reference. No default RTL or whole-core equivalence claim.'}
    write(folder/'reference-contract.json', contract)
    return mapping, inv, contract


def directed_expectations(folder, case, trace, plan, paths):
    """Evaluate literal, independently authored guards and postconditions."""
    rows = []
    for check in case['checks']:
        matches = [p for p in plan if p['cycle'] == check['cycle'] and p['sampling'] == check['sampling']]
        require(len(matches) == 1, 'Coverage sampling target is ambiguous', coverage=check['id'])
        where = matches[0]; sample = where['sample']; ref = paths['reference'][sample]
        conditions = []
        def condition(section, name, actual, expected, trigger=False):
            conditions.append({'section':section,'name':name,'actual':actual,'expected':expected,
                               'match':actual == expected,'trigger':trigger})
        condition('metadata','rising',ref['rising'],check['rising'],True)
        for n, v in check['inputs'].items():
            condition('inputs',n,trace[sample]['inputs'][n],v,True)
        for n, v in check['pre_states'].items():
            condition('pre.states',n,ref['pre']['states'][n],v,True)
        for n, v in check['post_states'].items():
            condition('post.states',n,ref['post']['states'][n],v)
        for n, v in check.get('post_outputs',{}).items():
            condition('post.outputs',n,ref['post']['outputs'][n],v)
        for n in check.get('hold_states',[]):
            condition('hold.states',n,ref['post']['states'][n],ref['pre']['states'][n])
        for dest, src in check.get('copy_old_state',{}).items():
            condition('copy.old_state',dest,ref['post']['states'][dest],ref['pre']['states'][src])
        for n in check.get('changed_states',[]):
            condition('changed.states',n,ref['pre']['states'][n] != ref['post']['states'][n],True)
        require(bool(check['pre_states']) and bool(check['post_states']), 'Coverage requires nonempty independent expectations')
        trigger = all(c['match'] for c in conditions if c['trigger'])
        expected = all(c['match'] for c in conditions if not c['trigger'])
        rows.append({'id':check['id'],'status':'HIT' if trigger and expected else ('EXPECTED_FAIL' if trigger else 'MISS'),
            'case':case['id'],**where,'description':check['description'],'triggered':trigger,
            'independent_expected_match':expected,'conditions':conditions,'inputs':trace[sample]['inputs'],
            'observed':{n:values[sample] for n,values in paths.items()}})
    write(folder/'coverage.json', {'task':'F1.2','points':rows,'required':len(rows),
          'hit':sum(r['status']=='HIT' for r in rows)})
    bad = next((r for r in rows if r['status'] != 'HIT'),None)
    if bad:
        failed = next(c for c in bad['conditions'] if not c['match'])
        bit = None
        if isinstance(failed['actual'],str) and isinstance(failed['expected'],str) and len(failed['actual']) == len(failed['expected']):
            bit = next(len(failed['actual'])-1-i for i,(a,b) in enumerate(zip(failed['actual'],failed['expected'])) if a!=b)
        raise SmokeFailure({'kind':'independent_expectation' if bad['triggered'] else 'coverage_miss',
            'case':case['id'],'coverage':bad['id'],'cycle':bad['cycle'],'sample':bad['sample'],'phase':'post',
            'bit':bit,'condition':failed})
    return [{'id':r['id'],'case':case['id'],'cycle':r['cycle'],'sample':r['sample'],
             'sampling':r['sampling'],'status':r['status']} for r in rows]


def coverage_matrix(folder, fixture):
    seen = {}
    for file in sorted((folder/'cases').glob('*/coverage.json')):
        for row in read(file)['points']:
            require(row['id'] not in seen, 'Duplicate required coverage point', coverage=row['id'])
            seen[row['id']] = {'status':row['status'],'case':row['case'],'cycle':row['cycle'],
                'sample':row['sample'],'sampling':row['sampling'],'evidence':file.relative_to(folder).as_posix()}
    points = {name:seen.get(name,{'status':'NOT_RUN'}) for name in fixture['required_coverage']}
    require(set(seen) <= set(points), 'Unlisted coverage point')
    result = {'task':'F1.2','required':len(points),'hit':sum(v['status']=='HIT' for v in points.values()),
              'missing':[n for n,v in points.items() if v['status']!='HIT'],'points':points}
    write(folder/'coverage.json', result)
    return result


def run_case(folder, case, base, manifest, mapping):
    folder.mkdir(parents=True)
    write(folder/'case.json', case)
    adapted = {**base,'cycles':case['cycles'],'initial':case['initial']}
    trace, plan = make_trace(adapted)
    validate(mapping, trace, case['initial'])
    write(folder/'initial.json',case['initial']); write(folder/'sampling-plan.json',plan)
    (folder/'trace.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in trace),encoding='utf-8')
    trace = [json.loads(x) for x in (folder/'trace.jsonl').read_text().splitlines()]
    initial = read(folder/'initial.json')
    ref = run_rtl(manifest.parents[1]/'reference/Chisel2LeanReference.v',mapping,trace,initial,folder/'reference-run')
    enc = run_rtl(manifest.parent/'encoded.sv',mapping,trace,initial,folder/'encoded',True)
    lean = simulate(manifest,trace,folder/'lean',initial)
    require(ref[0]['pre']['states'] == initial, 'All eleven initial states must be observed exactly', case=case['id'])
    comparison = compare_all(folder,adapted,trace,plan,ref,enc,lean)
    rails = check_rails(folder,mapping,trace)
    points = directed_expectations(folder,case,trace,plan,{'reference':ref,'encoded':enc,'lean':lean})
    result = {'id':case['id'],'status':'DIRECTED_PASS','comparison':comparison,'rails':rails,'coverage':points}
    write(folder/'result.json',result)
    return result


def rerun_smoke(folder):
    root = ROOT/'experiments/fourstate'/('pd-s-'+folder.name[-8:])
    require(not root.exists(), 'F1.1 rerun root already exists')
    cmd = [sys.executable,'-B',str(ROOT/'scripts/verification/four_state/verify_fourstate_prefetch_smoke.py'),'--evidence',str(root)]
    require(run_logged(cmd,folder/'f11-command',echo=False)==0, 'F1.1 rerun failed')
    reports = list(root.glob('*/summary.json'))
    require(len(reports)==1 and read(reports[0])['status']=='SMOKE_PASS', 'F1.1 rerun did not report SMOKE_PASS')
    return {'status':'SMOKE_PASS','exit_code':0,'report':Path(os.path.relpath(reports[0],folder)).as_posix(),
            'sha256':digest(reports[0]),'samples':read(reports[0])['comparison']['samples']}


def campaign(folder):
    report = {'task':'F1.2','status':'RUNNING','cases':[],'first_failure':None,
              'scope':'Directed finite trajectories of official no-local-variable RTL; no default RTL or whole-core equivalence claim.'}
    write(folder/'summary.json',report)
    before = None; fixture = None; stage = 'input-and-model-check'; current_case = None
    try:
        fixture = read(FIXTURE); base = read(ROOT/fixture['base_fixture'])
        before = protected_files(folder); write(folder/'protected-before.json',before)
        require(len(set(fixture['required_coverage']))==len(fixture['required_coverage']), 'Coverage IDs must be unique')
        mapping, report['inventory'], report['reference_contract'] = prepare(folder,fixture,base)
        report['source_snapshot_sha256'] = provenance(folder)
        report['tools'] = tools_record(folder/'tools')
        manifest = folder/'convert/fourstate-manifest.json'
        for index,case in enumerate(fixture['cases']):
            current_case = case['id']; stage = 'directed-three-way-and-independent-expectations'
            print('Directed',index+1,'/',len(fixture['cases']),current_case,flush=True)
            report['cases'].append(run_case(folder/'cases'/('c'+str(index).zfill(2)),case,base,manifest,mapping))
            write(folder/'summary.json',report)
        report['coverage'] = coverage_matrix(folder,fixture)
        require(not report['coverage']['missing'] and len(report['cases'])==len(fixture['cases']), 'Required directed coverage is incomplete')
        report['totals'] = {k:sum(c['comparison'][k] for c in report['cases'])
                            for k in ('cycles','samples','output_bit_positions','state_bit_positions','total_bit_positions')}
        write(folder/'summary.json',report)
        current_case = None; stage = 'f11-rerun'
        print('Rerunning unchanged F1.1 entrypoint',flush=True)
        report['f11_regression'] = rerun_smoke(folder)
        stage = 'existing-four-state-regressions'
        print('Running existing seven regression batches and v4 replay',flush=True)
        report['regressions'] = regressions(folder)
        stage = 'integrity'
        require(not unchanged(before), 'Protected source or historical report changed',files=unchanged(before))
        require(digest(ROOT/base['sources']['default_rtl'])==base['sources']['default_rtl_sha256'] and
                digest(ROOT/base['sources']['chirrtl'])==base['sources']['chirrtl_sha256'], 'Default RTL or saved CHIRRTL changed')
        report['status'] = 'DIRECTED_PASS'
        write(folder/'first-failure.json',{'status':'NO_FAILURE','first_failure':None})
        return 0
    except Exception as exc:
        detail = exc.detail if isinstance(exc,SmokeFailure) else {'kind':'execution','sample':None,'reason':str(exc)}
        report.update(status='BLOCKED',blocked_stage=stage,failed_case=current_case,first_failure=detail,error=traceback.format_exc())
        write(folder/'first-failure.json',{'status':'BLOCKED','stage':stage,'first_failure':detail,'traceback':report['error']})
        print(report['error'],file=sys.stderr,flush=True)
        return 1
    finally:
        if fixture is not None:
            report['coverage'] = coverage_matrix(folder,fixture)
        if before is not None:
            write(folder/'integrity.json',{'protected_files_checked':len(before),'changed':unchanged(before)})
        write(folder/'summary.json',report)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--evidence',type=Path,default=ROOT/'experiments/fourstate/pf-dir')
    parser.add_argument('--run',type=Path,help=argparse.SUPPRESS)
    args = parser.parse_args()
    if args.run:
        folder = args.run.resolve()
        require(folder.is_relative_to((ROOT/'experiments/fourstate').resolve()) and
                not (folder/'summary.json').exists() and {p.name for p in folder.iterdir()} <= {'invocation'}, 'Internal run must be new')
        raise SystemExit(campaign(folder))
    run = dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ')+'-'+uuid.uuid4().hex[:8]
    folder = fresh_directory(args.evidence/run)
    print('Evidence:',folder,flush=True)
    code = run_logged([sys.executable,'-B',str(Path(__file__).resolve()),'--run',str(folder)],folder/'invocation')
    report = read(folder/'summary.json'); report['invocation_exit_code'] = code
    if code:
        report['status'] = 'BLOCKED'
    report['artifact_sha256'] = {p.relative_to(folder).as_posix():digest(p) for p in sorted(folder.rglob('*')) if p.is_file() and p!=folder/'summary.json'}
    external = [ROOT/'experiments/fourstate'/(prefix+folder.name[-8:]) for prefix in ('pd-s-','xa-r-')]
    report['external_artifact_sha256'] = {Path(os.path.relpath(p,folder)).as_posix():digest(p.resolve())
        for root in external if root.exists() for p in sorted(root.rglob('*')) if p.is_file()}
    write(folder/'summary.json',report)
    print(json.dumps({k:report.get(k) for k in ('task','status','totals','coverage','first_failure')},ensure_ascii=False,indent=2))
    raise SystemExit(code)


if __name__ == '__main__':
    main()
