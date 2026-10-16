"""Check evaluator refresh provenance and rejection of changed circuit assets."""
from __future__ import annotations

import json
import datetime as dt
from pathlib import Path
import uuid

from common import ROOT
from recheck_lean_table import check, prepare
from yosys2lean import digest, write


def main():
    source = ROOT / 'experiments/yosys-table-pipeline-7.3/model'
    attempt = dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ') + '-' + uuid.uuid4().hex[:8]
    base = ROOT / 'experiments/yosys-table-recheck-7.3' / attempt
    model = base / 'model'
    prepared = prepare(source, model)
    original = json.loads((model / 'upstream-manifest.json').read_text(encoding='utf-8'))
    assets = {original['lean'], original['ir'], original['interface'], original['table']['binary'],
              original['table']['hexadecimal'], original['table']['runtime'], 'upstream-manifest.json'}
    rejected = []
    for name in sorted(assets):
        path = model / name
        unchanged = path.read_bytes()
        try:
            if name == 'upstream-manifest.json':
                changed = dict(original, nodes=original['nodes']+1)
                write(path, changed)
            else:
                path.write_bytes(unchanged + b'\n')
            try:
                check(model)
            except ValueError as error:
                assert any(reason in str(error) for reason in ('manifest changed', 'artifact differs', 'evaluator changed'))
                rejected.append(name)
            else:
                raise AssertionError('Changed prepared asset was accepted: ' + name)
        finally:
            path.write_bytes(unchanged)
    checked = check(model)
    manifest = json.loads((model / 'manifest.json').read_text(encoding='utf-8'))
    assert checked['status'] == manifest['table_runtime_recheck']['status'] == 'PASS'
    assert manifest['table_runtime_sha256'] == digest(ROOT / 'lean/Chisel2Lean/Functional.lean')
    assert manifest['source_table_manifest']['sha256'] == prepared['source_manifest_sha256'] == digest(source / 'manifest.json')
    for name in assets - {original['table']['runtime'], 'upstream-manifest.json'}:
        assert digest(model / name) == original['artifact_sha256'][Path(name).as_posix()]
    report = {'status': 'PASS', 'rejected_changed_assets': rejected,
              'model_manifest_sha256': digest(model / 'manifest.json'),
              'runtime_sha256': manifest['table_runtime_sha256'],
              'scope': 'Unchanged packet recompiled and completely validated by Lean with the updated evaluator. Modified Lean entry, interface, IR, binary, hex, runtime and upstream manifest are rejected before compilation.'}
    write(base / 'summary.json', report)
    write(ROOT / 'docs/validation-table-recheck-7.3.json', report)
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
