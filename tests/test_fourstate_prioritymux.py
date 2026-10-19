"""Checks for the F3.2.1 independent corpus/oracle, not hardware PASS claims."""
from collections import Counter
from pathlib import Path
import sys
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts/verification/four_state'))
from verify_fourstate_prioritymux import mux,oracle,corpus,INPUTS,DIRECTED


class PriorityMuxOracle(unittest.TestCase):
    def test_unknown_equal_branches_preserve_every_symbol(self):
        for c in 'xz':
            for value in '01xz':self.assertEqual(mux(c,value,value),value)

    def test_unknown_unequal_branches_are_x(self):
        for c in 'xz':
            for a,b in [('0','1'),('z','x'),('1','z'),('0','x')]:self.assertEqual(mux(c,a,b),'x')

    def test_known_condition_preserves_selected_z_and_masks_unknown(self):
        self.assertEqual(mux('1','z','x'),'z');self.assertEqual(mux('0','x','z'),'z')

    def test_authored_priority_and_boundary_literals(self):
        for bits,expected in DIRECTED.items():
            self.assertEqual(len(bits),7)
            self.assertEqual(oracle(dict(zip(INPUTS,bits))),{'out_res':expected})

    def test_complete_domain_and_three_operand_tables(self):
        trace=corpus();self.assertEqual(len(trace),16384)
        self.assertEqual(len({tuple(r['inputs'][n] for n in INPUTS) for r in trace}),16384)
        coverage={n:Counter() for n in ('s2','s1','s3')}
        for row in trace:oracle(row['inputs'],coverage)
        self.assertEqual([len(c) for c in coverage.values()],[64,64,64])


if __name__=='__main__':unittest.main()
