# Chisel2Lean4

把 Chisel 模块转换成可以运行的 Lean 4 模型，用来检查电路行为，也方便在 Lean 中证明性质。
模块的位宽等构造参数会保留下来，生成的模型可以使用不同的参数值。

目前使用 Chisel 7.3.0、Scala 2.13.15 和 Lean 4.19.0。
项目还在开发中，支持范围见下文。

## 先跑一个例子

需要 Java 17 和 Python 3.10 以上，并设置好 `JAVA_HOME`。
在仓库根目录运行，首次构建需要联网：

```powershell
python scripts/bootstrap.py
python scripts/sbt.py writeToolClasspath reference/writeReferenceClasspath
```

然后转换示例计数器，再运行一段输入序列：

```powershell
python scripts/chisel2lean.py examples/Counter.scala --module Counter
python scripts/simulate.py generated/Counter.ir.json --params n=4 --trace examples/direct-counter-trace.json
```

转换会生成 `generated/Counter.lean` 和 `generated/Counter.ir.json`，并默认检查 Lean 代码能否编译。
这里的 `n=4` 表示四位计数器；可以改成其他合法位宽。
示例序列包含复位、计数和暂停，每拍边沿后的计数值是 `0, 1, 2, 2, 3, 0, 1`。

生成的 Lean 文件包含参数、输入、状态和输出。
`step` 计算下一拍状态，`output` 计算当前输出，可以直接用它们写证明。

## 转换自己的模块

把模块及其依赖的源码一起传入，`--module` 指定目标模块：

```powershell
python scripts/chisel2lean.py Design.scala Ports.scala --module mypkg.Design --out generated/my-design
```

父类、trait 和子模块需要参与转换时，也要提供相应源码。
额外依赖可以通过 `--classpath-file` 指定。真实 CDE 配置的用法见
[配置接入说明](docs/chisel7-configuration.md)。

另有一个入口可以把展开后的经典 FIRRTL 转成固定配置的 Lean 模型，
用法和支持版本见 [FIRRTL 前端说明](docs/firrtl-frontend.md)。

## 怎么实现的

源码入口走的是这条流程：

`Chisel 源码 → Scala 类型检查和 Chicala 前端 → 硬件中间模型 → Lean 4`

转换器主体用 Scala 实现，Python 脚本负责构建、运行和验证。
前端读取带类型的源码，中间模型整理端口、运算、连接和寄存器，处理位宽和状态更新规则。
Lean 后端再把它们写成参数化的数据结构和 `step`、`output` 函数。

香山部分使用真实的 CDE 依赖。转换器沿父类和 trait 查找配置 getter，
把模块用到的标量字段变成 Lean 参数；运行具体配置时，再由真实 CDE 查询对应的值。
FIRRTL 入口则读取已经展开的电路，接入同一套中间模型和 Lean 后端。

## 怎么检查结果

```powershell
python scripts/validate.py
python scripts/verify_xiangshan_config.py
```

第一条运行通用回归，比较 Lean 模型和原始 Chisel 生成的 RTL 输出。
第二条会下载锁定的香山及依赖源码，构建真实配置框架，验证原始 `RightShiftModule`。
RTL 仿真还需要 Verilator、C++ 编译器和 Make。

现有验证记录：

- [通用回归](docs/validation-chisel7.json)：51 个模型、128 组参数配置通过。
- [配置与继承](docs/validation-configuration-7.3.json)：20 组配置通过。
- [香山移位模块](docs/validation-xiangshan-config-7.3.json)：3 组配置、30,720 个周期的 Lean、RTL 和独立数学结果一致。

这些结果覆盖已测试的案例。整个转换流程、所有合法参数和所有输入序列上的等价性还没有证明。

## 目前的支持范围

源码入口支持常见的单时钟设计，包括 UInt/SInt/Bool、同步寄存器、条件赋值、
模块层次，以及支持范围内的 Bundle/Vec、生成循环和存储器。
遇到不支持的写法会报错。具体构造见 [支持列表](docs/support-matrix.md)。

真实香山的 `XSModule/CDE` 已经接入：可以解析支持范围内的父类、trait 和 getter，
把硬件实际使用的 Int/Boolean 配置字段映射到 Lean 参数。
`XSBundle` 继承、`Vec[Bundle]`、配置对象在子模块间传递和复杂配置计算仍需补齐。
目前还不能自动转换整颗香山。

更完整的使用演练见 [饱和累加器示例](docs/walkthrough-saturating.md)。
位宽、复位和状态更新的约定见 [语义说明](docs/semantics.md)。

## 来源与许可

项目基于 [Chicala](https://github.com/iscas-tis/chicala)，在其源码前端上增加了 Lean 后端和验证工具。
沿用 [Apache-2.0 许可证](LICENSE)，其他依赖与示例的来源见 [NOTICE](NOTICE)。
