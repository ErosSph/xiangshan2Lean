"""Validate official exposure cuts, literal prints and failing properties."""
from __future__ import annotations

import json

from common import ROOT
from rtl import run_emitted_rtl
from yosys2lean import digest, translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def main():
    folder = ROOT / 'experiments/yosys-exposure-7.3'
    folder.mkdir(parents=True, exist_ok=True)
    source = folder / 'Observed.sv'
    source.write_text('''module Observed(input clock,reset,en,input [3:0] d,output reg [3:0] q);
initial q=0;
always @(posedge clock) if(reset) q<=0; else if(en) q<=d;
always @(posedge clock) if(!reset && en) begin
  assert(d!=15);
  assume(d<15);
  cover(d==7);
  $display("LITERAL");
  $fwrite(32'h80000001,"VALUE=%0d\\n",q);
end
endmodule
''', encoding='utf-8')
    original = digest(source)
    relative = translate_yosys(source, folder / 'model', 'Observed', 'Exposure.Observed',
        evidence=folder / 'translation', preserve_effects=True, stdio_compat=True,
        yosys_engine='native', json_io='stream')
    assert digest(source) == original
    path = folder / 'model' / relative
    ir = json.loads(path.read_text(encoding='utf-8'))
    effects = {e['index']: e for e in ir['effects']}
    literal = next(e for e in effects.values() if e['kind'] == 'print' and e['format'] == 'LITERAL\n')
    value_print = next(e for e in effects.values() if e.get('stream') == 'stdout')
    assert literal['argument_width'] == 0 and 'arguments' not in literal['ports']
    assert {e['kind'] for e in effects.values()} == {'assert', 'assume', 'cover', 'print'}
    lowered = json.loads((folder / 'model/lowered.json').read_text(encoding='utf-8'))['modules']['Observed']
    assert not any(c['type'] in {'$assert','$assume','$cover','$print','$anyseq'} for c in lowered['cells'].values())
    assert all(p['bits'] for p in lowered['ports'].values())
    rows = [{'inputs': {'reset': int(i % 17 == 0), 'en': int(i % 3 != 0), 'd': (i * 7) % 15}} for i in range(48)]
    def lean_rows(trace):
        return [{'inputs': {**r['inputs'], **{p['name']: 0 for p in ir['arbitrary_inputs']}}} for r in trace]
    def native_rows(trace):
        return [{'reset': r['inputs']['reset'], 'inputs': {k: v for k, v in r['inputs'].items() if k != 'reset'}} for r in trace]
    metadata = {'top': 'Observed', 'clocked': True, 'assertions': True, 'rtl_sources': ['Observed.sv'],
                'ports': [{'name': n, 'rtl_name': n, 'width': w, 'direction': 'output' if n == 'q' else 'input'}
                          for n,w in [('clock',1),('reset',1),('en',1),('d',4),('q',4)]]}
    code, actual = simulate_yosys(path, lean_rows(rows), experiment_initial(ir), folder / 'lean')
    assert code == 0
    code, native = run_emitted_rtl(folder, metadata, native_rows(rows), folder / 'reference')
    assert code == 0 and len(rows) == len(actual) == len(native)
    q = 0
    expected_prints = []
    for index, (row, lean, rtl) in enumerate(zip(rows, actual, native)):
        assert lean['pre'] == rtl['pre'] == {'q': q}, index
        inputs = row['inputs']
        active = not inputs['reset'] and inputs['en']
        by_id = {e['index']: e for e in lean['effects_post']}
        if active:
            assert literal['index'] in by_id and 'arguments' not in by_id[literal['index']]
            assert by_id[value_print['index']]['arguments'] == q
            expected_prints += ['LITERAL', 'VALUE=' + str(q)]
        else:
            assert not by_id
        if inputs['reset']:
            q = 0
        elif inputs['en']:
            q = inputs['d']
        assert lean['post'] == rtl['post'] == {'q': q}, index
    output = (folder / 'reference/verilator-run/stdout.log').read_text(encoding='utf-8').splitlines()
    assert [line for line in output if line == 'LITERAL' or line.startswith('VALUE=')] == expected_prints
    invalid = rows + [{'inputs': {'reset': 0, 'en': 1, 'd': 15}}]
    lean_code, _ = simulate_yosys(path, lean_rows(invalid), experiment_initial(ir), folder / 'invalid-lean')
    rtl_code, _ = run_emitted_rtl(folder, metadata, native_rows(invalid), folder / 'invalid-reference')
    assert lean_code != 0 and rtl_code != 0
    result = {'status': 'PASS', 'cycles': len(rows), 'output_comparisons': len(rows) * 2,
              'literal_prints': expected_prints.count('LITERAL'), 'original_rtl_sha256': original,
              'assertion_lean_exit': lean_code, 'assertion_native_exit': rtl_code,
              'scope': 'Official RTLIL transport and expose pass retain assertion/assumption/cover and literal/no-argument prints. Original RTL remains unchanged; Lean and RTL both reject an intentional violation.'}
    write(folder / 'summary.json', result)
    write(ROOT / 'docs/validation-yosys-exposure-7.3.json', result)
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
