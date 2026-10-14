# 固定配置的 RTL → Lean

这条入口接收官方 Chisel/firtool 生成的 SystemVerilog，也可以接收独立的 RTL。
配置在展开前确定；例如三层流水线直接生成三层电路，Lean 中不再保留待赋值的 n。

路径是：香山原模块和真实配置 → 官方展开 → SystemVerilog → Yosys FunctionalIR → Lean。
Scala、trait、CDE、集合和生成循环由原工程执行；本入口处理已经确定的电路。

## 先运行

目前提供 Windows x64 的项目内工具锁。使用 Python 3.10 以上、Java 17，首次安装需要联网。
YoWASP Yosys 固定为 0.70.0.0.post1259，实际 Yosys 0.70，提交 28ba3cb92；
所有 Python 依赖 wheel 和 Yosys WASM 均记录 SHA256。没有全局安装或 WSL 依赖。
Chisel 7.3.0、Scala 2.13.15、firtool 1.135.0、Lean 4.19.0 沿用现有工具锁。

```powershell
python scripts/bootstrap.py --sbt --lean --firtool
python scripts/bootstrap_yosys.py
python scripts/sbt.py reference/writeReferenceClasspath
python scripts/elaborate_chisel.py --module probes.Counter --constructor examples/modern/counter-constructor.json --out generated/counter-original
python scripts/yosys2lean.py generated/counter-original/Chisel2LeanReference.v --top Chisel2LeanReference --namespace Yosys.Counter4 --out generated/counter-yosys
```

最后一步默认编译检查生成的 Lean。目录包含 `.lean`、`.ir.json`、来源清单、
Yosys 硬件元数据和 FunctionalIR 的 SMT 文件。SMT 文件是官方后端导出的转换数据，
这一步不依赖 SMT 求解器给出证明。

自己的已展开电路可以直接转换：

```powershell
python scripts/yosys2lean.py design.sv --top Design --out generated/design
```

外部 Chisel 工程的 classpath 和真实构造参数仍按 [官方展开入口](modern-firrtl.md) 准备。
先产生 RTL，再运行上面的转换命令。

## 模型如何执行

生成模型有固定的 `Inputs`、`State` 和 `Outputs`。`step` 返回输出和下一状态，
`evaluate` 还返回操作是否有定义。没有符号配置参数。
位运算直接使用 Lean 的 BitVec；存储器是地址位向量到数据位向量的函数，写操作产生新函数。

Yosys 的官方 `clk2fflogic` 保留边沿检测，会引入采样状态。
一个 FunctionalIR 步是一个全局采样步；一个硬件周期由执行器先输入低时钟、再输入高时钟组成。
所以状态字段数可能多于原电路寄存器数，不能把采样状态当成新增硬件寄存器。

执行器要求显式给出全部初态，包括存储器每个地址的值。
它检查原电路和 Yosys 辅助状态中已确定的初始位；其余位仍由调用者提供。
特别注意：官方 FunctionalIR 的 SMT 导出器把未知初始位打印成零，
本入口舍弃这些 SMT 初态断言，从同时导出的 JSON 恢复已知位约束。

数据 X/Z 和未驱动信号经官方 `setundef -anyseq` 变成额外输入，名称为 `c2l_undefined_*`。
调用者也必须给这些输入提供值。模型采用二值补全语义，不表示 IEEE 四值仿真的 X/Z 传播。
除零有单独的执行条件：未选中的分支可以含除零，实际观察或更新涉及除零则执行失败。

轨迹使用生成 IR 中的原始端口名，reset 也是普通输入。初态可以写入 JSON 文件：

```powershell
python scripts/yosys_simulate.py generated/design/Yosys/Design.ir.json --trace trace.json --initial-file initial.json --evidence experiments/design-run
```

也可以重新执行验收脚本保存的完整请求：

