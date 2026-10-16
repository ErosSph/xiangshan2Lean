"""Import pinned slang's elaborated hierarchy into the independent four-state IR.

slang evaluates parameters, creates generate scopes and binds port conversions.
This module imports those results; it does not implement an RTL elaborator.
"""
from __future__ import annotations

from pathlib import Path
import os
import re

from bootstrap_fourstate import load_parser

SIMPLE = re.compile(r'[A-Za-z_][A-Za-z0-9_$]*\Z')
BINARY = {'Add': 'add', 'Subtract': 'sub', 'BinaryAnd': 'and', 'BinaryOr': 'or',
          'BinaryXor': 'xor', 'BinaryXnor': 'xnor', 'Equality': 'eq', 'Inequality': 'ne',
          'CaseEquality': 'case_eq', 'CaseInequality': 'case_ne', 'LessThan': 'lt',
          'LessThanEqual': 'le', 'GreaterThan': 'gt', 'GreaterThanEqual': 'ge',
          'LogicalAnd': 'logical_and', 'LogicalOr': 'logical_or',
          'LogicalShiftLeft': 'shl', 'LogicalShiftRight': 'shr',
          'ArithmeticShiftLeft': 'ashl', 'ArithmeticShiftRight': 'ashr'}
UNARY = {'Plus': 'pos', 'Minus': 'neg', 'BitwiseNot': 'not', 'LogicalNot': 'logical_not',
         'BitwiseAnd': 'reduce_and', 'BitwiseOr': 'reduce_or'}


def source_files(source):
    source = Path(source).resolve()
    files = sorted((p.resolve() for p in source.rglob('*') if p.is_file() and p.suffix.lower() in ('.sv', '.v')),
                   key=lambda p: p.as_posix()) if source.is_dir() else [source]
    if not files or any(not p.is_file() for p in files):
        raise ValueError('RTL source file or nonempty .sv/.v directory required: ' + str(source))
    return files


