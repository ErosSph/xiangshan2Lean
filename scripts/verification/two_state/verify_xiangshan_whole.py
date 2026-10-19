"""Compare an original fixed XSTop against its Lean model under an explicit smoke trace."""
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
from pathlib import Path
import shutil
import uuid
import gc

from bootstrap_json_stream import reader
from common import ROOT
from rtl import run_emitted_rtl
from trace_compare import compare_rows
from yosys2lean import digest, write
from yosys_json import ports
from yosys_simulate import experiment_initial, simulate_yosys


def trace_for(interface, cycles):
    inputs = {name: 0 for name, port in interface.items() if port['direction'] == 'input'}
    required = {'io_clock', 'io_reset', 'io_systemjtag_jtag_TCK', 'io_systemjtag_reset'}
    if not required <= inputs.keys():
        raise ValueError('Expected the original DefaultConfig XSTop interface')
    rows = []
    for cycle in range(cycles):
        values = dict(inputs)
        values.update(io_reset=int(cycle < 8), io_systemjtag_reset=int(cycle < 10),
                      io_systemjtag_jtag_TCK=(cycle // 4) % 2)
        for name in ('io_pll0_lock', 'io_systemjtag_jtag_TMS'):
            if name in values:
                values[name] = 1
        if cycle >= 12:
            for channel in (0, 1):
                prefix = 'io_cacheable_check_req_' + str(channel)
                values[prefix + '_valid'] = int((cycle + channel) % 2 == 0)
                values[prefix + '_bits_addr'] = [0, 0x10000000, 0x80000000, 0x100000000][(cycle + channel) % 4]
                values[prefix + '_bits_size'] = (cycle + channel) % 4
                values[prefix + '_bits_cmd'] = channel
        # Data/reset changes while main clock is low; a stable low sample
        # precedes the edge. JTAG reset release occurs between its clock edges.
        for clock in (0, 0, 1, 0):
            rows.append({'inputs': {**values, 'io_clock': clock}})
    return rows


def prepare(package_path, checkpoint_path, cycles, evidence):
    package = json.loads(package_path.read_text(encoding='utf-8'))
    checkpoint = json.loads(checkpoint_path.read_text(encoding='utf-8'))
    hashes = {name: item['sha256'] for name, item in package['sources'].items()}
    if package['hardware_sources_modified'] or checkpoint['identity']['source_files_sha256'] != hashes:
        raise ValueError('Expected the successful export of identical original RTL')
    before = checkpoint_path.parent / 'before.json'
    if digest(before) != checkpoint['companions']['before.json']:
        raise ValueError('Original RTL interface artifact changed')
    interface = ports(before, 'XSTop', reader())
    evidence.mkdir(parents=True)
    rtl = evidence / 'rtl'
    rtl.mkdir()
    for name, item in package['sources'].items():
        source = Path(item['source'])
        if digest(source) != item['sha256']:
            raise ValueError('Recorded original RTL changed: ' + str(source))
        target = (rtl / name).resolve()
        if not target.is_relative_to(rtl.resolve()):
            raise ValueError('RTL source path escapes the evidence directory')
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)
    metadata = {'top': 'XSTop', 'clocked': False, 'assertions': True,
        'rtl_sources': [name for name in sorted(hashes) if Path(name).suffix in {'.v', '.sv'}],
        'rtl_include_dirs': [str(rtl)], 'output_split': 10000, 'output_split_cfuncs': 5000,
        'output_groups': 0, 'optimization': 0,
        'ports': [{'name': name, 'rtl_name': name, 'width': len(port['bits']), 'direction': port['direction']}
                  for name, port in interface.items()]}
    metadata['initial_inputs'] = {p['name']: 0 for p in metadata['ports'] if p['direction'] == 'input'}
    trace = trace_for(interface, cycles)
    write(evidence / 'ports.json', metadata)
    write(evidence / 'trace.json', trace)
    prepared = {'status': 'PREPARED', 'source_files_sha256': hashes,
        'source_package': str(package_path), 'source_package_sha256': digest(package_path),
        'functional_checkpoint': str(checkpoint_path), 'functional_checkpoint_sha256': digest(checkpoint_path),
        'cycles': cycles, 'global_samples': len(trace), 'evidence': str(evidence),
        'scenario': 'Reset assertion/release, independent JTAG clock, stalled external AXI buses, aligned cacheability queries.',
        'choices': 'Unknown RTL initial/data bits zero; Lean caller selects zero for unknown bits and arbitrary inputs, retaining known sampling-state constraints.',
        'initialization_profile': 'caller-state', 'whole_instruction_execution': 'NOT_TESTED',
        'universal_equivalence': 'NOT_PROVED'}
    write(evidence / 'summary.json', prepared)
    return prepared


def reference(prepared):
    folder = Path(prepared['evidence'])
    metadata_path, trace_path = folder / 'ports.json', folder / 'trace.json'
    for name, expected in prepared['source_files_sha256'].items():
        if digest(folder / 'rtl' / name) != expected:
            raise ValueError('Original RTL source changed: ' + name)
    record = folder / 'reference.json'
    if record.is_file():
        cached = json.loads(record.read_text(encoding='utf-8'))
        if cached['status'] == 'PASS' and cached['metadata_sha256'] == digest(metadata_path) and cached['trace_sha256'] == digest(trace_path):
            result = Path(cached.get('execution_directory', str(folder / 'reference'))) / 'result.json'
            if digest(result) == cached['result_sha256']:
                return json.loads(result.read_text(encoding='utf-8'))
    metadata = json.loads(metadata_path.read_text(encoding='utf-8'))
    trace = json.loads(trace_path.read_text(encoding='utf-8'))
    prepared.update(status='RUNNING_RTL')
    write(folder / 'summary.json', prepared)
    attempt = dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ') + '-' + uuid.uuid4().hex[:8]
    execution = folder / 'reference' / attempt
    code, native = run_emitted_rtl(folder / 'rtl', metadata, trace, execution)
    if code:
        prepared.update(status='RTL_FAILED', rtl_exit_code=code)
        write(folder / 'summary.json', prepared)
        raise RuntimeError('Original whole XSTop RTL failed: ' + str(folder / 'reference'))
    cached = {'status': 'PASS', 'metadata_sha256': digest(metadata_path), 'trace_sha256': digest(trace_path),
              'result_sha256': digest(execution / 'result.json'), 'execution_directory': str(execution),
              'scope': 'Actual complete original RTL smoke execution; Lean comparison remains separate.'}
    write(record, cached)
    prepared.update(status='RTL_REFERENCE_PASS')
    write(folder / 'summary.json', prepared)
    return native


def lean_reference(prepared, model, native_runner=None):
    folder = Path(prepared['evidence'])
    manifest = json.loads((model / 'manifest.json').read_text(encoding='utf-8'))
    if not manifest['lean_checked'] or manifest['source_files_sha256'] != prepared['source_files_sha256']:
        raise ValueError('Expected a compiled model of the identical original RTL')
    trace = json.loads((folder / 'trace.json').read_text(encoding='utf-8'))
    fingerprint = {'model_manifest_sha256': digest(model / 'manifest.json'),
                   'trace_sha256': digest(folder / 'trace.json'),
                   'native_runner_manifest_sha256': digest(Path(native_runner) / 'manifest.json') if native_runner else None}
    record = folder / 'lean-reference.json'
    if record.is_file():
        cached = json.loads(record.read_text(encoding='utf-8'))
        result = Path(cached.get('execution_directory', str(folder / 'lean'))) / 'result.json'
        if cached['status'] == 'PASS' and all(cached[key] == value for key, value in fingerprint.items()) and digest(result) == cached['result_sha256']:
            return json.loads(result.read_text(encoding='utf-8'))
    write(folder / 'lean-progress.json', {'status': 'RUNNING', **fingerprint})
    interface_path = model / (manifest.get('interface') or manifest['ir'])
    from table_simulate import load_interface
    interface = load_interface(interface_path)
    choices = {field['name']: 0 for field in interface['arbitrary_inputs']}
    lean_trace = [{'inputs': {**row['inputs'], **choices}} for row in trace]
    if interface_path.name.endswith('.table.json') and interface_path.stat().st_size > 64 * 1024 * 1024:
        initial = {}
        with interface_path.open('rb') as stream:
            for field in reader().items(stream, 'states.item'):
                initial[field['name']] = field['initial']['value'] if field['sort']['kind'] == 'bits' else [word['value'] for word in field['initial']['words']]
    else:
        initial = experiment_initial(interface)
    del interface
    gc.collect()
    attempt = dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ') + '-' + uuid.uuid4().hex[:8]
    execution = folder / 'lean' / attempt
    code, actual = simulate_yosys(interface_path, lean_trace, initial, execution, native_runner)
    if code:
        write(folder / 'lean-progress.json', {'status': 'LEAN_FAILED', 'exit_code': code, **fingerprint})
        raise RuntimeError('Whole Lean replay failed: ' + str(folder / 'lean'))
    write(record, {'status': 'PASS', **fingerprint, 'result_sha256': digest(execution / 'result.json'), 'execution_directory': str(execution),
                   'scope': 'Actual whole-model Lean smoke execution; independent RTL comparison remains separate.'})
    return actual


def run(prepared, model, native_runner=None):
    folder = Path(prepared['evidence'])
    manifest = json.loads((model / 'manifest.json').read_text(encoding='utf-8'))
    metadata = json.loads((folder / 'ports.json').read_text(encoding='utf-8'))
    trace = json.loads((folder / 'trace.json').read_text(encoding='utf-8'))
    native = reference(prepared)
    actual = lean_reference(prepared, model, native_runner)
    comparison = compare_rows(actual, native, [p['name'] for p in metadata['ports'] if p['direction'] == 'output'], len(trace))
    if comparison['status'] != 'PASS':
        prepared.update(comparison)
        write(folder / 'summary.json', prepared)
        raise AssertionError('Whole XSTop comparison failed: ' + comparison['status'])
    for name, expected in prepared['source_files_sha256'].items():
        assert digest(folder / 'rtl' / name) == expected, 'Original hardware source changed: ' + name
    prepared.update(status='PASS', output_comparisons=comparison['output_comparisons'],
                    model_manifest_sha256=digest(model / 'manifest.json'), original_hardware_source_modified=False)
    write(folder / 'summary.json', prepared)
    write(ROOT / 'docs/validation-xiangshan-whole-differential-7.3.json', prepared)
    return prepared


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-package', type=Path)
    parser.add_argument('--functional-checkpoint', type=Path)
    parser.add_argument('--prepared', type=Path)
    parser.add_argument('--model', type=Path, default=ROOT / 'generated/xiangshan-whole')
    parser.add_argument('--cycles', type=int, default=24)
    parser.add_argument('--prepare-only', action='store_true')
    parser.add_argument('--reference-only', action='store_true')
    parser.add_argument('--lean-only', action='store_true')
    parser.add_argument('--native-runner', type=Path)
    parser.add_argument('--rtl-jobs', type=int, help='Limit original RTL compiler parallelism')
    parser.add_argument('--evidence', type=Path, default=ROOT / 'experiments/xiangshan-whole-differential-7.3')
    args = parser.parse_args()
    if args.rtl_jobs is not None and args.rtl_jobs < 1:
        parser.error('RTL jobs must be positive')
    if args.prepared:
        prepared = json.loads((args.prepared.resolve() / 'summary.json').read_text(encoding='utf-8'))
    else:
        if not args.source_package or not args.functional_checkpoint or args.cycles < 12:
            parser.error('Provide source package, successful FunctionalIR checkpoint, and at least 12 cycles')
        attempt = dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ') + '-' + uuid.uuid4().hex[:8]
        prepared = prepare(args.source_package.resolve(), args.functional_checkpoint.resolve(), args.cycles,
                           args.evidence.resolve() / attempt)
    metadata_path = Path(prepared['evidence']) / 'ports.json'
    metadata = json.loads(metadata_path.read_text(encoding='utf-8'))
    previous = dict(metadata)
    if args.rtl_jobs is not None:
        metadata['jobs'] = args.rtl_jobs
    # Recent Verilator defaults concatenate the split files into build-job
    # groups. For XSTop those groups are hundreds of MB each; keep the splits.
    metadata['output_groups'] = 0
    metadata.setdefault('initial_inputs', {p['name']: 0 for p in metadata['ports'] if p['direction'] == 'input'})
    if metadata != previous:
        write(metadata_path, metadata)
    if args.lean_only:
        actual = lean_reference(prepared, args.model.resolve(), args.native_runner)
        prepared = {**prepared, 'status': 'LEAN_EXECUTED', 'samples_executed': len(actual)}
    elif args.reference_only:
        reference(prepared)
    elif not args.prepare_only:
        prepared = run(prepared, args.model.resolve(), args.native_runner)
    print(json.dumps({key: prepared[key] for key in ('status', 'global_samples', 'evidence')}, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
