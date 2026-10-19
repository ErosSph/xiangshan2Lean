# 脚本逐文件用途目录

盘点日期：2026-10-19。101 个验证/实验脚本已移入分类目录，旧根目录桥接文件已删除。少数阶段指纹扫描器和常用转换入口仍留在根目录。

常用转换入口负责 Chisel、FIRRTL 或 SystemVerilog 到 Lean；`simulate.py` 等执行已生成的 Lean 模型。`verify_`、`audit_` 和阶段启动器支撑对应回归、审计或实验。以下用途说明取自实现文件的模块说明首行；分类本身不构成删除判定。

逐项链接指向当前可用路径。同步配置中的冻结路径由本地打包器映射到分类后的实现，打包时仍保留原归档结构。

## 常用转换、展开和模型执行入口（9）

- [`chisel2lean.py`](../scripts/chisel2lean.py)：Compatibility CLI for the parameterized Chisel source frontend.
- [`elaborate_chisel.py`](../scripts/elaborate_chisel.py)：Compatibility CLI for official Chisel elaboration.
- [`firrtl2lean.py`](../scripts/firrtl2lean.py)：Compatibility CLI for the fixed-configuration FIRRTL frontend.
- [`firrtl_simulate.py`](../scripts/firrtl_simulate.py)：Compatibility CLI for executing fixed-configuration FIRRTL models.
- [`fourstate2lean.py`](../scripts/fourstate2lean.py)：Translate the strict four-state RTL subset through the unchanged two-state backend.
- [`fourstate_simulate.py`](../scripts/fourstate_simulate.py)：Replay strict four-state JSONL inputs on an actual generated Lean model.
- [`simulate.py`](../scripts/simulate.py)：Compatibility CLI for executing parameterized Chisel2Lean models.
- [`yosys2lean.py`](../scripts/yosys2lean.py)：Convert fixed RTL through official Yosys FunctionalIR into executable Lean 4.
- [`yosys_simulate.py`](../scripts/yosys_simulate.py)：Execute generated Lean FunctionalIR models, including array-valued memory state.

## 二态验证、审计和回归（48）

