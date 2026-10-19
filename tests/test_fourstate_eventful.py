"""v8 opt-in boundaries, reset graph and independently observable activations."""
import copy,os,sys,unittest,uuid
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
from fourstate_eventful import parse_eventful,encode_eventful,validate_eventful,dependency_plan
from fourstate_scalable import parse_scalable,encode_scalable
from fourstate_encode import encode

class Eventful(unittest.TestCase):
    def setUp(self):self.root=Path(os.environ['TMPDIR'])/('v8-'+uuid.uuid4().hex);self.root.mkdir()
    def source(self,text):p=self.root/'T.sv';p.write_text(text);return p
    def cascade(self,logic='r[2]'):
        return self.source(f"module T(input clock,reset,d,output reg q);reg [2:0] r;wire dr={logic};always @(posedge clock or posedge reset)if(reset)r<=3'b111;else r<={{r[1:0],d}};always @(posedge clock or posedge dr)if(dr)q<=1'b0;else q<=d;endmodule")
    def test_static_packed_state_reset(self):
        ir=parse_eventful(self.cascade(),'T','clock');e=ir['events'];self.assertEqual(e['reset_dependency_edges'],[[0,1]])
        self.assertEqual(e['max_waves'],3);t=e['processes'][1]['triggers'][1];self.assertEqual(t['source']['bit'],2)
        rtl,m=encode_eventful(ir);self.assertIn('wave_valid',rtl);self.assertEqual(m['protocol']['max_waves'],3)
    def test_legacy_entry_still_refuses_state_reset(self):
        with self.assertRaisesRegex(ValueError,'async reset'):parse_scalable(self.cascade(),'T','clock')
    def test_inverted_state_bit_reset(self):
        ir=parse_eventful(self.cascade('~r[1]'),'T','clock');self.assertTrue(ir['events']['processes'][1]['triggers'][1]['source']['inverted'])
    def test_logic_reset_remains_located_rejection(self):
        with self.assertRaisesRegex(ValueError,r'T.sv:\d+:\d+: derived reset'):parse_eventful(self.cascade('r[0]|reset'),'T','clock')
    def test_self_reset_cycle(self):
        p=self.source("module T(input clock,d,output reg q);wire r=q;always @(posedge clock or posedge r)if(r)q<=1'b0;else q<=d;endmodule")
        with self.assertRaisesRegex(ValueError,'self-triggered'):parse_eventful(p,'T','clock')
    def test_graph_cycle_and_depth(self):
        def fail(p,msg):raise ValueError(msg)
        self.assertEqual(dependency_plan([{}]*4,[(0,1),(1,2),(0,3)],fail)['depth'],2)
        with self.assertRaisesRegex(ValueError,'cyclic'):dependency_plan([{}]*3,[(0,1),(1,2),(2,0)],fail)
    def test_state_fed_clockgate_and_old_boundary(self):
        p=self.source('module T(input clock,d,output reg q);reg en,l;wire g=clock&l;always @(posedge clock)en<=d;always_latch if(!clock)l=en;always @(posedge g)q<=d;endmodule')
        ir=parse_eventful(p,'T','clock');self.assertEqual(len(ir['states']),3);encode_eventful(ir)
        with self.assertRaisesRegex(ValueError,'latch data'):parse_scalable(p,'T','clock')
    def test_latch_chain_remains_rejected(self):
        p=self.source('module T(input clock,d,output reg q);reg a,l;wire g=clock&l;always_latch if(!clock)a=d;always_latch if(!clock)l=a;always @(posedge g)q<=d;endmodule')
        with self.assertRaisesRegex(ValueError,'latch data'):parse_eventful(p,'T','clock')
    def test_graph_bound_corruption(self):
        ir=parse_eventful(self.cascade(),'T','clock');ir['events']['max_waves']+=1
        with self.assertRaises(ValueError):validate_eventful(ir)
    def test_explicit_encoder_required(self):
        ir=parse_eventful(self.cascade(),'T','clock')
        for fn in (encode,encode_scalable):
            with self.assertRaises(ValueError):fn(ir)
    def test_bench_contains_activation_witness(self):
        from fourstate_eventful_bench import benches
        _,m=encode_eventful(parse_eventful(self.cascade(),'T','clock'));row={'inputs':{'clock':'1','reset':'0','d':'0'}}
        for binary in (False,True):
            tb,data=benches(m,[row],'x',binary);self.assertIn('A2L',tb);self.assertIn('activation1',tb)
            self.assertNotIn('endend',tb)
            self.assertNotIn('endif(',tb)
    def test_explicit_nonuniform_reset_state(self):
        from fourstate_eventful_bench import benches
        _,m=encode_eventful(parse_eventful(self.cascade(),'T','clock'));row={'inputs':{'clock':'1','reset':'0','d':'0'}}
        for binary in (False,True):
            tb,_=benches(m,[row],'0',binary,initial_overrides={'T.r':'010'})
            self.assertIn("3'b010",tb)
            if not binary:
                self.assertIn("force dut.r=3'b010",tb);self.assertIn('release dut.r;',tb)
    def test_unvalidated_per_wave_assertion_is_located_rejection(self):
        p=self.source('module T(input clock,d,output reg q);always @(posedge clock)begin q<=d;assert(d)else $error("probe");end endmodule')
        with self.assertRaisesRegex(ValueError,r'T.sv:\d+:\d+: v8 per-wave'):
            parse_eventful(p,'T','clock',immediate_assertions=True)
    def test_multiple_nba_reset_edges_rejected(self):
        p=self.source("module T(input clock,d,output reg q);reg r;always @(posedge clock)begin r<=1'b1;r<=1'b0;end always @(posedge clock or posedge r)if(r)q<=1'b0;else q<=d;endmodule")
        with self.assertRaisesRegex(ValueError,r'T.sv:\d+:\d+: derived reset producer'):
            parse_eventful(p,'T','clock')

if __name__=='__main__':unittest.main()
