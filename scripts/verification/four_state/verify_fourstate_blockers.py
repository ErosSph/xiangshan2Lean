"""F3.2.2 bounded CAMTemplate / LevelGateway blocker reproduction.

This harness never changes frontend semantics. Default server calls acquire
pinned inputs or archive data. An explicit reviewed F4.5 helper additionally
runs the resource-bounded Linux RAM replay in the Guard-owned workspace.
"""
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
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import traceback
import uuid

ROOT=_PROJECT_ROOT
FIXTURES={
    'CamLocalElab':'PROCESS_SCOPE',
    'CamLocalFlat':'PROCEDURAL_BLOCKING',
    'LocalDeclOnly':'PROCESS_LOCAL_DECLARATION',
    'BlockingOnly':'PROCEDURAL_BLOCKING',
    'MacroGuard':'PREPROCESSOR',
    'AsyncFlat':'ASYNC_MULTI_EVENT',
    'AsyncElab':'ASYNC_MULTI_EVENT',
}
CONTROLS=('SingleClockControl','NetAliasClockControl')


def remote_call(folder,request,*,entry='verify_fourstate_blockers_remote'):
    import fourstate_sync as sync
    metadata=None
    if request.get('operation')=='archive':
        from fourstate_sync_common import INPUT_ARCHIVE_LIMIT, relative, checksum
        files=request['files']
        if not isinstance(files,list) or not 1<=len(files)<=100:raise ValueError('invalid file whitelist')
        metadata=[];total=0
        for row in files:
            relative(row['path']);checksum(row['sha256']);value=row['base64']
            if not isinstance(value,str) or len(value)%4:raise ValueError('invalid base64 payload length')
            size=len(value)//4*3-(len(value)-len(value.rstrip('=')))
            if size<0:raise ValueError('invalid base64 payload size')
            total+=size
            if not request.get('unrestricted') and total>INPUT_ARCHIVE_LIMIT:raise ValueError('128 MiB archive budget exceeded before transfer')
            metadata.append(dict(path=row['path'],bytes=size,sha256=row['sha256']))
        ready=remote_call(folder,dict(operation='archive-preflight',run_id=request['run_id'],
                          snapshot_id=request['snapshot_id'],version=request['version'],files=metadata,
                          **({'unrestricted':True} if request.get('unrestricted') else {})),entry=entry)
        if ready.get('status')!='ARCHIVE_READY' or ready.get('bytes')!=total or ready.get('files')!=metadata:
            raise ValueError('archive space/manifest preflight mismatch')
    names=['fourstate_sync_common','fourstate_sync_remote','audit_fourstate_remote',
           'verify_fourstate_prioritymux_remote','verify_fourstate_blockers_remote']
    if entry=='audit_fourstate_batch_remote':
        names=['fourstate_sync_common','fourstate_sync_remote','audit_fourstate_remote',
               'audit_fourstate_server','audit_fourstate_batch_remote']
    elif entry=='verify_fourstate_memory_remote':
        names=['fourstate_sync_common','fourstate_sync_remote','audit_fourstate_remote',
               'audit_fourstate_server','verify_fourstate_memory_remote']
    elif entry=='verify_fourstate_clocks_remote':
        names=['fourstate_sync_common','fourstate_sync_remote','audit_fourstate_remote',
               'audit_fourstate_server','verify_fourstate_prioritymux_remote','fourstate_assertions','fourstate_bounded_events',
               'verify_fourstate_clocks','verify_fourstate_clocks_remote','verify_fourstate_clocks_regression']
        names.append('verify_fourstate_conditional_compare')
    elif entry!='verify_fourstate_blockers_remote':
        raise ValueError('unreviewed remote data helper')
    code='import sys,types\n';hashes={}
    for name in names:
        source_path=ROOT/'scripts/verification/four_state'/(name+'.py')
        if not source_path.is_file():
            source_path=ROOT/'scripts'/(name+'.py')
        source=source_path.read_text(encoding='utf-8');hashes[name]=hashlib.sha256(source.encode()).hexdigest()
        code+='m=types.ModuleType('+repr(name)+');sys.modules['+repr(name)+']=m\nexec('+ascii(source)+',m.__dict__)\n'
    code+='sys.modules['+repr(entry)+'].main('+ascii(request)+')\n'
    log=Path(folder)/('remote-'+request['operation']+'-'+uuid.uuid4().hex[:8]);log.mkdir()
    (log/'stdin.py').write_bytes(code.encode('ascii'))
    command=['ssh.exe','-T','-a','-x',*sync.OPTIONS,'amax','/usr/bin/python3 -I -B -S -']
    result=subprocess.run(command,input=code.encode('ascii'),capture_output=True,
                          timeout=None if request.get('unrestricted') else (240 if entry in ('verify_fourstate_memory_remote','verify_fourstate_clocks_remote') else 120))
    (log/'stdout.json').write_bytes(result.stdout);(log/'stderr.log').write_bytes(result.stderr)
    (log/'command.json').write_text(json.dumps(dict(command=command,exit_code=result.returncode,worker_sha256=hashes),indent=2),encoding='utf-8')
    if result.returncode:raise RuntimeError('remote data operation failed: '+str(log))
    value=json.loads(result.stdout)
    if metadata is not None:
        expected=[dict(row,path='reports/'+request['version']+'/'+row['path']) for row in metadata]
        if (value.get('status')!='ARCHIVED' or value.get('verification')!='SHA256_READBACK_MATCH' or
                value.get('files')!=expected or value.get('bytes')!=sum(r['bytes'] for r in metadata) or
                value.get('manifest_sha256')!=ready['manifest_sha256']):
            raise ValueError('archive post-transfer SHA256 receipt mismatch')
    return value


