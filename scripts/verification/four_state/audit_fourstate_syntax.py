"""Facts from official slang CST JSON, never keyword-derived semantic counts."""
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

from collections import Counter
import re


def walk(value):
    if isinstance(value,dict):
        yield value
        for child in value.values():yield from walk(child)
    elif isinstance(value,list):
        for child in value:yield from walk(child)


def mask(text):
    """Preserve offsets while masking comments/strings; used only for evidence anchors."""
    pattern=r'//[^\n]*|/\*.*?\*/|"(?:\\.|[^"\\])*"|\\[^\s]+'
    return re.sub(pattern,lambda m: ''.join('\n' if c=='\n' else ' ' for c in m.group()),text,flags=re.S)


def expression(n):
    if isinstance(n,str):return n
    if not isinstance(n,dict):return '?'
    if 'identifier' in n:return n['identifier']
    if 'literal' in n:return str(n['literal'])
    if n.get('kind')=='IntegerVectorExpression':return str(n.get('size',''))+str(n.get('base',''))+str(n.get('value',''))
    if 'left' in n:return '('+expression(n['left'])+str(n.get('operatorToken','?'))+expression(n.get('right'))+')'
    if 'operand' in n:return str(n.get('operatorToken',''))+expression(n['operand'])
    if 'expr' in n:return expression(n['expr'])
    return '?'+str(n.get('kind',''))


def unwrapped(node):
    while isinstance(node,dict) and node.get('kind') in ('SimplePropertyExpr','SimpleSequenceExpr','ParenthesizedExpression'):
        node=node.get('expr',{})
    return node if isinstance(node,dict) else {}


def identifiers(n):
    return {x['identifier'] for x in walk(n) if x.get('kind') in ('IdentifierName','IdentifierSelectName') and isinstance(x.get('identifier'),str)}


