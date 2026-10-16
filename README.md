# Chisel2Lean4

把固定配置的 Chisel 电路转换成可运行的 Lean 4 模型。例如先确定 `n=3`，再转换这个具体电路。

## 实现

`Chisel / firtool → SystemVerilog → Yosys FunctionalIR → Lean 4`

复用官方工具处理 Scala、香山配置和电路展开。我们实现 FunctionalIR 到 Lean 的导出器，用 `BitVec` 表示运算，用状态和更新函数表示寄存器、存储器。

当前版本：Chisel 7.3.0、Yosys 0.70（整颗导入另用原生 0.70+16）、Lean 4.19.0。

## 使用

先在原工程中生成 SystemVerilog，再运行：

```powershell
python scripts/yosys2lean.py design.sv --top Design --out generated/design
```

生成 `generated/design/Yosys/Design.lean`，默认检查 Lean 编译。安装和完整示例见 [使用说明](docs/yosys-frontend.md)。

独立四态实验入口已验证组合逻辑及单时钟同步复位子集，采用显式状态转移，不替换默认二态流程，见 [四态使用与协作约定](docs/fourstate-frontend.md)。

## 验证

已通过 7 组配置、115,500 次 RTL 输出比较，包括 Counter、流水线、存储器 Queue，以及香山的 `AluDataModule` 和 `L2TlbPrefetch`。

香山模块源码没有修改，只新增外围构建、配置适配和端口包装。使用真实 `MinimalConfig(1)`；[源码核对](docs/validation-xiangshan-source-audit-7.3.json)和[测试报告](docs/validation-yosys-7.3.json)可查。

默认使用单时钟；多时钟和检查语句可加 `--clock-mode global --effects preserve`，使用约定见[说明](docs/yosys-frontend.md)。

整颗香山 `DefaultConfig` 单核已完成转换和 Lean 编译。基础运算、乘除法与压缩指令、浮点、访存、缓存逐出写回、异常、MPRV/Sv39 和外部中断程序已全部通过 RTL／Lean／Spike 三方对照，原始硬件未修改。
本轮八种程序共九次独立运行，结果和用法见[程序验证](docs/program-validation.md)。有限测试不代表所有输入序列的等价证明。

最新进度和接手步骤见[交接文档](docs/HANDOFF-2026-10-16.md)。整颗生成数据和工具缓存不随 Git 提交，可按说明重建。
转到服务器继续验证，使用[迁移说明](docs/server.md)中的数据包和分步入口。

项目基于 Chicala，保留 [Apache-2.0 许可证](LICENSE)，来源见 [NOTICE](NOTICE)。

本机现仅保留源码和文档，大型数据与验证已迁到服务器，见 [迁移说明](MIGRATION.md)。

## TODO

- [ ] 在明确的初态、时钟、复位和接口规则下，无论输入什么数据、以什么合法顺序到达、运行多少拍，原始 RTL 和生成的 Lean 都产生相同的可观察行为。
