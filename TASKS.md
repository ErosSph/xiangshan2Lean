# Chisel2Lean4 implementation

发布里程碑（2026-10-19，项目维护者本次确认）：完整香山单核（XSTop）成功转换为 Lean 4 可执行模型并通过编译；全 0、全 1、全 X、全 Z 四种初始状态分别完成 7、7、10、10 步整机差分验证。本次 Git 整理未重跑该整机验证，原始凭证不随本次源码提交发布。下方 F5.7 的执行中描述保留为早期快照；这项有限前缀结果不表示原定四初态 × 36 步完整覆盖已完成。

User authorization: 2026-10-13, continue until a working translator; the handoff
T0 stopping point is superseded.

- [x] T0: pin upstream, run unmodified baseline, probe source AST, record defects.
- [x] M1: independent typed parameterized IR, source diagnostics, semantics.
- [x] M2: real source -> Lean, type checking, executable trace interface.
- [x] M3 first subset: Bool/UInt/SInt, IO/Bundle, registers, arithmetic,
  conditional widths, parameter helpers, Vec and whole-length generate loops.
- [x] M4 release verification: final full/edge/control RTL differential suite,
  rejection tests, fault injection, clean CLI build and documentation.

Versioned remaining unsupported constructs are in docs/support-matrix.md;
they are not hidden semantic defaults. The implemented scope is the documented
single-clock source subset, with real independent verification.

The user requested a relatively complete implementation after v0.1. The v0.1
stopping point is superseded by the v0.2 scope below.

- [x] M5: recursive parameterized module instantiation, dependency ordering,
  multi-port children, old-state semantics across hierarchy.
- [x] M6: scalar width inference, RegNext/RegEnable idioms, Bundle registers,
  VecInit/fill/tabulate, partial ranges, captured local aliases.
- [x] M7: dynamic Vec read/write, switch/Enum, Mux priority, division/remainder,
  dynamic shifts, head/tail/Fill, pure hardware helpers.
- [x] M8: asynchronous and one-cycle synchronous memory models, executable
  definedness contracts, FIFO/register-file integration.
- [x] M9: wide-port RTL driver, fingerprints, complete validation CLI and
  executable client proofs.
- [x] M10: frozen v0.2 release regression, final evidence and source package.

Historical v0.1 evidence is retained in docs/validation-v0.1.json. The final
v0.2 report requires the current generated-model/source/driver fingerprints.

v0.2 delivered: 51 checked Lean modules, 128 independent RTL configurations,
6303 cycles, 28907 compared output values, 25 rejection checks, fault injection
and two client model theorems. validate.py --skip-build --resume was executed
successfully. The source/model/evidence archive passed CRC and per-file SHA256
verification; caches and installed tools are excluded.

## Independent four-state extension

Design, interfaces, evidence and blockers are maintained in
[the four-state frontend document](docs/fourstate-frontend.md).

- [ ] F5.7 完整XSTop端到端验证：用户将主线调整为原始ModelSim四态RTL↔实际Lean模型。已核实Icarus不属于后端依赖，并按PID／UID／启动身份／工作目录校验停止本次编译5个进程，全部文件保留；整机Icarus成功不再作为门槛，历史三方功能保留。ModelSim四初态×36步已实际执行，337,853,664条快照完整；尚无整机两方通过结论。当前从哈希严格匹配的compact-v4编码与Flat检查点恢复公共后端，不重跑SLANG或整机编码，先尝试初态／复位／时钟前7步，再接续原完整覆盖。压缩Flat恢复小模型已实际Lean编译，FunctionalIR、表数据、Lean及runtime与原流程逐字节相同。实测任务、取消收据、资源及分阶段状态见 `experiments/fourstate/f57-20261018t110744z-da58ffda/in-progress.json`；公共后端、IR和Lean接口未改，无提交／推送。

## Full XSTop four-state roadmap (2026-10-18)

Local Windows sources remain authoritative; server writes are restricted to
`chisel2lean-fourstate`. Preserve all dirty/untracked work and historical data.
The fixed DefaultConfig provenance chain remains unconfirmed; do not relabel
audit counts or generated files as executable/behaviorally verified models.