- [`audit_xiangshan.py`](../scripts/verification/two_state/audit_xiangshan.py)：Record whole-XiangShan stage coverage without confusing elaboration with verification.
- [`check_aggregate_contracts.py`](../scripts/verification/two_state/check_aggregate_contracts.py)：Reject unsupported aggregate layouts and execute Vec[Bundle] definedness contracts.
- [`check_circt_contracts.py`](../scripts/verification/two_state/check_circt_contracts.py)：Check modern-input rejection, pre-optimization effects and executable definedness.
- [`check_circt_initialization.py`](../scripts/verification/two_state/check_circt_initialization.py)：Check the explicit-state hardware profile against normal CIRCT reset initialization.
- [`check_firrtl_contracts.py`](../scripts/verification/two_state/check_firrtl_contracts.py)：Check unsupported hardware diagnostics, undefined division, and a Lean mutant.
- [`check_mutation.py`](../scripts/verification/two_state/check_mutation.py)：Verify that independent differential testing detects a wrong Lean output.
- [`check_rejections.py`](../scripts/verification/two_state/check_rejections.py)：Check unsupported-source diagnostics and parameter-domain failures.
- [`check_xiangshan_layers.py`](../scripts/verification/two_state/check_xiangshan_layers.py)：Check that official layer enabling preserves Chisel's actual assertion intrinsic.
- [`check_yosys_contracts.py`](../scripts/verification/two_state/check_yosys_contracts.py)：Execute boundary checks and a semantic mutation against the new RTL route.
- [`check_yosys_project.py`](../scripts/verification/two_state/check_yosys_project.py)：Exercise project RTL input, includes/macros and an actual child module against Verilator.
- [`validate.py`](../scripts/verification/two_state/validate.py)：Build, translate, execute the independent release suite, and aggregate evidence.
- [`validate_incremental_runner.py`](../scripts/verification/two_state/validate_incremental_runner.py)：Compare the new pure Lean execution backend with saved independent results.
- [`validate_xiangshan_program.py`](../scripts/verification/two_state/validate_xiangshan_program.py)：Run one finite original-RTL / official-Spike / generated-Lean acceptance.
- [`verify_aggregate.py`](../scripts/verification/two_state/verify_aggregate.py)：Compare parameterized Vec[Bundle] models with official RTL and integer specifications.
- [`verify_bounded_shifts.py`](../scripts/verification/two_state/verify_bounded_shifts.py)：Check large shift counts against original RTL and independent integers.
- [`verify_configuration.py`](../scripts/verification/two_state/verify_configuration.py)：Exercise generic inheritance, trait overrides, CDE field projection and rejection diagnostics.
- [`verify_firrtl_bridges.py`](../scripts/verification/two_state/verify_firrtl_bridges.py)：Check the model equivalence bridge proofs with freshly generated models.
- [`verify_firrtl_frontend.py`](../scripts/verification/two_state/verify_firrtl_frontend.py)：Compare the FIRRTL frontend with original Chisel-source Lean and original RTL.
- [`verify_functional_stream.py`](../scripts/verification/two_state/verify_functional_stream.py)：Compare streamed imports with checked models, including exact Lean source.
- [`verify_lean_table_native.py`](../scripts/verification/two_state/verify_lean_table_native.py)：Check the native Lean executable against completed bytecode/RTL traces.
- [`verify_leanparam.py`](../scripts/verification/two_state/verify_leanparam.py)：Check @LeanParam retention, inheritance/CDE binding, behavior and explicit rejections.
- [`verify_modern_bridge.py`](../scripts/verification/two_state/verify_modern_bridge.py)：Kernel-check a same-source, same-Chisel-version fixed-configuration bridge.
- [`verify_modern_firrtl.py`](../scripts/verification/two_state/verify_modern_firrtl.py)：Fresh Chisel 7.3 -> CIRCT SSA -> Lean vs independent official RTL and integer specs.
- [`verify_native_yosys.py`](../scripts/verification/two_state/verify_native_yosys.py)：Re-run RTL-checked clock, memory and observation traces with native Yosys.
- [`verify_saturating_example.py`](../scripts/verification/two_state/verify_saturating_example.py)：Verify a new Chisel example against mathematical expectations and official RTL.
- [`verify_server_bundle.py`](../scripts/verification/two_state/verify_server_bundle.py)：Relocate the actual transfer archive and execute its small acceptance gates.
- [`verify_table_pipeline.py`](../scripts/verification/two_state/verify_table_pipeline.py)：Verify the real table CLI artifacts, runner and negative data validation.
- [`verify_table_recheck.py`](../scripts/verification/two_state/verify_table_recheck.py)：Check evaluator refresh provenance and rejection of changed circuit assets.
- [`verify_xiangshan_aggregate.py`](../scripts/verification/two_state/verify_xiangshan_aggregate.py)：Check Vec of original XiangShan SfenceBundle under real XSModule/CDE configuration.
- [`verify_xiangshan_config.py`](../scripts/verification/two_state/verify_xiangshan_config.py)：Validate original Nanhu RightShiftModule with real, complete XSModule/CDE dependencies.
- [`verify_xiangshan_firrtl.py`](../scripts/verification/two_state/verify_xiangshan_firrtl.py)：Verify ORIGINAL XiangShan v2.1 modules elaborated with the full parameter framework.
- [`verify_xiangshan_hierarchy.py`](../scripts/verification/two_state/verify_xiangshan_hierarchy.py)：Check CDE propagation and original XSBundle fields through small real-framework test tops.
- [`verify_xiangshan_right_shift.py`](../scripts/verification/two_state/verify_xiangshan_right_shift.py)：Check XiangShan's original right shifter against generated Lean and integer math.
- [`verify_xiangshan_sram.py`](../scripts/verification/two_state/verify_xiangshan_sram.py)：Execute the actual XiangShan utility SramArray1P/2P implementations through Lean.
- [`verify_xiangshan_whole.py`](../scripts/verification/two_state/verify_xiangshan_whole.py)：Compare an original fixed XSTop against its Lean model under an explicit smoke trace.
- [`verify_yosys.py`](../scripts/verification/two_state/verify_yosys.py)：Fresh official Chisel RTL / Yosys-to-Lean / FIRRTL-to-Lean comparison campaign.
- [`verify_yosys_arbitrary.py`](../scripts/verification/two_state/verify_yosys_arbitrary.py)：Check nonzero choices for exposed unknown bits through both transports.
- [`verify_yosys_checkpoint.py`](../scripts/verification/two_state/verify_yosys_checkpoint.py)：Check that reusable RTL imports preserve behavior and reject stale inputs.
- [`verify_yosys_chunks.py`](../scripts/verification/two_state/verify_yosys_chunks.py)：Validate bounded Lean emission using previous RTL oracles and a larger fresh circuit.
- [`verify_yosys_clocks.py`](../scripts/verification/two_state/verify_yosys_clocks.py)：Compare explicit multi-clock sampling, clock gates, latches and async reset with RTL.
- [`verify_yosys_effects.py`](../scripts/verification/two_state/verify_yosys_effects.py)：Check preserved clocked assertions, assumptions, coverage, and print events against RTL.
- [`verify_yosys_exposure.py`](../scripts/verification/two_state/verify_yosys_exposure.py)：Validate official exposure cuts, literal prints and failing properties.
- [`verify_yosys_hierarchy.py`](../scripts/verification/two_state/verify_yosys_hierarchy.py)：Check root-only flattening on deep hierarchy and registered cross-feedback.
- [`verify_yosys_json.py`](../scripts/verification/two_state/verify_yosys_json.py)：Compare streaming netlist edits with the existing checked JSON artifacts.
- [`verify_yosys_proof.py`](../scripts/verification/two_state/verify_yosys_proof.py)：Kernel-check properties of a freshly translated fixed four-bit Counter.
- [`verify_yosys_records.py`](../scripts/verification/two_state/verify_yosys_records.py)：Check grouped inputs, state, outputs and effect fields using a real wide interface.
- [`verify_yosys_stdio.py`](../scripts/verification/two_state/verify_yosys_stdio.py)：Compare static stdout/stderr observations with unmodified original RTL.
- [`verify_yosys_table.py`](../scripts/verification/two_state/verify_yosys_table.py)：Compare actual Lean table execution with independently checked RTL traces.

