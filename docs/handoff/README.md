# Chisel2Lean 交接包

本包只包含交接文档，不含已实现的转换器、用户 GitHub fork 或已运行的实验结果。

## 文件

- `CHISEL2LEAN_HANDOFF.md`：完整项目任务、固定范围、架构、源码核对、语义边界、T0 任务卡、里程碑和验收标准。
- `AGENTS.md`：精简的项目工作规则。
- `CODEX_START_PROMPT.md`：可直接发送给 Codex 的启动指令。

## 使用

将文件放到为 Chisel2Lean 选定的项目目录。目录已有同名文件时先检查并合并，不要直接覆盖；尤其要保留已有 AGENTS.md 中仍适用的规则。

在该工作区打开 Codex，将 `CODEX_START_PROMPT.md` 的正文发送过去。首个任务是 `T0-CHICALA-FRONTEND-AUDIT`，不是立即实现全部翻译器。

固定范围：**只做 Chisel → 参数化 IR → Lean 4 自动翻译**。不做 Agent、自动规格、自动证明、证明知识库或论文结果复现。

上游基线、工作区和实际工具版本要由 Codex 接手后复核。包中的远程源码核对不等于本地环境已可构建。
