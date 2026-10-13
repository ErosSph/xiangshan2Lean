package chicala.lean.firrtl

import java.nio.charset.StandardCharsets
import java.nio.file.{Files, Paths}
import firrtl.{CircuitState, ChirrtlForm, LowFirrtlCompiler, Parser}
import chicala.lean.ir.{Normalize, TranslationError}
import chicala.lean.backend.{Json, LeanEmitter}

/** Separate entry point: never invokes the Scala/Chicala source frontend. */
object FirrtlMain {
  def main(args: Array[String]): Unit = try {
    require(args.length >= 2, "Usage: FirrtlMain <input.fir> <output-dir> [top-module] [Lean-namespace]")
    val input = Paths.get(args(0)).toAbsolutePath
    val out = Paths.get(args(1)).toAbsolutePath
    val parsed = FirrtlInput.parse(input)
    val top = if (args.length >= 3 && args(2).nonEmpty) args(2) else parsed.main
    require(parsed.modules.exists(_.name == top), "Unknown top module " + top)
    val namespace = if (args.length >= 4 && args(3).nonEmpty) args(3) else "FIRRTL." + top
    require(namespace.split('.').forall(_.matches("[a-zA-Z_][a-zA-Z0-9_]*")), "Invalid Lean namespace")
    // Official lowering: expand CHIRRTL memories, resolve widths, lower aggregates,
    // and resolve when/last-connect. Preserve hierarchy for our scoped traversal.
    val lowered = new LowFirrtlCompiler().compile(CircuitState(parsed.copy(main = top), ChirrtlForm), Nil).circuit
    val normalized = Normalize(FirrtlAdapter(lowered, namespace, input.toString))
    Files.createDirectories(out)
    Files.write(out.resolve("lowered.fir"), lowered.serialize.getBytes(StandardCharsets.UTF_8))
    val segments = namespace.split('.')
    val directory = segments.dropRight(1).foldLeft(out)((p, n) => p.resolve(n))
    Files.createDirectories(directory)
    val contract = if (normalized.next.isEmpty) "valid p; combinational semantics; reset ports remain explicit inputs." else
      "valid p; one synchronous clock; reset ports remain explicit inputs; supply initial State; the optional step reset argument is unused."
    val lean = FirrtlLeanEmitter.emit(normalized, contract)
    val metadata = List("frontend" -> Json.str("firrtl"), "firrtlVersion" -> Json.str("1.5.6"),
      "scalaVersion" -> Json.str(scala.util.Properties.versionNumberString),
      "expressionRepresentation" -> Json.str("pure-named-DAG"),
      "circuitTop" -> Json.str(top), "resetInterface" -> Json.str("explicit-input"),
      "initialState" -> Json.str("caller-supplied-for-registers"))
    Files.write(directory.resolve(segments.last + ".lean"), lean.getBytes(StandardCharsets.UTF_8))
    val resetMode = if (normalized.next.isEmpty) "none-combinational" else "single-clock-explicit-input-reset"
    Files.write(directory.resolve(segments.last + ".ir.json"), Json.module(normalized, None, metadata, Some(resetMode)).getBytes(StandardCharsets.UTF_8))
    println(s"FIRRTL $top -> $namespace: ${normalized.signals.size} signals, ${normalized.next.size} state fields")
  } catch {
    case e: TranslationError =>
      System.err.println(s"${e.source.file}:${e.source.line}:${e.source.column}: ${e.detail}")
      sys.exit(2)
    case e: Exception =>
      System.err.println("FIRRTL frontend failed: " + e.getMessage)
      sys.exit(2)
  }
}