- [x] F3.1: static audit: 982 RTL files, 981 module definitions, 21,024 hierarchy
  instances including XSTop. These counts are not conversion coverage.
- [x] F3.2: PriorityMux exhaustive validation and CAM/LevelGateway blocker probes.
- [x] F4.1: automatic process locals/blocking assignments; original CAMTemplate
  passed 72-state-bit three-way comparison under the documented contract.
- [x] F4.2: official preprocessing, guarded source provenance and regressions.
- [x] A / F4.3: original LevelGateway passed 21,504 samples with explicit
  `--async-reset reset`; all original state and output matched. Default macros
  exclude ENABLE_INITIAL_REG_; its active initial path remains rejected.
- [x] B / F4.4: all 981 definitions accounted; 767 bounded attempts, 229 IR/encoding successes, 538 rejections; two new definitions passed actual backend/Lean/three-way comparison. Instance weights are not verification counts.
- [x] C / F4.5: opt-in bounded memories; 75,552 new fixture/real-RAM samples, all output/state exact; real ram_2x3 also passed the same 9,280 samples on Linux. 112 unit tests, complete existing regressions, old models and two-thread recompile/replay passed. 20/24 selected definitions encoded; 3 budget rejections and 1 later async blocker remain.
- [x] D / F4.6: bounded low-transparent latches, real ClockGate, latched-AND/inverted clocks and two ordered independent roots. 96,988 new three-way samples; 146,625 complete-corpus regression/legacy replay samples, 122 unit tests and 98 rejection checks passed. No multi-clock memory expansion.
- [x] E / F4.7: scoped F47_PASS after the ImmediateAssertion supplement. Bounded packed automatic locals, named sequential scopes and opt-in immediate assert/static $error observations passed. Original CaptureUpdateChain_2 and JtagStateMachine three-way PASS; JtagTapController now explicitly rejects a child asynchronous-reset port alias. No full Tap/XSTop claim; remaining semantics require separate validation.
- [ ] F / F5: dependency-closed real hierarchy/subsystems, explicit environment,
  state and event contracts, then finite three-way integration tests.
- [x] F5.1 / F5.1a: F51A_PASS. IEEE conditional Z/Z merge corrected; untouched JtagTapController passes all 31,684 frozen three-way samples, all outputs/state/events/assertion diagnostics. Full historical, alias and assertion regressions retained.
- [x] F5.2: F52_PROBE_PASS. Server-first complete XSTop bounded probe and blocker audit; 981 definitions accounted, 419 encoded closures (359 leaf / 60 composite), 562 explicit rejections. Instance weights are potential impact, not verified instance coverage. See the F5.2 section in docs/fourstate-frontend.md.
- [x] F5.3: F53_PASS. Private compact memory/state IR and bound clock attribution; real small RAM/Queue, gated dual-clock hierarchy and ordered/static-slice NBA raw/encoded checks pass. Large RAMs have compact IR only; no whole-XSTop semantic conversion or Lean claim. See the F5.3 section in docs/fourstate-frontend.md.
- [x] F5.4: F54_PASS. Explicit private v7 native dual-rail RAMs and scalable event plan; 12 models pass 13,756 raw/encoded samples and unchanged-backend FunctionalIR import. Depth/4,417-process/capacity fixtures, 112 tests, 7 faults/3 guards and 64 historical sets pass. No whole-XSTop or Lean execution claim; see the F5.4 evidence and limits in docs/fourstate-frontend.md.
- [x] F5.5: F55_PASS within explicit private v8: static-bit derived resets and state-fed low-latched gates. Unmodified SRAMWrapper_32 closure, ResetGen boundary composition and three labeled witnesses pass 2,337 raw/encoded samples including every RAM word and activation old state; three real models import through the unchanged backend. 126 tests, 8 faults/4 guards, 64 historical sets and four fresh v7 cases pass. General reset logic/latch chains and other XSTop blockers remain; see the F5.5 evidence and limits in docs/fourstate-frontend.md.
- [x] F5.6: F56_PASS for blockers 5-8 in explicit private v9: open ports, remaining frozen expressions/types, automatic process scopes/stateless events, and typed assertion diagnostics. Fifteen real modules plus seven fixtures pass 38,005 raw/encoded samples; all 22 import through the unchanged backend. 143 tests, 11 faults and 64 historical sets pass. Fresh audit imports 978/981 complete closures, including XSTop; three standalone tops exceed the retained two-root clock contract. Whole-XSTop encoding/behavior and Lean are not claimed; see the F5.6 evidence and limits in docs/fourstate-frontend.md.
- [ ] G0 / F6: close configuration/tool/input provenance before DefaultConfig claims.
- [ ] G1-G4 / F6: resource-bounded full encoding, FunctionalIR, Lean compilation,
  execution and scoped difftest; distinguish every actual completed status.

