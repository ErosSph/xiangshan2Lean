# 交给 Codex 的启动提示词

请接手 **Chisel2Lean** 项目。先读取当前项目适用的 `AGENTS.md`，再完整读取 `CHISEL2LEAN_HANDOFF.md`，不要假设你能看到之前的聊天记录。

我们的目标和路线已经确定：

**fork Chicala → 审查并复用源级 Typed AST 与相应 Pass → 参数化语义 IR → Lean 4 后端。**

现在只做 Chisel → Lean 4 自动翻译，保留支持范围内的参数和硬件行为。标准 Chisel/CIRCT/兼容 RTL 路线仅用于独立对照。不要加入 Agent、自动规格、自动定理证明、证明库、参数化 RTL 后端或论文结果复现。

请先执行 **T0-CHICALA-FRONTEND-AUDIT**，不要立即大规模实现后端：

1. 确认当前工作区、现有文件、Git 状态和实际环境。工作区或 fork 目标缺失且无法判断时，只询问必要信息；不要使用其他项目的路径或仓库。
2. 核对 handoff 记录的 Chicala 上游提交和构建版本。审查真实代码与构建脚本，再尝试原始示例的编译/翻译，并保存命令、退出码和完整日志。
3. 追踪参数、require、符号宽度、RegInit、when、旧状态/下一状态、输出与 Pass 前后的变化。用少量独立探针检查参数分支和数组结构；不支持也要作为审查结果记录。
4. 输出 `docs/frontend-audit.md`、`docs/support-matrix.md`、`docs/environment.md`、`docs/decisions.md`、`TASKS.md` 以及 `experiments/t0_frontend_audit/` 下的证据。
5. 明确说明可复用部分、缺口、建议的 IR/Lean 后端接入点，以及 M1 最小文件级计划。完成 T0 报告后先汇报，不自动扩展到下一阶段。

请把“远程源码观察”“实际构建成功”“执行成功”“语义对照通过”严格分开。若构建被阻塞，继续能够完成的静态审查并标记 PARTIAL/BLOCKED，不能伪造成功，也不能用手写 Counter Lean 模型代替真实翻译。

不要仅回复一份计划。在工作区与权限足够时，实际进行上述审查和基线尝试；需要破坏现有文件、全局安装或远程发布时先确认。
