"""Fresh original Nanhu ALU / encoded RTL / executable Lean verification."""
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


import argparse
from collections import Counter
import datetime as dt
import itertools
import json
import os
from pathlib import Path
import random
import re
import shutil
import sys
import traceback
import uuid

from bootstrap_fourstate import load_parser
from common import ROOT, run_logged
from fourstate2lean import digest, fresh_directory, provenance, translate, write
from fourstate_frontend import parse
from fourstate_simulate import decode, load, simulate
from verify_fourstate import compare, run_rtl, tools_record

SEED = 410172
TOP = 'AluDataModule'
MODULE = 'xiangshan.backend.fu.AluDataModule'
COMMIT = '997cd5b35cfbd26586674aa553d0f04b27914cb2'
DEPENDENCIES = ROOT / '.cache/xiangshan-dependencies-7.3'
UPSTREAM = DEPENDENCIES / 'xiangshan/src/main/scala/xiangshan'
DEAD_RUNTIME_MULTIPLY = "module T(input a,b,output [1:0] y);wire [1:0] n = 1'b0 ? (a * b) : a;assign y=n;endmodule"


def require_multiply_diagnostic(source, location, diagnostic):
    expected = f'{source}:{location["line"]}:{location["column"]}: unsupported hardware syntax (MultiplyExpression)'
    if diagnostic.strip() != expected:
        raise AssertionError('Expected located unsupported hardware operation MultiplyExpression; got: ' + diagnostic)


def check_dead_runtime_multiply(source):
    """A malformed fixture or an unrelated rejection must never pass this test."""
    s = load_parser()
    sm = s.SourceManager()
    tree = s.syntax.SyntaxTree.fromFile(str(source), sm)
    if any(d.isError() for d in tree.diagnostics):
        raise AssertionError('DeadRuntimeMultiply fixture has syntax errors:\n' +
                             s.DiagnosticEngine.reportAll(sm, tree.diagnostics))
    multiply = []
    tree.root.visit(lambda n: multiply.append(n) if isinstance(n, s.syntax.SyntaxNode) and
                    str(n.kind).split('.')[-1] == 'MultiplyExpression' else None)
    if len(multiply) != 1:
        raise AssertionError('DeadRuntimeMultiply fixture must contain exactly one raw MultiplyExpression')
    options = s.ast.CompilationOptions()
    options.topModules = {'T'}
    compilation = s.ast.Compilation(s.Bag([options]))
    compilation.addSyntaxTree(tree)
    compilation.getRoot()
    diagnostics = compilation.getAllDiagnostics()
    if any(d.isError() for d in diagnostics):
        raise AssertionError('DeadRuntimeMultiply fixture has elaboration errors:\n' +
                             s.DiagnosticEngine.reportAll(sm, diagnostics))
    pos = multiply[0].sourceRange.start
    location = {'line': sm.getLineNumber(pos), 'column': sm.getColumnNumber(pos)}
    try:
        parse(source, 'T')
    except (ValueError, RuntimeError) as exc:
        require_multiply_diagnostic(source, location, str(exc))
        return {'case': 'DeadRuntimeMultiply', 'status': 'PASS', 'diagnostic': str(exc),
                'syntax_errors': 0, 'elaboration_errors': 0, 'raw_multiply_nodes': len(multiply),
                'location': location, 'source_sha256': digest(source),
                'elaboration_diagnostics': s.DiagnosticEngine.reportAll(sm, diagnostics)}
    raise AssertionError('Unsupported dead-branch MultiplyExpression accepted')


