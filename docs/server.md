# 在服务器运行

当前服务器为 Ubuntu 20.04 x86_64，已配置 Python 3.13、Lean 4.19.0 和 Verilator 5.048。
工作根目录是 `/data2/home/lvhongqing/cgt/chisel2lean`，本机可从 `Z:\chisel2lean` 浏览。
可编辑源码及完整项目备份见[迁移说明](../MIGRATION.md)。大型转换和验证在服务器执行。

整颗 `DefaultConfig` 单核已通过短场景对照：81 个输出、两组场景共 192 个采样点，31,104 项比较一致。
两组报告路径和哈希见[验收汇总](validation-xiangshan-whole-differential-7.3.json)，基础场景报告是
`runs/20261016-linux-01/acceptance.json`。工具和来源见[Linux 记录](validation-server-linux-7.3.json)。
短整数程序已通过 RTL／Lean／Spike 三方对照：9 条实际提交、4,284 个采样点、10,958,472 项输出及只读观测值比较一致。
缓存、基础异常、Sv39，以及访存等待期间的外部中断程序已通过 RTL／Spike，其 Lean 对照仍在进行。
`accept-program` 可连续执行 RTL、Spike 和 Lean，并保存最终验收状态，使用见[程序验证](program-validation.md)。所有输入序列上的等价证明尚未完成。

## 使用

SSH 登录后：

```bash
cd /data2/home/lvhongqing/cgt/chisel2lean
./server.sh doctor --with-rtl
./server.sh verify
./server.sh compare --work runs/20261016-linux-01
```

`server.sh` 使用可编辑源码中的工具，读取原来的不可变迁移包，自动指定本机工具路径。
迁移包中的 1,347 个文件继续按原哈希校验；原始 RTL 和已通过的结果均保留。
需要从头执行时，用新目录：

```bash
./server.sh all --work runs/new-run --jobs 4
```

也可分别用 `init`、`selftest --with-rtl`、`lean`、`rtl`、`compare`，各步使用同一 `--work`。
已有模型和工具不变时，续跑复用已编译产物。每次 RTL 尝试独立保存驱动、输入、日志、结果和哈希。

## 增加场景

```bash
./server.sh scenario --work runs/20261016-linux-01 --reset-reassertion
./server.sh scenario --work runs/20261016-linux-01 --scenario /path/to/scenario.json
```

自定义 JSON 包含 `description` 和 `trace`，每个采样点的 `inputs` 必须提供全部 68 个物理输入。
工具检查端口、位宽和初态来源；继承原实验记录的初态及全零任意输入选择，再独立执行 RTL 与 Lean。
每组场景写入新的 `runs/.../scenarios/<时间>/`，不会覆盖基础场景的验收报告。

RTL 先在明确的全零输入下求值一次，再从采样点 0 施加复位。该启动条件记录在 `startup.json`，
不计入比较点数，也不直接修改内部寄存器。全部断言保持启用，错误会记录实际采样点并停止。
这解决了此前初始复位为高、模拟器却未看到复位边沿而导致的 MSHR 启动断言问题。

只有每组 `acceptance.json` 为 `PASS` 才表示该有限场景对照通过。缺拍、缺端口和任何输出差异都会失败。
当前是二态显式采样模型；全零未知位是本轮测试选择，不能推广为任意初态、四态仿真或完整处理器正确性证明。
