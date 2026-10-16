"""Translate the strict four-state RTL subset through the unchanged two-state backend."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import subprocess

from common import ROOT
from fourstate_frontend import parse
from fourstate_encode import encode
from yosys2lean import translate_yosys


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def write(path, data):
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    Path(path).write_text(json.dumps(data, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


def fresh_directory(path):
    path = Path(path).resolve()
    bases = [(ROOT / 'generated/fourstate').resolve(), (ROOT / 'experiments/fourstate').resolve()]
    if not any(path.is_relative_to(base) and path != base for base in bases):
        raise ValueError('Use an independent child of generated/fourstate or experiments/fourstate')
    if path.exists() and any(path.iterdir()):
        raise ValueError('Refusing to overwrite nonempty directory: ' + str(path))
    path.mkdir(parents=True, exist_ok=True)
    return path


def provenance(output):
    folder = output / 'source-snapshot'
    folder.mkdir()
    files = sorted(set(ROOT.glob('scripts/fourstate*.py')) | set(ROOT.glob('scripts/*fourstate*.py')) |
                   {p for p in ROOT.glob('verification/fourstate/**/*') if p.is_file()} |
                   {ROOT / name for name in ('README.md', 'AGENTS.md', 'TASKS.md', 'docs/fourstate-frontend.md')})
    hashes = {}
    for src in files:
        relative = src.relative_to(ROOT)
        dest = folder / relative
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_bytes(src.read_bytes())
        hashes[relative.as_posix()] = digest(src)
    for args, name in [(['rev-parse', 'HEAD'], 'head.txt'),
                       (['status', '--porcelain=v1', '--untracked-files=all'], 'status.txt'),
                       (['diff', '--binary', 'HEAD', '--', 'scripts', 'verification/fourstate', 'docs/fourstate-frontend.md', 'README.md', 'AGENTS.md', 'TASKS.md'], 'working-tree.diff')]:
        (folder / name).write_bytes(subprocess.check_output(['git', *args], cwd=ROOT))
    return hashes


def check_interface(ir, mapping):
    if ir['states'] or ir['clock'] is not None or ir.get('effects'):
        raise ValueError('Four-state combinational model must have no state, clock or effects')
    for kind, direction in [('inputs', 'input'), ('outputs', 'output')]:
        expected = {p[key]: p['width'] for p in mapping['ports'] if p['direction'] == direction and p.get('role') != 'clock' for key in ('tag', 'value')}
        fields = ('current_tag', 'current_value') if direction == 'input' else ('next_tag', 'next_value')
        expected.update({p[key]: p['width'] for p in mapping.get('states', []) for key in fields})
        actual = {p['name']: p['sort']['width'] for p in ir[kind] if p['sort']['kind'] == 'bits'}
        if actual != expected or len(ir[kind]) != len(expected):
            raise ValueError('Encoded interface mismatch or extra arbitrary inputs: ' + kind)


def translate(source, top, output, mode='combinational', clock=None):
    ir = parse(Path(source), top, mode, clock)
    rtl, mapping = encode(ir)
    output = fresh_directory(output)
    version = ir['format'].rsplit('-', 1)[-1]
    source_assets = []
    if version in ('v4', 'v5'):
        base = Path(source).resolve() if Path(source).is_dir() else Path(source).resolve().parent
        for name in ir['sources']:
            src = Path(name)
            relative = Path('original') / src.relative_to(base)
            dest = output / relative
            dest.parent.mkdir(parents=True, exist_ok=True); dest.write_bytes(src.read_bytes())
            source_assets.append({'path': str(src), 'snapshot': relative.as_posix(), 'sha256': digest(dest)})
        write(output / 'sources.json', {'top': top, 'files': source_assets})
        write(output / 'elaboration.json', ir['elaboration'])
    else:
        snapshot = output / 'original.sv'
        snapshot.write_bytes(Path(source).read_bytes())
    (output / 'encoded.sv').write_text(rtl, encoding='utf-8')
    write(output / 'fourstate.ir.json', ir)
    write(output / 'ports.json', mapping)
    sources = provenance(output)
    relative_ir = translate_yosys(output / 'encoded.sv', output / 'model', mapping['encoded_top'],
                                  namespace='FourState.Model', evidence=output / 'translation',
                                  yosys_engine='native', lean_backend='source', check=True)
    model_ir = output / 'model' / relative_ir
    check_interface(json.loads(model_ir.read_text()), mapping)
    artifacts = {p.relative_to(output).as_posix(): digest(p) for p in output.rglob('*') if p.is_file()}
    manifest = {'format': 'chisel2lean-fourstate-manifest-' + version, 'mode': mode, 'status': 'COMPILED',
                'scope': 'Typed four-state subset with source provenance; compilation is not differential verification.',
                'source': str(Path(source).resolve()),
                'mapping': 'ports.json', 'ir': model_ir.relative_to(output).as_posix(),
                'source_snapshot_sha256': sources, 'artifact_sha256': artifacts}
    if version in ('v4', 'v5'):
        manifest.update(sources='sources.json', elaboration='elaboration.json', fourstate_ir='fourstate.ir.json')
    else:
        manifest['source_sha256'] = digest(snapshot)
    if mode == 'sequential':
        manifest.update(clock=clock,
                        scope='Explicit register transition, single binary posedge clock, caller-supplied four-state initial values.')
    write(output / 'fourstate-manifest.json', manifest)
    return output / 'fourstate-manifest.json'


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('source', type=Path); p.add_argument('--top', required=True)
    p.add_argument('--out', type=Path, required=True)
    p.add_argument('--mode', choices=['combinational', 'sequential'], default='combinational')
    p.add_argument('--clock')
    args = p.parse_args()
    print(translate(args.source, args.top, args.out, args.mode, args.clock))


if __name__ == '__main__':
    main()
