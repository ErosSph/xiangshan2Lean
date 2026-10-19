"""Safety and static-analysis fixtures for F3.1; no hardware execution."""
import ast
import importlib.util
from pathlib import Path
import stat
import sys
import types
import json
import unittest
import tempfile
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
sys.path.insert(0, str(ROOT / 'scripts/verification/four_state'))
import audit_fourstate_remote as remote
import audit_fourstate_xstop as audit
import audit_fourstate_syntax as syntax
import audit_fourstate_analysis as analysis


class SyntaxFacts(unittest.TestCase):
    def setUp(self):
        self.fixture=json.loads((ROOT/'verification/fourstate/audit/structure.json').read_text(encoding='utf-8'))
        self.modules={m['name']:m for m in syntax.facts(self.fixture['cst'],self.fixture['source'],'fixture.sv')}

    def test_official_cst_ignores_comment_modules_and_processes(self):
        self.assertEqual(set(self.modules),{'Top','Leaf'})
        self.assertEqual(self.modules['Leaf']['features']['always'],2)
        self.assertEqual(self.modules['Leaf']['features']['initial'],1)

    def test_array_state_events_and_unknown_literal(self):
        leaf=self.modules['Leaf']
        self.assertEqual(leaf['register_targets'],['q'])
        self.assertEqual([m['name'] for m in leaf['memories']],['mem'])
        self.assertEqual(leaf['features']['x_literal'],1)
        self.assertEqual(leaf['features']['async_reset_candidate'],1)
        self.assertEqual(leaf['processes'][0]['clock_events'][0]['expr'],'clk')
        self.assertEqual(leaf['memories'][0]['source']['line'],3)

    def test_instances_are_not_definitions(self):
        self.assertEqual([r['module'] for r in self.modules['Top']['instances']],['Leaf','Leaf'])
        rows=syntax.hierarchy_output(self.fixture['hierarchy'])
        self.assertEqual(len(rows),3)
        self.assertEqual(len({r['module'] for r in rows}),2)

    def test_duplicate_hierarchical_paths_rejected(self):
        with self.assertRaises(ValueError):syntax.hierarchy_output('T|T|x\nT|T|x\n')

    def test_casez_is_structural_not_a_string_match(self):
        fake={'kind':'ModuleDeclaration','header':{'name':'M'},'members':[{'kind':'CaseStatement','keyword':'casez'}]}
        fact=syntax.facts(fake,'module M; casez(a) endcase endmodule','m.sv')[0]
        self.assertEqual(fact['features']['casez_statement'],1)
        self.assertEqual(syntax.mask('// casez(a)\n"casex"\n'), '           \n       \n')

    def test_real_reset_block_is_not_two_clocks(self):
        sample=json.loads((ROOT/'verification/fourstate/audit/real-samples.json').read_text(encoding='utf-8'))
        module={'kind':'ModuleDeclaration','header':{'name':'ResetGen'},'members':sample['resetgen']['AlwaysBlock']}
        result=syntax.facts(module,'module ResetGen; always begin end endmodule','ResetGen.sv')[0]
        self.assertEqual(result['features']['async_reset_candidate'],1)
        self.assertNotIn('multiple_local_clock_expressions',result['features'])
        self.assertEqual(result['processes'][0]['clock_events'][0]['expr'],'clock')

    def test_real_ram_write_and_ranges(self):
        sample=json.loads((ROOT/'verification/fourstate/audit/real-samples.json').read_text(encoding='utf-8'))
        members=sample['ram']['AlwaysBlock']+sample['ram']['DataDeclaration']
        module={'kind':'ModuleDeclaration','header':{'name':'ram'},'members':members}
        result=syntax.facts(module,'module ram; reg Memory; always begin end endmodule','ram.sv')[0]
        self.assertEqual(result['register_targets'],[])
        self.assertEqual(result['features']['memory_write'],1)
        self.assertEqual(result['features']['nonliteral_index'],1)
        self.assertNotIn('procedural_blocking_assignment',result['features'])

    def test_continuous_assignment_not_procedural_blocking(self):
        assignment={'kind':'AssignmentExpression','left':{'kind':'IdentifierName','identifier':'out'},'right':{'kind':'IdentifierName','identifier':'clk'}}
        module={'kind':'ModuleDeclaration','header':{'name':'M'},'members':[{'kind':'ContinuousAssign','assignments':[assignment]}]}
        result=syntax.facts(module,'module M; assign out=clk; endmodule','m.sv')[0]
        self.assertNotIn('procedural_blocking_assignment',result['features'])
        self.assertEqual(result['aliases'][0]['source'],'clk')

    def test_aggregation_keeps_declaration_instance_and_weighted_counts_separate(self):
        result=analysis.aggregate(list(self.modules.values()),{'status':'ELABORATED','instances':syntax.hierarchy_output(self.fixture['hierarchy'])},[])
        self.assertEqual(result['definitions']['distinct_names'],2)
        self.assertEqual(result['hierarchy']['instances_including_top'],3)
        self.assertEqual(result['features']['unpacked_array']['module_definitions'],1)
        self.assertEqual(result['features']['unpacked_array']['affected_instances'],2)
        self.assertIsNone(result['clocks']['architectural_clock_domain_count'])

    def test_unresolved_cycles_do_not_invent_instances(self):
        modules=list(self.modules.values())
        modules[0]['instances'].append({'name':'u','module':'Unknown'})
        modules[0]['instances'].append({'name':'loop','module':modules[0]['name']})
        result=analysis.aggregate(modules,{'status':'UNCONFIRMED','instances':[]},[])
        self.assertEqual(len(result['hierarchy']['unresolved_source_instances']),1)
        self.assertTrue(result['hierarchy']['source_graph_cycles'])
        self.assertIsNone(result['hierarchy']['instances_excluding_top'])

    def test_macro_lexical_scope_is_explicit(self):
        r=syntax.preprocessing_facts('// `ifdef FAKE\n`ifdef SYNTHESIS\n`endif\n','x.sv')
        self.assertEqual(r['directives_and_macro_uses'],{'ifdef':1,'endif':1})

    def test_property_wrappers_are_not_clock_logic(self):
        node={'kind':'SimplePropertyExpr','expr':{'kind':'SimpleSequenceExpr','expr':{'kind':'IdentifierName','identifier':'clk'}}}
        self.assertEqual(syntax.unwrapped(node),{'kind':'IdentifierName','identifier':'clk'})

    def test_two_local_clock_names_can_bind_one_top_input(self):
        def event(name):return {'clock_events':[dict(edge='posedge',expr=name,identifiers=[name])],'source':{}}
        child=dict(ports=[dict(name=n,direction='input') for n in ('c1','c2')],aliases=[],drivers=[],instances=[],
                   processes=[event('c1'),event('c2')],features={'multiple_local_clock_expressions':1})
        top=dict(ports=[dict(name='clk',direction='input')],aliases=[],drivers=[],processes=[],features={},
                 instances=[dict(name='u',bindings=[dict(formal=n,expr='clk',expr_kind='IdentifierName') for n in ('c1','c2')])])
        rows=[dict(path='T',module='Top'),dict(path='T.u',module='M')]
        result=analysis.trace_clocks({'Top':top,'M':child},rows,{'T.u':'T'},{'T':['T.u'],'T.u':[]})
        self.assertEqual(result['top_input_sources'],['T.clk'])
        self.assertTrue(result['multiple_expression_instances'][0]['same_traced_endpoint'])

    def test_inversion_is_derived_clock_not_simple_alias(self):
        module=dict(ports=[dict(name='clk',direction='input')],aliases=[],instances=[],features={},
                    drivers=[dict(target='falling',kind='UnaryBitwiseNotExpression',identifiers=['clk'])],
                    processes=[dict(source={},clock_events=[dict(edge='posedge',expr='falling',identifiers=['falling'])])])
        result=analysis.trace_clocks({'M':module},[dict(path='T',module='M')],{}, {'T':[]})
        self.assertEqual(result['endpoints'][0]['kind'],'logic_or_multiple_drivers')
        self.assertEqual(result['inverted_clock_drivers'][0]['upstream_sources'][0]['signal'],'T.clk')


