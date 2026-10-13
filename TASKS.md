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
