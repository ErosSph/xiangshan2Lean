# 独立四态 RTL → Lean 实验入口

当前目标是在同一工程中开发独立四态实验入口，不替换默认二态流程。
固定宽度四态运算、单时钟寄存器和同步复位，以及固定参数模块层次与 generate 子集已完成三方差分。
支持范围以本文件列出的语法为准，不承诺完整 SystemVerilog、任意时序电路或完整香山四态支持。

## 当前状态与职责

| 内容 | 状态 |
| --- | --- |
| 文档与协作基线 | 已完成，文档检查通过；不代表四态功能实现 |
| 四态架构、编码、首阶段范围和验证方法 | 已实现下述限定子集 |
| 四态 RTL 前端、语义表示和编码器 | 已实现，基于 pyslang 原始语法树及类型分析 |
| 四态独立 CLI、端口映射产物和差分驱动 | 已实现，实际 CLI 转换与回放通过 |
| 原始 RTL、编码 RTL、Lean 三方比较 | 已验证 3 个设计、197 个采样，详见下方独立报告 |
| 单时钟显式状态转移与时序回放 | 已验证 7 个场景、3,584 个采样，详见时序报告 |
| 有符号类型、上下文位宽和显式转换 | 已验证 2 个新设计、100 个采样，详见运算扩展第一批报告 |
| 逻辑运算、四种相等运算和大小比较 | 已验证 3 个新设计、336 个采样，详见运算扩展第二批报告 |
| 加减及移位 | 已验证 4 个新设计、772 个采样，详见运算扩展第三批报告 |
| 模块层次、固定参数、generate 与全设计同时更新 | 审计修正后已验证 5 个场景、340 个采样及独立状态清单，详见层次报告 |
| 真实 Nanhu AluDataModule | 已验证 20,931 个采样；使用经用户确认的官方布局参考，限制及报告见下方 |
| 现有二态后端 | 已实现；历史证据见 [Yosys 入口](yosys-frontend.md)，不构成四态验证 |

当前实现路径：

```text
保留 X/Z 信息的原始 RTL
  → 四态前端：解析、位宽和支持范围检查
  → 四态语义表示：保留 0/1/X/Z、操作及源码位置
  → 编码器：生成 tag/value 二态 RTL 和端口映射
  → 现有 Yosys / FunctionalIR / Lean 后端
  → 执行生成的 Lean，按映射解码结果
```

输入必须来自保留四态信息的原始 RTL，不能从已经生成的二态模型恢复 X/Z。
原始文件保留用于独立参照；编码前不能先经过丢失未知值的优化或二态补全。
现有 [Yosys 转换器](../scripts/yosys2lean.py) 使用 `setundef -anyseq` 暴露任意输入，
属于二态补全语义。[现代 FIRRTL 入口](modern-firrtl.md) 会拒绝显式未知值，
其官方规范化可能消去未知分支，因此不能直接作为本设计的保真四态前端。

四态前端负责原始语义和拒绝诊断，编码器负责将四态运算实现为确定的二态逻辑。
现有后端只处理编码后的二态位向量，不负责恢复未知值或推断四态真值表。
前端使用固定 pyslang 12.0.0。平坦 v3 先审计原始语法树，再使用官方类型分析确定信号位宽、
声明范围和引用；v4 导入官方已展开语义树，仅审计选定顶层实际生成的硬件作用域。
运行时死分支必须检查，不允许被常量折叠掩盖；静态未选 generate 分支的规则见下方层次说明。
原始 RTL 中的预处理指令和宏在预处理之前拒绝。

## tag/value 与端口约定（已实现）

每个原始宽度为 W 的数据端口拆成两条 W 位轨道，方向与原端口一致。
以下编码顺序为 `(tag, value)`，不是 `(value, tag)`：

| 原始状态 | tag | value |
| --- | --- | --- |
| 0 | 0 | 0 |
| 1 | 0 | 1 |
| X | 1 | 0 |
| Z | 1 | 1 |

`value` 在 `tag=1` 时仍有意义，用来区分 X 与 Z，不能作为无关位掩掉。
使用 `<原端口名>__tag` 和 `<原端口名>__value`。映射记录原始名称、方向、
位宽、声明范围与位序，以及两条编码端口的名称和逐位对应关系；不能仅靠后缀猜测。
编码向量按 `[W-1:0]` 表示，位 0 对应原向量最低有效位（声明范围右端），
升序声明也显式记录映射，`bit_indices[i]` 给出编码位 i 的原始下标。
发生名称冲突时明确拒绝，不静默改名；生成的内部节点名避开已有名称。

直接连接、切片和拼接逐位保留 Z。按位逻辑采用四态真值表：
例如 `0 & X = 0`、`1 | Z = 1`，取反 X/Z 均为 X，异或遇到 X/Z 为 X。
一位条件为 0/1 时选择对应分支；为 X/Z 时逐位合并两分支，
相同状态保留（包括 X/X、Z/Z），不同状态产生 X。
一位运算及条件表达式已通过全部四态输入组合的三方比较。

组合模式没有硬件状态、时钟或复位，也不假设零初态。执行器向无状态模型传空初态对象。
生成模型若出现状态、时钟、事件或额外任意输入，独立入口直接拒绝，不能悄悄填零。
时序模式的寄存器通过显式状态转移接口处理，见下方时序约定。

## 组合模式范围（已实现）

平坦 v3 输入限定单文件、单模块、ANSI 端口，简单标识符和非负十进制常量下标，至少一个输出。
多文件、参数和 generate 的 v4 范围见下方层次说明，结构下标使用官方常量求值结果。
数据使用四态 `wire` / `logic`，允许有符号声明和单个 packed 维度；赋值左侧仅支持完整信号。
v5 另支持内部 wire 的二维 packed 字向量，范围与限制见下方真实 ALU 接入说明。
当前新转换按所支持表达式的上下文位宽执行隐式扩展或截断；截断保留低位。
零扩展补 `(tag,value)=00`，符号扩展复制最高位的完整状态，包括 X/Z。
支持 `$signed/$unsigned`、正十进制定宽转换 `N'(expr)` 和定宽有符号常量；
无尺寸常量仍拒绝。旧组合及其历史报告对应此前的等宽无符号范围。
显式位宽的二、八、十、十六进制常量按 RTL 字面量规则填充或截取，包括 X/Z 填充。

| 结构 | 当前行为 |
| --- | --- |
| 固定宽度、可有符号、无状态组合电路 | 支持限定语法；层次和参数走 v4 |
| 有明确位宽的 0/1/X/Z 常量、连续赋值 | 支持 |
| 按位取反、与、或、异或及其取反形式 | 支持四态真值表 |
| 静态切片、拼接、一位条件的条件表达式 | 支持明确位宽和位序的形式 |
| 寄存器、存储器、过程块 | 组合模式拒绝寄存器和过程；存储器均拒绝 |
| 多驱动、三态解析、inout、驱动强度、延时 | 拒绝 |
| 有符号声明、定宽常量、显式 signed/unsigned 与定宽转换、扩展和截断 | 已验证 |
| `!`、`&&`、`||`、`==`、`!=`、`===`、`!==`、`<`、`<=`、`>`、`>=` | 已验证四态结果 |
| 一元/二元 `+`、`-`，`<<`、`>>`、`<<<`、`>>>` | 已验证限定语法与输入范围 |
| 乘除、取模及其他未列结构 | 拒绝 |
| 固定整型参数、模块实例、generate if/case/for | 支持下方 v4 子集 |
| 宏、include、非 ANSI 端口、无尺寸数据常量 | 拒绝 |
| 动态标量位选、部分左值、多维端口/寄存器、unpacked 数组、属性、用户函数 | 拒绝；内部 packed 字索引见 v5 说明 |

单驱动数据中的 Z 可以编码，不意味着支持总线电气解析。
未驱动网络、组合环和不明确的位宽处理带文件、行列及结构名称拒绝，
不能借助二态后端的任意输入机制静默接受。
扩展范围时必须同时更新本文件、实现及对应验证证据。

## 三方比较与证据

1. 用 Icarus 执行未改写的原始 RTL，输入和输出保留逐位 0/1/X/Z。
2. 将同一输入按本约定编码，独立运行生成的编码 RTL；两条轨道必须全部为 0/1。
3. 向实际生成的 Lean 提供相同编码输入，检查执行成功及定义域条件后取得结果。
4. 在相同输入稳定后的组合逻辑采样点，按映射解码编码 RTL 与 Lean 输出，
   同原始 RTL 比较全部端口的全部位，并比较编码 RTL 与 Lean 的两条轨道。