## 四态验证与审计（47）

- [`audit_fourstate_analysis.py`](../scripts/verification/four_state/audit_fourstate_analysis.py)：Deterministic aggregation of CST facts and official elaborated instance paths.
- [`audit_fourstate_batch.py`](../scripts/verification/four_state/audit_fourstate_batch.py)：F4.4 bounded module conversion probes; no frontend semantics are changed.
- [`audit_fourstate_batch_remote.py`](../scripts/verification/four_state/audit_fourstate_batch_remote.py)：F4.4 data-only acquisition; original Reader, own-workspace Guard, no installs.
- [`audit_fourstate_f52.py`](../scripts/verification/four_state/audit_fourstate_f52.py)：F5.2 local SSH controller. No semantic extensions or Lean invocation.
- [`audit_fourstate_f52_remote.py`](../scripts/verification/four_state/audit_fourstate_f52_remote.py)：F5.2 Guard-owned data acquisition, environment checks and finite probes.
- [`audit_fourstate_f52_worker.py`](../scripts/verification/four_state/audit_fourstate_f52_worker.py)：F5.2 diagnostic worker; imports the unchanged private converter only.
- [`audit_fourstate_remote.py`](../scripts/verification/four_state/audit_fourstate_remote.py)：Read-only SSH payload for F3.1. Sent on stdin; never installed remotely.
- [`audit_fourstate_report.py`](../scripts/verification/four_state/audit_fourstate_report.py)：Render an evidence-backed F3.1 report from frozen facts (no hardware tools).
- [`audit_fourstate_server.py`](../scripts/verification/four_state/audit_fourstate_server.py)：Bounded F3.1 worker. Source Reader is read-only; Guard writes only our workspace.
- [`audit_fourstate_stateflow.py`](../scripts/verification/four_state/audit_fourstate_stateflow.py)：Bound-AST XSTop storage ownership inventory; explicitly not semantic IR.
- [`audit_fourstate_syntax.py`](../scripts/verification/four_state/audit_fourstate_syntax.py)：Facts from official slang CST JSON, never keyword-derived semantic counts.
- [`audit_fourstate_xstop.py`](../scripts/verification/four_state/audit_fourstate_xstop.py)：F3.1 static-only audit: guarded SSH collection and offline pyslang analysis.
- [`verify_fourstate.py`](../scripts/verification/four_state/verify_fourstate.py)：Independent Icarus/original, Icarus/encoded and executable Lean validation.
- [`verify_fourstate_assertions.py`](../scripts/verification/four_state/verify_fourstate_assertions.py)：F4.7 supplement: untouched RTL / encoded RTL / Lean + native $error channel.
- [`verify_fourstate_async.py`](../scripts/verification/four_state/verify_fourstate_async.py)：F4.3: native SV events / encoded RTL / actual Lean async differential tests.
- [`verify_fourstate_backend.py`](../scripts/verification/four_state/verify_fourstate_backend.py)：Exercise four-state-only backend cleanup and explicit Lean compilation stack.
- [`verify_fourstate_blockers.py`](../scripts/verification/four_state/verify_fourstate_blockers.py)：F3.2.2 bounded CAMTemplate / LevelGateway blocker reproduction.
- [`verify_fourstate_blockers_remote.py`](../scripts/verification/four_state/verify_fourstate_blockers_remote.py)：F3.2.2 data-only server helper; two pinned files, no hardware execution.
- [`verify_fourstate_cam.py`](../scripts/verification/four_state/verify_fourstate_cam.py)：F4.1 finite raw RTL / Boolean RTL / Lean checks, with ModelSim raw reference.
- [`verify_fourstate_clocks.py`](../scripts/verification/four_state/verify_fourstate_clocks.py)：F4.6 bounded event benches, traces and exact three-way comparison.
- [`verify_fourstate_clocks_regression.py`](../scripts/verification/four_state/verify_fourstate_clocks_regression.py)：F4.6 complete frozen-corpus regression transport (stdlib on Linux).
- [`verify_fourstate_clocks_remote.py`](../scripts/verification/four_state/verify_fourstate_clocks_remote.py)：Python 3.8, Guard-owned Linux execution for F4.6 only; no installation.
- [`verify_fourstate_conditional.py`](../scripts/verification/four_state/verify_fourstate_conditional.py)：F5.1a fresh translations, immutable frozen corpora, and IEEE conditional checks.
- [`verify_fourstate_conditional_compare.py`](../scripts/verification/four_state/verify_fourstate_conditional_compare.py)：Stdlib-only strict comparison for freshly regenerated frozen F4 models.
- [`verify_fourstate_f53.py`](../scripts/verify_fourstate_f53.py)：Finite F53 server work: compact IR, explicit small lowerings, raw/encoded RTL.
- [`verify_fourstate_f54.py`](../scripts/verification/four_state/verify_fourstate_f54.py)：F54 private server probes; immutable inputs, native-array encoding, no Lean run.
- [`verify_fourstate_f55.py`](../scripts/verify_fourstate_f55.py)：Finite F55 native subsystem probes and real raw/encoded executions on amax.
- [`verify_fourstate_f56.py`](../scripts/verify_fourstate_f56.py)：F56 finite probes of hierarchy, expressions, process scopes and diagnostics.
- [`verify_fourstate_f57.py`](../scripts/verification/four_state/verify_fourstate_f57.py)：Frozen-XSTop encoding and explicitly requested validation, with stage evidence.
- [`verify_fourstate_f57_native.py`](../scripts/verification/four_state/verify_fourstate_f57_native.py)：Compile/elaborate unchanged frozen XSTop in the existing Windows ModelSim.
- [`verify_fourstate_hierarchy.py`](../scripts/verification/four_state/verify_fourstate_hierarchy.py)：Independent inventory and three-way hierarchy / parameter / generate validation.
- [`verify_fourstate_machine_diagnostics.py`](../scripts/verification/four_state/verify_fourstate_machine_diagnostics.py)：Windows reference rendering after server-side full hardware comparisons.
- [`verify_fourstate_machine_initial.py`](../scripts/verification/four_state/verify_fourstate_machine_initial.py)：Check every requested original state at both phases of the seeding step.
- [`verify_fourstate_machine_native.py`](../scripts/verification/four_state/verify_fourstate_machine_native.py)：Compare full native reference observations and render typed diagnostic ABI.
- [`verify_fourstate_memory.py`](../scripts/verification/four_state/verify_fourstate_memory.py)：Bounded F4.5 memory contracts and exact raw RTL / encoded RTL / Lean tests.
- [`verify_fourstate_memory_remote.py`](../scripts/verification/four_state/verify_fourstate_memory_remote.py)：Python 3.8: bounded Linux RAM replay, existing tools, Guard-only writes.
- [`verify_fourstate_operators.py`](../scripts/verification/four_state/verify_fourstate_operators.py)：Run staged four-state width and operator RTL / encoded RTL / Lean checks.
- [`verify_fourstate_prefetch_directed.py`](../scripts/verification/four_state/verify_fourstate_prefetch_directed.py)：F1.2 directed prefetch validation, reusing F1.1 execution and comparison.
- [`verify_fourstate_prefetch_faults.py`](../scripts/verification/four_state/verify_fourstate_prefetch_faults.py)：F1.3: compiled isolated prefetch RTL faults, using the F1.1/F1.2 framework.
- [`verify_fourstate_prefetch_smoke.py`](../scripts/verification/four_state/verify_fourstate_prefetch_smoke.py)：F1.1: execute the official no-local-variable Nanhu prefetch RTL in three paths.
- [`verify_fourstate_preprocess.py`](../scripts/verification/four_state/verify_fourstate_preprocess.py)：F4.2 official preprocessing boundaries and finite three-way regressions.
- [`verify_fourstate_prioritymux.py`](../scripts/verification/four_state/verify_fourstate_prioritymux.py)：F3.2.1: exact real PriorityMuxModule_25, exhaustive seven-scalar-input check.
- [`verify_fourstate_prioritymux_remote.py`](../scripts/verification/four_state/verify_fourstate_prioritymux_remote.py)：Python 3.8 data-only acquisition/archive helper for the single F3.2.1 module.
- [`verify_fourstate_reset_alias.py`](../scripts/verification/four_state/verify_fourstate_reset_alias.py)：F5.1 bounded reset alias assets; Windows conversion, guarded server execution.
- [`verify_fourstate_sequential.py`](../scripts/verification/four_state/verify_fourstate_sequential.py)：Three-way sequential four-state verification with independent Icarus state drivers.
- [`verify_fourstate_structures.py`](../scripts/verification/four_state/verify_fourstate_structures.py)：F4.7 bounded procedural fixtures and untouched JTAG reference evidence.
- [`verify_fourstate_xiangshan.py`](../scripts/verification/four_state/verify_fourstate_xiangshan.py)：Fresh original Nanhu ALU / encoded RTL / executable Lean verification.

