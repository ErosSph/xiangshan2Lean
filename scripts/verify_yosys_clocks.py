"""Compare explicit multi-clock sampling, clock gates, latches and async reset with RTL."""
from __future__ import annotations

import json
import random

from common import ROOT
from rtl import run_emitted_rtl
from yosys2lean import digest, translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def main():
    folder = ROOT / 'experiments/yosys-clocks-7.3'
    folder.mkdir(parents=True, exist_ok=True)
    source = folder / 'Clocks.sv'
    source.write_text('''module Clocks(
  input c1, c2, reset, latch_en, gate_en,
  input [7:0] d,
  output reg [7:0] p, n, a, l, g, crossed);
reg gate_open;
initial begin p=0; n=0; a=0; l=0; g=0; crossed=0; gate_open=0; end
always @(posedge c1) begin p <= d; crossed <= n; end
always @(negedge c2) n <= d;
always @(posedge c1 or posedge reset) if(reset) a <= 0; else a <= d;
always_latch if(latch_en) l <= d;
always_latch if(!c1) gate_open <= gate_en;
wire gated_clock = c1 & gate_open;
always @(posedge gated_clock) g <= d;
endmodule
''', encoding='utf-8')
    relative = translate_yosys(source, folder / 'model', 'Clocks', 'Clocks.All',
                               evidence=folder / 'translation', clock_mode='global')
    path = folder / 'model' / relative
    ir = json.loads(path.read_text(encoding='utf-8'))
    assert ir['clock_mode'] == 'global' and ir['clock'] is None
    rng = random.Random(730151)
    current = dict(c1=0, c2=1, reset=1, latch_en=0, gate_en=0, d=0)
    rows = []
    def step(**updates):
        current.update(updates)
        rows.append({'inputs': dict(current)})
    # Data/control settle before each clock edge; reset release is separated from edges.
    step()
    step(reset=0)
    step()
    for cycle in range(128):
        step(c1=0, c2=1)
        step(d=rng.randrange(256), gate_en=rng.randrange(2), latch_en=rng.randrange(2))
        step()
        if cycle % 9 == 0:
            step(reset=1)  # asynchronous assertion, neither active edge
            step()
            step(reset=0)
            step()
        if cycle % 3 == 0:
            step(c1=1, c2=0)  # simultaneous active edges must read old n
        elif cycle % 3 == 1:
            step(c2=0)
            step(c1=1)
        else:
            step(c1=1)
            step(c2=0)
        step()
        step(d=rng.randrange(256))  # exercise a transparent and a closed latch
        step()
        if cycle % 7 == 0:
            step(reset=1)  # asynchronous assertion while c1 remains high
            step()
            step(reset=0)
            step()
    lean_rows = [{'inputs': {**row['inputs'], **{p['name']: 0 for p in ir['arbitrary_inputs']}}}
                 for row in rows]
    code, lean = simulate_yosys(path, lean_rows, experiment_initial(ir), folder / 'lean')
    if code:
        raise RuntimeError('Global-clock Lean execution failed: ' + str(folder / 'lean/execution'))
    widths = {**{n: 1 for n in ('c1', 'c2', 'reset', 'latch_en', 'gate_en')},
              **{n: 8 for n in ('d', 'p', 'n', 'a', 'l', 'g', 'crossed')}}
    metadata = {'top': 'Clocks', 'clocked': False, 'rtl_sources': ['Clocks.sv'], 'ports': [
        {'name': n, 'rtl_name': n, 'width': w,
         'direction': 'output' if n in {'p', 'n', 'a', 'l', 'g', 'crossed'} else 'input'}
        for n, w in widths.items()]}
    code, native = run_emitted_rtl(folder, metadata, rows, folder / 'reference')
    if code:
        raise RuntimeError('Global-clock RTL execution failed: ' + str(folder / 'reference'))
    state = dict(p=0, n=0, a=0, l=0, g=0, crossed=0)
    previous = dict(c1=0, c2=0, reset=0, gated_clock=0)
    gate_open = 0
    for index, (row, actual, golden) in enumerate(zip(rows, lean, native)):
        i = row['inputs']
        pos = i['c1'] and not previous['c1']
        neg = not i['c2'] and previous['c2']
        reset_edge = i['reset'] and not previous['reset']
        if not i['c1']:
            gate_open = i['gate_en']
        gated_clock = i['c1'] and gate_open
        old_n = state['n']
        if pos:
            state.update(p=i['d'], crossed=old_n)
        if neg:
            state['n'] = i['d']
        if pos or reset_edge:
            state['a'] = 0 if i['reset'] else i['d']
        if i['latch_en']:
            state['l'] = i['d']
        if gated_clock and not previous['gated_clock']:
            state['g'] = i['d']
        if actual['post'] != golden['post'] or golden['post'] != state:
            raise AssertionError({'step': index, 'inputs': i, 'lean': actual['post'],
                                  'rtl': golden['post'], 'integer': dict(state)})
        previous = {**i, 'gated_clock': gated_clock}
    report = {'status': 'PASS', 'steps': len(rows), 'output_comparisons': len(rows) * 6,
              'source_sha256': digest(source), 'reader_sha256': digest(ROOT / 'scripts/functional_ir.py'),
              'features': ['two independent clocks', 'negative edge', 'simultaneous old-state reads',
                           'asynchronous reset', 'transparent latch', 'latch-based clock gate'],
              'contract': 'Explicit global sampling steps. Data and gate controls settle before active edges; reset release is separated from active edges. Unknown initial bits and arbitrary inputs are explicitly zero in this experiment.',
              'scope': 'Generated Lean executed and compared with independent Verilator and integer model; finite traces, not arbitrary-delay or universal equivalence.'}
    write(folder / 'summary.json', report)
    write(ROOT / 'docs/validation-yosys-clocks-7.3.json', report)
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