F4.3 evidence: `experiments/fourstate/async-f4.3/f43-async-20261017t161451z-d3e825c0a5/`.
Its source hashes and VERIFIED_AND_IMPORTED receipt were checked before F4.4;
no asynchronous functionality or completed experiment is being redeveloped.
Current state (2026-10-18 Asia/Shanghai): F55_PASS for the selected real SRAM subsystem and ResetGen boundary composition, not whole-XSTop conversion. Evidence: experiments/fourstate/f55-20261018t081308z-8d0a6cc2/independent-final-v1/acceptance.json; delivery.json records reproduction, reference corrections, performance and source/Git protection. The 1,873 reset endpoints / 144 gate candidates are not all behaviorally validated. Public backend and old v4/v5/v6/v7 contracts remain intact. Stop awaiting acceptance; no Lean compilation/execution, next-stage development, commit or push.
Record implementation, acceptance and continuation details in the existing
[four-state document](docs/fourstate-frontend.md). Shared backend changes,
software installation, unsafe writes/overwrites and major architecture changes
are explicit stop conditions; no automatic commit/push/checkout/reset/cleanup.

## GitHub issue #1: composite size-cast context and propagated signedness

- [x] Reproduce the reported 8'(a+b) error with actual reference RTL, encoded
  RTL and Lean; retain the original mismatch and subsequent failed attempts.
- [x] Propagate the cast's own width into flat frontend operands while keeping
  narrowing, nested casts, concatenation and shift-count boundaries intact.
- [x] Use the official propagated conversion's context signedness in the
  elaborated frontend; retain source extension for assignment/explicit casts.
- [x] Extend the existing width batch with flat/elaborated composite casts and
  explicit-state sequential casts; require independent literal expectations.
- [x] Run all seven four-state batches, legacy replay and fresh official v5
  prefetch conversion/execution; preserve hashes, commands and scoped evidence.

Executed on 2026-10-17 (Asia/Shanghai): CAST_FIX_PASS, exit 0. The width batch
passed 1,192 samples: original cases 36/64, flat and elaborated casts 534 each,
and sequential casts 24. All 88 independent literal points passed. Remaining
combinational/sequential/hierarchy/logic/arithmetic/compatibility batches passed
197/3584/340/336/772/132 samples; old v4 replay passed 192 samples. Fresh official
L2TlbPrefetch v5 conversion and the original 80-sample F1.1 trace matched all
output/state bits and binary rails; encoded RTL was byte-identical to the old
artifact. Historical F1.x pinned-source guards and reports were not changed.

Only the independent four-state frontends, dedicated tests and documentation
changed. A mixed signed/unsigned defect discovered by the larger comparison and
a directory-hash error in the new test helper were fixed with failed evidence
retained. Old affected models need regeneration; replay does not repair them.
No shared backend/IR/runtime/CLI or two-state changes, whole-core build, commit,
push or GitHub issue update. Detailed evidence and reproduction are in
[the four-state frontend document](docs/fourstate-frontend.md).
The tasks below do not replace the historical conclusions above.

- [x] F0: establish and check the documentation and collaboration baseline.
- [x] F1: implement an independent raw RTL frontend preserving four-state
  semantics, with source diagnostics for the explicitly unsupported subset.
- [x] F2: implement tag/value encoding and port mapping, then connect encoded
  RTL to the existing Yosys / FunctionalIR / Lean backend.
