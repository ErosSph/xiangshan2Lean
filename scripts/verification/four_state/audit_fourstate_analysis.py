"""Deterministic aggregation of CST facts and official elaborated instance paths.

This module never elaborates SystemVerilog. Instance counts only come from the
successful official hierarchy receipt. Clock tracing follows direct identifiers,
port bindings and simple aliases, and stops at logic/state or ambiguous drivers.
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

from collections import Counter,defaultdict
import csv
import io
import json


def aggregate(modules,hierarchy,preprocessing):
    definitions=defaultdict(list)
    for m in modules:definitions[m['name']].append(m)
    unique={k:v[0] for k,v in definitions.items() if len(v)==1}
    rows=hierarchy['instances'] if hierarchy['status']=='ELABORATED' else []
    counts=Counter(r['module'] for r in rows);by_path={r['path']:r for r in rows}
    children=defaultdict(list);parents={}
    for row in rows:
        p=row['path'].rsplit('.',1)[0]
        while p not in by_path and '.' in p:p=p.rsplit('.',1)[0]
        if p in by_path and p!=row['path']:children[p].append(row['path']);parents[row['path']]=p
    feature_names=sorted({k for m in modules for k in m['features']})
    features={}
    for key in feature_names:
        selected=[m for m in modules if m['features'].get(key)]
        features[key]=dict(syntax_occurrences=sum(m['features'][key] for m in selected),
                           module_definitions=len(selected),reachable_module_types=sum(m['name'] in counts for m in selected),
                           affected_instances=sum(counts[m['name']] for m in selected),
                           instance_weighted_syntax_occurrences=sum(counts[m['name']]*m['features'][key] for m in selected),
                           examples=[dict(module=m['name'],**m['examples'][key]) for m in selected[:5]])
    unresolved=[dict(parent=m['name'],**i) for m in modules for i in m['instances'] if i['module'] not in definitions]
    subcount={};subfeatures={};subtypes={}
    for row in sorted(rows,key=lambda r:r['path'].count('.'),reverse=True):
        path=row['path'];m=unique.get(row['module'],{})
        subcount[path]=1+sum(subcount[p] for p in children[path])
        subfeatures[path]=set(m.get('features',{}));subtypes[path]={row['module']}
        for p in children[path]:subfeatures[path].update(subfeatures[p]);subtypes[path].update(subtypes[p])
    representatives=[];seen=set()
    for row in rows:
        name=row['module']
        if name in seen or name not in unique:continue
        seen.add(name);m=unique[name];path=row['path']
        representatives.append(dict(module=name,file=m['file'],path=path,instances=counts[name],
                                    subtree_instances=subcount[path],subtree_module_types=len(subtypes[path]),
                                    subtree_features=sorted(subfeatures[path]),own_features=m['features'],
                                    process_clocks=sorted({e['expr'] for p in m['processes'] for e in p['clock_events']})))
    edges={m['name']:[i['module'] for i in m['instances']] for m in modules}
    active=set();done=set();cycles=[]
    def visit(name):
        if name in active:cycles.append(name);return
        if name in done:return
        active.add(name)
        for target in edges.get(name,[]):visit(target)
        active.remove(name);done.add(name)
    for name in edges:visit(name)
    graph_check=dict(status='NOT_APPLICABLE')
    if not unresolved and not cycles and not any(m['features'].get('generate') or m['features'].get('parameter') or
            any(i.get('array') or i.get('parameters') for i in m['instances']) for m in modules):
        memo_counts={}
        def subtree(name):
            if name in memo_counts:return memo_counts[name]
            c=Counter({name:1})
            for child in edges.get(name,[]):c.update(subtree(child))
            memo_counts[name]=c;return c
        expected=subtree('XSTop') if 'XSTop' in definitions else None
        if expected is not None:graph_check=dict(status='MATCH' if expected==counts else 'MISMATCH',
                                                graph_instances=sum(expected.values()),official_instances=len(rows))
    lexical=Counter();lexical_files=Counter();condition_macros=Counter();lexical_keywords=Counter()
    for f in preprocessing:
        lexical.update(f['directives_and_macro_uses']);lexical_files.update(f['directives_and_macro_uses'].keys())
        condition_macros.update(f.get('condition_macros',{}));lexical_keywords.update(f.get('lexical_keywords',{}))
    pp={f['file']:f for f in preprocessing if f['directives_and_macro_uses']}
    pp_modules=[m for m in modules if m['file'] in pp]
    features['preprocessor_source_file']=dict(syntax_occurrences=sum(sum(f['directives_and_macro_uses'].values()) for f in pp.values()),
            module_definitions=len(pp_modules),reachable_module_types=sum(m['name'] in counts for m in pp_modules),
            affected_instances=sum(counts[m['name']] for m in pp_modules),instance_weighted_syntax_occurrences=None,
            scope='Lexical directive/macro occurrences in raw source, including inactive branches; not active syntax-node counts.',
            examples=[dict(module=m['name'],**next(iter(pp[m['file']]['examples'].values()))) for m in pp_modules[:5]])
    clocks=trace_clocks(unique,rows,parents,children)
    return dict(definitions=dict(occurrences=len(modules),distinct_names=len(definitions),
                                 duplicate_names={k:len(v) for k,v in definitions.items() if len(v)>1},
                                 reachable_types=len(set(counts)&set(definitions)),
                                 unreachable_types=sorted(set(definitions)-set(counts))),
                hierarchy=dict(status=hierarchy['status'],instances_including_top=len(rows),
                               instances_excluding_top=max(0,len(rows)-1) if rows else None,
                               source_instance_declarations=sum(len(m['instances']) for m in modules),
                               module_multiplicity=dict(counts),unresolved_source_instances=unresolved,
                               elaborated_undefined_types=sorted(set(counts)-set(definitions)),
                               source_graph_cycles=sorted(set(cycles)),
                               unconditional_graph_crosscheck=graph_check,
                               explicit_blackbox_attributes=0 if not any(m['kind_counts'].get('AttributeInstance') for m in modules) else None,
                               empty_module_candidates=[m['name'] for m in modules if m['features'].get('empty_module_candidate')]),
                features=features,
                state=dict(unique_whole_identifier_nba_targets=sum(len(m['register_targets']) for m in modules),
                           instance_weighted_whole_identifier_nba_targets=sum(counts[m['name']]*len(m['register_targets']) for m in modules),
                           unpacked_declarations=sum(len(m['memories']) for m in modules),
                           note='Names per module, not state bits or synthesized FF/RAM cell counts; memory/partial targets excluded from whole-register count.'),
                preprocessing=dict(lexical_occurrences=dict(lexical),files_per_name=dict(lexical_files),
                                   condition_macros=dict(condition_macros),noncomment_raw_keyword_occurrences=dict(lexical_keywords),
                                   defines_added_by_audit=[],profile='official CLI default, separate compilation units, no added defines; inactive branches not in CST'),
                system_calls=dict(sum((Counter(m.get('system_calls',{})) for m in modules),Counter())),
                clocks=clocks,representative_subtrees=representatives)


def trace_clocks(modules,rows,parents,children):
    bypath={r['path']:r['module'] for r in rows};memo={};outputs={}
    portmaps={name:{p['name']:p['direction'] for p in m['ports']} for name,m in modules.items()}
    aliasmaps={};drivermaps={};instmaps={}
    for name,m in modules.items():
        aliases=defaultdict(list);drivers=defaultdict(list)
        for a in m['aliases']:aliases[a['target']].append(a['source'])
        for d in m.get('drivers',[]):drivers[d['target']].append(d)
        aliasmaps[name]=aliases;drivermaps[name]=drivers;instmaps[name]={i['name']:i for i in m['instances']}
    def binding(parent,child,formal):
        definition=bypath.get(parent);inst=instmaps.get(definition,{}).get(child.rsplit('.',1)[-1])
        if not inst:return None
        connections=inst['bindings'];named=[b for b in connections if b['formal']==formal]
        if len(named)==1:return named[0]
        if all(b['formal'] is None for b in connections):
            names=[p['name'] for p in modules[bypath[child]]['ports']]
            if formal in names and names.index(formal)<len(connections):return connections[names.index(formal)]
        return None
    def output_connections(parent):
        if parent in outputs:return outputs[parent]
        result=defaultdict(list)
        for child in children[parent]:
            for formal,direction in portmaps.get(bypath[child],{}).items():
                if direction!='output':continue
                b=binding(parent,child,formal)
                if b and b.get('expr_kind')=='IdentifierName':result[b['expr']].append((child,formal))
        outputs[parent]=result;return result
    def resolve(path,signal,visiting):
        key=(path,signal)
        if key in memo:return memo[key]
        if key in visiting:return ('cycle_or_ambiguous',path+'.'+signal)
        visiting=visiting|{key};name=bypath.get(path)
        if name not in modules:return ('unknown_definition',path+'.'+signal)
        aliases=aliasmaps[name].get(signal,[]);drivers=drivermaps[name].get(signal,[])
        if len(aliases)==1 and len(drivers)==1:
            value=resolve(path,aliases[0],visiting)
        elif portmaps[name].get(signal)=='input':
            if path not in parents:value=('top_input',path+'.'+signal)
            else:
                b=binding(parents[path],path,signal)
                value=resolve(parents[path],b['expr'],visiting) if b and b.get('expr_kind')=='IdentifierName' else ('unresolved_port_binding',path+'.'+signal)
        elif drivers:
            value=('logic_or_multiple_drivers',path+'.'+signal)
        else:
            connected=output_connections(path).get(signal,[])
            value=resolve(*connected[0],visiting) if len(connected)==1 else ('internal_state_or_unresolved',path+'.'+signal)
        memo[key]=value;return value
    endpoints=defaultdict(lambda:dict(process_events=0,instances=set(),examples=[]));multiple=[];inverted=[]
    for row in rows:
        m=modules.get(row['module'],{});local_endpoints=set();local_expressions=set()
        for process in m.get('processes',[]):
            for event in process['clock_events']:
                if event['edge'] not in ('posedge','negedge'):continue
                if len(event['identifiers'])==1 and event['expr']==event['identifiers'][0]:
                    endpoint=resolve(row['path'],event['expr'],set())
                    drivers=drivermaps.get(row['module'],{}).get(event['expr'],[])
                    if len(drivers)==1 and drivers[0]['kind']=='UnaryBitwiseNotExpression':
                        inverted.append(dict(instance=row['path'],local_signal=event['expr'],driver=drivers[0],
                                             upstream_sources=[dict(kind=k,signal=s) for k,s in
                                                [resolve(row['path'],n,set()) for n in drivers[0]['identifiers']]]))
                else:endpoint=('complex_event_expression',row['path']+'.'+event['expr'])
                local_endpoints.add(endpoint);local_expressions.add(event['expr'])
                entry=endpoints[endpoint];entry['process_events']+=1;entry['instances'].add(row['path'])
                if len(entry['examples'])<3:entry['examples'].append(dict(instance=row['path'],event=event,source=process['source']))
        if m.get('features',{}).get('multiple_local_clock_expressions'):
            multiple.append(dict(instance=row['path'],module=row['module'],expressions=sorted(local_expressions),
                                 traced_endpoints=[dict(kind=k,signal=s) for k,s in sorted(local_endpoints)],
                                 same_traced_endpoint=len(local_endpoints)==1))
    return dict(method='Direct identifier port/alias tracing only; reset-event candidates excluded. Endpoints are NOT proven architectural clock domains.',
                endpoints=[dict(kind=k[0],signal=k[1],process_events=v['process_events'],affected_instances=len(v['instances']),examples=v['examples']) for k,v in sorted(endpoints.items())],
                endpoint_count=len(endpoints),top_input_sources=sorted(k[1] for k in endpoints if k[0]=='top_input'),
                multiple_expression_instances=multiple,
                inverted_clock_drivers=inverted,
                unresolved_or_derived_endpoints=sum(k[0]!='top_input' for k in endpoints),
                architectural_clock_domain_count=None)


def gaps_csv(rows):
    out=io.StringIO(newline='');writer=csv.DictWriter(out,fieldnames=list(rows[0]))
    writer.writeheader();writer.writerows(rows);return out.getvalue()


def main():
    import argparse,gzip
    from pathlib import Path
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--facts',required=True,type=Path);p.add_argument('--hierarchy',required=True,type=Path)
    p.add_argument('--preprocessing',required=True,type=Path);p.add_argument('--output',required=True,type=Path)
    a=p.parse_args();facts=json.loads(gzip.decompress(a.facts.read_bytes()))
    value=aggregate(facts,json.loads(a.hierarchy.read_text(encoding='utf-8')),json.loads(a.preprocessing.read_text(encoding='utf-8')))
    with a.output.open('x',encoding='utf-8') as f:json.dump(value,f,ensure_ascii=False,indent=2);f.write('\n')


if __name__=='__main__':main()