def diagnostic(stderr):
    matches=re.findall(r'^ValueError: (.+):(\d+):(\d+): (.+)$',stderr,re.M)
    if not matches:return dict(category='UNCLASSIFIED',raw=stderr)
    file,line,column,message=matches[-1];category='UNCLASSIFIED'
    if message=='unsupported active elaborated symbol (StatementBlock)':category='PROCESS_SCOPE'
    elif message=='unsupported preprocessor directive or macro':category='PREPROCESSOR'
    elif message.startswith('process-local declarations unsupported'):category='PROCESS_LOCAL_DECLARATION'
    elif message=='assignment expression outside continuous assignment (AssignmentExpression)':category='PROCEDURAL_BLOCKING'
    elif message.startswith('unsupported clocked statement') and '(ExpressionStatement)' in message:category='PROCEDURAL_BLOCKING'
    elif (message=='unsupported syntax (BinaryEventExpression)' or
          message.startswith('all processes must use the same direct posedge clock') or
          message.startswith('common direct posedge clock required; asynchronous/derived clocks unsupported')):category='ASYNC_MULTI_EVENT'
    return dict(category=category,file=file,line=int(line),column=int(column),message=message)


def inventory(source,top):
    """Official typed ports/state widths plus actual CST process facts, no conversion."""
    from bootstrap_fourstate import load_parser
    from audit_fourstate_syntax import preprocessing_facts
    s=load_parser();sm=s.SourceManager();tree=s.syntax.SyntaxTree.fromFile(str(source),sm)
    options=s.ast.CompilationOptions();options.topModules={top}
    compilation=s.ast.Compilation(s.Bag([options]));compilation.addSyntaxTree(tree)
    root=compilation.getRoot();diagnostics=compilation.getAllDiagnostics()
    if any(d.isError() for d in diagnostics):raise ValueError(s.DiagnosticEngine.reportAll(sm,diagnostics))
    if len(root.topInstances)!=1:raise ValueError('one root module required')
    instance=root.topInstances[0];kinds=Counter();nba=set();unresolved_nba=[];processes=[];dependencies=[]
    def kind(n):return str(n.kind).split('.')[-1]
    def loc(n):
        pos=n.sourceRange.start
        return dict(line=sm.getLineNumber(pos),column=sm.getColumnNumber(pos))
    def visit(n):
        if not isinstance(n,s.syntax.SyntaxNode):return
        key=kind(n);kinds[key]+=1
        if key=='NonblockingAssignmentExpression':
            # CST stringification includes leading source-map comments. Token
            # valueText identifies the actual target instead of those trivia.
            if kind(n.left)=='IdentifierName':nba.add(n.left.identifier.valueText)
            else:unresolved_nba.append(dict(source_text=str(n.left),**loc(n)))
        if key=='HierarchyInstantiation':dependencies.append(n.type.valueText)
        if key in ('AlwaysBlock','AlwaysFFBlock','InitialBlock'):
            events=[];locals_=[];assignments=Counter()
            def child(c):
                if not isinstance(c,s.syntax.SyntaxNode):return
                k=kind(c)
                if k=='SignalEventExpression':events.append(dict(edge=str(c.edge).strip(),expression=str(c.expr).strip(),**loc(c)))
                if k=='DataDeclaration':locals_.append(dict(source_text=str(c).strip(),**loc(c)))
                if k in ('AssignmentExpression','NonblockingAssignmentExpression'):assignments[k]+=1
            n.visit(child);processes.append(dict(kind=key,events=events,local_declarations=locals_,assignments=dict(assignments),**loc(n)))
    tree.root.visit(visit)
    ports=[dict(name=p.name,direction=str(p.direction).split('.')[-1],width=p.type.bitWidth,signed=bool(p.type.isSigned)) for p in instance.body.portList]
    variables=[dict(name=n.name,width=n.type.bitWidth,signed=bool(n.type.isSigned),unpacked=bool(n.type.isUnpackedArray),
                    nba_target=n.name in nba) for n in instance.body if kind(n)=='Variable']
    states=[n for n in variables if n['nba_target']]
    return dict(top=top,source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),ports=ports,
                inputs=len([p for p in ports if p['direction']=='In']),outputs=len([p for p in ports if p['direction']=='Out']),
                input_bits=sum(p['width'] for p in ports if p['direction']=='In'),output_bits=sum(p['width'] for p in ports if p['direction']=='Out'),
                states=states,state_bits=sum(n['width'] for n in states),module_variables=variables,
                unresolved_nba_targets=unresolved_nba,
                syntax=dict(kinds),processes=processes,dependencies=dependencies,parser_error_count=0,
                macro_profile='Official default, no added defines. Raw directive rejection occurs before this preprocessing in the converter.',
                preprocessing=preprocessing_facts(source.read_text(encoding='utf-8'),source.name))