- [x] F3: execute original RTL, encoded RTL and generated Lean; compare exact
  0/1/X/Z results and save reproducible evidence, including fault injection.
- [x] F4: execute four-state boundary regressions and any agreed shared-backend
  regressions; update verified scope without changing the default flow.

First combinational subset verified on 2026-10-16: 3 designs, 197 samples,
19,384 output bits compared across original RTL, encoded RTL and executable
Lean; 42 rejection checks, 11 fault/input checks, and 8 known-input samples
through the unchanged two-state entrypoint. This does not cover sequential
hardware or general SystemVerilog. Reports and commands are linked above.

## Four-state single-clock sequential extension

- [x] S1: parse posedge processes and preserve old-state reads, nonblocking
  assignment priority, procedural if semantics and synchronous reset.
- [x] S2: emit explicit current/next-state rails and versioned interfaces;
  execute the sampling and simultaneous state update in a Lean wrapper.
- [x] S3: validate original RTL, encoded transitions and Lean at every sample,
  including initial state, rejection and semantic fault injection.
- [x] S4: rerun combinational/v1 compatibility and known-value sequential
  checks; publish actual evidence in the existing four-state document.

Sequential subset verified on 2026-10-16: 7 scenarios, 3,584 samples,
381,248 output-bit and 381,248 register-bit positions compared at pre/post
sampling points; 23 rejection checks and 12 input/fault checks passed.
The original two-state backend matched 224 known-input samples under both
zero and one arbitrary-input choices. Combinational regression and replay
of an unchanged v1 artifact passed. No shared backend was modified.

## Four-state width and operators

- [x] O1: preserve signedness and evaluate context widths, explicit casts,
  extension and truncation in the independent frontend; run three-way width
  checks for combinational and sequential designs.
- [x] O2: add four-state logical and comparison operations with three-way
  truth-table, signed-relation and fault-injection evidence.
- [x] O3: add modular add/subtract and four-state shifts; verify counter,
  comparison-control and shift-pipeline designs including register state.
- [x] O4: rerun old combinational/sequential and two-state compatibility
  checks, replay v1/v2 artifacts, and publish the final operator report.

O1 verified on 2026-10-16: 36 combinational and 64 sequential samples,
7,560 combinational output-bit positions plus 2,560 sequential output-bit and
1,536 register-bit positions; two syntax rejections. The linked report and
the remaining operator limits are in docs/fourstate-frontend.md.

O2 verified on 2026-10-16: 16 one-bit truth-table, 256 two-bit comparison,
and 64 sequential samples; 4,144 output-bit and 384 register-bit positions,
two unsupported-operator rejections and one detected RTL mutation.

O3 verified on 2026-10-16: 772 samples across arithmetic truth vectors,
Counter4, ComparatorControl and a 65-bit ShiftPipeline; 123,744 output-bit
and 39,408 register-bit positions, three rejections and two detected RTL
mutations. The separate compatibility results are recorded under O4.

O4 verified on 2026-10-16: the final-source operator batches passed 100,
336 and 772 samples respectively. Three new known-value designs passed 132
samples through the original two-state backend under zero/one choices for
exposed arbitrary inputs; old v1/v2 artifacts replayed unchanged. Existing
combinational and sequential campaigns passed 197 and 3,584 samples.
Previously rejected constructs that are now supported became positive cases;
the remaining rejection counts are 35 and 22. No shared backend changed.

## Four-state elaborated hierarchy

- [x] H1: import pinned slang instance, parameter, generate and port binding
  results; audit only active hardware while retaining runtime branch checks.
- [x] H2: add v4 source/elaboration contracts and full-path register state,
  independent RTL observation paths and global simultaneous updates.
- [x] H3: run three-way hierarchy tests with independent register/parameter
  inventories, rejection checks and executed semantic fault injection.
- [x] H4: rerun existing four-state/two-state regressions and v1-v3 replays;
  publish current source snapshots, commands and final evidence.

