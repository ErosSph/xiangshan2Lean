"""Exercise project RTL input, includes/macros and an actual child module against Verilator."""
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
from pathlib import Path

from common import ROOT
from rtl import run_emitted_rtl
from yosys2lean import translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def main():
    folder = ROOT / 'experiments/yosys-project-7.3'
    project = folder / 'project'
    (project / 'include').mkdir(parents=True, exist_ok=True)
    (project / 'include/width.svh').write_text('`ifndef WIDTH\n`define WIDTH 5\n`endif\n')
    (project / 'Lane.sv').write_text('''`include "width.svh"
module Lane(input clock,en,input [`WIDTH-1:0] d,output reg [`WIDTH-1:0] q);
initial q=0;
always @(posedge clock) if(en) q<=d+1;
endmodule
''')
    (project / 'ProjectTop.sv').write_text('''`include "width.svh"
module ProjectTop(input clock,en,input [`WIDTH-1:0] d,output [`WIDTH-1:0] q);
Lane lane(.clock(clock),.en(en),.d(d),.q(q));
endmodule
''')
    relative = translate_yosys(project, folder / 'model', 'ProjectTop', 'Project.Top',
                               evidence=folder / 'translation', keep_hierarchy=True)
    path = folder / 'model' / relative
    ir = json.loads(path.read_text())
    rows = [{'inputs': {'en': int(i % 4 != 0), 'd': (i * 7) % 32}} for i in range(96)]
    lean_rows = [{'inputs': {**r['inputs'], **{p['name']: 0 for p in ir['arbitrary_inputs']}}} for r in rows]
    code, actual = simulate_yosys(path, lean_rows, experiment_initial(ir), folder / 'lean')
    assert code == 0
    metadata = {'top': 'ProjectTop', 'clocked': True, 'rtl_sources': ['ProjectTop.sv', 'Lane.sv'],
                'rtl_include_dirs': ['include'], 'ports': [
                    {'name': n, 'rtl_name': n, 'width': w, 'direction': 'output' if n == 'q' else 'input'}
                    for n,w in [('clock',1),('en',1),('d',5),('q',5)]]}
    code, expected = run_emitted_rtl(project, metadata, rows, folder / 'reference')
    assert code == 0
    q = 0
    for cycle, (row, a, b) in enumerate(zip(rows, actual, expected)):
        assert a['pre'] == b['pre'] == {'q': q}, cycle
        if row['inputs']['en']:
            q = (row['inputs']['d'] + 1) % 32
        assert a['post'] == b['post'] == {'q': q}, cycle
    manifest = json.loads((folder / 'model/manifest.json').read_text())
    assert len(manifest['source_files_sha256']) == 3
    assert manifest['frontend_keep_hierarchy']
    report = {'status': 'PASS', 'cycles': len(rows), 'output_comparisons': len(rows) * 2,
              'source_files': manifest['source_files_sha256'],
              'scope': 'RTL directory with two modules and an included macro header; actual Lean/Verilator and integer comparison.'}
    write(folder / 'summary.json', report)
    write(ROOT / 'docs/validation-yosys-project-7.3.json', report)
    print(json.dumps(report, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