X/Z 必须精确比较，不能使用通配符匹配、跳过未知位或把未知位转为零。
编码轨道意外出现 X/Z、输出缺失、位宽或采样数不符均判为失败。
三条路径分别保存原始输出，不能用编码 RTL 的输出代替 Lean 执行结果。
现有 Verilator 二态实验不能用作此处原始 RTL 四态参照。

已覆盖所有一位操作真值表、X/Z 条件合并、混合四态向量、位宽与升降序位序、
静态切片和拼接，以及下方报告列明的拒绝结构。故障注入实际修改编码 RTL 的输出轨道，
交换 X/Z 后重新用 Icarus 运行，比较器检测到差异。有限差分通过不等于转换器的通用正确性证明。

生成产物使用仓库根目录下的 `generated/fourstate/`；每次实验使用
`experiments/fourstate/<run-id>/`，保存自己的报告，不覆盖历史实验。
转换和回放目录必须是 `generated/fourstate/` 或 `experiments/fourstate/` 的独立子目录；
非空目录拒绝覆盖。`verify_fourstate.py` 每次在证据根目录下建立新的运行目录。

每次实验应保存原始 RTL、配置、测试输入与源码位置，四态表示、编码 RTL、端口映射、
生成模型及其 SHA256；记录工具路径、版本、关键工具哈希、完整命令、退出码和日志。
同时记录 Git HEAD、工作区状态、相关未提交差异及新增源码文件的内容和哈希，
使输入、驱动和模型对应实际执行版本，不能仅记录一个提交号。
三方请求、输出、比较数量及失败样例须可追溯；旧报告的状态、哈希和结论不得手工改写。

## 运行命令与产物

在仓库根目录执行。解析器安装锁见 [固定清单](../verification/fourstate/parser-lock.json)，
安装到 `.tools/pyslang-12.0.0-cp<版本>/`，不改系统 Python。
pyslang 12.0.0 的 wheel 另需 nanobind-backend 1.0.0，二者均固定 SHA256。
当前锁含 Windows x64 CPython 3.11、3.13；本轮实际执行的是 Python 3.13.13，未验收 3.11 安装。
Yosys / Lean 安装沿用 [现有说明](yosys-frontend.md)，Icarus 的 `iverilog` 和 `vvp` 需在 PATH 中。

以下转换及回放命令已实际执行成功。重复运行时须使用新的输出及证据目录：

```powershell
python -B scripts/bootstrap_fourstate.py
python -B scripts/fourstate2lean.py verification/fourstate/Operators.sv --top Operators --out generated/fourstate/operators-example-v1
python -B scripts/fourstate_simulate.py generated/fourstate/operators-example-v1/fourstate-manifest.json --trace experiments/fourstate/20261016T141220Z-2af4545a/Operators/trace.jsonl --evidence experiments/fourstate/cli-20261016-v1/replay
python -B scripts/verify_fourstate.py --evidence experiments/fourstate
```

回放示例使用已保存的实验输入；全新检出若无实验产物，先运行最后一条生成新的轨迹，
再替换 `--trace` 路径。默认使用原生 Yosys 和 source Lean 后端，生成时实际编译 Lean。
输入轨迹为 JSONL，每行一个对象，例如：

```json
{"inputs":{"a":"x","b":"z","c":"1"}}
```

每个值必须是与原始位宽严格相等的 `01xz` 小写字符串，从最高有效位到最低有效位排列。
缺失、多余端口、错误位宽和非法字符均拒绝；不自动补值。
回放结果包含样本序号和解码后的原始输出名，底层 Lean 请求与输出另行保存。

| 产物 | 用途 |
| --- | --- |
| `original.sv`、`fourstate.ir.json` | 原始 RTL 副本及四态节点、赋值依赖、源码位置 |
| `encoded.sv`、`ports.json` | tag/value RTL 和逐位端口映射 |
| `model/`、`translation/` | 现有后端产物、独立来源清单及编译日志 |
| `fourstate-manifest.json` | 串联原始源码、映射和模型哈希；`COMPILED` 仅表示编译成功 |
| `source-snapshot/` | 实际四态脚本、测试源码、依赖锁和文档快照，以及 HEAD、工作区状态和差异 |
| 实验 `summary.json` | 三方结果、拒绝和故障检查、工具版本与哈希、全部实验产物哈希 |

回放先验证清单记录的产物哈希和编码接口；映射或模型损坏不能继续执行。
底层二态后端清单保持原有语义说明，四态语义由外层清单、原始源码和编码实现共同说明。

## 组合阶段验证结果

2026-10-16（Asia/Shanghai），源码基线仍为 `main` /
`20eaf4f3d08bdeb572dbf4384dbc4b7447ed7060`。本轮代码与文档均为未提交增量，
实际执行源码、配置和输入由报告中的快照及哈希确定，不能仅凭该提交号复现。

[三方及边界报告](../experiments/fourstate/20261016T141220Z-2af4545a/summary.json) 保存最终代码的完整实验：

| 场景 | 实际结果 |
| --- | --- |
| Operators：全部一位三输入四态组合，含条件表达式 | 64 个采样、576 个输出位比较 |
| Vectors：4/65 位、升降序与非零下标、混合 X/Z、多级依赖 | 132 个采样、18,744 个输出位比较 |
| Literals：无输入、不同进制和显式位宽填充/截取 | 1 个采样、64 个输出位比较 |
| 语法、位宽、驱动和接口拒绝检查 | 42 项通过，包括死分支算术和失活预处理分支 |
| 实际 RTL X/Z 交换、缺拍/缺输出、资产损坏、非法输入及覆盖保护 | 11 项通过 |
| 同一 Operators 原始源码的默认二态语义对照 | 8 个全已知输入采样通过 |

合计 197 个采样、19,384 个输出位位置完成三方精确比较；该数量不把两条比较边或
两条编码轨重复计数。另逐项比较编码 RTL 与 Lean 的原始轨道值。
随机种子为 `410161`。三个模型均实际完成 Lean 编译和执行，没有状态或额外任意输入。
CLI 独立执行记录见 [转换日志](../experiments/fourstate/cli-20261016-v1/0/result.json) 和
[回放日志](../experiments/fourstate/cli-20261016-v1/1/result.json)，三个新 CLI 的帮助命令也实际退出 0。

本轮实际使用 Python 3.13.13、pyslang 12.0.0、nanobind-backend 1.0.0、
Yosys 0.70+16 / `3bb533450`、Lean 4.19.0 / `6caaee842e94`、Icarus/vvp 13.0。
首次安装 pyslang 时发现缺少 nanobind-backend，补充项目内依赖锁后成功；没有替换系统工具链。
较早的探针与第一轮报告保留，不手工改写其状态或哈希。
最终文档更新晚于实验快照，不影响报告记录的执行源码版本；未运行整颗或完整框架回归。

[交付复核](../experiments/fourstate/cli-20261016-v1/delivery-check.json) 已重新校验报告记录的
781 个产物哈希，确认当前实现及测试源码匹配实验快照，独立 CLI 回放匹配原始 RTL。
新增 Python 文件语法、文档本地链接与 `git diff --check` 均通过，共享后端文件未修改。

## 单时钟寄存器与同步复位（已实现并验证）

时序模式采用“显式状态转移＋采样驱动”。编码 RTL 接收非时钟输入和所有寄存器当前态的
tag/value，输出原始输出和所有寄存器的下一态。后端生成的模型仍是无隐藏状态、
无时钟、无额外任意输入的组合函数；不是直接复用 Yosys 原生寄存器状态。

独立生成的 `RunSequential.lean` 在 Lean 中保存编码寄存器状态、判断时钟边沿、
调用实际生成的 `evaluate`，同时提交下一态后重新计算输出。Python 只校验、编码、
启动和解码，不替代 Lean 计算状态转移。Icarus 的编码 RTL 包装独立保存和更新状态轨。

### 支持范围与语义

支持 `always @(posedge clk)`、`always_ff @(posedge clk)`、`begin/end`、
嵌套一位 `if/else`、完整寄存器左值的非阻塞赋值，以及 `logic/reg` 寄存器。
多个过程可共享同一个直接连接的一位输入时钟，但每个寄存器只能由一个过程驱动。
同步高/低有效复位、使能和保持由实际过程语句决定，不按端口名称猜测。
右侧沿用组合子集；当前 `!` 可接收多位操作数，在组合及该时序模式中均可使用。