## 四态阶段实验启动器（9）

- [`run_fourstate_f53.py`](../scripts/experiments/four_state/runners/run_fourstate_f53.py)：Windows F5.3 controller: explicit source snapshot, guarded SSH, no remote Codex.
- [`run_fourstate_f53_remote.py`](../scripts/experiments/four_state/runners/run_fourstate_f53_remote.py)：F53 server launcher. Only Guard-owned fresh output paths may be executed.
- [`run_fourstate_f54.py`](../scripts/experiments/four_state/runners/run_fourstate_f54.py)：Windows F5.4 controller: explicit source snapshot, guarded SSH, no remote Codex.
- [`run_fourstate_f54_remote.py`](../scripts/experiments/four_state/runners/run_fourstate_f54_remote.py)：F54 server launcher. Only Guard-owned fresh output paths may be executed.
- [`run_fourstate_f55.py`](../scripts/experiments/four_state/runners/run_fourstate_f55.py)：F55 guarded local control; server work remains in the personal directory.
- [`run_fourstate_f56.py`](../scripts/experiments/four_state/runners/run_fourstate_f56.py)：Windows control of F56 experiments, using guarded personal-server paths.
- [`run_fourstate_f57.py`](../scripts/experiments/four_state/runners/run_fourstate_f57.py)：Guarded control for full-XSTop encoding and explicitly requested validation.
- [`run_fourstate_f57_native_trace.py`](../scripts/experiments/four_state/runners/run_fourstate_f57_native_trace.py)：Execute the frozen complete original-XSTop short trace in existing ModelSim.
- [`run_fourstate_f57_reference.py`](../scripts/experiments/four_state/runners/run_fourstate_f57_reference.py)：Stream the frozen native reference to an exclusive Guard-approved server path.

