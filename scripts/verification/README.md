# 验证脚本

此目录按验证对象拆分二态与四态脚本实现：

- [`two_state/`](two_state/)：48 个二态验证、契约检查和回归实现。
- [`four_state/`](four_state/)：44 个四态验证与审计实现。

根目录原有脚本名保留为兼容入口；建议继续用 `python scripts/<脚本名>.py ...` 启动。这样旧文档、实验命令和脚本自身的仓库路径解析都保持兼容。逐文件职责见[脚本目录](../../docs/script-catalog.md)。

`verify_fourstate_f53.py`、`verify_fourstate_f55.py`、`verify_fourstate_f56.py` 暂留 `scripts/` 根目录，因为它们会扫描同目录源码并将结果写入来源指纹。
