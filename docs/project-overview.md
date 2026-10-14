# Chisel2Lean4

把 Chisel 硬件设计转换成可以运行的 Lean 4 模型，用来检查电路行为，也方便在 Lean 中证明性质。
项目提供两个入口：源码入口保留支持范围内的位宽等参数，FIRRTL 入口处理官方工具已经展开的固定配置电路。
两端共用硬件中间模型和 Lean 后端。

源码入口目前使用 Chisel 7.3.0、Scala 2.13.15 和 Lean 4.19.0；官方 RTL 参考使用 CIRCT firtool 1.135.0。
经典 FIRRTL 入口使用独立的 Scala FIRRTL 1.5.6 工具环境，生成的模型同样使用 Lean 4.19.0。
现代 FIRRTL 入口现已接入 Chisel 7.3 官方展开结果，使用固定 CIRCT 完成规范化，
再通过 SSA 导入同一个硬件 IR。用法见 [现代入口](modern-firrtl.md)。
项目还在开发中，当前支持范围和证明范围见下文。

## 两个入口有什么区别

源码入口读取“怎样生成电路”，FIRRTL 入口读取“已经生成好的电路”。

以 `Counter(n)` 为例，源码入口把位宽 `n` 保留为 Lean 参数，同一份模型可以分别使用 `n=4`、`n=8`。
FIRRTL 入口在官方 Chisel 已经选择 `n=4` 后读取具体电路，生成的 Lean 模型就是四位计数器。
得到八位版本，需要重新按 `n=8` 展开并转换。

| 对比 | Chicala 源码入口 | FIRRTL 入口 |
|---|---|---|
| 输入 | Chisel 模块及相关源码 | 官方展开后的 `.fir` 电路文件 |
| 配置参数 | 支持的参数保留在 Lean 中 | 参数已经落实成具体位宽和电路结构 |
| 前端任务 | 解析 Scala、继承、配置读取和支持的生成结构 | 解析寄存器、连接、位运算和模块实例 |
| 适合的工作 | 参数化建模和性质证明 | 指定配置的真实电路建模和验证 |

`n`、`XLEN` 是生成电路前选择的配置参数；使能信号和运算数据是运行时输入。
固定配置模型仍然可以接受不同输入，也可以证明该配置下所有输入或任意长度输入序列的性质。
保留参数本身不构成所有参数下的正确性证明。

## 先跑一个源码例子

需要 Java 17 和 Python 3.10 以上，并设置好 `JAVA_HOME`。
以下命令都在仓库根目录运行，首次安装和构建需要联网：

```powershell
python scripts/bootstrap.py
python scripts/sbt.py writeToolClasspath reference/writeReferenceClasspath
```

转换示例计数器，再运行一段输入序列：

```powershell
python scripts/chisel2lean.py examples/Counter.scala --module Counter --out generated/source-demo
python scripts/simulate.py generated/source-demo/Counter.ir.json --params n=4 --trace examples/direct-counter-trace.json --evidence experiments/source-demo
```

转换会生成 `generated/source-demo/Counter.lean` 和 `generated/source-demo/Counter.ir.json`，并默认检查 Lean 代码能否编译。
这里的 `n=4` 表示四位计数器，可以改成其他合法位宽。
示例序列包含复位、计数和暂停，每拍边沿后的计数值是 `0, 1, 2, 2, 3, 0, 1`。
执行结果保存在 `experiments/source-demo/result.json`。

## 先跑一个 FIRRTL 例子

完成上述工具安装后，构建经典 FIRRTL 前端：

```powershell
python scripts/sbt.py classicFirrtl/writeFirrtlClasspath
```

转换已经展开的四位计数器，再执行示例输入：

```powershell
python scripts/firrtl2lean.py examples/firrtl/Counter4.fir --out generated/firrtl-demo
python scripts/firrtl_simulate.py generated/firrtl-demo/FIRRTL/Counter.ir.json --trace examples/firrtl/counter-trace.json --initial-state '{"cnt":0}' --evidence experiments/firrtl-demo-run
```

转换会生成 `generated/firrtl-demo/FIRRTL/Counter.lean`、对应 IR、规范化后的 FIRRTL 和来源清单，并默认检查 Lean 代码能否编译。
示例每拍边沿后的计数值是 `0, 1, 2, 2, 0`，结果保存在 `experiments/firrtl-demo-run/result.json`。

两份示例的输入序列不同，所以预期计数序列也不同。
FIRRTL 示例的 `reset` 是输入端口，写在轨迹的 `inputs` 中；源码示例的复位通过轨迹外层的 `reset` 字段传入。
`--initial-state` 必须明确提供寄存器初态，组合电路使用 `'{}'`。
本例的零初态是实验条件，不表示硬件保证零上电状态。

## 转换自己的模块

源码入口需要模块及相关源码，`--module` 指定目标模块：

```powershell
python scripts/chisel2lean.py Design.scala Ports.scala --module mypkg.Design --out generated/my-design
```

