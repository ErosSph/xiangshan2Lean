"""Execute the actual XiangShan utility SramArray1P/2P implementations through Lean."""
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
import json
import random

from common import ROOT, run_logged, sbt_command
from elaborate_chisel import elaborate
from rtl import run_emitted_rtl
from yosys2lean import digest, translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--skip-build', action='store_true')
    args = parser.parse_args()
    folder = ROOT / 'experiments/xiangshan-sram-7.3'
    if not args.skip_build:
        command, env = sbt_command(['xiangshanFramework/writeXiangshanClasspath'])
        if code := run_logged(command, folder / 'build', env=env, echo=False):
            return code
    results = []
    for single in (True, False):
        name = 'SramArray1P' if single else 'SramArray2P'
        case = folder / name
        rtl = case / 'original'
        provenance = elaborate('xiangshan.validation.SramArrayValidation', [single],
                               ROOT / '.cache/xiangshan-classpath.txt', rtl, case / 'elaboration')
        metadata = json.loads((rtl / 'ports.json').read_text(encoding='utf-8'))
        relative = translate_yosys(rtl / (metadata['top'] + '.v'), case / 'model', metadata['top'],
                                   'SRAM.' + name, evidence=case / 'translation', clock_mode='global')
        path = case / 'model' / relative
        ir = json.loads(path.read_text(encoding='utf-8'))
        assert ir['hardware']['memory_cells'] > 0, 'Original SRAM was not retained as memory'
        rng = random.Random(73161 + int(single))
        values = dict(rclk=0, wclk=0, ren=0, wen=0, raddr=0, waddr=0, data=0, mask=0)
        rows = []
        def step(**updates):
            values.update(updates)
            rows.append({'inputs': dict(values)})
        step()
        for index in range(160):
            step(rclk=0, wclk=0)
            write_address = index % 8 if index < 8 else rng.randrange(8)
            read_address = (write_address + rng.randrange(1, 8)) % 8
            step(ren=int(index >= 8), wen=int(index < 8 or rng.randrange(3) > 0),
                 raddr=read_address, waddr=write_address, data=rng.randrange(65536),
                 mask=3 if index < 8 else rng.randrange(4))
            step()
            if single or index % 3 == 0:
                step(rclk=1, wclk=1)
            elif index % 3 == 1:
                step(wclk=1)
                step(rclk=1)
            else:
                step(rclk=1)
                step(wclk=1)
            step()
        mapping = {p['name']: p['rtl_name'] for p in metadata['ports']}
        lean_rows = []
        for row in rows:
            inputs = {p['name']: 0 for p in ir['inputs']}
            inputs.update({mapping[n]: v for n, v in row['inputs'].items()})
            lean_rows.append({'inputs': inputs})
        code, actual = simulate_yosys(path, lean_rows, experiment_initial(ir), case / 'lean')
        if code:
            raise RuntimeError('Actual SRAM Lean execution failed: ' + str(case / 'lean/execution'))
        code, native = run_emitted_rtl(rtl, metadata, rows, case / 'reference')
        if code:
            raise RuntimeError('Actual SRAM Verilator execution failed: ' + str(case / 'reference'))
        assert len(actual) == len(native) == len(rows)
        for index, (a, b) in enumerate(zip(actual, native)):
            expected = {mapping[n]: value for n, value in b['post'].items()}
            if a['post'] != expected:
                raise AssertionError({'case': name, 'step': index, 'inputs': rows[index],
                                      'lean': a['post'], 'rtl': expected})
        result = {'case': name, 'status': 'PASS', 'steps': len(rows), 'output_comparisons': len(rows),
                  'hardware': ir['hardware'], 'official_elaboration': provenance}
        write(case / 'summary.json', result)
        results.append(result)
        print('PASS ' + name + ': ' + str(len(rows)) + ' explicit sampling steps', flush=True)
    original = ROOT / '.cache/xiangshan-dependencies-7.3/utility/src/main/scala/utility/sram/SramProto.scala'
    report = {'status': 'PASS', 'original_source_sha256': digest(original), 'cases': results,
              'scope': 'Actual unmodified utility SramArray1P and SramArray2P, depth 8, width 16, two byte masks; independent read/write clocks for 2P. Read/write same-address conflicts are avoided. Unknown initial state and arbitrary values are explicitly zero in this experiment; finite differential tests, not a universal proof.'}
    write(folder / 'summary.json', report)
    write(ROOT / 'docs/validation-xiangshan-sram-7.3.json', report)
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
