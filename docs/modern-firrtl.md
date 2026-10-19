# Chisel 7.3 官方展开入口

现在可以把原工程按实际配置展开，再转成 Lean，不必让源码转换器逐个理解
Scala 集合、泛型、trait 和 CDE 构造过程。它们由官方 Chisel 执行；本入口处理
展开后的硬件。输出是固定配置模型，运行时输入仍然可变。

工具固定为 Chisel 7.3.0、Scala 2.13.15、CIRCT firtool 1.135.0、Lean 4.19.0。
经典 FIRRTL 入口保留，两条入口共用现有 IR 和 Lean 后端。

## 先运行一个例子

在仓库根目录执行：

```powershell
python scripts/bootstrap.py --sbt --lean --firtool
python scripts/sbt.py classicFirrtl/writeFirrtlClasspath reference/writeReferenceClasspath
python scripts/elaborate_chisel.py --module probes.Counter --constructor examples/modern/counter-constructor.json --out generated/modern-counter-original --lean-out generated/modern-counter
```

构造参数文件是 `[4]`。输出目录中，原电路包含 `design.fir`、官方生成的
`Chisel2LeanReference.v` 和端口映射 `ports.json`；模型包含
`FIRRTL/Chisel2LeanReference.lean`、对应 IR、规范化的 MLIR 和来源清单。
生成模型默认经过 Lean 类型检查。

已有现代 FIRRTL 时，直接执行：

```powershell
python scripts/firrtl2lean.py design.fir --out generated/design
```

`--frontend auto` 是默认设置：经典文本走原入口，现代文本走 CIRCT。
现代版本范围明确限制为 2.0.0 到 6.0.0，主要验收格式为 Chisel 7.3 产生的
6.0.0；不接受未来版本号。`--top` 可选择其中的模块。

运行轨迹使用 `firrtl_simulate.py`。reset 是真实输入字段，初态必须显式提供，
以 IR 中的端口和寄存器字段为准。验证脚本已经完成这一步。
零初态和 Verilator 的 `--x-initial 0` 是实验条件，不表示硬件保证零上电。

## 接入自己的工程

先用工程原有构建流程编译目标类和依赖，将它们以及 `reference.ElaborateChisel`
桥接类放入 classpath 文件，然后指定模块类、构造参数和 classpath：

```powershell
python scripts/elaborate_chisel.py --module my.ProjectModule --constructor constructor.json --classpath-file project-classpath.txt --out generated/original --lean-out generated/model
```

构造参数按原始构造器的位置填写，可以使用 Int、Boolean、String，或递归构造
真实对象的 `{"class":"包名.配置类","args":[...]}`。当前要求同一参数数量下
恰有一个 public 构造器；复杂工厂可以在工程中提供一个简单入口。

这里不会从固定电路恢复符号参数。需要保留 `n`、`XLEN` 时，继续使用
[源码入口](chisel7-configuration.md)。

## 怎样转换

1. 官方 Chisel 使用原类和真实构造参数生成 CHIRRTL；另一次官方展开独立生成 RTL。
   外层只添加透明端口包装，用稳定名称连接原始模块，硬件主体保持原样。
2. CIRCT 先解析输入。转换器在优化前检查不支持的存储器、验证语句、
   外部模块、异步复位和显式未知值，避免它们在后续流程中消失。
3. CIRCT 推导位宽、解析复位类型、展开 Bundle/Vec 与 when，并保留模块层次。
   使用固定工具输出的通用 MLIR 格式，按 SSA 身份读取值。
4. `CirctMain` 将已知位宽的标量操作接到现有适配器，再进入 Normalize 和 LeanEmitter。
   不把现代文本交给旧解析器，也不让旧编译器重新推导现代输入的位宽。
5. Lean 模型保留同时更新寄存器、旧状态读取、连接优先级和真实 reset 端口。
   来源清单记录输入、编译器、CIRCT、MLIR 和读取器的 SHA256。

采用 SSA 是为了保持值的身份。CIRCT 的可读 FIRRTL 导出在当前工具版本下可能
包含重名提示或空名，不能直接当作本入口的语义桥接格式。
多位选择器 `multibit_mux` 按 CIRCT 的反向操作数顺序导入，越界观察保留定义域检查。
格式和操作语义参考 [MLIR 通用语法](https://mlir.llvm.org/docs/LangRef/#operations)
与 [CIRCT FIRRTL dialect](https://circt.llvm.org/docs/Dialects/FIRRTL/#firrtlmultibit_mux-circtfirrtlmultibitmuxop)。

## 香山目前做到哪一步

真实依赖固定在 [依赖清单](../verification/xiangshan/config-dependencies.json)，
香山提交为 `997cd5b35cfbd26586674aa553d0f04b27914cb2`。
使用原版 `MinimalConfig(1)`，通过现有 `NanhuCoreConfig` 将首个 tile 的实际配置
绑定到叶模块需要的 `XSCoreParamsKey`。没有替换 XSModule、CDE 或硬件定义。

- 源码路线已验证原始移位模块，并把使用的标量配置字段保留为 Lean 参数。
- 原始 XSBundle 及其向量已放入本地流水线、层次测试顶层验证；这些顶层是测试代码。
- 现代展开路线新增原始 `L2TlbPrefetch`：包含 11 个状态字段，测试停顿、重复请求、
  sfence、satp 更新、同时输入输出和复位。
- 现代展开路线新增原始 `AluDataModule`，包含原模块的 10 个子模块，覆盖全部
  128 个操作码值。旧版 v2.1 的 ALU 验证单独保留，不混为同一次实验。

复现新实验：

```powershell
python scripts/fetch_xiangshan_dependencies.py
python scripts/verification/two_state/verify_modern_firrtl.py
python scripts/verification/two_state/check_circt_contracts.py
python scripts/verification/two_state/verify_modern_bridge.py
```

行为结果见 [现代入口验证](validation-modern-firrtl-7.3.json)，
边界检查见 [契约检查](validation-modern-firrtl-contracts-7.3.json)。
本轮共通过 9 组配置、18,610 拍、110,424 次输出比较和 87,924 次独立整数检查。
其中 ALU 为 16,000 拍、96,000 次输出比较；预取模块为 768 拍、4,608 次输出比较。
另有 13 项边界检查，覆盖不支持结构、未来版本、非法字符、无效值和除零。
每个行为用例都重新执行官方 RTL 和 Lean；独立整数规格在报告中注明检查的输出。
四位 Counter 另有 [同版本模型桥接证明](validation-modern-bridge-7.3.json)，
覆盖所有初态及任意长度的有限使能/复位序列。

## 还有哪些限制

配置对象的宿主计算可以由原工程实际执行，生成的电路仍需落在支持的硬件范围内。
本入口目前拒绝 FIRRTL 存储器、多时钟、门控时钟、异步复位、BlackBox、探针、
验证或仿真副作用，以及显式 `DontCare/invalidvalue`。

显式未知值需要单独说明：CIRCT 的 when 展开可以把含未知分支的表达式化简成
一个确定分支，即使关闭优化也可能发生。当前在展开前拒绝这类输入；尚未实现
跨官方规范化流程传播未定义条件。运行时除零等已保留操作的定义域由执行器检查。

因此，目前尚未完整接入标准 Queue 的存储器实现，也不能转换整颗香山。
后续优先补存储器及未知值传播，再处理更大的队列和流水线模块。
有限测试、模型性质和指定模型间的等价证明，均不构成整个转换器的通用正确性证明。
