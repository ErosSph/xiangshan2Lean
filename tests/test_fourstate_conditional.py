import itertools
from pathlib import Path
import sys
import unittest
import uuid
import json
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'scripts'))
sys.path.insert(0,str(ROOT/'scripts/verification/four_state'))
from fourstate_frontend import parse
from fourstate_encode import encode


class ConditionalIEEE(unittest.TestCase):
    def test_ternary_and_procedural_selection_are_separate(self):
        ir=parse(ROOT/'verification/fourstate/operators/ConditionalIEEE.sv',
                 'ConditionalVector','sequential','clk',bounded_events=True)
        ops={n['op'] for n in ir['nodes']}
        self.assertTrue({'mux','proc_mux','eq','case_eq'} <= ops)
        self.assertEqual(sum(s['width'] for s in ir['states']),6)

    def test_pinned_constant_fold_is_not_silently_trusted(self):
        for expression in ["1'bx ? 1'bz : 1'bz", "(1'bx ? 1'bz : 1'bz) === 1'bz"]:
            folder=ROOT/'experiments/fourstate/conditional-tests'/uuid.uuid4().hex;folder.mkdir(parents=True)
            p=folder/'M.sv';p.write_text('module M(input a,output y); localparam logic P = '+expression+'; assign y=a & P; endmodule\n')
            with self.assertRaisesRegex(ValueError,'constant conditional folding.*IEEE'):
                parse(p,'M')

    def test_runtime_constant_conditional_is_lowered_for_encoding(self):
        folder=ROOT/'experiments/fourstate/conditional-tests'/uuid.uuid4().hex;folder.mkdir(parents=True)
        p=folder/'M.sv';p.write_text("module M(input a,output y);assign y=1'bx ? 1'bz : 1'bz;endmodule\n")
        ir=parse(p,'M');self.assertIn('mux',[n['op'] for n in ir['nodes']])

    def test_generate_folding_is_audited(self):
        expr="((1'bx ? 1'bz : 1'bz) === 1'bz)"
        bodies=[f"if ({expr}) begin:g assign y=a;end else begin:h assign y=~a;end",
                f"for(genvar i=0;i<({expr} ? 1 : 0);i++)begin:g wire unused;assign unused=a;end assign y=a;",
                "for(genvar i=0;i<((((i==0) ? 1'bx : 1'b1) ? 1'bz : 1'bz) === 1'bz ? 1 : 0);i++)begin:g wire n;assign n=a;end assign y=a;"]
        for body in bodies:
            folder=ROOT/'experiments/fourstate/conditional-tests'/uuid.uuid4().hex;folder.mkdir(parents=True)
            p=folder/'M.sv';p.write_text('module M(input a,output y);'+body+' endmodule\n')
            with self.assertRaisesRegex(ValueError,'constant conditional folding.*IEEE'):
                parse(p,'M')

    def test_fresh_comparison_detects_corruption_and_missing_coverage(self):
        from verify_fourstate_conditional_compare import compare_fresh
        m=dict(mode='sequential',ports=[dict(name='y',direction='output',width=1,tag='yt',value='yv')],
               states=[dict(name='q',width=1,current_tag='qt',current_value='qv')])
        request=dict(trace=[dict(clock=0,inputs={})])
        original='0 pre z z\n0 post z z\n'
        encoded='0 pre 1 1 1 1\n0 post 1 1 1 1\n'
        phase=dict(outputs=dict(yt=1,yv=1),states=dict(qt=1,qv=1))
        lean=json.dumps(dict(sample=0,clock=0,rising=False,pre=phase,post=phase))+'\n'
        self.assertEqual(compare_fresh(m,request,original,encoded,lean)['status'],'FRESH_THREE_WAY_PASS')
        for mutant in [encoded.replace('1 1 1 1','1 0 1 1',1),encoded.replace('1 1 1 1','1 1 1 0',1),
                       encoded.replace('1 1 1 1','x 1 1 1',1),encoded.splitlines()[0]+'\n',
                       encoded.replace('0 post','1 post'),encoded.replace('1 1 1 1','1 1',1)]:
            with self.assertRaises(ValueError):compare_fresh(m,request,original,mutant,lean)
