"""Render an evidence-backed F3.1 report from frozen facts (no hardware tools)."""
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
from audit_fourstate_analysis import gaps_csv


POLICIES=[
('P0','preprocessor_source_file','未支持','原始文件中的宏、include 和条件编译','当前入口在解析前拒绝反引号；活动 CST 的成功不等于当前转换入口接受原文件。','官方预处理可作为候选；必须固定宏、include 和编译单元设置。','先对带 ENABLE_INITIAL_REG_ / DIFFTEST 的小夹具固定两套宏，比较活动语法与诊断。'),
('P1','async_reset_candidate','未支持','多事件过程及异步控制','当前仅允许同一直接二值时钟的 posedge；本批候选均以条件引用事件信号识别，代表源码确认异步复位。','语法重排不能替代异步事件四态语义。','LevelGateway：复位独立于时钟断言/释放，含 X/Z 控制与旧状态读取。'),
('P2','process_local_declaration','未支持','过程局部变量及其声明初始化/阻塞赋值','53,579 是声明语法节点数；普通 begin/end 已支持，不能把所有块当缺口。','disallowLocalVariables 是候选；现有有限模块结果不证明原始 RTL 与该布局全域四态等价。','CAMTemplate：一个 automatic 临时量、阻塞计算、多个寄存器 NBA，检查旧状态和 X/Z。'),
('P3','unpacked_array','未支持','未打包数组、索引写入与读写时序','现有动态选择只覆盖受限二维 packed word wire；不覆盖本批 RAM 数组。','不能以 flatten/memory_map 的二态成功代替未知地址、X/Z 数据、冲突写入语义。','2 深度内存：X/Z 地址、使能、同址读写、掩码写、显式初态；以后再取 ram_2x340。'),
('P4','immediate_assert','未支持','断言和可观察系统任务','活动源码含 immediate assert/$error 与 $fwrite；$signed/$unsigned 单参数属于已支持转换子集。','删除副作用会改变执行契约，需先定义四态检查/打印接口。','一个时钟断言：条件 0/1/X/Z、失败退出与打印事件；不静默丢弃。'),
('P5','always_latch','未支持','锁存器与时钟门控','ClockGate 内部 EN 为锁存状态，输出 Q=CK&EN；当前单时钟入口不能执行这类电路。','需显式事件/锁存器契约；普通组合化不足以保留四态。','ClockGate：CK/E/TE 含 X/Z，透明期、保持期、门控输出边沿。'),
('P6','multiple_local_clock_expressions','部分支持','局部多时钟表达式与整机多源时钟','9 个实例的两端口均追踪到 io_clock；整机仍有两个根输入及派生时钟，不能视为单时钟设计。','端口绑定已确认这 9 个实例同源；不能由此简化整个顶层的四态事件调度。','先复用同源时钟身份；另以 JTAG TCK 与 io_clock 的独立相位、反相时钟最小夹具确认调度需求。'),
('P7','nonliteral_index','部分支持','非字面量下标与 packed/unpacked 上下文','非字面量可能是常量表达式，并不全部是运行时动态索引；当前仅有限 packed 选择有测试。','官方类型/常量绑定可分类，不能据 CST 直接宣称全类支持。','区分局部 packed word、标量 bit、unpacked array，含越界与 X/Z 下标。'),
('P8','assignment_pattern','未支持','赋值模式与聚合布局','活动语法存在赋值模式；当前严格表达式子集不包含该类。','官方展开常量模式是候选；仍需检查宽度、符号和元素顺序。','BlockCipherModule 的常量模式缩小为两元素，比较顺序/符号/X/Z。'),
('P9','reduction_xor','未支持','归约异或','当前 UNARY 仅列归约 AND/OR，不能把二元 XOR 测试当成归约 XOR 证据。','可展开成异或树的候选，四态真值必须独立核验。','2/3/宽向量含 X/Z 的归约 XOR，随后再取 PtwCache。'),
('P10','modulo','未支持','取模运算','本批唯一节点在 DebugTransportModuleJTAG 的断言相关计算中；不能据此推断一般数据通路取模需求。','常数 2 的特例可由官方工具规范化候选处理，当前无四态等价证据。','先固定断言契约，再验证常数 2 与 signed/unsigned、X/Z 输入。'),
('P11','unsized_literal','部分支持','无尺寸常量、宽度和符号上下文','总数包含端口宽度、范围和静态下标，不能把 371,487 个节点全部当作不支持的数据表达式。','官方类型 AST 能补足上下文；本轮未输出全设计类型 AST。','挑数据上下文中的无尺寸常量，与已覆盖定宽转换比较宽度和符号扩展。')]


