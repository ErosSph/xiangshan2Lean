# Chisel2Lean working rules

Implement Chisel 7.3.0 -> typed parameterized IR -> executable Lean 4.
The user authorized continuous implementation on 2026-10-13, including work
beyond the handoff's T0 stopping point. Do not stop at an audit or a hand-written
Counter model. The handoff is preserved in docs/handoff as source material.

Preserve parameter dependencies, widths, signedness, synchronous old-state
reads, connection priority, input-dependent outputs, and explicit reset
semantics. Unsupported hardware must fail with a source location. No sorry,
admit, new axioms, hard-coded module templates, or invented initial states.

Keep the original Scala backend available. Pin upstream commit, Scala, Chisel,
sbt and Lean. Use project-local dependencies and caches. Preserve upstream
license. Publish or push only when explicitly requested by the human user.
The user explicitly authorized creating and uploading a private GitHub repository
named chisel2lean4. Preserve the original working directory and upstream history;
publish a reviewed source/model/evidence snapshot to the new repository.
Never destroy user files as part of this task.

Record the frontend audit, semantics, support matrix, decisions, and real
compiler/runtime/differential evidence. Finite tests are not an equivalence
proof. A versioned, tested subset is the deliverable; arbitrary Scala is not
an implicit support promise.

The user explicitly authorized upgrading the whole project to Chisel 7.3 on
2026-10-13. Preserve earlier version evidence as historical and revalidate.
