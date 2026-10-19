"""Run one finite original-RTL / official-Spike / generated-Lean acceptance."""
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
from pathlib import Path

from replay_xiangshan_retirement import replay
from server_bundle import read, write
from xiangshan_isa import run as run_isa
from xiangshan_program import run as run_program
from yosys_hierarchy import digest


def validate(bundle, work, spike, model, runner, validation, program=None, existing=None,
             cycles=50000, dram_text=False, interrupt=False, writeback=False):
    engine = read(runner / 'manifest.json')
    regression = read(validation)
    if regression.get('status') != 'PASS' or regression.get('runner_manifest_sha256') != digest(runner / 'manifest.json'):
        raise ValueError('A successful matching Lean runner regression is required')
    if digest(Path(engine['executable'])) != engine['executable_sha256']:
        raise ValueError('Lean runner executable changed')
    case = existing or run_program(bundle, work, cycles, True, program, dram_text, interrupt)
    print('ACCEPTANCE_PROGRAM_DIRECTORY='+str(case), flush=True)
    target = case / 'program-acceptance.json'
    if target.exists():
        raise FileExistsError('Preserve the previous program acceptance: '+str(target))
    report = {'status':'RUNNING', 'case':str(case), 'original_hardware_modified':False,
              'universal_equivalence':'NOT_PROVED', 'scope':'One finite program, fixed configuration and explicit initial/interface choices.'}
    write(target, report)
    try:
        isa_path = case / 'isa-comparison/summary.json'
        isa = read(isa_path) if isa_path.exists() else run_isa(case, spike, writeback)
        if writeback and isa.get('memory_writeback_comparison', {}).get('status') != 'PASS':
            raise ValueError('This acceptance requires a completed external writeback comparison')
        lean_path = case / 'lean-retirement-replay/summary.json'
        lean = read(lean_path) if lean_path.exists() else replay(bundle, model, case, runner, validation)
        if isa.get('status') != 'RTL_SPIKE_PC_GPR_PASS' or lean.get('status') != 'RTL_LEAN_RETIREMENT_PASS':
            raise ValueError('All stages must have completed successfully; a running stage is not a pass')
        # Bind the successful receipts to the same actual program and retirement trace.
        if (isa['rtl_commits_sha256'] != digest(case / 'commits.csv') or
            isa['program_sha256'] != digest(case / 'program.bin') or
            lean['isa_reference_sha256'] != digest(isa_path) or
            lean['rtl_trace_sha256']['commits.csv'] != isa['rtl_commits_sha256'] or
            lean['program_elf_sha256'] != digest(case / 'program.elf') or
            lean['model_manifest_sha256'] != digest(model / 'manifest.json') or
            lean['runner_manifest_sha256'] != digest(runner / 'manifest.json') or
            lean['runner_validation_sha256'] != digest(validation)):
            raise ValueError('Successful receipts do not belong to the same program/model/runner')
        report.update(status='RTL_LEAN_SPIKE_PROGRAM_PASS',
            receipts={str(path):digest(path) for path in [case/'execution.json', isa_path, lean_path]},
            samples=lean['samples'], committed_instructions=isa['committed_instructions'],
            physical_outputs=lean['physical_outputs'], read_only_taps=lean['read_only_taps'],
            external_interrupt_interleaving=isa.get('external_interrupt_interleaving'),
            memory_writeback_comparison=isa.get('memory_writeback_comparison'),
            full_isa_coverage='NOT_ESTABLISHED', universal_equivalence='NOT_PROVED')
        write(target, report)
        print('RTL_LEAN_SPIKE_PROGRAM_PASS '+str(target), flush=True)
        return report
    except BaseException as error:
        report.update(status='FAILED', error=f'{type(error).__name__}: {error}')
        write(target, report)
        raise


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ['bundle','work','spike','model','runner','validation']:
        parser.add_argument('--'+name, type=Path, required=True)
    choice = parser.add_mutually_exclusive_group(required=True)
    choice.add_argument('--program', type=Path, help='New test: assembly source')
    choice.add_argument('--existing-program', type=Path, help='Previously recorded observed RTL test')
    parser.add_argument('--cycles', type=int, default=50000)
    parser.add_argument('--dram-text', action='store_true')
    parser.add_argument('--irq-on-read-wait', action='store_true')
    parser.add_argument('--verify-writeback', action='store_true')
    args = parser.parse_args()
    if args.cycles < 33:
        parser.error('Allow reset and active cycles')
    if args.existing_program and (args.dram_text or args.irq_on_read_wait):
        parser.error('Existing RTL traces retain their recorded environment; do not supply new environment flags')
    validate(*(getattr(args,name).resolve() for name in ['bundle','work','spike','model','runner','validation']),
             program=args.program.resolve() if args.program else None,
             existing=args.existing_program.resolve() if args.existing_program else None,
             cycles=args.cycles, dram_text=args.dram_text, interrupt=args.irq_on_read_wait, writeback=args.verify_writeback)


if __name__ == '__main__':
    main()
