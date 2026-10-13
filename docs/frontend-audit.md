# T0 frontend audit

Status: PASS for the audit task; upstream support is conditional and incomplete.
Upstream commit: c8bab84b24c448c611b8bf2a87c7e9c26014b081.

The original `publishLocal testcase/compile` completed with exit 0 under Java 17,
sbt 1.8.2 and Scala 2.13.10. Logs: `experiments/t0_frontend_audit/baseline`.
This was compilation/translation, not hardware simulation.

The original audit probe compilation failed with exit 1 at DirectCounter:
`ValDefsReader.loadIoDef` assumes Bundle IO and calls `None.get` for a scalar
IO. Logs: `experiments/t0_frontend_audit/probes`. Before that failure, dumps
were produced for Counter, DualRegister, Priority, ParamChoice, VecLoop and
ParamExpression. They show symbolic constructor parameters, width expressions,
RegDef reset literals, When connections, Scala SIf branches, and range/foreach
with an SFunction. `require` is represented as SApply but the original Scala
emitter reports a TODO for Scala Predef handling.

Reuse the source Reader after `typer`, `LiteralPropagation` and `RegEnableApply`.
Construct hardware IR before `DependencySort`; the new normalizer preserves
last-connect priority and resolves combinational dependencies itself. Do not
reuse the original fixed-count simulation wrapper as a cycle/reset contract.

Necessary changes: scalar IO loading, strict unsupported diagnostics, a source
position side table, additional explicit operators, a typed IR, independent
width rules, and a Lean emitter. The original Scala backend remains selectable.
Submodule lowering and parameter-dependent declaration layouts are explicitly
outside the first implementation subset.

The conditional regression also found that the upstream Otherwise loader
replaces the elsewhen chain. Lean mode now attaches the final otherwise at the
end of that chain; nested and chained conditional fixtures are tested against
official RTL. Source Scala backend behavior remains unchanged.

This audit supplies an integration point and actual positive/negative evidence.
It does not establish semantic correctness of all Chicala passes or all probes.
