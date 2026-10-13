# 香山 RightShiftModule 验证

本文记录升级前的独立参数框架实验。当前 Chisel 7.3 已接入真实完整 CDE、
XSModule、HasXSParameter 和配置依赖；当前用法与证据见
[chisel7-configuration.md](chisel7-configuration.md)。

本例选择香山南湖 ALU 的 `xiangshan.backend.fu.RightShiftModule`。
原始模块同时提供逻辑右移、算术右移以及使用独立移位输入的第二路逻辑右移。
香山实际配置为 XLEN=64，两个移位输入均为六位。

## 来源与独立配置适配

官方源码固定为提交 `997cd5b35cfbd26586674aa553d0f04b27914cb2`：
[Alu.scala 中的 RightShiftModule](https://github.com/OpenXiangShan/XiangShan/blob/997cd5b35cfbd26586674aa553d0f04b27914cb2/src/main/scala/xiangshan/backend/fu/Alu.scala)。
完整原文件、Parameters.scala 和上游 LICENSE 保存于
`verification/xiangshan/right-shift/upstream/`。
SHA256 与适配记录见
[SOURCE.json](../verification/xiangshan/right-shift/SOURCE.json)。

转换器目前要求直接继承 Module，构造参数为 Int/Boolean。
因此独立输入文件只做以下类声明替换：

```scala
// 原声明
class RightShiftModule(implicit p: Parameters) extends XSModule {
// 独立声明
class RightShiftModule(val XLEN: Int) extends Module {
```

两份声明之后的整个类体保持一致；验证脚本在运行前检查逐字一致性和
固定上游文件校验值。其三个硬件输出原样保留：

```scala
io.srl := io.srlSrc >> io.shamt
io.sra := (io.sraSrc.asSInt >> io.shamt).asUInt
io.revSrl := io.srlSrc >> io.revShamt
```

RTL 参考文件保留原类声明和原类体。测试专用框架只提供该类使用的
该类需要的 XLEN 配置值及 `XSModule` 基类；一个普通 Module 包装器转接
所有端口，使 RTL 驱动能通过 Int 构造参数实例化原类。
本实验没有构建整个香山处理器，也没有宣称支持完整 CDE 或 XSModule 体系。

## 三条独立检查路径

1. 独立输入源码经当前 Chisel2Lean4 生成参数化 Lean，默认通过 Lean 类型检查，
   然后执行生成模型。大量输入从 JSON 在运行时读取。
2. 原始香山类经官方 Chisel 3.5.6/FIRRTL 1.5.6 生成 RTL，再用 Verilator 执行。
   此路径只从接口描述读取构造参数，不从语义 IR 定义电路行为。
3. Python 使用无界整数、二补码解码和右移计算数学预期，不解释转换器 IR。

每个输入检查三个输出的边沿前、边沿后数值，要求数学预期、Lean 和 RTL
三者相等。本模块无寄存器，复位不会改变组合输出。

## 复现

先按主 README 安装固定依赖，然后在仓库根目录运行：

```powershell
python scripts/verify_xiangshan_right_shift.py
```

默认验证 XLEN=8、32、64。64 位是实际香山配置；8/32 位是独立适配版本的
辅助配置。8 位输入安排保证每个输出函数都经历全部 256 个数据值和全部
64 个移位量；这不等同于穷举四个输入端口的完整笛卡尔积。
较大配置覆盖边界数、walking-one/zero 模式、全部移位量和固定种子的
独立随机输入。随机部分还切换复位。

短演示可以使用公开转换/执行入口：

```powershell
python scripts/chisel2lean.py examples/xiangshan/RightShiftModule.scala --module xiangshan.backend.fu.RightShiftModule --out generated/xiangshan-right-shift
python scripts/simulate.py generated/xiangshan-right-shift/xiangshan/backend/fu/RightShiftModule.ir.json --params XLEN=64 --trace examples/xiangshan/right-shift-trace.json
```

第一组输入为 `0x8000000000000000`，右移一位：逻辑结果为
`0x4000000000000000`，算术结果为 `0xc000000000000000`。
第二组算术输入为全一，右移 63 位后仍为全一；相同逻辑输入右移 63 位为 1。

## 通用模型证明与故障注入

[RightShiftProof.lean](../verification/xiangshan/right-shift/RightShiftProof.lean)
给出三个由 Lean 检查的定理：对任意模型位宽和任意输入，三个生成输出
分别等于标准 `BitVec` 逻辑/算术右移运算。证明没有 sorry、admit 或新增公理。
执行记录在 `experiments/xiangshan-right-shift/model-proof/`。

验证脚本还在隔离副本中删除算术右移前的 `asSInt`，保持交付源码不变。
输入最高位为 1、移位一位时，应检测到错误副本输出 `0x4000000000000000`，
数学规格和原 RTL 输出 `0xc000000000000000`。只有发现这一预期错误才判定
故障注入通过。

上述通用证明针对生成模型与 BitVec 规格；Scala/Chisel 源程序到 Lean 的
整条翻译链尚无形式化等价证明。源类体一致性、官方 RTL 对照和数学预期
共同提供该具体模块的工程验证证据。

## 结果文件

本机实际运行结果为 **PASS**：

| XLEN | 配置用途 | 输入周期 | 对照输出值 |
|---:|---|---:|---:|
| 8 | 辅助配置；每个输出函数的数据/移位量穷举及随机输入 | 16,896 | 101,376 |
| 32 | 辅助配置；边界、walking-one/zero 及随机输入 | 4,864 | 29,184 |
| 64 | 香山实际配置；边界、walking-one/zero 及随机输入 | 8,960 | 53,760 |
| 合计 | 三方一致 | 30,720 | 184,320 |

三个通用模型定理通过 Lean 检查；算术右移改为逻辑右移的隔离反例被正确发现。
短演示还通过公开 simulate.py 入口独立执行，并与原始 RTL 和数学规格对照。
这些具体模块结果独立于原 v0.2 的 51 模块/128 配置回归统计。
可查看 [结构化报告](validation-xiangshan-right-shift.json)。

完成运行后，汇总为 `experiments/xiangshan-right-shift/summary.json`。
各 XLEN 目录包含原始输入、Lean 执行输出、RTL 输出和 `comparison.csv`；
CSV 同列展示数学预期、Lean、RTL 的三个输出。
模型证明和故障注入保留各自的日志及结构化结果。