过程 `if` 仅在条件为 1 时进入真分支，0/X/Z 均走假分支；`?:` 仍按四态逐位合并。
非阻塞赋值右侧和条件都读取旧态，同一过程最后执行的赋值优先，未赋值则保持。
全部寄存器同时提交；跨寄存器反馈合法，纯组合环仍拒绝。

时序模式继续拒绝异步复位、多时钟、下降沿触发、门控时钟、时钟作为数据、阻塞赋值、
过程内局部声明、循环、case、延时、initial、声明初始化、部分寄存器赋值、
存储器。层次设计使用下方 v4 路径；混合连续/过程驱动和跨过程重复驱动也拒绝。
原组合模式仍默认拒绝过程块，不因新增时序入口而放宽旧契约。

### 初态、轨迹与接口版本

转换增加 `--mode sequential --clock <原始时钟端口名>`；默认仍为 `combinational`。
历史时序产物使用 v2，历史组合产物使用 v1；当前平坦转换产物使用 v3，层次展开使用 v4，
本轮真实 ALU 所需的新操作及 packed 类型布局使用 v5。
加载器继续兼容旧 v1/v2/v3。v3 在信号和表达式节点记录 signed、求值位宽及调整节点，
时序模式仍显式记录时钟和状态映射；原有 tag/value 端口命名不变。
公共后端、共享 IR、运行时和原有二态 CLI 没有接口变化。

v2 映射新增 `mode`、`clock`、`states`。时钟端口标记为 `role: clock`，不进入编码 RTL。
每个寄存器记录原始名称、位宽、位序、来源和过程，以及 `current_tag/current_value`、
`next_tag/next_value`；编码名称分别使用 `__state_tag/__state_value`、
`__next_tag/__next_value`，碰撞时拒绝。原始输出仍按既有 tag/value 映射观察。

时序回放必须提供 `--initial-file`，JSON 对象逐个给出所有原始寄存器的等宽 `01xz` 字符串。
不默认填零或全 X，缺失、多余名称及非法值均拒绝。例如 SequentialControl 的初态为：

```json
{"q":"x","stage":"x","chosen":"x","priority_q":"x","hidden":"x"}
```

JSONL 的每行 `inputs` 包含全部原始输入和时钟。时钟只能为字符串 `"0"` 或 `"1"`，
第一行必须为 0；0→1 行的所有非时钟输入必须与前一行一致，保证边沿前稳定。
相同电平和下降沿不更新寄存器；无有效边沿时改变同步复位也不更新。
数据和复位可包含 X/Z。该约定不覆盖任意延时或竞态。

每行结果包含 `sample`、`clock`、`rising`、`pre`、`post`；两个阶段各有 `outputs` 和
`states`，均解码回原始名称及四态字符串。`pre` 在本行非时钟输入稳定后、边沿前观察；
`post` 在可能的同时更新及组合逻辑稳定后观察。首行没有有效边沿。

### 原始 RTL 初始化与实际运行

原始 RTL 保持不变，只在测试平台首个采样前一次性 deposit 指定寄存器初态，之后不覆写。
本机 Icarus 13.0 内置 `$deposit` 在实际测试中把 X 写成了 0，
[失败记录](../experiments/fourstate/sequential/20261016T143227Z-0434f324/summary.json) 保留。
因此测试平台使用 [deposit4.c](../verification/fourstate/deposit4.c) 注册的
`$fourstate_deposit`：通过 VPI `vpiVectorVal` 和 `vpiNoDelay` 一次性写入完整四态向量。
它没有 force、持续回调或硬件转移逻辑；X/Z 和 65 位初态已在三方测试中核对。

辅助模块用项目内 `.tools/w64devkit/bin/gcc.exe`（本轮 GCC 16.2.0）构建，
使用 PATH 中 Icarus 安装的 VPI 头文件与库。每个原始 RTL 实验保存编译命令、退出码、
辅助源码、编译器、VPI 头/库及生成模块的哈希，不修改系统工具链。

以下命令已实际执行成功；重复运行须使用新的非空检查通过的输出和证据目录：

```powershell
python -B scripts/fourstate2lean.py verification/fourstate/SequentialControl.sv --top SequentialControl --mode sequential --clock clk --out generated/fourstate/sequential-example-v1
python -B scripts/fourstate_simulate.py generated/fourstate/sequential-example-v1/fourstate-manifest.json --trace experiments/fourstate/sequential/20261016T143541Z-a8360f4b/SequentialControl/initial-x/trace.jsonl --initial-file experiments/fourstate/sequential/20261016T143541Z-a8360f4b/SequentialControl/initial-x/initial.json --evidence experiments/fourstate/sequential-cli-20261016-v1/replay
python -B scripts/verify_fourstate_sequential.py
python -B scripts/verify_fourstate.py --evidence experiments/fourstate/combinational-regression
```

示例的目录名 `sequential-example-v1` 是第一次 CLI 实验的目录，内部产物格式为 v2。
新检出缺少实验输入时，先运行验证脚本生成自己的轨迹和初态，再替换回放路径。

### 时序验收结果

[时序报告](../experiments/fourstate/sequential/20261016T143541Z-a8360f4b/summary.json)
记录 2026-10-16 的真实运行，种子 `410162`：

| 场景 | 实际结果 |
| --- | --- |
| SequentialControl，初态分别全 0/1/X/Z | 4 组，每组 448 个采样，复位/使能/数据四态组合 |
| SequentialWide，4/65 位、升降序及非零下标 | 1,344 个采样，混合四态初态与固定种子随机轨迹 |
| SequentialSwap，跨过程寄存器交换 | 224 个采样，验证旧态读取与同时提交 |
| SequentialControl，全已知轨迹 | 224 个采样，另与原始 RTL 的现有二态导出路线对照 |
| 时序语法与驱动拒绝检查 | 23 项通过，错误包含源码位置 |
| 初态/时钟/边沿稳定性检查及实际故障注入 | 12 项通过 |

7 个场景共 3,584 个采样，更新前后累计比较 381,248 个输出位位置、
381,248 个寄存器位位置。两类观察分别计数；输出寄存器也出现在状态观察中，
不能将总数当作独立硬件信号数量。所有 0/1/X/Z 精确比较，不掩码、不跳过。
额外高电平采样改变复位，验证无边沿时同步复位不生效。

故障注入实际运行了错误的逐寄存器更新包装、把未知 `if` 当真的编码 RTL、
以及交换下一态 X/Z 的编码 RTL，三者均被检测。原始二态导出含两个显式任意输入，
测试分别将它们全选 0 和全选 1；原始寄存器初态显式为零，Yosys 辅助初态保留已知位约束、
其余选零。这是限定的二态兼容实验，不代表所有初态或任意输入选择的证明。

[组合回归报告](../experiments/fourstate/combinational-regression/20261016T143439Z-a13f7cb1/summary.json)
重新通过原 197 个采样、42 项拒绝、11 项故障/输入检查及 8 个二态对照采样。
独立 CLI [时序转换](../experiments/fourstate/sequential-cli-20261016-v1/0/result.json)、
[时序回放](../experiments/fourstate/sequential-cli-20261016-v1/1/result.json)、
[旧 v1 原产物回放](../experiments/fourstate/sequential-cli-20261016-v1/2/result.json) 均退出 0，
旧 v1 回放结果与原保存结果完全一致。

本轮仍基于 `20eaf4f3d08bdeb572dbf4384dbc4b7447ed7060` 上的未提交增量。
报告保存实际脚本、测试与依赖快照、Git 状态及差异；文档最终更新晚于执行快照。
未修改历史报告，未运行整颗或完整框架回归，也未操作同伴服务器。

[时序交付复核](../experiments/fourstate/sequential-cli-20261016-v1/delivery-check.json)
再次核对时序报告的 845 个产物和组合回归的 817 个产物哈希，确认当前实现及测试源码
匹配时序实验快照、独立 CLI 结果匹配原始 RTL、旧 v1 结果未改变。
Python 语法、文档链接、新 CLI 帮助及 `git diff --check` 均通过。

## 位宽与运算扩展（分批实施）

