# 四态实验驱动

[`runners/`](runners/) 收纳 9 个四态阶段控制脚本。它们负责启动指定实验或远程流程；转换/验证逻辑和每次运行产生的证据分别保留在各自实现模块和仓库顶层 `experiments/fourstate/`。

根目录原有 `run_fourstate_*.py` 名称保留为兼容入口。运行这些阶段脚本时继续使用 `python scripts/run_fourstate_<阶段>.py ...`；`runners/` 中保存对应的分类实现，供维护和源码快照使用。
