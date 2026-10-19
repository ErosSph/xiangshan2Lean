"""Opt-in v9 semantics; behavioral oracle lives in the F56 native comparisons."""
from pathlib import Path
import os,sys,unittest,uuid
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
from fourstate_extended import parse_extended,encode_extended
from fourstate_eventful import parse_eventful


class Extended(unittest.TestCase):
    def setUp(self):self.root=Path(os.environ['TMPDIR'])/('v9-'+uuid.uuid4().hex);self.root.mkdir()
    def model(self,text,clock=None):
        f=self.root/'T.sv';f.write_text(text);return parse_extended(f,'T',clock)
    def test_open_output_keeps_child(self):
        ir=self.model('module C(input d,output q,r);assign q=d;assign r=~d;endmodule module T(input d,output q);C c(.d(d),.q(q),.r());endmodule')
        self.assertEqual(len(ir['elaboration']['instances']),2);self.assertTrue(any(c.get('open') for c in ir['elaboration']['connections']));encode_extended(ir)
    def test_floating_wire_input_is_z(self):
        ir=self.model('module C(input [2:0] d,output [2:0] q);assign q=d;endmodule module T(output [2:0] q);C c(.d(),.q(q));endmodule')
        self.assertEqual(ir['elaboration']['floating_signals'][0]['bits'],'zzz');encode_extended(ir)
    def test_legacy_profile_still_rejects(self):
        ir=self.model('module C(input d,output q,r);assign q=d;assign r=d;endmodule module T(input clock,d,output reg q);wire a;C c(.d(d),.q(a),.r());always @(posedge clock)q<=a;endmodule','clock')
        with self.assertRaisesRegex(ValueError,'every input/output'):parse_eventful(self.root/'T.sv','T','clock')
        encode_extended(ir)
    def test_unsized_bound_width_and_signedness(self):
        ir=self.model('module T(input [4:0] d,output [7:0] q);assign q=d+1;endmodule');self.assertTrue(any(n['op']=='const' and n['width']>=8 for n in ir['nodes']));encode_extended(ir)
    def test_unbased_literals_fill_bound_context(self):
        ir=self.model("module T(output [7:0] a,b,c,d);assign a='1;assign b='0;assign c='x;assign d='z;endmodule")
        for port,symbol in [('a','1'),('b','0'),('c','x'),('d','z')]:
            n=ir['nodes'][ir['assignments']['T.'+port]];self.assertEqual(n['bits'],symbol*8)
        encode_extended(ir)
    def test_dynamic_simple_vector_read(self):
        ir=self.model('module T(input [3:0] d,input [2:0] i,output q);assign q=d[i];endmodule');self.assertTrue(any(n['op']=='packed_select' for n in ir['nodes']));encode_extended(ir)
    def test_packed_pattern(self):
        ir=self.model("module T(input [2:0] d,output [5:0] q);wire [1:0][2:0] a='{d,3'b101};assign q=a;endmodule");encode_extended(ir)
    def test_multibit_if_truth(self):
        ir=self.model('module T(input clock,input [2:0] d,output reg q);always @(posedge clock)if(d)q<=1\'b1;else q<=1\'b0;endmodule','clock');self.assertTrue(any(n['op']=='reduce_or' for n in ir['nodes']));encode_extended(ir)
    def test_stateless_event_process(self):
        ir=self.model('module T(input clock,d,output q);assign q=d;always @(posedge clock) begin end endmodule','clock');self.assertEqual(ir['states'],[]);self.assertEqual(len(ir['events']['processes']),1);encode_extended(ir)
    def test_remainder_explicit_node(self):
        ir=self.model('module T(input signed [4:0] a,b,output signed [4:0] q);assign q=a%b;endmodule');self.assertTrue(any(n['op']=='mod' for n in ir['nodes']));encode_extended(ir)
    def test_xor_reductions(self):
        ir=self.model('module T(input [4:0] a,output x,n);assign x=^a;assign n=~^a;endmodule');self.assertEqual({n['op'] for n in ir['nodes']}&{'reduce_xor','reduce_xnor'},{'reduce_xor','reduce_xnor'});encode_extended(ir)
    def test_formatted_payload_has_real_rails(self):
        ir=self.model('module T(input clock,input [2:0] d,output q);assign q=d[0];always @(posedge clock)assert(d)else $error("d=%b %d",d,$signed(d));endmodule','clock')
        rtl,m=encode_extended(ir);self.assertEqual(len(m['assertions'][0]['arguments']),2);self.assertIn('c2l4_assert0_arg0_tag',rtl)
    def test_stderr_write_is_observed(self):
        ir=self.model('module T(input clock,d,output q);assign q=d;always @(posedge clock)if(d)$fwrite(32\'h80000002,"d=%x\\n",d);endmodule','clock')
        _,m=encode_extended(ir);self.assertEqual(m['assertions'][0]['severity'],'write')
    def test_dynamic_format_and_other_stream_refused(self):
        for call in ('$fwrite(32\'h80000001,"bad")','$error("%s",d)','$fatal(1,"bad")'):
            with self.subTest(call=call),self.assertRaises(ValueError):self.model('module T(input clock,d,output q);assign q=d;always @(posedge clock)'+call+';endmodule','clock')
    def test_independent_diagnostic_stream_buffering(self):
        import gzip
        from fourstate_extended_bench import native_diagnostics
        common=dict(process=0,rtl_scope='',source=dict(file='T.sv',line=1),action_source=dict(line=1))
        mapping=dict(assertions=[dict(common,id='error',severity='error',message='err %d\n'),dict(common,id='write',severity='write',message='writer %b\n')])
        text='writer 0000\nF56_STDERR_STEP 0\nF56_STDERR_STEP 1\nwriter 0011\n# F47_STEP 0\n# ** Error: err 0\n# Time: 0 Scope: tb.dut File: T.sv Line: 1\n# F47_STEP 1\n# ** Error: err 1\n# Time: 1 Scope: tb.dut File: T.sv Line: 1\n'
        p=self.root/'native.gz'
        with gzip.open(p,'wt') as f:f.write(text)
        rows,initial=native_diagnostics(p,mapping)
        self.assertEqual(initial,1);self.assertEqual([(r['sample'],r['site']) for r in rows],[(1,'write'),(0,'error'),(1,'error')])
    def test_exact_preload_tool_capacity_notice(self):
        import gzip
        from fourstate_extended_bench import native_diagnostics
        text='# ** Warning: Design size of 6 instances exceeds ModelSim ALTERA recommended capacity.\n# This may because you are loading cell libraries which are not recommended with\n# the ModelSim Altera version. Expect performance to be adversely affected.\n'
        p=self.root/'tool.gz'
        with gzip.open(p,'wt') as f:f.write(text+'# F47_STEP 0\n')
        self.assertEqual(native_diagnostics(p,dict(assertions=[])),([],0))
        with gzip.open(p,'wt') as f:f.write('# F47_STEP 0\n'+text)
        with self.assertRaisesRegex(ValueError,'Unmatched'):native_diagnostics(p,dict(assertions=[]))
    def test_native_implicit_block_scope_identity(self):
        import gzip
        from fourstate_extended_bench import native_diagnostics
        m=dict(assertions=[dict(id='T.checked@T.sv:5:1',process=0,severity='error',rtl_scope='checked',source=dict(file='T.sv',line=5),action_source=dict(line=6),action_end_source=dict(line=8))])
        p=self.root/'scope.gz';text='# F47_STEP 0\n# ** Error: bad\n# Time: 1 Scope: tb.dut.#ublk#0#2.#ublk#0#4.checked File: T.sv Line: 8\n'
        with gzip.open(p,'wt') as f:f.write(text)
        self.assertEqual(native_diagnostics(p,m)[0][0]['site'],'T.checked@T.sv:5:1')
        with gzip.open(p,'wt') as f:f.write(text.replace('.checked ','.different '))
        with self.assertRaisesRegex(ValueError,'Unmatched native error site'):native_diagnostics(p,m)


if __name__=='__main__':unittest.main()
