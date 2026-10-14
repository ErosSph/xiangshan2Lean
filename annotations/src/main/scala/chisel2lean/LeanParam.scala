package chisel2lean

import scala.annotation.StaticAnnotation

/** Require Chicala's Lean source frontend to retain this scalar's symbolic
  * parameter expression. Ordinary Chisel elaboration ignores the marker.
  *
  * In a Module or its source parents/traits, supported targets are immutable
  * Int/Boolean constructor parameters and
  * scalar member vals or parameterless defs derived from those parameters
  * or supported CDE field projections. This annotation performs no expansion.
  */
final class LeanParam extends StaticAnnotation
