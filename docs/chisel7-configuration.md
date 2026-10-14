# Chisel 7.3 与真实配置接入

当前工作区使用 Chisel 7.3.0、Scala 2.13.15、Lean 4.19.0、sbt 1.8.2、
Java 17 和 CIRCT firtool 1.135.0。升级前 v0.2 的报告保留为历史记录。
当前验证分别记录在 `validation-chisel7.json`、`validation-configuration-7.3.json`
和 `validation-xiangshan-config-7.3.json`。

## 转换行为

转换器在 Scala typer 后收集源码中的类和 trait，沿 Scala 线性化顺序处理
父类硬件声明与连接，绑定父类构造参数，并解析实际被调用的成员。
纯 getter 使用具体类/最右 trait 的覆盖定义；private/final getter 保持静态绑定。
继承的参数辅助函数可以带 Int/Boolean 参数。寄存器、同步旧状态读取和
连接顺序继续由原有 IR 处理。

对 `Parameters` 构造参数，转换器沿 getter 和不可变别名展开到真实 CDE 查询，
收集硬件需要的 Int/Boolean 叶字段，将其变为符号化 Lean 参数。
不会将一个选定配置的值硬编码进模型；未使用的 Seq、Option、函数等复杂
配置字段不进入 Lean Params。

可以在模块构造参数或纯标量 getter 上使用 [`@LeanParam`](lean-param.md)，显式要求保留其符号表达式。
例如 `@LeanParam def width: Int = p(CoreKey).width` 会沿真实 CDE 查询记录依赖；注解不实现集合配置或条件硬件布局。

例如原始香山代码保持如下声明：

```scala
class RightShiftModule(implicit p: Parameters) extends XSModule {
  // 原始 IO 与硬件语句
}
```

解析链是 `XSModule -> HasXSParameter.XLEN -> coreParams.XLEN -> p(XSCoreParamsKey).XLEN`，
生成模型中的参数为：

```lean
structure Params where
  cfg_p_xiangshan_XSCoreParamsKey_XLEN : Int
```

IR 的 `configuration` 字段记录配置根、singleton Field key、字段路径、
构造参数顺序、使用的 getter、继承链及源位置。运行时桥接通过这些记录
自动查询真正的 CDE 对象，导出对应参数，同时可将同一对象交给原始模块
构造器生成官方 RTL。

## 验证真实香山模块

所有命令在仓库根目录执行。Windows 使用已配置的 Python，首次安装需要网络。

```powershell
python scripts/bootstrap.py --sbt --lean --firtool
python scripts/verify_xiangshan_config.py
```

该命令下载锁定的完整香山、Rocket Chip、CDE、HuanCun、Utility、Difftest、
HardFloat 和 Fudian 源码，编译真实框架，并直接向转换器提供完整的
`Alu.scala`、`XSCore.scala`、`Parameters.scala`。
模块声明、父类、trait、配置记录和硬件主体均不使用替代定义。
依赖提交见 `verification/xiangshan/config-dependencies.json`。
实际处理的香山提交为 `997cd5b35cfbd26586674aa553d0f04b27914cb2`。

验证使用原版 `top.MinimalConfig(1)` 和完整 `XSCoreParameters`。
本地 `NanhuCoreConfig` 只将第一个 tile 的配置接到叶模块使用的 `XSCoreParamsKey`；
`NanhuWidthConfig` 用真正的 CDE `alter/up` 和记录 `copy` 建立测试变体。
64 位采用实际配置；8/32 位是孤立移位模块的参数变体，并不声明完整处理器支持 RV32。

测试包括 30,720 周期、184,320 个输出值：
Python 独立整数规格、执行的 Lean 模型、原始类生成的 CIRCT/Verilator RTL 三方一致。
8 位时逐输出穷举 256 个数据值与 64 个移位量；其他配置覆盖角落值、逐位模式
和随机组合。这是有限测试覆盖，不是四个输入端口的全笛卡尔积穷举。
三个移位规格定理对任意生成模型参数/输入通过 Lean 内核检查。
另有故意映射错误 XLEN 的检测实验。

## 在自己的工程中使用

将目标、父类和 trait 的源码一并传入；二进制 classpath 能提供类型，但不能
提供用于展开 getter 的方法体。额外依赖 classpath 可以放在文本文件中。

```powershell
python scripts/chisel2lean.py Module.scala Parents.scala Params.scala --module my.Module --classpath-file dependency-classpath.txt --out generated/my-project
python scripts/materialize_config.py generated/my-project/my/Module.ir.json --factories factories.json --constructor constructor.json --classpath-file dependency-classpath.txt --out parameters.json
python scripts/simulate.py generated/my-project/my/Module.ir.json --config-snapshot parameters.json --trace trace.json
```

`dependency-classpath.txt` 在映射阶段还需包含本工程编译后的模块、配置类、
真实 CDE 和 `reference.ConfiguredModule` 桥接类；香山示例已经由 sbt 自动写好。
多个配置根分别指定工厂。`factories.json` 形如：

```json
{"p": {"class": "my.ProjectConfig", "args": [64, true]}}
```

