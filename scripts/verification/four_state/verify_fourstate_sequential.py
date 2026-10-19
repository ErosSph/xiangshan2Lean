"""Three-way sequential four-state verification with independent Icarus state drivers."""
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
import datetime as dt
import itertools
import json
from pathlib import Path
import random
import re
import shutil
import sys
import traceback
import uuid

from common import ROOT, run_logged
from fourstate2lean import translate, write, digest, provenance, fresh_directory
from fourstate_frontend import parse
from fourstate_encode import encode
from fourstate_simulate import load, simulate, decode
from fourstate_sequential import validate, state_ports
from verify_fourstate import expect_failure, tools_record
from yosys2lean import translate_yosys
from yosys_simulate import simulate_yosys, experiment_initial

SEED = 410162


def build_deposit(folder):
    folder.mkdir(parents=True)
    prefix = Path(shutil.which('iverilog')).resolve().parent.parent
    compiler = ROOT / '.tools/w64devkit/bin/gcc.exe'
    if not compiler.is_file():
        raise RuntimeError('Project-local w64devkit GCC required for four-state VPI deposit')
    source = ROOT / 'verification/fourstate/deposit4.c'
    plugin = folder / 'deposit4.vpi'
    cmd = [str(compiler), '-shared', '-O2', '-Wall', '-Wextra', '-Werror',
           '-I'+str(prefix/'include/iverilog'), str(source), '-L'+str(prefix/'lib'), '-lvpi', '-o', str(plugin)]
    if run_logged(cmd, folder/'build', echo=False):
        raise RuntimeError('VPI deposit build failed')
    write(folder/'manifest.json', {'source_sha256':digest(source),'plugin_sha256':digest(plugin),
          'compiler':str(compiler),'compiler_sha256':digest(compiler),
          'vpi_header_sha256':digest(prefix/'include/iverilog/vpi_user.h'),
          'vpi_library_sha256':digest(prefix/'lib/libvpi.a')})
    return plugin


