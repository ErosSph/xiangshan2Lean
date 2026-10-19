"""Private v7 admission, DAG and native-array encoding contract checks."""
import copy,os,sys,unittest,uuid
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
from fourstate_scalable import parse_scalable,encode_scalable,scalar_kernel,validate_scalable
from fourstate_stateflow import parse_compact
from fourstate_encode import encode


class ScalableState(unittest.TestCase):
    def setUp(self):self.root=Path(os.environ['TMPDIR'])/('v7-'+uuid.uuid4().hex);self.root.mkdir()
    def source(self,text):p=self.root/'T.sv';p.write_text(text);return p
    def memory(self,depth=2,body='if(en)m[a]<=d;'):
        return self.source(f'module T(input clk,en,input [12:0] a,input [7:0] d,output [7:0] q);reg [7:0] m[0:{depth-1}];always @(posedge clk)begin {body}end assign q=m[a];endmodule')
    def test_native_array_depth_scaling(self):
        counts=[]
        for depth in (2,32,1024,6144):
            ir=parse_scalable(self.memory(depth),'T','clk');rtl,m=encode_scalable(ir)
            self.assertNotIn('words',ir['memories'][0]);self.assertIn('reg [7:0] bank0_t [0:',rtl)
            self.assertEqual(m['states'][0]['memory']['physical_depth'],1<<(max(2,depth)-1).bit_length())
            counts.append((len(ir['nodes']),len(m['states']),len(m['writes'])))
        self.assertEqual(len(set(counts)),1)
    def test_state_capacity_and_legacy_profile(self):
        p=self.source('module T(input clk,en,input [289:0] d,output reg [289:0] q);always @(posedge clk)if(en)q<=d;endmodule')
        ir=parse_scalable(p,'T','clk');self.assertEqual(ir['storage']['scalar_bits'],290)
        with self.assertRaisesRegex(ValueError,'budget'):parse_compact(p,'T','clk')
    def test_process_capacity(self):
        body=''.join(f'reg q{i};always @(posedge clk)q{i}<=d;' for i in range(17))
        p=self.source('module T(input clk,d,output q);'+body+'assign q=q16;endmodule')
        ir=parse_scalable(p,'T','clk');self.assertEqual(len(ir['event_plan']['owners']),17)
        with self.assertRaisesRegex(ValueError,'budget'):parse_compact(p,'T','clk')
    def test_branch_writes_preserve_order(self):
        ir=parse_scalable(self.memory(body='if(en)begin m[a]<=d;m[a][3:0]<=m[0][3:0];end else m[1]<=d;'),'T','clk')
        _,_,_,writes=scalar_kernel(ir)
        self.assertEqual(len(writes),3);self.assertEqual([w['order'] for w in writes],sorted(w['order'] for w in writes))
        self.assertEqual(writes[1]['positions'],[3,2,1,0])
    def test_ownership_and_plan_corruption_rejected(self):
        ir=parse_scalable(self.memory(),'T','clk');a=copy.deepcopy(ir);a['event_plan']['watchers']=[]
        with self.assertRaisesRegex(ValueError,'plan'):validate_scalable(a)
        a=copy.deepcopy(ir);a['ownership'][0]['process']=7
        with self.assertRaises(ValueError):validate_scalable(a)
    def test_implicit_v7_old_encoder_rejected(self):
        with self.assertRaisesRegex(ValueError,'explicit'):encode(parse_scalable(self.memory(),'T','clk'))
    def test_multiple_identity_reset_roots(self):
        p=self.source("module T(input clk,r,s,d,output reg q,p);always @(posedge clk or posedge r)if(r)q<=1'b0;else q<=d;always @(posedge clk or posedge s)if(s)p<=1'b0;else p<=d;endmodule")
        ir=parse_scalable(p,'T','clk');self.assertEqual(len(ir['events']['reset_roots']),2)
    def test_unsupported_sources_stay_rejected(self):
        for event in ('clk & en','q'):
            p=self.source(f'module T(input clk,en,d,output reg q);wire g={event};always @(posedge g)q<=d;endmodule')
            with self.assertRaisesRegex(ValueError,'derived'):parse_scalable(p,'T','clk')
    def test_multiple_memory_writers_stay_rejected(self):
        p=self.source('module T(input clk,cb,a,d,output q);reg m[0:1];always @(posedge clk)m[a]<=d;always @(posedge cb)m[a]<=d;assign q=m[a];endmodule')
        with self.assertRaisesRegex(ValueError,'multiple memory'):parse_scalable(p,'T','clk',event_clocks=('clk','cb'))
    def test_dynamic_slice_stays_rejected(self):
        with self.assertRaises(ValueError):parse_scalable(self.memory(body='m[a][a +: 2]<=d[1:0];'),'T','clk')
    def test_latch_feedback_stays_rejected(self):
        p=self.source('module T(input clk,d,output reg q);always_latch if(!clk)q=q|d;endmodule')
        with self.assertRaisesRegex(ValueError,'feedback'):parse_scalable(p,'T','clk')
    def test_combinational_cycle_stays_rejected(self):
        p=self.source('module T(input clk,output reg q);wire a;assign a=~a;always @(posedge clk)q<=a;endmodule')
        with self.assertRaisesRegex(ValueError,'cycle'):parse_scalable(p,'T','clk')
    def test_deep_alias_schedule_is_iterative(self):
        aliases='wire a0=d;'+''.join(f'wire a{i}=a{i-1};' for i in range(1,2048))
        p=self.source('module T(input clk,d,output reg q);'+aliases+'always @(posedge clk)q<=a2047;endmodule')
        ir=parse_scalable(p,'T','clk');self.assertEqual(len(ir['order']),2048)
    def test_original_ports_are_not_classified_by_private_prefix(self):
        p=self.source('module T(input clk,__c2l_read_payload,output reg __c2l_write_result);always @(posedge clk)__c2l_write_result<=__c2l_read_payload;endmodule')
        _,m=encode_scalable(parse_scalable(p,'T','clk'))
        self.assertEqual({p['name'] for p in m['ports']},{'clk','__c2l_read_payload','__c2l_write_result'})
    def test_bench_exact_stream_detects_missing_words(self):
        import gzip
        from fourstate_scalable_bench import compare_streams
        ir=parse_scalable(self.memory(),'T','clk');_,m=encode_scalable(ir)
        for name in ('a.gz','b.gz'):
            with gzip.open(self.root/name,'wt') as f:f.write('C2L 0 0 S 0 0 0\nC2L 0 1 S 0 0 0\n')
        with self.assertRaises(ValueError):compare_streams(self.root/'a.gz',self.root/'b.gz',m,1)
    def test_invalid_initial_and_input_bits_rejected(self):
        from fourstate_scalable_bench import rails,make_bench
        with self.assertRaises(ValueError):rails('bad')
        _,m=encode_scalable(parse_scalable(self.memory(),'T','clk'))
        row={'inputs':{p['name']:'0'*p['width'] for p in m['ports'] if p['direction']=='input'}}
        with self.assertRaises(ValueError):make_bench(m,[row],'?',True)
        row['inputs']['a']='0'
        with self.assertRaises(ValueError):make_bench(m,[row],'0',True)


if __name__=='__main__':unittest.main()
