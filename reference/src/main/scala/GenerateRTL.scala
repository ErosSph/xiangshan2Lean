package reference

import chisel3._
import chisel3.reflect.DataMirror
import circt.stage.ChiselStage
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
    emit(() => constructor.newInstance(values.map(_.asInstanceOf[AnyRef]): _*).asInstanceOf[RawModule], args(0), args(1))
  }

  def emit(factory: () => RawModule, moduleName: String, output: String): Unit = {
    val directory = Paths.get(output).toAbsolutePath
    Files.createDirectories(directory)
    var original: RawModule = null
    var mirrored = List.empty[(String, String, String, Int, Boolean)]
    // Legal, unique wrapper ports avoid guessing CIRCT's keyword/collision
    // renaming. The original class and every hardware statement remain intact.
    class ReferencePorts extends Module {
      override def desiredName = "Chisel2LeanReference"
      original = Module(factory())
      val clocked = original.isInstanceOf[Module]
      var serial = 0
      def expose(path: String, data: Data): Unit = data match {
        case b: Bundle => b.elements.toList.sortBy(_._1).foreach { case (n, d) => expose(path + "." + n, d) }
        case v: Vec[_] => v.toList.zipWithIndex.foreach { case (d, i) => expose(path + "." + i, d) }
        case leaf if clocked && (path == "clock" || path == "reset") =>
          mirrored :+= ((path, path, "input", 1, false))
        case leaf =>
          val direction = DataMirror.directionOf(leaf).toString.toLowerCase
          val name = "c2l_port_" + serial
          serial += 1
          val port = if (direction == "input") IO(Input(chiselTypeOf(leaf))) else IO(Output(chiselTypeOf(leaf)))
          port.suggestName(name)
          if (direction == "input") leaf := port else port := leaf
          mirrored :+= ((path, name, direction, leaf.getWidth, leaf.isInstanceOf[SInt]))
      }
      DataMirror.modulePorts(original).foreach { case (n, d) => expose(n, d) }
    }
    var elaborated: RawModule = null
    def create(): RawModule = { elaborated = new ReferencePorts; elaborated }
    val verilog = ChiselStage.emitSystemVerilog(create(), Array.empty[String],
      Array("--disable-all-randomization", "--default-layer-specialization=enable"))
    val top = elaborated.desiredName
    Files.write(directory.resolve(top + ".v"), verilog.getBytes(StandardCharsets.UTF_8))
    val header = verilog.substring(verilog.indexOf("module " + top + "(")).takeWhile(_ != ';')
    val emittedNames = "(?m)//[^\\r\\n]*".r.replaceAllIn(header, "").split(',').flatMap { declaration =>
      "[a-zA-Z_][a-zA-Z0-9_$]*".r.findAllIn(declaration).toList.lastOption
    }.toSet
    def quote(value: String): String = "\"" + value.replace("\\", "\\\\").replace("\"", "\\\"") + "\""
    val ports = mirrored.map { case (path, emitted, direction, width, signed) =>
      require(width == 0 || emittedNames(emitted), s"Missing stable reference port $path/$emitted")
      s"{\"name\":${quote(path)},\"rtl_name\":${quote(emitted)},\"direction\":${quote(direction)},\"width\":$width,\"signed\":$signed}"
    }
    val clocked = original.isInstanceOf[Module]
    val metadata = s"{\"top\":${quote(top)},\"module\":${quote(moduleName)},\"clocked\":$clocked,\"ports\":[${ports.mkString(",")}]}\n"
    Files.write(directory.resolve("ports.json"), metadata.getBytes(StandardCharsets.UTF_8))
    println(s"Official Chisel 7.3.0 / CIRCT firtool RTL: ${directory.resolve(top + ".v")}")
  }
}
