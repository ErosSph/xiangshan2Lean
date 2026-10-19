"""Bounded blocker evidence checks; these are not hardware semantic tests."""
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts/verification/four_state'))
from verify_fourstate_blockers import diagnostic, inventory, ROOT


class BlockerEvidence(unittest.TestCase):
    def test_exact_located_diagnostics(self):
        messages={
            'unsupported active elaborated symbol (StatementBlock)':'PROCESS_SCOPE',
            'unsupported preprocessor directive or macro':'PREPROCESSOR',
            'assignment expression outside continuous assignment (AssignmentExpression)':'PROCEDURAL_BLOCKING',
            'unsupported syntax (BinaryEventExpression)':'ASYNC_MULTI_EVENT',
            'process-local declarations unsupported (DataDeclaration)':'PROCESS_LOCAL_DECLARATION',
            'common direct posedge clock required; asynchronous/derived clocks unsupported (ProceduralBlock)':'ASYNC_MULTI_EVENT',
        }
        for message,category in messages.items():
            with self.subTest(message=message):
                result=diagnostic('ValueError: E:\\source\\minimal.sv:3:12: '+message+'\n')
                self.assertEqual(result['category'],category)
                self.assertEqual((result['file'],result['line'],result['column']),('E:\\source\\minimal.sv',3,12))

    def test_generic_or_syntax_errors_cannot_be_blocker_evidence(self):
        for error in ('ValueError: syntax error',
                      'ValueError: sample.sv:1:1: expected expression',
                      'RuntimeError: sample.sv:1:1: unsupported active elaborated symbol (StatementBlock)',
                      'ValueError: sample.sv:1:1: unsupported syntax (UnknownNode)'):
            self.assertEqual(diagnostic(error)['category'],'UNCLASSIFIED')

    def test_cam_minimum_is_valid_with_local_blocking_then_nba(self):
        inv=inventory(ROOT/'verification/fourstate/blockers/CamLocalElab.sv','CamLocalElab')
        self.assertEqual(inv['parser_error_count'],0)
        self.assertEqual(inv['state_bits'],1)
        self.assertEqual(len(inv['processes']),1)
        process=inv['processes'][0]
        self.assertEqual(process['local_declarations'][0]['source_text'],'automatic logic t;')
        self.assertEqual(process['assignments'],{'AssignmentExpression':1,'NonblockingAssignmentExpression':1})

    def test_async_minimum_is_valid_and_has_both_edges(self):
        inv=inventory(ROOT/'verification/fourstate/blockers/AsyncFlat.sv','AsyncFlat')
        self.assertEqual(inv['parser_error_count'],0)
        self.assertEqual([(e['edge'],e['expression']) for e in inv['processes'][0]['events']],
                         [('posedge','clock'),('posedge','reset')])

    def test_inactive_initial_is_present_in_raw_but_not_active_syntax(self):
        inv=inventory(ROOT/'verification/fourstate/blockers/MacroGuard.sv','MacroGuard')
        self.assertEqual(inv['syntax'].get('InitialBlock',0),0)
        self.assertIn('`ifdef ENABLE_INITIAL_REG_',
                      (ROOT/'verification/fourstate/blockers/MacroGuard.sv').read_text(encoding='utf-8'))

    def test_source_map_comment_is_not_part_of_nba_target_name(self):
        with tempfile.TemporaryDirectory(dir=ROOT/'.cache') as folder:
            source=Path(folder)/'CommentTrivia.sv'
            source.write_text('module CommentTrivia(input clock, input [8:0] d, output reg [8:0] q);\n'
                              'always @(posedge clock) begin // source.scala:9:1\n'
                              '  q <= d;\nend\nendmodule\n',encoding='utf-8')
            inv=inventory(source,'CommentTrivia')
            self.assertEqual(inv['state_bits'],9)
            self.assertEqual([n['name'] for n in inv['states']],['q'])
            self.assertEqual(inv['unresolved_nba_targets'],[])


if __name__=='__main__':unittest.main()
