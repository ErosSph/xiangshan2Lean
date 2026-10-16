"""Check grouped inputs, state, outputs and effect fields using a real wide interface."""
from __future__ import annotations

import json

from common import ROOT
from rtl import run_emitted_rtl
from yosys2lean import translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def main():
    folder = ROOT / 'experiments/yosys-records-7.3'
    folder.mkdir(parents=True, exist_ok=True)
    count = 160
    ports = ['input clock, reset, en']
    ports += [f'input [7:0] d{i}, expected{i}' for i in range(count)]
    ports += [f'output reg [7:0] q{i}' for i in range(count)]
    body = [f'initial q{i}=0; always @(posedge clock) begin '
            f'if(reset) q{i}<=0; else if(en) q{i}<=d{i}; '
            f'if(!reset) assert(q{i}==expected{i}); end' for i in range(count)]
    source = folder / 'Many.sv'
    source.write_text('module Many(' + ',\n'.join(ports) + ');\n' + '\n'.join(body) + '\nendmodule\n', encoding='utf-8')
    relative = translate_yosys(source, folder / 'model', 'Many', 'Records.Many',
                               evidence=folder / 'translation', preserve_effects=True)
    path = folder / 'model' / relative
    ir = json.loads(path.read_text(encoding='utf-8'))
    assert all(any('.' in p for p in ir['lean_field_paths'][kind].values()) for kind in ('inputs', 'states', 'outputs'))
    rows, specifications, state = [], [], [0] * count
    for cycle in range(8):
        inputs = {'en': int(cycle % 3 != 0)}
        inputs.update({f'd{i}': (cycle * 19 + i * 7) % 256 for i in range(count)})
        inputs.update({f'expected{i}': state[i] for i in range(count)})
        reset = int(cycle in (0, 5))
        rows.append({'reset': reset, 'inputs': inputs})
        pre = {f'q{i}': state[i] for i in range(count)}
        state = [0] * count if reset else [inputs[f'd{i}'] for i in range(count)] if inputs['en'] else state
        specifications.append({'pre': pre, 'post': {f'q{i}': state[i] for i in range(count)}})
    def lean_trace(trace):
        return [{'inputs': {'reset': row['reset'], **row['inputs'],
                            **{p['name']: 0 for p in ir['arbitrary_inputs']}}} for row in trace]
    code, actual = simulate_yosys(path, lean_trace(rows), experiment_initial(ir), folder / 'lean')
    assert code == 0, 'Grouped model did not execute'
    widths = {'clock': 1, 'reset': 1, 'en': 1,
              **{n: 8 for i in range(count) for n in (f'd{i}', f'expected{i}', f'q{i}')}}
    metadata = {'top': 'Many', 'clocked': True, 'assertions': True, 'rtl_sources': ['Many.sv'],
                'ports': [{'name': n, 'rtl_name': n, 'width': w,
                           'direction': 'output' if n.startswith('q') else 'input'} for n, w in widths.items()]}
    code, native = run_emitted_rtl(folder, metadata, rows, folder / 'reference')
    assert code == 0
    for index, (a, b, expected) in enumerate(zip(actual, native, specifications)):
        assert a['pre'] == b['pre'] == expected['pre'], index
        assert a['post'] == b['post'] == expected['post'], index
    bad = json.loads(json.dumps(rows[:2]))
    bad[1]['inputs']['expected159'] ^= 1
    a, _ = simulate_yosys(path, lean_trace(bad), experiment_initial(ir), folder / 'bad-lean')
    b, _ = run_emitted_rtl(folder, metadata, bad, folder / 'bad-reference')
    assert a != 0 and b == 7, (a, b)
    report = {'status': 'PASS', 'cycles': len(rows), 'output_comparisons': len(rows) * count * 2,
              'fields': {kind: len(ir[kind]) for kind in ('inputs', 'states', 'outputs')},
              'assertion_violation_detected_by_both': True,
              'scope': 'Grouped input clock update, state decoding, hardware output encoding and 160 preserved assertions; actual Lean, Verilator and integer comparison.'}
    write(folder / 'summary.json', report)
    write(ROOT / 'docs/validation-yosys-records-7.3.json', report)
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
