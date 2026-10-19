"""Explicit F5.1 transfer policy removes caps while retaining exact integrity."""
import copy
from pathlib import Path
import sys
import unittest
from unittest.mock import patch
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'scripts'))
sys.path.insert(0,str(ROOT/'scripts/verification/four_state'))
import fourstate_sync_common as c


class UnrestrictedTransfer(unittest.TestCase):
    def test_explicit_policy_and_integrity(self):
        data=b'payload larger than the patched test budget'
        m=dict(format='fourstate-sync-source-v1',snapshot_id='f51-test',files=[dict(path='scripts/probe.py',bytes=len(data),sha256=c.sha(data))],bytes=len(data))
        with patch.object(c,'SOURCE_LIMIT',1):
            with self.assertRaisesRegex(ValueError,'byte budget'):c.records(m,'source')
            m['unrestricted']=True
            bundle=c.make_zip(m,{'scripts/probe.py':data},'source')
            restored,_,payloads=c.inspect_zip(bundle,'source',c.sha(c.encoded(m)),['scripts/probe.py'])
            self.assertEqual(payloads['scripts/probe.py'],data)
            bad=copy.deepcopy(m);bad['files'][0]['sha256']='0'*64
            with self.assertRaisesRegex(ValueError,'differs from manifest'):c.make_zip(bad,{'scripts/probe.py':data},'source')
            bad=copy.deepcopy(m);bad['files'][0]['path']='../escape'
            with self.assertRaisesRegex(ValueError,'unsafe'):c.records(bad,'source')
