# 香山到 Lean：服务器运行

工具已配置，原始 RTL 和迁移包保留。当前任务目录是 `runs/20261016-linux-01`。

查看进度：
```bash
tail -f deployment-logs/whole-20261016-linux-01.stdout
```

查看整颗对照结果：
```bash
cat runs/20261016-linux-01/acceptance.json
```
只有该文件中的 `status` 为 `PASS` 才算完整短场景通过；小自检通过不代表整颗通过。

需要重新运行时，使用一个尚不存在的工作目录：
```bash
./server.sh all --work "$PWD/runs/second" --jobs 4
```

这一轮是 DefaultConfig 单核、96 个采样点、81 个实际输出的二态对照，不包含完整程序执行，也不是所有输入序列的等价证明。
日志及资源采样保存在 `deployment-logs`。不要在本机直接运行 Z 盘上的脚本；计算应在 SSH 登录后的服务器运行。
