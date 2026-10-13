# 两种前端的实现边界

源码前端继续发展符号参数、Scala 继承、CDE 参数字段和生成结构；FIRRTL
前端负责已经展开的固定配置电路。两端都使用 IR v2、Normalize、LeanEmitter
及 Runtime.lean，不把固定配置记录伪装成恢复出来的符号参数。

- Chicala / Chisel 7.3 路线：frontend/LeanAdapter、LeanSourceResolver、astloader、
  ChiselToScalaComponent；使用 writeToolClasspath 和 .cache/tool-classpath.txt。
- FIRRTL 1.5.6 路线：lean/firrtl/*.scala、scripts/firrtl*.py、verify_firrtl*.py；
  使用 classicFirrtl/writeFirrtlClasspath 和 .cache/firrtl-classpath.txt。
- 两个依赖集合在不同 JVM 中运行。Chisel 7 的 firrtl 序列化类不能与完整
  Scala FIRRTL 1.x 混入同一 classpath。
- 本次共享后端修改只增加可选工具链/契约/JSON 来源参数，保留原调用方式。
  rtl.py 抽出 run_emitted_rtl，原 run_rtl 仍调用同一驱动，行为不变。
- 修改 Model/Normalize/LeanEmitter 的硬件语义后，需要同时重验两端。

源码路线沿用 step 的 Bool reset 参数。FIRRTL 路线保留实际 reset 端口，
它属于 Inputs，复位 mux 进入 next-state 表达式；step 的兼容 reset 参数
不控制它。测试显式传入零状态并在有效复位后比较，不声称零上电初态。

CounterBridge 和 RightShiftBridge 显式映射端口及状态，在给定配置下比较
两个生成模型。Counter 还对任意长度的输入/复位序列作归纳。这些证明不是
整个编译器或全部 Scala/CDE 的证明。

真实工程测试另选官方香山 v2.1 的完整依赖与 MinimalConfig(1)，独立记录
Chisel 3.5.3/Scala 2.12.13/Mill 0.9.8，不冒充此前 nanhu 快照的验证。
现代 FIRRTL/CHIRRTL 输入目前需新增版本适配，遇到未知版本明确失败。
