"""Record whole-XiangShan stage coverage without confusing elaboration with verification."""
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
import json
from pathlib import Path

from common import ROOT
from elaborate_xiangshan import digest, inventory_firrtl, write


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('elaboration', type=Path)
    parser.add_argument('--lowering', type=Path)
    parser.add_argument('--conversion', type=Path)
    parser.add_argument('--rtl-import', type=Path, help='Successful whole-top native import report')
    parser.add_argument('--refresh-inventory', action='store_true')
    args = parser.parse_args()
    elaboration = json.loads(args.elaboration.read_text(encoding='utf-8'))
    if elaboration['status'] != 'PASS':
        raise ValueError('Expected successful official top-level elaboration')
    origin = Path(elaboration['evidence'])
    name = next(n for n in elaboration['files'] if n.endswith('.fir'))
    source = origin / name
    if digest(source) != elaboration['files'][name]['sha256']:
        raise ValueError('Official FIRRTL differs from recorded successful generation')
    inventory_path = origin / 'module-inventory-v2.json'
    if args.refresh_inventory or not inventory_path.is_file():
        print('Inventorying original complete FIRRTL declarations and verification intrinsics', flush=True)
        inventory = inventory_firrtl(source)
        write(inventory_path, inventory)
    else:
        inventory = json.loads(inventory_path.read_text(encoding='utf-8'))
    externals = Counter(m.get('defname', m['name']) for m in inventory['modules'] if m['kind'] == 'extmodule')
    stages = {'official_elaboration': 'PASS', 'native_rtl_lowering': 'NOT_RUN',
              'whole_top_hierarchical_rtl_import': 'NOT_RUN',
              'whole_top_flat_rtl_normalization': 'NOT_REACHED',
              'whole_top_clock_lowering': 'NOT_REACHED', 'whole_top_transfer_export': 'NOT_REACHED',
              'whole_top_lean_compilation': 'NOT_RUN', 'whole_top_rtl_differential': 'NOT_RUN',
              'whole_top_universal_equivalence': 'NOT_PROVED'}
    if args.lowering:
        lowering = json.loads(args.lowering.read_text(encoding='utf-8'))
        if lowering['source_sha256'] != elaboration['files'][name]['sha256']:
            raise ValueError('Native lowering and elaboration refer to different circuits')
        stages['native_rtl_lowering'] = lowering['status']
    if args.rtl_import:
        imported = json.loads(args.rtl_import.read_text(encoding='utf-8'))
        if imported['firrtl_sha256'] != elaboration['files'][name]['sha256'] or imported['config'] != elaboration['config'] or imported['cores'] != elaboration['cores']:
            raise ValueError('Whole-top RTL import and elaboration refer to different circuits')
        stages['whole_top_hierarchical_rtl_import'] = imported['status']
    conversion_detail = None
    if args.conversion:
        conversion = json.loads(args.conversion.read_text(encoding='utf-8'))
        if conversion['config'] != elaboration['config'] or conversion['cores'] != elaboration['cores']:
            raise ValueError('Conversion scope differs from official generation')
        stages['whole_top_lean_compilation'] = conversion['lean_compilation']
        attempts = sorted((Path(conversion['evidence']) / 'translation').glob('*'))
        active = attempts[-1] if attempts else None
        actual_codes = dict(conversion.get('tool_exit_codes', {}))
        reused = set(conversion.get('reused_stages', []))
        if active:
            # During long runs summary.json is still RUNNING. Only count real
            # completed commands or a successfully validated reuse as passed.
            for result in active.glob('*/result.json'):
                actual_codes[result.parent.name] = json.loads(result.read_text(encoding='utf-8'))['exit_code']
            reused.update(p.parent.name for p in active.glob('*/reused.json'))
            for check_name in ('lean-check', 'lean-standalone-check'):
                if check_name in actual_codes:
                    stages['whole_top_lean_compilation'] = 'PASS' if actual_codes[check_name] == 0 else 'FAIL'
                    break
                elif (active / check_name / 'command.json').exists():
                    stages['whole_top_lean_compilation'] = 'RUNNING'
                    break
        for tool, stage in [('yosys-prepare', 'whole_top_flat_rtl_normalization'),
                            ('yosys-functional', 'whole_top_clock_lowering'),
                            ('yosys-export', 'whole_top_transfer_export')]:
            code = actual_codes.get(tool)
            if code is not None:
                stages[stage] = 'PASS' if code == 0 else 'FAIL'
            elif tool in reused:
                stages[stage] = 'PASS'
            elif active and (active / tool / 'command.json').exists():
                stages[stage] = 'RUNNING'
            elif conversion['lean_compilation'] == 'PASS':
                stages[stage] = 'PASS'
        conversion_detail = {k: conversion[k] for k in ('status', 'diagnostic', 'blocking_diagnostics', 'tool_exit_codes') if k in conversion}
        conversion_detail.update(tool_exit_codes=actual_codes, reused_stages=sorted(reused))
    report = {'format': 'xiangshan-whole-coverage-v1', 'config': elaboration['config'], 'cores': elaboration['cores'],
              'upstream_commit': elaboration['upstream_sources']['dependencies'][0]['commit'],
              'hardware_sources_modified': False, 'firrtl_sha256': elaboration['files'][name]['sha256'],
              'stages': stages, 'inventory': {k: v for k, v in inventory.items() if k != 'modules'},
              'conversion_detail': conversion_detail,
              'external_definition_counts': dict(externals), 'full_inventory': str(inventory_path),
              'evidence': {'elaboration': str(args.elaboration.resolve()),
                           'lowering': str(args.lowering.resolve()) if args.lowering else None,
                           'rtl_import': str(args.rtl_import.resolve()) if args.rtl_import else None,
                           'conversion': str(args.conversion.resolve()) if args.conversion else None},
              'scope': 'Fixed DefaultConfig/one core only when so configured. Declaration counts include pre-dedup and aggregate declarations. No module becomes Lean-verified merely by being listed or by passing Chisel/firtool.'}
    write(origin / 'coverage.json', report)
    write(ROOT / 'docs/validation-xiangshan-full-7.3.json', report)
    print(json.dumps(report, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
