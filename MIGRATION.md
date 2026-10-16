# 项目已迁到服务器

本机保留源码、Git 历史、文档和小型测试代码。大型实验数据、生成结果和工具缓存已在完整备份校验通过后清理。

- 可编辑源码：`/data2/home/lvhongqing/cgt/chisel2lean/source/20261016-full-local-project/ICT/chisel2lean4`
- 完整备份：`/data2/home/lvhongqing/cgt/chisel2lean/windows-backup/20261016-full-local-project/workspace.tar.zst`
- 本机浏览源码：`Z:\chisel2lean\source\20261016-full-local-project\ICT\chisel2lean4`

完整备份约 8.77 GB，包含迁移前约 106 GB、167,222 个文件及目录链接。服务器已逐文件核对哈希，并检查 Git 数据；本机保留的 7,898 个文件也已复查哈希。
具体空间和校验结果见 [迁移记录](docs/migration-result-2026-10-16.json)。迁移工具及逐文件记录在 `E:\ICT\.migration\20261016-full-local-project`。

大型转换与验证在 SSH 登录后的服务器执行。现有验证入口位于 `/data2/home/lvhongqing/cgt/chisel2lean`，使用 `./server.sh`。
整颗 `DefaultConfig` 单核的短场景对照已通过：81 个输出、两组场景共 192 个采样点，31,104 项比较一致。
两组报告见[验收汇总](docs/validation-xiangshan-whole-differential-7.3.json)。复位启动问题已修复，原始硬件未修改。
2026-10-17 八种程序、九次独立运行已全部通过完整三方对照，包含缓存逐出写回长用例，最新结果见[程序验证](docs/program-validation.md)。