## 四态实现与实验支撑模块（34）

- [`bootstrap_fourstate.py`](../scripts/bootstrap_fourstate.py)：Install the pinned four-state parser into project-local storage.
- [`fourstate_assertions.py`](../scripts/fourstate_assertions.py)：Bounded immediate-assert diagnostic ABI; no general assertion scheduler.
- [`fourstate_backend_cache.py`](../scripts/fourstate_backend_cache.py)：Private artifact page-cache advice; no cgroup or global cache policy changes.
- [`fourstate_backend_io.py`](../scripts/fourstate_backend_io.py)：Opt-in private storage adapter around the unchanged public backend.
- [`fourstate_backend_pipes.py`](../scripts/fourstate_backend_pipes.py)：Private native-JSON FIFO transport to lossless archives, never a netlist edit.
- [`fourstate_bounded_events.py`](../scripts/fourstate_bounded_events.py)：F4.6 private, explicitly bounded event contract; no general SV scheduler.
- [`fourstate_commit_layout.py`](../scripts/fourstate_commit_layout.py)：Opt-in grouping of generated, disjoint NBA bank writers by logical owner.
- [`fourstate_diagnostics.py`](../scripts/fourstate_diagnostics.py)：Private v9 observational diagnostics, sampled at each process activation.
- [`fourstate_elaborated.py`](../scripts/fourstate_elaborated.py)：Import pinned slang's elaborated hierarchy into the independent four-state IR.
- [`fourstate_encode.py`](../scripts/fourstate_encode.py)：Lower four-state IR to fully defined tag/value Boolean RTL.
- [`fourstate_eventful.py`](../scripts/fourstate_eventful.py)：Explicit private v8: acyclic static-bit derived resets and state-fed gates.
- [`fourstate_eventful_bench.py`](../scripts/fourstate_eventful_bench.py)：v8 benches: pre/post NBA plus every activation's complete owned old state.
- [`fourstate_events.py`](../scripts/fourstate_events.py)：F4.3: a bounded sampled wrapper for one posedge clock/reset process.
- [`fourstate_extended.py`](../scripts/fourstate_extended.py)：Explicit private v9 admission; old v4-v8 entrypoints remain opt-in compatible.
- [`fourstate_extended_bench.py`](../scripts/fourstate_extended_bench.py)：Exact v9 observations plus native-rendered, per-activation diagnostics.
- [`fourstate_frontend.py`](../scripts/fourstate_frontend.py)：Strict, source-audited pyslang frontend for the four-state combinational subset.
- [`fourstate_inline_kernel.py`](../scripts/fourstate_inline_kernel.py)：Explicit structural inlining of the private combinational scalar kernel.
- [`fourstate_json_stream.py`](../scripts/fourstate_json_stream.py)：Private exact-number Linux JSON selector; ijson-shaped IO, no hardware logic.
- [`fourstate_machine_bench.py`](../scripts/fourstate_machine_bench.py)：Streaming original-RTL observer for large admitted v9 hierarchies.
- [`fourstate_machine_compare.py`](../scripts/fourstate_machine_compare.py)：Exact streamed large-model observations, activations and diagnostic ABI.
- [`fourstate_machine_replay.py`](../scripts/fourstate_machine_replay.py)：Private v9 VPI replay configuration; all observations stay exact and streamed.
- [`fourstate_native_replay.py`](../scripts/fourstate_native_replay.py)：Private execution-engine selection and verified replay preparation reuse.
- [`fourstate_observation_check.py`](../scripts/fourstate_observation_check.py)：Native four-state exhaustive selector check of the optional mux layout.
- [`fourstate_observation_layout.py`](../scripts/fourstate_observation_layout.py)：Exact optional narrowing of unsigned, zero-extended observation muxes.
- [`fourstate_preprocess.py`](../scripts/fourstate_preprocess.py)：Bounded official slang preprocessing, with physical source provenance.
- [`fourstate_scalable.py`](../scripts/fourstate_scalable.py)：Private v7 native dual-rail arrays and a synchronous ordered-step controller.
- [`fourstate_scalable_bench.py`](../scripts/fourstate_scalable_bench.py)：Streamed exact raw/native-array comparison; no checksum-only acceptance.
- [`fourstate_scalable_events.py`](../scripts/fourstate_scalable_events.py)：Private v7 event admission: F46 source semantics without cardinality budgets.
- [`fourstate_sequential.py`](../scripts/fourstate_sequential.py)：Explicit four-state register state and sampling wrapper; transitions execute in Lean.
- [`fourstate_stateflow.py`](../scripts/fourstate_stateflow.py)：F5.3 private compact state IR. Never invokes FunctionalIR or Lean.
- [`fourstate_sync.py`](../scripts/fourstate_sync.py)：Windows/local CLI for immutable, explicitly whitelisted four-state snapshots.
- [`fourstate_sync_common.py`](../scripts/fourstate_sync_common.py)：Portable, stdlib-only validation shared by the local and Python 3.8 receiver.
- [`fourstate_sync_remote.py`](../scripts/fourstate_sync_remote.py)：Python 3.8 stdlib SSH receiver. Every write is anchored under WORKSPACE.
- [`fourstate_unused_inputs.py`](../scripts/fourstate_unused_inputs.py)：Prove unused ABI fields against the unchanged compiled Lean circuit data.

