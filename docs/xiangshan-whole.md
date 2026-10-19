# 完整香山的接入

目标是将原工程固定配置的整个 `XSTop` 转成 Lean，首先使用 `DefaultConfig`、单核。
原版 Scala、CDE、trait 和 SRAM 实现由原工程和官方编译器处理，不改写成简化硬件。

2026-10-16：完整 `DefaultConfig` 单核已在 Linux 服务器完成 Lean/原始 RTL 短场景对照，
81 个输出、两组场景共 192 个采样点，31,104 项比较一致。[验收汇总](validation-xiangshan-whole-differential-7.3.json)保留两组结果路径和哈希，
操作见[服务器说明](server.md)。尚未验收指令或完整程序运行，也没有所有输入序列上的等价证明。

完整 `top.TopMain` 展开已成功，包含 19,995 个模块声明、55,835 个寄存器声明、1,091 个存储器声明。
这些是优化、去重前的声明数，寄存器也可能包含聚合类型，不能当成物理单元数量。
各阶段结果以[完整记录](validation-xiangshan-full-7.3.json)为准；展开成功不表示 Lean 转换或等价验证成功。

## 运行

先按[环境说明](yosys-frontend.md)安装依赖并生成真实香山 classpath：

```powershell
python scripts/fetch_xiangshan_dependencies.py
python scripts/sbt.py xiangshanFramework/writeXiangshanClasspath
python scripts/elaborate_xiangshan.py --config DefaultConfig --cores 1 --heap 6g
```

第一步输出的 `summary.json` 再交给后续步骤。用实际路径替换下面的占位路径：

```powershell
python scripts/lower_xiangshan.py <展开目录>/summary.json --initialization caller-state
python scripts/bootstrap_native_yosys.py
python scripts/bootstrap_json_stream.py
python scripts/convert_xiangshan.py <RTL降低目录>/summary.json
python scripts/verification/two_state/audit_xiangshan.py <展开目录>/summary.json --lowering <RTL降低目录>/summary.json --conversion <转换目录>/summary.json
```

每一步保留来源哈希、命令和日志。后一步要求前一步完整成功。
转换入口收集全部生成 RTL 和原工程生成的 Difftest 头文件，开启多时钟模式并保留断言等检查。
没有默认补上的 SRAM 或黑盒行为，也没有把未处理模块算成成功。

整颗入口默认使用原生 64 位 Yosys `0.70+16 / 3bb533450`；此前 WASM 在完整导入时崩溃。
其[完整规范化导入](validation-xiangshan-native-import-7.3.json)已通过，产生约 776 MB 的层次 RTLIL。
整个顶层的[扁平化、时钟及存储器降低](validation-xiangshan-normalization-7.3.json)也已通过，产生约 1.75 GB 的 RTLIL。
[完整 FunctionalIR 导出](validation-xiangshan-functional-7.3.json)和[整颗 Lean 编译](validation-xiangshan-whole-lean-7.3.json)已成功。
Lean 实际解码并校验了 7,902,969 个节点、523,808 个状态字段；这些状态包括时钟采样辅助状态。
整颗 RTL 短场景对照已通过，还没有指令执行和所有输入序列上的等价证明。
固定标准流的 14 处 `$fwrite` 在暂存副本中转接为可观察日志，原始 RTL 保留；不支持的系统任务仍报错。
成功导入会产生带哈希的层次检查点，重试时可加 `--hierarchy-checkpoint <检查点文件>`。
也可用 `--flat-checkpoint` 从扁平化后恢复、`--normalized-checkpoint` 从时钟和存储器降低后恢复，
或用 `--functional-checkpoint` 从完整 FunctionalIR 导出后恢复；每次选一个。
检查点核对全部 RTL、头文件、暂存改写、工具、处理选项和产物哈希，并要求原工具真实退出成功。
超过 64 MB 的 JSON 自动流式处理，当前依赖锁要求 Python 3.11；[逐项核对](validation-yosys-stream-json-7.3.json)覆盖 16 个已验证模型。
原生后端各阶段以 RTLIL 传递电路，避免将整颗 JSON 再读入 Yosys；JSON 只提供端口、初态和来源等元数据。
观测节点通过官方 `rename`、`expose` 批量导出，[回归](validation-yosys-native-7.3.json)覆盖时钟、掩码存储器及标准流。
大的 FunctionalIR 文件也流式读取；[22 个已有模型的逐项核对](validation-functional-stream-7.3.json)确认节点、初态和 Lean 源码不变。
为减少内存峰值，只直接展开顶层，再清理层次库。[四层反馈回归](validation-yosys-hierarchy-7.3.json)
及[默认 WASM 后端回归](validation-yosys-hierarchy-wasm-7.3.json)都与独立 RTL 一致。