`constructor.json` 只提供普通 Int/Boolean 构造参数，没有这些参数时可省略。
工厂可以使用真实 Config 组合、默认 Field、`site/here/up`、`alter`；转换器投影
的是组合后的查询结果。`materialize_config.py --rtl-dir ...` 还会展开原始模块。
参考路径在外层使用透明 IO 包装，为每个叶端口提供合法、唯一的 RTL 名称，
以避免猜测 CIRCT 对 `bit` 等保留字及名称碰撞的重命名。

## 配置在模块层次和 Bundle 中传递

现在可以把构造参数中的真实 `Parameters` 原样传给有源码的子模块和命名 Bundle。
转换器先分析子类实际使用的字段，再按原始构造参数的位置，把这些字段绑定到父类的配置根。
因此，父模块即使没有直接查询配置，也会自动获得子模块需要的 Lean 参数。
不同配置根保持独立；同一个根的同一字段只生成一个参数。普通 Int/Boolean 构造参数仍保留。
依赖收集在继承展开之后进行，也覆盖父类中声明的子模块。

Bundle 可以继承有源码的父类和 trait，包括原始 `XSBundle / HasXSParameter`。
继承字段、命名 Bundle 嵌套和标量配置位宽沿用原有字段展开机制，支持整体连接和 Bundle 寄存器。
字段位宽中的算术表达式和 Scala if 分支也会随实例替换参数，避免不同配置的实例串用位宽。
`Vec[Bundle]` 的端口、寄存器、整体连接与动态字段读写现已接入，见
[聚合向量说明](vector-bundles.md)。泛型 Bundle 和任意构造逻辑仍未支持。
Bundle 构造体中的 `require`、连接等独立语句目前明确拒绝；参数约束可以写在外层 Module 中。
这些语句不会被悄悄忽略。

通用例子见 [Hierarchy.scala](../tests/fixtures/configuration/Hierarchy.scala)：
两层子模块交换、重命名配置根，父类中创建子模块；另一个例子在不同配置宽度的
继承 Bundle 之间进行带使能和复位的寄存器传递。

这组测试检出并修复了旧前端的参数替换缺口。例如来源配置宽度为 5、目标为 2 时，
`tag` 字段应从 6 位截成 3 位，输入 14 应得到 6。旧实现错误保留了 14，
现在与独立计算和原始 RTL 一致，见 [原反例修复检查](../experiments/configuration-width-repair/summary.json)。
回归同时包含算术位宽和条件位宽，以及相同类型 Bundle 的多个配置实例。

```powershell
python scripts/verify_configuration.py
python scripts/verify_xiangshan_hierarchy.py
```

第二条使用本地测试顶层组合原始 `LeftShiftModule`、`RightShiftModule`，
并将原始 `SfenceBundle` 放进一个带复位、使能的流水线。
原始模块、Bundle、XSModule/XSBundle 和配置依赖保持不变；测试顶层是本项目编写的，
不是香山上游的完整处理器模块。宽度变体仅用于这些孤立案例。
模型与官方 Chisel/CIRCT/Verilator RTL、独立整数规格逐拍比较。
已完成 6 组配置、2,112 个周期、18,048 次输出比较，见
[层次与 XSBundle 验证](validation-xiangshan-hierarchy-7.3.json)。
另有三条 Lean 模型定理，覆盖任意参数和输入下的关闭使能保持、使能采样、复位采样；
证明对象是生成的流水线模型，见 [SfencePipelineProof.lean](../verification/xiangshan/config/SfencePipelineProof.lean)。

配置对象必须来自当前模块的构造参数。模块内部新建配置、调用 `alter` 后再传给子模块，
以及任意函数对配置对象的处理，仍不在这一转换子集内；真实 CDE 工厂中的配置组合不受此限制。

## 通用回归与限制

```powershell
python scripts/validate.py
python scripts/verify_configuration.py
python scripts/verify_xiangshan_config.py --skip-build
```

通用配置回归涵盖继承寄存器、trait 连接优先级、getter 覆盖、带参/无参 getter、
父构造参数表达式、Bool 分支、嵌套记录、多个配置根及 Field 默认值。
当前共通过 32 组配置、1,848 个周期、6,768 次输出比较和 10 项拒绝检查，
并检出故意交换子模块配置根的错误。见 [配置回归记录](validation-configuration-7.3.json)。

当前明确拒绝：缺少父类源码、泛型父类、辅助构造器、显式 super 调度、
覆盖/遮蔽的 concrete val、覆盖的构造 val、读取尚未初始化的成员、继承的
eager 配置 val、递归/重载 helper、动态 Field key、被硬件使用的集合/Option
配置、配置对象的任意宿主计算。继承的纯配置 getter 使用 `def`。
原样传递构造配置的子模块和 XSBundle 继承已纳入上述子集。
模块内改变配置、Bundle 独立构造语句等仍未支持；
不能据此声称已转换整颗香山处理器。

上面的限制针对保留符号参数的源码路线。新增的
[官方展开入口](modern-firrtl.md) 可由实际 Chisel 工程执行更复杂的配置和 Scala
构造，再将支持范围内的硬件转成固定配置 Lean 模型；两种能力分别验收。

Lean 类型检查、规格定理和有限 RTL 对照并不构成 Scala/CDE/Chisel 到 Lean
全过程、所有合法参数和所有输入序列的等价证明。报告保持这一限制为 false。