class Safety(unittest.TestCase):
    def test_server_transport_escapes_unicode_without_changing_request(self):
        observed=[]
        def fake_run(command,**kwargs):
            observed.append(kwargs['input']);kwargs['stdout'].write(b'{}')
            return types.SimpleNamespace(returncode=0)
        with tempfile.TemporaryDirectory() as folder,patch.object(audit.subprocess,'run',fake_run):
            self.assertEqual(audit.server_call(Path(folder),'inspect_scan',{'title':'\u56db\u6001'}),{})
            payload=observed[0]
            self.assertTrue(payload.isascii());self.assertIn(b'\\u56db',payload)
            compile(payload,'transport','exec')
            self.assertEqual(next(Path(folder).glob('server-*/stdin.py')).read_bytes(),payload)

    def test_paths(self):
        for bad in ('/etc/passwd', '../a', 'a/../b', './a', 'a//b', 'a/', 'a\\b', 'a\x00b'):
            with self.subTest(bad=bad), self.assertRaises(ValueError):
                remote.relative(bad)
        self.assertEqual(remote.relative('runs/x/rtl-input/a.sv'), ('runs', 'x', 'rtl-input', 'a.sv'))

    def test_local_escape(self):
        for bad in ('C:/a', '..', '/x', 'a/../b'):
            with self.assertRaises(ValueError):
                audit.local_path(ROOT, bad)

    def test_no_flag_fallback(self):
        fake = types.SimpleNamespace()
        with patch.object(remote, 'os', fake), self.assertRaisesRegex(RuntimeError, 'O_NOATIME'):
            remote.Reader()

    def test_file_open_flags_and_special_rejection(self):
        for mode, dev in ((stat.S_IFREG, 3), (stat.S_IFIFO, 3), (stat.S_IFREG, 4)):
            opened = []
            fake = types.SimpleNamespace(O_RDONLY=0, O_NOFOLLOW=0x20000, O_NOATIME=0x40000,
                     O_NONBLOCK=0x800, close=lambda fd: None,
                     open=lambda *a, **kw: opened.append((a, kw)) or 11,
                     fstat=lambda fd: types.SimpleNamespace(st_mode=mode, st_dev=dev))
            reader = object.__new__(remote.Reader)
            reader.device = 3
            reader.directory = lambda name: 9
            with patch.object(remote, 'os', fake):
                if mode == stat.S_IFREG and dev == 3:
                    self.assertEqual(reader.file('a.sv'), 11)
                else:
                    with self.assertRaises(ValueError):
                        reader.file('a.sv')
            self.assertEqual(opened[0][0][1], 0x60800)

    def test_noatime_error_is_not_retried(self):
        calls = []
        def denied(*args, **kwargs):
            calls.append(args)
            raise PermissionError('noatime denied')
        fake = types.SimpleNamespace(O_RDONLY=0, O_NOFOLLOW=1, O_NOATIME=2, O_NONBLOCK=4,
                                     open=denied, close=lambda fd: None)
        reader = object.__new__(remote.Reader)
        reader.directory = lambda name: 9
        with patch.object(remote, 'os', fake), self.assertRaises(PermissionError):
            reader.file('a.sv')
        self.assertEqual(len(calls), 1)

    def test_payload_has_no_process_or_mutation_api(self):
        tree = ast.parse((ROOT / 'scripts/verification/four_state/audit_fourstate_remote.py').read_text())
        forbidden = {'subprocess', 'tempfile', 'shutil', 'socket', 'urllib'}
        for node in ast.walk(tree):
            if isinstance(node, ast.Import):
                self.assertFalse(forbidden.intersection(n.name for n in node.names))
            if isinstance(node, ast.Call):
                name = node.func.attr if isinstance(node.func, ast.Attribute) else getattr(node.func, 'id', '')
                self.assertNotIn(name, {'exec', 'eval', 'system', 'popen', 'mkdir', 'makedirs', 'unlink',
                                       'remove', 'rename', 'replace', 'chmod', 'utime', 'truncate', 'mkstemp'})


if __name__ == '__main__':
    unittest.main()
