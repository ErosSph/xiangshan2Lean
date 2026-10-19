"""F4.3 parsing and trace-contract rejection tests; no backend compilation."""
import json
from pathlib import Path
import sys
import unittest
import uuid

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
from fourstate_frontend import parse
from fourstate_encode import encode
from fourstate_events import validate, validate_contract, POSEDGE, contract
from fourstate_sequential import validate as validate_sequential


class AsyncBoundary(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.folder = ROOT / 'experiments/fourstate/async-tests' / uuid.uuid4().hex
        cls.folder.mkdir(parents=True)
        cls.ir = parse(ROOT / 'verification/fourstate/async/AsyncRegister.sv', 'AsyncRegister', 'sequential', 'clock', async_reset='reset')
        _, cls.mapping = encode(cls.ir)

    def test_explicit_capability_and_contract(self):
        self.assertEqual(self.ir['events'], contract('clock', 'reset'))
        self.assertIn('async_posedge', self.ir['capabilities'])
        self.assertEqual(len(self.ir['states']), 1)

    def test_no_implicit_async_support(self):
        with self.assertRaises(ValueError):
            parse(ROOT / 'verification/fourstate/async/AsyncRegister.sv', 'AsyncRegister', 'sequential', 'clock')

    def test_all_five_positive_edges(self):
        self.assertEqual(POSEDGE, {('0','1'), ('0','x'), ('0','z'), ('x','1'), ('z','1')})
        rows = [{'inputs': dict(clock=c,reset=r,enable='1',d='z')} for c,r in [('0','0'),('x','0'),('z','x'),('1','1')]]
        encoded, initial = validate(self.mapping, rows, {'AsyncRegister.q':'x'})
        self.assertEqual([r['clock'] for r in encoded], [0,2,3,1])
        self.assertEqual(len(initial),2)

    def test_invalid_traces_rejected(self):
        row = dict(clock='0',reset='0',enable='1',d='x')
        cases = [[{'inputs':dict(row,reset='1')}],
                 [{'inputs':row},{'inputs':dict(row,clock='1',d='z')}],
                 [{'inputs':row},{'inputs':dict(row,reset='x',enable='0')}],
                 [{'inputs':dict(row,clock='a')}],
                 [{'inputs':dict(row,extra='0')}]]
        for trace in cases:
            with self.subTest(trace=trace), self.assertRaises(ValueError):
                validate(self.mapping, trace, {'AsyncRegister.q':'x'})

    def test_release_and_data_without_event(self):
        rows = [{'inputs':dict(clock='0',reset=r,enable='1',d=d)} for r,d in [('0','0'),('1','0'),('0','x'),('0','z')]]
        self.assertEqual(len(validate(self.mapping,rows,{'AsyncRegister.q':'z'})[0]),4)

    def test_invalid_initial_rejected(self):
        row = [{'inputs':dict(clock='0',reset='0',enable='0',d='0')}]
        for initial in [None,{}, {'AsyncRegister.q':'00'}, {'AsyncRegister.q':'a'}]:
            with self.subTest(initial=initial), self.assertRaises(ValueError):
                validate(self.mapping,row,initial)

    def test_unsupported_event_syntax(self):
        head='module T(input clock,reset,other,d,output reg q);'
        bodies = {
            'negedge':'always @(posedge clock or negedge reset) if(reset)q<=0;else q<=d;',
            'third':'always @(posedge clock or posedge reset or posedge other) if(reset)q<=0;else q<=d;',
            'derived':'always @(posedge (clock & other) or posedge reset) if(reset)q<=0;else q<=d;',
            'iff':'always @(posedge clock iff other or posedge reset) if(reset)q<=0;else q<=d;',
            'wrong_guard':'always @(posedge clock or posedge reset) if(other)q<=0;else q<=d;',
            'alias':'wire a=clock;always @(posedge a or posedge reset) if(reset)q<=0;else q<=d;',
            'multi_process':'always @(posedge clock or posedge reset)if(reset)q<=0;else q<=d;always @(posedge clock)q<=d;',
            'missing_event':'always @(posedge clock) if(reset)q<=0;else q<=d;',
            'initial':"initial q=1'b0;always @(posedge clock or posedge reset) if(reset)q<=0;else q<=d;",
        }
        for name,body in bodies.items():
            p=self.folder/(name+'.sv');p.write_text(head+body+'endmodule\n',encoding='utf8')
            from fourstate_preprocess import parse_sources
            s,sm,trees,_=parse_sources(p)
            self.assertFalse(any(d.isError() for t in trees for d in t.diagnostics),name)
            with self.subTest(case=name),self.assertRaisesRegex(ValueError,r':\d+:\d+:'):
                parse(p,'T','sequential','clock',async_reset='reset')

    def test_event_contract_is_not_silently_reinterpreted(self):
        import copy
        for key,value in [('process_count',2),('edge','negedge'),('initial_controls','xx'),('reset','clock')]:
            m=copy.deepcopy(self.mapping);m['events'][key]=value
            with self.subTest(key=key),self.assertRaises(ValueError):
                validate_contract(m)

    def test_legacy_binary_clock_contract(self):
        mapping=dict(self.mapping);del mapping['events']
        row=dict(clock='0',reset='0',enable='1',d='x')
        with self.assertRaisesRegex(ValueError,'binary'):
            validate_sequential(mapping,[{'inputs':row},{'inputs':dict(row,clock='x')}],{'AsyncRegister.q':'x'})


if __name__ == '__main__':
    unittest.main()
