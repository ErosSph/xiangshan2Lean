"""Input archive policy, pre-upload space check and SHA256 readback."""
import base64
from contextlib import contextmanager
import json
from pathlib import Path
import sys
import types
import unittest
from unittest.mock import patch
import uuid

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'scripts'))
sys.path.insert(0,str(ROOT/'scripts/verification/four_state'))
import fourstate_sync_common as common
import verify_fourstate_prioritymux_remote as receiver
import verify_fourstate_blockers as client


class MemoryGuard:
    root=7
    def __init__(self,existing=False,corrupt=False):
        self.existing=existing;self.corrupt=corrupt;self.files={};self.created=[]
    def exists(self,path):return self.existing
    @contextmanager
    def directory(self,path,**kwargs):
        self.created.append(path);yield 11
    def new_file(self,path,data):
        if path in self.files:raise FileExistsError(path)
        self.files[path]=data
    def read(self,path,limit):
        return b'CORRUPTED' if self.corrupt else self.files[path]


class InputArchives(unittest.TestCase):
    def setUp(self):
        self.guard=MemoryGuard()
        self.space=patch.object(common.os,'fstatvfs',return_value=types.SimpleNamespace(f_bavail=4*1024**3,f_frsize=1),create=True)
        self.release=patch.object(receiver,'verify_release',return_value=dict(manifest_sha256='a'*64))
        self.space.start();self.release.start();self.addCleanup(self.space.stop);self.addCleanup(self.release.stop)
    def request(self,size=7):
        return dict(operation='archive-preflight',run_id='r',snapshot_id='s',version='v',
                    files=[dict(path='data.bin',bytes=size,sha256=common.sha(b'payload'))])
    def payload(self):
        r=self.request();r['operation']='archive';r['files'][0]['base64']=base64.b64encode(b'payload').decode();return r

    def test_128_mib_inclusive_limit_and_unchanged_other_limits(self):
        self.assertEqual(common.INPUT_ARCHIVE_LIMIT,128*1024**2)
        self.assertEqual(common.SOURCE_LIMIT,8*1024**2);self.assertEqual(common.EXPORT_LIMIT,100*1024**2)
        r=receiver.archive_preflight(self.guard,self.request(common.INPUT_ARCHIVE_LIMIT))
        self.assertEqual(r['status'],'ARCHIVE_READY')
        with self.assertRaisesRegex(ValueError,'128 MiB'):
            receiver.archive_preflight(self.guard,self.request(common.INPUT_ARCHIVE_LIMIT+1))
        self.assertFalse(self.guard.created);self.assertFalse(self.guard.files)

    def test_insufficient_space_refuses_before_creating_target(self):
        with patch.object(common.os,'fstatvfs',return_value=types.SimpleNamespace(f_bavail=1024**3,f_frsize=1)):
            with self.assertRaisesRegex(ValueError,'1 GiB reserve'):receiver.archive_files(self.guard,self.payload())
        self.assertFalse(self.guard.created);self.assertFalse(self.guard.files)

    def test_written_bytes_are_read_back_and_hashed(self):
        r=receiver.archive_files(self.guard,self.payload())
        self.assertEqual(r['verification'],'SHA256_READBACK_MATCH')
        self.assertEqual(r['files'][0]['sha256'],common.sha(self.guard.files['runs/r/reports/v/data.bin']))
        self.assertGreaterEqual(r['space']['free_bytes'],r['space']['required_bytes']+r['space']['reserve_bytes'])

    def test_input_hash_mismatch_has_no_writes(self):
        r=self.payload();r['files'][0]['sha256']='0'*64
        with self.assertRaisesRegex(ValueError,'payload hash'):receiver.archive_files(self.guard,r)
        self.assertFalse(self.guard.files);self.assertFalse(self.guard.created)

    def test_readback_corruption_never_produces_success_receipt(self):
        guard=MemoryGuard(corrupt=True)
        with self.assertRaisesRegex(ValueError,'written archive SHA256'):receiver.archive_files(guard,self.payload())
        self.assertNotIn('runs/r/reports/v/archive-receipt.json',guard.files)

    def test_existing_or_unsafe_targets_are_not_overwritten(self):
        with self.assertRaises(FileExistsError):receiver.archive_files(MemoryGuard(existing=True),self.payload())
        for name in ['../escape','/absolute','a/../b']:
            r=self.request();r['files'][0]['path']=name
            with self.assertRaises(ValueError):receiver.archive_preflight(self.guard,r)
        self.assertFalse(self.guard.created)

    def responses(self):
        request=self.payload();meta=self.request()['files']
        ready=dict(status='ARCHIVE_READY',bytes=7,files=meta,manifest_sha256='a'*64)
        written=dict(status='ARCHIVED',bytes=7,verification='SHA256_READBACK_MATCH',manifest_sha256='a'*64,
                     files=[dict(meta[0],path='reports/v/data.bin')])
        return request,[types.SimpleNamespace(returncode=0,stdout=json.dumps(x).encode(),stderr=b'') for x in [ready,written]]

    def test_client_checks_space_before_sending_payload_and_checks_receipt(self):
        folder=ROOT/'.cache/fourstate-sync-tests'/uuid.uuid4().hex;folder.mkdir(parents=True)
        request,responses=self.responses()
        with patch.object(client.subprocess,'run',side_effect=responses) as transport:
            result=client.remote_call(folder,request)
        self.assertEqual(result['verification'],'SHA256_READBACK_MATCH')
        self.assertEqual(transport.call_count,2)
        inputs=[call.kwargs['input'] for call in transport.call_args_list]
        self.assertNotIn(request['files'][0]['base64'].encode(),inputs[0])
        self.assertIn(request['files'][0]['base64'].encode(),inputs[1])

    def test_failed_preflight_never_transfers_payload(self):
        folder=ROOT/'.cache/fourstate-sync-tests'/uuid.uuid4().hex;folder.mkdir(parents=True)
        with patch.object(client.subprocess,'run',return_value=types.SimpleNamespace(returncode=1,stdout=b'',stderr=b'disk low')) as transport:
            with self.assertRaises(RuntimeError):client.remote_call(folder,self.payload())
        self.assertEqual(transport.call_count,1)

    def test_source_scp_preparation_also_checks_free_space_first(self):
        import fourstate_sync_remote as source_receiver
        request=dict(snapshot_id='s',transfer_id='t',archive_sha256='0'*64,manifest_sha256='1'*64)
        with patch.object(common.os,'fstatvfs',return_value=types.SimpleNamespace(f_bavail=0,f_frsize=1)):
            with self.assertRaisesRegex(ValueError,'workspace space'):source_receiver.prepare(self.guard,request)
        self.assertFalse(self.guard.files);self.assertFalse(self.guard.created)

    def test_client_refuses_inconsistent_post_transfer_hash(self):
        folder=ROOT/'.cache/fourstate-sync-tests'/uuid.uuid4().hex;folder.mkdir(parents=True)
        request,responses=self.responses();bad=json.loads(responses[1].stdout)
        bad['files'][0]['sha256']='0'*64;responses[1].stdout=json.dumps(bad).encode()
        with patch.object(client.subprocess,'run',side_effect=responses):
            with self.assertRaisesRegex(ValueError,'post-transfer SHA256'):client.remote_call(folder,request)


if __name__=='__main__':unittest.main()
