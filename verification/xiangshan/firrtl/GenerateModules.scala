package validation

import java.nio.charset.StandardCharsets
import java.nio.file.{Files, Paths}
import chisel3._
import chisel3.stage.ChiselStage
import chipsalliance.rocketchip.config.Parameters
import xiangshan.{XSCoreParamsKey, XSTileKey}
import xiangshan.backend.fu.{RightShiftModule, AluDataModule}

/** Instantiate ORIGINAL modules with ORIGINAL full-project configuration classes. */
object GenerateModules {
  def main(args: Array[String]): Unit = {
    require(args.length == 2, "GenerateModules <RightShiftModule|AluDataModule> <directory>")
    val base = (new top.MinimalConfig(1)).toInstance
    implicit val p: Parameters = base.alterPartial {
      case XSCoreParamsKey => base(XSTileKey).head
    }
    val factory: () => RawModule = args(0) match {
      case "RightShiftModule" => () => new RightShiftModule
      case "AluDataModule" => () => new AluDataModule
      case other => throw new IllegalArgumentException("Unknown target " + other)
    }
    val directory = Paths.get(args(1)).toAbsolutePath
    Files.createDirectories(directory)
    val text = (new ChiselStage).emitChirrtl(factory(), Array("--target-dir", directory.toString))
    Files.write(directory.resolve(args(0) + ".fir"), text.getBytes(StandardCharsets.UTF_8))
    // A separate official elaboration/compiler path supplies the native oracle.
    val rtl = (new ChiselStage).emitVerilog(factory(), Array("--target-dir", directory.toString))
    Files.write(directory.resolve(args(0) + ".v"), rtl.getBytes(StandardCharsets.UTF_8))
    println("Original XiangShan v2.1 / MinimalConfig(1), XLEN=" + p(XSCoreParamsKey).XLEN)
  }
}
