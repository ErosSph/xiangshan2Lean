"""Check that official layer enabling preserves Chisel's actual assertion intrinsic."""
import json

from common import ROOT, FIRTOOL_VERSION, run_logged
from rtl import run_emitted_rtl
from yosys2lean import translate_yosys, write
from yosys_simulate import experiment_initial, simulate_yosys


def main():
    folder = ROOT / 'experiments/xiangshan-layers-7.3'
    folder.mkdir(parents=True, exist_ok=True)
    source = folder / 'Layer.fir'
    source.write_text(r'''FIRRTL version 6.0.0
circuit Layer :
  layer Verification, bind, "verification" :
    layer Assert, bind, "verification\assert" :
  public module Layer :
    input clock : Clock
    input en : UInt<1>
    input ok : UInt<1>
    output q : UInt<1>
    connect q, ok
    layerblock Verification :
      layerblock Assert :
        intrinsic(circt_chisel_ifelsefatal<format = "Assertion failed\n", label = "chisel3_builtin">, clock, ok, en)
''', encoding='utf-8')
    firtool = ROOT / '.tools' / ('firtool-' + FIRTOOL_VERSION) / ('firtool-' + FIRTOOL_VERSION) / 'bin/firtool.exe'
    rtl = folder / 'rtl'
    rtl.mkdir(exist_ok=True)
    command = [str(firtool), str(source), '--split-verilog', '-o=' + str(rtl),
               '--default-layer-specialization=enable', '--verification-flavor=immediate',
               '--mlir-print-op-on-diagnostic=false']
    assert run_logged(command, folder / 'firtool', echo=False) == 0
    relative = translate_yosys(rtl, folder / 'model', 'Layer', 'Layers.Check',
                               evidence=folder / 'translation', preserve_effects=True)
    path = folder / 'model' / relative
    ir = json.loads(path.read_text(encoding='utf-8'))
    assert any(e['kind'] == 'assert' for e in ir['effects'])
    metadata = {'top': 'Layer', 'clocked': True, 'assertions': True, 'rtl_sources': ['Layer.sv'],
                'ports': [{'name': n, 'rtl_name': n, 'width': 1,
                           'direction': 'output' if n == 'q' else 'input'}
                          for n in ('clock', 'en', 'ok', 'q')]}
    outcomes = []
    for label, rows, expected in [('valid', [{'inputs': {'en': 0, 'ok': 0}}, {'inputs': {'en': 1, 'ok': 1}}], True),
                                  ('invalid', [{'inputs': {'en': 1, 'ok': 0}}], False)]:
        lean_rows = [{'inputs': {**r['inputs'], **{p['name']: 0 for p in ir['arbitrary_inputs']}}} for r in rows]
        a, _ = simulate_yosys(path, lean_rows, experiment_initial(ir), folder / (label + '-lean'))
        b, _ = run_emitted_rtl(rtl, metadata, rows, folder / (label + '-rtl'))
        assert (a == 0) == (b == 0) == expected, (label, a, b)
        outcomes.append({'case': label, 'lean_exit': a, 'rtl_exit': b})
    report = {'status': 'PASS', 'outcomes': outcomes,
              'scope': 'Original Chisel ifelsefatal intrinsic inside nested verification layers; all layers enabled by official firtool, actual Lean and Verilator execution.'}
    write(folder / 'summary.json', report)
    write(ROOT / 'docs/validation-xiangshan-layers-7.3.json', report)
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    raise SystemExit(main())
