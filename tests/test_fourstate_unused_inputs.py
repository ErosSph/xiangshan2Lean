"""Extra-input acceptance requires absence of reads in the compiled circuit."""
import copy
import hashlib
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from lean_table import emit_table
from fourstate_unused_inputs import prove_unused


class UnusedInputs(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        bits = dict(kind='bits', width=1)
        self.ir = dict(namespace='Yosys.Probe', clock='exec_clk',
                       inputs=[dict(name='exec_clk', field='i0', sort=bits),
                               dict(name='c2l_undefined_0_Y', field='i1', sort=bits)],
                       states=[], outputs=[dict(name='y', node=0, sort=bits)],
                       nodes=[dict(id=0, op='constant', sort=bits, args=[], value=1)],
                       arbitrary_inputs=[dict(name='c2l_undefined_0_Y', width=1, source='setundef')])

    def tearDown(self):
        self.temp.cleanup()

    def emit(self):
        _, table = emit_table(self.ir, self.root)
        self.path = self.root / table['binary']
        self.manifest = dict(arbitrary_inputs=copy.deepcopy(self.ir['arbitrary_inputs']),
                             interface='interface.json', table=table, nodes=len(self.ir['nodes']),
                             artifact_sha256={'interface.json': 'a' * 64})
        self.rehash()

    def rehash(self):
        self.manifest['artifact_sha256'][self.manifest['table']['binary']] = hashlib.sha256(self.path.read_bytes()).hexdigest()

    def prove(self):
        return prove_unused(self.root, self.manifest, self.ir, 'a' * 64)

    def add_input_read(self, index=1, observable=True):
        self.ir['nodes'].append(dict(id=1, op='input', sort=dict(kind='bits', width=1), args=[], field='i' + str(index)))
        if observable:
            self.ir['outputs'][0]['node'] = 1

    def test_unused_slot_accepted_without_modifying_binary(self):
        self.emit(); before = self.path.read_bytes()
        names, proof = self.prove()
        self.assertEqual(names, {'c2l_undefined_0_Y'})
        self.assertEqual(proof['read_input_fields'], 0)
        self.assertEqual(self.path.read_bytes(), before)

    def test_live_arbitrary_input_rejected(self):
        self.add_input_read(); self.emit()
        with self.assertRaisesRegex(ValueError, 'is read by compiled Lean'):
            self.prove()

    def test_disconnected_arbitrary_read_also_rejected(self):
        self.add_input_read(observable=False); self.emit()
        with self.assertRaisesRegex(ValueError, 'is read by compiled Lean'):
            self.prove()

    def test_real_input_remains_readable(self):
        self.add_input_read(index=0); self.emit()
        self.assertEqual(self.prove()[1]['read_input_fields'], 1)

    def test_tampered_binary_rejected(self):
        self.emit(); self.path.write_bytes(self.path.read_bytes() + b'\0')
        with self.assertRaisesRegex(ValueError, 'manifest SHA256'):
            self.prove()

    def test_wrong_interface_hash_rejected(self):
        self.emit()
        with self.assertRaisesRegex(ValueError, 'interface.*SHA256'):
            prove_unused(self.root, self.manifest, self.ir, 'b' * 64)

    def test_arbitrary_metadata_mismatch_rejected(self):
        self.emit(); self.ir['arbitrary_inputs'] = []
        with self.assertRaisesRegex(ValueError, 'metadata differs'):
            self.prove()

    def test_truncated_binary_rejected_even_with_matching_hash(self):
        self.emit(); self.path.write_bytes(self.path.read_bytes()[:-1]); self.rehash()
        with self.assertRaisesRegex(ValueError, 'Truncated'):
            self.prove()

    def test_trailing_binary_rejected_even_with_matching_hash(self):
        self.emit(); self.path.write_bytes(self.path.read_bytes() + b'\0'); self.rehash()
        with self.assertRaisesRegex(ValueError, 'Trailing'):
            self.prove()

    def test_binary_interface_name_mismatch_rejected(self):
        self.emit(); self.ir['inputs'][0]['name'] = 'different'
        with self.assertRaisesRegex(ValueError, 'field differs'):
            self.prove()

    def test_memory_constraints_and_large_constants_are_skipped_exactly(self):
        memory = dict(kind='memory', width=257, address_width=2)
        known = dict(mask=(1 << 257) - 1, value=1 << 256)
        self.ir['states'] = [dict(name='ram', field='s0', sort=memory,
                                  initial=dict(words=[known] * 4), node=1)]
        self.ir['nodes'].append(dict(id=1, op='state', sort=memory, args=[], field='s0'))
        self.ir['nodes'].append(dict(id=2, op='constant', sort=dict(kind='bits', width=4096), args=[], value=1 << 4095))
        self.emit()
        self.assertEqual(self.prove()[1]['nodes'], 3)

    def test_no_arbitrary_inputs_keep_existing_path(self):
        self.ir['arbitrary_inputs'] = []; self.emit()
        self.assertEqual(self.prove(), (set(), None))

    def test_relative_escape_rejected(self):
        self.emit(); self.manifest['table']['binary'] = '../other.bin'
        with self.assertRaisesRegex(ValueError, 'Unsafe'):
            self.prove()

    def test_duplicate_arbitrary_metadata_rejected(self):
        self.ir['arbitrary_inputs'] *= 2; self.emit()
        with self.assertRaisesRegex(ValueError, 'Duplicate'):
            self.prove()


if __name__ == '__main__':
    unittest.main()