def prepare(folder):
    # Scope the override to subprocesses of this independent entrypoint.
    java = ROOT / '.tools/jdk-17.0.20.1+1/bin/java.exe'
    env = dict(os.environ, PYTHONIOENCODING='utf-8', PYTHONUTF8='1')
    if java.is_file():
        env['CHISEL2LEAN_JAVA'] = str(java)
    commands = [
        ('fetch', [sys.executable, '-B', 'scripts/fetch_xiangshan_dependencies.py']),
        ('build', [sys.executable, '-B', 'scripts/sbt.py', '--log', str(folder / 'sbt'),
                   'xiangshanFramework/writeXiangshanClasspath']),
        ('elaborate', [sys.executable, '-B', 'scripts/elaborate_chisel.py', '--module', MODULE,
                       '--constructor', 'examples/modern/xiangshan-constructor.json',
                       '--classpath-file', '.cache/xiangshan-classpath.txt',
                       '--out', str(folder / 'original'), '--evidence', str(folder / 'elaboration')])]
    for name, command in commands:
        if run_logged(command, folder / ('prepare-' + name), env=env, echo=False):
            raise RuntimeError('Pinned source preparation failed: ' + name)
    source = folder / 'original/Chisel2LeanReference.v'
    marker = json.loads((DEPENDENCIES / 'xiangshan/.chisel2lean-source.json').read_text(encoding='utf-8'))
    if marker['commit'] != COMMIT:
        raise ValueError('Original XiangShan revision mismatch')
    sources, classes, local_sources = {}, {}, {}
    for dependency in json.loads((DEPENDENCIES / 'sources.json').read_text(encoding='utf-8')):
        base = DEPENDENCIES / dependency['name']
        for path in base.rglob('*'):
            if path.is_file() and (path.suffix in ('.scala', '.java') or path.name.startswith(('LICENSE', '.chisel2lean-source'))):
                target = folder / 'upstream-snapshot' / path.relative_to(DEPENDENCIES)
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(path.read_bytes())
                sources[path.relative_to(DEPENDENCIES).as_posix()] = digest(path)
    # The existing build deliberately uses vendored CDE and local config/bridge
    # sources. Record the actual inputs, not just the fetched upstream copies.
    local_files = {ROOT / name for name in (
        'build.sbt', 'project/build.properties', 'project/plugins.sbt', 'project/repositories',
        'examples/modern/xiangshan-constructor.json', 'verification/xiangshan/config-dependencies.json',
        'scripts/elaborate_chisel.py',
        'scripts/fetch_xiangshan_dependencies.py', 'scripts/sbt.py', 'scripts/common.py',
        'python/chisel2lean4/__init__.py', 'python/chisel2lean4/_compat.py',
        'python/chisel2lean4/frontends/__init__.py',
        'python/chisel2lean4/frontends/chisel_elaborator.py')}
    for directory in ('vendor/cde', 'verification/xiangshan/config/reference', 'reference/src/main/scala'):
        local_files.update(p for p in (ROOT / directory).rglob('*') if p.is_file() and
                           (p.suffix in ('.scala', '.java', '.json') or p.name.startswith(('LICENSE', 'NOTICE'))))
    for path in sorted(local_files):
        if path.is_file():
            target = folder / 'local-source-snapshot' / path.relative_to(ROOT)
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(path.read_bytes())
            local_sources[path.relative_to(ROOT).as_posix()] = digest(path)
    classpath = (ROOT / '.cache/xiangshan-classpath.txt').read_text(encoding='utf-8').strip().split(os.pathsep)
    for name in classpath:
        path = Path(name)
        if not path.exists():
            raise ValueError('Missing actual classpath entry: ' + name)
        if path.is_file():
            classes[name] = digest(path)
        else:
            for binary in path.rglob('*.class'):
                classes[str(binary)] = digest(binary)
    write(folder / 'upstream-provenance.json', {
        'dependencies': json.loads((DEPENDENCIES / 'sources.json').read_text(encoding='utf-8')),
        'constructor': json.loads((ROOT / 'examples/modern/xiangshan-constructor.json').read_text(encoding='utf-8')),
        'source_sha256': sources, 'local_source_sha256': local_sources,
        'classpath_sha256': classes, 'rtl_sha256': digest(source),
        'java_override': env.get('CHISEL2LEAN_JAVA'), 'upstream_hardware_modified': False})
    return source


def audit(source, folder):
    """Inventory official bound hardware without importing the converter IR."""
    s = load_parser()
    sm = s.SourceManager()
    tree = s.syntax.SyntaxTree.fromFile(str(source), sm)
    options = s.ast.CompilationOptions()
    options.topModules = {TOP}
    compilation = s.ast.Compilation(s.Bag([options]))
    compilation.addSyntaxTree(tree)
    root = compilation.getRoot()
    errors = compilation.getAllDiagnostics()
    if any(d.isError() for d in errors):
        raise ValueError(s.DiagnosticEngine.reportAll(sm, errors))
    instance = root.topInstances[0]
    result = {'top': TOP, 'source_sha256': digest(source), 'instances': [], 'ports': [],
              'signals': [], 'processes': [], 'expressions': {}, 'syntax': {}}
    syntax, expressions = Counter(), Counter()
    def kind(n):
        return str(n.kind).split('.')[-1]
    tree.root.visit(lambda n: syntax.update([kind(n)]) if isinstance(n, s.syntax.SyntaxNode) else None)
    def expr(n):
        if isinstance(n, s.ast.Expression):
            expressions[kind(n) + (':' + str(n.op).split('.')[-1] if hasattr(n, 'op') else '')] += 1
    def scope(body):
        for n in body:
            k = kind(n)
            if k == 'Instance':
                result['instances'].append({'path': n.hierarchicalPath, 'module': n.definition.name})
                scope(n.body)
            elif k in ('Net', 'Variable'):
                result['signals'].append({'path': n.hierarchicalPath, 'kind': k, 'type': str(n.type),
                                          'width': n.type.bitWidth, 'initializer': n.initializer is not None})
                if n.initializer is not None:
                    n.initializer.visit(expr)
            elif k == 'ContinuousAssign':
                n.assignment.visit(expr)
            elif k == 'ProceduralBlock':
                result['processes'].append({'kind': str(n.procedureKind), 'path': n.hierarchicalPath})
                n.body.visit(expr)
    scope(instance.body)
    for p in instance.body.portList:
        result['ports'].append({'name': p.name, 'direction': str(p.direction).split('.')[-1],
                                'width': p.type.bitWidth, 'signed': bool(p.type.isSigned)})
    result.update(expressions=dict(expressions), syntax=dict(syntax))
    write(folder / 'raw-rtl-inventory.json', result)
    try:
        ir = parse(source, TOP)
        outcome = {'status': 'ACCEPTED', 'format': ir['format']}
    except (ValueError, RuntimeError) as exc:
        outcome = {'status': 'REJECTED', 'diagnostic': str(exc)}
    write(folder / 'frontend-probe.json', outcome)
    return result


