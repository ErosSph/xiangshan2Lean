# Executed environment

- Workspace: E:/ICT/chisel2lean, an independent local clone.
- Upstream: https://github.com/iscas-tis/chicala
- Pinned upstream HEAD: c8bab84b24c448c611b8bf2a87c7e9c26014b081.
- Local development branch: codex/chisel2lean4; no remote publication.
- Source/Scala compiler: 2.13.10; sbt 1.8.2.
- Chisel 3.5.6; official reference compiler plugin 3.5.6.
- Reference Scala FIRRTL dependency: 1.5.6.
- Original testcase dependency: chiseltest 0.5.6.
- JDK: Temurin 17.0.20.1+1, reused from E:/ICT/.tools.
- Lean: official 4.19.0 x86_64-w64-windows-gnu binary, commit 6caaee842e94.
- Verilator: 5.048 (2026-04-26), MSYS2 build.
- GCC: MSYS2 16.1.0; GNU Make 4.4.1.
- Python: Miniconda 3.11.13; all scripts use the standard library.
- Maven downloads, sbt launcher/cache and Lean binary are local to this project.
  No global software versions or existing Chisel 7.7.0 example were changed.

Managed sandbox networking and MSYS process objects required approved tool
escalation. Native tool execution works with that permission; the earlier
sandbox-only Verilator probe was not a failed installation.

Bootstrap records binary source URL, byte count and SHA256 in .tools/downloads.
Each experiment records commands, cwd, UTC start/end, exit status and full
stdout/stderr. sbt log dates use the local Hong Kong timezone.
