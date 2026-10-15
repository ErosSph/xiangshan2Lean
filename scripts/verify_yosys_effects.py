"""Check preserved clocked assertions, assumptions, coverage, and print events against RTL."""
from __future__ import annotations

import json
from pathlib import Path
import random

from common import ROOT
from rtl import run_emitted_rtl
from yosys2lean import translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def main():
    base = ROOT / 'experiments/yosys-effects-7.3'
    base.mkdir(parents=True, exist_ok=True)
    source = '''module Observed(input clock, reset, en, input [3:0] d, expected, output reg [3:0] q);
initial q = 0;
always @(posedge clock) begin
  if (reset) q <= 0; else if (en) q <= d;
  if (!reset) begin
    assert(q == expected);
    assume(d < 12);
    cover(q == 3);
    $display("OBS q=%0d d=%0d", q, d);
  end
end
endmodule
'''
    folder = base / 'Observed'
    folder.mkdir(parents=True, exist_ok=True)
    rtl = folder / 'Observed.v'
    rtl.write_text(source, encoding='utf-8')
    relative = translate_yosys(rtl, folder / 'model', 'Observed', 'Effects.Observed',
                               evidence=folder / 'translation', preserve_effects=True)
    path = folder / 'model' / relative
    ir = json.loads(path.read_text(encoding='utf-8'))
    assert {e['kind'] for e in ir['effects']} >= {'assert', 'assume', 'cover', 'print'}
    rng = random.Random(71003)
    trace, reference, q = [], [], 0
    for cycle in range(160):
        reset = int(cycle % 37 == 0)
        inputs = {'en': rng.randrange(2), 'd': rng.randrange(12), 'expected': q}
        if cycle == 1:
            inputs.update(en=1, d=3)
        trace.append({'reset': reset, 'inputs': inputs})
        pre = q
        q = 0 if reset else inputs['d'] if inputs['en'] else q
        reference.append({'pre': {'q': pre}, 'post': {'q': q}})
    def lean_rows(rows):
        return [{'inputs': {'reset': row['reset'], **row['inputs'],
                **{a['name']: 0 for a in ir['arbitrary_inputs']}}} for row in rows]
    code, lean = simulate_yosys(path, lean_rows(trace), experiment_initial(ir), folder / 'valid-lean')
    if code:
        raise RuntimeError('Valid checked Lean execution failed: ' + str(folder / 'valid-lean/execution'))
    widths = {'clock': 1, 'reset': 1, 'en': 1, 'd': 4, 'expected': 4, 'q': 4}
    metadata = {'top': 'Observed', 'clocked': True, 'assertions': True,
                'ports': [{'name': n, 'rtl_name': n, 'width': w,
                           'direction': 'output' if n == 'q' else 'input'} for n, w in widths.items()]}
    code, native = run_emitted_rtl(folder, metadata, trace, folder / 'valid-rtl')
    if code:
        raise RuntimeError('RTL check run failed: ' + str(folder / 'valid-rtl'))
    for cycle, (row, actual, golden, expected) in enumerate(zip(trace, lean, native, reference)):
        assert actual['pre'] == golden['pre'] == expected['pre'], cycle
        assert actual['post'] == golden['post'] == expected['post'], cycle
        assert not actual['effects_pre'], cycle
        events = actual['effects_post']
        if row['reset']:
            assert not events, cycle
        else:
            assert {e['kind'] for e in events} >= {'assert', 'assume', 'cover', 'print'}, cycle
            cover = next(e for e in events if e['kind'] == 'cover')
            assert cover['condition'] == int(expected['pre']['q'] == 3), cycle
    print_lines = [line for line in (folder / 'valid-rtl/verilator-run/stdout.log').read_text().splitlines()
                   if line.startswith('OBS ')]
    expected_lines = [f"OBS q={r['pre']['q']} d={t['inputs']['d']}" for t, r in zip(trace, reference) if not t['reset']]
    assert print_lines == expected_lines
    results = [{'case': 'clocked-checks-and-events', 'status': 'PASS', 'cycles': len(trace),
                'output_comparisons': 2 * len(trace), 'print_events': len(print_lines)}]
    for kind in ('assert', 'assume'):
        bad = json.loads(json.dumps(trace[:3]))
        bad[1]['inputs']['expected' if kind == 'assert' else 'd'] = 1 if kind == 'assert' else 15
        code, _ = simulate_yosys(path, lean_rows(bad), experiment_initial(ir), folder / (kind + '-lean'))
        log = (folder / (kind + '-lean') / 'execution/stdout.log').read_text()
        log += (folder / (kind + '-lean') / 'execution/stderr.log').read_text()
        assert code != 0 and kind + ' failed' in log, kind
        code, _ = run_emitted_rtl(folder, metadata, bad, folder / (kind + '-rtl'))
        assert code == 7, (kind, code)
        results.append({'case': kind + '-violation-detected-by-both-executors', 'status': 'PASS'})
    folder = base / 'DisabledCheck'
    folder.mkdir(parents=True, exist_ok=True)
    rtl = folder / 'T.v'
    rtl.write_text('module T(input en,input [3:0] a,b,output q); assign q=1; always_comb if(en) assert(a/b>0); endmodule', encoding='utf-8')
    relative = translate_yosys(rtl, folder / 'model', 'T', 'Effects.DisabledCheck',
                               evidence=folder / 'translation', preserve_effects=True)
    path = folder / 'model' / relative
    ir = json.loads(path.read_text())
    rows = [{'inputs': {'en': 0, 'a': 0, 'b': 0}}, {'inputs': {'en': 1, 'a': 9, 'b': 2}}]
    code, _ = simulate_yosys(path, rows, experiment_initial(ir), folder / 'lean')
    assert code == 0, 'Disabled check incorrectly observes division by zero'
    results.append({'case': 'disabled-check-does-not-observe-undefined-condition', 'status': 'PASS'})
    report = {'status': 'PASS', 'cases': results, 'effect_contract': 'Official chformal/clk2fflogic lowering. Enabled checks inspect pre-NBA values. Assertions and assumptions reject execution on failure; cover conditions and print arguments are retained as observations.',
              'scope': 'Single direct positive-edge clock and combinational effects. Generic DPI/system tasks and temporal SVA are not covered.'}
    write(base / 'summary.json', report)
    write(ROOT / 'docs/validation-yosys-effects-7.3.json', report)
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