def build(stats,context):
    features=stats['features'];rows=[]
    evidence=context['support_evidence']
    for priority,key,status,title,limit,normalization,experiment in POLICIES:
        f=features.get(key,{});example=f.get('examples',[{}])[0]
        if key=='async_reset_candidate':example=dict(file='LevelGateway.sv',line=12)
        if key=='process_local_declaration':example=dict(file='CAMTemplate.sv',line=30)
        if key=='unpacked_array':example=dict(file='ram_2x340.sv',line=14)
        if key=='assignment_pattern':example=dict(file='BlockCipherModule.sv',line=29)
        rows.append(dict(priority=priority,feature=key,title=title,status=status,
                         syntax_occurrences=f.get('syntax_occurrences',0),module_definitions=f.get('module_definitions',0),
                         affected_instances=f.get('affected_instances',0),example_file=example.get('file',''),example_line=example.get('line',''),
                         support_evidence='support-evidence.json; scripts/fourstate_elaborated.py; scripts/fourstate_frontend.py',
                         limitation=limit,normalization=normalization,minimal_experiment=experiment))
    representatives={r['module']:r for r in stats['representative_subtrees']}
    candidates=[]
    for name,reason in [('PriorityMuxModule_25','三个条件合并、纯组合、无子实例；先测可支持子集的真实复用。'),
                        ('CAMTemplate','单 posedge、一个 automatic 临时量及阻塞计算、8 个 NBA 状态目标；隔离过程局部变量缺口。'),
                        ('LevelGateway','一个异步复位过程及一个状态目标；隔离影响最大的异步控制缺口。')]:
        c=dict(representatives[name]);c['reason']=reason;c['conversion_executed']=False;candidates.append(c)
    summary=dict(format='fourstate-xstop-static-audit-v1',status='STATIC_AUDIT_COMPLETED_WITH_LIMITATIONS',
                 run_id=context['run_id'],scope='First static audit only; no four-state conversion, RTL simulation, Yosys FunctionalIR generation or Lean compilation.',
                 provenance=context['provenance'],source_snapshots=context['source_snapshots'],
                 parser=context['parser'],execution=context['execution'],
                 definitions=stats['definitions'],hierarchy=stats['hierarchy'],state=stats['state'],
                 features=features,clocks=stats['clocks'],preprocessing=stats['preprocessing'],system_calls=stats['system_calls'],
                 gaps=rows,f32_candidates=candidates,support_evidence=evidence,
                 safety=context['safety'],tests=context['tests'],
                 audited_absent_active_features=['initial','final','always_comb','always_ff','negedge_event','case_statement','casez_statement',
                     'casex_statement','case_equality','case_inequality','multiply','divide','generate','parameter','user_function','dpi_import','z_literal'],
                 limitations=[
                    'Only the explicitly recorded default CLI macro profile was elaborated. Inactive initial/DPI branches remain outside active syntax counts.',
                    'Feature impacts count instances whose OWN module has the feature; parent transitive impact is separate in representative_subtrees. Categories overlap.',
                    'Clock endpoints follow only direct identifiers and aliases; no architectural clock-domain proof, X/Z propagation proof, or timing simulation.',
                    'Whole-register target names are not state bits or netlist FF counts. Unpacked declarations are not a synthesized RAM count.',
                    'CLI CST has no source positions. Automated anchors can identify a module or first matching token; curated source-evidence JSON provides exact representative lines.',
                    'No complete typed AST was retained; some width, signedness, constant-index, reset-polarity and driver-resolution details require later experiments.',
                    'Lightweight return package contains facts and selected receipts, not all RTL/CST/tool assets; those remain in the isolated server run.'])
    external=context['external_models'];summary['external_models']=external
    def number(key,field='syntax_occurrences'):return features.get(key,{}).get(field,0)
    p=context['provenance'];h=stats['hierarchy'];d=stats['definitions'];s=stats['state'];clock=stats['clocks']
    lines=[
        '# F3.1 完整 XSTop 四态能力缺口：第一轮静态审计',
        '',
        '本轮完成真实 RTL 静态解析、官方层次展开及现有四态能力对照。状态为 `STATIC_AUDIT_COMPLETED_WITH_LIMITATIONS`。没有进行 F3.2 转换、RTL 仿真、Yosys 转换或 Lean 编译；没有新增四态功能。',
        '',
        f"运行：`{context['run_id']}`。服务器结果：`/data2/home/lvhongqing/cgt/chisel2lean-fourstate/runs/{context['run_id']}/reports/`。",
        '',
        '## 来源和实际执行',
        '',
        f"实际取得并检查 **{p['rtl_files']} 个 RTL 文件，{p['rtl_bytes']:,} 字节**；{p['model_hash_matches']}/{p['rtl_files']} 个文件哈希与原模型 manifest 对应。历史约 1.2 GB 不能作为 RTL 正文字节数；原输入目录还含已编译的 obj_dir，本轮排除它。",
        '',
        f"`XSTop.sv` SHA256：`{p['xstop_sha256']}`。982 个源文件的来源路径、字节数、哈希和前后稳定性元数据见 `inputs.json`。",
        '',
        '**DefaultConfig 来源尚未确认。** `SERVER-BUNDLE.json`、`validation-xiangshan-full-7.3.json` 和 native-import 记录均标注 DefaultConfig/1 core，并记录上游提交 `997cd5b35cfbd26586674aa553d0f04b27914cb2`、FIRRTL 哈希；但原始生成与 lowering 收据所指的 `experiments/xiangshan-full-7.3/20261015T083406Z-cc618ef8/` 在所查来源副本中缺失，打包脚本配置标签又为固定值。因此已确认本批字节与模型来源相符，不能把配置标签提升为完整生成哈希链已证实。也未确认生成本批 RTL 的确切 firtool 命令/版本。',
        '',
        '模型记录的 7,902,969 节点和 Lean 4.19.0 得到 manifest 佐证，属于记录核对；本轮没有重数模型或重新运行 Lean。',
        '',
        f"实际解析器为 `{context['parser']['version']}`，使用既有官方 CLI 的独立只读副本。Linux Python wheel 未安装；没有把 CLI 版本说成已完成 pyslang Python Linux 适配。982 次逐文件 parse-only 命令全部退出 0，CST 提取错误为 0。`DifftestMacros.v` 只含宏定义，因此 982 个文件对应 981 个模块定义。",
        '',
        '首次层次命令误带 slang-hier 不支持的 `-q --disable-analysis`，退出 1；失败日志保留。修正后的 `slang-hier --top XSTop --threads 1 --custom-format ... -f audit-files.f` 实际退出 0、stderr 为空，耗时约 5 秒。原始 CST 与第一次事实表保留，修正后的分类以 `modules-v3.json.gz` 为准；离线重放不重新调用解析器。',
        '',
        '首次报告发送因远端 Python 拒绝中文 stdin 源字节而在载荷执行前退出 1；未写报告。审计入口改为 ASCII 转义传输并新增测试，Python 接收后还原原始 Unicode 文本；失败收据保留。',
        '',
        '## 统计口径与模块层次',
        '',
        '| 项目 | 结果 |', '| --- | ---: |',
        f"| 模块定义出现数 / 不同定义名 | {d['occurrences']} / {d['distinct_names']} |",
        f"| 源码实例声明 | {h['source_instance_declarations']} |",
        f"| 官方 XSTop 展开实例（包含顶层） | {h['instances_including_top']} |",
        f"| XSTop 可达模块类型 / 不可达类型 | {d['reachable_types']} / {len(d['unreachable_types'])} |",
        f"| 重名定义 / 未解析模块类型 / 源码图循环 | {len(d['duplicate_names'])} / {len(h['elaborated_undefined_types'])} / {len(h['source_graph_cycles'])} |",
        f"| 显式黑盒属性 | {h['explicit_blackbox_attributes']} |",
        '',
        '本批活动语法没有 parameter/generate/实例数组歧义，带重数的无条件定义图独立计算结果与官方 21,024 个实例完全一致。模块多次复用数量与每个层次路径保存在 `aggregate.json`、`hierarchy-v2.json`；定义数不能与实例数互换。',
        '',
        f"上游记录中 external 定义对应本批 {external['types']} 个类型、{external['instances']} 个实例：ClockGate 为实际锁存器实现（136 次）；11 个 DiffExt 观察模块共 30 次，默认宏环境只有占位逻辑，DIFFTEST/DPI 分支未激活。这不是 166 个未解析黑盒；启用 DIFFTEST 的外部接口尚未审计。",
        '',
        '## 主要语法事实',
        '',
        '出现次数取自官方 CST 节点；“涉及实例”只统计自身定义含该结构的实际实例，不自动包含其祖先。各行允许重叠。',
        '',
        '| 结构 | 源码次数 | 模块定义数 | 涉及实例 |', '| --- | ---: | ---: | ---: |']
    for key,label in [('always','always'),('always_latch','always_latch'),('async_reset_candidate','异步控制候选'),
                      ('synchronous_conditional_control_candidate','单事件条件控制候选'),('nonblocking_assignment','NBA'),
                      ('process_local_declaration','过程局部声明'),('procedural_blocking_assignment','过程阻塞赋值'),
                      ('unpacked_array','未打包数组声明'),('multidimensional_packed','多维 packed 声明'),
                      ('nonliteral_index','非字面量 bit/元素下标'),('indexed_part_select','indexed part-select'),
                      ('x_literal','X 字面量'),('conditional_merge','条件表达式'),('logical_equality','逻辑相等'),
                      ('immediate_assert','immediate assert'),('assignment_pattern','赋值模式')]:
        lines.append(f'| {label} | {number(key)} | {number(key,"module_definitions")} | {number(key,"affected_instances")} |')
    lines += ['',
        f"另有 {s['unique_whole_identifier_nba_targets']:,} 个模块内唯一整标识符 NBA 目标，按实例加权为 {s['instance_weighted_whole_identifier_nba_targets']:,}。它们不是寄存器位数或综合 FF 单元数；数组/部分写目标和锁存器 EN 另列。974 个边沿过程展开加权为 {number('edge_process','instance_weighted_syntax_occurrences'):,} 个过程，另有 136 个 latch 实例。",
        '',
        '单事件条件控制包含使能、状态条件和可能的同步复位，不能将其全部叫同步复位。448 个多事件过程根据顶层条件引用事件信号识别为异步控制候选；LevelGateway.sv:12 和 ResetGen.sv:9 的代表源码确认为 posedge reset 异步复位。',
        '',
        '活动语法中的 initial、case/casez/casex、四态相等运算、乘除、负边沿、参数/generate、用户函数、DPI import 和 Z 字面量计数为 0；这是本批宏配置下的结构事实，不能外推至完整 SystemVerilog 或其他生成配置。条件表达式的 X/Z 合并需求仍存在，且没有 Z 常量不表示输入永远没有 Z。',
        '',
        f"原始注释/字符串过滤后的词法扫描仍发现 initial {stats['preprocessing']['noncomment_raw_keyword_occurrences'].get('initial',0)} 处。它们在未启用 ENABLE_INITIAL_REG_ 等条件下不进入本轮活动 CST；DIFFTEST 分支同理。宏及 include 统计单列为词法事实，不能与活动语法相加。",
        '',
        f"系统调用：`{json.dumps(stats['system_calls'],ensure_ascii=False)}`。$error 与断言、$fwrite 的事件行为未被当前四态模型支持；$signed/$unsigned 在受限单参数子集中有已有测试依据。",
        '',
        '## 时钟、复位及四态范围',
        '',
        f"4 个定义、9 个实例含多个局部时钟表达式；不能据此断言存在 9 个独立时钟域。直接端口/别名追踪得到 {clock['endpoint_count']} 个来源端点，其中根输入为 `{', '.join(clock['top_input_sources'])}`，另有 {clock['unresolved_or_derived_endpoints']} 个派生或未解析端点。`architectural_clock_domain_count=null`。完整路径、边沿及代表来源见 summary/aggregate 的 clocks；遇逻辑、状态、多驱动或复杂表达式就停止，未作时序等价或 CDC 证明。",
        '',
        '9 个局部双时钟表达式实例的 R0_clk/W0_clk 全部沿直接连线追踪至同一 XSTop.io_clock；因此它们不构成 9 个独立域需求。整机仍有两个根时钟来源、136 个门控输出，以及 JtagTapController.sv:22 的 clock_falling=~clock；该反相时钟在 :29 用 posedge 触发，静态驱动追踪关联到 JTAG TCK。因此 negedge 语法为 0 不能解释为没有下降沿行为。',
        '',
        'ClockGate.sv:10–13 保存 EN 的锁存状态，再输出 CK & EN；不能通过把门控时钟当二值使能来直接宣称四态等价。X 字面量集中在 93 个数组模块（920 次实例化）的读数据路径；本轮只识别语法来源，没有证明动态 X/Z 传播。',
        '',
        '## 当前支持矩阵及缺口排序',
        '',
        '已有测试证据来自本地 backend-fix 主报告及其 8 个子报告的实际文件。5 个当前四态核心源码哈希与主报告的快照一致，8 个子报告哈希与父报告一致。本轮没有重跑这些已完成的硬件实验；有限用例通过不推出整类语义或本批模块已通过。',
        '',
        '| 分类 | 当前边界与证据 |', '| --- | --- |',
        '| 已支持 | 已测固定宽度四态组合运算、条件合并、比较、静态选择、有限 signed/unsigned 转换，以及同一直接二值 posedge 时钟下的整寄存器 NBA/if/普通 begin/end、层次多实例。具体证据见 support-evidence.json。 |',
        '| 部分支持 | 多维 packed 只限已实现的内部 word wire 选择；不能推广到任意动态 bit、数组或多驱动。无尺寸常量只在静态宽度/范围等受限上下文可接受；数据上下文仍拒绝。 |',
        '| 未支持 | 当前入口的宏/include、过程局部变量/阻塞过程赋值、异步控制、未打包数组、latch/门控/独立多时钟、断言/打印、赋值模式、归约 XOR 与取模。 |',
        '| 待验证 | 原始 DefaultConfig 完整来源链；局部时钟是否同源与架构域数；全设计宽度/常量下标分类；官方规范化对本批原始 RTL 的四态保真；未激活 initial/DPI 配置。 |',
        '',
        '下表按原始入口阻塞、真实实例影响、共同缺口与最小实验成本排序；这是开发建议，不是已经实现或通过的清单。',
        '',
        '| 顺序 | 缺口 | 类型 / 实例 | 后续最小实验 |', '| --- | --- | ---: | --- |']
    for row in rows:
        lines.append(f"| {row['priority']} | {row['title']}（{row['status']}） | {row['module_definitions']} / {row['affected_instances']} | {row['minimal_experiment']} |")
    lines += ['',
        '完整 CSV 另列每项出现次数、代表文件/行号、实现/测试依据、局限及规范化判断。unsized_literal/nonliteral_index 是宽口径语法需求，不是精确失败数。既有 disallowPackedArrays 的 Z 选择器反例说明官方规范化也不能直接视为四态等价；disallowLocalVariables 仍需按具体布局建立原始参考契约。',
        '',
        '## F3.2 候选（本轮未执行）',
        '',
        '| 模块 | 子树实例 / 类型 | 整颗中的次数 | 选择理由和阻塞 |', '| --- | ---: | ---: | --- |']
    for c in candidates:lines.append(f"| {c['module']} | {c['subtree_instances']} / {c['subtree_module_types']} | {c['instances']} | {c['reason']} |")
    lines += ['',
        '建议先做 PriorityMuxModule_25 的现有子集摸底，再用 CAMTemplate、LevelGateway 分别记录局部变量与异步控制的首个明确拒绝。后两者不是当前可转换的承诺，也不要求先实现它们。AluDataModule、L2TlbPrefetch 的旧实验未重跑。',
        '',
        '## 复现、资产与安全',
        '',
        '原工程只用逐级 O_NOFOLLOW/O_NOATIME 读取；所有写入都经独立工作区 Guard，文件独占创建、失败保留。输入副本约 133 MiB；原始 CST gzip 合计 41,992,409 字节，留在服务器。开始可用磁盘约 154 GiB；安全复核约 153.62 GiB 可用，原 RTL 清单及文件稳定性元数据、两份既有探测文件哈希均未变。没有扫描其他服务器项目、安装软件、清理或覆盖已有数据。',
        '',
        '每个解析进程最多 3 GiB / 45 秒 CPU、单次墙钟 55 秒；官方层次最多 6 GiB / 900 秒 CPU；事实重放父进程 8 GiB，30 分钟总墙钟预算；nice=10，解析子进程限制到两个可用 CPU 且 --threads 1。预算是限制，不是实际峰值测量。首次全扫描约 208 秒；命令和实际退出码见 parse-results.json、hierarchy-v2-command.json、reanalysis-v3.json。',
        '',
        f"本轮审计工具测试 {context['tests']['audit_tests']} 项、同步安全测试 {context['tests']['sync_tests']} 项实际通过。它们验证采集/统计工具，不是硬件差分。修正分类前后的失败和中间事实表保留，最终统计按 v3 事实和当前 aggregation 脚本重放。",
        '',
        '轻量回传包含 summary.json、report.md、gaps.csv、aggregate.json、压缩模块事实、官方层次、输入/哈希清单、解析收据、代表源码片段、支持证据和安全收据。完整 RTL、原始逐文件 CST、工具副本及原始大元数据留在服务器；回传包不是完整离线硬件复现包。',
        '',
        '离线只重放聚合（指定新的输出文件，禁止覆盖）：',
        '',
        '```powershell',
        'python -B scripts/verification/four_state/audit_fourstate_analysis.py --facts <reports>/modules-v3.json.gz --hierarchy <reports>/hierarchy-v2.json --preprocessing <reports>/preprocessing-v3.json --output <new-output.json>',
        '```',
        '',
        '审计入口已提供 server 子命令，具体请求、SSH stdin 源码、argv、stdout/stderr、退出码保存在本地本次 runs 目录。大型输入的服务器重放使用 reanalyze 新版本名，读取保留 CST 并逐文件校验原有哈希，不重新解析、不访问原工程正文。报告生成器 build(stats, context) 及 context 记录在 reproduction.json。',
        '',
        '尚不能判断：未激活宏组合的完整语义、四态异步事件调度、所有宽度/符号上下文、未知地址及并发写内存行为、门控时钟的 X/Z 边沿行为，以及整颗四态转换/执行可行性。没有把静态审计完成标为“整颗四态已支持”。','']
    return summary,'\n'.join(lines),gaps_csv(rows)
