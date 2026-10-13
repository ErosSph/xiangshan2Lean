# Decisions

- 2026-10-13: User selected Chisel 3.5.6. Pin Scala 2.13.10,
  sbt 1.8.2, chiseltest 0.5.6, use the existing JDK 17.
- Upstream: iscas-tis/chicala at c8bab84b24c448c611b8bf2a87c7e9c26014b081.
- User explicitly authorized continuing beyond T0 to a working translator.
  The stopping instruction in the imported handoff is superseded.
- Lean 4.19.0 is pinned. Use its official local binary and standard BitVec;
  the initial backend needs no Mathlib or proof automation dependency.
- Use the original source Reader and suitable passes. Normalize hardware into
  a separate typed IR before Lean emission. Preserve connection order before
  DependencySort; resolving combinational dependencies belongs in our IR.
- Use the matching Chisel 3.5.6 Scala FIRRTL compiler for independent RTL.
  Finite differential tests do not establish a universal equivalence proof.
- Compiler distribution is an immutable SHA256-addressed jar snapshot with
  an atomically replaced classpath index. A diagnosis run overlapped the old
  mutable jar packaging and failed to load a class; after this change the full
  rejection group was rerun successfully.
- Conditional source widths and domain guards distinguish Scala if from
  hardware Mux/when. Elsewhen/otherwise preserves the complete condition chain.
- 2026-10-13: User requested a relatively complete implementation after v0.1.
  Extend the single-clock source subset through hierarchy, state/width idioms,
  arrays, control and memories; archive the v0.1 evidence separately.
- Hierarchy is instantiated in symbolic IR, with parameter substitution and
  instance prefixes. All registers read the same old state across instances.
- Scalar width inference includes overridden connects and reset constraints.
  Array legality uses finite quantified parameter predicates and unique binders.
- Division, dynamic array access and synchronous memory results expose executable
  definedness predicates. Disabled SyncReadMem reads and same-edge collisions in
  default Undefined mode are rejected by the trace observer.
- Verilator wide ports use decimal input parsing and hexadecimal multi-word
  output. std::array avoids the installed GCC 16/libstdc++ move-constructor link
  incompatibility encountered with vector<string>; 65/128-bit probes passed.
- Release evidence records SHA256 fingerprints of source, generated models,
  runtime and differential drivers. Resume cannot reuse an unmatched case.
