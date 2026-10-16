"""Check root-only flattening on deep hierarchy and registered cross-feedback."""
from __future__ import annotations

import argparse
import json
import random

from common import ROOT
from rtl import run_emitted_rtl
from yosys2lean import translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--yosys-engine', choices=['native', 'wasm'], default='native')
    args = parser.parse_args()
    folder = ROOT / 'experiments/yosys-hierarchy-7.3'
    if args.yosys_engine == 'wasm':
        folder = folder / 'wasm'
    folder.mkdir(parents=True, exist_ok=True)
    source = folder / 'Nested.sv'
    source.write_text('''module Leaf(input clock,reset,en,input [7:0] d,output reg [7:0] q);
initial q=0;
always @(posedge clock) if(reset) q<=0; else if(en) q<=d+1;
endmodule
module Middle(input clock,reset,en,input [7:0] d,output [7:0] q);
Leaf leaf(.clock(clock),.reset(reset),.en(en),.d(d),.q(q));
endmodule
module Branch(input clock,reset,en,input [7:0] d,output [7:0] q);
Middle middle(.clock(clock),.reset(reset),.en(en),.d(d),.q(q));
endmodule
module Nested(input clock,reset,en,input [7:0] d,output [7:0] a,b);
Branch left(.clock(clock),.reset(reset),.en(en),.d(b+d),.q(a));
Branch right(.clock(clock),.reset(reset),.en(en),.d(a^d),.q(b));
endmodule
''', encoding='utf-8')
    relative = translate_yosys(source, folder / 'model', 'Nested', 'Hierarchy.Nested',
                               evidence=folder / 'translation', keep_hierarchy=True,
                               yosys_engine=args.yosys_engine, json_io='stream')
    path = folder / 'model' / relative
    ir = json.loads(path.read_text(encoding='utf-8'))
    normalized = json.loads((folder / 'model/before.json').read_text(encoding='utf-8'))
    assert list(normalized['modules']) == ['Nested']
    assert all(cell['type'].startswith('$') for cell in normalized['modules']['Nested']['cells'].values())
    rng = random.Random(731015)
    rows = [{'inputs': {'reset': int(i % 19 == 0), 'en': rng.randrange(2), 'd': rng.randrange(256)}} for i in range(96)]
    lean_rows = [{'inputs': {**r['inputs'], **{p['name']: 0 for p in ir['arbitrary_inputs']}}} for r in rows]
    code, actual = simulate_yosys(path, lean_rows, experiment_initial(ir), folder / 'lean')
    assert code == 0
    metadata = {'top': 'Nested', 'clocked': True, 'rtl_sources': ['Nested.sv'],
                'ports': [{'name': n, 'rtl_name': n, 'width': w, 'direction': 'output' if n in {'a', 'b'} else 'input'}
                          for n,w in [('clock',1),('reset',1),('en',1),('d',8),('a',8),('b',8)]]}
    native_rows = [{'reset': r['inputs']['reset'],
                    'inputs': {n: v for n, v in r['inputs'].items() if n != 'reset'}} for r in rows]
    code, native = run_emitted_rtl(folder, metadata, native_rows, folder / 'reference')
    assert code == 0
    a = b = 0
    assert len(rows) == len(actual) == len(native)
    for row, lean, rtl in zip(rows, actual, native):
        assert lean['pre'] == rtl['pre'] == {'a': a, 'b': b}
        inputs = row['inputs']
        if inputs['reset']:
            a = b = 0
        elif inputs['en']:
            a, b = (b + inputs['d'] + 1) % 256, ((a ^ inputs['d']) + 1) % 256
        assert lean['post'] == rtl['post'] == {'a': a, 'b': b}
    result = {'status': 'PASS', 'module_levels': 4, 'cycles': len(rows), 'output_comparisons': len(rows) * 4,
              'yosys_engine': args.yosys_engine,
              'scope': 'Root-only official flattening, repeated child types, and registered cross-feedback; real Lean, unmodified native RTL and simultaneous-update integer oracle.'}
    write(folder / 'summary.json', result)
    write(ROOT / ('docs/validation-yosys-hierarchy-wasm-7.3.json' if args.yosys_engine == 'wasm'
                  else 'docs/validation-yosys-hierarchy-7.3.json'), result)
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