官方 firtool 开启全部验证层，并使用标准立即断言形式，避免 Windows 的验证层目录问题。
检查仍然存在；[测试](validation-xiangshan-layers-7.3.json)确认正常输入通过、违反断言时 Lean 和 RTL 都失败。
没有额外定义 `SYNTHESIS` 或 `DIFFTEST`；条件编译按原始代码和头文件执行，不能据此声称已模拟启用后的 DPI 环境。

`caller-state` 使用官方 `--disable-all-randomization`，未知初态由调用者提供，复位由转换后的状态语义处理。
RTL 验证驱动先以明确的全零输入求值一次，再施加保存轨迹中的复位，保证异步复位确实产生上升沿。
它不直接写内部寄存器，也不关闭断言；这次启动求值单独记录在 `startup.json`，不计入 96 个比较采样点。
此前驱动在首次求值前就将复位置为 1，Verilator 没有识别到该复位边沿，导致下游 MSHR 在首个时钟边沿断言失败。
不能把关闭初始化后的 RTL 仿真当作默认 RTL 的时间零行为：两者在首个事件前可能不同。
[初始化回归](validation-circt-initialization-7.3.json)直接以默认原始 RTL 为参照，覆盖初始复位高、低及非零复位值；
这项小型回归不是整颗设计的初始化等价证明。

## 已补的能力和验收要求

[时钟测试](validation-yosys-clocks-7.3.json)覆盖多个时钟、下降沿、异步复位、锁存器和基于锁存器的门控时钟。
这是显式采样模型：数据、门控使能须在有效边沿前稳定，复位释放须与有效边沿分开。
它不模拟任意延时，也不提供四态 X/Z 传播。

[检查语句测试](validation-yosys-effects-7.3.json)覆盖断言、假设、覆盖和打印事件。
[工程输入测试](validation-yosys-project-7.3.json)覆盖多文件、子模块和宏头文件。
这些测试通过后，仍需在完整香山上检查所有实际单元、模型规模和执行行为。

大模型按有类型的中间值分块导出，新模型的记录每组最多 16 个字段，控制单个 Lean 函数和构造器的规模。
它们保留同一采样步的计算，不增加硬件周期。生成清单记录导出器哈希及实际字段路径。
[规模回归](validation-yosys-chunks-7.3.json)执行了 23,557 节点、1,536 状态字段的模型，
64 拍的 8,192 位输出与 Verilator 和独立整数模型一致。

整颗设计超过了上述源码布局的规模，已改用同一类型 IR 的数据表示和纯 Lean `BitVec` 执行器。
全部电路保存在约 131 MB 的二进制数据中，生成的 Lean 模块包含并校验这份数据；没有换成简化模块。
[17 组、22,080 步回归](validation-yosys-table-7.3.json)与已有 RTL/初态契约参照一致。
原生执行器由官方 Lean/Clang 编译同一份 Lean 代码，[13 组回归](validation-lean-table-native-7.3.json)与字节码结果一致。

大移位量现在限制到电路位宽，避免 Lean 先分配巨大的自然数再截断。三类移位均有任意位宽和移位量的 Lean 等价证明；
[专项测试](validation-bounded-shifts-7.3.json)比较了 208 组输入、三种 Lean 执行方式与独立 RTL。
新原生执行器也通过了[17 组、22,080 步回归](validation-lean-table-native-bounded-7.3.json)。
整颗换执行器时，`scripts/recheck_lean_table.py` 核对原电路数据不变并重新编译；
[篡改拒绝测试](validation-table-recheck-7.3.json)覆盖入口、接口、IR、二进制、十六进制、解释器及来源清单。

本次更新解释器后，完整模型在 `generated/xiangshan-whole-bounded/XiangShan/Whole.lean`，执行接口在相邻的 `Whole.table.json`。
它已重新通过 Lean 编译和全部 7,902,969 个节点的数据校验，旧模型仍保留。
准备包含完整初态和输入的请求后，可使用：

```powershell
python scripts/build_lean_table_runner.py --out experiments/lean-table-native-bounded-v2-7.3
python scripts/yosys_simulate.py generated/xiangshan-whole-bounded/XiangShan/Whole.table.json --request request.json --native-runner experiments/lean-table-native-bounded-v2-7.3
```

整颗测试入口为 `scripts/verification/two_state/verify_xiangshan_whole.py`。它复制并核对原始 RTL，再执行独立 Verilator 对照；
当前准备的场景是复位、JTAG 时钟、外部总线停顿和地址属性查询，不等于完整程序运行验收。

完整验收需要：整个顶层生成并通过 Lean 编译；存储器、时钟、复位和外部边界均有明确语义；
完整顶层在复位、总线响应及指令运行场景下与独立 RTL 比较一致。
目前不能用两个小模块的测试结果代替这项验收，通用转换器正确性证明也尚未完成。
