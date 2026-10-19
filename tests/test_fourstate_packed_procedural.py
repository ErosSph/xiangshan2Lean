"""F4.7 admission and symbol identity; differential evidence is separate."""
from pathlib import Path
import sys
import tempfile
import unittest
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'scripts'))
from fourstate_frontend import parse
from fourstate_encode import encode


class PackedProcedural(unittest.TestCase):
    def test_plain_named_block_routes_to_bound_frontend(self):
        with tempfile.TemporaryDirectory(dir=ROOT/'.cache') as folder:
            p=Path(folder)/'T.sv'
            p.write_text('module T(input clk,d,output reg q); always @(posedge clk) begin : named q<=d; end : named endmodule')
            ir=parse(p,'T','sequential','clk')
            self.assertEqual(ir['elaboration']['named_process_blocks'][0]['name'],'named')

    def test_packed_is_not_memory_or_persistent_state(self):
        ir=parse(ROOT/'verification/fourstate/procedural/PackedProcedural.sv','PackedProcedural','sequential','clk',bounded_events=True)
        self.assertEqual({s['name'] for s in ir['states']},{'PackedProcedural.'+x for x in ['q','reads','widths']})
        self.assertNotIn('unpacked_memory',ir['capabilities'])
        self.assertTrue(any(n['op']=='packed_select' for n in ir['nodes']))
        self.assertEqual(len(ir['elaboration']['process_locals']),4)
        encode(ir)

    def test_named_shadow_symbols_remain_independent(self):
        ir=parse(ROOT/'verification/fourstate/procedural/NamedProcedural.sv','NamedProcedural','sequential','clk',bounded_events=True)
        locals_=ir['elaboration']['process_locals']
        self.assertEqual(len(locals_),2)
        self.assertEqual({n['name'] for n in locals_},{'temp'})
        self.assertEqual(len({n['path'] for n in locals_}),2)
        self.assertEqual(len(ir['states']),4)
        self.assertEqual(len(ir['elaboration']['named_process_blocks']),2)

    def test_bounded_processes_keep_separate_local_ownership(self):
        with tempfile.TemporaryDirectory(dir=ROOT/'.cache') as folder:
            p=Path(folder)/'T.sv'
            p.write_text('module T(input clk,d,output reg q,r); always @(posedge clk) begin : a automatic logic t=d; q<=t; end always @(negedge clk) begin : b automatic logic t=~d; r<=t; end endmodule')
            ir=parse(p,'T','sequential','clk',bounded_events=True)
            self.assertEqual({n['process'] for n in ir['elaboration']['process_locals']},{0,1})
            self.assertEqual(len(ir['states']),2)

    def test_refusal_boundaries(self):
        cases={
            'three_dims':'automatic logic [1:0][1:0][1:0] t; t=8\'h00; q<=t[0][0][0];',
            'static_lifetime':'static logic t; t=d; q<=t;',
            'disable':'automatic logic t; t=d; disable block_name; q<=t;',
            'fork':'fork q<=d; join',
            'wait':'wait (d) q<=d;',
            'delay':'#1 q<=d;',
            'hierarchical_local':'automatic logic t; t=d; q<=block_name.t;',
            'assertion':'assert (d); q<=d;',
        }
        with tempfile.TemporaryDirectory(dir=ROOT/'.cache') as folder:
            for name,body in cases.items():
                with self.subTest(name=name):
                    f=Path(folder)/(name+'.sv')
                    f.write_text('module T(input clk,d,output reg q); always @(posedge clk) begin : block_name '+body+' end endmodule')
                    with self.assertRaisesRegex(ValueError,r':\d+:\d+:'):
                        parse(f,'T','sequential','clk',bounded_events=True)


if __name__=='__main__':unittest.main()