def compatible_reference(source, folder):
    """User-approved official codegen variant; never edit either RTL file."""
    reference = folder / 'icarus-compatible.v'
    fir = source.parent / 'design.fir'
    executable = ROOT / '.tools/firtool-1.135.0/firtool-1.135.0/bin/firtool.exe'
    command = [str(executable), str(fir), '--disable-all-randomization',
               '--default-layer-specialization=enable', '--lowering-options=maximumNumberOfTermsPerExpression=1',
               '-o', str(reference)]
    if run_logged(command, folder / 'compatible-codegen', echo=False):
        raise RuntimeError('Official Icarus-compatible codegen failed')
    expected = json.loads((ROOT / 'verification/fourstate/xiangshan-alu-expected.json').read_text(encoding='utf-8'))
    raw_mapping = {'top': TOP, 'ports': [dict(name=name, direction=spec[0], width=spec[1], left=spec[1]-1, right=0)
                                        for name, spec in expected['ports'].items()]}
    probe = [{'inputs': {'io_src_0': '0'*63+'1', 'io_src_1': '0'*64, 'io_func': '00000zz',
                         'io_pred_taken': '0', 'io_isBranch': '0'}}]
    try:
        run_rtl(source, raw_mapping, probe, folder / 'default-reference-probe')
    except RuntimeError:
        error = (folder / 'default-reference-probe/compile/stderr.log').read_text(encoding='utf-8')
        if 'Array index expressions must be constant here' not in error:
            raise
    else:
        raise ValueError('Expected default Icarus limitation changed; re-audit reference contract')
    rejected = folder / 'rejected-casez-reference.v'
    alternative = [str(executable), str(fir), '--disable-all-randomization',
                   '--default-layer-specialization=enable', '--lowering-options=disallowPackedArrays',
                   '-o', str(rejected)]
    if run_logged(alternative, folder / 'rejected-casez-codegen', echo=False):
        raise RuntimeError('Reference option audit codegen failed')
    correct = run_rtl(reference, raw_mapping, probe, folder / 'reference-option-correct')
    incorrect = run_rtl(rejected, raw_mapping, probe, folder / 'reference-option-casez')
    if correct[0]['io_result'] != 'x'*64 or incorrect[0]['io_result'] != '0'*63+'1':
        raise ValueError('Reference option X/Z counterexample changed')
    write(folder / 'reference-option-counterexample.json', {'trace': probe, 'preserved_packed_index': correct,
                                                           'rejected_casez_lowering': incorrect})
    write(folder / 'reference-contract.json', {
        'authorization': 'User approved a separately generated official compatibility reference in this task.',
        'primary_rtl': str(source), 'primary_sha256': digest(source),
        'reference_rtl': str(reference), 'reference_sha256': digest(reference),
        'official_chirrtl_sha256': digest(fir), 'firtool_sha256': digest(executable),
        'command': command, 'source_configuration': 'Same pinned Nanhu / NanhuCoreConfig / MinimalConfig(1)',
        'manual_rtl_edits': False,
        'reason': 'Icarus 13 rejects nested dynamic packed selection followed by a slice in the default RTL.',
        'rejected_option': 'disallowPackedArrays introduces casez and changes Z-selector behavior; executed counterexample retained.',
        'comparison_scope': 'Default RTL converted to encoded RTL and Lean; official expression-split RTL with preserved packed indexing executed by Icarus.'})
    audit(reference, folder / 'reference-audit')
    return reference