父类、trait 和子模块需要参与转换时，也要提供相应源码。
额外依赖可以通过 `--classpath-file` 指定。
真实 CDE 配置的查询、参数快照和原始模块展开方法见 [配置接入说明](chisel7-configuration.md)。

对于已由官方工具生成的经典 FIRRTL 文件：

```powershell
python scripts/firrtl2lean.py design.fir --top Design --namespace FIRRTL.Design --out generated/my-firrtl-design
```

省略 `--top` 时使用文件声明的顶层模块。
端口名和状态字段以生成的 `.ir.json` 为准；FIRRTL 的聚合端口经官方展开后可能与源码端名称不同。
支持的文本版本、复位和执行接口见 [FIRRTL 前端说明](firrtl-frontend.md)。

## 怎么实现的

源码入口走这条流程：

`Chisel 源码 → Scala 类型检查和 Chicala 前端 → 参数化硬件 IR → Lean 4`

FIRRTL 入口走这条流程：

`官方 Chisel 按配置展开 → FIRRTL → 官方规范化与 FIRRTL 前端 → 固定配置硬件 IR → Lean 4`

转换器主体用 Scala 实现，Python 脚本负责构建、运行和验证。
硬件 IR 整理端口、位宽、符号性、运算、连接优先级和寄存器更新。
Lean 后端生成 `Params`、`Inputs`、`State`、`Outputs`，以及 `step`、`output` 函数。
`step` 计算一个时钟上升沿后的状态，`output` 计算给定状态下的当前输出。
各寄存器的下一状态同时从旧状态和当前输入计算。