def run_rtl(source, mapping, trace, initial, folder, encoded=False, fault=None, *, deposit_initial=True):
    encoded_trace, encoded_initial = validate(mapping, trace, initial)
    folder.mkdir(parents=True)
    lines = ['module tb;']
    connections, input_local, output_observe, state_observe = [], {}, [], []
    number = 0

    def declare(name, width, direction, left=None, right=None):
        nonlocal number
        local = 'p' + str(number); number += 1
        left, right = (width - 1, 0) if left is None else (left, right)
        lines.append(f'{"reg" if direction == "input" else "wire"} [{left}:{right}] {local};')
        connections.append(f'.{name}({local})')
        return local

    next_local, current_local = {}, {}
    for p in mapping['ports']:
        if encoded and p.get('role') == 'clock':
            continue
        for key in ('tag', 'value') if encoded else ('name',):
            local = declare(p[key], p['width'], p['direction'], None if encoded else p['left'], None if encoded else p['right'])
            if p['direction'] == 'input':
                input_local[p[key]] = local
            else:
                output_observe.append((p[key], local, p['width']))
    for p in mapping['states']:
        if encoded:
            for rail in ('tag', 'value'):
                cur, nxt = p['current_' + rail], p['next_' + rail]
                current_local[cur] = declare(cur, p['width'], 'input')
                next_local[cur] = declare(nxt, p['width'], 'output')
                state_observe.append((cur, current_local[cur], p['width']))
        else:
            state_observe.append((p['name'], 'dut.' + p.get('rtl_path', p['name']), p['width']))
    top = mapping['encoded_top'] if encoded else mapping['top']
    lines.append(f'{top} dut(' + ', '.join(connections) + ');')
    lines.append('initial begin')
    if encoded:
        for name, local in current_local.items():
            width = next(w for n, _, w in state_observe if n == name)
            lines.append(f"{local} = {width}'d{encoded_initial[name]};")
    else:
        lines.append(f"{input_local[mapping['clock']]} = 1'b0;")
        # Let time-zero initialization settle, then deposit once without a force.
        for p in mapping['ports']:
            if p['direction'] == 'input' and p.get('role') != 'clock':
                lines.append(f"{input_local[p['name']]} = {p['width']}'b{trace[0]['inputs'][p['name']]};")
        lines.append('#1;')
        if not deposit_initial and any(set(v)-{'x'} for v in initial.values()):
            raise ValueError('Natural uninitialized reference requires an explicit all-X expected initial state')
        if deposit_initial:
            for p in mapping['states']:
                lines.append(f"$fourstate_deposit(dut.{p.get('rtl_path', p['name'])}, {p['width']}'b{initial[p['name']]});")
    lines.append('#1;')
    observe = output_observe + state_observe

    def display(i, phase):
        return '$display("' + f'{i} {phase} ' + ' '.join('%b' for _ in observe) + '", ' + ', '.join(p[1] for p in observe) + ');'

    previous = 0
    for i, row in enumerate(trace):
        clock = int(row['inputs'][mapping['clock']])
        values = encoded_trace[i]['inputs'] if encoded else row['inputs']
        for p in mapping['ports']:
            if p['direction'] != 'input' or p.get('role') == 'clock':
                continue
            for key in ('tag', 'value') if encoded else ('name',):
                value = format(values[p[key]], f"0{p['width']}b") if encoded else values[p[key]]
                lines.append(f"{input_local[p[key]]} = {p['width']}'b{value};")
        lines += ['#1;', display(i, 'pre')]
        if encoded:
            if previous == 0 and clock == 1:
                if fault == 'update-order':
                    # Intentionally settle after each register instead of simultaneous commit.
                    for p in mapping['states']:
                        cs = [current_local[p['current_' + rail]] for rail in ('tag', 'value')]
                        ns = [next_local[p['current_' + rail]] for rail in ('tag', 'value')]
                        lines.append('{' + ','.join(cs) + '} = {' + ','.join(ns) + '}; #1;')
                else:
                    lines.append('{' + ','.join(current_local.values()) + '} = {' + ','.join(next_local.values()) + '};')
        else:
            lines.append(f"{input_local[mapping['clock']]} = 1'b{clock};")
        lines += ['#1;', display(i, 'post')]
        previous = clock
    lines += ['$finish;', 'end', 'endmodule']
    bench = folder / 'tb.sv'; bench.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    image = folder / 'sim.vvp'
    from fourstate_elaborated import source_files
    if run_logged([shutil.which('iverilog'), '-g2012', '-s', 'tb', '-o', str(image),
                   *[str(p) for p in source_files(source)], str(bench)], folder / 'compile', echo=False):
        raise RuntimeError('Sequential Icarus compilation failed: ' + str(folder))
    plugin = build_deposit(folder/'deposit') if not encoded else None
    command = [shutil.which('vvp')] + (['-M', str(plugin.parent), '-m', plugin.stem] if plugin else []) + [str(image)]
    if run_logged(command, folder / 'execute', echo=False):
        raise RuntimeError('Sequential Icarus execution failed: ' + str(folder))
    raw = []
    for line in (folder / 'execute/stdout.log').read_text().splitlines():
        if '$finish called at' in line:
            continue
        fields = line.split()
        i, phase = len(raw) // 2, ('pre' if len(raw) % 2 == 0 else 'post')
        if len(fields) != len(observe) + 2 or fields[:2] != [str(i), phase]:
            raise ValueError('Malformed sequential RTL result: ' + line)
        values = []
        for (_, _, width), bits in zip(observe, fields[2:]):
            if len(bits) != width or any(c not in ('01' if encoded else '01xz') for c in bits):
                raise ValueError('Invalid four-state result or unknown encoded rail: ' + bits)
            values.append(int(bits, 2) if encoded else bits)
        raw.append({'outputs': dict(zip((x[0] for x in output_observe), values[:len(output_observe)])),
                    'states': dict(zip((x[0] for x in state_observe), values[len(output_observe):]))})
    if len(raw) != 2 * len(trace):
        raise ValueError('Incomplete sequential RTL trace')
    write(folder / 'encoded-result.json' if encoded else folder / 'raw-result.json', raw)
    result = []
    for i, row in enumerate(trace):
        clock = int(row['inputs'][mapping['clock']])
        rising = i > 0 and trace[i-1]['inputs'][mapping['clock']] == '0' and clock == 1
        record = {'sample': i, 'clock': clock, 'rising': rising}
        for j, phase in enumerate(('pre', 'post')):
            r = raw[2*i+j]
            record[phase] = {'outputs': decode(mapping, r['outputs']),
                             'states': decode({'ports': state_ports(mapping)}, r['states'])} if encoded else r
        result.append(record)
    write(folder / 'result.json', result)
    return result


