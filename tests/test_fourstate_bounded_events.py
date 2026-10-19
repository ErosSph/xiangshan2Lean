import json
from pathlib import Path
import sys
import unittest
import uuid

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'scripts'))
sys.path.insert(0,str(ROOT/'scripts/verification/four_state'))
from fourstate_frontend import parse
from fourstate_encode import encode
from fourstate_bounded_events import validate_trace, validate_contract, POSEDGE, NEGEDGE


class BoundedEvents(unittest.TestCase):
    def setUp(self):
        self.folder=ROOT/'experiments/fourstate/event-tests'/uuid.uuid4().hex
        self.folder.mkdir(parents=True)

    def model(self,text,**options):
        p=self.folder/'M.sv';p.write_text(text)
        return parse(p,'M','sequential','clk',bounded_events=True,**options)

    def test_latch_is_persistent_state_and_clock_has_rails(self):
        ir=self.model('module M(input clk,d, output reg q); always_latch if(!clk) q=d; endmodule')
        rtl,m=encode(ir);validate_contract(m)
        self.assertEqual(ir['events']['processes'][0]['kind'],'latch')
        self.assertEqual(len(ir['states']),1)
        self.assertIn('clk__tag',rtl)
        self.assertNotIn('role',next(p for p in m['ports'] if p['name']=='clk'))

    def test_two_independent_clocks(self):
        ir=self.model('module M(input clk,cb,d, output reg q,r); always @(posedge clk) q<=d; always @(posedge cb) r<=q; endmodule',event_clocks=['clk','cb'])
        self.assertEqual(len(ir['events']['processes']),2)

    def test_inverted_and_negative_clock(self):
        for event in ['posedge inv','negedge clk']:
            p=self.folder/(str(uuid.uuid4())+'.sv')
            p.write_text('module M(input clk,d, output reg q); wire inv=~clk; always @('+event+') q<=d; endmodule')
            ir=parse(p,'M','sequential','clk',bounded_events=True)
            self.assertEqual(ir['events']['processes'][0]['triggers'][0]['edge'],'PosEdge' if 'inv' in event else 'NegEdge')

    def test_trace_rejects_simultaneous_data_and_clock(self):
        ir=self.model('module M(input clk,d, output reg q); always @(posedge clk) q<=d; endmodule')
        _,m=encode(ir)
        with self.assertRaisesRegex(ValueError,'Simultaneous'):
            validate_trace(m,[{'inputs':{'clk':'0','d':'0'}},{'inputs':{'clk':'1','d':'1'}}],{'M.q':'x'})

    def test_reject_unadmitted_semantics(self):
        cases=[
            ('always_latch q=d;','latch requires'),
            ('always_latch if(clk) q=d;','guard'),
            ('always_latch if(!clk) q=~q;','feedback'),
            ('always_latch if(!clk) q<=d;','blocking'),
            ('wire g=clk & d; always @(posedge g) q<=d;','derived'),
            ('always @(posedge clk) q= d;','automatic local'),
            ('always @(posedge clk) q<=clk;','race'),
            ('always @(posedge clk) q<=d; always @(negedge clk) q<=d;','multiple'),
            ('always @(posedge clk iff d) q<=d;','without iff'),
            ('initial q=0; always @(posedge clk) q<=d;','initial'),
        ]
        for body,diagnostic in cases:
            with self.subTest(body=body):
                p=self.folder/(uuid.uuid4().hex+'.sv');p.write_text('module M(input clk,d, output reg q); '+body+' endmodule')
                with self.assertRaisesRegex(ValueError,diagnostic):parse(p,'M','sequential','clk',bounded_events=True)

    def test_memory_option_not_relaxed(self):
        with self.assertRaisesRegex(ValueError,'no memory'):
            self.model('module M(input clk,d,output q); assign q=d; endmodule',bounded_memories=True)

    def test_edge_table(self):
        self.assertEqual(len(POSEDGE),5);self.assertEqual(len(NEGEDGE),5)
        self.assertNotIn(('x','z'),POSEDGE|NEGEDGE)

    def test_rail_adapter_matches_existing_full_symbol_space(self):
        import itertools
        from fourstate_bounded_events import rail_encode_trace,rail_decode
        from fourstate_simulate import encode_trace,decode
        p=dict(name='v',width=3,direction='input',tag='t',value='v')
        trace=[dict(inputs=dict(v=''.join(bits))) for bits in itertools.product('01xz',repeat=3)]
        self.assertEqual(rail_encode_trace({'ports':[p]},trace),encode_trace({'ports':[p]},trace))
        for row in rail_encode_trace({'ports':[p]},trace):
            self.assertEqual(rail_decode([p],row['inputs']),decode({'ports':[dict(p,direction='output')]},row['inputs']))

    def test_event_metadata_ownership_and_limits_are_checked(self):
        import copy
        ir=self.model('module M(input clk,d,output reg q); always @(posedge clk) q<=d; endmodule')
        _,m=encode(ir)
        for mutation in ['process','limit','root','trigger']:
            bad=copy.deepcopy(m)
            if mutation=='process':bad['states'][0]['process']=1
            if mutation=='limit':bad['events']['max_activations_per_process']=2
            if mutation=='root':bad['events']['roots']=['missing']
            if mutation=='trigger':bad['events']['processes'][0]['triggers'][0]['edge']='Both'
            with self.subTest(mutation=mutation),self.assertRaises(ValueError):validate_contract(bad)

    def test_comparator_detects_hidden_state_and_z_corruption(self):
        import copy
        from verify_fourstate_clocks import compare
        mapping={'states':[dict(name='M.q',width=1)],'events':{'processes':[]}}
        sample=dict(sample=0,fired=[],pre=dict(outputs={'q':'z'},states={'M.q':'z'},monitors={}),post=dict(outputs={'q':'z'},states={'M.q':'z'},monitors={}))
        for section in ['outputs','states']:
            bad=copy.deepcopy(sample);bad['post'][section]['q' if section=='outputs' else 'M.q']='x'
            with self.subTest(section=section),self.assertRaisesRegex(ValueError,'mismatch'):compare(mapping,[sample],[bad],[sample])


if __name__=='__main__':unittest.main()
