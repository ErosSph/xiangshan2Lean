"""Exact IO and failure contracts before admitting a whole Flat checkpoint."""
from decimal import Decimal
import gzip
import io
import json
import random
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1]/'scripts'))
sys.path.insert(0, str(Path(__file__).resolve().parents[1]/'scripts/verification/four_state'))
from fourstate_json_stream import build


@unittest.skipUnless(sys.platform == 'linux', 'Private Linux JSON selector')
class StreamingJSON(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temp = tempfile.TemporaryDirectory()
        cls.reader, cls.build_report = build(cls.temp.name)

    @classmethod
    def tearDownClass(cls):
        cls.temp.cleanup()

    def items(self, raw, prefix=''):
        return list(self.reader.items(io.BytesIO(raw), prefix))

    def test_numeric_lexemes_remain_exact(self):
        raw=b'[9007199254740993,-18446744073709551617,1.2345678901234567890123456789,1e1000,-0,0.00000000000000001]'
        self.assertEqual(self.items(raw), [json.loads(raw, parse_float=Decimal)])

    def test_nested_empty_and_unicode(self):
        obj={'modules':{'T':{'cells':{'a':{}, 'b':[], 'c':{'x':[{},[],True,None,'x\n"\\\U0001f642\u4e2d']}}}},'after':[]}
        raw=json.dumps(obj,ensure_ascii=False).encode()
        self.assertEqual(dict(self.reader.kvitems(io.BytesIO(raw),'modules.T.cells')), obj['modules']['T']['cells'])
        self.assertEqual(self.items(raw,'modules.T.cells'),[obj['modules']['T']['cells']])

    def test_escaped_keys(self):
        self.assertEqual(self.items(b'{"\\u4e2d":{"a\\u002eb":[1]}}','\u4e2d.a.b'),[[1]])

    def test_arrays_and_duplicate_keys_match_ijson_iteration(self):
        self.assertEqual(self.items(b'{"v":[{"x":1},{"x":2}]}','v.item.x'),[1,2])
        self.assertEqual(list(self.reader.kvitems(io.BytesIO(b'{"x":{"a":1,"a":2}}'),'x')),[('a',1),('a',2)])

    def test_basic_parse(self):
        events=list(self.reader.basic_parse(io.BytesIO(b'{"a":[{},[],true,null,9007199254740993,"x"]}')))
        self.assertEqual(events,[('start_map',None),('map_key','a'),('start_array',None),('start_map',None),('end_map',None),('start_array',None),('end_array',None),('boolean',True),('null',None),('number',9007199254740993),('string','x'),('end_array',None),('end_map',None)])

    def test_random_nested_values(self):
        rng=random.Random(57011)
        def value(depth):
            if not depth:return rng.choice([None,True,False,rng.randrange(-2**100,2**100),'x\n\U0001f642'])
            return rng.choice([[value(depth-1) for _ in range(rng.randrange(4))],{str(i):value(depth-1) for i in range(rng.randrange(4))}])
        for _ in range(100):
            obj={'cells':{str(i):value(3) for i in range(5)}}
            self.assertEqual(dict(self.reader.kvitems(io.BytesIO(json.dumps(obj).encode()),'cells')),obj['cells'])

    def test_malformed_including_unselected_tail_rejected(self):
        for raw in [b'',b'{',b'[1,]',b'{"x":1,}',b'01',b'-',b'1.',b'1e+',b'NaN',b'{} {}',b'{"x":0,"tail":[}',b'"\\q"',b'"\\uZZZZ"',b'"\x01"',b'"\xff"',b'"\xc0\x80"',b'"\\ud800"']:
            with self.subTest(raw=raw), self.assertRaises(ValueError):
                self.items(raw,'x')

    def test_gzip_and_corruption(self):
        raw=b'{"x":'+json.dumps(list(range(10000))).encode()+b'}'
        with gzip.GzipFile(fileobj=io.BytesIO(gzip.compress(raw))) as stream:
            self.assertEqual(list(self.reader.items(stream,'x')),[list(range(10000))])
        with gzip.GzipFile(fileobj=io.BytesIO(gzip.compress(raw)[:-5])) as stream:
            with self.assertRaises((EOFError,OSError)):
                list(self.reader.items(stream,'x'))

    def test_early_consumer_close_reaps_helper(self):
        import threading
        before=set(threading.enumerate())
        raw=b'{"ports":{},"tail":['+b'0,'*1000000+b'0]}'
        generator=self.reader.items(io.BytesIO(raw),'ports')
        self.assertEqual(next(generator),{})
        generator.close()
        self.assertEqual(set(threading.enumerate()),before)

    def test_replay_selection_matches_original_fields_and_hash(self):
        import hashlib
        from fourstate_machine_replay import lowered_json
        obj={'modules':{'T':{'ports':{},'cells':{'keep':{'type':'$ff','connections':{'D':[1,2],'Q':[3,4]}},'drop':{'type':'$not'}},'netnames':{'bank':{'bits':[1,2]},'drop':{'bits':[3,4]}}}}}
        raw=json.dumps(obj).encode()
        with tempfile.TemporaryDirectory() as temp:
            model=Path(temp)
            with gzip.open(model/'lowered.json.gz','wb') as stream:stream.write(raw)
            manifest={'artifact_sha256':{'lowered.json':hashlib.sha256(raw).hexdigest()}}
            old,old_receipt=lowered_json(model,manifest)
            selected,receipt=lowered_json(model,manifest,dict(reader=self.reader,top='T',cells={'keep'},netnames={'bank'}))
            self.assertEqual(selected,{'modules':{'T':{'cells':{'keep':old['modules']['T']['cells']['keep']},'netnames':{'bank':old['modules']['T']['netnames']['bank']}}}})
            self.assertEqual(receipt,old_receipt)
            manifest['artifact_sha256']['lowered.json']='0'*64
            with self.assertRaisesRegex(ValueError,'manifest SHA256'):
                lowered_json(model,manifest,dict(reader=self.reader,top='T',cells={'keep'},netnames={'bank'}))


@unittest.skipUnless(sys.platform == 'linux', 'Private Linux worker')
class BackendFailure(unittest.TestCase):
    def test_nonzero_inner_failure_is_raised_after_summary(self):
        import verify_fourstate_f57 as worker
        for code in (-15,2):
            with self.subTest(code=code), tempfile.TemporaryDirectory() as temp:
                run=Path(temp);out=run/'out';out.mkdir()
                project=run/'work/backend-project/scripts';project.mkdir(parents=True)
                (project/'yosys2lean.py').write_text('unchanged')
                source=run/'reports/encoded';source.mkdir(parents=True)
                (source/'encoded.sv').write_text('input')
                (run/'reports/threeway-tools.json').write_text(json.dumps(dict(status='VERIFIED',lean='/tool/bin/lean')))
                with patch.object(worker,'encoded_receipt',return_value=dict(status='ENCODED',rtl_sha256=worker.digest(source/'encoded.sv'),encoded_top='T')),patch.object(worker,'execute_command',return_value=dict(exit_code=code)):
                    with self.assertRaisesRegex(RuntimeError,'inner exit code '+str(code)):
                        worker.backend(dict(run=str(run),encode_label='encoded'),out)
                self.assertEqual(json.loads((out/'summary.json').read_bytes())['status'],'BACKEND_FAILED')


if __name__=='__main__':unittest.main()