## 工具链、工程准备与服务器/香山流程（26）

- [`bootstrap.py`](../scripts/bootstrap.py)：Download pinned public tool binaries into this project, never globally.
- [`bootstrap_elftools.py`](../scripts/bootstrap_elftools.py)：Use the pinned pure-Python pyelftools wheel to parse executable images.
- [`bootstrap_json_stream.py`](../scripts/bootstrap_json_stream.py)：Install the pinned project-local C JSON streaming reader for large RTL files.
- [`bootstrap_native_yosys.py`](../scripts/bootstrap_native_yosys.py)：Install a hash-locked official Windows/Linux x64 Yosys runtime locally.
- [`bootstrap_spike.py`](../scripts/bootstrap_spike.py)：Build the official pinned Spike reference locally, with commit logging.
- [`bootstrap_yosys.py`](../scripts/bootstrap_yosys.py)：Install a hash-locked, project-local Yosys WASM distribution (Windows x64).
- [`build_incremental_runner.py`](../scripts/build_incremental_runner.py)：Build a pure Lean cached evaluator with compact physical-input requests.
- [`build_lean_table_runner.py`](../scripts/build_lean_table_runner.py)：Compile the same pure Lean table evaluator to a native replay executable.
- [`build_progressive_runner.py`](../scripts/build_progressive_runner.py)：Compile a pure Lean runner that continues its own complete next state.
- [`build_xiangshan_firrtl.py`](../scripts/build_xiangshan_firrtl.py)：Run original XiangShan v2.1 with a small generation entry point, no framework shim.
- [`convert_xiangshan.py`](../scripts/convert_xiangshan.py)：Package complete official XiangShan RTL and attempt strict whole-top Lean conversion.
- [`elaborate_xiangshan.py`](../scripts/elaborate_xiangshan.py)：Run the unmodified official XiangShan top-level generator in an isolated directory.
- [`fetch_xiangshan_dependencies.py`](../scripts/fetch_xiangshan_dependencies.py)：Fetch immutable, original XiangShan/CDE source dependencies into the local cache.
- [`lower_xiangshan.py`](../scripts/lower_xiangshan.py)：Lower a successful full official XiangShan elaboration using pinned native firtool.
- [`migrate_workspace.py`](../scripts/migrate_workspace.py)：Stream a complete workspace backup, verify it remotely, then prune saved outputs.
- [`package_release.py`](../scripts/package_release.py)：Package source, generated examples and current validation reports without caches.
- [`prepare_xiangshan_firrtl.py`](../scripts/prepare_xiangshan_firrtl.py)：Fetch the official XiangShan v2.1 source and exact recursive generator dependencies.
- [`replay_xiangshan_program.py`](../scripts/replay_xiangshan_program.py)：Replay a recorded original-RTL program in Lean and compare every port sample.
- [`replay_xiangshan_retirement.py`](../scripts/replay_xiangshan_retirement.py)：Compare original RTL ports, read-only taps and retirement with actual Lean execution.
- [`sbt.py`](../scripts/sbt.py)：Run the pinned sbt launcher with local caches and complete logs.
- [`server.py`](../scripts/server.py)：Resume the saved fixed XSTop on a host with Lean and Verilator installed.
- [`server_bundle.py`](../scripts/server_bundle.py)：Create and verify a relocatable source/model/original-RTL server bundle.
- [`server_scenario.py`](../scripts/server_scenario.py)：Replay another physical-input scenario on the saved complete XSTop and Lean model.
- [`xiangshan_isa.py`](../scripts/xiangshan_isa.py)：Compare original RTL retirement with the pinned official Spike reference.
- [`xiangshan_observer.py`](../scripts/xiangshan_observer.py)：Read-only monitors for the pinned Nanhu DefaultConfig Verilated hierarchy.
- [`xiangshan_program.py`](../scripts/xiangshan_program.py)：Run bare-metal code on the original saved XSTop with real AXI responses.

