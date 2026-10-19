"""Replay checkpoint reuse rejects drift and rechecks every input/seed."""
import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from fourstate_native_replay import digest, reuse_preparation, native_observer


class PreparedReplay(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.source = self.root / 'reports/old'
        self.model = self.root / 'model'
        self.target = self.root / 'new'
        for p in [self.source / 'compile', self.source / 'request', self.root / 'work/old', self.model]:
            p.mkdir(parents=True, exist_ok=True)
        self.observer = self.root / 'observer.lean'
        self.observer.write_text('unchanged observer')
        (self.source / 'RunMachine.lean').write_bytes(self.observer.read_bytes())
        self.request = dict(backend_label='backend', encode_label='encoded', raw_reference_label='raw', initial_fills='0')
        self.scope = dict(selected_samples_per_fill=1, initial_fills='0')
        self.mapping = dict(states=[], ports=[dict(direction='input', name='a', width=1, tag='a_t', value='a_v')])
        self.trace = [dict(inputs=dict(a='x'))]
        self.ir = dict(inputs=[dict(name=n) for n in ['a_t', 'a_v', 'exec_clk', 'step_valid', 'obs_object', 'obs_index']],
                       states=[dict(name='s', sort=dict(kind='bits', width=1), initial=dict(value=1, mask=1))])
        self.put(self.model / 'interface.json', self.ir)
        self.put(self.model / 'manifest.json', dict(interface='interface.json', table=dict(binary='circuit.bin'), artifact_sha256={'lowered.json':'abc'}))
        self.proof = dict(status='UNREFERENCED_COMPILED_INPUTS_PROVED')
        self.put(self.root / 'work/old/request.json', self.request)
        self.put(self.source / 'trace-scope.json', self.scope)
        self.put(self.source / 'compile/execution-result.json', dict(exit_code=0))
        self.put(self.source / 'request/plan.json', dict(objects=[]))
        self.put(self.source / 'request/bank-witnesses.json', [])
        self.put(self.source / 'request/request-0.json', dict(initial=dict(s=1), trace=[dict(inputs=dict(a_t=1, a_v=0, exec_clk=0, step_valid=0, obs_object=0, obs_index=0))]))
        self.receipt = dict(model_manifest_sha256=digest(self.model / 'manifest.json'),
                            lowered_artifact=dict(sha256='abc'), unused_input_proof=self.proof,
                            binary=str(self.model / 'circuit.bin'), objects=0, bank_fields=0,
                            plan_sha256=digest(self.source / 'request/plan.json'),
                            witness_sha256=digest(self.source / 'request/bank-witnesses.json'))
        self.put(self.source / 'state-map-receipt.json', self.receipt)

    def tearDown(self):
        self.temp.cleanup()

    def put(self, path, data):
        path.write_text(json.dumps(data))

    def run_reuse(self):
        with patch('fourstate_unused_inputs.prove_unused', return_value=(set(), copy.deepcopy(self.proof))):
            return reuse_preparation(self.source, self.model, self.mapping, self.trace, self.request, self.scope, self.observer, self.target)

    def test_exact_reuse(self):
        value = self.run_reuse()
        self.assertEqual(len(value['reuse']['files']), 3)
        self.assertEqual((self.target / 'request-0.json').read_bytes(), (self.source / 'request/request-0.json').read_bytes())

    def test_plan_drift(self):
        self.put(self.source / 'request/plan.json', {})
        with self.assertRaisesRegex(ValueError, 'mapping hash'): self.run_reuse()

    def test_scope_drift(self):
        self.scope['selected_samples_per_fill'] = 2
        with self.assertRaisesRegex(ValueError, 'scope'): self.run_reuse()

    def test_fill_change_revalidates_existing_seed(self):
        self.request['initial_fills'] = '1'
        self.scope['initial_fills'] = '1'
        original = (self.source / 'request/request-0.json').read_bytes()
        (self.source / 'request/request-1.json').write_bytes(original)
        result = self.run_reuse()
        self.assertEqual((self.target / 'request-1.json').read_bytes(), original)
        self.assertEqual(result['reuse']['files'][-1]['path'], 'request-1.json')

    def test_fill_change_rejects_wrong_seed(self):
        self.request['initial_fills'] = '1'
        self.scope['initial_fills'] = '1'
        data = json.loads((self.source / 'request/request-0.json').read_bytes())
        data['initial']['s'] = 0
        self.put(self.source / 'request/request-1.json', data)
        with self.assertRaisesRegex(ValueError, 'initial state'): self.run_reuse()

    def test_backend_drift(self):
        self.request['backend_label'] = 'another'
        with self.assertRaisesRegex(ValueError, 'backend_label'): self.run_reuse()

    def test_seed_drift(self):
        p = self.source / 'request/request-0.json'
        data = json.loads(p.read_bytes()); data['initial']['s'] = 0; self.put(p, data)
        with self.assertRaisesRegex(ValueError, 'initial state'): self.run_reuse()

    def test_input_drift(self):
        p = self.source / 'request/request-0.json'
        data = json.loads(p.read_bytes()); data['trace'][0]['inputs']['a_v'] = 1; self.put(p, data)
        with self.assertRaisesRegex(ValueError, 'trace inputs'): self.run_reuse()

    def test_observer_drift(self):
        self.observer.write_text('changed')
        with self.assertRaisesRegex(ValueError, 'observer source'): self.run_reuse()

    def test_proof_drift(self):
        self.receipt['unused_input_proof'] = {}; self.put(self.source / 'state-map-receipt.json', self.receipt)
        with self.assertRaisesRegex(ValueError, 'circuit proof'): self.run_reuse()


if __name__ == '__main__': unittest.main()
