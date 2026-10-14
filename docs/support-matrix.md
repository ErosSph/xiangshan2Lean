# Chisel 7.3 支持矩阵

当前结果见 experiments/differential-v0.3-{full,edge,control,extension}
及 experiments/rejections-v0.3；错误检测见 experiments/mutation-v0.3。
此前 v0.2 / Chisel 3.5.6 报告保留为历史记录。
配置与继承扩展另通过 32 组配置及 10 项拒绝检查；真实香山层次/XSBundle
测试通过 6 组配置，详见 chisel7-configuration.md。
Vec[Bundle] 扩展另通过 23 组通用配置、3 组真实 XSBundle 配置及
23 项边界检查，详见 vector-bundles.md。
下表按语言构造定义能力；电路名称只是回归样例。

| 构造 | 实现状态 | 回归样例/限制 |
|---|---|---|
| Scala typer / Chisel 7.3.0 源前端 | 已实现 | Scala 2.13.15；官方参考使用 CIRCT firtool 1.135.0 |
| Module 父类和 trait、父构造参数绑定 | 已实现子集 | ConfiguredPipeline、InheritedPrimitive；需要父类源码 |
| 继承 getter 覆盖、纯参数 helper | 已实现子集 | Scala 线性化顺序，private/final 静态绑定；初始化风险拒绝 |
| 真实 CDE Int/Boolean 字段投影 | 已实现子集 | singleton Field、嵌套 case-class 字段、多个配置根、Field 默认值 |
| CDE 配置原样传入子模块、命名 Bundle | 已实现子集 | 配置字段递归投影，保留根和构造参数位置；不支持模块内部 alter/新建配置 |
| Bundle / XSBundle 父类、trait 与嵌套命名 Bundle | 已实现子集 | 继承字段展开、整体连接和寄存器；需要所有相关源码 |
| 真实香山 XSModule / HasXSParameter | 已验证叶模块 | 原始完整 Alu.scala 的 RightShiftModule；真实完整配置依赖 |
| Int / Boolean 参数、require | 已实现 | Counter、BoolGate；Int 范围/溢出反例 |
| 参数 +、-、*、/、%、负号、比较、布尔表达式 | 已实现 | Int 回绕，纯参数表达式，条件合法域 |
| 纯参数辅助函数和不可变参数别名 | 已实现 | HelperWidth；递归/副作用不支持 |
| 参数化 UInt / SInt / Bool | 已实现 | Arithmetic、SignedArithmetic、BoolState |
| 独立 IO、匿名/命名 Bundle IO | 已实现 | DirectCounter、NamedBundle |
| 无状态 RawModule | 已实现 | BoolGate、ReservedPorts |
| Wire、节点、连续组合依赖 | 已实现 | CombinationalDependencies；环/未连接拒绝 |
| when/otherwise/elsewhen、后连接优先级 | 已实现 | Priority；嵌套条件按源顺序处理 |
| 寄存器同时更新、保持 | 已实现 | DualRegister、Counter |
| RegInit 一/两参数、Reg、RegNext、RegEnable 二/三参数 | 已实现 | RegisterIdioms、InferredRegisters；同步复位优先 |
| 标量位宽推导、被覆盖连接的宽度约束 | 已实现 | RegInit(0.U)、Wire(UInt())；扩展反馈不收敛则拒绝 |
| Bundle 整体赋值、Bundle 寄存器 | 已实现 | BundlePipeline；支持字段展开和 Bundle 引用初始化 |
| +、-、+&、-&、*、比较、Mux | 已实现 | Arithmetic、SignedArithmetic |
| 位运算、负号、逻辑操作、Cat、pad、head、tail、Fill | 已实现 | ExtendedBits、MoreBits |
| 切片/单比特选择、orR/andR/xorR | 已实现 | BitOperations |
| 静态/动态左右移、动态位选择 | 已实现 | MoreBits；遵守 Chisel 结果位宽 |
| UInt/SInt 除法和余数 | 已实现 | SignedDivision、MoreBits；除数必须非零 |
| switch/is、Enum | 已实现 | SwitchMachine；case 要求字面值/枚举常量 |
| MuxLookup、MuxCase、PriorityMux | 已实现 | MuxPriorities；优先级及完整查表优化按源 API 处理 |
| 纯硬件辅助函数及局部不可变硬件量 | 已实现 | HardwareHelper；不支持递归或带状态的辅助函数 |
| Scala if 分支、条件临时位宽 | 已实现 | ElaborationWidth、ElaborationLiteral |
| 参数化 Vec 端口、Vec 寄存器 | 已实现 | VecLoop、VecRegisters、VecIndex |
| Vec[Bundle]、嵌套聚合和多层索引写入 | 已实现子集 | BundleVectorPipeline/Writes、NestedBundleVector；按字段保留参数化向量，见 vector-bundles.md |
| 聚合 Mux、聚合 VecInit、聚合位宽转换 | 已实现子集 | Mux/VecInit 要求类型、宽度、长度匹配；直接连接支持 UInt/SInt 截断及扩展 |
| 完整/部分 until 区间循环、局部别名 | 已实现 | PartialGenerate；逐元素 Vec 连接，量化合法条件 |
| VecInit(Seq(...))、Seq.fill/tabulate | 已实现 | LiteralVector、VectorReset、TabulatedVector |
| 动态 Vec 读写 | 已实现 | RegisterFile、Fifo；索引截断和有效范围条件 |
| 同步高有效复位、输入决定的复位值 | 已实现 | ResetFromInput、MixedReset |
| 非复位寄存器的显式初态 | 已实现 | 模型不提供伪造的 resetState |
| 参数化子模块、多层层次、多 IO 子模块 | 已实现 | HierarchicalPipeline、NestedHierarchy、HierarchicalComb |
| 异步读 Mem | 已实现 | AsyncMemory；单写端口，显式初始存储状态 |
| 一拍读 SyncReadMem | 已实现 | SyncMemory；单写端口、Bool 读使能、默认 Undefined 冲突语义 |
| FIFO、寄存器文件 | 组合设计回归 | Fifo 深度 2/3/8；RegisterFile 长度 1/2/3/8 |
| BlackBox、模拟/外部逻辑 | 不支持 | 需要提供外部语义模型，当前拒绝 |
| 异步复位、withClock/withReset、多时钟 | 不支持 | 明确诊断 |
| 参数控制 IO/寄存器/实例布局、循环创建实例 | 不支持 | 当前生成循环作用于已声明的 Vec |
| 多写端口/掩码存储器、显式 ReadFirst/WriteFirst | 不支持 | 冲突模型尚未实现，拒绝 |
| Mux1H、Decoupled/Queue 标准库封装、运行时 assert | 不支持 | 可用支持的基本构造写对应电路；未知调用拒绝 |
| 任意 Scala、递归/可变宿主计算 | 不支持 | 只支持明确的纯参数子集 |
| 动态 CDE key、集合/Option 配置、模块内构造/改变配置对象 | 不支持 | 原样传递构造配置已支持；不声明完整香山处理器已支持 |
| generic 父类、显式 super、eager 配置 val | 不支持 | 配置 getter 使用 def；初始化语义有明确边界 |
| Bundle 构造体中的 require、连接等独立语句 | 不支持 | 明确拒绝；约束可写在外层 Module，避免漏掉构造条件 |
| 自动规格/定理证明 | 不属于本项目 | 不生成 sorry/admit/新公理 |

宽度规则和上下文约定见 semantics.md。Bundle 复位支持 Bundle 引用；
asTypeOf/BundleLiterals 聚合字面值尚不支持。Vec 元素需要统一位宽；
生成循环不能改变元素类型或布局。未知语法产生可定位编译失败。
Vec 的元素支持标量、嵌套 Vec 和支持范围内的 Bundle。Vec[Bundle] 按字段
展开为参数化向量；原端口布局记录在 IR source_path 中。别名读取支持，
通过值别名写入明确拒绝；生成循环目前支持最外层逐元素连接。

差分驱动支持多字宽端口，并实际验证了 65/128 位配置。Lean 模型采用
参数化 BitVec 与 Fin 函数，没有把模型固化为某个测试位宽或深度。