def attempt(source,top,folder):
    from common import run_logged
    output=folder/'converted'
    command=[sys.executable,'-B',str(ROOT/'scripts/fourstate2lean.py'),str(source),'--top',top,
             '--mode','sequential','--clock','clock','--out',str(output)]
    code=run_logged(command,folder/'command',echo=False)
    stderr=(folder/'command/stderr.log').read_text(encoding='utf-8')
    result=dict(top=top,command=command,exit_code=code,diagnostic=diagnostic(stderr),
                source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
                encoded_rtl_created=(output/'encoded.sv').exists(),manifest_created=(output/'fourstate-manifest.json').exists(),
                conversion_status='COMPILED' if code==0 else 'REJECTED',semantic_verification='NOT_RUN')
    if code==0:raise RuntimeError('Unexpected real conversion success; stop blocker-only campaign and design module-specific validation: '+top)
    return result


def frontend_control(source,top,folder):
    from common import run_logged
    command=[sys.executable,'-B',str(Path(__file__).resolve()),'frontend','--source',str(source),'--top',top]
    code=run_logged(command,folder/'command',echo=False)
    if code:raise RuntimeError('positive frontend control failed: '+top)
    result=json.loads((folder/'command/stdout.log').read_text(encoding='utf-8'))
    return dict(top=top,exit_code=code,command=command,result=result,scope='Frontend IR only; no RTL encoding, Lean compilation or behavior validation.')