第一批已实现并验证有符号声明、定宽有符号常量、`$signed/$unsigned`、
正十进制定宽转换 `N'(expr)`、上下文扩展与截断。表达式 IR 的每个节点保存
`width`、`signed`、源码位置，`resize` 节点另保存原宽度和扩展方式。
已覆盖赋值、非阻塞赋值、按位运算和一位条件表达式中的不同位宽；
位选与拼接按无符号结果处理。平坦 v3 仅接受正十进制固定宽度转换；
v4 另外接受官方求值后的参数定宽转换。无尺寸数据常量和其他类型转换仍带位置拒绝。

新产物的四态 IR、映射和清单格式为 v3；映射同时记录端口与寄存器的有符号性，
编码轨道仍各为 W 位。二态后端接口无变化。旧 v1/v2 文件不作改写，
其兼容回放在本轮最终回归中单独检查。

在仓库根目录实际运行：

```powershell
python -B scripts/verify_fourstate_operators.py --batch width
```

[第一批报告](../experiments/fourstate/operators/20261016T150842Z-ab24fa62/summary.json)
为 PASS：`WidthTypes` 36 个采样、7,560 个输出位位置；`WidthState`
64 个采样、更新前后共 2,560 个输出位及 1,536 个寄存器位位置。
原始 RTL、编码 RTL、生成并执行的 Lean 结果一致；无尺寸常量与动态宽度转换的
2 项拒绝检查通过。后续又补充了不同宽度操作数、不同宽度条件分支和两位显式 signed
扩展的测试；最终源码的第一批报告见下方复核表。报告保存 Python 3.13.13、
pyslang 12.0.0、Icarus/vvp 13.0、
Yosys 0.70+16、Lean 4.19.0 的实际路径、版本及哈希，以及源码快照、未提交状态、
命令、退出码、三方输入输出与产物哈希。

第二批已实现并验证 `!`、`&&`、`||`，以及普通、case 相等和有符号/无符号大小比较。
多位逻辑操作数：存在已知 1 即为真，全部已知 0 即为假，其余为 X；
逻辑运算按此三态真值计算，不产生 Z。`==`、`!=` 若已有确定不等位可得到确定结果，
否则未知位产生 X；`===`、`!==` 精确比较两条编码轨，结果始终为 0/1。
大小比较只在参与运算的位全已知时给出 0/1，有 X/Z 时给出 X；
双方均有符号才按有符号值比较，混合类型按无符号值比较。
过程 `if` 遇 X/Z 条件走假分支，`?:` 继续逐位合并。

```powershell
python -B scripts/verify_fourstate_operators.py --batch logic
```

[第二批报告](../experiments/fourstate/operators/20261016T151018Z-ae8a8485/summary.json)
为 PASS：一位全部 16 组四态输入、两位 256 组四态比较和 64 个时序采样，
共 4,144 个输出位与 384 个寄存器位位置完成三方比较；2 项乘法拒绝检查通过，
其中一项位于死分支。实际篡改编码 RTL 的 case 相等运算，让它忽略 value 位后，
三方比较检测到差异。

第三批已实现并验证一元/二元加减和四种移位。二元加减按表达式求值宽度模
`2^W` 计算；参与运算的 X/Z 使结果为 X。一元负号遇 X/Z 也产生 X；
一元正号按原始 RTL 行为直接保留操作数的四态位。已知移位量按位搬运
tag/value，移入位置补 0，因此原位的 Z 可以保留；未知移位量产生 X。
`<<<` 与 `<<` 的补位相同；`>>>` 对有符号左操作数复制最高位的完整状态，
对无符号左操作数补 0。大于位宽的移位量按完整数值处理，不截成低几位。

```powershell
python -B scripts/verify_fourstate_operators.py --batch arithmetic
```

[第三批报告](../experiments/fourstate/operators/20261016T151435Z-3a395a54/summary.json)
为 PASS：`ArithmeticBits` 256、`Counter4` 208、`ComparatorControl` 168、
65 位 `ShiftPipeline` 140 个采样，合计 123,744 个输出位及 39,408 个寄存器位位置
完成三方比较；3 项乘法、无尺寸计数常量和死分支除法拒绝检查通过。
实际把编码 RTL 的加法改成减法、算术右移改成逻辑右移，差分均检测到错误。
之前发现并保留的失败探针分别暴露了编码重复位在 Yosys 中形成环、
一元正号的 X/Z 语义，以及条件上下文改变有符号右移的问题；最终报告使用修正后的源码。
### 最终回归与产物兼容

以下报告在最终实现和验证源码上重新运行；各实验使用独立目录，早先报告及失败探针保留。

| 实际命令与报告 | 结果 |
| --- | --- |
| `python -B scripts/verify_fourstate_operators.py --batch width`：[位宽报告](../experiments/fourstate/operators/20261016T152016Z-280a6c90/summary.json) | PASS；100 个采样，10,984 个输出位、1,536 个寄存器位位置，2 项拒绝 |
| `python -B scripts/verify_fourstate_operators.py --batch logic`：[逻辑比较报告](../experiments/fourstate/operators/20261016T152043Z-1b8ba8f7/summary.json) | PASS；336 个采样，4,144 个输出位、384 个寄存器位位置，2 项拒绝、1 项故障被检测 |
| `python -B scripts/verify_fourstate_operators.py --batch arithmetic`：[算术移位报告](../experiments/fourstate/operators/20261016T152112Z-8c98d172/summary.json) | PASS；772 个采样，123,744 个输出位、39,408 个寄存器位位置，3 项拒绝、2 项故障被检测 |
| `python -B scripts/verify_fourstate_operators.py --batch compatibility`：[二态与旧产物报告](../experiments/fourstate/operators/20261016T152158Z-bce78ca8/summary.json) | PASS；3 个新设计、132 个全已知采样，与原始 RTL 的二态后端一致；旧 v1 组合 64 个、v2 时序 448 个采样回放与原保存结果一致 |
| `python -B scripts/verify_fourstate.py --evidence experiments/fourstate/combinational-operators-regression`：[组合回归](../experiments/fourstate/combinational-operators-regression/20261016T152250Z-6520a34e/summary.json) | PASS；197 个采样、19,384 个输出位位置、35 项仍拒绝结构、11 项故障/输入检查、8 个二态对照采样 |
| `python -B scripts/verify_fourstate_sequential.py --evidence experiments/fourstate/sequential-operators-regression`：[时序回归](../experiments/fourstate/sequential-operators-regression/20261016T152323Z-eba8192a/summary.json) | PASS；3,584 个采样、381,248 个输出位和 381,248 个寄存器位位置、22 项仍拒绝结构、12 项故障/输入检查、224 个二态对照采样 |

新设计的二态对照包括 Counter4、ComparatorControl 和 ShiftPipeline，原始寄存器
明确从零开始；Yosys 辅助状态的未约束位取零并保留已知位约束。若导出额外任意输入，
分别选择全零和全一。这仅核对全已知轨迹及所选补全，不覆盖所有初态。
旧回归的拒绝数量减少，是因为 signed、位宽调整、逻辑非、加法和移位等原负例
已转为新正例；历史报告中的 42/23 项旧结论没有改写。

另外直接执行当前 v3 的组合和时序转换、回放 CLI：

```powershell
python -B scripts/fourstate2lean.py verification/fourstate/WidthTypes.sv --top WidthTypes --out generated/fourstate/operator-cli-20261016-final
python -B scripts/fourstate_simulate.py generated/fourstate/operator-cli-20261016-final/fourstate-manifest.json --trace experiments/fourstate/operators/20261016T152016Z-280a6c90/WidthTypes/trace.jsonl --evidence experiments/fourstate/operator-cli-20261016-final/replay
python -B scripts/fourstate2lean.py verification/fourstate/Counter4.sv --top Counter4 --mode sequential --clock clk --out generated/fourstate/operator-sequential-cli-20261016-final
python -B scripts/fourstate_simulate.py generated/fourstate/operator-sequential-cli-20261016-final/fourstate-manifest.json --trace experiments/fourstate/operators/20261016T152158Z-bce78ca8/Counter4/trace.jsonl --initial-file experiments/fourstate/operators/20261016T152158Z-bce78ca8/Counter4/initial.json --evidence experiments/fourstate/operator-cli-20261016-final/replay-sequential
```

实际执行均退出 0；[组合回放结果](../experiments/fourstate/operator-cli-20261016-final/replay/fourstate-result.json)
的 36 个采样与第一批原始 RTL 一致，[时序回放结果](../experiments/fourstate/operator-cli-20261016-final/replay-sequential/fourstate-result.json)
的 84 个采样（包括前后状态）与兼容实验原始 RTL 一致。
执行日志保存在同一 `operator-cli-20261016-final/` 实验目录，重复运行需换新目录。

