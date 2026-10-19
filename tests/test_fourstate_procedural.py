"""Front-end acceptance inventory and unsupported-boundary checks for F4.1."""
from pathlib import Path
import sys
import tempfile
import unittest

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'scripts'))
from fourstate_frontend import parse


class ProceduralBoundary(unittest.TestCase):
    def test_locals_are_bound_expressions_and_not_state(self):
        ir=parse(ROOT/'verification/fourstate/procedural/ProceduralLocals.sv',
                 'ProceduralLocals','sequential','clk')
        self.assertEqual({x['name'] for x in ir['states']},
                         {'ProceduralLocals.'+n for n in ('q','r','s','fresh')})
        self.assertEqual(sum(x['width'] for x in ir['states']),8)
        self.assertEqual(len(ir['elaboration']['process_locals']),3)
        self.assertIn('procedural_locals',ir['capabilities'])
        signal_names={x['name'] for x in ir['signals']}
        self.assertTrue(all(n['name'] in signal_names for n in ir['nodes'] if n['op'] in ('ref','select')))

    def test_width_fixture_is_valid_with_signed_local_and_local_guard(self):
        ir=parse(ROOT/'verification/fourstate/procedural/LocalWidths.sv','LocalWidths','sequential','clk')
        locals_={x['name']:x for x in ir['elaboration']['process_locals']}
        self.assertEqual((locals_['narrow_s']['width'],locals_['narrow_s']['signed']),(2,True))
        self.assertEqual(locals_['guard']['width'],1)

    def test_unsupported_forms_have_located_rejections(self):
        head='module T(input clk,d,en,reset,output reg q); '
        wrap=lambda body:head+body+' endmodule'
        cases={
            'static':wrap('always @(posedge clk) begin logic t; t=d; q<=t; end'),
            'static_initializer':wrap('always @(posedge clk) begin static logic t=d; q<=t; end'),
            'local_nba':wrap('always @(posedge clk) begin automatic logic t; t<=d; q<=t; end'),
            'state_blocking':wrap('always @(posedge clk) q=d;'),
            'compound':wrap('always @(posedge clk) begin automatic logic t; t=d; t^=en; q<=t; end'),
            'delay':wrap('always @(posedge clk) begin automatic logic t; t=#1 d; q<=t; end'),
            'range_partial':wrap('always @(posedge clk) begin automatic logic [1:0] t; t[1:0]={d,d}; q<=t[0]; end'),
            'loop':wrap('always @(posedge clk) begin automatic logic t; repeat(2) t=d; q<=t; end'),
            'async':wrap('always @(posedge clk or posedge reset) begin automatic logic t; t=d; q<=t; end'),
            'disable_named':wrap('always @(posedge clk) begin : named automatic logic t; t=d; disable named; q<=t; end'),
            'multi':wrap('reg r; always @(posedge clk) begin automatic logic t; t=d; q<=t; end always @(posedge clk) r<=d;'),
            'memory':wrap('always @(posedge clk) begin automatic logic t[0:1]; t[0]=d; q<=t[0]; end'),
        }
        with tempfile.TemporaryDirectory(dir=ROOT/'.cache') as folder:
            for name,text in cases.items():
                with self.subTest(name=name):
                    path=Path(folder)/(name+'.sv');path.write_text(text,encoding='utf-8')
                    with self.assertRaisesRegex(ValueError,r':\d+:\d+:'):
                        parse(path,'T','sequential','clk')


if __name__=='__main__':unittest.main()
