# Vec[Bundle] 源码转换

现在可以转换参数化的 `Vec(n, new Packet(...))`，包括端口、寄存器、
整组连接、动态选择元素，以及选中元素后的字段读写。
Bundle 中的 Vec、嵌套 Bundle 和多层 Vec 也保留原来的参数化长度。

例如 `packets(i).header.valid` 会读取第 i 个元素的 valid 字段。
`saved(i).lanes(j) := value` 会更新这个位置，保留此前对其他位置的连接；
同一位置后面的连接优先，右侧寄存器引用仍读取旧状态。

## 先运行一个例子

在仓库根目录执行，工具安装方法见 [配置接入说明](chisel7-configuration.md)：

```powershell
python scripts/sbt.py writeToolClasspath
python scripts/chisel2lean.py tests/fixtures/aggregate/Supported.scala --module aggregate.BundleVectorPipeline --out generated/vector-demo
python scripts/simulate.py generated/vector-demo/aggregate/BundleVectorPipeline.ir.json --params n=2 w=3 m=2 --trace examples/aggregate/pipeline-trace.json --evidence experiments/vector-demo
```

这个例子有两个 Packet，每个 Packet 内还有两个 lane。
第一拍复位采样输入，`out.data` 得到 `[1, 2]`；第二拍关闭使能，仍保持 `[1, 2]`。
模型中的长度和位宽仍由 `n`、`w`、`m` 决定。

## 数据怎么表示

转换器按字段保存向量。例如 Chisel 的 `Vec(n, Packet)` 会生成：

```lean
data_data : Fin p.n.toNat → BitVec p.w.toNat
data_valid : Fin p.n.toNat → Bool
```

输入 JSON 也按字段给数组：`"data.data": [1, 2]`，
`"data.valid": [true, false]`。内层 Vec 使用嵌套数组，见
[完整轨迹](../examples/aggregate/pipeline-trace.json)。
IR 中的 `source_path` 记录这些列与原始 Chisel 叶端口的对应关系，
例如 `data.*.meta.code`。官方 RTL 比较按这个关系恢复原端口名。

## 已覆盖什么

- `RegInit` 复位采样、使能采样和保持。
- 整组、单元素、单字段连接，静态和动态多层索引。
- 连续部分写入、同址覆盖、旧状态反馈及复位优先级。
- `VecInit(Seq(...))`、`Seq.fill/tabulate` 和外层逐元素生成循环。
- UInt 截断/零扩展、SInt 符号扩展，以及聚合 Mux 后的位宽转换。
- 子模块中的向量 Bundle，以及真实 CDE 配置下的原版香山 `SfenceBundle`。

运行检查：

```powershell
python scripts/verify_aggregate.py
python scripts/check_aggregate_contracts.py
python scripts/verify_xiangshan_aggregate.py
```

前两项检查 [通用测试模块](../tests/fixtures/aggregate/Supported.scala)；
第三项使用完整真实框架和原版 `SfenceBundle`，测试顶层是本项目编写的
[SfenceVectorPipeline](../verification/xiangshan/config/reference/Vector.scala)。
RTL 来自原始 Chisel 类，经官方 Chisel/CIRCT 和 Verilator 执行；
再与执行的 Lean 模型、独立整数规格逐拍比较。

结果分别见 [聚合差分报告](validation-aggregate-7.3.json)、
[边界检查](validation-aggregate-contracts-7.3.json) 和
[香山 XSBundle 向量报告](validation-xiangshan-aggregate-7.3.json)。
通用测试共 23 组配置、1,472 周期、97,299 次输出比较；真实 XSBundle
测试共 3 组配置、192 周期、6,985 次输出比较。23 项边界检查全部通过。
复验时，只复用模型、运行时及重新生成的官方 RTL 完全相同的已执行轨迹；
各用例记录采用的是重新执行还是这类复验。
另有三条 [流水线模型定理](../verification/aggregate/VectorPipelineProof.lean)，
对任意模型参数和输入证明保持、使能采样及复位采样。
此前配置与香山案例的模型也重新生成并逐字节核对，见
[模型兼容性记录](../experiments/aggregate-regeneration-7.3/summary.json)。

## 当前限制

这项扩展沿用源码入口的单时钟同步复位和纯参数子集。
Bundle 字段集合与 Vec 层次必须匹配，Vec 长度需使用可匹配的符号表达式。
聚合 Mux / VecInit 还要求相同聚合类、声明位宽及 Vec 长度；直接聚合赋值
允许截断和扩展。测试中由官方 Chisel 检出了这一差别，原始失败记录保存在
[聚合 Mux 反例](../experiments/aggregate-mux-contract-7.3/official-rejection/reference/elaboration/stderr.log)。
动态索引仍按 Chisel 规则截断；截断后越界的观察会被执行器拒绝。
关闭的写入和复位覆盖的更新按实际执行分支检查。

通过 `val view = saved(i)` 这样的值别名再写入，目前会明确报错；
直接写 `saved(i).field` 即可。局部别名读取已支持。
空 Bundle、多层嵌套生成循环、聚合字面值/asTypeOf、泛型 Bundle 和任意 Scala 集合操作
仍不在本轮支持范围内。不支持的表达式会报源码位置。

有限测试和生成模型的性质证明，没有证明整个 Chisel 到 Lean 转换流程对所有程序正确。
