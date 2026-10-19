"""Replay termination and exact object/word matrix failure detection."""
import gzip
from pathlib import Path
import sys
import tempfile
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
from fourstate_machine_compare import stream_complete,native_prefix


class ReplayCompleteness(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory();self.path=Path(self.temp.name)/'stream.gz'
        self.mapping=dict(ports=[dict(direction='output',width=1)],states=[dict(object_id=0,width=1,memory=dict(offset=3,depth=2))],events=dict(monitors=['m'],processes=[dict(id=0,kind='edge')]),assertions=[dict(process=0)])
        self.lines=['F47_STEP 0']
        for phase in (0,1):
            self.lines += [f'C2L 0 {phase} O 0 0 00',f'C2L 0 {phase} S 0 3 00',f'C2L 0 {phase} S 0 4 00',f'C2L 0 {phase} M 0 0 00',f'C2L 0 {phase} E 0 0 0']
            if phase==0:self.lines.append('AFLAG 0 0 0000')
        self.lines.append('F57_END 1')

    def tearDown(self):self.temp.cleanup()
    def check(self,lines):
        with gzip.open(self.path,'wt') as stream:stream.write('\n'.join(lines)+'\n')
        return stream_complete(self.path,self.mapping,1)

    def test_complete(self):self.assertEqual(self.check(self.lines)['snapshot_records'],10)
    def test_missing_end(self):
        with self.assertRaisesRegex(ValueError,'did not complete'):self.check(self.lines[:-1])
    def test_runtime_error_even_with_end(self):
        with self.assertRaisesRegex(ValueError,'F57_ERROR'):self.check(self.lines+['F57_ERROR failed'])
    def test_same_count_duplicate_word(self):
        with self.assertRaisesRegex(ValueError,'snapshot object'):self.check([s.replace('S 0 4','S 0 3') for s in self.lines])
    def test_truncated_matrix(self):
        with self.assertRaisesRegex(ValueError,'snapshot object|Truncated'):self.check([s for s in self.lines if '1 S 0 4' not in s])
    def test_invalid_rail(self):
        with self.assertRaisesRegex(ValueError,'rail'):self.check([s.replace('O 0 0 00','O 0 0 0x') for s in self.lines])
    def test_missing_flags(self):
        with self.assertRaisesRegex(ValueError,'did not complete'):self.check([s for s in self.lines if not s.startswith('AFLAG')])


class NativePrefix(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory();self.root=Path(self.temp.name)
        self.source=self.root/'complete.gz';self.target=self.root/'prefix.gz'

    def tearDown(self):self.temp.cleanup()

    def write(self,lines):
        with gzip.open(self.source,'wt') as stream:stream.write('\n'.join(lines)+'\n')

    def test_preserves_all_words_xz_events_and_activation_in_selected_samples(self):
        selected=[]
        for phase in (0,1):
            selected.extend([f'C2L 0 {phase} O 0 0 x',f'C2L 0 {phase} S 0 3 z',f'C2L 0 {phase} S 0 4 1',f'C2L 0 {phase} M 0 0 0',f'C2L 0 {phase} E 0 0 1'])
        selected.append('A2L 0 0 1 S 0 3 z')
        self.write(['# '+line for line in selected]+['C2L 1 0 O 0 0 1'])
        original=self.source.read_bytes();result=native_prefix(self.source,self.target,1)
        with gzip.open(self.target,'rt') as stream:self.assertEqual(stream.read(),'\n'.join(selected)+'\n')
        mapping=dict(ports=[dict(direction='output',width=1)],states=[dict(object_id=0,width=1,memory=dict(offset=3,depth=2))],events=dict(monitors=['m'],processes=[dict(id=0,kind='edge')]))
        self.assertEqual(stream_complete(self.target,mapping,1,binary=False,protocol=False)['snapshot_records'],10)
        self.assertEqual(result['records'],11);self.assertEqual(self.source.read_bytes(),original)

    def test_missing_prefix_boundary_rejected(self):
        self.write(['C2L 0 0 O 0 0 x'])
        with self.assertRaisesRegex(ValueError,'boundary'):native_prefix(self.source,self.target,1)

    def test_reordered_samples_rejected(self):
        self.write(['C2L 0 0 O 0 0 x','C2L 1 0 O 0 0 z','C2L 0 1 O 0 0 1'])
        with self.assertRaisesRegex(ValueError,'Unordered'):native_prefix(self.source,self.target,2)

    def test_existing_evidence_not_overwritten(self):
        self.write(['C2L 0 0 O 0 0 x','C2L 1 0 O 0 0 z']);self.target.write_bytes(b'old evidence')
        with self.assertRaises(FileExistsError):native_prefix(self.source,self.target,1)
        self.assertEqual(self.target.read_bytes(),b'old evidence')


if __name__=='__main__':unittest.main()
