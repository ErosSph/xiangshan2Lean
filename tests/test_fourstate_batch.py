"""Actual Job Object limits and batch-stage bookkeeping boundaries."""
from pathlib import Path
import os
import sys
import unittest
import uuid

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'scripts'))
sys.path.insert(0,str(ROOT/'scripts/verification/four_state'))
from audit_fourstate_batch import bounded,category


@unittest.skipUnless(os.name=='nt','Windows Job Object implementation')
class BatchLimits(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.folder=ROOT/'experiments/fourstate/batch-tests'/uuid.uuid4().hex
        cls.folder.mkdir(parents=True)

    def run_child(self,code,**kwargs):
        return bounded([sys.executable,'-B','-c',"import sys; assert sys.stdin.readline().strip()=='GO'; "+code],
                       self.folder/self._testMethodName,**kwargs)

    def test_success_and_actual_memory_measurement(self):
        r=self.run_child("a=bytearray(1024*1024);print('OK')")
        self.assertEqual(r['exit_code'],0);self.assertGreater(r['peak_job_committed_bytes'],1024*1024)

    def test_wall_timeout_kills_only_own_job(self):
        r=self.run_child('import time;time.sleep(5)',seconds=0.3)
        self.assertEqual(r['termination'],'TIMEOUT');self.assertNotEqual(r['exit_code'],0)

    def test_committed_memory_limit(self):
        r=self.run_child('a=bytearray(128*1024*1024)',memory=40*1024**2)
        self.assertNotEqual(r['exit_code'],0);self.assertLessEqual(r['peak_job_committed_bytes'],40*1024**2)

    def test_output_limit_keeps_failed_directory(self):
        r=self.run_child("import time;[(print('x'*1024,flush=True),time.sleep(0.01)) for _ in range(1000)]",output_limit=4096)
        self.assertEqual(r['termination'],'OUTPUT_LIMIT')
        self.assertTrue((self.folder/self._testMethodName/'stdout.log').exists())

    def test_no_overwrite(self):
        p=self.folder/self._testMethodName;p.mkdir()
        with self.assertRaises(FileExistsError):bounded([sys.executable,'-V'],p)

    def test_diagnostic_categories(self):
        self.assertEqual(category('process locals with async events are outside the F4.3 subset'),'async_event_scope')
        self.assertEqual(category('initial/nonclocked process execution unsupported'),'latch_or_nonclocked')
        self.assertEqual(category('C:\\macro\\DpiPort.v:3:8: at least one top output required (Instance)'),'standalone_no_output')
        self.assertEqual(category('C:\\LoadPipe.sv:146:33: declaration initializer unsupported (Variable)'),'process_local')

    def test_existing_data_transport_with_reviewed_entry(self):
        import subprocess
        from unittest.mock import patch
        from verify_fourstate_blockers import remote_call
        folder=self.folder/self._testMethodName;folder.mkdir()
        def reply(command,**kwargs):
            source=kwargs['input'].decode('ascii')
            self.assertIn("sys.modules['audit_fourstate_batch_remote'].main(",source)
            self.assertIn('StrictHostKeyChecking=yes',command)
            return subprocess.CompletedProcess(command,0,b'{"status":"MOCK_TRANSPORT_ONLY"}',b'')
        with patch('verify_fourstate_blockers.subprocess.run',side_effect=reply):
            r=remote_call(folder,dict(operation='acquire'),entry='audit_fourstate_batch_remote')
        self.assertEqual(r['status'],'MOCK_TRANSPORT_ONLY')
        with self.assertRaises(ValueError):remote_call(folder,{},entry='arbitrary_command')

    def test_hash_mismatch_is_not_a_semantic_rejection(self):
        import io,json
        from unittest.mock import patch
        from audit_fourstate_batch import worker
        folder=self.folder/self._testMethodName;folder.mkdir()
        source=folder/'T.sv';source.write_text('module T; endmodule\n',encoding='utf8')
        request=dict(module='T',source=str(source),input_hashes={str(source):'0'*64},mode='combinational')
        with patch('sys.stdin',io.StringIO('GO\n')):self.assertEqual(worker(request,folder),2)
        report=json.loads((folder/'result.json').read_text())
        self.assertEqual(report['status'],'INPUT_HASH_MISMATCH');self.assertFalse((folder/'encoded.sv').exists())

    def test_wrapper_clock_comes_from_child_binding(self):
        import json
        from audit_fourstate_batch import select_modules
        folder=self.folder/self._testMethodName;folder.mkdir()
        child=dict(name='Child',file='Child.sv',features={},instances=[],ports=[dict(name='c',direction='input')],
                   processes=[dict(events=[dict(expr='c')],clock_events=[dict(expr='c')])])
        wrapper=dict(name='Wrapper',file='Wrapper.sv',features={},processes=[],ports=[dict(name='tick',direction='input')],
                     instances=[dict(module='Child',bindings=[dict(formal='c',expr='tick',expr_kind='IdentifierName')])])
        (folder/'facts.json').write_text(json.dumps([child,wrapper]));(folder/'inventory.json').write_text(json.dumps(dict(files=[dict(name=n,bytes=30,sha256='0'*64) for n in ['Child.sv','Wrapper.sv']])))
        (folder/'hierarchy.json').write_text(json.dumps(dict(instances=[dict(module='Wrapper'),dict(module='Child')])))
        r=select_modules(folder/'facts.json',folder/'inventory.json',folder/'hierarchy.json',folder/'selection.json')
        w=next(x for x in r['ledger'] if x['module']=='Wrapper')
        self.assertEqual(w['mode'],'sequential');self.assertEqual(w['clock'],'tick')

    def test_ledger_does_not_promote_encoding_to_behavior_pass(self):
        import json
        from audit_fourstate_batch import aggregate,STAGES
        folder=self.folder/self._testMethodName;folder.mkdir()
        ledger=[dict(module='A',selection='ELIGIBLE',instances=3),dict(module='B',selection='SKIPPED_CLOSURE_BUDGET',instances=7)]
        (folder/'selection.json').write_text(json.dumps(dict(ledger=ledger,global_instances=10)))
        stages={s:'PASS' if s in ('preprocessed','fourstate_ir','encoded_rtl') else 'NOT_RUN' for s in STAGES}
        (folder/'result.json').write_text(json.dumps(dict(results=[dict(module='A',status='COMPLETED',stages=stages)])))
        r=aggregate(folder/'selection.json',[folder/'result.json'],folder/'aggregate')
        self.assertEqual(r['definitions'],2);self.assertEqual(r['attempted'],1)
        self.assertEqual(r['stages']['encoded_rtl']['weighted_instances'],3)
        self.assertEqual(r['stages']['three_way']['definitions'],0)

    def test_parser_integrity_is_a_hard_stop_status(self):
        import io,json
        from unittest.mock import patch
        from audit_fourstate_batch import worker
        folder=self.folder/self._testMethodName;folder.mkdir()
        with patch('sys.stdin',io.StringIO('GO\n')),patch('fourstate_frontend.parse',side_effect=RuntimeError('Four-state parser file changed: library')):
            self.assertEqual(worker(dict(module='T',source=str(folder/'T.sv'),mode='combinational'),folder),2)
        self.assertEqual(json.loads((folder/'result.json').read_text())['status'],'TOOL_INTEGRITY_MISMATCH')


if __name__=='__main__':unittest.main()
