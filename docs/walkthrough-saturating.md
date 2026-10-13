# 用一个新电路验证 Chisel2Lean4

本例从新写的 [SaturatingAccumulator.scala](../examples/SaturatingAccumulator.scala)
开始，经转换器生成参数化 Lean，再分别执行 Lean 与原始 Chisel 的官方 RTL。
最后把两路输出与预先定义的数学行为比较。

## 先写清楚电路的预期行为

这是一个单时钟、同步复位的饱和累加器，构造参数 `w` 是数据位宽。

- `reset`：在有效上升沿将累加值和溢出标志清零。
- `clear`：清零，优先于 `en`。
- `en=true`：累加 `data`；超过 `2^w - 1` 时保持最大值。
- `en=false`：保持累加值和标志。
- `overflow`：表示清零或复位后曾经发生过溢出，置位后保持。

刚好达到最大值不会置位 `overflow`。例如四位累加器先达到 15，随后再加
1，值仍为 15，此时才置位溢出标志。

数学预期用 Python 的任意精度整数计算：

```python
if reset or clear:
    value, overflow = 0, False
elif en:
    total = value + data
    overflow = overflow or total > (2**w - 1)
    value = min(total, 2**w - 1)
```

这段预期计算不读取 IR 或生成的 Lean。另有手写的四位
[输入序列](../examples/saturating-accumulator-trace.json)和
[预期输出表](../examples/saturating-accumulator-expected.json)，用来检查预期计算本身。

## 先看四位的手算例子

下面列出全部 18 个定向周期。输出均是当前上升沿后的值。

| 周期 | reset | clear | en | data | 预期 value | 预期 overflow |
|---:|---:|---:|---:|---:|---:|---:|
| 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 1 | 0 | 0 | 0 | 9 | 0 | 0 |
| 2 | 0 | 0 | 1 | 5 | 5 | 0 |
| 3 | 0 | 0 | 1 | 7 | 12 | 0 |
| 4 | 0 | 0 | 0 | 9 | 12 | 0 |
| 5 | 0 | 0 | 1 | 3 | 15 | 0 |
| 6 | 0 | 0 | 1 | 1 | 15 | 1 |
| 7 | 0 | 0 | 1 | 9 | 15 | 1 |
| 8 | 0 | 0 | 0 | 0 | 15 | 1 |
| 9 | 0 | 1 | 1 | 9 | 0 | 0 |
| 10 | 0 | 0 | 1 | 4 | 4 | 0 |
| 11 | 1 | 0 | 1 | 15 | 0 | 0 |
| 12 | 0 | 0 | 1 | 15 | 15 | 0 |
| 13 | 0 | 0 | 1 | 0 | 15 | 0 |
| 14 | 0 | 0 | 1 | 1 | 15 | 1 |
| 15 | 0 | 1 | 0 | 12 | 0 | 0 |
| 16 | 0 | 0 | 0 | 14 | 0 | 0 |
| 17 | 0 | 0 | 1 | 2 | 2 | 0 |

## 转换并执行 Lean

在仓库根目录执行；新环境先按 README 安装固定版本依赖。

```powershell
python scripts/chisel2lean.py examples/SaturatingAccumulator.scala --module walkthrough.SaturatingAccumulator --out generated/saturating-demo

python scripts/simulate.py generated/saturating-demo/walkthrough/SaturatingAccumulator.ir.json --params w=4 --trace examples/saturating-accumulator-trace.json --evidence experiments/saturating-directed
```

第一条读取 Chisel 源码，生成 `.lean`、`.ir.json` 和 manifest，并实际调用
Lean 4.19.0 进行检查。检查本次命令退出码为 0，以及
`generated/saturating-demo/manifest.json` 中的 `lean_checked: true`。

第二条实际执行 Lean，逐拍记录 `pre`、`post` 和 `state`。手算表应与
`experiments/saturating-directed/result.json` 的 `post` 字段一致。

