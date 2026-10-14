# Chisel2Lean4

把固定配置的 Chisel 电路转换成可运行的 Lean 4 模型。例如先确定 `n=3`，再转换这个具体电路。

## 实现

`Chisel / firtool → SystemVerilog → Yosys FunctionalIR → Lean 4`

复用官方工具处理 Scala、香山配置和电路展开。我们实现 FunctionalIR 到 Lean 的导出器，用 `BitVec` 表示运算，用状态和更新函数表示寄存器、存储器。

当前版本：Chisel 7.3.0、Yosys 0.70、Lean 4.19.0。

## 使用

先在原工程中生成 SystemVerilog，再运行：

```powershell
python scripts/yosys2lean.py design.sv --top Design --out generated/design
```

生成 `generated/design/Yosys/Design.lean`，默认检查 Lean 编译。安装和完整示例见 [使用说明](docs/yosys-frontend.md)。

## 验证

已通过 7 组配置、115,500 次 RTL 输出比较，包括 Counter、流水线、存储器 Queue，以及香山的 `AluDataModule` 和 `L2TlbPrefetch`。

香山模块源码没有修改，只新增外围构建、配置适配和端口包装。使用真实 `MinimalConfig(1)`；[源码核对](docs/validation-xiangshan-source-audit-7.3.json)和[测试报告](docs/validation-yosys-7.3.json)可查。

当前支持部分单时钟、两态电路，尚不能转换整颗香山。有限测试通过不代表所有输入序列的等价证明。

项目基于 Chicala，保留 [Apache-2.0 许可证](LICENSE)，来源见 [NOTICE](NOTICE)。
