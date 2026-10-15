"""Check that reusable RTL imports preserve behavior and reject stale inputs."""
from __future__ import annotations

import json
import shutil
from pathlib import Path

from common import ROOT
from yosys2lean import digest, translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def main():
    reference = ROOT / 'experiments/yosys-project-7.3'
    folder = ROOT / 'experiments/yosys-checkpoint-7.3'
    project = folder / 'project'
    shutil.copytree(reference / 'project', project, dirs_exist_ok=True)
    kwargs = dict(top='ProjectTop', namespace='Checkpoint.Top', keep_hierarchy=True, yosys_engine='native', functional_io='stream')
    fresh = translate_yosys(project, folder / 'fresh', evidence=folder / 'fresh-translation', **kwargs)
    checkpoint = folder / 'fresh/hierarchy-checkpoint.json'
    resumed = translate_yosys(project, folder / 'resumed', evidence=folder / 'resumed-translation',
                              hierarchy_checkpoint=checkpoint, **kwargs)
    flat = folder / 'fresh/flat-checkpoint.json'
    flat_relative = translate_yosys(project, folder / 'flat-resumed', evidence=folder / 'flat-translation',
                                   flat_checkpoint=flat, **kwargs)
    normalized = folder / 'fresh/normalized-checkpoint.json'
    normalized_relative = translate_yosys(project, folder / 'normalized-resumed', evidence=folder / 'normalized-translation',
                                         normalized_checkpoint=normalized, **kwargs)
    functional = folder / 'fresh/functional-checkpoint.json'
    functional_relative = translate_yosys(project, folder / 'functional-resumed', evidence=folder / 'functional-translation',
                                         functional_checkpoint=functional, **kwargs)
    request = json.loads((reference / 'lean/request.json').read_text(encoding='utf-8'))
    expected = json.loads((reference / 'lean/result.json').read_text(encoding='utf-8'))
    for kind, relative in [('fresh', fresh), ('resumed', resumed), ('flat-resumed', flat_relative),
                           ('normalized-resumed', normalized_relative), ('functional-resumed', functional_relative)]:
        path = folder / kind / relative
        ir = json.loads(path.read_text(encoding='utf-8'))
        rows = [{'inputs': {n: v for n, v in row['inputs'].items() if n != ir['clock']}}
                for row in request['trace']]
        for row in rows:
            row['inputs'].update({p['name']: 0 for p in ir['arbitrary_inputs']})
        code, actual = simulate_yosys(path, rows, experiment_initial(ir), folder / (kind + '-lean'))
        assert code == 0 and actual == expected, kind
    report = json.loads((folder / 'resumed/manifest.json').read_text(encoding='utf-8'))
    assert report['reused_hierarchy']
    assert not (Path(report['evidence']) / 'yosys-hierarchy/result.json').exists()
    rejected = []
    header = project / 'include/width.svh'
    original = header.read_bytes()
    header.write_text('`define WIDTH 6\n', encoding='utf-8')
    try:
        translate_yosys(project, folder / 'stale', evidence=folder / 'stale-translation',
                        hierarchy_checkpoint=checkpoint, **kwargs)
    except ValueError as error:
        assert 'checkpoint differs' in str(error)
        rejected.append('modified included macro header')
    else:
        raise AssertionError('Stale RTL checkpoint accepted')
    finally:
        header.write_bytes(original)
    damaged = folder / 'damaged'
    damaged.mkdir(parents=True, exist_ok=True)
    record = json.loads(checkpoint.read_text(encoding='utf-8'))
    (damaged / record['rtlil']['name']).write_bytes(b'damaged RTLIL')
    write(damaged / 'checkpoint.json', record)
    try:
        translate_yosys(project, folder / 'bad-il', evidence=folder / 'bad-il-translation',
                        hierarchy_checkpoint=damaged / 'checkpoint.json', **kwargs)
    except ValueError as error:
        assert 'RTLIL hash mismatch' in str(error)
        rejected.append('corrupted RTLIL')
    else:
        raise AssertionError('Corrupted RTLIL checkpoint accepted')
    try:
        translate_yosys(project, folder / 'wrong-tool', evidence=folder / 'wrong-tool-translation',
                        hierarchy_checkpoint=checkpoint, **{**kwargs, 'yosys_engine': 'wasm'})
    except ValueError as error:
        assert 'checkpoint differs' in str(error)
        rejected.append('different pinned runtime')
    else:
        raise AssertionError('Checkpoint from another runtime accepted')
    bad_flat = folder / 'damaged-flat'
    bad_flat.mkdir(parents=True, exist_ok=True)
    flat_record = json.loads(flat.read_text(encoding='utf-8'))
    shutil.copy2(flat.parent / flat_record['rtlil']['name'], bad_flat / flat_record['rtlil']['name'])
    (bad_flat / 'before.json').write_text('{}', encoding='utf-8')
    write(bad_flat / 'checkpoint.json', flat_record)
    try:
        translate_yosys(project, folder / 'bad-companion', evidence=folder / 'bad-companion-translation',
                        flat_checkpoint=bad_flat / 'checkpoint.json', **kwargs)
    except ValueError as error:
        assert 'companion artifact hash mismatch' in str(error)
        rejected.append('corrupted flat metadata companion')
    else:
        raise AssertionError('Corrupted metadata companion accepted')
    normalized_manifest = json.loads((folder / 'normalized-resumed/manifest.json').read_text(encoding='utf-8'))
    assert normalized_manifest['reused_normalized']
    for stage in ('yosys-prepare', 'yosys-functional'):
        assert (Path(normalized_manifest['evidence']) / stage / 'reused.json').exists()
        assert not (Path(normalized_manifest['evidence']) / stage / 'result.json').exists()
    for changed in ({'clock_mode': 'global'}, {'preserve_effects': True}):
        try:
            translate_yosys(project, folder / 'wrong-normalization', evidence=folder / 'wrong-normalization-translation',
                            normalized_checkpoint=normalized, **{**kwargs, **changed})
        except ValueError as error:
            assert 'checkpoint differs' in str(error)
            rejected.append('different clock/effect lowering contract: ' + next(iter(changed)))
        else:
            raise AssertionError('Checkpoint from another normalization accepted')
    functional_manifest = json.loads((folder / 'functional-resumed/manifest.json').read_text(encoding='utf-8'))
    assert functional_manifest['reused_functional'] and functional_manifest['functional_io'] == 'stream'
    for stage in ('yosys-prepare', 'yosys-functional', 'yosys-export'):
        assert (Path(functional_manifest['evidence']) / stage / 'reused.json').exists()
        assert not (Path(functional_manifest['evidence']) / stage / 'result.json').exists()
    bad_functional = folder / 'damaged-functional'
    bad_functional.mkdir(parents=True, exist_ok=True)
    record = json.loads(functional.read_text(encoding='utf-8'))
    (bad_functional / record['functional']['name']).write_text('corrupted', encoding='utf-8')
    write(bad_functional / 'checkpoint.json', record)
    try:
        translate_yosys(project, folder / 'bad-functional', evidence=folder / 'bad-functional-translation',
                        functional_checkpoint=bad_functional / 'checkpoint.json', **kwargs)
    except ValueError as error:
        assert 'FunctionalIR hash mismatch' in str(error)
        rejected.append('corrupted FunctionalIR')
    else:
        raise AssertionError('Corrupted FunctionalIR checkpoint accepted')
    result = {'status': 'PASS', 'cycles_per_model': len(expected), 'models_compared': 5,
              'independent_rtl_reference_sha256': digest(reference / 'lean/result.json'),
              'rejected': rejected,
              'scope': 'Fresh and resumed Lean execute the same independently RTL-checked hierarchical project trace. Reuse also checks source headers, preprocessing, tool identity and producer hashes.'}
    write(folder / 'summary.json', result)
    write(ROOT / 'docs/validation-yosys-checkpoint-7.3.json', result)
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
