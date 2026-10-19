"""Private cache advice and lossless native-output transport contracts."""
import gzip
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
from fourstate_backend_cache import advise, ArtifactCache
from fourstate_backend_pipes import JSONPipes


@unittest.skipUnless(sys.platform=='linux','Private Linux artifact IO')
class PrivateStorage(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory();self.run=Path(self.temp.name)
        self.out=self.run/'reports/test';self.out.mkdir(parents=True)

    def tearDown(self):self.temp.cleanup()

    def test_cache_advice_preserves_bytes_and_metadata(self):
        path=self.out/'data.json';payload=b'0123456789'*100000;path.write_bytes(payload)
        before=path.stat();digest=hashlib.sha256(payload).hexdigest()
        row=advise(path,self.run)
        after=path.stat()
        self.assertEqual((before.st_ino,before.st_size,before.st_mtime_ns,before.st_ctime_ns),(after.st_ino,after.st_size,after.st_mtime_ns,after.st_ctime_ns))
        self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(),digest)
        self.assertEqual(row['bytes'],len(payload))

    def test_cache_advice_rejects_links_and_out_of_reports(self):
        source=self.out/'source';source.write_bytes(b'data')
        link=self.out/'symbolic';link.symlink_to(source)
        with self.assertRaises(ValueError):advise(link,self.run)
        hard=self.out/'hard';os.link(source,hard)
        with self.assertRaises(ValueError):advise(hard,self.run)
        outside=self.run/'outside';outside.write_bytes(b'data')
        with self.assertRaises(ValueError):advise(outside,self.run)

    def test_native_fifo_bytes_and_gzip_roundtrip(self):
        pipes=JSONPipes(self.out,['named.json','lowered.json'])
        code='from pathlib import Path;import sys; p=Path(sys.argv[1]); data=b\'{"integer":9007199254740993,"empty":{},"bits":[0,1]}\\n\'*32768; (p/"named.json").write_bytes(data); (p/"lowered.json").write_bytes(data)'
        done=subprocess.run([sys.executable,'-I','-B','-c',code,str(self.out)],capture_output=True)
        rows=pipes.finish(done.returncode)
        self.assertEqual(done.returncode,0,done.stderr)
        expected=b'{"integer":9007199254740993,"empty":{},"bits":[0,1]}\n'*32768
        for row in rows:
            self.assertEqual(gzip.decompress(Path(row['archive']).read_bytes()),expected)
            self.assertEqual(row['sha256'],hashlib.sha256(expected).hexdigest())
            self.assertFalse(Path(row['logical']).exists())

    def test_failed_or_absent_producer_cannot_register_complete_artifacts(self):
        pipes=JSONPipes(self.out,['unconstrained.json'])
        rows=pipes.finish(1)
        self.assertEqual(rows[0]['bytes'],0)
        self.assertTrue(Path(rows[0]['archive']).is_file())
        pipes=JSONPipes(self.out,['lowered.json'])
        with self.assertRaisesRegex(RuntimeError,'did not complete'):pipes.finish(0)

    def test_cache_watcher_preserves_artifact(self):
        folder=self.out/'translation/attempt/artifacts';folder.mkdir(parents=True)
        path=folder/'before.il';path.write_bytes(b'original artifact\n'*10000)
        before=hashlib.sha256(path.read_bytes()).hexdigest()
        cache=ArtifactCache(self.run,self.out);cache.start();cache.finish()
        self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(),before)


if __name__=='__main__':unittest.main()
