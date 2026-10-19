"""Compare full native reference observations and render typed diagnostic ABI.

Renderer uses the same existing ModelSim as the unchanged RTL. It is an external
literal-only bench, preserving native integral width, signedness and padding.
"""
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

from pathlib import Path
import argparse
import collections
import gzip
import json
import shutil
from fourstate_machine_compare import diagnostics
from fourstate_scalable_bench import compare_streams,decode
from fourstate_eventful_bench import compare_activations
from fourstate_extended_bench import native_diagnostics,encoded_diagnostics
from verify_fourstate_f57_native import command


def compare_native_diagnostics(mapping,abi,console,out,tools):
    """Render the exact compared typed payloads in the original reference tool."""
    native,initial=native_diagnostics(console,mapping)
    lines=['module tb;initial begin']
    for sample,site,pid,ordinal in sorted(abi['events'],key=lambda r:(r[0],r[2],r[3],r[1])):
        diagnostic=mapping['assertions'][site];values=[]
        for j,arg in enumerate(diagnostic['arguments']):
            bits=decode(abi['arguments'][(sample,site,ordinal,j)])
            literal=str(arg['width'])+"'b"+bits
            values.append('$signed('+literal+')' if arg['signed'] else literal)
        lines.append(f'$display("F56_BEGIN {sample} {site}");$write('+','.join([json.dumps(diagnostic['message']),*values])+');$display("\\nF56_END");')
    lines+=['$finish;end endmodule'];(out/'tb.sv').write_text('\n'.join(lines)+'\n')
    for label,args in [('vlib',[tools/'vlib.exe','work']),('vlog',[tools/'vlog.exe','-sv','-work','work',out/'tb.sv']),('execute',[tools/'vsim.exe','-c','-onfinish','stop','-lib','work','tb','-do','run -all; quit -f'])]:
        execution=command(out,label,args)
        if execution['exit_code']:raise ValueError('Native diagnostic renderer failed')
    with (out/'execute/stdout.log').open('rb') as src,gzip.open(out/'rendered.log.gz','wb') as dst:shutil.copyfileobj(src,dst)
    rendered=encoded_diagnostics(out/'rendered.log.gz',mapping)
    def grouped(rows):
        groups=collections.defaultdict(list)
        for r in rows:groups[r['sample'],r['process'],r['severity']].append(r)
        return dict(groups)
    if grouped(native)!=grouped(rendered):raise ValueError('Exact native diagnostic events/text differ')
    return dict(status='EXACT_NATIVE_DIAGNOSTICS_PASS',events=len(native),initial_events_excluded=initial,typed_arguments=len(abi['arguments']))


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--mapping',type=Path,required=True)
    p.add_argument('--trace',type=Path,required=True)
    p.add_argument('--original',type=Path,required=True)
    p.add_argument('--console',type=Path,required=True)
    p.add_argument('--encoded',type=Path,required=True)
    p.add_argument('--out',type=Path,required=True)
    p.add_argument('--tools',type=Path,default=Path('E:/quartus/modelsim_ase/win32aloem'))
    a=p.parse_args();out=a.out.absolute();out.mkdir()
    with gzip.open(a.mapping,'rt') as f:mapping=json.load(f)
    trace=json.loads(a.trace.read_bytes())
    result=compare_streams(a.original,a.encoded,dict(mapping,assertions=[]),len(trace))
    (out/'snapshots.json').write_text(json.dumps(result,indent=2))
    result['activations']=compare_activations(a.original,a.encoded)
    (out/'activations.json').write_text(json.dumps(result['activations'],indent=2))
    abi=diagnostics(a.encoded,mapping)
    if len(abi['flags'])!=len(trace)*len(mapping['assertions']):raise ValueError('Missing full diagnostic flags')
    result['diagnostics']=compare_native_diagnostics(mapping,abi,a.console,out,a.tools)
    result['status']='WHOLE_RAW_ENCODED_FINITE_PASS'
    (out/'summary.json').write_text(json.dumps(result,indent=2))


if __name__=='__main__':main()