def corpus():
    from verify_modern_firrtl import alu
    known, _ = alu(UPSTREAM)
    aliases = {'io.src.0': 'io_src_0', 'io.src.1': 'io_src_1', 'io.func': 'io_func',
               'io.pred_taken': 'io_pred_taken', 'io.isBranch': 'io_isBranch'}
    widths = {'io_src_0': 64, 'io_src_1': 64, 'io_func': 7, 'io_pred_taken': 1, 'io_isBranch': 1}
    trace = [{'inputs': {aliases[k]: format(v, '0' + str(widths[aliases[k]]) + 'b') for k, v in row['inputs'].items()}}
             for row in known(None)]
    counts = {'known': len(trace)}
    package = (UPSTREAM / 'package.scala').read_text(encoding='utf-8')
    body = package.split('object ALUOpType', 1)[1].split('object MDUOpType', 1)[0]
    labels = {label: int(bits.replace('_', ''), 2) for label, bits in re.findall(r'def\s+(\w+)\s*=\s*"b([01_]+)"\.U', body)}
    def row(func, a, b, pred='0', branch='0'):
        return {'inputs': {'io_src_0': a, 'io_src_1': b,
                           'io_func': format(func, '07b') if isinstance(func, int) else func,
                           'io_pred_taken': pred, 'io_isBranch': branch}}
    def append(name, rows):
        start = len(trace)
        trace.extend(rows)
        counts[name] = len(trace) - start
    patterns = ['0'*64, '1'*64, 'x'*64, 'z'*64, '01xz'*16, 'zx10'*16, 'x'+'0'*63, '0'*63+'z']
    append('all_opcodes_mixed', [row(f, a, patterns[(i+3) % len(patterns)])
                               for f in range(128) for i, a in enumerate(patterns)])
    injected = []
    for label in ('add', 'sub', 'and', 'or', 'xor', 'sra'):
        for side, bit, state in itertools.product(range(2), range(64), 'xz'):
            data = list('0'*64)
            data[63-bit] = state
            operands = ['0'*63+'1', '0'*63+'1']
            operands[side] = ''.join(data)
            injected.append(row(labels[label], *operands))
    append('walking_unknown', injected)
    controls = []
    for bit, state, a in itertools.product(range(7), 'xz', patterns[:4]):
        func = list(format(labels['and'], '07b'))
        func[bit] = state
        controls.append(row(''.join(func), a, '1'*64))
    controls += [row(c*7, a, '0'*64) for c, a in itertools.product('xz', patterns[:4])]
    append('unknown_function', controls)
    append('branch_controls', [row(labels[f], a, '0'*64, p, b)
                               for f, a, p, b in itertools.product(('beq', 'bne', 'blt', 'bltu'), patterns[:4], '01xz', '01xz')])
    rng = random.Random(SEED)
    append('random', [row(''.join(rng.choice('01xz') for _ in range(7)),
                         ''.join(rng.choice('01xz') for _ in range(64)),
                         ''.join(rng.choice('01xz') for _ in range(64)),
                         rng.choice('01xz'), rng.choice('01xz')) for _ in range(2048)])
    # Explicit mask and direct wiring cases keep the corpus from degenerating to all-X outputs.
    append('directed', [row(labels['and'], 'x'*64, '0'*64),
                        row(labels['pack'], 'z'*64, '0'*64),
                        row(labels['sra'], 'z'+'0'*63, '0'*63+'1')])
    return trace, counts


def gap_checks(folder):
    from verify_fourstate_operators import run_case, sampled
    words = [''.join(x) for x in itertools.product('01xz', repeat=4)]
    trace = [{'inputs': {'a': a, 'b': words[(i*7) % len(words)],
                         'index': format(i % 16, '04b'), 'signed_index': format(i % 16, '04b')}}
             for i, a in enumerate(words)]
    trace += [{'inputs': {'a': 'z101', 'b': '01xz', 'index': i, 'signed_index': i}}
              for i in words]
    positive = [run_case(folder, 'AluGaps', trace)]
    values = [{'a': a*4, 'index': index, 'en': en}
              for a, index, en in itertools.product('01xz', ('0000', '0001', '1111', '00x1'), '01xz')]
    positive.append(run_case(folder, 'AluGapsState', sampled(values), {'AluGapsState.q': 'z101'}))
    positive.append(run_case(folder, 'NetAlias', [{'inputs': {'a': c*4}} for c in '01xz']))
    normalized = json.loads((folder / positive[-1]['manifest']).read_text(encoding='utf-8'))
    if normalized['format'] != 'chisel2lean-fourstate-manifest-v4':
        raise ValueError('Wire initializer normalization unnecessarily changed the IR version')
    negatives = {
        'VariableInitialization': "module T(input a,output y);logic n=1'b0;assign y=n;endmodule",
        'MultipleInitializedDrivers': 'module T(input a,output y);wire n=a;assign n=~a;assign y=n;endmodule',
        'InitializedCycle': 'module T(input a,output y);wire n=y;assign y=n;endmodule',
        'ZeroReplication': 'module T(input a,output [1:0] y);assign y={0{a}};endmodule',
        'RuntimeReplication': 'module T(input [3:0] n,input a,output [3:0] y);assign y={n{a}};endmodule',
        'UnknownReplication': "module T(input a,output [3:0] y);assign y={2'bxx{a}};endmodule",
        'PackedPort': 'module T(input [1:0][3:0] a,output [3:0] y);assign y=a[0];endmodule',
        'PackedRegister': "module T(input a,output [3:0] y);logic [1:0][3:0] n;assign n={8{a}};assign y=n[0];endmodule",
        'UnpackedMemory': 'module T(input a,output y);wire n[0:1];assign y=n[0];endmodule',
        'DynamicScalarBit': 'module T(input [3:0] a,input [1:0] i,output y);assign y=a[i];endmodule',
        'DeadRuntimeMultiply': DEAD_RUNTIME_MULTIPLY,
    }
    checks = []
    for name, raw in negatives.items():
        source = folder / 'rejections' / (name + '.sv')
        source.parent.mkdir(exist_ok=True)
        source.write_text(raw, encoding='utf-8')
        if name == 'DeadRuntimeMultiply':
            checks.append(check_dead_runtime_multiply(source))
            continue
        try:
            parse(source, 'T')
        except (ValueError, RuntimeError) as exc:
            if not re.search(re.escape(str(source)) + r':\d+:\d+:', str(exc)):
                raise AssertionError('Missing gap rejection source location: ' + name) from exc
            checks.append({'case': name, 'status': 'PASS', 'diagnostic': str(exc)})
        else:
            raise AssertionError('Unsupported gap test accepted: ' + name)
    return {'positive': positive, 'rejections': checks}


