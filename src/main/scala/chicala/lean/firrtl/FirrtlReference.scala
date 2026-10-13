package chicala.lean.firrtl

import java.nio.charset.StandardCharsets
import java.nio.file.{Files, Paths}
import firrtl.{CircuitState, ChirrtlForm, LowFirrtlCompiler, Parser, VerilogCompiler}
import firrtl.{ir => F}
import chicala.lean.backend.Json

/** Independent oracle: official FIRRTL -> Verilog, with no adapter/Lean IR use. */
object FirrtlReference {
  def main(args: Array[String]): Unit = {
    require(args.length >= 2, "Usage: FirrtlReference <input.fir> <directory> [top]")
    val parsed = FirrtlInput.parse(Paths.get(args(0)))
    val top = if (args.length > 2 && args(2).nonEmpty) args(2) else parsed.main
    val circuit = parsed.copy(main = top)
    val low = new LowFirrtlCompiler().compile(CircuitState(circuit, ChirrtlForm), Nil).circuit
    val ports = low.modules.find(_.name == top).get.ports
    val verilog = new VerilogCompiler().compileAndEmit(CircuitState(circuit, ChirrtlForm)).getEmittedCircuit.value
    val out = Paths.get(args(1))
    Files.createDirectories(out)
    Files.write(out.resolve(top + ".v"), verilog.getBytes(StandardCharsets.UTF_8))
    val metadata = Json.obj("top" -> Json.str(top), "clocked" -> ports.exists(_.tpe == F.ClockType).toString,
      "ports" -> Json.arr(ports.map { p =>
        val (width, signed) = p.tpe match {
          case F.UIntType(F.IntWidth(w)) => (w, false)
          case F.SIntType(F.IntWidth(w)) => (w, true)
          case F.ClockType => (BigInt(1), false)
          case other => throw new IllegalArgumentException("Unsupported reference port " + other.serialize)
        }
        Json.obj("name" -> Json.str(p.name), "rtl_name" -> Json.str(p.name),
          "direction" -> Json.str(if (p.direction == F.Input) "input" else "output"),
          "width" -> width.toString, "signed" -> signed.toString)
      }))
    Files.write(out.resolve("ports.json"), metadata.getBytes(StandardCharsets.UTF_8))
  }
}
