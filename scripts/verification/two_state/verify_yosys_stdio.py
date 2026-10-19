"""Compare static stdout/stderr observations with unmodified original RTL."""
from __future__ import annotations
from pathlib import Path as _BootstrapPath
import sys as _bootstrap_sys

if "__file__" in globals():
    _BOOTSTRAP_FILE = _BootstrapPath(__file__).resolve()
    _SCRIPTS_ROOT = next((parent for parent in _BOOTSTRAP_FILE.parents if parent.name == "scripts"), None)
    if _SCRIPTS_ROOT is None:
        raise RuntimeError("categorized script must be under scripts/")
    _PROJECT_ROOT = _SCRIPTS_ROOT.parent
    for _entry in (_SCRIPTS_ROOT, _BOOTSTRAP_FILE.parent):
        if str(_entry) not in _bootstrap_sys.path:
            _bootstrap_sys.path.insert(0, str(_entry))
else:
    _BOOTSTRAP_FILE = None
    _SCRIPTS_ROOT = None
    _PROJECT_ROOT = None


import json

from common import ROOT
from rtl import run_emitted_rtl
from yosys2lean import digest, translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def main():
    folder = ROOT / 'experiments/yosys-stdio-7.3'
    folder.mkdir(parents=True, exist_ok=True)
    source = folder / 'Stdio.sv'
    source.write_text('''module Stdio(input clock, en, input [3:0] d, output reg [3:0] q);
initial q=0;
// $fwrite(dynamic_fd, "This comment must stay unchanged");
always @(posedge clock) begin
  if(en) begin
    $fwrite(32'h80000002, "ERR q=%0d\\n", q);
    $fwrite(32'h80000001, "OUT literal $fwrite(dynamic_fd) q=%0d\\n", q);
    q<=d;
  end
end
endmodule
''', encoding='utf-8')
    original_hash = digest(source)
    relative = translate_yosys(source, folder / 'model', 'Stdio', 'Stdio.Observed',
                               evidence=folder / 'translation', preserve_effects=True, stdio_compat=True)
    assert digest(source) == original_hash, 'Original RTL changed'
    path = folder / 'model' / relative
    ir = json.loads(path.read_text(encoding='utf-8'))
    manifest = json.loads((folder / 'model/manifest.json').read_text(encoding='utf-8'))
    assert len(manifest['stdio_compatibility']['markers']) == 2
    effects = [e for e in ir['effects'] if e['kind'] == 'print']
    assert {e['stream'] for e in effects} == {'stdout', 'stderr'}
    assert all(not e['format'].startswith('__C2L_STDIO_') for e in effects)
    rows = [{'inputs': {'en': int(i % 3 != 0), 'd': (i * 7) % 16}} for i in range(48)]
    lean_rows = [{'inputs': {**row['inputs'], **{p['name']: 0 for p in ir['arbitrary_inputs']}}} for row in rows]
    code, actual = simulate_yosys(path, lean_rows, experiment_initial(ir), folder / 'lean')
    assert code == 0
    metadata = {'top': 'Stdio', 'clocked': True, 'rtl_sources': ['Stdio.sv'],
                'ports': [{'name': n, 'rtl_name': n, 'width': w, 'direction': 'output' if n == 'q' else 'input'}
                          for n, w in [('clock', 1), ('en', 1), ('d', 4), ('q', 4)]]}
    code, native = run_emitted_rtl(folder, metadata, rows, folder / 'reference')
    assert code == 0
    q, expected_stdout, expected_stderr = 0, [], []
    for index, (row, a, b) in enumerate(zip(rows, actual, native)):
        assert a['pre'] == b['pre'] == {'q': q}, index
        if row['inputs']['en']:
            expected_stdout.append('OUT literal $fwrite(dynamic_fd) q=' + str(q))
            expected_stderr.append('ERR q=' + str(q))
            assert {e['stream'] for e in a['effects_post']} == {'stdout', 'stderr'}, index
            assert all(e['arguments'] == q for e in a['effects_post']), index
            q = row['inputs']['d']
        else:
            assert not a['effects_post'], index
        assert not a['effects_pre'], index
        assert a['post'] == b['post'] == {'q': q}, index
    stdout = (folder / 'reference/verilator-run/stdout.log').read_text(encoding='utf-8').splitlines()
    stderr = (folder / 'reference/verilator-run/stderr.log').read_text(encoding='utf-8').splitlines()
    assert [s for s in stdout if s.startswith('OUT ')] == expected_stdout
    assert [s for s in stderr if s.startswith('ERR ')] == expected_stderr
    bad = folder / 'Dynamic.sv'
    bad.write_text('module Dynamic(input clock,input [31:0] fd); always @(posedge clock) $fwrite(fd,"X"); endmodule', encoding='utf-8')
    try:
        translate_yosys(bad, folder / 'bad-model', 'Dynamic', evidence=folder / 'bad-translation',
                        preserve_effects=True, stdio_compat=True)
    except ValueError as error:
        assert 'static standard-stream descriptor' in str(error)
    else:
        raise AssertionError('Dynamic descriptor silently accepted')
    report = {'status': 'PASS', 'cycles': len(rows), 'output_comparisons': 2 * len(rows),
              'events': {'stdout': len(expected_stdout), 'stderr': len(expected_stderr)},
              'original_rtl_sha256': original_hash, 'original_rtl_modified': False,
              'dynamic_descriptor_rejected': True,
              'scope': 'Fixed standard-stream $fwrite with literal format; original Verilator output streams and pre-NBA arguments compared with Lean events. No arbitrary files, DPI or generic system-task support.'}
    write(folder / 'summary.json', report)
    write(ROOT / 'docs/validation-yosys-stdio-7.3.json', report)
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
