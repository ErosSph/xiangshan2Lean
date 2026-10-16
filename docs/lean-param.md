# 用 `@LeanParam` 标记要保留的参数

源码入口现在认识普通 Scala 静态注解 `chisel2lean.LeanParam`。不需要宏，也不用给变量加特殊前缀。

```scala
import chisel3._
import chisel2lean.LeanParam

class Bank(@LeanParam val n: Int, @LeanParam val w: Int) extends Module {
  require(n > 0 && w > 0)
  @LeanParam val width: Int = w + 1

  val data = IO(Input(Vec(n, UInt(width.W))))
  val out = IO(Output(Vec(n, UInt(width.W))))
  val saved = RegInit(VecInit(Seq.fill(n)(0.U(width.W))))
  saved := data
  out := saved
}
```

生成的 Lean 仍有 `n` 和 `w` 参数。端口和状态的长度取决于 `n`，元素位宽取决于 `w + 1`。
`width` 是派生表达式，不会变成另一个可以随意填写的独立参数。

## 这版注解做了什么

- 支持 Module 构造参数上的 `Int`、`Boolean`，以及从参数派生的不可变成员 `val` 和无参 `def`。
- 支持父类、trait 和子模块参数绑定。父类的 `width` 接到子类的 `n + 1`，记录的就是 `n + 1`。
- 支持真实 CDE 的标量投影。例如在模块或参数 trait 中写 `@LeanParam def width: Int = p(CoreKey).width`。
- IR 的 `leanParameters` 记录注解声明、源位置、实例路径、符号表达式和依赖参数。CLI 清单还记录注解库的 SHA-256。
- 按注解类的完整符号识别，导入别名也能使用；其他包里的同名注解不会被误认。

原来无需注解就能保留的参数仍然保留。加注解表达一个显式要求，不会改变正常 Chisel 展开的硬件行为。

参数仍遵守 Scala `Int` 的范围和运算回绕规则，源代码中的 `require` 进入模型合法条件。
不支持可变参数、可变或 lazy 成员、带参数的方法、硬件信号，以及 `Seq/Option` 本身。
注解应写在声明上；类型使用位置的注解和 Bundle 内部的注解会明确报错。Bundle 的位宽可继续使用外层 Module 保留的参数。
`@LeanParam val n = 4` 也会被拒绝：注解不能把一个常量程序改成任意 `n` 的程序。可以使用带默认值的构造参数 `@LeanParam n: Int = 4`。

## 运行示例

在仓库根目录执行：

```powershell
python scripts/chisel2lean.py examples/leanparam/Counter.scala --module example.Counter --out generated/lean-param --rebuild
```

输出包含 `example/Counter.lean`、`.ir.json` 和 `manifest.json`，默认通过 Lean 编译检查。
转换自己的普通模块时，源码入口的工具类路径已经包含注解库。需要 CDE 或其他工程依赖时，另传 `--classpath-file`。

带参数化向量、父类、子模块和真实 CDE 的例子在 [`Supported.scala`](../tests/fixtures/leanparam/Supported.scala)。

原工程使用官方 Chisel 编译时，把小型注解库放进编译类路径即可。库的源码在
[`annotations`](../annotations/src/main/scala/chisel2lean/LeanParam.scala)，由 `leanAnnotations/packageBin` 构建；不需要把整个转换器加入硬件工程。

验证命令：

```powershell
python scripts/verify_leanparam.py
```

该命令实际运行 Lean 和独立的官方 Chisel RTL，并与整数规格比较，同时检查参数追踪和拒绝诊断。
结果见 [验证报告](validation-leanparam-7.3.json)。有限测试不构成转换器的通用正确性证明。

## 还需要继续做的结构支持

注解让转换器知道哪些符号必须保留，但不会替转换器实现新的结构语义。
目前 `Vec(n, ...)`、参数化位宽和已有向量上的生成连接可用；以下结构仍明确拒绝：

```scala
val children = Seq.fill(n)(Module(new Lane))
val extra = if (enabled) Some(IO(Input(UInt(8.W)))) else None
```

下一步需要加入同构子模块数组的参数化状态和连接，再处理条件端口、条件寄存器和 `Option` 布局。
注解应当标在标量数量或开关上。异构 `Seq` 还需要描述每个元素的类型和配置，仅保留长度不够。

此约定属于 **Chicala 源码入口**。官方展开后的 CIRCT/FIRRTL 入口仍生成指定配置的模型，不能从已经展开的电路恢复这些符号。
