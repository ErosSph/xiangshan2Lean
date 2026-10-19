# Chisel2Lean4

将 Chisel 源码、已展开的 FIRRTL 或 SystemVerilog 电路转换成可执行的 Lean 4 模型。不同入口保留的参数、规范化方式和语义范围不同，请先看对应说明。

## 项目导航

- [文档总目录](docs/README.md)：使用、架构、验证、环境和历史交接。
- [当前状态](docs/status.md)：最近记录的里程碑和未完成范围。
- [脚本职责图](scripts/README.md)：转换入口、模型执行器、工具链和验证脚本的区别。
- [脚本逐文件目录](docs/script-catalog.md)：203 个 Python 脚本的用途说明与分类。
- [框架重构计划](docs/refactor-plan.md)：已执行范围、兼容边界和后续批次。
- [源码入口概览](docs/project-overview.md) · [支持矩阵](docs/support-matrix.md) · [语义约定](docs/semantics.md)

## 最短路径

需要仓库锁定的 Java、Lean、sbt 和其他工具；安装步骤见[环境说明](docs/environment.md)。

将 Chisel 源文件编译成参数化 Lean 模型：

```powershell
python scripts/chisel2lean.py Design.scala --module mypkg.Design --out generated/design
```

转换已展开的 SystemVerilog：

```powershell
python scripts/yosys2lean.py design.sv --top Design --out generated/design
```

入口比较、FIRRTL 用法和生成模型的执行方式见[项目概览](docs/project-overview.md)及[Yosys 前端说明](docs/yosys-frontend.md)。

## 范围

转换器只接受文档列出的硬件语言子集；不支持的构造应明确报错。请用[支持矩阵](docs/support-matrix.md)选择入口，并按对应验证报告理解实际覆盖。有限回归不能推出任意 Chisel、SystemVerilog 或所有输入轨迹下的普遍等价。

四态 RTL 是独立实验入口，范围和当前阻塞见[四态前端文档](docs/fourstate-frontend.md)，不会替换默认二态流程。

## 许可

项目基于 Chicala 并保留 [Apache-2.0 许可证](LICENSE)，来源见 [NOTICE](NOTICE)。
