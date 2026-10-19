import copy
from pathlib import Path
import sys
import unittest
import uuid
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'scripts'))
sys.path.insert(0,str(ROOT/'scripts/verification/four_state'))
from fourstate_frontend import parse
from fourstate_encode import encode
from fourstate_bounded_events import validate_contract


class ResetAliasTests(unittest.TestCase):
    def model(self, text, **options):
        p=ROOT/'experiments/fourstate/reset-alias-tests'/uuid.uuid4().hex/'M.sv'
        p.parent.mkdir(parents=True);p.write_text(text+'\n')
        return parse(p,'M','sequential','clk',bounded_events=True,**options)

    def test_bound_port_net_paths_and_single_monitor(self):
        for top,depth,processes in [('PortReset',2,1),('DeepReset',3,1),('NetReset',5,1),('SharedReset',3,2)]:
            ir=parse(ROOT/'verification/fourstate/events/ResetAliases.sv',top,'sequential','clk',bounded_events=True)
            _,m=encode(ir);validate_contract(m)
            ts=[t for p in ir['events']['processes'] for t in p['triggers'] if t['source']['form']=='reset']
            self.assertEqual(len(ts),processes)
            self.assertEqual(max(len(t['source']['alias_path']) for t in ts),depth)
            self.assertEqual(ir['events']['monitors'].count(top+'.rst'),1)
            self.assertTrue(all(t['signal']==top+'.rst' for t in ts))

    def test_reset_rejections(self):
        leaf="module C(input c,r,d,output reg q);always @(posedge c or posedge r) if(r) q<=1'b0;else q<=d;endmodule "
        cases=[
          ('wire a=~rst;','a','identity alias'),
          ('wire a=rst & d;','a','identity alias'),
          ('wire a=rst|spare;','a','identity alias'),
          ('wire a,b;assign a=b;assign b=a;','a','cycle'),
          ('wire a;assign a=rst;assign a=spare;','a','multiple drivers'),
          ('wire [1:0] a={rst,rst};','a','identity alias'),
          ('wire a;','a','undriven'),
          ('','clk','distinct'),
          ('wire a=bit\'(rst);','a','identity alias'),
        ]
        for body,actual,diagnostic in cases:
            with self.subTest(actual=actual,body=body),self.assertRaisesRegex(ValueError,diagnostic):
                self.model(leaf+'module M(input clk,rst,d,spare,output q);'+body+'C c(.c(clk),.r('+actual+'),.d(d),.q(q));endmodule')

    def test_distinct_same_named_roots_not_merged(self):
        text="module C(input c,r,d,output reg q);always @(posedge c or posedge r) if(r)q<=1'b0;else q<=d;endmodule "
        with self.assertRaisesRegex(ValueError,'one independent async reset'):
            self.model(text+'module M(input clk,rst,other,d,output q,s);C a(clk,rst,d,q);C b(clk,other,d,s);endmodule')

    def test_illegal_width_and_type(self):
        for decl in ['input [1:0] rst','input bit rst']:
            with self.subTest(decl=decl),self.assertRaises(ValueError):
                self.model("module M(input clk,d,"+decl+",output reg q);always @(posedge clk or posedge rst) if(rst)q<=1'b0;else q<=d;endmodule")

    def test_process_and_state_budgets(self):
        for text in ['module M(input clk,rst,d,output q);'+
                     ' '.join('reg q'+str(i)+';always @(posedge clk) q'+str(i)+'<=d;' for i in range(9))+'assign q=q0;endmodule',
                     "module M(input clk,rst,d,output reg [256:0] q);always @(posedge clk or posedge rst) if(rst)q<=257'b0;else q<=d;endmodule"]:
            with self.assertRaisesRegex(ValueError,'budget'):
                self.model(text)

    def test_memory_and_multichange_boundaries(self):
        from fourstate_bounded_events import validate_trace
        with self.assertRaisesRegex(ValueError,'no memory'):
            self.model('module M(input clk,d,output q);assign q=d;endmodule',bounded_memories=True)
        ir=self.model("module M(input clk,rst,d,output reg q);always @(posedge clk or posedge rst)if(rst)q<=1'b0;else q<=d;endmodule")
        _,m=encode(ir)
        with self.assertRaisesRegex(ValueError,'Simultaneous'):
            validate_trace(m,[dict(inputs=dict(clk='0',rst='0',d='0')),dict(inputs=dict(clk='1',rst='1',d='0'))],{'M.q':'x'})

    def test_wrong_source_fault_keeps_four_state_decode(self):
        from verify_fourstate_clocks import benches,reset_fault_bench
        ir=parse(ROOT/'verification/fourstate/events/ResetAliases.sv','PortReset','sequential','clk',bounded_events=True)
        _,m=encode(ir)
        trace=[dict(inputs=dict(clk=c,rst=r,d='0',spare='0')) for c,r in [('0','0'),('1','0'),('1','1')]]
        b=benches(m,trace,{s['name']:'0' for s in m['states']},compact=True)
        fault=reset_fault_bench(m,b['encoded'],'wrong_source')
        self.assertIn('rise4(early0,(m0_tag*2+m0_value))',fault)
        self.assertNotIn('m0_tag*0',fault)
