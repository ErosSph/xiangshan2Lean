# Chisel2Lean4：FIRRTL → Lean 4

把官方 Chisel 工具展开后的 FIRRTL 电路转换成可运行的 Lean 4 模型，用来检查指定配置的硬件行为，也方便在 Lean 中证明性质。
前端使用 Scala FIRRTL 1.5.6，生成模型使用 Lean 4.19.0。项目仍在开发中。

## 两个入口有什么区别

源码入口读取“怎样生成电路”，FIRRTL 入口读取“已经生成好的电路”。本页介绍 FIRRTL 入口。

| 对比 | Chicala 源码入口 | FIRRTL 入口 |
|---|---|---|
| 输入 | Chisel 模块及相关源码 | 官方展开后的 `.fir` 电路文件 |
| 配置参数 | 支持的参数保留在 Lean 中 | 参数已经落实成具体位宽和电路结构 |
| 前端任务 | 解析 Scala、继承、配置读取和支持的生成结构 | 解析寄存器、连接、位运算和模块实例 |
| 适合的工作 | 参数化建模和性质证明 | 指定配置的真实电路建模和验证 |

例如，`Counter(n)` 按 `n=4` 展开后，本入口生成四位计数器模型。配置固定，但运行时输入仍可变化。

## 先跑一个例子

需要 Java 17、Python 3.10 以上，并设置好 `JAVA_HOME`。在仓库根目录运行，首次安装和构建需要联网：

```powershell
python scripts/bootstrap.py --sbt --lean
python scripts/sbt.py classicFirrtl/writeFirrtlClasspath
```

转换四位计数器，再执行一段输入序列：

```powershell
python scripts/firrtl2lean.py examples/firrtl/Counter4.fir --out generated/firrtl-demo
python scripts/firrtl_simulate.py generated/firrtl-demo/FIRRTL/Counter.ir.json --trace examples/firrtl/counter-trace.json --initial-state '{"cnt":0}' --evidence experiments/firrtl-demo-run
```

生成的模型位于 `generated/firrtl-demo/FIRRTL/Counter.lean`，并默认经过 Lean 编译检查。
示例每拍边沿后的计数值是 `0, 1, 2, 2, 0`，结果保存在 `experiments/firrtl-demo-run/result.json`。

复位信号放在轨迹的 `inputs` 中；寄存器初态必须显式提供，组合电路使用 `--initial-state '{}'`。
本例的零初态是实验条件，不表示硬件保证零上电状态。

## 转换自己的电路

先通过原工程的官方 Chisel 构建流程生成支持版本的 `.fir` 文件，然后运行：

```powershell
python scripts/firrtl2lean.py design.fir --top Design --out generated/design
```

`--top` 指定目标模块，省略时使用文件声明的顶层。
输出包含 `.lean`、`.ir.json`、规范化后的 FIRRTL 和来源清单。输入端口、状态字段以生成的 IR 为准。

## 怎么实现的

`FIRRTL → 官方解析与规范化 → 硬件 IR → Lean 4`

官方 FIRRTL 库处理位宽推导、Bundle/Vec 展开和连接优先级；前端处理模块连接及寄存器，并复用已有的 IR 和 Lean 后端。
生成模型中的 `step` 计算下一拍状态，`output` 计算当前输出。所有寄存器同时从旧状态和当前输入计算下一状态。

## 怎么检查结果

```powershell
python scripts/verify_firrtl_frontend.py
python scripts/check_firrtl_contracts.py
python scripts/verify_firrtl_bridges.py
```

分别运行行为回归、不支持输入与故障注入检查，以及指定配置下两端生成模型的 Lean 等价证明。
RTL 仿真还需要 Verilator、C++ 编译器和 Make。

现有验证记录：

- [FIRRTL 回归](docs/validation-firrtl.json)：22 项配置、34,155 个周期、595,699 次输出比较通过。
- [香山 v2.1 验证](docs/validation-xiangshan-firrtl.json)：验证真实 RightShift 和 AluDataModule；ALU 含 10 个子模块，覆盖 128 个操作码值，完成 153,600 次输出比较。
- [模型等价证明](docs/validation-firrtl-bridges.json)：四位 Counter 覆盖全部初态和任意长度的有限输入序列；64 位 RightShift 覆盖全部输入。

回归包含历史 Chisel 3.5.6 展开产物，香山实验使用 v2.1 的 Chisel 3.5.3。
有限测试和指定配置的模型等价证明，不构成整个转换流程的通用正确性证明。

## 目前的支持范围

支持经典 FIRRTL 文本版本至 1.1.0，以及旧的无版本头格式；支持常见 UInt/SInt 运算、Mux、聚合展开、多层模块和单时钟同步寄存器。

暂不支持现代 FIRRTL 6.x、FIRRTL Mem/SyncReadMem、多时钟、门控时钟、异步复位、BlackBox/ExtModule 和验证语句。
不支持的结构会报错；除零、无效 validif 等未定义观察会被执行器拒绝。

详细用法、复位约定和香山实验复现步骤见 [FIRRTL 前端说明](docs/firrtl-frontend.md)。

## 来源与许可

项目基于 [Chicala](https://github.com/iscas-tis/chicala)，FIRRTL 前端的电路图组织和状态更新实现参考 [GSIM](https://github.com/OpenXiangShan/gsim)。
保留 [Apache-2.0 许可证](LICENSE)，香山派生电路及其他依赖的来源和许可见 [NOTICE](NOTICE)。