def parse(source, top, mode='combinational', clock=None):
    if mode not in ('combinational', 'sequential') or (mode == 'sequential') != bool(clock):
        raise ValueError('Sequential mode requires --clock; combinational mode forbids it')
    s = load_parser()
    files = source_files(source)
    sm = s.SourceManager()
    def diagnostic_text(items):
        text = s.DiagnosticEngine.reportAll(sm, items)
        for file in files:
            try:
                relative = os.path.relpath(file)
            except ValueError:
                continue  # A different Windows drive is already printed absolute.
            text = text.replace(relative, str(file))
        return text
    trees = []
    for file in files:
        raw = file.read_text(encoding='utf-8')
        clean = re.sub(r'/\*.*?\*/|//[^\n]*', lambda m: ''.join('\n' if c == '\n' else ' ' for c in m[0]), raw, flags=re.S)
        if '`' in clean:
            offset = clean.index('`')
            raise ValueError(f'{file}:{clean.count(chr(10), 0, offset)+1}:{offset-clean.rfind(chr(10),0,offset)}: preprocessor directive or macro unsupported')
        tree = s.syntax.SyntaxTree.fromFile(str(file), sm)
        if any(d.isError() for d in tree.diagnostics):
            raise ValueError(diagnostic_text(tree.diagnostics))
        trees.append(tree)
        def unsupported_directive(n):
            if isinstance(n, s.syntax.SyntaxNode):
                k = str(n.kind).split('.')[-1]
                if k == 'BindDirective' or 'DefParam' in k:
                    p = n.sourceRange.start
                    raise ValueError(f'{file}:{sm.getLineNumber(p)}:{sm.getColumnNumber(p)}: {k} unsupported')
        tree.root.visit(unsupported_directive)
    options = s.ast.CompilationOptions()
    options.topModules = {top}
    options.maxInstanceDepth = 128
    options.maxGenerateSteps = 65536
    compilation = s.ast.Compilation(s.Bag([options]))
    for tree in trees:
        compilation.addSyntaxTree(tree)
    root = compilation.getRoot()
    diagnostics = compilation.getAllDiagnostics()
    if any(d.isError() for d in diagnostics):
        raise ValueError(diagnostic_text(diagnostics))
    if len(root.topInstances) != 1 or root.topInstances[0].name != top:
        raise ValueError(f'{files[0]}:1:1: --top must identify exactly one module ({top})')
    instance = root.topInstances[0]

    def kind(n):
        return str(n.kind).split('.')[-1]

    def loc(n):
        pos = n.sourceRange.start if hasattr(n, 'sourceRange') else n.location
        return {'file': str(Path(sm.getFileName(pos)).resolve()),
                'line': sm.getLineNumber(pos), 'column': sm.getColumnNumber(pos)}

    def fail(n, message):
        p = loc(n)
        raise ValueError(f"{p['file']}:{p['line']}:{p['column']}: {message} ({kind(n)})")

    def simple(n):
        if not SIMPLE.fullmatch(n.name):
            fail(n, 'simple unescaped identifier required: ' + n.name)

    def bits(value, width=None):
        width = value.bitWidth if width is None else width
        result = ''.join(str(value[i]).lower() for i in reversed(range(value.bitWidth)))
        fill = result[0] if value.isSigned else '0'
        return (fill * width + result)[-width:]

    def constant_audit(e, local_values=(), known_parameters=False):
        def visit(n):
            if isinstance(n, s.ast.Expression):
                if kind(n) == 'Call' and (not n.isSystemCall or n.subroutineName not in ('$clog2', '$bits', '$signed', '$unsigned')):
                    fail(n, 'constant function unsupported')
                if kind(n) == 'Call' and n.isSystemCall and n.subroutineName == '$bits':
                    return s.ast.VisitAction.Skip
                if kind(n) in ('NamedValue', 'HierarchicalValue'):
                    if kind(n.symbol) not in ('Parameter', 'Genvar') and n.symbol not in local_values:
                        fail(n, 'constant expression references hardware')
                    if known_parameters and kind(n.symbol) == 'Parameter':
                        value = n.symbol.value.value
                        if not isinstance(value, s.SVInt) or value.hasUnknown:
                            fail(n, 'fully known integral generate-for parameter required')
        if e is not None:
            e.visit(visit)

    def integer(e, scope):
        constant_audit(e)
        context = (s.ast.EvalContext(scope) if isinstance(scope, s.ast.Symbol) else
                   s.ast.EvalContext(s.ast.ASTContext(scope, s.ast.LookupLocation.max)))
        value = e.eval(context).value
        if not isinstance(value, s.SVInt) or value.hasUnknown:
            fail(e, 'fully known integral structural expression required')
        return int(value)

    def audit_generate_for(n, scope):
        # Audit official expressions at official iteration values. Do not decide
        # which scopes exist or reproduce slang's generate expansion algorithm.
        variable = n.loopVariable
        for e in (n.initialExpression, n.stopExpression, n.iterExpression):
            constant_audit(e, (variable,), known_parameters=True)

        def evaluate(e, context):
            value = e.eval(context)
            if not isinstance(value.value, s.SVInt) or value.value.hasUnknown:
                fail(e, 'fully known integral generate-for structural expression required')
            return value

        initial = evaluate(n.initialExpression, s.ast.EvalContext(scope))
        values = [initial] + [entry.find(variable.name).value for entry in n.entries]
        for value in values:
            context = s.ast.EvalContext(scope)
            context.createLocal(variable, value)
            evaluate(n.stopExpression, context)
            evaluate(n.iterExpression, context)
            # The evaluator applies the increment to its local, including ++,
            # -- and compound assignment. Check the terminal condition too.
            current = context.findLocal(variable).value
            if not isinstance(current, s.SVInt) or current.hasUnknown:
                fail(n.iterExpression, 'fully known integral generate-for step required')
            evaluate(n.stopExpression, context)

    signals, symbols, owners_of_signal, parameter_owners = {}, {}, {}, {}
    capabilities = set()
    raw_drives, processes, connections = [], [], []
    hierarchy = {'top': top, 'parser': 'pyslang 12.0.0', 'instances': [], 'parameters': [], 'generate': [], 'connections': [],
                 'options': {'topModules': [top], 'maxInstanceDepth': 128, 'maxGenerateSteps': 65536},
                 'diagnostics': diagnostic_text(diagnostics)}

    def declaration(n, is_port=False):
        simple(n)
        typ = n.type
        multidimensional = typ.isPackedArray and typ.arrayElementType.isPackedArray
        if (not typ.isIntegral or not typ.isFourState or typ.bitWidth < 1 or typ.isUnpackedArray
                or (not typ.isSimpleBitVector and not multidimensional)):
            fail(n, 'fixed four-state packed vector required')
        if multidimensional:
            if is_port or kind(n) != 'Net' or typ.arrayElementType.arrayElementType.isPackedArray:
                fail(n, 'two packed dimensions supported only for internal wires')
            capabilities.add('packed_vectors')
        if min(typ.fixedRange.left, typ.fixedRange.right) < 0:
            fail(n, 'nonnegative declaration range required')
        if n.initializer is not None and kind(n) != 'Net':
            fail(n, 'declaration initializer unsupported')
        if kind(n) == 'Net' and (n.isImplicit or n.netType.name != 'wire' or n.delay is not None):
            fail(n, 'explicit plain wire required')
        syntax = n.syntax
        while syntax is not None and kind(syntax) not in ('ModuleDeclaration', 'GenerateBlock', 'IfGenerate', 'LoopGenerate'):
            if getattr(syntax, 'attributes', None):
                fail(syntax, 'attributes unsupported')
            if getattr(syntax, 'strength', None) is not None or getattr(syntax, 'delay', None) is not None:
                fail(syntax, 'strength/delay unsupported')
            syntax = syntax.parent

    def module_check(inst):
        simple(inst)
        if not inst.isModule or inst.arrayPath:
            fail(inst, 'ordinary scalar module instance required')
        definition = inst.definition
        simple(definition)
        syntax = definition.syntax
        if syntax.header.ports is None or kind(syntax.header.ports) != 'AnsiPortList':
            fail(syntax, 'ANSI module ports required')
        if getattr(syntax, 'attributes', None):
            fail(syntax, 'module attributes unsupported')
        # Wildcards and omitted connections must not be filled silently.
        if inst is not instance:
            def check(n):
                if isinstance(n, s.syntax.SyntaxNode) and kind(n) == 'WildcardPortConnection':
                    fail(n, 'wildcard port connection unsupported')
            inst.syntax.visit(check)

    def collect(scope, owning_instance):
        port_directions = {}
        if kind(scope) == 'InstanceBody':
            for p in scope.portList:
                simple(p)
                if kind(p) != 'Port' or str(p.direction).split('.')[-1] not in ('In', 'Out') or not p.isAnsiPort:
                    fail(p, 'ordinary ANSI input/output required')
                if p.initializer is not None:
                    fail(p, 'port initializer unsupported')
                port_directions[p.internalSymbol.hierarchicalPath] = 'input' if str(p.direction).endswith('.In') else 'output'
        for n in scope:
            k = kind(n)
            if k in ('Net', 'Variable'):
                declaration(n, n.hierarchicalPath in port_directions)
                path = n.hierarchicalPath
                typ, r = n.type, n.type.fixedRange
                info = {'name': path, 'logical_path': path, 'rtl_path': path[len(top)+1:],
                        'direction': port_directions.get(path, 'internal') if owning_instance == top else 'internal',
                        'width': typ.bitWidth, 'signed': bool(typ.isSigned), 'left': r.left, 'right': r.right,
                        'source': loc(n)}
                if info['direction'] != 'internal':
                    info['port_name'] = n.name
                signals[path], symbols[path], owners_of_signal[path] = info, n, owning_instance
                if typ.isPackedArray and typ.arrayElementType.isPackedArray:
                    ranges, current = [], typ
                    while current.isPackedArray:
                        bounds = current.fixedRange
                        if min(bounds.left, bounds.right) < 0:
                            fail(n, 'nonnegative packed range required')
                        ranges.append({'left': bounds.left, 'right': bounds.right,
                                       'element_width': current.arrayElementType.bitWidth})
                        current = current.arrayElementType
                    info['packed_ranges'] = ranges
                if n.initializer is not None:
                    capabilities.add('net_initializer')
                    raw_drives.append((path, n.initializer, scope, owning_instance, None, n))
            elif k == 'Parameter':
                simple(n)
                constant_audit(n.initializer)
                value = n.value.value
                if not isinstance(value, s.SVInt):
                    fail(n, 'integral parameter/localparam required')
                parameter_owners[n.hierarchicalPath] = owning_instance
                hierarchy['parameters'].append({'path': n.hierarchicalPath, 'width': value.bitWidth,
                                                 'signed': bool(value.isSigned), 'bits': bits(value),
                                                 'local': n.isLocalParam, 'source': loc(n)})
            elif k == 'Instance':
                module_check(n)
                record_instance(n)
                connections.append((n, owning_instance))
                collect(n.body, n.hierarchicalPath)
            elif k == 'GenerateBlock':
                if n.name:
                    simple(n)
                hierarchy['generate'].append({'path': n.hierarchicalPath, 'active': not n.isUninstantiated,
                                              'kind': str(n.branchKind), 'source': loc(n)})
                if n.conditionExpression is not None:
                    integer(n.conditionExpression, scope)
                for item in n.caseItemExpressions:
                    integer(item, scope)
                if not n.isUninstantiated:
                    collect(n, owning_instance)
            elif k == 'GenerateBlockArray':
                simple(n)
                if not n.valid:
                    fail(n, 'invalid generate expansion')
                audit_generate_for(n, scope)
                hierarchy['generate'].append({'path': n.hierarchicalPath, 'kind': 'for',
                                              'entries': [e.hierarchicalPath for e in n.entries], 'source': loc(n)})
                for entry in n.entries:
                    collect(entry, owning_instance)
            elif k == 'ContinuousAssign':
                if n.delay is not None or any(v is not None for v in n.driveStrength):
                    fail(n, 'continuous delay/strength unsupported')
                raw_drives.append((n.assignment.left, n.assignment.right, scope, owning_instance, None, n))
            elif k == 'ProceduralBlock':
                processes.append((n, scope, owning_instance))
            elif k not in ('Port', 'Genvar', 'EmptyMember'):
                fail(n, 'unsupported active elaborated symbol')

    def record_instance(inst):
        params = []
        for p in inst.body.parameters:
            if kind(p) == 'Parameter' and p.isLocalParam:
                continue
            v = p.value.value if kind(p) == 'Parameter' else None
            if not isinstance(v, s.SVInt):
                fail(p, 'integral value parameter required')
            params.append({'name': p.name, 'width': v.bitWidth, 'signed': bool(v.isSigned), 'bits': bits(v),
                           'overridden': p.isOverridden, 'source': loc(p)})
        hierarchy['instances'].append({'path': inst.hierarchicalPath, 'module': inst.definition.name,
                                       'parameters': params, 'source': loc(inst), 'definition': loc(inst.definition)})

    module_check(instance)
    record_instance(instance)
    collect(instance.body, top)
    if not any(p['direction'] == 'output' for p in signals.values()):
        fail(instance, 'at least one top output required')

    def reference(e, placeholder=None):
        if kind(e) in ('NamedValue', 'HierarchicalValue') and kind(e.symbol) in ('Net', 'Variable'):
            return e.symbol.hierarchicalPath
        if kind(e) == 'EmptyArgument' and placeholder is not None:
            return placeholder
        return None

    def audit_reference_owner(e, owner, role):
        def visit(n):
            if isinstance(n, s.ast.Expression) and kind(n) in ('NamedValue', 'HierarchicalValue'):
                if kind(n.symbol) in ('Net', 'Variable'):
                    if owners_of_signal.get(n.symbol.hierarchicalPath) != owner:
                        fail(n, 'cross-module internal reference unsupported in ' + role)
                elif kind(n.symbol) == 'Parameter' and parameter_owners.get(n.symbol.hierarchicalPath) != owner:
                    fail(n, 'cross-module parameter reference unsupported in ' + role)
        e.visit(visit)

    for child, parent_owner in connections:
        for p in child.portConnections:
            port, actual = p.port, p.expression
            if actual is None or kind(actual) == 'EmptyArgument':
                fail(child, 'every input/output must be connected: ' + port.name)
            formal = port.internalSymbol.hierarchicalPath
            if str(port.direction).endswith('.In'):
                raw_drives.append((formal, actual, child.parentScope, parent_owner, None, child))
                destination = formal
            else:
                if kind(actual) != 'Assignment' or reference(actual.left) is None:
                    fail(actual, 'output connection must target a whole signal')
                # slang's synthetic output assignment crosses the boundary on
                # purpose; only its source actual target belongs to the parent.
                audit_reference_owner(actual.left, parent_owner, 'output connection target')
                raw_drives.append((actual.left, actual.right, child.parentScope, child.hierarchicalPath, formal, child))
                destination = reference(actual.left)
            hierarchy['connections'].append({'instance': child.hierarchicalPath, 'port': port.name,
                                               'direction': str(port.direction), 'formal': formal,
                                               'destination': destination, 'source': loc(child)})

    drives = {}
    for left, right, scope, owner, placeholder, origin in raw_drives:
        dest = left if isinstance(left, str) else reference(left)
        if not isinstance(left, str) and placeholder is None:
            audit_reference_owner(left, owner, 'assignment target')
        audit_reference_owner(right, owner, 'assignment source')
        if dest not in signals or signals[dest]['direction'] == 'input':
            fail(origin, 'whole declared non-input signal assignment required')
        if dest in drives:
            fail(origin, 'multiple drivers: ' + dest)
        drives[dest] = (right, scope, owner, placeholder, origin)

    def alias(e, placeholder):
        while kind(e) == 'Conversion' and e.isImplicit and e.type.bitWidth == 1 and e.operand.type.bitWidth == 1:
            e = e.operand
        return reference(e, placeholder)

    clock_signal, clock_signals = top + '.' + str(clock), set()
    if mode == 'sequential':
        if clock_signal not in signals or signals[clock_signal]['direction'] != 'input' or signals[clock_signal]['width'] != 1:
            fail(instance, '--clock must name a one-bit top input')
        clock_signals.add(clock_signal)
        changed = True
        while changed:
            changed = False
            for dest, (right, _, _, placeholder, _) in drives.items():
                if signals[dest]['width'] == 1 and alias(right, placeholder) in clock_signals and dest not in clock_signals:
                    clock_signals.add(dest); changed = True
        for name in clock_signals:
            if signals[name]['direction'] == 'output':
                fail(symbols[name], 'clock cannot be observed as data output')
        if not processes:
            fail(instance, 'sequential design must contain registers')
    elif processes:
        fail(processes[0][0], 'clocked process requires sequential mode')

    ir_nodes, state_owners, process_bodies = [], {}, []

    def add(n, op, w, args=(), signed=False, **extra):
        i = len(ir_nodes)
        ir_nodes.append({'id': i, 'op': op, 'width': w, 'signed': signed, 'args': list(args), 'source': loc(n), **extra})
        return i

    def audit_runtime(n):
        if n is None:
            return
        from fourstate_frontend import ALLOWED
        k = kind(n)
        if k.endswith('Name'):
            return  # binding and static selector evaluation are checked below
        if k == 'MultipleConcatenationExpression':
            audit_runtime(n.concatenation)
            return  # The replication count uses the official structural evaluator.
        if k == 'CastExpression':
            if kind(n.left).endswith('Type'):
                fail(n, 'type cast unsupported; use an integral size')
            audit_runtime(n.right)
            return
        if k not in ALLOWED | {'UnaryBitwiseAndExpression', 'UnaryBitwiseOrExpression'}:
            fail(n, 'unsupported hardware syntax')
        if k == 'IntegerLiteralExpression':
            fail(n, 'unsized data literal unsupported')
        for child in n:
            if isinstance(child, s.syntax.SyntaxNode):
                audit_runtime(child)

    def expression(e, scope, owner, placeholder=None):
        k, w, signed = kind(e), e.type.bitWidth, bool(e.type.isSigned)
        if w < 1:
            fail(e, 'positive bit-vector expression required')
        if k in ('NamedValue', 'HierarchicalValue'):
            symbol = e.symbol
            if kind(symbol) == 'Parameter':
                if parameter_owners.get(symbol.hierarchicalPath) != owner:
                    fail(e, 'cross-module parameter reference unsupported')
                return add(e, 'const', w, signed=signed, bits=bits(symbol.value.value, w))
            name = reference(e)
            if name not in signals or owners_of_signal[name] != owner:
                fail(e, 'cross-module internal reference unsupported')
            if name in clock_signals:
                fail(e, 'clock cannot be used as data')
            return add(e, 'ref', w, signed=signed, name=name)
        if k == 'EmptyArgument' and placeholder is not None:
            return add(e, 'ref', w, signed=signed, name=placeholder)
        if k == 'IntegerLiteral':
            if e.isDeclaredUnsized:
                fail(e, 'unsized data literal unsupported')
            return add(e, 'const', w, signed=signed, bits=bits(e.value, w))
        if k == 'Conversion':
            arg = expression(e.operand, scope, owner, placeholder)
            old = ir_nodes[arg]
            op = 'resize' if old['width'] != w else 'cast_sign'
            return add(e, op, w, [arg], signed=signed, from_width=old['width'],
                       extension='sign' if e.operand.type.isSigned else 'zero')
        if k == 'UnaryOp':
            op = UNARY.get(str(e.op).split('.')[-1])
            if op is None:
                fail(e, 'unsupported unary hardware operator')
            if op.startswith('reduce_'):
                capabilities.add('reductions')
            return add(e, op, w, [expression(e.operand, scope, owner)], signed=signed)
        if k == 'BinaryOp':
            op = BINARY.get(str(e.op).split('.')[-1])
            if op is None:
                fail(e, 'unsupported binary hardware operator')
            args = [expression(e.left, scope, owner), expression(e.right, scope, owner)]
            return add(e, op, w, args, signed=signed,
                       compare_signed=bool(e.left.type.isSigned and e.right.type.isSigned), operand_width=e.left.type.bitWidth)
        if k == 'ConditionalOp':
            if len(e.conditions) != 1 or e.conditions[0].pattern is not None or e.conditions[0].expr.type.bitWidth != 1:
                fail(e, 'one-bit expression condition required')
            args = [expression(e.conditions[0].expr, scope, owner), expression(e.left, scope, owner), expression(e.right, scope, owner)]
            return add(e, 'mux', w, args, signed=signed)
        if k == 'Concatenation':
            return add(e, 'concat', w, [expression(a, scope, owner) for a in e.operands], signed=signed)
        if k == 'Replication':
            count = integer(e.count, scope)
            if count <= 0:
                fail(e, 'positive constant replication count required')
            capabilities.add('replication')
            return add(e, 'repeat', w, [expression(e.concat, scope, owner)], signed=signed, count=count)
        if k in ('ElementSelect', 'RangeSelect'):
            name = reference(e.value)
            typ = e.value.type
            multidimensional = typ.isPackedArray and typ.arrayElementType.isPackedArray
            if k == 'ElementSelect' and e.selector.constant is None:
                if not multidimensional:
                    fail(e, 'dynamic selection supported only for packed word vectors')
                capabilities.add('packed_select')
                return add(e, 'packed_select', w,
                           [expression(e.value, scope, owner), expression(e.selector, scope, owner)],
                           signed=signed, left=typ.fixedRange.left, right=typ.fixedRange.right,
                           index_signed=bool(e.selector.type.isSigned))
            if k == 'ElementSelect':
                a = b = integer(e.selector, scope)
            else:
                if str(e.selectionKind).split('.')[-1] != 'Simple':
                    fail(e, 'simple static range required')
                a, b = integer(e.left, scope), integer(e.right, scope)
            r = typ.fixedRange
            indices = list(range(a, b + (1 if a <= b else -1), 1 if a <= b else -1))
            if any(i < min(r.left, r.right) or i > max(r.left, r.right) for i in indices):
                fail(e, 'selection outside declaration')
            stride = typ.arrayElementType.bitWidth if typ.isPackedArray else 1
            positions = [abs(i-r.right)*stride+j for i in indices for j in reversed(range(stride))]
            if name in signals and not multidimensional:
                if owners_of_signal[name] != owner or name in clock_signals:
                    fail(e, 'static select of local signal required')
                return add(e, 'select', w, signed=signed, name=name, bits=positions)
            capabilities.add('packed_vectors')
            return add(e, 'slice', w, [expression(e.value, scope, owner)], signed=signed, bits=positions)
        if k == 'Call' and e.isSystemCall and e.subroutineName in ('$signed', '$unsigned') and len(e.arguments) == 1:
            arg = expression(e.arguments[0], scope, owner)
            return add(e, 'cast_sign', w, [arg], signed=signed)
        fail(e, 'unsupported hardware expression')

    for index, (proc, scope, owner) in enumerate(processes):
        body = proc.body
        if kind(body) == 'Timed' and kind(body.timing) == 'SignalEvent':
            audit_reference_owner(body.timing.expr, owner, 'event clock')
        if (str(proc.procedureKind).split('.')[-1] not in ('Always', 'AlwaysFF') or kind(body) != 'Timed'
                or kind(body.timing) != 'SignalEvent' or str(body.timing.edge).split('.')[-1] != 'PosEdge'
                or body.timing.iffCondition is not None or reference(body.timing.expr) not in clock_signals):
            fail(proc, 'common direct posedge clock required; asynchronous/derived clocks unsupported')
        def own(n):
            if isinstance(n, s.ast.Expression) and kind(n) == 'Assignment':
                dest = reference(n.left)
                if not n.isNonBlocking or n.op is not None or n.timingControl is not None or dest not in signals or kind(symbols[dest]) != 'Variable':
                    fail(n, 'whole-register nonblocking assignment required')
                if owners_of_signal[dest] != owner or signals[dest]['direction'] == 'input':
                    fail(n, 'local non-input register target required')
                if dest in state_owners and state_owners[dest] != index or dest in drives:
                    fail(n, 'multiple or mixed register drivers: ' + dest)
                state_owners[dest] = index
        body.stmt.visit(own)
        process_bodies.append((body.stmt, scope, owner, proc))

    def lower(statement, env, scope, owner):
        k = kind(statement)
        if k == 'Empty':
            return env
        if k == 'Block':
            if str(statement.blockKind).split('.')[-1] != 'Sequential':
                fail(statement, 'sequential begin/end required')
            return lower(statement.body, env, scope, owner)
        if k == 'List':
            for item in statement.list:
                env = lower(item, env, scope, owner)
            return env
        if k == 'ExpressionStatement' and kind(statement.expr) == 'Assignment':
            e = statement.expr
            audit_runtime(e.right.syntax)
            result = dict(env)
            result[reference(e.left)] = expression(e.right, scope, owner)
            return result
        if k == 'Conditional':
            if len(statement.conditions) != 1 or statement.conditions[0].pattern is not None or 'None' not in str(statement.check):
                fail(statement, 'ordinary one-bit procedural if required')
            cond = statement.conditions[0].expr
            if cond.type.bitWidth != 1:
                fail(cond, 'one-bit procedural if required')
            audit_runtime(cond.syntax)
            condition = expression(cond, scope, owner)
            yes = lower(statement.ifTrue, dict(env), scope, owner)
            no = lower(statement.ifFalse, dict(env), scope, owner) if statement.ifFalse is not None else env
            return {name: add(statement, 'proc_mux', signals[name]['width'], [condition, yes[name], no[name]],
                              signed=signals[name]['signed']) if yes[name] != no[name] else yes[name] for name in env}
        fail(statement, 'unsupported clocked statement')

    assignments = {}
    for dest, (right, scope, owner, placeholder, origin) in drives.items():
        if dest in clock_signals:
            continue
        if placeholder is None:
            audit_runtime(right.syntax)
        assignments[dest] = expression(right, scope, owner, placeholder)
        if ir_nodes[assignments[dest]]['width'] != signals[dest]['width']:
            fail(origin, 'bound assignment width mismatch')
    next_state = {}
    for i, (body, scope, owner, proc) in enumerate(process_bodies):
        env = {n: add(proc, 'ref', signals[n]['width'], signed=signals[n]['signed'], name=n)
               for n, p in state_owners.items() if p == i}
        next_state.update(lower(body, env, scope, owner))
    if mode == 'sequential' and not state_owners:
        fail(instance, 'at least one assigned register required')
    for name, info in signals.items():
        if name not in clock_signals and info['direction'] != 'input' and name not in assignments and name not in state_owners:
            fail(symbols[name], 'undriven signal: ' + name)
    order, active, done = [], set(), set()
    def dependencies(i):
        n = ir_nodes[i]
        if n['op'] in ('ref', 'select'):
            yield n['name']
        for a in n['args']:
            yield from dependencies(a)
    def schedule(name):
        if name in active:
            fail(symbols[name], 'combinational cycle: ' + name)
        if name in done or name in state_owners or signals[name]['direction'] == 'input':
            return
        active.add(name)
        for dep in dependencies(assignments[name]):
            schedule(dep)
        active.remove(name); done.add(name); order.append(name)
    for name in assignments:
        schedule(name)
    states = [dict(signals[n], process=p,
                   bit_indices=[signals[n]['right'] + (i if signals[n]['left'] >= signals[n]['right'] else -i)
                                for i in range(signals[n]['width'])]) for n, p in state_owners.items()]
    hierarchy['states'] = [{k: x[k] for k in ('name', 'rtl_path', 'width', 'signed', 'left', 'right', 'source')} for x in states]
    extended = capabilities - {'net_initializer'}
    return {'format': 'chisel2lean-fourstate-ir-v5' if extended else 'chisel2lean-fourstate-ir-v4',
            'capabilities': sorted(capabilities), 'mode': mode, 'top': top,
            'source': str(Path(source).resolve()), 'sources': [str(p) for p in files],
            'signals': list(signals.values()), 'nodes': ir_nodes, 'assignments': assignments, 'order': order,
            'parser': 'pyslang 12.0.0', 'clock': clock if mode == 'sequential' else None,
            'clock_signal': clock_signal if mode == 'sequential' else None, 'clock_signals': sorted(clock_signals),
            'states': states, 'next_state': next_state, 'elaboration': hierarchy}
