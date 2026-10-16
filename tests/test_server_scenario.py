"""Keep external scenarios tied to the checked full-model initial choices."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from server_scenario import reset_scenario, validate_trace, write_request


META = {'ports': [{'name': 'clock', 'direction': 'input', 'width': 1},
                  {'name': 'data', 'direction': 'input', 'width': 4},
                  {'name': 'q', 'direction': 'output', 'width': 4}]}


class ServerScenarioTests(unittest.TestCase):
    def test_all_physical_inputs_and_widths_required(self):
        for bad in [[], {}, [{'inputs': {'clock': 0}}],
                    [{'inputs': {'clock': 0, 'data': 16}}],
                    [{'inputs': {'clock': 0, 'data': -1}}],
                    [{'inputs': {'clock': '0', 'data': 1}}],
                    [{'inputs': {'clock': 0, 'data': 1, 'extra': 0}}],
                    [{'inputs': {'clock': 0, 'data': 1}, 'initial': {}}]]:
            with self.subTest(trace=bad), self.assertRaises(ValueError):
                validate_trace(bad, META)
        validate_trace([{'inputs': {'clock': 0, 'data': 15}}], META)

    def test_request_preserves_exact_initial_header_and_arbitrary_inputs(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            header = b'{ "initial": {"state": 7} }\n'
            template = root / 'template.jsonl'
            template.write_bytes(header + b'{"inputs":{"clock":0,"data":0,"cut":0}}\n')
            trace = [{'inputs': {'clock': 0, 'data': 3}}, {'inputs': {'clock': 1, 'data': 14}}]
            report = write_request(template, root / 'request.jsonl', trace, META, {'states': 1, 'inputs': 3})
            lines = (root / 'request.jsonl').read_bytes().splitlines(keepends=True)
            self.assertEqual(lines[0], header)
            self.assertEqual(report['initial_header_sha256'], hashlib.sha256(header).hexdigest())
            for line, row in zip(lines[1:], trace):
                self.assertEqual(json.loads(line), {'inputs': {**row['inputs'], 'cut': 0}})
            self.assertEqual(report['arbitrary_inputs'], 1)

    def test_nonzero_arbitrary_template_is_rejected(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            template = root / 'template.jsonl'
            template.write_text('{"initial":{"state":0}}\n{"inputs":{"clock":0,"data":0,"cut":1}}\n')
            with self.assertRaisesRegex(ValueError, 'zero arbitrary-input'):
                write_request(template, root / 'request.jsonl', [{'inputs': {'clock': 0, 'data': 0}}], META,
                              {'states': 1, 'inputs': 3})
            self.assertFalse((root / 'request.jsonl').exists())

    def test_wrong_initial_state_count_is_rejected(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            template = root / 'template.jsonl'
            template.write_text('{"initial":{}}\n{"inputs":{"clock":0,"data":0,"cut":0}}\n')
            with self.assertRaisesRegex(ValueError, 'Initial state'):
                write_request(template, root / 'request.jsonl', [{'inputs': {'clock': 0, 'data': 0}}], META,
                              {'states': 1, 'inputs': 3})

    def test_reassertion_is_between_main_clock_edges(self):
        original = [{'inputs': {'io_clock': [0, 0, 1, 0][i % 4], 'unchanged': i}}
                    for i in range(96)]
        trace = reset_scenario(original)
        self.assertEqual(len(trace), 96)
        self.assertEqual([trace[i]['inputs']['io_clock'] for i in range(71, 75)], [0, 0, 0, 1])
        self.assertEqual([trace[i]['inputs']['io_reset'] for i in range(71, 75)], [0, 1, 0, 0])
        for i, row in enumerate(trace):
            self.assertEqual(row['inputs']['unchanged'], i)
            self.assertNotIn('io_reset', original[i]['inputs'])


if __name__ == '__main__':
    unittest.main()
