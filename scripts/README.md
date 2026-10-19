# 脚本职责与入口地图

`scripts/` 包含用户命令、转换器实现、工具链构建器、模型执行器和验证/实验代码。验证与实验实现已按用途放入子目录；旧根目录桥接文件已移除。不要把整个目录当成“实验脚本”，也不要只按 `verify_` 等名字判断用途。

日常转换主要用下面几条 CLI；验证和实验脚本用于回归、审计、阶段实验或服务器流程，不会在每次转换时自动运行。逐文件用途见[脚本目录](../docs/script-catalog.md)。

## 真正执行转换的入口

| 命令 | 输入和职责 | 主要下游 |
|---|---|---|
| `python scripts/chisel2lean.py ...` | Chisel/Scala 源码 → 参数化硬件 IR → Lean；默认编译检查 | `src/main/scala/chicala`、Lean runtime |
| `python scripts/firrtl2lean.py ...` | 已展开 FIRRTL → 固定配置硬件 IR → Lean | Scala FIRRTL/CIRCT 前端、Lean runtime |
| `python scripts/yosys2lean.py ...` | SystemVerilog → Yosys FunctionalIR → Lean | Yosys、`functional_ir.py` 及 Yosys/Lean 导出模块 |
| `python scripts/fourstate2lean.py ...` | 受支持的四态 RTL → tag/value 编码 → 独立 Lean 模型 | 四态解析/编码模块，再调用 `yosys2lean.py` 后端 |

生成模型后的执行器是另一类入口：`simulate.py` 用于源码模型，`firrtl_simulate.py` 用于 FIRRTL 模型，`yosys_simulate.py` 用于 Yosys 模型，`fourstate_simulate.py` 用于四态模型。它们运行 Lean 模型，不负责解析原始 Chisel 源码。

## 构建和环境工具

- `bootstrap*.py`：安装或检查项目锁定的 Java/Lean/firtool/Yosys 等工具。
- `sbt.py`：在项目本地缓存和锁定设置下运行 sbt 命令。
- `elaborate_chisel.py`、`elaborate_xiangshan.py`、`lower_xiangshan.py`、`prepare_xiangshan_firrtl.py`：调用官方工程展开/规范化，或准备真实香山输入；只在对应输入流程中需要。
- `server*.py`、`package_release.py`、`migrate_workspace.py`：服务端场景、打包和迁移工具；不是一般转换必需项。

## 验证和实验脚本

- `validate.py`：编排源码翻译、Lean 检查、差分、拒绝项、故障注入和报告，是回归总控，不是普通单模块转换入口。
- [验证脚本目录](verification/README.md)：[`two_state/`](verification/two_state/) 有 48 个实现；[`four_state/`](verification/four_state/) 有 44 个实现。
- [四态实验驱动目录](experiments/four_state/README.md)：[`runners/`](experiments/four_state/runners/) 有 9 个阶段启动器。
- `verify_fourstate_f53.py`、`verify_fourstate_f55.py`、`verify_fourstate_f56.py` 暂留根目录，因为它们对同目录源码集合做指纹采样。
- `*_bench.py`、`audit_*.py`、`check_*.py`、`report*.py`：性能测量、边界/来源审计、契约检查或证据汇总。
- `tests/` 下的测试是小型自动检查；`verification/` 放硬件夹具/模型；`experiments/` 放逐次运行证据。三者用途不同。

验证脚本不参与每次用户转换，但它们支撑回归、复现历史结果和检查拒绝行为。是否仍在使用必须结合导入关系、文档命令、自动调用和报告中的源码哈希判断；仅凭命名无法认定可删。

直接从分类路径启动脚本，例如 `python scripts/verification/four_state/verify_fourstate.py ...`。脚本会自行加入仓库根目录和所属分类目录，解析共享模块与仓库资源。`scripts/experiments/` 只放实验驱动代码；每次运行的日志和原始证据仍放在仓库顶层 `experiments/`。

## 静态依赖观察

分类迁移前对 `scripts/*.py` 的字面 import 做过 AST 扫描。得到的本地模块导入闭包约为：源码入口 2 个，FIRRTL 入口 4 个，Yosys 入口 17 个，四态入口 35 个（包含它复用的 Yosys 后端）。这是迁移前的静态观察，不包含所有运行期导入/子进程，也不是删除清单。

## 目录重构进度

验证与实验代码已按用途移动 101 个实现：48 个二态验证/审计脚本放入 `scripts/verification/two_state/`，44 个四态验证/审计脚本放入 `scripts/verification/four_state/`，9 个阶段启动器放入 `scripts/experiments/four_state/runners/`。旧根目录桥接已删除；仓库内命令与测试引用已迁到分类路径。

Chisel 源码、FIRRTL 转换、Chisel 官方展开，以及参数化/FIRRTL Lean 模型执行器这五个实现模块已迁入 `python/chisel2lean4/` 下的 `frontends/` 和 `runtimes/`。`differential.py`、`verify_aggregate.py` 和四态来源快照清单已补入迁移实现的指纹。

公共 `common.py`、Yosys 主后端和四态转换实现暂留原位：它们被大量脚本导入，或参与源码哈希/证据快照。冻结的四态同步 profile 仍保留原归档文件名；本地同步脚本在读取时解析到新位置，远端包内仍按冻结路径布局。测试通过 `tests/conftest.py` 加入分类目录。当前 Python 包按仓库源码目录导入，尚未安装成独立 wheel；测试目录和实验产物未搬迁。