## 模块层次、固定参数与 generate（已实现并验证）

2026-10-17 后续审计发现 generate-for 未检查未知结构值，以及跨实例赋值目标、
输出连接目标和事件时钟引用的漏检。下面保留原验收记录，其 PASS 不覆盖这些漏检；
漏检已修正并完成新的专项检查及层次/组合/时序回归，以本节末的审计修正报告验收。

修正实现使用官方 `GenerateBlockArray` 的初始化、终止和步进表达式，以及官方展开条目
中的 genvar 值，经 `EvalContext` 求值检查；不自行决定循环次数或生成硬件。循环头引用的
整型参数也须完全已知，包括零次循环的步进参数和被确定值掩盖的未知边界参数。
源码连续赋值的左值、子模块输出的实际目标、事件时钟及作为时钟别名的右值均检查所属
模块实例。官方生成的端口绑定按父/子两侧分别检查，同一实例的静态 generate 引用仍允许。
诊断同时处理 Windows 跨盘源码路径，避免格式化位置时用相对路径计算掩盖原始错误。

本轮直接导入固定 pyslang 12.0.0 的已展开语义树：指定 `CompilationOptions.topModules`
后读取实例、参数值、generate 作用域和官方端口转换，再降低到独立四态 IR。
不重新实现参数求值或 generate 展开，不在编码前经过二态模型。
全部输入文件须语法合法；硬件白名单只检查选定顶层实际展开的作用域，未选 generate
分支和无关模块不纳入硬件支持承诺。运行时 `if/?:` 的所有分支继续审计。

已接入文件/目录输入、普通 input/output、具名/位置实例连接和参数覆盖、整型参数及
localparam、generate if/case/for。参数用于数据表达式时保留官方宽度、signed 和四态值，
因此 `q + STEP` 可使用已求值参数；直接书写的无尺寸数据常量继续拒绝。
结构表达式须完全已知；编译期可使用整型常量运算及 `$clog2/$bits`。
输出连接仅限完整信号，输入使用已有表达式。宏/include、悬空或通配端口、inout/ref、
类型参数、实例数组、defparam、bind、用户函数、转义标识符及源码中的跨模块内部引用仍拒绝。
目录递归收集 `.sv/.v` 并按路径稳定排序，`--top` 在官方展开开始前明确指定；
顶层参数取 RTL 默认值，子实例可覆盖，不提供新的 CLI 参数覆盖选项。

普通单模块平坦设计仍生成 v3；多模块、参数、generate 或目录输入生成 v4。
v4 初态与结果用 `Top.u0.bank[0].q` 等完整路径；映射分别保存逻辑路径、
相对顶层的 `rtl_path`、原始声明范围、signed 和位序。编码标识符由独立分配器生成。
所有实例状态仍在同一次全设计 evaluate 中读取旧值并在共同上升沿同时提交。
时钟只能通过直接端口和纯导线别名传递，不能用作数据、门控或派生时钟。

v4 清单增加必需且带哈希的 `sources.json`、`elaboration.json`、`fourstate.ir.json`；
来源清单保存全部原始文件快照，加载器校验版本、模式、来源、展开记录、状态集合及
映射。实现/测试快照递归收集测试子目录和未跟踪文件，不只依赖 Git diff。
验证另用人工维护的 `hierarchy-expected.json` 核对寄存器、范围及关键参数，
包括未直接影响顶层输出的状态，避免三方共同漏比较。

例如已执行的 HierarchySwap 初态完整对象为：

```json
{"HierarchySwap.u0.q":"x","HierarchySwap.u1.q":"z"}
```

### 层次验证结果与命令

2026-10-17（Asia/Shanghai），基线仍为 `main` /
`20eaf4f3d08bdeb572dbf4384dbc4b7447ed7060`，实现、文档和测试为已有未提交成果上的增量。
报告目录使用 UTC 时间，因而该轮目录以 `20261016T17…Z` 开头。

```powershell
python -B scripts/verify_fourstate_hierarchy.py
```

[层次验收报告](../experiments/fourstate/hierarchy/20261016T172300Z-baccfb12/summary.json)
为 PASS，随机种子 `410171`。全部生成 Lean 均实际编译、执行，后端均无隐藏状态。

| 场景 | 实际结果 |
| --- | --- |
| HierarchyTop：多文件、7 个参数化叶实例、4/8/65 位、嵌套流水、generate if/case/for、localparam、`$clog2/$bits`、负数 STEP、时钟别名 | 192 个采样，独立核对 14 个寄存器；35,712 个输出位和 71,424 个寄存器位位置 |
| HierarchySwap：相同模块双实例、X/Z 初态、跨实例反馈 | 48 个采样，2 个寄存器；192 个输出位和 192 个寄存器位位置 |
| PathCollision：`a.b.q` 与 `a_b.q` | 64 个采样，2 个寄存器；256 个输出位和 256 个寄存器位位置，无编码命名碰撞 |
| HierarchyComb：v4 组合、端口扩展/截断、升序范围、X/Z 数据参数 | 32 个采样，2,592 个输出位位置 |

共 336 个采样、38,752 个输出位和 71,872 个寄存器位位置完成三方精确比较。
时序数量包括更新前后观察；输出寄存器也出现在状态观察中，不据此推算独立信号数量。
叶模块寄存器使用 `[1:DB]` 升序非零范围，顶层另含 `[0:7]` 和 `[68:4]` 输入。
生成作用域中的 X/Z 一次性初始化、观察路径和位序均实际验证。
同目录的 Unrelated 含不支持硬件而未被误作顶层；其文件发生语法错误时则明确拒绝。
未选 generate 存储器分支未进入电路，选中后拒绝；未知结构条件也拒绝。

每个场景的 `expected-inventory.json` 和 `inventory-result.json` 来自独立维护的
[预期清单](../verification/fourstate/hierarchy-expected.json)，严格核对状态路径、数量、
宽度、signed、声明范围及关键实例参数/localparam。没有直接影响输出的 bank 状态也必须存在。
报告另有 27 项结构拒绝、13 项加载/清单检查，包括缺失或损坏来源、映射、展开记录和源码，
v4 模式/版本不一致，以及三份产物共同漏状态时由独立清单检测的用例。

3 项故障均成功编译并实际执行编码 RTL 后被语义差分检测；报告保存具体改动、源码哈希和首次差异：

| 故障 | 首次差异 |
| --- | --- |
| 两实例串用当前态 | sample 0 pre，q1 应为 Z，错误结果为 X |
| 将 4 位特化状态错误截为 2 位再扩展，保持外部接口宽度 | sample 0 pre，p0 应为 `xz01`，错误结果为 `0001` |
| 逐实例提前提交并稳定后再更新另一个实例 | sample 2 post，q1 应为 X，错误结果为 Z |

编译失败的结构负例没有计入上述 3 项语义故障。各场景的 `original/`、`encoded/`、`lean/`
保存三方原始结果与执行命令、退出码；早先失败探针保留，未改写状态或哈希。

直接 CLI 转换及回放也已退出 0，详见 [CLI 报告](../experiments/fourstate/hierarchy-cli/20261016T172619Z-d3ec3aa7/summary.json)：

```powershell
python -B scripts/fourstate2lean.py verification/fourstate/hierarchy --top HierarchyTop --out generated/fourstate/hierarchy-cli-20261016T172619Z-d3ec3aa7-HierarchyTop --mode sequential --clock clk
python -B scripts/fourstate_simulate.py generated/fourstate/hierarchy-cli-20261016T172619Z-d3ec3aa7-HierarchyTop/fourstate-manifest.json --trace experiments/fourstate/hierarchy/20261016T172300Z-baccfb12/HierarchyTop/trace.jsonl --evidence experiments/fourstate/hierarchy-cli/20261016T172619Z-d3ec3aa7/HierarchyTop/replay --initial-file experiments/fourstate/hierarchy/20261016T172300Z-baccfb12/HierarchyTop/initial.json
```

CLI 报告同时保存 HierarchyComb 的转换与回放命令；两者结果均与本轮原始 RTL 一致。
重复运行需换新的生成/证据目录，非空目录仍拒绝覆盖。缺少历史实验输入的新检出，先运行验证脚本。
本轮实际工具仍为 Python 3.13.13、pyslang 12.0.0、Icarus/vvp 13.0、Yosys 0.70+16、Lean 4.19.0；
工具路径、可执行文件哈希、解析器安装回执及 VPI 初始化辅助模块来源均随报告保存。