def execute_case(source, folder, trace, reference=None):
    write(folder / 'trace.json', trace)
    (folder / 'trace.jsonl').write_text(''.join(json.dumps(r) + '\n' for r in trace), encoding='utf-8')
    manifest = translate(source, TOP, folder / 'converted')
    mapping, model = load(manifest)
    inventory(folder, mapping, model)
    original = run_rtl(reference or source, mapping, trace, folder / 'original-run')
    encoded = run_rtl(manifest.parent / 'encoded.sv', mapping, trace, folder / 'encoded-run', True)
    lean = simulate(manifest, trace, folder / 'lean-run')
    bits = compare(mapping, original, encoded, [r['outputs'] for r in lean])
    rails = json.loads((folder / 'lean-run/lean/result.json').read_text(encoding='utf-8'))
    if [r['pre'] for r in rails] != encoded:
        raise ValueError('Encoded RTL and actual Lean rail results differ')
    histogram = Counter(c for row in original for value in row.values() for c in value)
    if not all(histogram[c] for c in '01xz'):
        raise ValueError('ALU corpus did not observe every output state: ' + repr(histogram))
    masked = original[-3]['io_result']
    passed_z = original[-2]['io_result']
    if masked != '0'*64 or passed_z != '0'*32+'z'*32:
        raise ValueError('Directed known-mask / Z-preserving output coverage failed')
    return mapping, original, lean, {'status': 'PASS', 'samples': len(trace), 'output_bit_positions': bits,
                                    'output_states': dict(histogram), 'manifest': str(manifest.relative_to(folder)),
                                    'manifest_sha256': digest(manifest)}


def inventory(folder, mapping, model):
    expected = json.loads((ROOT / 'verification/fourstate/xiangshan-alu-expected.json').read_text(encoding='utf-8'))
    write(folder / 'expected-inventory.json', expected)
    raw = json.loads((folder / 'raw-rtl-inventory.json').read_text(encoding='utf-8'))
    converted = json.loads((folder / 'converted/fourstate.ir.json').read_text(encoding='utf-8'))
    elaboration = json.loads((folder / 'converted/elaboration.json').read_text(encoding='utf-8'))
    if {p['name']: [('input' if p['direction'] == 'In' else 'output'), p['width'], p['signed']]
            for p in raw['ports']} != expected['ports']:
        raise ValueError('Independent original ALU port inventory mismatch')
    if {p['name']: [p['direction'], p['width'], p['signed']] for p in mapping['ports']} != expected['ports']:
        raise ValueError('Independent converted ALU port inventory mismatch')
    if {p['path']: p['module'] for p in raw['instances']} != expected['instances']:
        raise ValueError('Independent original ALU instance inventory mismatch')
    if {p['path']: p['module'] for p in elaboration['instances'] if p['path'] != TOP} != expected['instances']:
        raise ValueError('Independent converted ALU instance inventory mismatch')
    if raw['processes'] or any(d.get('states', []) != expected['states'] for d in
                               [converted, mapping, elaboration, json.loads(model.read_text(encoding='utf-8'))]):
        raise ValueError('ALU unexpectedly contains hardware/hidden state')
    reference = json.loads((folder / 'reference-audit/raw-rtl-inventory.json').read_text(encoding='utf-8'))
    if reference['ports'] != raw['ports'] or reference['processes'] or reference['instances'] != raw['instances']:
        raise ValueError('Official compatible RTL interface/hardware inventory differs')
    write(folder / 'inventory-result.json', {'status': 'PASS', 'ports': len(expected['ports']),
                                           'child_instances': len(expected['instances']), 'states': []})


def two_state(source, folder, trace, original):
    from yosys2lean import translate_yosys
    from yosys_simulate import simulate_yosys
    indices = [f*121+p for f in range(128) for p in (0, 120)]
    rows = [{'inputs': {k: int(v, 2) for k, v in trace[i]['inputs'].items()}} for i in indices]
    write(folder / 'two-state-request.json', rows)
    relative = translate_yosys(source, folder / 'two-state-model', TOP, namespace='FourState.AluBaseline',
                               evidence=folder / 'two-state-translation', yosys_engine='native', lean_backend='source')
    model = folder / 'two-state-model' / relative
    ir = json.loads(model.read_text(encoding='utf-8'))
    if ir['states'] or ir['clock'] is not None:
        raise ValueError('Original ALU two-state backend unexpectedly has state')
    for choice in (0, 1):
        extra = {p['name']: ((1 << p['width'])-1)*choice for p in ir['arbitrary_inputs']}
        request = [{'inputs': {**r['inputs'], **extra}} for r in rows]
        code, result = simulate_yosys(model, request, {}, folder / ('two-state-run-' + str(choice)))
        if code or len(result) != len(rows):
            raise ValueError('Original ALU two-state execution failed')
        for i, actual in enumerate(result):
            values = {name: format(value, '064b' if name == 'io_result' else '01b')
                      for name, value in actual['pre'].items()}
            if values != original[indices[i]]:
                raise ValueError('Known-input ALU two-state mismatch at ' + str(indices[i]))
    return {'status': 'PASS', 'samples': len(rows), 'arbitrary_inputs': ir['arbitrary_inputs'], 'choices': [0, 1]}


