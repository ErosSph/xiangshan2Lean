"""Bound assertion admission, ABI validation and native diagnostic handling."""
from pathlib import Path
import copy,json,sys,tempfile,unittest
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'scripts'))
from fourstate_frontend import parse
from fourstate_encode import encode
from fourstate_assertions import FIELDS,flags_events,reference_events,validate_mapping

class ImmediateAssertions(unittest.TestCase):
    def ir(self):return parse(ROOT/'verification/fourstate/procedural/AssertionOrder.sv','AssertionOrder','sequential','clk',bounded_events=True,immediate_assertions=True)
    def test_bound_order_scope_and_no_new_state(self):
        ir=self.ir();rtl,m=encode(ir);validate_mapping(m)
        self.assertEqual(len(ir['assertions']),4)
        self.assertEqual([a['ordinal'] for a in ir['assertions']],list(range(4)))
        self.assertEqual({s['name'] for s in ir['states']},{'AssertionOrder.q','AssertionOrder.r'})
        self.assertEqual(ir['assertions'][0]['label'],'before_local')
        self.assertEqual(ir['assertions'][1]['label'],None)
        self.assertIn('immediate_assertions',ir['capabilities'])
        self.assertTrue(all(a[k] in rtl for a in m['assertions'] for k in FIELDS))
    def test_explicit_opt_in_and_existing_rejections(self):
        with self.assertRaisesRegex(ValueError,'unsupported clocked statement'):
            parse(ROOT/'verification/fourstate/procedural/AssertionOrder.sv','AssertionOrder','sequential','clk',bounded_events=True)
        with self.assertRaisesRegex(ValueError,'bounded-events'):
            parse(ROOT/'verification/fourstate/procedural/AssertionQuiet.sv','AssertionQuiet','sequential','clk',immediate_assertions=True)
    def test_unmodeled_actions_rejected(self):
        bodies=['assert #0 (d) else $error("bad");','assert final (d) else $error("bad");',
            'assert(d) q<=d; else $error("bad");','assert(d) else $fatal(1,"bad");',
            'assert(d) else begin q<=d; $error("bad"); end','assert(d) else $error("%b",d);',
            'assert(d);','assume(d) else $error("bad");',
            'assert({d,d}) else $error("bad");','assert(clk) else $error("bad");']
        with tempfile.TemporaryDirectory(dir=ROOT/'.cache') as folder:
            for body in bodies:
                with self.subTest(body=body):
                    f=Path(folder)/'T.sv';f.write_text('module T(input clk,d,output reg q); always @(posedge clk) begin '+body+' q<=d; end endmodule')
                    with self.assertRaisesRegex(ValueError,r':\d+:\d+:'):
                        parse(f,'T','sequential','clk',bounded_events=True,immediate_assertions=True)
    def test_flags_require_activation_known_rails_and_guard(self):
        _,m=encode(self.ir());flags=[[0,1,0,0]]*4
        self.assertEqual(flags_events(m,0,[],flags),[])
        self.assertEqual(len(flags_events(m,1,[0],flags)),4)
        self.assertEqual(flags_events(m,1,[0],[[0,1,0,1]]*4),[])
        self.assertEqual(flags_events(m,1,[0],[[0,0,0,0]]*4),[])
        with self.assertRaisesRegex(ValueError,'known'):
            flags_events(m,1,[0],[[1,1,0,0]]*4)
    def test_native_parser_preserves_failures_and_rejects_unknown_errors(self):
        _,m=encode(self.ir());a=m['assertions'][0]
        raw='F47_STEP 0\n** Error: local_before\n Time: 2 ns Scope: tb.dut.update.before_local File: original.sv Line: 5\n'
        self.assertEqual(len(reference_events(m,raw,1)[0]),1)
        with self.assertRaisesRegex(ValueError,'Unmatched'):
            reference_events(m,raw.replace('local_before','different'),1)
        with self.assertRaisesRegex(ValueError,'outside'):
            reference_events(m,raw.replace('F47_STEP 0\n',''),1)
        with self.assertRaisesRegex(ValueError,'order'):
            reference_events(m,raw+raw.split('\n',1)[1],1)
    def test_contract_tamper_rejected(self):
        _,m=encode(self.ir())
        for field in ['ordinal','process','severity']:
            bad=copy.deepcopy(m);bad['assertions'][0][field]='wrong'
            with self.assertRaises(ValueError):validate_mapping(bad)

if __name__=='__main__':unittest.main()