### 本轮旧回归与兼容

| 实际命令 | 报告与结果 |
| --- | --- |
| `python -B scripts/verify_fourstate.py --evidence experiments/fourstate/hierarchy-combinational-regression` | [PASS](../experiments/fourstate/hierarchy-combinational-regression/20261016T172422Z-32711731/summary.json)：197 个采样、32 项仍拒绝结构、11 项故障/输入检查、8 个二态对照采样 |
| `python -B scripts/verify_fourstate_sequential.py --evidence experiments/fourstate/hierarchy-sequential-regression` | [PASS](../experiments/fourstate/hierarchy-sequential-regression/20261016T172422Z-06add43a/summary.json)：3,584 个采样、22 项仍拒绝结构、12 项故障/输入检查、224 个二态对照采样 |
| `python -B scripts/verify_fourstate_operators.py --batch width --evidence experiments/fourstate/hierarchy-operators-regression` | [PASS](../experiments/fourstate/hierarchy-operators-regression/20261016T172422Z-bdc86dec/summary.json)：100 个采样 |
| `python -B scripts/verify_fourstate_operators.py --batch logic --evidence experiments/fourstate/hierarchy-operators-regression` | [PASS](../experiments/fourstate/hierarchy-operators-regression/20261016T172517Z-a52b0243/summary.json)：336 个采样 |
| `python -B scripts/verify_fourstate_operators.py --batch arithmetic --evidence experiments/fourstate/hierarchy-operators-regression` | [PASS](../experiments/fourstate/hierarchy-operators-regression/20261016T172517Z-7b007532/summary.json)：772 个采样 |
| `python -B scripts/verify_fourstate_operators.py --batch compatibility --evidence experiments/fourstate/hierarchy-operators-regression` | [PASS](../experiments/fourstate/hierarchy-operators-regression/20261016T172517Z-a68b2e17/summary.json)：132 个已知值采样与原始二态入口一致 |

层次报告另回放未经修改的 v1（64 个）、v2（448 个）、v3 组合（36 个）及 v3 时序（84 个）采样，
均与旧保存结果一致。旧组合拒绝数量从 35 变为 32，是参数、generate 和多模块选择转为支持；
历史报告不改写。公共二态后端、共享 IR、运行时及其 CLI 无变化，未执行整颗/完整框架回归。
报告记录实际源码快照和未提交差异，文档最终更新晚于运行快照；有限差分不构成通用正确性证明。

首次层次交付前另执行一次性 `python -B -` 静态核查脚本，退出 0：逐项复核以上八份报告的
6,968 个产物哈希，核对 288 项实现/测试快照与当时文件一致；四份入口及协作文档的
53 个本地相对链接有效，40 个相关源码、测试和文档文件的行尾空白及末尾换行检查通过，
四态 Python 脚本编译检查通过。`git diff --check` 退出 0；两份早期组合/时序历史报告
哈希保持原值，共享后端无工作区改动。本项仅检查交付完整性，没有重新执行硬件实验，
也没有改写实验报告；本段文档增量晚于上述快照。

### 层次审计修正与新验收

2026-10-17（Asia/Shanghai），仍在同一 `main` / `20eaf4f3d08bdeb572dbf4384dbc4b7447ed7060`
的未提交工作区增量上修正两类审计漏检。实际修改
`scripts/fourstate_elaborated.py`、`scripts/verify_fourstate_hierarchy.py`，新增
`verification/fourstate/GenerateAudit.sv`，并同步本文件及 `TASKS.md`。
README、AGENTS 和已有未提交成果保留；公共后端、格式版本和 CLI 接口均无变化。

下列三条命令均重新执行并退出 0；每份报告保存本次实际实现/测试源码（包括未跟踪文件）、
HEAD、工作区差异、工具版本/哈希、命令和子进程退出码，以及三方原始输入输出。

| 实际命令 | 新报告与结果 |
| --- | --- |
| `python -B scripts/verify_fourstate_hierarchy.py --evidence experiments/fourstate/hierarchy-audit-fix` | [PASS](../experiments/fourstate/hierarchy-audit-fix/20261016T174507Z-426858c4/summary.json)：5 个场景、340 个采样、38,768 个输出位及 71,872 个寄存器位位置；42 项拒绝、13 项加载/清单检查、3 项实际语义故障 |
| `python -B scripts/verify_fourstate.py --evidence experiments/fourstate/hierarchy-audit-combinational` | [PASS](../experiments/fourstate/hierarchy-audit-combinational/20261016T174507Z-825be5da/summary.json)：197 个采样、19,384 个输出位位置、32 项拒绝、11 项故障/输入检查、8 个二态对照采样 |
| `python -B scripts/verify_fourstate_sequential.py --evidence experiments/fourstate/hierarchy-audit-sequential` | [PASS](../experiments/fourstate/hierarchy-audit-sequential/20261016T174507Z-5bfd8531/summary.json)：3,584 个采样、381,248 个输出位及 381,248 个寄存器位位置、22 项拒绝、12 项故障/输入检查、224 个二态对照采样 |

新增 15 项负例：X/Z 各覆盖循环初始化、边界、步进、零次循环中的未知步进参数、
被确定值掩盖的未知边界参数，共 10 项；另有跨实例连续赋值左值、输出实际目标、
事件时钟、时钟别名和子实例时钟端口连接 5 项。每项检查文件、行列；跨实例负例还检查
诊断明确指向跨模块引用，防止因其他错误被拒绝而误记通过。官方本来就拒绝的未知初始化/
步进值沿用官方诊断；此前漏掉的未知边界等由新的官方表达式求值审计拒绝。

新增 GenerateAudit 正例实际完成转换、Lean 编译/执行和 4 个四态采样的三方比较：
普通循环生成 3 个作用域，合法零次循环不生成硬件，输出静态读取同实例的 `g[2].n` 等
信号。零次分支中的未支持存储器不进入硬件审计。原四个场景的 336 个采样也全部重跑，
原独立清单仍核对 18 个寄存器；新组合正例独立要求状态集合为空且参数 N=3、ZERO=0。

三项语义故障重新编译并执行，首次差异仍分别为 sample 0 pre 的 q1：Z→X、
sample 0 pre 的 p0：`xz01`→`0001`、sample 2 post 的 q1：X→Z；具体变异和结果保存在
新层次报告。v1（64）、v2（448）、v3 组合（36）及 v3 时序（84）旧产物回放全部通过。
本轮未重跑运算专用批次、整颗或完整框架回归，不能将前一轮运算报告称为本轮重跑结果。

交付核查逐项验证三份新报告的 4,464 个产物哈希，111 项实现/测试快照与当前源码一致；
此前 41 份 `summary.json` 哈希未变。一次性 `python -B -` 静态核查退出 0，检查 41 个
相关文件的语法/行尾空白/末尾换行及 56 个本地相对链接；`git diff --check` 退出 0。
文档验收更新晚于运行快照，旧报告的状态、哈希和
实验结论保持原样；旧 PASS 不能证明本次修正前已具备新增拒绝能力。有限差分仍不是
转换器的通用正确性证明。

## 真实香山 AluDataModule 接入（已实现并验证）

本轮限定 Nanhu 提交 `997cd5b35cfbd26586674aa553d0f04b27914cb2`、原版 `MinimalConfig(1)`
及现有 NanhuCoreConfig 绑定，使用 Chisel 7.3.0 / firtool 1.135.0 重新生成原始 RTL。
锁定依赖已在本地恢复，已重新生成并审计真实 RTL，完整验证入口已退出 0。
历史二态 ALU 报告不能替代本轮结果，也不使用旧版 v2.1 FIRRTL 代替当前源码。
后续只补实际出现的结构，所有实验另存 `experiments/fourstate/xiangshan-alu/` 的唯一目录。
公共二态后端、共享展开入口及上游硬件保持原样；不访问服务器，不提交或推送。

已重新生成默认 RTL，SHA256 为 `f32b09044ef7c407d5e16824e5a313f5ebfa3e954f9e3a55bba40e26365fc82c`。
独立审计确认 10 个子实例、8 个顶层端口及零过程/寄存器，实际需要连续网声明赋值、
复制、归约与/或和内部二维 packed 字向量选择。相关 v5 编码已实现，小型组合三方测试通过；
完整 ALU 已完成转换、Lean 编译和执行，并通过下述三方比较及回归。