def compare(original, encoded, lean):
    if not original or len(original) != len(encoded) or len(original) != len(lean):
        raise ValueError('Sequential trace length mismatch')
    for i, (a, b, c) in enumerate(zip(original, encoded, lean)):
        if a != b or a != c:
            raise ValueError(f'Sequential mismatch at sample {i}: original={a}, encoded={b}, lean={c}')


def rejection_sources():
    head = 'module T(input clk,reset,en,d,clk2,output logic q); '
    wrap = lambda body: head + body + ' endmodule'
    return {
        'AsyncReset': wrap("always @(posedge clk or posedge reset) if(reset) q<=1'b0; else q<=d;"),
        'SecondClock': wrap('always @(posedge clk2) q<=d;'),
        'Negedge': wrap('always @(negedge clk) q<=d;'),
        'GatedClock': wrap('always @(posedge (clk & en)) q<=d;'),
        'ClockData': wrap('always @(posedge clk) q<=clk;'),
        'Blocking': wrap('always @(posedge clk) q=d;'),
        'LocalDeclaration': wrap('always @(posedge clk) begin logic n; q<=d; end'),
        'Loop': wrap('always @(posedge clk) repeat(2) q<=d;'),
        'Case': wrap("always @(posedge clk) case(en) 1'b0:q<=d; default:q<=1'b0;endcase"),
        'Delay': wrap('always @(posedge clk) q<=#1 d;'),
        'Initial': wrap("initial q=1'b0; always @(posedge clk) q<=d;"),
        'PartialLvalue': wrap('always @(posedge clk) q[0]<=d;'),
        'MixedDrivers': wrap('assign q=d; always @(posedge clk) q<=en;'),
        'MultiProcess': wrap('always @(posedge clk) q<=d; always @(posedge clk) q<=en;'),
        'Initialization': 'module T(input clk,d,output logic q=0); always @(posedge clk) q<=d; endmodule',
        'Memory': wrap('logic m[0:1]; always @(posedge clk) begin m[0]<=d;q<=m[0];end'),
        'Hierarchy': wrap('T child(); always @(posedge clk) q<=d;'),
        'WideIf': 'module T(input clk,input [1:0] d,output logic q);always @(posedge clk) if(d)q<=1\'b0;endmodule',
        'WideClock': 'module T(input [1:0] clk,input d,output logic q);always @(posedge clk)q<=d;endmodule',
        'CombinationalCycle': wrap('wire a,b;assign a=b;assign b=a;always @(posedge clk)q<=a;'),
        'StateNameCollision': wrap('wire q__state_tag; assign q__state_tag=d; always @(posedge clk)q<=d;'),
        'DeadBlocking': wrap("always @(posedge clk) if(1'b0) q=d; else q<=en;"),
    }


def sampled(values, clock='clk'):
    rows = []
    for value in values:
        # Fall with old data, change data at low level, then edge after a stable sample.
        previous = {k:v for k,v in rows[-1]['inputs'].items() if k != clock} if rows else value
        rows.append({'inputs': {**previous, clock:'0'}})
        rows.extend({'inputs': {**value, clock:c}} for c in ('0','0','1','1'))
        reset = 'reset' if 'reset' in value else 'reset_n'
        changed = {**value, reset:dict(zip('01xz','10zx'))[value[reset]]}
        rows.extend([{'inputs':{**changed,clock:'1'}},{'inputs':{**value,clock:'1'}}])
    return rows