def campaign(inputs,out):
    from fourstate2lean import fresh_directory,write
    from verify_fourstate_blockers_remote import MODULES
    out=fresh_directory(out);receipts=json.loads((inputs/'input-receipts.json').read_text(encoding='utf-8'))
    report=dict(status='RUNNING',scope='Two raw real modules and small synthetic blocker/acceptance controls only; no new four-state semantics.',
                execution_location='Windows; server acquisition/archive only',modules=[],fixtures=[],controls=[],
                normalization_executed=False,semantic_verification='NOT_RUN',source_harness_sha256={})
    try:
        from bootstrap_fourstate import load_parser
        parser=load_parser()
        report['versions']=dict(python=sys.version,python_executable=sys.executable,
                                pyslang=parser.__version__,parser_module=parser.__file__)
        write(out/'source-receipts.json',receipts)
        for name in ('scripts/verification/four_state/verify_fourstate_blockers.py',
                     'scripts/verification/four_state/verify_fourstate_blockers_remote.py',
                     'scripts/fourstate_frontend.py','scripts/fourstate_elaborated.py',
                     'scripts/fourstate2lean.py','scripts/bootstrap_fourstate.py',
                     'scripts/verification/four_state/audit_fourstate_syntax.py',
                     'verification/fourstate/parser-lock.json'):
            target=out/'harness-source'/name;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes((ROOT/name).read_bytes())
            report['source_harness_sha256'][name]=hashlib.sha256(target.read_bytes()).hexdigest()
        sources=out/'inputs';sources.mkdir()
        for name,expected in MODULES.items():
            source=inputs/'source'/name;data=source.read_bytes();receipt=next(r for r in receipts['files'] if r['name']==name)
            if hashlib.sha256(data).hexdigest()!=expected or receipt['sha256']!=expected:raise ValueError('raw input hash mismatch')
            target=sources/name;target.write_bytes(data);top=target.stem
            inv=inventory(target,top);write(out/'inventory'/(top+'.json'),inv)
            if inv['state_bits']!={'CAMTemplate':72,'LevelGateway':1}[top] or inv['unresolved_nba_targets']:
                raise ValueError('real-module NBA state inventory mismatch: '+top)
            result=attempt(target,top,out/'attempts'/top)
            expected_category={'CAMTemplate':'PROCESS_SCOPE','LevelGateway':'PREPROCESSOR'}[top]
            if result['diagnostic']['category']!=expected_category:raise ValueError('first raw blocker changed: '+top)
            result['inventory']=inv;report['modules'].append(result)
        for top,expected in FIXTURES.items():
            original=ROOT/'verification/fourstate/blockers'/(top+'.sv')
            source=out/'fixture-inputs'/(top+'.sv');source.parent.mkdir(parents=True,exist_ok=True)
            source.write_bytes(original.read_bytes())
            inv=inventory(source,top);write(out/'fixture-inventory'/(top+'.json'),inv)
            result=attempt(source,top,out/'fixtures'/top)
            if result['diagnostic']['category']!=expected:raise ValueError('wrong blocker category: '+top)
            result['parser_error_count']=inv['parser_error_count'];report['fixtures'].append(result)
        for top in CONTROLS:
            original=ROOT/'verification/fourstate/blockers'/(top+'.sv')
            source=out/'fixture-inputs'/(top+'.sv');source.write_bytes(original.read_bytes());inventory(source,top)
            report['controls'].append(frontend_control(source,top,out/'controls'/top))
        report.update(status='BLOCKER_CHARACTERIZATION_COMPLETED',real_conversions=2,real_conversion_failures=2,
                      semantic_verified_modules=0,syntax_valid_blocker_fixtures=len(FIXTURES),frontend_only_positive_controls=len(CONTROLS))
    except Exception:report.update(status='HARNESS_FAIL',error=traceback.format_exc())
    write(out/'summary.json',report);return report


def main():
    p=argparse.ArgumentParser(description=__doc__);sub=p.add_subparsers(dest='action',required=True)
    front=sub.add_parser('frontend');front.add_argument('--source',type=Path,required=True);front.add_argument('--top',required=True)
    run=sub.add_parser('run');run.add_argument('--inputs',type=Path,required=True);run.add_argument('--out',type=Path,required=True)
    a=p.parse_args()
    if a.action=='frontend':
        from fourstate_frontend import parse
        ir=parse(a.source.resolve(),a.top,'sequential','clock')
        print(json.dumps(dict(status='FRONTEND_IR_ACCEPTED_ONLY',format=ir['format'],top=a.top,semantic_verified=False)))
        return 0
    report=campaign(a.inputs.resolve(),a.out)
    print(json.dumps(dict(status=report['status'],summary=str(a.out/'summary.json'),error=report.get('error')),ensure_ascii=True))
    return 0 if report['status']=='BLOCKER_CHARACTERIZATION_COMPLETED' else 1


if __name__=='__main__':raise SystemExit(main())
