"""Private F53 representation and fail-closed boundaries, using bound RTL."""
import copy,os,sys,unittest,uuid
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
from fourstate_stateflow import parse_compact,lower_small,validate_compact
from fourstate_frontend import parse
from fourstate_encode import encode
from fourstate_bounded_events import validate_trace

class CompactState(unittest.TestCase):
    def setUp(self):
        self.root=Path(os.environ['TMPDIR'])/('unit-'+uuid.uuid4().hex);self.root.mkdir()
    def source(self,text):
        p=self.root/'T.sv';p.write_text(text);return p
    def model(self,body='if(en)m[a]<=d;',shape='[0:1]'):
        return self.source('module T(input clk,cb,en,input [2:0] a,input [3:0] d,output [3:0] q);reg [3:0] m'+shape+';always @(posedge clk)begin '+body+'end assign q=m[a];endmodule')
    def test_depth_does_not_enumerate_words(self):
        counts=[]
        for depth in (2,32,1024,6144):
            ir=parse_compact(self.model(shape=f'[0:{depth-1}]'),'T','clk')
            self.assertNotIn('words',ir['memories'][0]);self.assertEqual(len(ir['states']),1);counts.append(len(ir['nodes']))
        self.assertEqual(len(set(counts)),1)
    def test_explicit_lowering_required(self):
        ir=parse_compact(self.model(),'T','clk')
        with self.assertRaisesRegex(ValueError,'explicit'):encode(ir)
        with self.assertRaisesRegex(ValueError,'selected'):lower_small(ir,allowed_tops=[])
        rtl,m=encode(lower_small(ir,allowed_tops=['T']));self.assertEqual(len(m['states']),2)
    def test_legacy_restrictions_unchanged(self):
        p=self.model(shape='[0:32]')
        with self.assertRaisesRegex(ValueError,'budget'):parse(p,'T','sequential','clk',bounded_memories=True)
        with self.assertRaisesRegex(ValueError,'no memory'):parse(p,'T','sequential','clk',bounded_memories=True,bounded_events=True)
    def test_old_reads_and_ordered_static_slices(self):
        ir=parse_compact(self.model('m[a]<=d;m[0][1 +: 2]<=m[1][1:0];m[0][1:0]<=d[1:0];'),'T','clk')
        writes=[n for n in ir['nodes'] if n['op']=='memory_write'];self.assertEqual(len(writes),3)
        self.assertEqual(writes[1]['positions'],[2,1]);self.assertEqual(writes[2]['positions'],[1,0])
        self.assertEqual(writes[1]['args'][0],writes[0]['id']);self.assertEqual(writes[2]['args'][0],writes[1]['id'])
        self.assertTrue(all(len(n['args'])==1 for n in ir['nodes'] if n['op']=='memory_read'))
    def test_multidriver_and_dynamic_slice_rejected(self):
        for body,reason in [('m[a][a]<=en;','structural'),('m[a]=d;','nonblocking')]:
            with self.assertRaises(ValueError):parse_compact(self.model(body),'T','clk')
        p=self.source('module T(input clk,cb,a,d,output q);reg m[0:1];always @(posedge clk)m[a]<=d;always @(posedge cb)m[a]<=d;assign q=m[a];endmodule')
        with self.assertRaisesRegex(ValueError,'multiple memory'):parse_compact(p,'T','clk',event_clocks=['clk','cb'])
    def test_async_memory_writer_rejected(self):
        p=self.source('module T(input clk,r,a,d,output q);reg m[0:1];always @(posedge clk or posedge r)if(r)m[0]<=0;else m[a]<=d;assign q=m[a];endmodule')
        with self.assertRaisesRegex(ValueError,'asynchronous memory reset'):parse_compact(p,'T','clk')
    def test_ownership_corruption_is_detected(self):
        ir=parse_compact(self.model(),'T','clk')
        for field in ('process','trigger','writer'):
            m=copy.deepcopy(ir)
            if field=='process':m['states'][0]['process']=99
            elif field=='trigger':m['events']['processes'][0]['triggers'][0]['edge']='NegEdge'
            else:next(n for n in m['nodes'] if n['op']=='memory_write')['process']=99
            with self.assertRaises((ValueError,IndexError)):validate_compact(m)
    def test_initial_and_event_trace_contract(self):
        _,m=encode(lower_small(parse_compact(self.model(),'T','clk'),allowed_tops=['T']))
        row={p['name']:'0'*p['width'] for p in m['ports'] if p['direction']=='input'}
        initial={s['name']:'x'*s['width'] for s in m['states']}
        validate_trace(m,[dict(inputs=row)],initial)
        with self.assertRaisesRegex(ValueError,'initial states'):validate_trace(m,[dict(inputs=row)],{})
        bad=dict(row,clk='1',en='1')
        with self.assertRaisesRegex(ValueError,'Simultaneous'):validate_trace(m,[dict(inputs=row),dict(inputs=bad)],initial)
    def test_derived_clock_race_and_feedback_rejected(self):
        for event in ('clk & en','q'):
            p=self.source(f'module T(input clk,en,a,d,output q);reg m[0:1];wire g={event};always @(posedge g)m[a]<=d;assign q=m[a];endmodule')
            with self.assertRaises(ValueError):parse_compact(p,'T','clk')

if __name__=='__main__':unittest.main()