def facts(cst,source,file):
    result=[];masked=mask(source)
    for module in (x for x in walk(cst) if x.get('kind')=='ModuleDeclaration'):
        name=module['header']['name'];counts=Counter(x.get('kind') for x in walk(module))
        start=re.search(r'\bmodule\s+'+re.escape(name)+r'\b',masked)
        start=start.start() if start else 0
        end=masked.find('endmodule',start);end=len(masked) if end<0 else end
        def loc(word):
            match=re.search(r'(?<![A-Za-z0-9_$])'+re.escape(word)+r'(?![A-Za-z0-9_$])',masked[start:end])
            offset=start+(match.start() if match else 0)
            return dict(file=file,line=source.count('\n',0,offset)+1,anchor=word,
                        method='comment/string-filtered source anchor; counts come from CST')
        features=Counter();examples={};registers=set();memories={};processes=[];instances=[];ports=[];aliases=[];drivers=[];calls=Counter()
        def add(feature,count=1,anchor=None):
            features[feature]+=count
            if feature not in examples:examples[feature]=loc(anchor or name)
        portlist=module['header'].get('ports',{}).get('ports',[])
        direction='unknown'
        for port in portlist:
            if not isinstance(port,dict):continue
            header=port.get('header',{});direction=header.get('direction',direction)
            if port.get('declarator'):ports.append(dict(name=port['declarator']['name'],direction=direction))
        for decl in (x for x in walk(module) if x.get('kind') in ('DataDeclaration','NetDeclaration')):
            typ=decl.get('type',{});packed=len(typ.get('dimensions',[]))
            for declarator in decl.get('declarators',[]):
                if not isinstance(declarator,dict):continue
                dims=declarator.get('dimensions',[])
                if dims:
                    memories[declarator['name']]=dict(name=declarator['name'],unpacked_dimensions=len(dims),packed_dimensions=packed,source=loc(declarator['name']))
                    add('unpacked_array',anchor=declarator['name'])
                if packed>1:add('multidimensional_packed',anchor=declarator['name'])
                if declarator.get('initializer'):
                    add('net_initializer' if decl['kind']=='NetDeclaration' else 'declaration_initializer',anchor=declarator['name'])
                    value=declarator['initializer'].get('expr',{})
                    if decl['kind']=='NetDeclaration':
                        drivers.append(dict(target=declarator['name'],kind=value.get('kind'),identifiers=sorted(identifiers(value))))
                        if value.get('kind')=='IdentifierName':aliases.append(dict(target=declarator['name'],source=value['identifier'],kind=value['kind']))
            if typ.get('signedOrUnsigned')=='signed' or typ.get('signing')=='signed':add('signed_declaration')
        blocks={'AlwaysBlock':'always','AlwaysFFBlock':'always_ff','AlwaysCombBlock':'always_comb','AlwaysLatchBlock':'always_latch','InitialBlock':'initial','FinalBlock':'final'}
        for proc in (x for x in walk(module) if x.get('kind') in blocks):
            key=blocks[proc['kind']];add(key,anchor=key)
            events=[dict(edge=x.get('edge','level'),expr=expression(x.get('expr')),identifiers=sorted(identifiers(x.get('expr'))))
                    for x in walk(proc.get('statement')) if x.get('kind')=='SignalEventExpression']
            body=proc.get('statement',{})
            while body.get('kind')=='TimingControlStatement':body=body.get('statement',{})
            top_statements=body.get('items',[]) if body.get('kind')=='SequentialBlockStatement' else [body]
            conditions=[s.get('predicate',{}) for s in top_statements if isinstance(s,dict) and s.get('kind')=='ConditionalStatement']
            cond_ids=set().union(*(identifiers(c) for c in conditions))
            reset_events=[e for e in events if len(e['identifiers'])==1 and set(e['identifiers'])<=cond_ids]
            clock_events=[e for e in events if e not in reset_events] if len(events)>1 and reset_events else events
            assigned=[]
            for assignment in (x for x in walk(proc) if x.get('kind')=='NonblockingAssignmentExpression'):
                target=assignment.get('left',{});dest=target.get('identifier')
                if dest:
                    assigned.append(dest)
                    if dest not in memories and target.get('kind')=='IdentifierName':registers.add(dest)
                    if dest in memories:add('memory_write',anchor=dest)
                if target.get('kind')!='IdentifierName':add('partial_or_array_procedural_target',anchor=dest or key)
            if len(events)>1:
                add('multi_event_process',anchor=key)
                if reset_events:add('async_reset_candidate',anchor=key)
            elif events and conditions:add('synchronous_conditional_control_candidate',anchor=key)
            if events and any(e['edge'] in ('posedge','negedge') for e in events):add('edge_process',anchor=key)
            elif key not in ('initial','final'):add('combinational_or_latch_process',anchor=key)
            for node in walk(proc):
                if node.get('kind')=='AssignmentExpression':add('procedural_blocking_assignment',anchor='=')
                if node.get('kind')=='DataDeclaration':add('process_local_declaration',anchor=key)
            for event in events:
                if event['edge']=='negedge':add('negedge_event',anchor='negedge')
            processes.append(dict(kind=key,events=events,clock_events=clock_events,
                                  async_control_candidates=reset_events,assigned=sorted(set(assigned)),source=loc(key)))
        for inst in (x for x in walk(module) if x.get('kind')=='HierarchyInstantiation'):
            for child in inst.get('instances',[]):
                if not isinstance(child,dict):continue
                declaration=child.get('decl',{});bindings=[]
                for connection in child.get('connections',[]):
                    if not isinstance(connection,dict):continue
                    formal=connection.get('name');value=unwrapped(connection.get('expr',{}))
                    bindings.append(dict(formal=formal,expr=expression(value),kind=connection.get('kind'),
                                         expr_kind=value.get('kind')))
                instances.append(dict(module=inst['type'],name=declaration.get('name'),
                                      array=bool(declaration.get('dimensions')),bindings=bindings,
                                      parameters=bool(inst.get('parameters')),source=loc(declaration.get('name') or name)))
        mapping={'ConditionalExpression':'conditional_merge','CaseStatement':'case_statement','CaseZStatement':'casez_statement',
                 'CaseXStatement':'casex_statement','MultiplyExpression':'multiply','DivideExpression':'divide','ModExpression':'modulo',
                 'InvocationExpression':'call','CastExpression':'cast','IntegerLiteralExpression':'unsized_literal',
                 'CaseEqualityExpression':'case_equality','CaseInequalityExpression':'case_inequality','EqualityExpression':'logical_equality',
                 'InequalityExpression':'logical_inequality',
                 'NonblockingAssignmentExpression':'nonblocking_assignment','SequentialBlockStatement':'statement_block',
                 'LoopStatement':'procedural_loop','ForLoopStatement':'procedural_loop','WhileLoopStatement':'procedural_loop',
                 'LoopGenerate':'generate','IfGenerate':'generate','CaseGenerate':'generate','ParameterDeclaration':'parameter',
                 'FunctionDeclaration':'user_function','DPIImport':'dpi_import','BindDirective':'bind','ContinuousAssign':'continuous_assign',
                 'ImmediateAssertStatement':'immediate_assert','UnaryBitwiseXorExpression':'reduction_xor',
                 'AscendingRangeSelect':'indexed_part_select','AssignmentPatternExpression':'assignment_pattern',
                 'AddExpression':'add','SubtractExpression':'subtract'}
        for kind,feature in mapping.items():
            if counts[kind]:add(feature,counts[kind],anchor={'nonblocking_assignment':'<=','immediate_assert':'assert','modulo':'%',
                                                         'reduction_xor':'^','indexed_part_select':'+:'}.get(feature))
        for node in walk(module):
            kind=node.get('kind')
            if kind=='IntegerVectorExpression' and re.search('[xz?]',str(node.get('value','')),re.I):
                value=str(node.get('value','')).lower()
                if 'x' in value or '?' in value:add('x_literal',anchor=expression(node))
                if 'z' in value:add('z_literal',anchor=expression(node))
            if kind=='UnbasedUnsizedLiteralExpression':
                if 'x' in str(node).lower():add('x_literal')
                if 'z' in str(node).lower():add('z_literal')
            if kind=='ElementSelect':
                selection=node.get('selector',{})
                if selection.get('kind')=='BitSelect':
                    selector=selection.get('expr',{})
                    literal=selector.get('kind') in ('IntegerLiteralExpression','IntegerVectorExpression')
                    add('literal_index' if literal else 'nonliteral_index')
                else:add('part_select')
            if kind=='IdentifierSelectName' and node.get('identifier') in memories:add('memory_reference',anchor=node['identifier'])
            if kind=='SystemName':
                call=node.get('systemIdentifier',node.get('identifier',name));calls[call]+=1
                add('system_call',anchor=call)
            if kind=='ContinuousAssign':
                for assignment in node.get('assignments',[]):
                    if not isinstance(assignment,dict):continue
                    left,right=assignment.get('left',{}),assignment.get('right',{})
                    if left.get('kind')=='IdentifierName':
                        drivers.append(dict(target=left['identifier'],kind=right.get('kind'),identifiers=sorted(identifiers(right))))
                        if right.get('kind')=='IdentifierName':aliases.append(dict(target=left['identifier'],source=right['identifier'],kind=right['kind']))
            if kind=='CaseStatement':
                keyword=node.get('keyword') or node.get('caseKeyword')
                if keyword in ('casez','casex'):add(keyword+'_statement',anchor=keyword)
        if not module.get('members'):add('empty_module_candidate')
        simple_clocks={e['expr'] for p in processes for e in p['clock_events'] if e['edge'] in ('posedge','negedge')}
        if len(simple_clocks)>1:add('multiple_local_clock_expressions')
        result.append(dict(name=name,file=file,source=loc(name),ports=ports,features=dict(features),examples=examples,
                           kind_counts=dict(counts),instances=instances,register_targets=sorted(registers),memories=list(memories.values()),
                           processes=processes,aliases=aliases,drivers=drivers,system_calls=dict(calls)))
    return result