参考仿真限制：Icarus 13 在原始默认 RTL 第 362 行拒绝 `_GEN[io_func[1:0]][31:0]`。
[首次完整尝试](../experiments/fourstate/xiangshan-alu/20261016T181234Z-5097c9ec/summary.json)
如实保存为 FAIL，并保留原始 RTL 编译错误；不将其写为模型仿真通过。用户已同意另存官方
兼容输出，但实际试验发现 `disallowPackedArrays` 生成 casez，会将 Z 选择码当作通配符：
`src0=1, src1=0, func=00000zz` 时结果错误地确定为 1，而 packed 动态选择应为全 X。
因此该候选输出不用于验收；新报告保留此反例及两份官方 RTL 的执行结果。
实际参考改用官方 `maximumNumberOfTermsPerExpression=1` 布局选项，只拆分表达式，
保留 packed 索引；默认 RTL 原样转换为编码 RTL/Lean，布局变体未经手改地交给 Icarus。
两份 RTL、共同 CHIRRTL、生成命令、哈希及参考契约均独立保存；不声称直接执行了默认 RTL。

本轮新增 IR 操作及 packed 类型布局使用 v5 IR/映射/清单，声明包含完整 packed 范围及元素宽度，IR 记录复制、
归约与/或、packed 动态读取及相关切片。动态索引为 X/Z、负值或越界时整字为 X，
不是条件表达式的逐位合并；已知索引搬运完整 tag/value。复制保留 X/Z，归约按确定的
0/1 优先处理未知位。二维 packed 仅用于内部固定四态 wire，非存储器；多维端口和寄存器、
unpacked 数组及任意动态标量位选仍拒绝。wire 声明赋值等同连续单驱动，变量初始化仍拒绝。
仅 wire 声明赋值归一化仍使用 v4；旧输入仍生成 v3/v4，回放继续支持 v1–v4。
v5 同时支持组合和已有显式状态转移采样契约，状态名称沿用 v4 完整实例路径；
旧 v1–v3 的初态键名保持原样。没有新增公共后端或共享 CLI 参数。

### 实际命令与来源

2026-10-17（Asia/Shanghai），源码基线为 `main` /
`20eaf4f3d08bdeb572dbf4384dbc4b7447ed7060`；本轮实现为已有未提交成果上的增量。
本轮修改四态前端、编码、转换清单与加载器及原组合验证脚本，新增
[真实模块验证入口](../scripts/verify_fourstate_xiangshan.py)、AluGaps、AluGapsState、
NetAlias 三个小型 RTL 和独立的 `xiangshan-alu-expected.json`。
文档修改仅本文件和 TASKS，README/AGENTS 的原有修改保留。

实际执行以下命令并退出 0：

```powershell
python -B scripts/verify_fourstate_xiangshan.py
```

[最终验收报告](../experiments/fourstate/xiangshan-alu/20261016T182930Z-acc514b3/summary.json)
为 PASS。该入口实际调用现有依赖获取、`xiangshanFramework/writeXiangshanClasspath` 和
官方 Chisel 展开入口，再转换未改写默认 RTL、生成布局参考、运行三方比较与全部旧回归。
报告的 `prepare-*`、`sbt/`、`elaboration/`、`compatible-codegen/` 及各运行目录保存
完整子命令、退出码与标准输出/错误；原始输入与配置可由同一报告定位。

上游源码由锁定提交的 codeload archives 恢复，不称为 Git 检出。证据保存各归档哈希、
722 份上游 Scala/Java/许可文件快照，以及实际使用的 vendored CDE、本地配置、展开桥接、
构建文件和脚本等 21 份本地输入快照，并记录 6,475 项 class/jar 文件哈希。
不能只依据项目 HEAD 复现实验：四态源码、测试及未提交差异另有独立快照。
实际工具为 Python 3.13.13、pyslang 12.0.0、JDK 17.0.20.1、Chisel 7.3.0、
Scala 2.13.15、firtool 1.135.0、Icarus/vvp 13.0、Yosys 0.70+16 和 Lean 4.19.0；
均使用已记录的工具路径/版本/哈希，Java 17 只对该入口的子进程指定，不改变系统工具。

`original/Chisel2LeanReference.v` 是默认输出，真正选择 `AluDataModule` 为顶层，
不是包装器或手写替代模型。`icarus-compatible.v` 是共同 `design.fir` 的官方布局变体，
SHA256 为 `7ecabf21760a37887fba4363cc30a3558d7ee2af433b6dad63844b15c09973b5`。
`reference-contract.json` 串联两份 RTL、共同 CHIRRTL、生成选项及其哈希；
`reference-option-counterexample.json` 保存被排除的 casez 变体与正确 packed 索引结果。

### 实际验证结果

独立维护的 [预期清单](../verification/fourstate/xiangshan-alu-expected.json) 与官方审计、
四态展开结果、映射及后端模型严格核对：两个 64 位数据输入、7 位操作码、两个一位
分支控制、三个输出，共 8 个端口、10 个子实例及空状态集合。两份官方 RTL 的接口和
实例清单一致，实际参考无过程；后端无隐藏状态或额外任意输入。本模块不需要初态文件。
`raw-rtl-inventory.json`、`expected-inventory.json` 和 `inventory-result.json` 保存核查结果。

| 测试 | 实际结果 |
| --- | --- |
| 真实 ALU 三方精确比较 | 20,931 个采样，1,381,446 个输出位位置；835 个四态 IR 节点、5,458 个 FunctionalIR 节点，Lean 实际编译执行 |
| 向量构成，种子 `410172` | 原 16,000 个已知向量；1,024 个全操作码混合四态、1,536 个逐位 X/Z、64 个未知操作码、256 个分支控制、2,048 个随机及 3 个定向向量 |
| 输出状态数量 | 0：974,228；1：212,495；X：192,502；Z：2,221，均逐位精确比较 |
| 新语义小型三方测试 | AluGaps：512 个组合采样；AluGapsState：256 个采样并比较前后状态；NetAlias：4 个采样及 v4 格式保持检查，共 50,192 个输出位、2,048 个寄存器位位置 |
| 新拒绝及产物检查 | 历史报告记录 11 项带位置拒绝及 6 项 v5 产物检查；其中 DeadRuntimeMultiply 实为词法歧义导致的语法错误，不能作为不支持乘法的验收证据，见下文定向修正 |
| 实际语义故障 | 抹去输出 tag、交换 X/Z 两个副本均重新编译执行；sample 16000 的 64 位 X 分别被错误变为 0 和 Z，比较器检测到首次差异 |
| 原始 RTL 的既有二态入口 | 每操作码两个边界向量，共 256 个采样匹配；实际无额外任意输入，初态为空 |

三方原始结果分别为 `original-run/result.json`、`encoded-run/result.json` 和
`lean-run/fourstate-result.json`，Lean 的原始二态轨结果也独立保存并核对。
定向用例确认 `X & 0` 输出确定零、pack 直接传递 Z，避免只比较全 X 结果。
实际 ALU 始终无寄存器；AluGapsState 是 v5 执行契约的小型回归，不冒充真实 ALU 状态。

既有组合、时序、层次、位宽、逻辑、算术、二态兼容批次分别重跑 197、3,584、340、100、
336、772、132 个采样，七条命令均退出 0；子报告及准确命令由主报告的 `regressions` 定位。
层次回归保留 42 项拒绝（包括未知 generate-for 和跨实例目标/时钟），组合回归保留
29 项拒绝，减少的三项 wire 初始化、归约及复制已转为正例，旧报告不改写。
旧 v1（64）、v2（448）、v3 组合（36）及 v3 时序（84）回放通过，另回放未改写 v4 时序
产物的 192 个采样。没有执行整颗或完整框架回归。

为避开 Windows MAX_PATH，最终回归和损坏副本使用独立短目录
`experiments/fourstate/xa-r-acc514b3/` 与 `experiments/fourstate/xa-l-acc514b3/`。
主报告使用相对路径引用，并在 `external_artifact_sha256` 记录这些文件；复制验收证据时
须同时保留这两个目录。中间失败尝试及此前报告全部保留，没有将失败改记为 PASS。

另实际执行既有转换、回放 CLI，均退出 0，14 个已知/混合/X/Z 定向采样与原始参考一致，
见 [CLI 报告](../experiments/fourstate/xiangshan-alu/20261016T182406Z-79032d51/cli/summary.json)：