def loader_checks(folder):
    checks = []
    short_root = fresh_directory(ROOT / 'experiments/fourstate' / ('xa-l-' + folder.name[-8:]))
    for name in ('mapping-version', 'ir-version', 'missing-source', 'corrupt-rtl', 'mode', 'missing-capabilities'):
        case = short_root / name
        shutil.copytree(folder / 'converted', case)
        manifest_path = case / 'fourstate-manifest.json'
        manifest = json.loads(manifest_path.read_text(encoding='utf-8'))
        if name == 'mapping-version':
            path = case / 'ports.json'
            data = json.loads(path.read_text(encoding='utf-8')); data['format'] = 'chisel2lean-fourstate-ports-v4'
            write(path, data); manifest['artifact_sha256']['ports.json'] = digest(path)
        elif name in ('ir-version', 'missing-capabilities'):
            path = case / 'fourstate.ir.json'
            data = json.loads(path.read_text(encoding='utf-8'))
            if name == 'ir-version':
                data['format'] = 'chisel2lean-fourstate-ir-v4'
            else:
                del data['capabilities']
            write(path, data); manifest['artifact_sha256']['fourstate.ir.json'] = digest(path)
        elif name == 'missing-source':
            del manifest['sources']
        elif name == 'mode':
            manifest['mode'] = 'sequential'
        else:
            with (case / 'encoded.sv').open('a') as stream:
                stream.write('\n// damaged\n')
        write(manifest_path, manifest)
        try:
            load(manifest_path)
        except (ValueError, RuntimeError) as exc:
            checks.append({'case': name, 'status': 'PASS', 'diagnostic': str(exc),
                           'evidence': Path(os.path.relpath(case, folder)).as_posix()})
        else:
            raise AssertionError('Malformed v5 artifact accepted: ' + name)
    return checks


def regressions(folder):
    from concurrent.futures import ThreadPoolExecutor
    commands = [('combinational', ['scripts/verification/four_state/verify_fourstate.py']),
                ('sequential', ['scripts/verification/four_state/verify_fourstate_sequential.py']),
                ('hierarchy', ['scripts/verification/four_state/verify_fourstate_hierarchy.py'])]
    commands += [(batch, ['scripts/verification/four_state/verify_fourstate_operators.py', '--batch', batch])
                 for batch in ('width', 'logic', 'arithmetic', 'compatibility')]
    short_root = fresh_directory(ROOT / 'experiments/fourstate' / ('xa-r-' + folder.name[-8:]))
    def run(item):
        name, arguments = item
        evidence = short_root / name
        command = [sys.executable, '-B', *arguments, '--evidence', str(evidence)]
        code = run_logged(command, folder / 'regression-commands' / name, echo=False)
        reports = list(evidence.glob('*/summary.json'))
        if code or len(reports) != 1:
            raise RuntimeError('Four-state regression failed: ' + name)
        report = json.loads(reports[0].read_text(encoding='utf-8'))
        if report['status'] != 'PASS':
            raise RuntimeError('Four-state regression not PASS: ' + name)
        return {'name': name, 'status': 'PASS', 'exit_code': code,
                'samples': sum(c['samples'] for c in report['cases']),
                'report': Path(os.path.relpath(reports[0], folder)).as_posix(), 'sha256': digest(reports[0])}
    with ThreadPoolExecutor(max_workers=3) as pool:
        result = list(pool.map(run, commands))
    # Keep an original v4 sequential artifact, independent of newly generated products.
    case = ROOT / 'experiments/fourstate/hierarchy-audit-fix/20261016T174507Z-426858c4/HierarchyTop'
    trace = json.loads((case / 'trace.json').read_text(encoding='utf-8'))
    initial = json.loads((case / 'initial.json').read_text(encoding='utf-8'))
    actual = simulate(case / 'translation/fourstate-manifest.json', trace, folder / 'replay-v4', initial)
    if actual != json.loads((case / 'lean/fourstate-result.json').read_text(encoding='utf-8')):
        raise ValueError('Old v4 sequential replay differs')
    result.append({'name': 'v4-sequential-replay', 'status': 'PASS', 'samples': len(trace)})
    return result


