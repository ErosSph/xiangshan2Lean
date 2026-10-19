"""Actual official preprocessing / frontend boundary tests; no hardware tools."""
import json
from pathlib import Path
import sys
import unittest
import uuid
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
from fourstate_frontend import parse
from fourstate_preprocess import parse_sources


class PreprocessTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.folder = ROOT / 'experiments/fourstate/preprocess-tests' / uuid.uuid4().hex
        cls.folder.mkdir(parents=True)

    def source(self, text, files=None):
        folder = self.folder / self._testMethodName
        folder.mkdir()
        for name, content in (files or {}).items():
            p = folder / name
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(content, encoding='utf-8')
        p = folder / 'T.sv'
        p.write_text(text, encoding='utf-8')
        return p

    def test_macro_guard_inactive_initial(self):
        pp = {}
        ir = parse(ROOT / 'verification/fourstate/blockers/MacroGuard.sv', 'MacroGuard', 'sequential', 'clock', preprocessing=pp)
        self.assertEqual(pp['status'], 'PREPROCESSED')
        self.assertNotIn('InitialBlock', pp['active_syntax_counts'])
        self.assertEqual(len(ir['states']), 1)

    def test_macro_guard_active_initial_rejected(self):
        pp = {}
        with self.assertRaisesRegex(ValueError, 'initial|posedge'):
            parse(ROOT / 'verification/fourstate/blockers/MacroGuard.sv', 'MacroGuard', 'sequential', 'clock', defines=['ENABLE_INITIAL_REG_'], preprocessing=pp)
        self.assertEqual(pp['status'], 'PREPROCESSED')
        self.assertEqual(pp['active_syntax_counts']['InitialBlock'], 1)

    def test_includes_function_macros_and_locations(self):
        root = ROOT / 'verification/fourstate/preprocess'
        pp = {}
        ir = parse(root / 'MacroComb.sv', 'MacroComb', include_dirs=[root / 'include'], preprocessing=pp)
        self.assertEqual(len(ir['sources']), 3)
        self.assertEqual(sum(p['role'] == 'active-include' for p in pp['files']), 2)
        self.assertTrue(any(n['source'].get('macro') for n in ir['nodes']))
        self.assertNotIn('InitialBlock', pp['active_syntax_counts'])

    def test_ifndef_elsif_undef_and_cli(self):
        p = self.source("`define REMOVE 1\n`undef REMOVE\n`ifndef REMOVE\n`ifdef SEL\n`define V 1'bx\n`elsif ALT\n`define V 1'bz\n`else\n`define V 1'b0\n`endif\n`endif\nmodule T(output y); assign y=`V; endmodule\n")
        for defs, bits in [([], '0'), (['SEL'], 'x'), (['ALT'], 'z')]:
            ir = parse(p, 'T', defines=defs)
            self.assertIn(bits, [n.get('bits') for n in ir['nodes']])

    def test_missing_active_include(self):
        p = self.source('`include "missing.svh"\nmodule T; endmodule\n')
        with self.assertRaisesRegex(ValueError, 'missing.svh'):
            parse(p, 'T')

    def test_unknown_active_macro(self):
        p = self.source('module T(output y); assign y=`MISSING; endmodule\n')
        with self.assertRaisesRegex(ValueError, 'MISSING'):
            parse(p, 'T')

    def test_bad_macro_arguments(self):
        p = self.source('`define F(a,b) ((a) ^ (b))\nmodule T(input a,output y); assign y=`F(a); endmodule\n')
        with self.assertRaises(ValueError):
            parse(p, 'T')

    def test_include_recursion(self):
        p = self.source('`include "loop.svh"\nmodule T; endmodule\n', {'loop.svh': '`include "loop.svh"\n'})
        with self.assertRaisesRegex(ValueError, 'depth|nested|recursive'):
            parse(p, 'T')

    def test_include_guard(self):
        p = self.source('`include "h.svh"\n`include "h.svh"\nmodule T(output y); assign y=`V; endmodule\n', {'h.svh': "`ifndef H\n`define H\n`define V 1'bz\n`endif\n"})
        self.assertTrue(parse(p, 'T')['nodes'])

    def test_inactive_unsupported_directive(self):
        p = self.source('`ifdef OFF\n`timescale 1ns/1ps\ninitial nonsense();\n`endif\nmodule T(input a,output y); assign y=a; endmodule\n')
        self.assertTrue(parse(p, 'T')['nodes'])

    def test_active_unsupported_directive(self):
        p = self.source('`timescale 1ns/1ps\nmodule T(input a,output y); assign y=a; endmodule\n')
        with self.assertRaisesRegex(ValueError, 'unsupported active preprocessor directive'):
            parse(p, 'T')

    def test_macro_expansion_error_location(self):
        p = self.source('`define MUL(a,b) ((a)*(b))\nmodule T(input a,b,output y);\nassign y=`MUL(a,b);\nendmodule\n')
        with self.assertRaisesRegex(ValueError, r'T.sv:3:.*MultiplyExpression'):
            parse(p, 'T')

    def test_include_error_location(self):
        p = self.source('`include "m.svh"\n', {'m.svh': 'module T(input a,b,output y);\nassign y=a*b;\nendmodule\n'})
        with self.assertRaisesRegex(ValueError, r'm.svh:2:.*MultiplyExpression'):
            parse(p, 'T')

    def test_unsafe_and_computed_includes(self):
        for i, name in enumerate(['"../secret.svh"', '"C:/secret.svh"', '`HEADER']):
            folder = self.folder / (self._testMethodName + str(i)); folder.mkdir()
            p = folder / 'T.sv'; p.write_text('`include ' + name + '\n', encoding='utf-8')
            with self.assertRaisesRegex(ValueError, 'unsafe|literal quoted'):
                parse(p, 'T')

    def test_paste_rejected(self):
        p = self.source('`define P(a,b) a``b\nmodule T(input a,output y); assign y=a; endmodule\n')
        with self.assertRaisesRegex(ValueError, 'pasting'):
            parse(p, 'T')

    def test_ambiguous_includes(self):
        p = self.source('`include "a.svh"\n', {'a.svh': '', 'other/a.svh': ''})
        with self.assertRaisesRegex(ValueError, 'ambiguous'):
            parse(p, 'T', include_dirs=[p.parent / 'other'])

    def test_reject_duplicate_defines(self):
        p = self.source('module T; endmodule\n')
        with self.assertRaisesRegex(ValueError, 'duplicate'):
            parse(p, 'T', defines=['A', 'A=2'])

    def test_units_do_not_leak_macros(self):
        p = self.source('`define LOCAL 1\nmodule T(input a,output y); assign y=a; endmodule\n',
                        {'Other.sv': '`ifdef LOCAL\ninitial bad();\n`endif\nmodule Other; endmodule\n'})
        pp = {}; parse_sources(p.parent, report=pp)
        self.assertNotIn('InitialBlock', pp['active_syntax_counts'])

    def test_existing_inactive_header_is_not_active(self):
        p = self.source('`ifdef OFF\n`include "unused.svh"\n`endif\nmodule T(input a,output y); assign y=a; endmodule\n',
                        {'unused.svh': 'unsupported inactive content\n'})
        pp = {}; ir = parse(p, 'T', preprocessing=pp)
        self.assertEqual(ir['sources'], [str(p)])
        self.assertEqual(pp['active_includes'], [])
        self.assertEqual(next(f for f in pp['files'] if f['path'].endswith('unused.svh'))['role'], 'admission-only')

    def test_multiple_cli_defines(self):
        p = self.source('module T(output y); assign y=`A ^ `B; endmodule\n')
        self.assertTrue(parse(p, 'T', defines=["A=1'bx", "B=1'b0"])['nodes'])

    def test_missing_final_newline_is_recorded(self):
        p = self.source('`define V 1\nmodule T(input a,output y); assign y=a; endmodule')
        pp = {}; self.assertTrue(parse(p, 'T', preprocessing=pp)['nodes'])
        self.assertEqual(pp['diagnostics'][0]['code'], 'DiagCode(NewlineEOF)')

    def test_changed_input_rejected(self):
        p = self.source('`define V 1\nmodule T(input a,output y); assign y=a; endmodule\n')
        from fourstate_preprocess import stable_bytes
        count = 0
        def change(path):
            nonlocal count
            count += 1
            if count == 2:
                p.write_text(p.read_text() + '// changed\n', encoding='utf-8')
            return stable_bytes(path)
        with patch('fourstate_preprocess.stable_bytes', side_effect=change):
            with self.assertRaisesRegex(ValueError, 'changed'):
                parse(p, 'T')

    def test_junction_rejected(self):
        import os
        import subprocess
        p = self.source('`include "link/x.svh"\n', {'target/x.svh': ''})
        if os.name == 'nt':
            result = subprocess.run(['cmd', '/c', 'mklink', '/J', str(p.parent / 'link'), str(p.parent / 'target')], capture_output=True)
            self.assertEqual(result.returncode, 0)
        else:
            (p.parent / 'link').symlink_to(p.parent / 'target', target_is_directory=True)
        with self.assertRaisesRegex(ValueError, 'link/reparse'):
            parse(p, 'T')


if __name__ == '__main__':
    unittest.main()
