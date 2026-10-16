"""Exercise real reset edges and assertion failures in the RTL reference driver."""
from __future__ import annotations

import json
import os
from pathlib import Path
import shutil
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from rtl import run_emitted_rtl


def metadata():
    return {'top': 'Startup', 'clocked': False, 'assertions': True, 'jobs': 1,
            'output_groups': 0, 'rtl_sources': ['Startup.sv'],
            'ports': [{'name': n, 'rtl_name': n, 'width': w, 'direction': d}
                      for n, w, d in [('clock', 1, 'input'), ('reset', 1, 'input'),
                                      ('legal', 1, 'input'), ('q', 1, 'output'), ('srst', 1, 'output')]]}


RTL = '''module Startup(input clock, reset, legal, output reg q, output srst);
  reg [2:0] pipe_reset;
  assign srst = pipe_reset[2];
  always @(posedge clock or posedge reset)
    if (reset) pipe_reset <= 3'b111;
    else pipe_reset <= {pipe_reset[1:0], 1'b0};
  always @(posedge clock) begin
    if (!srst) assert(q == 1) else $error("reset did not reach downstream state");
    if (!reset) assert(legal) else $error("illegal input still rejected");
    if (srst) q <= 1;
    else q <= 0;
  end
endmodule
'''


class InputContractTests(unittest.TestCase):
    def test_bad_initial_inputs_rejected_before_build(self):
        valid = {'clock': 0, 'reset': 0, 'legal': 0}
        invalid = [[], {'clock': 0}, {**valid, 'unknown': 0},
                   {**valid, 'reset': 2}, {**valid, 'legal': -1},
                   {**valid, 'clock': '0'}, {**valid, 'clock': 0.0}]
        for value in invalid:
            with self.subTest(value=value), tempfile.TemporaryDirectory() as folder:
                root = Path(folder)
                with self.assertRaises(ValueError):
                    run_emitted_rtl(root, {**metadata(), 'initial_inputs': value}, [], root / 'evidence')
                self.assertEqual(list(root.iterdir()), [])


@unittest.skipUnless(os.name != 'nt' and (os.environ.get('CHISEL2LEAN_VERILATOR') or shutil.which('verilator')),
                     'Run the real RTL regression on the Linux server with the pinned Verilator')
class StartupRTLTests(unittest.TestCase):
    def run_fixture(self, primed, illegal=False):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)
        root = Path(self.folder.name)
        (root / 'Startup.sv').write_text(RTL, encoding='utf-8')
        meta = metadata()
        if primed:
            meta['initial_inputs'] = {'clock': 0, 'reset': 0, 'legal': 0}
        pairs = [(0, 1), (0, 1), (1, 1), (0, 1), (0, 0), (1, 0),
                 (0, 0), (1, 0), (0, 0), (1, 0), (0, 0)]
        trace = [{'inputs': {'clock': c, 'reset': r, 'legal': int(not illegal or i != 5)}}
                 for i, (c, r) in enumerate(pairs)]
        code, rows = run_emitted_rtl(root, meta, trace, root / 'evidence')
        return root, code, rows

    def test_initially_high_reset_without_edge_reproduces_failure(self):
        root, code, rows = self.run_fixture(False)
        self.assertEqual((code, rows), (7, []))
        self.assertIn('reset did not reach downstream state',
                      (root / 'evidence/verilator-run/stdout.log').read_text())
        self.assertIn('sample 2 (pre)', (root / 'evidence/verilator-run/stderr.log').read_text())

    def test_explicit_settle_preserves_reset_edge_and_every_sample(self):
        root, code, rows = self.run_fixture(True)
        self.assertEqual(code, 0)
        self.assertEqual(len(rows), 11)
        for i, row in enumerate(rows):
            expected = {'q': int(i >= 2), 'srst': int(i < 9)}
            self.assertEqual(row, {'cycle': i, 'pre': expected, 'post': expected})
        startup = json.loads((root / 'evidence/startup.json').read_text())
        self.assertEqual(startup['initial_inputs'], {'clock': 0, 'reset': 0, 'legal': 0})
        self.assertTrue(startup['assertions_enabled'])
        self.assertEqual((root / 'Startup.sv').read_text(), RTL)

    def test_priming_keeps_real_assertions_enabled(self):
        root, code, rows = self.run_fixture(True, illegal=True)
        self.assertEqual((code, rows), (7, []))
        self.assertIn('illegal input still rejected',
                      (root / 'evidence/verilator-run/stdout.log').read_text())
        self.assertIn('sample 5 (pre)', (root / 'evidence/verilator-run/stderr.log').read_text())


if __name__ == '__main__':
    unittest.main()