def campaign(folder):
    report = {'status': 'RUNNING', 'command': [sys.executable, *sys.argv], 'seed': SEED,
              'scope': 'Original fixed Nanhu AluDataModule combinational four-state differential tests; not a general proof.'}
    write(folder / 'summary.json', report)
    try:
        report['source_snapshot_sha256'] = provenance(folder)
        report['tools'] = tools_record(folder / 'tools')
        for name, executable, option in [
            ('java', ROOT / '.tools/jdk-17.0.20.1+1/bin/java.exe', '-version'),
            ('firtool', ROOT / '.tools/firtool-1.135.0/firtool-1.135.0/bin/firtool.exe', '--version')]:
            log = folder / 'tools' / name
            if run_logged([str(executable), option], log, echo=False):
                raise RuntimeError('Pinned tool probe failed: ' + name)
            report['tools'][name] = {'executable': str(executable), 'sha256': digest(executable),
                                     'output': (log / 'stdout.log').read_text(encoding='utf-8') + (log / 'stderr.log').read_text(encoding='utf-8')}
        print('Restoring / elaborating original Nanhu ALU', flush=True)
        source = prepare(folder)
        report['rtl_sha256'] = digest(source)
        audit(source, folder)
        reference = compatible_reference(source, folder)
        report['reference_sha256'] = digest(reference)
        print('Validating actual RTL gap semantics', flush=True)
        report['gap_checks'] = gap_checks(folder)
        trace, counts = corpus()
        report['vector_categories'] = counts
        print('Converting and running original ALU:', len(trace), 'samples', flush=True)
        mapping, original, lean, report['alu'] = execute_case(source, folder, trace, reference)
        report['faults'] = faults(folder, mapping, trace, original, lean)
        report['two_state'] = two_state(source, folder, trace, original)
        report['loader_checks'] = loader_checks(folder)
        print('Running existing regressions and old artifact replays', flush=True)
        report['regressions'] = regressions(folder)
        report['status'] = 'PASS'
    except Exception:
        report['status'] = 'FAIL'
        report['error'] = traceback.format_exc()
    finally:
        # Short sibling paths avoid Windows MAX_PATH in backend provenance copies.
        # They remain private to this run and are linked and hashed by this report.
        report['external_artifact_sha256'] = {
            Path(os.path.relpath(p, folder)).as_posix(): digest(p)
            for prefix in ('xa-l-', 'xa-r-')
            for p in (ROOT / 'experiments/fourstate' / (prefix + folder.name[-8:])).rglob('*') if p.is_file()}
        report['artifact_sha256'] = {p.relative_to(folder).as_posix(): digest(p) for p in folder.rglob('*')
                                    if p.is_file() and p.name != 'summary.json'}
        write(folder / 'summary.json', report)
    return report


def multiply_campaign(folder):
    """Only exercise the repaired negative fixture and its acceptance guards."""
    from bootstrap_fourstate import INSTALL, LOCK
    report = {'status': 'RUNNING', 'command': [sys.executable, *sys.argv],
              'scope': 'Targeted dead runtime multiplication audit; no ALU or full regression rerun.',
              'not_run': ['ALU conversion', 'RTL simulation', 'Lean compilation/execution', 'full regressions'],
              'reference_contract': 'Default original RTL is the conversion input; Icarus executes the official expression-split output of the same CHIRRTL. This targeted run does not directly simulate default RTL.'}
    write(folder / 'summary.json', report)
    try:
        report['source_snapshot_sha256'] = provenance(folder)
        s = load_parser()
        receipt = INSTALL / 'fourstate-install.json'
        for path in (LOCK, receipt):
            target = folder / 'tools' / path.name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(path, target)
        report['tools'] = {
            'python': {'executable': sys.executable, 'version': sys.version, 'sha256': digest(sys.executable)},
            'pyslang': {'path': str(INSTALL), 'version': s.__version__, 'lock_sha256': digest(LOCK),
                        'receipt_sha256': digest(receipt), 'installed_files_rehashed': True}}
        source = folder / 'DeadRuntimeMultiply.sv'
        source.write_text(DEAD_RUNTIME_MULTIPLY + '\n', encoding='utf-8')
        result = check_dead_runtime_multiply(source)
        write(folder / 'rejection.json', result)
        checks = [result]

        # Reproduce the former false PASS: it has a location, but only syntax errors.
        ambiguous = folder / 'FormerAmbiguousMultiply.sv'
        ambiguous.write_text("module T(input a,b,output [1:0] y);wire [1:0] n=1'b0?(a*b):a;assign y=n;endmodule\n", encoding='utf-8')
        try:
            parse(ambiguous, 'T')
        except (ValueError, RuntimeError) as exc:
            old_diagnostic = str(exc)
        else:
            raise AssertionError('Former ambiguous source unexpectedly accepted')
        try:
            check_dead_runtime_multiply(ambiguous)
        except AssertionError as exc:
            if 'fixture has syntax errors:' not in str(exc):
                raise
            checks.append({'case': 'MalformedFixtureCannotPass', 'status': 'PASS',
                           'frontend_diagnostic': old_diagnostic, 'guard_diagnostic': str(exc)})
        else:
            raise AssertionError('Malformed fixture satisfied the negative-test contract')

        location = result['location']
        prefix = f'{source}:{location["line"]}:{location["column"]}: '
        for name, diagnostic in [
            ('SyntaxErrorCannotPass', prefix + "error: expected ';'"),
            ('OtherOperationCannotPass', prefix + 'unsupported hardware syntax (DivideExpression)'),
            ('WrongSourceCannotPass', result['diagnostic'].replace(str(source), str(ambiguous))),
            ('WrongLocationCannotPass', f'{source}:{location["line"]}:{location["column"]+1}: unsupported hardware syntax (MultiplyExpression)')]:
            try:
                require_multiply_diagnostic(source, location, diagnostic)
            except AssertionError as exc:
                checks.append({'case': name, 'status': 'PASS', 'injected_diagnostic': diagnostic,
                               'guard_diagnostic': str(exc)})
            else:
                raise AssertionError('Unrelated diagnostic passed: ' + name)

        control = folder / 'SupportedDeadBranch.sv'
        control.write_text(DEAD_RUNTIME_MULTIPLY.replace('a * b', 'a | b') + '\n', encoding='utf-8')
        ir = parse(control, 'T')
        checks.append({'case': 'SupportedDeadBranch', 'status': 'PASS', 'format': ir['format'],
                       'source_sha256': digest(control)})
        report.update(status='PASS', checks=checks, check_count=len(checks))
    except Exception:
        report.update(status='FAIL', error=traceback.format_exc())
    finally:
        report['artifact_sha256'] = {p.relative_to(folder).as_posix(): digest(p) for p in folder.rglob('*')
                                    if p.is_file() and p.name != 'summary.json'}
        write(folder / 'summary.json', report)
    return report