源码入口沿父类和 trait 解析真实 CDE 配置 getter，把硬件使用的 Int/Boolean 字段保留为 Lean 参数；运行具体配置时，再查询真实 CDE 对象取得值。
FIRRTL 入口使用官方 Scala FIRRTL 库处理位宽、聚合展开和条件连接，再接入共同 IR。
表达式按电路图组织成具名 Lean 定义，寄存器当前值与下一拍值分离；这些实现思路参考了 [GSIM](https://github.com/OpenXiangShan/gsim)。

## 怎么检查结果

源码与配置验证：

```powershell
python scripts/validate.py
python scripts/verify_configuration.py
python scripts/verify_xiangshan_config.py
```

分别检查通用模块、配置与继承，以及真实香山 `RightShiftModule`。
香山验证会下载锁定的源码和依赖，使用真实 CDE、原始 `XSModule` 和原版配置框架生成官方 RTL。
RTL 仿真还需要 Verilator、C++ 编译器和 Make。

经典 FIRRTL 的行为回归、错误检测和两端模型证明：

```powershell
python scripts/verify_firrtl_frontend.py
python scripts/check_firrtl_contracts.py
python scripts/verify_firrtl_bridges.py
```

复现完整香山 v2.1 工程的 FIRRTL 实验：

```powershell
python scripts/prepare_xiangshan_firrtl.py
python scripts/build_xiangshan_firrtl.py --module RightShiftModule
python scripts/build_xiangshan_firrtl.py --module AluDataModule
python scripts/verify_xiangshan_firrtl.py
```

现有验收记录如下。数字对应已保存的实验，不能代替新环境中的实际运行。

| 验证 | 已保存结果 | 记录 |
|---|---|---|
| Chisel 7.3 通用回归 | 51 个模型、128 组参数配置；6,303 周期、28,907 次输出比较 | [通用回归](validation-chisel7.json) |
| 配置与继承 | 32 组配置；1,848 周期、6,768 次输出比较；10 项拒绝检查 | [配置回归](validation-configuration-7.3.json) |
| 源码端真实香山 RightShift | XLEN=8/32/64；30,720 周期、184,320 次输出比较 | [香山源码验证](validation-xiangshan-config-7.3.json) |
| 源码端 CDE 层次与 XSBundle | 6 组配置；2,112 周期、18,048 次输出比较；三条流水线模型定理 | [层次验证](validation-xiangshan-hierarchy-7.3.json) |
| 源码端 Vec[Bundle] | 23 组配置；1,472 周期、97,299 次输出比较；23 项边界检查 | [聚合向量](vector-bundles.md) |
| 真实香山 XSBundle 向量 | 3 组配置；192 周期、6,985 次输出比较 | [向量验证](validation-xiangshan-aggregate-7.3.json) |
| 经典 FIRRTL 回归 | 22 项配置；34,155 周期、595,699 次输出比较 | [FIRRTL 回归](validation-firrtl.json) |
| FIRRTL 错误检测 | 8 类不支持输入、未定义操作和行为故障注入检出 | [契约与故障注入](validation-firrtl-contracts.json) |
| FIRRTL 端真实香山 v2.1 | RightShift 和 AluDataModule；合计 27,008 周期、162,048 次输出比较 | [香山 FIRRTL 验证](validation-xiangshan-firrtl.json) |
| 指定配置的两端模型证明 | Counter n=4、RightShift XLEN=64 | [模型桥接证明](validation-firrtl-bridges.json) |
| Chisel 7.3 现代展开入口 | 9 组配置；18,610 拍、110,424 次输出比较，含原始 L2TlbPrefetch 和 AluDataModule | [现代入口验证](validation-modern-firrtl-7.3.json) |
| 同源码、同 Chisel 7.3 的模型证明 | Counter n=4，全部初态与任意有限输入序列 | [现代桥接证明](validation-modern-bridge-7.3.json) |

香山 `AluDataModule` 实验包含 10 个子模块、710 个信号，覆盖全部 128 个操作码值；该模块单独比较了 153,600 次输出。
源码端 RightShift 的 64 位配置采用实际处理器配置，8/32 位是孤立模块的测试变体。
层次验证使用本地测试顶层，组合未改写的香山移位子模块和 SfenceBundle；不表示验证了上游完整处理器模块。
经典 FIRRTL 回归包含历史 Chisel 3.5.6 展开产物及新的原语 RTL 对照；香山 FIRRTL 实验使用 v2.1 的 Chisel 3.5.3。
上述经典实验与新的 Chisel 7.3 现代入口实验分别记录，不能互相代替。

## Lean 和原电路的一致性

Lean 类型检查确认生成程序可接受；与官方 RTL 的行为比较确认已测试配置和输入下输出一致。
部分用例还使用独立整数规格，并故意修改生成模型的行为，检查验证流程能否发现错误。
官方 RTL 参考来自原始硬件及官方生成工具，不使用本项目的 IR 生成。

已有 Lean 证明覆盖：四位 Counter 的全部初态、全部使能/复位输入和任意长度的有限输入序列；64 位 RightShift 的全部数据位模式和六位移位量。
证明文件位于 [verification/firrtl](../verification/firrtl)，证明对象是指定配置下的两份生成模型。

两端共用后端，也可能共同带有同一个错误，因此仍需独立 RTL 或独立参考语义核验。
目前还没有证明整个 Scala/CDE/Chisel 到 Lean 的转换流程对所有合法参数、所有输入序列都等价，也没有证明官方工具链正确。
模型性质证明、模型之间的等价证明和原电路到模型的翻译正确性证明，需要分别说明范围。

## 目前的支持范围

源码入口支持常见单时钟设计，包括 UInt/SInt/Bool、同步寄存器、条件赋值、模块层次，以及支持范围内的 Bundle/Vec、生成循环和存储器。
真实香山的 `XSModule/CDE` 已接入支持范围内的父类、trait 和纯配置 getter。
已支持有源码的 `XSBundle` 继承，以及将构造参数中的 CDE 对象原样传入子模块和命名 Bundle。
新增的 [Vec[Bundle] 支持](vector-bundles.md) 保留向量长度参数，可处理聚合寄存器、动态字段读写和嵌套 Vec。
模块内部新建或改变配置、Bundle 独立构造语句和复杂配置计算仍需补齐。
具体构造和限制见 [支持列表](support-matrix.md)。

FIRRTL 入口支持经典文本版本至 1.1.0，以及旧的无版本头格式；现代路线主要验收 Chisel 7.3 的 6.0.0 格式。
支持常见组合逻辑、聚合展开、多层实例和单时钟同步寄存器。
FIRRTL Mem/SyncReadMem、多时钟、门控时钟、异步复位、BlackBox/ExtModule 和验证语句暂不支持。
现代路线额外拒绝显式 DontCare/invalidvalue，避免官方规范化过程消除未定义条件。
由寄存器组成的 FIFO、寄存器文件已有回归，这与直接支持 FIRRTL 存储器不同。
不支持的写法明确报错；除零、无效 validif 等未定义观察由执行器检查并拒绝。

目前还不能自动转换整颗香山。
更多使用演练见 [饱和累加器示例](walkthrough-saturating.md)。
[语义说明](semantics.md)记录参数、位宽、复位和状态更新约定，其中版本背景为 v0.2；当前版本能力结合支持列表和配置接入说明阅读。

## 两条路线接下来怎样结合

两端已经共用 IR 和后端。现代入口现已对同一份 Chisel 7.3 Counter 源码生成模型，
并建立四位配置下的任意有限序列模型等价证明；新的香山实验也使用同一锁定的
Nanhu 工程和真实配置生成官方 RTL。香山本身尚未建立完整的源码/现代入口双向证明链。
接下来优先补存储器、未定义条件传播和更大的握手队列，再扩大状态及复位对应证明。

对于时序电路，证明需要建立初态或有效复位后的状态对应关系，证明状态对应时输出一致，并证明每拍更新保持对应关系。
由此可归纳得到任意长度输入序列上的一致性。
固定配置的证明覆盖该配置；所有合法参数下的结论还需要参数化证明。
具体开发边界见 [两端协作约定](firrtl-integration-coordination.md)。

## 来源与许可

项目基于 [Chicala](https://github.com/iscas-tis/chicala)，在其源码前端上增加了 Lean 后端、FIRRTL 入口和验证工具。
项目保留 [Apache-2.0 许可证](../LICENSE)。
香山派生电路保留其 Mulan PSL v2 许可证；其他依赖、示例和设计参考的来源见 [NOTICE](../NOTICE)。