## 共享实现模块和分析辅助工具（30）

- [`circt_frontend.py`](../scripts/circt_frontend.py)：Pinned CIRCT normalization and strict reader for its generic MLIR output.
- [`common.py`](../scripts/common.py)：Project-local tool discovery and logged subprocess execution.
- [`compact_request.py`](../scripts/compact_request.py)：Record every physical input while keeping fixed arbitrary choices once.
- [`compiled_runtime.py`](../scripts/compiled_runtime.py)：Generate inline Lean helpers with kernel-checked definitional equalities.
- [`differential.py`](../scripts/differential.py)：Compare generated Lean against independently generated and simulated RTL.
- [`elf_image.py`](../scripts/elf_image.py)：Stage ELF PT_LOAD segments using official pyelftools; no ELF parser here.
- [`finalize_program_jobs.py`](../scripts/finalize_program_jobs.py)：Aggregate an already launched finite batch; never rerun or mark unfinished jobs as passed.
- [`functional_ir.py`](../scripts/functional_ir.py)：Strict reader for locked Yosys FunctionalIR's SMT serialization, not an SMT solver.
- [`functional_nodes.py`](../scripts/functional_nodes.py)：Compact, read-only storage for large typed FunctionalIR node sequences.
- [`functional_stream.py`](../scripts/functional_stream.py)：Read the pinned FunctionalIR serialization without retaining its let tree.
- [`lean_chunks.py`](../scripts/lean_chunks.py)：Split a generated, typed transfer DAG into bounded Lean functions.
- [`lean_records.py`](../scripts/lean_records.py)：Bound generated record arity while retaining stable field identifiers.
- [`lean_table.py`](../scripts/lean_table.py)：Encode the checked FunctionalIR as data for the pure Lean interpreter.
- [`materialize_config.py`](../scripts/materialize_config.py)：Map used real CDE configuration fields to generated Lean Params; optionally emit original RTL.
- [`model_request.py`](../scripts/model_request.py)：Prepare an explicit zero-completion experiment for a newly checked model.
- [`profile_lean_table.py`](../scripts/profile_lean_table.py)：Run a bounded prefix of an existing request with allocator statistics.
- [`program_report.py`](../scripts/program_report.py)：Index actual server receipts; keep RTL/ISA and complete Lean acceptance separate.
- [`recheck_lean_table.py`](../scripts/recheck_lean_table.py)：Recheck an unchanged circuit packet with an updated pure Lean evaluator.
- [`report.py`](../scripts/report.py)：Aggregate fingerprint-verified v0.2 evidence; fail on missing or stale checks.
- [`report_chisel7.py`](../scripts/report_chisel7.py)：Aggregate fresh Chisel 7.3 evidence; earlier reports remain historical.
- [`rtl.py`](../scripts/rtl.py)：Independent official-Chisel RTL generation and Verilator trace execution.
- [`sv_stdio.py`](../scripts/sv_stdio.py)：Narrow compatibility for fixed stdout/stderr $fwrite observations.
- [`table_simulate.py`](../scripts/table_simulate.py)：Replay an explicit request through a compiled Lean table model.
- [`trace_compare.py`](../scripts/trace_compare.py)：Strict physical-port comparison for complete sampled RTL/Lean traces.
- [`yosys_effects.py`](../scripts/yosys_effects.py)：Preserve officially lowered checks and print events as explicit observations.
- [`yosys_expose.py`](../scripts/yosys_expose.py)：Make explicit observation/input cuts using official Yosys passes only.
- [`yosys_hierarchy.py`](../scripts/yosys_hierarchy.py)：Reuse a successful import only for identical RTL, preprocessing and tools.
- [`yosys_json.py`](../scripts/yosys_json.py)：Stream official Yosys JSON while retaining the exact netlist and bit IDs.
- [`yosys_observations.py`](../scripts/yosys_observations.py)：Expose explicitly selected internal wires as read-only verification outputs.
- [`yosys_runner.py`](../scripts/yosys_runner.py)：Run the locked Yosys, mounting only the subprocess working directory.

## 保留在根目录的阶段指纹扫描器

- [`verify_fourstate_f53.py`](../scripts/verify_fourstate_f53.py)、[`verify_fourstate_f55.py`](../scripts/verify_fourstate_f55.py) 和 [`verify_fourstate_f56.py`](../scripts/verify_fourstate_f56.py) 会枚举同目录源码并记录指纹，暂留根目录以保持来源集合稳定。

- [`fourstate_json_select.cpp`](../scripts/fourstate_json_select.cpp)：私有流式 JSON 选择器。
- [`server_entry.sh`](../scripts/server_entry.sh)：服务器命令入口。
- [`sync_fourstate.ps1`](../scripts/sync_fourstate.ps1)：四态快照同步的 PowerShell 包装器。