```powershell
python scripts/yosys_simulate.py experiments/yosys-7.3/Queue3/model/Yosys/Queue3.ir.json --request experiments/yosys-7.3/Queue3/lean/request.json --evidence experiments/queue-replay
```

## 验收和香山

```powershell
python scripts/fetch_xiangshan_dependencies.py
python scripts/verify_yosys.py
python scripts/check_yosys_contracts.py
python scripts/verify_yosys_proof.py
```

行为比较需要现有 Verilator、C++ 编译器和 Make。实验重新执行官方 Chisel 展开和 RTL，
再比较真正运行的 Lean 输出。香山依赖由 [固定清单](../verification/xiangshan/config-dependencies.json) 管理，
没有替换 XSModule、CDE 或硬件逻辑。

本轮 [行为报告](validation-yosys-7.3.json) 包含 7 组配置、18,841 拍、115,500 次 RTL 输出比较，
以及 92,418 次独立整数规格检查：

- 四位 Counter、三层 65 位握手流水线、65 位有符号运算；
- 原版香山 `AluDataModule`：全部 128 个操作码值，16,000 拍；
- 原版香山 `L2TlbPrefetch`：768 拍，包含停顿、过滤、刷新和复位；
- 标准 Queue 深度 3、数据宽度 8：Mem 和 SyncReadMem 两种实现，各 640 拍。

前五组另与现有 FIRRTL → Lean 路线完成 105,260 次输出交叉比较。
因此已有 FIRRTL 工作可以继续使用；新入口补上了它当前拒绝的存储器 Queue。
两条路线共享官方展开等组件，这种交叉比较不能代替独立的正确性证明。

[边界报告](validation-yosys-contracts-7.3.json) 检查时钟、复位、外部模块、验证语句、
未知值、部分已知初态、除零和存储器范围，还执行两路掩码写口的同址优先级检查。
将真实 Counter 模型中的加法故意改为减法，比较能检测到差异。

[Counter 证明](validation-yosys-proof-7.3.json) 对新生成的四位模型做 Lean 内核检查：
允许任意计数值、任意使能/复位和任意额外未知输入，证明单周期行为与整数规格一致，
并用归纳覆盖任意长度的有限输入序列。前一采样时钟为高是循环状态的约定。
证明没有 sorry 或新增公理；内核输出只列出 Lean 已有的 propext。

实验把未知初始位和额外任意输入选择为零，并给 Verilator 使用 `--x-initial 0 --x-assign 0`。
这是明确的实验条件，不表示硬件保证零上电，也不验证所有未知值选择。
有限测试和这一指定模型的证明，不构成整个转换器的通用正确性证明。

## 支持范围

已接入 FunctionalIR 的位向量运算、比较、Mux、移位、拼接、扩展、存储器读写和同步状态。
SystemVerilog 由固定版 Yosys 内置的 slang/sv-elab 前端读取；层次由官方工具展开。
没有自己实现 SystemVerilog 解析器或 Scala 配置分析。

目前限定单个直接连接的上升沿时钟。异步复位、门控时钟、多时钟、锁存器、外部模块，
以及需要单独契约的验证/仿真语句会报错。
本轮存储器限定零起始地址且至少两个字，尚未验证任意大 SRAM 宏和复杂读写冲突策略。
当前 CLI 接收一个包含所需模块定义的 RTL 文件，尚未做完整外部工程文件清单管理。
工具安装锁目前仅提供 Windows x64；其他系统需要增加对应 wheel 锁。

因此可以使用真实香山配置转换已验收模块，尚不能转换整颗香山。

开源接口依据：[Yosys FunctionalIR](https://yosyshq.readthedocs.io/projects/yosys/en/latest/yosys_internals/extending_yosys/functional_ir.html)、
[固定版官方导出器](https://github.com/YosysHQ/yosys/blob/v0.70/backends/functional/smtlib.cc)、
[YoWASP](https://github.com/YoWASP/yosys)、[sv-elab](https://github.com/povik/sv-elab)。
