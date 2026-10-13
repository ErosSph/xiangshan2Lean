package reference

import chisel3._
import chisel3.experimental.DataMirror
import chisel3.stage.ChiselStage
import java.nio.file.{Files, Paths}
import java.nio.charset.StandardCharsets

/** Independent source elaboration using the official Chisel/FIRRTL compiler.
  * No Chicala AST, IR or Lean semantics are used on this path.
  */
object GenerateRTL {
  def main(args: Array[String]): Unit = {
    require(args.length >= 2, "Usage: reference.GenerateRTL <module> <directory> [constructor values]")
    val cls = Class.forName(args(0))
    val directory = Paths.get(args(1)).toAbsolutePath
    Files.createDirectories(directory)
    val constructor = cls.getConstructors.find(_.getParameterCount == args.length - 2).getOrElse(
      throw new IllegalArgumentException("No matching module constructor"))
    val values = constructor.getParameterTypes.toList.zip(args.drop(2)).map {
      case (t, v) if t == java.lang.Integer.TYPE => java.lang.Integer.valueOf(v)
      case (t, v) if t == java.lang.Boolean.TYPE => java.lang.Boolean.valueOf(v)
      case _ => throw new IllegalArgumentException("Unsupported reference constructor type")
    }
    var elaborated: RawModule = null
    def create(): RawModule = {
      val m = constructor.newInstance(values.map(_.asInstanceOf[AnyRef]): _*).asInstanceOf[RawModule]
      elaborated = m
      m
    }
    val verilog = (new ChiselStage).emitVerilog(create(), Array("--target-dir", directory.toString))
    val top = elaborated.desiredName
    Files.write(directory.resolve(top + ".v"), verilog.getBytes(StandardCharsets.UTF_8))
    val header = verilog.substring(verilog.indexOf("module " + top + "(")).takeWhile(_ != ';')
    val emittedNames = "(?m)^\\s*(?:input|output)\\s+(?:wire\\s+)?(?:\\[[^\\]]+\\]\\s+)?([a-zA-Z_][a-zA-Z0-9_$]*)".r
      .findAllMatchIn(header).map(_.group(1)).toSet
    def quote(value: String): String = "\"" + value.replace("\\", "\\\\").replace("\"", "\\\"") + "\""
    def flatten(path: String, data: Data): List[String] = data match {
      case b: Bundle => b.elements.toList.sortBy(_._1).flatMap { case (n, d) => flatten(path + "." + n, d) }
      case v: Vec[_] => v.toList.zipWithIndex.flatMap { case (d, i) => flatten(path + "." + i, d) }
      case leaf =>
        val direction = DataMirror.directionOf(leaf).toString.toLowerCase
        val width = leaf.getWidth
        val signed = leaf.isInstanceOf[SInt]
        var emitted = path.replace('.', '_')
        var attempts = 0
        while (width > 0 && !emittedNames(emitted) && attempts < 32) { emitted += "_"; attempts += 1 }
        require(width == 0 || emittedNames(emitted), s"Cannot map source port $path into official emitted RTL")
        List(s"{\"name\":${quote(path)},\"rtl_name\":${quote(emitted)},\"direction\":${quote(direction)},\"width\":$width,\"signed\":$signed}")
    }
    val ports = DataMirror.modulePorts(elaborated).toList.flatMap { case (n, d) => flatten(n, d) }
    val clocked = elaborated.isInstanceOf[Module]
    val metadata = s"{\"top\":${quote(top)},\"module\":${quote(args(0))},\"clocked\":$clocked,\"ports\":[${ports.mkString(",")}]}\n"
    Files.write(directory.resolve("ports.json"), metadata.getBytes(StandardCharsets.UTF_8))
    println(s"Official Chisel 3.5.6 / Scala FIRRTL RTL: ${directory.resolve(top + ".v")}")
  }
}
