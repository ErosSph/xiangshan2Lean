# 程序验证

测试对象仍是锁定的 Nanhu `DefaultConfig` 单核 `XSTop`，原始香山 RTL 没有修改。

现在分三步验收：

1. 给原始 RTL 接外部 AXI 内存，加载程序，记录全部物理输入和输出。
2. 用官方 Spike 执行相同程序，核对提交 PC、整数寄存器写回和提交后的 GPR 重建结果。
3. Lean 复放相同输入，核对每个采样点的输出、只读观测信号，以及 Lean 自己算出的提交 PC 和写回数据。

第三步全部结束并得到 `RTL_LEAN_RETIREMENT_PASS`，才算这一条程序的三方对照通过。
`RTL_PROGRAM_COMPLETED` 只表示 RTL 跑到了结束标记；`RTL_SPIKE_PC_GPR_PASS` 只表示 RTL 与指令参照一致。

## 已有用例

| 程序 | 内容 |
| --- | --- |
| `integer.S` | 运算、分支的两种结果、跳转、提交 |
| `arithmetic.S` | 有符号／无符号乘除法、除零、溢出、移位边界和压缩指令 |
| `floating.S` | F/D 运算、开方、融合运算、转换、NaN 和异常标志；通过 GPR 检查结果 |
| `smoke.S` | 循环、冷读、读写和 fence |
| `cache.S` | 写入 64 条冲突缓存行，再读回；检查真实 DRAM 写回数据 |
| `traps.S` | M 态 ecall、非法指令、异常处理和 mret |
| `sv39.S` | MPRV/Sv39 页表遍历、译址读写、缺页异常和返回 |
| `interrupt.S` | AXI 读应答延迟期间拉高外部中断，经 PLIC 领取、完成中断并 mret，检查读回数据 |

2026-10-17 核查：表中八种程序均已通过完整 RTL／Lean／Spike 三方对照，共九次独立运行，包含 `smoke.S` 的 ROM 和 DRAM 两种取指方式。
缓存用例也已完成：602 条实际提交、94,104 个采样点、240,718,032 项输出及只读观测值比较一致，并检查了实际外部 DRAM 写回数据。
报告、轨迹、程序镜像、原始 RTL、模型和执行器哈希核对通过；缓存的完整 Lean 输出文件也已重新计算哈希和行数。
最新逐项状态见[服务器测试记录](validation-programs-server-7.3.json)，本次完整性核查见[核查记录](validation-program-audit-2026-10-17.json)。
浮点用例检查程序取出的结果位及部分 `fflags`，尚未逐项比较完整浮点寄存器和 CSR 状态。

## 在服务器使用

服务器根目录的 `server.sh` 提供 `program`、`isa`、`retirement-replay` 和串联三步的 `accept-program`。
`program` 返回本次的 `PROGRAM_DIRECTORY`；后续命令使用这个目录。

```bash
./server.sh program --work runs/20261016-linux-01 --observe
```

默认执行 `smoke.S`。用 `--program` 指定其他汇编文件；加 `--dram-text` 会通过 ELF 分段加载，先执行复位 ROM 跳转代码，再从 DRAM 经指令缓存取指。
ELF 使用锁定的 pyelftools 0.32 解析；指令参照使用官方 Spike v1.1.0 提交 `530af85d83781a3dae31a4ace84a573ec255fefa`。
安装入口是 `scripts/bootstrap_elftools.py` 和 `scripts/bootstrap_spike.py`，依赖放在项目自己的 `.tools` 中。

`isa --program 目录` 核对提交；缓存用例可再加 `--verify-writeback`。
`retirement-replay --help` 列出 Lean 对照所需的模型、执行器及匹配的回归报告。
每次运行保存程序、驱动、输入、输出、提交记录、日志和哈希，保留此前结果。

也可直接执行完整流程（当前服务器已安装这些工具和模型）：

```bash
./server.sh accept-program --work runs/20261016-linux-01 \
  --model runs/20261016-linux-01/model-observed-v4 \
  --runner runs/20261016-linux-01/runner-progressive-10 \
  --validation runs/20261016-linux-01/incremental-regression/20261016T115153Z-883fb904/summary.json \
  --program source/20261016-full-local-project/ICT/chisel2lean4/verification/xiangshan/programs/integer.S
```

只有最终 `program-acceptance.json` 为 `RTL_LEAN_SPIKE_PROGRAM_PASS` 才表示整个流程通过；出现差异会停止并保存反例。
中断用例使用 `--program .../interrupt.S --irq-on-read-wait`。它给 `0x50000000` 的外部读请求增加 500 拍延迟，记录实际 AXI 事务和中断引脚时刻。
Spike 没有周期模型，所以在实测的精确异常提交边界注入 MEIP；测试用的参考外设仅实现 PLIC 源 1／M 上下文 0。
RTL 与 Lean 仍比较真实引脚轨迹的每个采样点。参考外设不代表完整 PLIC 模型。

当前实验明确选择未知初值和任意输入为零，同时保留所有已知初态约束。复位保持 32 个主时钟周期，每周期记录四个采样点。
PC 来自实际 FTQ 元数据和 PC 存储，写回数据来自实际寄存器文件；没有按程序文本猜测提交结果，也没有直接设置 CPU 内部状态。

这些是固定配置、明确初态下的有限测试。本轮验收用例已全部完成；更长的真实程序、更多中断时序和更广的指令覆盖仍需扩展，所有合法输入序列上的等价证明留作后续工作。
