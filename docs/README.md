# 文档导航

本页是仓库文档入口。README 负责项目简介和最短命令；本页按用途指向详细说明；`TASKS.md` 与各验证文档保留阶段记录和证据边界。

## 开始使用

- [项目概览与快速示例](project-overview.md)：源码入口、FIRRTL 入口、生成模型运行方式。
- [固定配置 RTL → Lean](yosys-frontend.md)：SystemVerilog/Yosys 转换、模型接口和执行约定。
- [现代 FIRRTL 入口](modern-firrtl.md)：调用官方 Chisel/CIRCT 展开后导入固定配置模型。
- [脚本职责与入口地图](../scripts/README.md)：哪些脚本转换、运行、构建或只做验证。
- [脚本逐文件目录](script-catalog.md)：按用途查看每个 Python 脚本的模块说明。
- [框架重构计划](refactor-plan.md)：当前迁移进度、兼容范围和下一批工作。
- [当前状态](status.md)：仓库记录中最新的项目状态及其时间范围。

## 架构、语义与支持范围

- [语义约定](semantics.md)：位宽、状态更新、复位和输出语义。
- [源码前端审计](frontend-audit.md)：Scala/Chisel 源码支持边界。
- [经典 FIRRTL 前端](firrtl-frontend.md)：已展开 FIRRTL 的处理范围。
- [支持矩阵](support-matrix.md)：Chisel 源码入口已实现和拒绝的构造。
- [设计决策](decisions.md)：已有实现决策及其依据。
- [参数化模型](lean-param.md) 与 [聚合向量](vector-bundles.md)：参数和聚合数据建模。
- [独立四态前端](fourstate-frontend.md)：四态接口、编码、范围、阶段证据和阻塞项；不替代默认二态流程。

## 验证和证据

- [v0.2 验收摘要](validation.md)：源码入口历史验收范围。
- [程序级验证](program-validation.md)：香山裸机程序对照及边界。
- [整颗香山模型](xiangshan-whole.md)：生成、执行和有限差分验证流程。
- [香山 RightShift 验证](verification-xiangshan-right-shift.md)：代表性真实模块用例。
- `validation-*.json`：机器可读报告。每份报告的通过结论仅限其记录的输入、版本、命令和比较范围；不要把有限回归扩大成普遍等价结论。
- `experiments/`：本地保留逐次运行的命令、日志、哈希、原始输出和中间产物。本次源码提交不包含新增的四态原始实验材料；克隆仓库后不能假定这些本地证据存在。

## 环境、服务器与协作

- [环境和工具版本](environment.md)
- [服务器流程](server.md)
- [迁移清单和恢复信息](../MIGRATION.md)
- [发布记录](publication-2026-10-16.md)
- [FIRRTL 集成协作约定](firrtl-integration-coordination.md)

## 历史交接

- [四态交接归档目录](handoff/README.md)
- [2026-10-15 交接快照](HANDOFF-2026-10-15.md)
- [2026-10-16 交接快照](HANDOFF-2026-10-16.md)

日期化交接和验证报告是历史快照。新状态应追加到对应的当前状态/阶段文档，并从本页建立链接；不要覆盖旧报告。
