"""Integrity of the private consumer of unchanged public lowered artifacts."""
import gzip
import hashlib
import json
import os
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
from fourstate_machine_replay import lowered_json


class LoweredArtifacts(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory()
        self.root=Path(self.temp.name)
        self.payload=json.dumps({'modules':{'test':{'unicode':'a'*(1024*1024-40)+'\U0001f642','bank':[1,0,3]}}},ensure_ascii=False).encode('utf-8')
        self.manifest={'artifact_sha256':{'lowered.json':hashlib.sha256(self.payload).hexdigest()}}

    def tearDown(self):
        self.temp.cleanup()

    def test_plain_and_archive_have_identical_original_bytes(self):
        path=self.root/'lowered.json'
        path.write_bytes(self.payload)
        plain,raw=lowered_json(self.root,self.manifest)
        with gzip.open(str(path)+'.gz','wb') as stream:stream.write(self.payload)
        path.unlink()
        packed,archive=lowered_json(self.root,self.manifest)
        self.assertEqual(plain,packed)
        self.assertEqual(raw['sha256'],archive['sha256'])
        self.assertEqual(len(self.payload),archive['logical_bytes'])
        self.assertTrue(archive['compressed'])

    def test_archive_corruption_cannot_replace_original_hash(self):
        with gzip.open(self.root/'lowered.json.gz','wb') as stream:stream.write(self.payload.replace(b'"bank"',b'"Bank"'))
        with self.assertRaisesRegex(ValueError,'manifest SHA256'):lowered_json(self.root,self.manifest)

    def test_truncated_archive_rejected(self):
        (self.root/'lowered.json.gz').write_bytes(gzip.compress(self.payload)[:-7])
        with self.assertRaises(EOFError):lowered_json(self.root,self.manifest)

    def test_hardlink_rejected(self):
        source=self.root/'source.json';source.write_bytes(self.payload)
        os.link(source,self.root/'lowered.json')
        with self.assertRaisesRegex(ValueError,'Single-link'):lowered_json(self.root,self.manifest)

    def test_symlink_rejected(self):
        source=self.root/'source.json';source.write_bytes(self.payload)
        try:(self.root/'lowered.json').symlink_to(source)
        except OSError as error:self.skipTest(str(error))
        with self.assertRaisesRegex(ValueError,'Single-link'):lowered_json(self.root,self.manifest)


if __name__=='__main__':unittest.main()
