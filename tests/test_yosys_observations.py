"""Fail-closed read-only taps, including actual pinned Yosys integration."""
from pathlib import Path
import json
import os
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
from yosys_observations import load, plan, check_ports, original_ports


class ObservationValidation(unittest.TestCase):
    def test_reject_ambiguous_or_executable_names(self):
        entry = {'name': 'c2l_observe_q', 'wire': 'inner.q', 'width': 2}
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / 'observations.json'
            cases = [[], [entry, entry], [{**entry, 'wire': 'inner.q; delete Top'}],
                     [{**entry, 'name': 'clock'}], [{**entry, 'width': True}],
                     [{**entry, 'width': 0}], [{**entry, 'cut': True}]]
            for case in cases:
                path.write_text(json.dumps(case), encoding='utf-8')
                with self.subTest(case=case), self.assertRaises(ValueError):
                    load(path)

    @unittest.skipUnless(os.environ.get('CHISEL2LEAN_OBSERVATION_YOSYS') == '1', 'requires pinned native Yosys')
    def test_native_read_only_taps_and_rejections(self):
        entry = {'name': 'c2l_observe_q', 'wire': 'inner.q', 'width': 2}
        with tempfile.TemporaryDirectory() as folder:
            base = Path(folder)
            source = base / 'design.sv'
            source.write_text('''module Child(input clk, input [1:0] d, output reg [1:0] q);
always @(posedge clk) q <= d;
endmodule
module Top(input clk, input [1:0] d, output [1:0] q);
Child inner(clk,d,q);
endmodule
''', encoding='utf-8')
            for index, item in enumerate([entry, {**entry, 'wire': 'inner.missing'},
                                          {**entry, 'width': 3}, {**entry, 'wire': 'q'}]):
                script = base / f'case-{index}.ys'
                output = base / f'case-{index}.json'
                commands = (f'read_slang --top Top {source.as_posix()}; hierarchy -top Top; proc; flatten Top; '
                            + plan('Top', [item]).replace('/work/', base.as_posix()+'/')
                            + f'; opt_clean; write_json {output.as_posix()}')
                script.write_text(commands, encoding='utf-8')
                run = subprocess.run([sys.executable, str(ROOT / 'scripts/yosys_runner.py'), '--native', '-Q', '-T', '-s', str(script)],
                                     text=True, capture_output=True)
                with self.subTest(case=index):
                    if index == 1:
                        self.assertNotEqual(run.returncode, 0)
                        continue
                    self.assertEqual(run.returncode, 0, run.stderr)
                    ports = json.loads(output.read_text(encoding='utf-8'))['modules']['Top']['ports']
                    original = original_ports(base / 'observation-original-ports.txt', 'Top')
                    if index:
                        with self.assertRaises(ValueError):
                            check_ports(ports, [item], original)
                    else:
                        check_ports(ports, [item], original)
                        self.assertEqual(original, {'clk', 'd', 'q'})
                        self.assertEqual(set(ports), {'clk', 'd', 'q', entry['name']})
                        self.assertEqual(ports['q']['bits'], ports[entry['name']]['bits'])
                        self.assertEqual(ports[entry['name']]['direction'], 'output')


if __name__ == '__main__':
    unittest.main()