```powershell
python -B scripts/fourstate2lean.py experiments/fourstate/xiangshan-alu/20261016T182406Z-79032d51/original/Chisel2LeanReference.v --top AluDataModule --out generated/fourstate/xs-alu-79032d51
python -B scripts/fourstate_simulate.py generated/fourstate/xs-alu-79032d51/fourstate-manifest.json --trace experiments/fourstate/xiangshan-alu/20261016T182406Z-79032d51/cli/trace.jsonl --evidence experiments/fourstate/xiangshan-alu/20261016T182406Z-79032d51/cli/replay
```

该 CLI 记录早于最终补齐上游/本地构建源码清单，其前端、编码器、转换器和加载器与最终
源码一致；最终主报告另完整执行全部步骤。重复执行应换新目录，不覆盖现有产物。
文档验收更新晚于实验快照，有限差分不构成转换器的通用正确性证明。

交付前一次性 `python -B -` 核查退出 0：独立复核最终报告记录的 9,896 项内外部产物哈希，
42 项实现/测试快照与当前文件一致，722 份上游及 21 份本地输入快照、6,475 项 class/jar
哈希均匹配；CLI 的五份核心转换/编码/加载源码与最终版本一致。此前 44 份历史报告及
其记录的 35,616 项产物哈希保持原值。另检查 61 个本地相对链接、46 个相关文件的
Python 语法/行尾空白/末尾换行及代码围栏，`git diff --check` 退出 0。
Windows 核对外部相对路径时先解析为规范化绝对路径，避免路径中的 `../..` 触发 MAX_PATH。

### DeadRuntimeMultiply 定向审计修正（2026-10-17）

历史负例将常量和条件运算符写成 `1'b0?`，其中 `?` 可以作为基数常量的未知数位。
pyslang 12.0.0 对该源码报告两项语法错误，未形成 `MultiplyExpression`；旧检查仅要求
错误带文件、行列，因此错误地将其计入拒绝通过。上述历史报告和源码原样保留，
其中这一项不能证明运行时死分支中的乘法受到硬件白名单审计；其余历史比较结果不重记为本轮执行。

现改为 `1'b0 ? (a * b) : a`，完整 ALU 验证入口与新增定向入口共用同一负例和严格检查：
独立检查语法及官方展开无错误，并确认原始语法树有一个乘法节点，最后要求四态前端在
该节点的准确文件、行列报告 `unsupported hardware syntax (MultiplyExpression)`。
仅有语法错误、其他不支持结构或错误位置均不能满足这一验收条件。乘法仍不受支持；
没有增加运算能力或修改公共后端。

实际在仓库根目录执行并退出 0：

```powershell
python -B scripts/verify_fourstate_xiangshan.py --check-dead-runtime-multiply --evidence experiments/fourstate/alu-multiply-audit
```

新 [定向报告](../experiments/fourstate/alu-multiply-audit/20261016T184634Z-45f15fb6/summary.json)
记录 7 项检查通过：修正负例精确拒绝、旧歧义源码不能通过检查、四项诊断防误收检查
（模拟语法错误、其他运算、错误文件、错误行列），以及将乘法改为按位或的支持对照。
修正源码零语法错误、零展开错误；实际拒绝位于 `DeadRuntimeMultiply.sv:1:59`。
四项诊断防误收检查是对检查器的合成诊断测试，不计为新增硬件拒绝用例。
`rejection.json` 保存实际拒绝，`invocation/` 保存完整命令、输出及退出码，报告另保存
三个测试源码、Python/解析器路径、版本与哈希、锁定安装清单、Git HEAD、未提交差异和
源码快照。文档验收更新晚于测试快照，最终文档与静态核查另存于同目录的 `acceptance/`。

本次只执行前端和检查器的定向验证，没有重跑 ALU 转换、RTL 仿真、Lean 编译执行或全部回归。
验收限定继续有效：**默认原始 RTL 用于转换；Icarus 实际执行的是同一 CHIRRTL 的官方
表达式拆分版本**（`maximumNumberOfTermsPerExpression=1`）。本次修正支持这一文档参考契约，
不能表述为“默认 RTL 已直接完成 Icarus 仿真”，也没有重新验证两份 RTL 的全域等价性。
源码基线仍为 `main` / `20eaf4f3d08bdeb572dbf4384dbc4b7447ed7060`，保留已有未提交成果；
本次仅修改独立验证脚本、本文件和 TASKS，并新增定向证据，不改写历史报告。

## 文档基线核查（历史记录）

以下保留本轮开发前的文档基线核查，描述当时状态，不表示当前仍无四态实现。

2026-10-16（Asia/Shanghai）在 `E:\projects\xiangshan2Lean` 核查：
分支 `main`，源码基线 `20eaf4f3d08bdeb572dbf4384dbc4b7447ed7060`。
编辑前 `git status --short` 无输出；本次交付为该基线上的未提交文档增量：
`README.md`、`AGENTS.md`、`TASKS.md` 和新增的本文件。
该提交号描述编辑前基线，不声称已经包含本轮文档。

在仓库根目录实际执行的命令如下，均退出 0：

```powershell
python --version
python -B scripts/yosys2lean.py --help
python -B scripts/yosys_simulate.py --help
.tools/lean-4.19.0-windows/bin/lean.exe --version
python -B -c 'import sys, subprocess; sys.path.insert(0, "scripts"); from bootstrap_native_yosys import INSTALL, environment; subprocess.run([str(INSTALL / "bin/yosys.exe"), "-V"], env=environment(), check=True)'
iverilog -V
vvp -V
```

原生 Yosys 版本探测使用项目已有环境函数设置 DLL 搜索路径。
核查时的实际输出为：

| 工具或命令 | 本轮结果 |
| --- | --- |
| Python | 3.13.13 |
| 两个现有 Yosys CLI 的 `--help` | 帮助正常输出；未执行转换或模型仿真 |
| 项目内 Lean | 4.19.0，commit `6caaee842e94` |
| 项目内原生 Yosys | 0.70+16，commit `3bb533450` |
| PATH 中 Icarus / vvp | 13.0 stable，`v13_0` |

这是版本与命令可访问性核查，不是完整安装兼容性或四态行为验证。
现有安装和二态使用方式复用 [Yosys 说明](yosys-frontend.md)；其中工具锁与
Python 3.11 流式依赖要求保持有效，不能用本次 Python 3.13 的帮助检查替代其验收。
本轮没有安装工具，没有执行四态转换、RTL/Lean 差分或整颗/完整框架回归。
当前不存在四态可运行示例；实现入口后再增加经实际执行的命令。

本轮文档检查已执行：`git diff --check` 退出 0；通过一次性 Python 检查核对四个
文件的本地相对链接、代码围栏配对及行尾空白，并与 `git show HEAD:<文件>` 比较。
README 仅新增入口，AGENTS 和 TASKS 的原内容逐字保留；
`git diff --name-only` 与 `git ls-files --others --exclude-standard` 的合并结果
只有上述四个文件。历史报告、代码及其他文档未修改。
该记录是文档检查结果，没有新增硬件实验报告或四态 PASS 结论。

## 双方协作与当前阻塞

同伴维护服务器上的二态主线，本地维护独立四态扩展。
本轮不联系或修改同伴环境，公共后端、IR、运行时和共享 CLI 均无接口变化。
两人已有的未提交修改必须保留，每轮编辑前重新检查工作区。

涉及公共接口时，先在本文件说明具体变更范围、默认行为和兼容性、受影响调用者及
所需二态/四态回归，再通过用户同步确认后实施。独立入口不得改变默认二态流程，
已有后端能力也不自动扩大本文件的四态支持承诺。

已列出的组合与单时钟同步复位运算子集无当前阻塞。无尺寸常量、未列的表达式与
类型转换、部分输出连接、存储器、多时钟、异步复位、多驱动解析及
完整 SystemVerilog/香山四态支持仍未实现，不属于此次验收范围。
真实 AluDataModule 已按上文参考契约完成验收；默认 RTL 的 Icarus 编译限制仍存在，
使用获准的官方表达式拆分布局参考处理，不表示修复了 Icarus 或证明了所有代码生成选项保真。
任务状态见 [TASKS](../TASKS.md)，协作规则见 [AGENTS](../AGENTS.md)。
设计细节与证据只在本文件维护，入口文档只保留链接。
