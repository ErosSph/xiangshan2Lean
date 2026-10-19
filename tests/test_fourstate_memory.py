"""Memory scope, state ownership and compatibility: actual official parser tests."""
from pathlib import Path
import sys
import unittest
import uuid

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'scripts'))
sys.path.insert(0,str(ROOT/'scripts/verification/four_state'))
from fourstate_frontend import parse
from fourstate_encode import encode
from verify_fourstate_memory import fixture, reference_mapping


class MemoryBoundary(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.root=ROOT/'experiments/fourstate/memory-tests'/uuid.uuid4().hex
        cls.root.mkdir(parents=True)

    def source(self,text):
        p=self.root/(self._testMethodName+'.sv');p.write_text(text,encoding='utf8');return p

    def test_default_still_rejects_memory(self):
        p=self.source(fixture('T',2,3,2))
        with self.assertRaisesRegex(ValueError,'unpacked dimensions|packed vector'):parse(p,'T','sequential','clk')

    def test_words_are_persistent_state_and_have_original_paths(self):
        p=self.source(fixture('T',4,5,3));ir=parse(p,'T','sequential','clk',bounded_memories=True)
        self.assertEqual({s['rtl_path'] for s in ir['states']},{f'Memory[{i}]' for i in range(4)})
        self.assertEqual(sum(s['width'] for s in ir['states']),20)
        self.assertEqual(set(ir['next_state']),{s['name'] for s in ir['states']})
        self.assertIn('unpacked_memory',ir['capabilities'])
        rtl,mapping=encode(ir);self.assertEqual(mapping['memories'],ir['memories']);self.assertEqual(len(mapping['states']),4)

    def test_reference_only_mapping_has_required_rails(self):
        from fourstate_sequential import validate
        m=reference_mapping('T',2,3,2)
        ports={p['name']:'0'*p['width'] for p in m['ports'] if p['direction']=='input'}
        validate(m,[dict(inputs=ports)],{s['name']:'xxx' for s in m['states']})

    def test_static_indices_and_nonzero_descending_bounds(self):
        p=self.source('module T(input clk,input [1:0] a,input [2:0] d,output [2:0] q);reg [2:0] m[3:2];always @(posedge clk) m[2]<=d;assign q=m[3];endmodule')
        ir=parse(p,'T','sequential','clk',bounded_memories=True)
        self.assertEqual(ir['memories'][0]['indices'],[2,3]);encode(ir)

    def test_expansion_budget_is_enforced(self):
        for depth,width in [(33,2),(32,33)]:
            p=self.root/(self._testMethodName+str(depth)+str(width)+'.sv');p.write_text(fixture('T',depth,width,6))
            with self.assertRaisesRegex(ValueError,'budget'):parse(p,'T','sequential','clk',bounded_memories=True)

    def test_hierarchy_retains_independent_memory_paths(self):
        text='''module Leaf(input clock,en,addr,input [2:0] d,output [2:0] q);
          reg [2:0] m[0:1];always @(posedge clock) if(en)m[addr]<=d;assign q=m[addr];endmodule
        module T(input clk,e0,e1,a,input [2:0] d,output [2:0] q0,q1);
          Leaf x(.clock(clk),.en(e0),.addr(a),.d(d),.q(q0));
          Leaf y(.clock(clk),.en(e1),.addr(a),.d(d),.q(q1));endmodule'''
        ir=parse(self.source(text),'T','sequential','clk',bounded_memories=True)
        self.assertEqual({s['rtl_path'] for s in ir['states']},{f'{n}.m[{i}]' for n in ('x','y') for i in range(2)})
        self.assertEqual(len(ir['memories']),2)
        self.assertEqual(len(set(ir['next_state'])),4)

    def test_unrepresentable_index_is_not_truncated(self):
        text='module T(input clk,a,input [2:0] d,output [2:0] q);reg [2:0] m[2:3];always @(posedge clk)m[a]<=d;assign q=m[a];endmodule'
        ir=parse(self.source(text),'T','sequential','clk',bounded_memories=True)
        # Neither 2 nor 3 fits the one-bit address; both write enables must
        # lower to known false, rather than aliases of address 0 or 1.
        nodes=ir['nodes']
        for root in ir['next_state'].values():
            condition=nodes[nodes[root]['args'][0]]
            self.assertEqual((condition['op'],condition.get('bits')),('const','0'))

    def test_linux_helper_is_python38_and_has_bounded_fixed_commands(self):
        import ast
        text=(ROOT/'scripts/verification/four_state/verify_fourstate_memory_remote.py').read_text(encoding='utf8')
        tree=ast.parse(text,feature_version=(3,8))
        calls={ast.unparse(n.func) for n in ast.walk(tree) if isinstance(n,ast.Call)}
        self.assertFalse(calls & {'os.remove','os.unlink','os.rmdir','os.system','shutil.rmtree'})
        self.assertIn('resource.setrlimit',calls);self.assertIn('os.killpg',calls)
        self.assertNotIn('shell=True',text)
        self.assertIn('original_bytes(reader,path',text)
        self.assertIn('guard.new_file(dest,data)',text)

    def test_linux_helper_uses_existing_reviewed_transport(self):
        import subprocess
        from unittest.mock import patch
        from verify_fourstate_blockers import remote_call
        folder=self.root/self._testMethodName;folder.mkdir()
        def reply(argv,**kwargs):
            code=kwargs['input'].decode('ascii')
            self.assertIn("sys.modules['verify_fourstate_memory_remote'].main(",code)
            self.assertIn('StrictHostKeyChecking=yes',argv)
            return subprocess.CompletedProcess(argv,0,b'{"status":"MOCK_TRANSPORT_ONLY"}',b'')
        with patch('verify_fourstate_blockers.subprocess.run',side_effect=reply):
            result=remote_call(folder,dict(operation='prepare-memory-runtime'),entry='verify_fourstate_memory_remote')
        self.assertEqual(result['status'],'MOCK_TRANSPORT_ONLY')

    def test_private_lean_compile_uses_system_threads(self):
        import json
        from unittest.mock import patch
        from fourstate2lean import compile_model
        folder=self.root/self._testMethodName;folder.mkdir();model=folder/'model';model.mkdir()
        ir=model/'ir.json';ir.write_text(json.dumps(dict(namespace='M')));(model/'M.lean').write_text('def x := 1')
        def run(argv,*args,**kwargs):
            self.assertNotIn('-j',argv);self.assertEqual(argv[1:3],['-s','65536']);(model/'M.olean').write_bytes(b'mock-compile-only');return 0
        with patch('fourstate2lean.run_logged',side_effect=run):compile_model(folder,ir)
        self.assertEqual(json.loads((folder/'lean-check/result.json').read_text())['threads'],'system default')

    def test_unsupported_memory_forms_are_located_rejections(self):
        head='module T(input clk,clk2,en,input [1:0] a,input [2:0] d,output [2:0] q);'
        cases={
            'multiwriter':'reg [2:0] m[0:1];always @(posedge clk)m[a]<=d;always @(posedge clk)m[a]<=d;assign q=m[a];',
            'secondclock':'reg [2:0] m[0:1];always @(posedge clk)m[a]<=d;reg r;always @(posedge clk2)r<=en;assign q=m[a];',
            'blocking':'reg [2:0] m[0:1];always @(posedge clk)m[a]=d;assign q=m[a];',
            'dynamicpartial':'reg [2:0] m[0:1];always @(posedge clk)m[a][a]<=en;assign q=m[a];',
            'multidimensional':'reg [2:0] m[0:1][0:1];always @(posedge clk)m[a][a]<=d;assign q=m[a][a];',
            'async':'reg [2:0] m[0:1];always @(posedge clk or posedge en)m[a]<=d;assign q=m[a];',
            'initial':'reg [2:0] m[0:1];initial m[0]=3\'b0;always @(posedge clk)m[a]<=d;assign q=m[a];',
            'wholearray':'reg [2:0] m[0:1];always @(posedge clk)m<=\'{default:3\'b0};assign q=m[a];',
        }
        for label,body in cases.items():
            with self.subTest(label=label):
                p=self.root/(self._testMethodName+label+'.sv');p.write_text(head+body+'endmodule')
                with self.assertRaises(ValueError) as caught:parse(p,'T','sequential','clk',bounded_memories=True)
                self.assertIn(str(p),str(caught.exception))


if __name__=='__main__':unittest.main()
