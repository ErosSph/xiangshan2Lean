"""Transfer safety tests; fixtures stay in the ignored, project-local cache."""
import copy
import io
import os
from pathlib import Path
import stat
import sys
import types
import unittest
import uuid
import zipfile
from unittest.mock import patch

ROOT=Path(__file__).absolute().parents[1]
sys.path.insert(0,str(ROOT/'scripts'))
sys.path.insert(0,str(ROOT/'scripts/verification/four_state'))
import fourstate_sync as local
import fourstate_sync_common as common
import fourstate_sync_remote as receiver


def fixture(kind='source'):
    path='README.md' if kind=='source' else 'reports/summary.json'
    data=b'example\n'
    m=dict(format='fourstate-sync-'+kind+'-v1',snapshot_id='snapshot-test',
           files=[dict(path=path,bytes=len(data),sha256=common.sha(data))],bytes=len(data))
    if kind=='export':
        m.update(run_id='run-test',export_id='export-test',retained_assets=[])
    return m,{path:data}


class ArchiveSafety(unittest.TestCase):
    def test_round_trip_and_wrong_manifest_hash(self):
        for kind in ('source','export'):
            m,p=fixture(kind); data=common.make_zip(m,p,kind)
            self.assertEqual(common.inspect_zip(data,kind,common.sha(common.encoded(m)))[2],p)
            with self.assertRaisesRegex(ValueError,'manifest SHA256'):
                common.inspect_zip(data,kind,'0'*64)

    def test_unsafe_paths_and_ids(self):
        for name in ('/x','../x','a/../x','a//x','a\\x','C:/x','NUL.txt','a.','a ','x\nq','a:x'):
            with self.subTest(name=name),self.assertRaises(ValueError):common.relative(name)
        for value in ('../x','a;touch x','',None,'a/b'):
            with self.assertRaises(ValueError):common.identifier(value)

    def test_duplicate_json_keys(self):
        with self.assertRaises(ValueError):common.loads('{"files":[],"files":[]}')

    def test_excluded_tracked_files(self):
        for name in ('.git/config','experiments/test/source.py','generated/Model.lean','.tools/bin/tool',
                     '.cache/a.json','target/x','foo.olean','foo.exe'):
            with self.assertRaises(ValueError):common.source_path(name)

    def test_duplicate_case_and_file_directory_collision(self):
        m,p=fixture()
        for other in ('readme.md','README.md/x'):
            bad=copy.deepcopy(m); row=copy.deepcopy(bad['files'][0]); row['path']=other
            bad['files'].append(row);bad['bytes']*=2
            with self.assertRaises(ValueError):common.records(bad,'source')

    def test_over_budget_and_bad_sizes(self):
        m,p=fixture('export');m['files'][0]['bytes']=common.EXPORT_LIMIT+1;m['bytes']=common.EXPORT_LIMIT+1
        with self.assertRaises(ValueError):common.records(m,'export')
        for n in (-1,True,'8'):
            m,p=fixture();m['files'][0]['bytes']=n
            with self.assertRaises(ValueError):common.records(m,'source')

    def test_return_scope(self):
        for path in ('scripts/source.py','../docs/a','work/large.ir.json'):
            m,p=fixture('export');m['files'][0]['path']=path
            with self.assertRaises(ValueError):common.records(m,'export')

    def test_reject_zip_paths_duplicates_links_and_unlisted_entries(self):
        m,p=fixture(); original=common.make_zip(m,p,'source')
        for name,mode in (('../escape',stat.S_IFREG),('src/readme.md',stat.S_IFREG),
                          ('src/link',stat.S_IFLNK),('src/fifo',stat.S_IFIFO),('src/extra',stat.S_IFREG)):
            buffer=io.BytesIO(original)
            with zipfile.ZipFile(buffer,'a') as z:
                item=zipfile.ZipInfo(name);item.create_system=3;item.external_attr=(mode|0o400)<<16
                z.writestr(item,b'x')
            with self.assertRaises((ValueError,KeyError)):common.inspect_zip(buffer.getvalue(),'source')

    def test_manifest_digest_and_whitelist_are_independent(self):
        m,p=fixture(); data=common.make_zip(m,p,'source')
        with self.assertRaisesRegex(ValueError,'frozen whitelist'):
            common.inspect_zip(data,'source',allowed_paths=['OTHER.md'])
        m['files'][0]['sha256']='0'*64
        with self.assertRaises(ValueError):common.make_zip(m,p,'source')

    def test_corrupt_or_interrupted_archive(self):
        m,p=fixture(); data=common.make_zip(m,p,'source')
        with self.assertRaises(zipfile.BadZipFile):common.inspect_zip(data[:len(data)//2],'source')


class LocalSafety(unittest.TestCase):
    def setUp(self):
        self.base=ROOT/'.cache/fourstate-sync-tests'/uuid.uuid4().hex
        self.base.mkdir(parents=True)
        self.override=patch.object(local,'ROOT',self.base);self.override.start()
        (self.base/'verification/fourstate').mkdir(parents=True)
        self.profile=self.base/'verification/fourstate/sync-profile-f3.1.json'
        self.profile.write_bytes(common.encoded(dict(files=['README.md'],excluded=['experiments/'])))
        (self.base/'README.md').write_bytes(b'working bytes, not HEAD\n')
        def git(*args):
            if args[0]=='status':return b' M README.md\0?? new.txt\0'
            if args[0]=='rev-parse':return b'1234567890\n'
            if args[0]=='branch':return b'main\n'
            return b'example diff\n'
        self.git=patch.object(local,'git',side_effect=git);self.git.start()

    def tearDown(self):
        self.git.stop();self.override.stop()

    def test_preview_reads_working_bytes_and_has_no_writes(self):
        with patch.object(local,'new_file',side_effect=AssertionError),patch.object(local,'remote',side_effect=AssertionError):
            manifest,c=local.preview()
        self.assertEqual(manifest['files'][0]['sha256'],common.sha((self.base/'README.md').read_bytes()))
        self.assertIn('?? new.txt',manifest['git']['selected_status_porcelain_z'])
        self.assertFalse((self.base/'.cache').exists())

    def test_pack_and_double_pack_no_overwrite(self):
        result=local.pack(snapshot='unique-snapshot')
        self.assertEqual(result['files'],1)
        folder,m,r,p=local.frozen('unique-snapshot')
        before=(folder/'bundle.zip').read_bytes()
        with self.assertRaises(FileExistsError):local.pack(snapshot='unique-snapshot')
        self.assertEqual((folder/'bundle.zip').read_bytes(),before)

    def test_stale_source_and_tampered_archive(self):
        local.pack(snapshot='frozen-snapshot')
        (self.base/'README.md').write_bytes(b'changed')
        with self.assertRaisesRegex(ValueError,'source changed since Pack'):local.frozen('frozen-snapshot')
        folder=self.base/'.cache/fourstate-sync/frozen-snapshot'
        (folder/'bundle.zip').write_bytes(b'corrupt')
        with self.assertRaisesRegex(ValueError,'archive changed'):local.frozen('frozen-snapshot',False)

    def test_edits_during_pack_leave_no_complete_marker(self):
        original=local.stable_read;calls=[0]
        def unstable(path,*args):
            if Path(path)==self.base/'README.md':
                calls[0]+=1
                if calls[0]>1:return b'edited during freeze'
            return original(path,*args)
        with patch.object(local,'stable_read',side_effect=unstable),self.assertRaises(ValueError):
            local.pack(snapshot='incomplete-snapshot')
        folder=self.base/'.cache/fourstate-sync/incomplete-snapshot'
        self.assertFalse((folder/'COMPLETE').exists())
        self.assertTrue((folder/'FAILED.json').exists())

    def test_reparse_ancestor(self):
        original=Path.lstat
        def lstat(path,*args,**kwargs):
            if path==self.base/'junction':return types.SimpleNamespace(st_mode=stat.S_IFDIR,st_file_attributes=0x400)
            return original(path,*args,**kwargs)
        with patch.object(Path,'lstat',lstat),self.assertRaisesRegex(ValueError,'reparse'):
            local.checked(self.base,'junction/file.txt')

    def test_local_outside_root_and_existing_file(self):
        with self.assertRaises(ValueError):local.checked(self.base.parent,'outside.txt')
        before=(self.base/'README.md').read_bytes()
        with self.assertRaises(FileExistsError):local.new_file(self.base/'README.md',b'overwrite')
        self.assertEqual((self.base/'README.md').read_bytes(),before)

    def test_existing_pull_destination_is_not_overwritten(self):
        dest=self.base/'runs/fourstate/run-test/imports/export-test';dest.mkdir(parents=True)
        receipt=dict(download_path=common.WORKSPACE+'/runs/run-test/exports/export-test/bundle.zip',archive_bytes=10)
        with patch.object(local,'remote',return_value=receipt),patch.object(local,'scp') as transport:
            with self.assertRaises(FileExistsError):local.pull('run-test','export-test')
            transport.assert_not_called()

    def test_git_reads_disable_optional_index_writes(self):
        self.git.stop()
        with patch.object(local.subprocess,'check_output',return_value=b'ok') as command:
            local.git('status','--porcelain=v1')
        self.assertIn('--no-optional-locks',command.call_args.args[0])
        self.git.start()

    def test_scp_failure_keeps_receipts_and_existing_data(self):
        log=self.base/'transport';log.mkdir()
        existing=self.base/'existing.txt';existing.write_bytes(b'preserve')
        response=types.SimpleNamespace(returncode=1,stdout=b'partial',stderr=b'disconnected')
        with patch.object(local.subprocess,'run',return_value=response),self.assertRaises(RuntimeError):
            local.scp('source.zip','amax:/guarded/new-slot.zip',log)
        self.assertEqual(existing.read_bytes(),b'preserve')
        self.assertEqual((log/'scp-stderr.log').read_bytes(),b'disconnected')
        self.assertTrue((log/'scp-result.json').is_file())


class ReceiverSafety(unittest.TestCase):
    def test_oversized_export_stops_before_creating_any_files(self):
        from contextlib import contextmanager
        class Fake:
            device=7
            def __init__(self):self.written=[]
            @contextmanager
            def directory(self,*args,**kwargs):yield 11
            def new_file(self,*args):self.written.append(args)
        guard=Fake()
        request=dict(run_id='r',export_id='e',snapshot_id='s',files=['logs/large.log'])
        info=types.SimpleNamespace(st_mode=stat.S_IFREG,st_dev=7,st_size=common.EXPORT_LIMIT+1)
        with patch.object(receiver,'verify_release',return_value={'manifest_sha256':'0'*64}),patch.object(receiver.os,'stat',return_value=info):
            with self.assertRaisesRegex(ValueError,'100 MiB'):receiver.export_result(guard,request)
        self.assertEqual(guard.written,[])

    def test_existing_incomplete_release_never_prepares_upload(self):
        class Fake:
            def exists(self,path):return True
        request=dict(snapshot_id='existing',transfer_id='fresh',archive_sha256='0'*64,manifest_sha256='1'*64)
        with patch.object(receiver,'verify_release',side_effect=FileNotFoundError('COMPLETE')):
            with self.assertRaises(FileNotFoundError):receiver.prepare(Fake(),request)

    def test_noatime_failure_does_not_retry(self):
        fake=types.SimpleNamespace(O_RDONLY=0,O_NOFOLLOW=1,O_NOATIME=2,O_NONBLOCK=4,
                                   open=lambda *a,**k:(_ for _ in ()).throw(PermissionError('noatime')))
        from contextlib import contextmanager
        class Fake(receiver.Guard):
            @contextmanager
            def directory(self,*args,**kwargs):yield 11
        guard=object.__new__(Fake)
        with patch.object(receiver,'os',fake),self.assertRaises(PermissionError):guard.read('a.txt',10)

    def test_receiver_has_no_external_execution_or_deletion(self):
        import ast
        tree=ast.parse((ROOT/'scripts/fourstate_sync_remote.py').read_text())
        for node in ast.walk(tree):
            if isinstance(node,ast.Call):
                name=node.func.attr if isinstance(node.func,ast.Attribute) else getattr(node.func,'id','')
                self.assertNotIn(name,{'unlink','remove','rmtree','rename','replace','system','Popen','run','extractall'})
        self.assertNotIn("WORKSPACE =",(ROOT/'scripts/fourstate_sync_remote.py').read_text())


if __name__=='__main__':unittest.main()
