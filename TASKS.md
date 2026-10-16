# Chisel2Lean4 implementation

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