H1-H4 verified on 2026-10-17 (Asia/Shanghai): four hierarchy scenarios,
336 samples, 38,752 output-bit and 71,872 register-bit positions; independent
inventories checked all 18 registers across three sequential designs,
including hidden generate state, ranges and instance parameters. The
integrated design contains 14 registers and 4/8/65-bit specializations.
All 27 rejection checks, 13 loader/inventory checks and three executed semantic
mutations passed. Direct v4 combinational/sequential CLI replay passed.
Existing combinational/sequential/operator and two-state compatibility
campaigns passed; old v1/v2/v3 artifacts replayed unchanged. Reports,
commands, exit codes and first fault differences are linked in the main doc.
No shared backend, server environment or historical report was changed.

## Four-state hierarchy audit corrections

- [x] H5: reject unknown generate-for structural values using the official
  evaluator; preserve normal and zero-iteration loops with new evidence.
- [x] H6: reject source cross-instance assignment, output target and event
  clock references while preserving local generate references and port binds.
- [x] H7: rerun hierarchy and affected combinational/sequential campaigns;
  record new reports separately from the historical H1-H4 acceptance.

The 2026-10-17 review found audit gaps in generate-for and cross-instance
targets/clocks. Historical PASS reports do not cover these newly found gaps;
the corrections are verified by new reports linked in the four-state document.
H5-H7 passed on 2026-10-17: five hierarchy cases, 340 samples, 38,768 output-bit
and 71,872 register-bit positions; 42 rejection checks (15 new), 13 loader/
inventory checks and three executed semantic faults. Normal/zero-iteration
loops and same-instance static generate references passed actual three-way
comparison. Combinational/sequential regressions passed 197/3,584 samples,
including 8/224 two-state samples; v1-v3 replays passed. All three campaign
commands exited 0. No operator/full-framework campaign was rerun this round.

## Four-state real XiangShan ALU

- [x] X1: restore pinned Nanhu dependencies, freshly elaborate the original
  AluDataModule and record its RTL structures and independent inventory.
- [x] X2: implement only the four-state gaps exposed by that RTL, with small
  three-way semantic checks and compatible versioned artifacts.
- [x] X3: compile and execute the generated Lean on known/four-state ALU
  vectors; compare exact RTL outputs and execute semantic mutations.
- [x] X4: rerun existing four-state/two-state and legacy replay regressions;
  record new evidence and remaining limits without changing shared backends.

X1-X4 verified on 2026-10-17: the original fixed Nanhu ALU has 10 child
instances, eight ports and no registers. Its default RTL converts to 835
four-state IR nodes and 5,458 FunctionalIR nodes; generated Lean compiled and
executed. All 20,931 samples / 1,381,446 output-bit positions matched exactly,
including 192,502 X and 2,221 Z positions. Three small designs passed 772
samples, 11 syntax/driver rejections and six v5 loader checks passed, two
executed ALU faults were detected, and 256 known samples matched the original
two-state entrypoint. All seven existing regression batches and v1-v4 replays
passed. Direct conversion/replay CLI checks passed 14 samples.

Reference exception: Icarus 13 cannot elaborate one nested packed select in
the default RTL. With the user's authorization, the reference is separately
emitted by the same official firtool using expression splitting, preserving
packed indexing. The initially considered disallowPackedArrays option is
excluded because an executed counterexample exposes its casez Z wildcard.
The default RTL remains untouched and is the conversion input. Exact source,
reference contract, commands, new reports and limits are in the main doc.

## Four-state ALU rejection audit correction

- [x] X5: disambiguate the DeadRuntimeMultiply literal and conditional;
  require syntax-valid, elaboration-valid input and an exact located
  unsupported MultiplyExpression diagnostic in both verification paths.
- [x] X6: save a new targeted report, exercise malformed/unrelated diagnostic
  guards and a supported control, and qualify the historical rejection claim.

X5-X6 verified on 2026-10-17 (Asia/Shanghai): seven targeted checks passed,
with command exit 0. The repaired fixture has no syntax/elaboration errors
and rejects at line 1, column 59 as unsupported hardware syntax
(MultiplyExpression). The former fixture produces syntax errors and cannot
satisfy the new contract. Four synthetic diagnostic guards and one supported
dead-branch control also passed; they are not additional hardware rejections.
The old report's DeadRuntimeMultiply PASS does not establish unsupported
multiplication rejection; the old report remains unchanged. Exact new report,
command and checks are linked in docs/fourstate-frontend.md.

