"""Safety checks for the real migration/cleanup workflow."""
import importlib.util
import json
import os
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location('migration', ROOT/'scripts/migrate_workspace.py')
migration = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(migration)


class MigrationTests(unittest.TestCase):
    def setUp(self):
        self.test_root = ROOT.parent/'.migration/tests'
        self.test_root.mkdir(parents=True, exist_ok=True)
        self.temporary = tempfile.TemporaryDirectory(dir=self.test_root)
        self.base = Path(self.temporary.name).resolve()
        self.assertTrue(self.base.is_relative_to(self.test_root.resolve()))
        self.source, self.work, self.backup = (self.base/name for name in ('source','work','backup'))
        for name, data in {'src/Core.scala':b'current dirty source', '.git/config':b'git state',
                           'experiments/case/output.bin':b'generated data'*20,
                           'experiments/case/check.lean':b'theorem check : True := by trivial',
                           'target/classes.bin':b'build output'}.items():
            path=self.source/'chisel2lean4'/name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)

    def tearDown(self):
        self.assertTrue(self.base.is_relative_to(self.test_root.resolve()))
        self.assertFalse(migration.reparse(self.base.lstat()))
        self.temporary.cleanup()

    def prepare(self):
        migration.pack(self.source,self.work,self.backup)
        migration.verify(self.backup,self.base/'remote-source')

    def clean(self):
        return migration.clean(self.source,self.work,self.backup/'verified.json',
                               self.backup/'workspace.tar.zst',apply=True)

    def test_complete_roundtrip_and_preserved_code(self):
        self.prepare()
        remote=self.base/'remote-source/ICT/chisel2lean4'
        self.assertEqual((remote/'src/Core.scala').read_bytes(),b'current dirty source')
        self.assertFalse((remote/'target/classes.bin').exists())
        result=self.clean()
        self.assertEqual(result['status'],'PASS')
        self.assertFalse((self.source/'chisel2lean4/experiments/case/output.bin').exists())
        self.assertTrue((self.source/'chisel2lean4/experiments/case/check.lean').is_file())
        self.assertTrue((self.source/'chisel2lean4/.git/config').is_file())
        self.assertTrue((self.backup/'workspace.tar.zst').is_file())

    def test_changed_source_is_preserved(self):
        self.prepare()
        target=self.source/'chisel2lean4/experiments/case/output.bin'
        target.write_bytes(b'new user work')
        result=self.clean()
        self.assertEqual(result['status'],'PARTIAL')
        self.assertEqual(target.read_bytes(),b'new user work')

    def test_false_proof_cannot_authorize_cleanup(self):
        self.prepare()
        proof=self.backup/'verified.json'
        data=json.loads(proof.read_text())
        data['archive_sha256']='0'*64
        proof.write_text(json.dumps(data))
        with self.assertRaises(ValueError):
            self.clean()
        self.assertTrue((self.source/'chisel2lean4/target/classes.bin').is_file())

    def test_corrupt_archive_is_rejected(self):
        migration.pack(self.source,self.work,self.backup)
        archive=self.backup/'workspace.tar.zst'
        with archive.open('r+b') as stream:
            stream.seek(12)
            byte=stream.read(1)
            stream.seek(12)
            stream.write(bytes([byte[0]^1]))
        with self.assertRaises(Exception):
            migration.verify(self.backup,self.base/'remote-source')
        self.assertFalse((self.backup/'verified.json').exists())

    def test_prefetch_boundary_and_large_stream(self):
        for index in range(70):
            path=self.source/'chisel2lean4/experiments/case'/f'part-{index}.bin'
            path.write_bytes(bytes([index])*128)
        (self.source/'chisel2lean4/experiments/case/large.bin').write_bytes(b'z'*(migration.BLOCK+1))
        self.prepare()
        verified=json.loads((self.backup/'verified.json').read_text())
        self.assertEqual(verified['counts']['file'],76)
        self.assertEqual(self.clean()['status'],'PASS')

    def test_paths_cannot_escape(self):
        for name in ('../other','/etc/passwd','C:/other','abc/../../other','abc\\outside'):
            with self.assertRaises(ValueError):
                migration.safe_local(self.source,name)
        if os.name=='nt' and (ROOT/'.tools').exists():
            with self.assertRaises(ValueError):
                migration.safe_local(ROOT.parent,'chisel2lean4/.tools/bin/tool')

    def test_missing_or_wrong_remote_presence_cannot_delete(self):
        self.prepare()
        with self.assertRaises(ValueError):
            migration.clean(self.source,self.work,self.backup/'verified.json',apply=True)
        presence=self.base/'presence.json'
        presence.write_text(json.dumps({'status':'PASS','checked_at':migration.now(),
                                       'archive_sha256':'0'*64,'compressed_bytes':0}))
        with self.assertRaises(ValueError):
            migration.clean(self.source,self.work,self.backup/'verified.json',presence=presence,apply=True)
        self.assertTrue((self.source/'chisel2lean4/target/classes.bin').is_file())


if __name__=='__main__':
    unittest.main()