## 一条命令做完整的三路对照

```powershell
python scripts/verify_saturating_example.py
```

[验证脚本](../scripts/verify_saturating_example.py)执行以下步骤：

1. 检查独立数学预期与手写的 18 周期输出表一致。
2. 将这个新源码加入本次 sbt 官方参考编译；该设置只在本次运行中生效。
3. 用 Chisel2Lean4 自动转换，并检查生成的 Lean。
4. 用真实 Chisel 3.5.6 官方插件/FIRRTL 生成 Verilog，再用 Verilator 执行。
5. 对每拍比较数学预期、Lean 和 RTL 两个输出，同时检查 Lean 的寄存器状态。

比较从第一拍复位边沿后开始；之后每拍都比较边沿前后输出。首次复位前
的 RTL 上电状态不作为已知状态。

默认对 `w=1、4、8` 各运行 18 个定向周期和 200 个固定种子的随机周期。
一次成功运行应同时满足：命令退出码为 0，汇总 `status` 为 `PASS`，
三个配置的状态均为 `PASS`。

本工作区已实际运行通过：

| 配置 | 周期 | 对照输出值 | 结果 |
|---|---:|---:|---|
| w=1 | 218 | 870 | PASS |
| w=4 | 218 | 870 | PASS |
| w=8 | 218 | 870 | PASS |
| 合计 | 654 | 2,610 | PASS |

每个“对照输出值”指一个采样点的一个信号；数学预期、Lean 与 RTL 在该
采样点都要一致。种子为 `20261013`，每个位宽使用 `seed + w`。

结果保存于 `experiments/saturating-demo`：

- `summary.json`：总体状态、源码和编译器 SHA256、配置和统计。
- `w4/expected.json`：独立数学预期。
- `w4/lean/result.json`：实际 Lean 执行结果。
- `w4/reference/result.json`：实际 RTL 执行结果。
- `w4/comparison.csv`：将输入、预期、Lean、RTL 并排排列。
- `w4/reference/rtl/`：实际生成的 Verilog 与仿真驱动。

只跑容易阅读的 18 个四位定向周期：

```powershell
python scripts/verify_saturating_example.py --widths 4 --random-cycles 0 --evidence experiments/saturating-directed-check
```

扩展测试长度或选择其他正位宽：

```powershell
python scripts/verify_saturating_example.py --widths 2 4 16 --random-cycles 1000 --evidence experiments/saturating-more
```

修改 Chisel 源码后再次运行，预期计算不会自动随源码改变：行为若与这里
定义的规格不同，应产生失败。改变设计规格时，需要独立审查并更新预期表
和数学规格。

## 验证过程是否能发现错误

```powershell
python scripts/verify_saturating_example.py --widths 4 --random-cycles 0 --negative-control --evidence experiments/saturating-directed-check
```

这个命令先验证正确电路，再制作隔离副本，把溢出分支的
`seenOverflow := true.B` 故意改成 `false.B`。隔离副本分别重新经过
Chisel2Lean4 和官方 Chisel 编译、执行。

本工作区实际在第 6 拍发现以下结果：

| 检查路径 | value | overflow |
|---|---:|---:|
| 独立预期 | 15 | true |
| 故障副本的 Lean | 15 | false |
| 故障副本的 RTL | 15 | false |

这里转换保持了故障源码的行为，设计却违反了“发生溢出后标志置位”的
规格，因此应拒绝。原始源码和正确模型保持不变。

汇总中的 `negative_control.status: PASS` 表示错误检测实验成功；
`observed_verification: FAIL` 表示故障电路本身未通过规格检查。
编译失败或仿真失败不会被当成负控成功，必须实际观察到 Lean 与 RTL
一致且与独立预期不一致。

这些检查验证当前源码在所选参数与轨迹下符合规格。结果中的
`formal_equivalence_proof: false` 保留，不能据此宣称所有参数和输入序列的
完整转换等价性已经证明。
