from pathlib import Path
import csv
import json
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
from xiangshan_isa import compare, interrupt_boundary
from yosys_hierarchy import digest


class IsaComparisonTests(unittest.TestCase):
    def test_interrupt_evidence_rejects_wrong_pin_timing_and_missing_wait(self):
        with tempfile.TemporaryDirectory() as folder:
            base = Path(folder)
            (base / 'environment.json').write_text(json.dumps({'irq_on_read_wait':True,
                'external_irq_bits':1, 'delayed_read_address':0x50000000,
                'extra_read_latency_cycles':500, 'test_device_initial_value':0x12345678}))
            (base / 'provenance.json').write_text(json.dumps({'environment_sha256':digest(base/'environment.json')}))
            events = ('cycle,event,committed,value,detail\n'
                      '1,assert_during_read_wait,1,1342177280,502\n'
                      '2,interrupt_accepted,1,9223372036854775819,268435460\n')
            (base / 'events.csv').write_text(events)
            bus = ('cycle,channel,event,id,address,detail0,detail1\n'
                   '0,peripheral,AR,1,1342177280,0,3\n'
                   '502,peripheral,R,1,1342177280,0,1\n')
            (base / 'axi.csv').write_text(bus)
            (base / 'commits.csv').write_text('cycle,lane\n0,0\n3,0\n')
            pins = 'sample,io_extIntrs\n'+''.join(f'{i},{int(i>=4)}\n' for i in range(16))
            (base / 'inputs.csv').write_text(pins)
            self.assertEqual(interrupt_boundary(base,base,2)['status'], 'OBSERVED')
            (base / 'inputs.csv').write_text(pins.replace('4,1\n','4,0\n'))
            with self.assertRaisesRegex(ValueError, 'input trace'):
                interrupt_boundary(base,base,2)
            (base / 'inputs.csv').write_text(pins)
            (base / 'axi.csv').write_text(bus.replace('502,peripheral,R','1,peripheral,R'))
            with self.assertRaisesRegex(ValueError, 'AXI read'):
                interrupt_boundary(base,base,2)
            (base / 'axi.csv').write_text(bus)
            (base / 'events.csv').write_text(events.replace('interrupt_accepted,1,','interrupt_accepted,2,'))
            with self.assertRaisesRegex(ValueError, 'boundary'):
                interrupt_boundary(base,base,2)

    def test_retirement_comparison_and_corruption_rejection(self):
        with tempfile.TemporaryDirectory() as folder:
            base = Path(folder)
            (base / 'spike-commits.log').write_text(
                'core   0: 3 0x0000000010000000 (0x00700293) x 5 0x0000000000000007\n'
                'core   0: 3 0x0000000010000004 (0x0000006f)\n')
            def write_rows(name, fields, rows):
                with (base / name).open('w', newline='') as stream:
                    writer = csv.DictWriter(stream, fields)
                    writer.writeheader()
                    writer.writerows(rows)
            fields = ['cycle','lane','ldest','pdest','rfwen','data','pc']
            rtl = [dict(cycle=10,lane=0,ldest=5,pdest=35,rfwen=1,data=7,pc=0x10000000),
                   dict(cycle=11,lane=0,ldest=0,pdest=0,rfwen=1,data=0,pc=0x10000004)]
            registers = [{'commit': i, **{'x'+str(r): 7 if r == 5 else 0 for r in range(32)}} for i in range(2)]
            write_rows('commits.csv', fields, rtl)
            write_rows('registers.csv', ['commit']+['x'+str(r) for r in range(32)], registers)
            result = compare(base, base, base)
            self.assertEqual(result['status'], 'RTL_SPIKE_PC_GPR_PASS')
            self.assertEqual(result['integer_writebacks'], 1)
            corruptions = [('wrong PC', [{**rtl[0], 'pc': 0x10000004}, rtl[1]]),
                           ('wrong GPR', [{**rtl[0], 'data': 8}, rtl[1]]),
                           ('missing commit', rtl[:1]), ('extra commit', rtl+rtl[:1]),
                           ('reordered commit', list(reversed(rtl)))]
            for name, rows in corruptions:
                write_rows('commits.csv', fields, rows)
                with self.subTest(name=name), self.assertRaises(ValueError):
                    compare(base, base, base)
            write_rows('commits.csv', fields, rtl)
            registers[1]['x5'] = 9
            write_rows('registers.csv', ['commit']+['x'+str(r) for r in range(32)], registers)
            with self.assertRaises(ValueError):
                compare(base, base, base)


if __name__ == '__main__':
    unittest.main()