This correction did not rerun ALU conversion, RTL/Lean execution or full
regressions. The reference contract remains: default original RTL is converted;
Icarus executes the official expression-split output of the same CHIRRTL.
Default RTL has not directly completed Icarus simulation. No shared backend,
upstream hardware, server environment or historical report was changed.

## Four-state backend integration compatibility fix

- [x] Reproduce truncated dead-expression arbitrary inputs and the large
  generated Lean default-stack failure with real commands and exit codes.
- [x] Purge dead public temporaries in a separate four-state backend copy;
  retain encoded.sv, all ports/states and the strict arbitrary-input rejection.
- [x] Compile the four-state source model with explicit Lean -s 65536 using
  the existing emission-only backend option; leave shared implementations unchanged.
- [x] Run flat/expanded targeted RTL, encoded RTL and Lean comparisons,
  normalized-copy rail checks, independent expectations and affected regressions.

Executed on 2026-10-17: BACKEND_FIX_PASS. Six targeted executions passed
2,624 samples and 9,248 independent checks. The same generated Lean source
fails with the default stack (3221226505, stack_space_exception) and compiles
with the explicit stack (exit 0). The new dead-cone regression rejects the
saved original entrypoint and passes the fixed entrypoint.

Seven existing campaigns passed 197/3584/340/1192/336/772/132 samples; old v4
replay passed 192 samples. A freshly generated official-layout L2TlbPrefetch
model passed the existing 80-sample smoke and 255-sample directed fixtures,
including 54/54 coverage points, all outputs/states, rails and independent
checks. This reuses the original F1.1/F1.2 mechanisms without weakening their
historical source-hash guards or claiming their pinned entrypoints reran.

Shared code/runtime hashes (116 files), earlier fixes and historical evidence
are preserved. No shared CLI/backend/two-state/server changes, new SV semantics,
commit or push. Finite validation is not default/normalized RTL equivalence or
whole-core four-state acceptance. Commands, failure controls, hashes, raw
traces and reproduction are linked in
[the four-state frontend document](docs/fourstate-frontend.md).

## F1.1 real XiangShan sequential four-state smoke

- [x] F1.1a: pin the saved L2TlbPrefetch CHIRRTL and prior read-only audit;
  regenerate the official disallowLocalVariables RTL without editing hardware.
- [x] F1.1b: independently list all nine ports and eleven registers (142 bits),
  supply explicit mixed four-state initial values and sixteen deterministic cycles.
- [x] F1.1c: compile and execute the reference RTL, encoded RTL and existing
  Lean sequential wrapper; compare every pre/post output and original state bit.
- [x] F1.1d: save commands, exits, raw traces, hashes, comparison counts and
  first-failure data; document the SMOKE_PASS scope and reference contract.

F1.1 executed on 2026-10-17 (Asia/Shanghai): SMOKE_PASS, command exit 0.
Sixteen cycles / eighty samples with pre/post observation compared 4,480
output-bit and 22,720 register-bit positions exactly, including X and Z.
Observed output/current-state rails matched at 54,400 tag/value bit positions;
both paths' 108,800 binary bit values were checked. All eleven explicit initial
states were confirmed by VPI-initialized reference observations. The actual
RunSequential.lean wrapper compiled and ran; first_failure is null.

Both conversion input and Icarus reference are the same official no-local-variable
RTL from saved CHIRRTL, using MinimalConfig(1) via NanhuCoreConfig, not DefaultConfig.
This is a finite smoke, not full four-state equivalence between default and
normalized RTL, full protocol validation, or whole-core four-state support.
The default RTL, converter, existing verification helpers, shared backend/IR/
runtime/CLI and all historical reports remain unchanged. No commit or push.
The command, report, fixture, sampling and reproduction limits are linked in
[the four-state frontend document](docs/fourstate-frontend.md).

## F1.2 real XiangShan directed sequential validation