def campaign(folder):
    report = {'status': 'RUNNING', 'seed': SEED, 'cases': [], 'rejections': [], 'fault_checks': [],
              'scope': 'Single binary posedge clock, explicit initial state, finite sampled four-state transition tests.'}
    write(folder / 'summary.json', report)
    try:
        report['tools'] = tools_record(folder / 'tools')
        report['source_snapshot_sha256'] = provenance(folder)
        for name, text in rejection_sources().items():
            src = folder / 'rejections' / (name + '.sv'); src.parent.mkdir(exist_ok=True)
            src.write_text(text, encoding='utf-8')
            expect_failure(name, lambda: encode(parse(src, 'T', 'sequential', 'clk')), report['rejections'])
            if str(src) not in report['rejections'][-1]['diagnostic']:
                raise AssertionError('Missing source location: ' + name)
        rng = random.Random(SEED)
        controls = [dict(zip(('reset','en','d'), x)) for x in itertools.product('01xz', repeat=3)]
        wide = [{key: ''.join(rng.choice('01xz') for _ in range(w)) for key, w in [('reset_n',1),('en',1),('d4',4),('d65',65)]} for _ in range(192)]
        swap = [dict(reset='0',en='1'), dict(reset='x',en='z'),dict(reset='1',en='1'),dict(reset='0',en='1')] * 8
        scenarios = [
            ('SequentialControl', 'initial-'+v, sampled(controls), {n:v for n in ('q','stage','chosen','priority_q','hidden')}) for v in '01xz']
        scenarios += [('SequentialWide', 'random', sampled(wide), {'q4':'xz10','q65':'1'+'xz'*32,'stage65':'z'+'01'*32}),
                      ('SequentialSwap', 'swap', sampled(swap), {'a':'x','b':'z'}),
                      ('SequentialControl', 'known', sampled([dict(zip(('reset','en','d'),x)) for x in itertools.product('01',repeat=3)]*4),
                       {n:'0' for n in ('q','stage','chosen','priority_q','hidden')})]
        manifests = {}
        for top, name, trace, initial in scenarios:
            print('Validating', top, name, flush=True)
            source = ROOT / 'verification/fourstate' / (top+'.sv')
            if top not in manifests:
                manifests[top] = translate(source, top, folder / top / 'translation', 'sequential', 'clk')
            manifest = manifests[top]
            mapping, _ = load(manifest)
            case = folder / top / name; case.mkdir(parents=True)
            write(case / 'initial.json', initial)
            (case / 'trace.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in trace), encoding='utf-8')
            original = run_rtl(source, mapping, trace, initial, case/'original')
            encoded = run_rtl(manifest.parent/'encoded.sv', mapping, trace, initial, case/'encoded', True)
            lean = simulate(manifest, trace, case/'lean', initial)
            compare(original, encoded, lean)
            result = {'name': top+'/'+name, 'status':'PASS','samples':len(trace),
                'output_bits':2*len(trace)*sum(p['width'] for p in mapping['ports'] if p['direction']=='output'),
                'state_bits':2*len(trace)*sum(p['width'] for p in mapping['states']),
                'manifest': str(manifest.relative_to(folder)), 'manifest_sha256':digest(manifest)}
            report['cases'].append(result)
            if name == 'known':
                relative = translate_yosys(source,case/'two-state-model',top,namespace='FourState.KnownSequential',
                    evidence=case/'two-state-translation',yosys_engine='native',lean_backend='source',clock_mode='global')
                ir_path=case/'two-state-model'/relative
                ir=json.loads(ir_path.read_text())
                baseline_initial=experiment_initial(ir)
                write(case/'two-state-initial.json',baseline_initial)
                for choice in (0,1):
                    extra={p['name']:((1<<p['width'])-1)*choice for p in ir['arbitrary_inputs']}
                    code,baseline=simulate_yosys(ir_path,[{'inputs':{**{k:int(v) for k,v in r['inputs'].items()},**extra}} for r in trace],
                        baseline_initial,case/('two-state-run-'+str(choice)))
                    if code or len(baseline)!=len(original):
                        raise ValueError('Known-value sequential baseline failed')
                    for i,(a,b) in enumerate(zip(original,baseline)):
                        if {k:str(v) for k,v in b['post'].items()} != a['post']['outputs']:
                            raise ValueError('Two-state sequential mismatch at sample '+str(i))
                report['two_state_compatibility']={'status':'PASS','samples':len(trace),
                    'arbitrary_inputs':ir['arbitrary_inputs'],'arbitrary_choices':[0,1],
                    'initialization':'Original registers explicitly zero; Yosys unknown auxiliary bits zero, known-bit constraints retained. Exposed two-state arbitrary inputs tested at both all-zero and all-one choices.'}
            if top == 'SequentialControl' and name == 'initial-x':
                for label, bad_trace, bad_initial in [
                    ('MissingInitial',trace,None),('MissingRegister',trace,{'q':'x'}),
                    ('ExtraRegister',trace,{**initial,'extra':'0'}),('WrongInitialWidth',trace,{**initial,'q':'xx'}),
                    ('InvalidInitial',trace,{**initial,'q':'?'}),
                    ('XClock',[{'inputs':{**trace[0]['inputs'],'clk':'x'}}],initial),
                    ('ZClock',[{'inputs':{**trace[0]['inputs'],'clk':'z'}}],initial),
                    ('FirstHigh',[{'inputs':{**trace[0]['inputs'],'clk':'1'}}],initial),
                    ('UnstableEdge',[trace[0],{'inputs':{**trace[0]['inputs'],'clk':'1','d':'z'}}],initial)]:
                    expect_failure(label,lambda: validate(mapping,bad_trace,bad_initial),report['fault_checks'])
                mutated = run_rtl(manifest.parent/'encoded.sv',mapping,trace,initial,case/'fault-order',True,'update-order')
                expect_failure('NonSimultaneousUpdate',lambda: compare(original,mutated,lean),report['fault_checks'])
                text = (manifest.parent/'encoded.sv').read_text()
                # Wrong procedural if: treat an unknown condition as true.
                changed, count = re.subn(r'\(~(c2l4_n\w+_t) & (c2l4_n\w+_v)\) \?',r'(\1 | \2) ?',text)
                if not count: raise AssertionError('No procedural mux mutation target')
                faulty = case/'fault-if.sv'; faulty.write_text(changed)
                mutated = run_rtl(faulty,mapping,trace,initial,case/'fault-if',True)
                expect_failure('UnknownIfIsTrue',lambda: compare(original,mutated,lean),report['fault_checks'])
                changed=text
                for p in mapping['states']:
                    changed,n = re.subn(r'assign '+re.escape(p['next_value'])+r' = ([^;]+);',
                        lambda m:'assign '+p['next_value']+' = ('+m[1]+') ^ '+p['next_tag']+';',changed)
                    if n!=1:raise AssertionError('No state mutation target')
                faulty=case/'fault-xz.sv';faulty.write_text(changed)
                mutated=run_rtl(faulty,mapping,trace,initial,case/'fault-xz',True)
                expect_failure('SwapStateXZ',lambda:compare(original,mutated,lean),report['fault_checks'])
            write(folder/'summary.json',report)
        report['status']='PASS'
    except Exception:
        report['status']='FAIL';report['error']=traceback.format_exc();raise
    finally:
        report['artifact_sha256']={p.relative_to(folder).as_posix():digest(p) for p in folder.rglob('*') if p.is_file() and p != folder/'summary.json'}
        write(folder/'summary.json',report)
    return report


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--evidence',type=Path,default=ROOT/'experiments/fourstate/sequential')
    a=p.parse_args()
    run=dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ')+'-'+uuid.uuid4().hex[:8]
    folder=fresh_directory(a.evidence/run)
    print('Evidence:',folder,flush=True)
    report=campaign(folder)
    print(json.dumps({k:report[k] for k in ('status','cases')},indent=2))


if __name__=='__main__':
    main()
