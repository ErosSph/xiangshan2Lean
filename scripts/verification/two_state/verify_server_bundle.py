"""Relocate the actual transfer archive and execute its small acceptance gates."""
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
import copy
import json
from pathlib import Path
import stat
import sys
import zipfile

from common import ROOT, lean_executable, run_logged
from server_bundle import MANIFEST, read, safe_path, write
from trace_compare import compare_rows
from yosys_hierarchy import digest


def verify(archive_path, output, work):
    if output.exists():
        raise ValueError('Use a new relocation directory; existing files are preserved')
    output.mkdir(parents=True)
    with zipfile.ZipFile(archive_path) as archive:
        entries = archive.infolist()
        if len({entry.filename for entry in entries}) != len(entries):
            raise ValueError('Archive has duplicate names')
        for entry in entries:
            if stat.S_ISLNK(entry.external_attr >> 16) or entry.is_dir():
                raise ValueError('Transfer archive must contain regular files only')
            target = safe_path(output, entry.filename)
            target.parent.mkdir(parents=True, exist_ok=True)
            with archive.open(entry) as source, target.open('xb') as destination:
                for data in iter(lambda: source.read(4*1024*1024), b''):
                    destination.write(data)
    root = output / 'xiangshan2lean-server'
    manifest = read(root / MANIFEST)
    if work.exists() or any(char.isspace() for char in str(work)):
        raise ValueError('Use a new work directory without whitespace for the Verilator check')
    base = [sys.executable, str(root / 'scripts/server.py')]
    lean = str(Path(lean_executable()).resolve())
    checks = []
    def run(label, action, *arguments, fail=False):
        command = [*base, action, '--lean', lean, *map(str, arguments)]
        code = run_logged(command, output / 'checks' / label, cwd=ROOT.parent, echo=False)
        if (code == 0) == fail:
            raise RuntimeError('Unexpected command outcome: ' + label + '; see ' + str(output / 'checks' / label))
        checks.append({'case': label, 'exit_code': code, 'expected_failure': fail})
        print('PASS ' + label, flush=True)
    run('archive-integrity', 'verify')
    run('host-tools', 'doctor', '--with-rtl')
    run('prepare-relocated-model', 'init', '--work', work)
    if read(work / 'model/manifest.json')['lean_checked']:
        raise AssertionError('Relocation incorrectly inherited host compilation success')
    run('native-and-fresh-rtl-smoke', 'selftest', '--work', work, '--with-rtl')
    selftest = read(work / 'selftest.json')
    assert selftest['status'] == selftest['fresh_rtl'] == 'PASS'
    run('reject-incomplete-whole-acceptance', 'compare', '--work', work, fail=True)
    assert not (work / 'acceptance.json').exists()

    fixture = manifest['fixture']['directory']
    original = read(root / fixture / 'origin-manifest.json')
    packet = root / fixture / original['table']['binary'].replace('\\', '/')
    data = packet.read_bytes()
    try:
        damaged = bytearray(data)
        damaged[len(damaged)//2] ^= 1
        packet.write_bytes(damaged)
        run('reject-changed-transfer-packet', 'verify', fail=True)
    finally:
        packet.write_bytes(data)
    work_packet = work / 'fixture' / original['table']['binary'].replace('\\', '/')
    data = work_packet.read_bytes()
    try:
        damaged = bytearray(data)
        damaged[len(damaged)//2] ^= 1
        work_packet.write_bytes(damaged)
        run('reject-changed-working-packet', 'selftest', '--work', work, fail=True)
    finally:
        work_packet.write_bytes(data)
    run('restored-transfer-integrity', 'verify')
    expected = read(root / 'fixture/expected.json')
    assert compare_rows(expected, expected, ['q'], len(expected))['status'] == 'PASS'
    rejected = []
    variants = [('missing-sample', expected[:-1], 'INCOMPLETE')]
    changed = copy.deepcopy(expected)
    changed[1]['post']['q'] ^= 1
    variants.append(('wrong-output-bit', changed, 'MISMATCH'))
    changed = copy.deepcopy(expected)
    del changed[1]['post']['q']
    variants.append(('missing-output-port', changed, 'PORT_MISMATCH'))
    changed = copy.deepcopy(expected)
    changed[1]['cycle'] = 7
    variants.append(('wrong-cycle-index', changed, 'INVALID_CYCLE'))
    for name, changed, status in variants:
        assert compare_rows(changed, expected, ['q'], len(expected))['status'] == status
        rejected.append(name)
    report = {'status': 'PASS', 'archive_sha256': digest(archive_path),
        'bundle_manifest_sha256': digest(root / MANIFEST), 'commands': checks,
        'selftest': selftest, 'trace_comparison_rejections': rejected,
        'work_directory': str(work), 'execution_host': 'Windows x86_64',
        'target_server_execution': 'NOT_RUN', 'whole_chip_acceptance': 'NOT_RUN',
        'scope': 'Actual bundle relocated to a different directory, host-compiled and executed on the small fixture against fresh independent RTL. Transfer/work packet corruption and incomplete/incorrect traces are rejected. Target OS/architecture remains unconfirmed.'}
    write(output / 'summary.json', report)
    write(ROOT / 'docs/validation-server-bundle-7.3.json', report)
    print(json.dumps({key: report[key] for key in ('status', 'archive_sha256', 'target_server_execution', 'whole_chip_acceptance')}, indent=2))
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--archive', type=Path, required=True)
    parser.add_argument('--out', type=Path, required=True)
    parser.add_argument('--work', type=Path, required=True)
    args = parser.parse_args()
    verify(args.archive.resolve(), args.out.resolve(), args.work.resolve())


if __name__ == '__main__':
    raise SystemExit(main())