- [x] F1.2a: verify F1.1 artifacts and reuse its exact official RTL, compiled v5
  model, VPI/trace/sampling, execution and comparison functions.
- [x] F1.2b: execute explicit eleven-register initial states and directed traces
  for ring history, NBA ordering, reset/data, stall, flush, X/Z and VPN semantics.
- [x] F1.2c: require executable trigger guards and independent literal/relational
  postconditions for every coverage point; save observed witnesses and misses.
- [x] F1.2d: rerun F1.1, the seven existing four-state batches and old v4 replay;
  retain raw results, hashes, first-failure data and scoped documentation.

F1.2 executed on 2026-10-17 (Asia/Shanghai): DIRECTED_PASS, command exit 0.
All 26 directed trajectories / 51 cycles / 255 samples matched at every pre/post
observation: 14,280 output-bit and 72,420 original register-bit positions.
All 54 required coverage points hit their actual trigger conditions and passed
independent expected-state checks. Observed binary rails matched at 173,400
tag/value bit positions. No first failure or missing coverage point was reported.

The unchanged F1.1 entrypoint reran with SMOKE_PASS (80 samples). Existing
combinational, sequential, hierarchy, width, logic, arithmetic and compatibility
campaigns passed 197/3584/340/100/336/772/132 samples; old v4 sequential replay
also passed 192 samples. Commands, snapshots, detailed witnesses and reports
are linked in the F1.2 section of docs/fourstate-frontend.md.

Only the official disallowLocalVariables MinimalConfig(1)/NanhuCoreConfig RTL
is covered. No converter, F1.1 mechanism, shared interface, two-state flow,
default RTL or historical report changed; no commit or push. This is finite
directed evidence, not default/normalized full equivalence or whole-core
four-state acceptance.

## F1.3 real XiangShan fault detection and closure

- [x] F1.3a: verify F1.1/F1.2 artifacts and reuse the existing RTL/VPI/Lean,
  mapping, trace, NBA sampling and exact output/state comparison mechanisms.
- [x] F1.3b: compile and execute isolated encoded RTL mutations for an output
  bit, an otherwise invisible original register bit, and reachable X-to-Z data.
- [x] F1.3c: require correct baselines, successful mutant execution and actual
  comparison exit 2, with exact first differences and independent trigger guards.
- [x] F1.3d: rerun F1.1/F1.2, seven existing batches and old v4 replay; retain
  commands, exits, raw traces, hashes, failed attempts and scoped documentation.

F1.3 executed on 2026-10-17 (Asia/Shanghai): FAULT_DETECTION_PASS, entry exit 0.
All three mutants compiled and executed with exit 0 and were rejected by the
unchanged exact comparator with exit 2. First differences: ring sample 0/pre,
io_out_valid[0] = 1/0/1; ring sample 3/post, old_reqs_2[0] = 0/1/0; vpn-arith
sample 23/post, io_out_bits_vpn[26] = X/Z/X (reference/mutant/Lean).
The state case preserves all 1,400 output-bit positions throughout its trace;
the X/Z case starts with fully known state and reaches X through input arithmetic
and a real edge. Raw rails confirm X=10 becoming Z=11, preserving known values.

Fresh F1.2 passed 255 samples and 54/54 coverage points; F1.1 passed 80 samples.
The seven existing batches passed 197/3584/340/100/336/772/132 samples and old
v4 replay passed 192 samples. The first fault-driver attempt stopped at a CRLF
assignment-location guard and remains BLOCKED in its own report; only the
dedicated injection script was fixed. The successful new run explicitly reuses
that freshly completed, hash-verified regression run. Default reproduction
reruns all regressions. Independent delivery inspection decodes actual stdout
and checks first differences, exit codes and all indexed artifact hashes.

This status covers only these specified fault-detection checks on official
disallowLocalVariables MinimalConfig(1)/NanhuCoreConfig RTL. It does not prove
default/normalized full equivalence, exhaustive fault coverage or whole-core
four-state correctness. No converter/shared interface/two-state changes, commit,
push or rollback. Reports, commands and reproduction limits are linked in
[the four-state frontend document](docs/fourstate-frontend.md).