def main():
    sys.stdout.reconfigure(encoding='utf-8')
    sys.stderr.reconfigure(encoding='utf-8')
    os.environ['PYTHONIOENCODING'] = 'utf-8'
    os.environ['PYTHONUTF8'] = '1'
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--evidence', type=Path, default=ROOT / 'experiments/fourstate/xiangshan-alu')
    parser.add_argument('--check-dead-runtime-multiply', action='store_true',
                        help='Only check the dead multiplication rejection and diagnostic guards')
    args = parser.parse_args()
    run_id = dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ') + '-' + uuid.uuid4().hex[:8]
    folder = fresh_directory(args.evidence / run_id)
    report = multiply_campaign(folder) if args.check_dead_runtime_multiply else campaign(folder)
    print(folder / 'summary.json', report['status'], flush=True)
    if report['status'] != 'PASS':
        print(report['error'], file=sys.stderr)
        raise SystemExit(1)


def faults(folder, mapping, trace, original, lean):
    checks = []
    port = next(p for p in mapping['ports'] if p['name'] == 'io_result')
    # Restrict recompilation size, but keep actual original/Lean expectations for these exact samples.
    indices = list(range(16000, 17024)) + list(range(len(trace)-3, len(trace)))
    rows = [trace[i] for i in indices]
    raw = (folder / 'converted/encoded.sv').read_text(encoding='utf-8')
    for name in ('EraseUnknownTag', 'SwapXZ'):
        key = port['tag'] if name == 'EraseUnknownTag' else port['value']
        pattern = r'assign ' + re.escape(key) + r' = ([^;]+);'
        match = re.search(pattern, raw)
        if match is None:
            raise AssertionError('ALU fault output assignment missing')
        before = match[0]
        after = f"assign {key} = 64'b0;" if name == 'EraseUnknownTag' else f"assign {key} = ({match[1]}) ^ {port['tag']};"
        altered, count = re.subn(pattern, lambda _: after, raw)
        if count != 1:
            raise AssertionError('ALU fault mutation ambiguous')
        case = folder / 'faults' / name
        case.mkdir(parents=True)
        source = case / 'mutated.sv'
        source.write_text(altered, encoding='utf-8')
        write(case / 'trace.json', rows)
        actual = run_rtl(source, mapping, rows, case / 'execution', True)
        difference = None
        for i, rails in enumerate(actual):
            values = decode(mapping, rails)
            if values != original[indices[i]]:
                output = next(k for k in values if values[k] != original[indices[i]][k])
                difference = {'sample': indices[i], 'fault_sample': i, 'output': output,
                              'expected': original[indices[i]][output], 'actual': values[output]}
                break
        if difference is None:
            raise AssertionError('Executed ALU semantic fault not detected: ' + name)
        compare_failed = False
        try:
            compare(mapping, [original[i] for i in indices], actual, [lean[i]['outputs'] for i in indices])
        except ValueError:
            compare_failed = True
        if not compare_failed:
            raise AssertionError('Three-way comparator failed to detect mutation')
        record = {'case': name, 'status': 'PASS', 'mutation': {'before': before, 'after': after},
                  'source_sha256': digest(source), 'first_difference': difference}
        write(case / 'result.json', record)
        checks.append(record)
    return checks


if __name__ == '__main__':
    main()