def hierarchy_output(text):
    result=[]
    for line in text.splitlines():
        fields=line.split('|')
        if len(fields)==3:
            path,module,file=fields
            if not path or not module:raise ValueError('invalid official hierarchy row')
            result.append(dict(path=path,module=module,file=file))
    if len({r['path'] for r in result})!=len(result):raise ValueError('duplicate official instance path')
    return result


def preprocessing_facts(source,file):
    """Lexical directives include inactive branches; these are not active CST counts."""
    clean=mask(source);counts=Counter();examples={}
    for match in re.finditer(r'`([A-Za-z_][A-Za-z0-9_$]*)',clean):
        key=match.group(1);counts[key]+=1
        examples.setdefault(key,dict(file=file,line=source.count('\n',0,match.start())+1))
    condition_macros=Counter(re.findall(r'`(?:ifdef|ifndef)\s+([A-Za-z_][A-Za-z0-9_$]*)',clean))
    lexical_keywords=Counter(re.findall(r'(?<![A-Za-z0-9_$])(initial|casez|casex|posedge|negedge|signed|inout|generate|endgenerate)(?![A-Za-z0-9_$])',clean))
    return dict(file=file,directives_and_macro_uses=dict(counts),examples=examples,condition_macros=dict(condition_macros),
                lexical_keywords=dict(lexical_keywords),
                scope='comment/string/escaped-identifier-filtered lexical occurrences; includes inactive branches')
