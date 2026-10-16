package reference

import chisel3.RawModule
import java.nio.file.{Files, Paths}

/** Official fixed-configuration elaboration, independent of the source translator.
  * Constructor arguments are primitives or recursively constructed JVM objects.
  * Thus real CDE Config/Parameters are evaluated by the original project itself.
  */
object ElaborateChisel {
  private def argument(value: ujson.Value, expected: Class[_]): AnyRef = {
    if (value.isInstanceOf[ujson.Obj]) {
      val result = construct(value("class").str, value.obj.get("args").map(_.arr.toSeq).getOrElse(Nil))
      require(expected.isInstance(result), "Factory object does not match constructor type " + expected.getName)
      result
    } else if (expected == java.lang.Integer.TYPE) {
      require(value.num.isWhole && value.num >= Int.MinValue && value.num <= Int.MaxValue, "Expected Scala Int")
      java.lang.Integer.valueOf(value.num.toInt)
    } else if (expected == java.lang.Boolean.TYPE) java.lang.Boolean.valueOf(value.bool)
    else if (expected == classOf[String]) value.str
    else throw new IllegalArgumentException("Supply a class/args factory for " + expected.getName)
  }
  private def construct(name: String, args: Seq[ujson.Value]): AnyRef = {
    val candidates = Class.forName(name).getConstructors.filter(_.getParameterCount == args.size)
    require(candidates.length == 1, "Expected one public constructor of matching arity: " + name)
    val constructor = candidates.head
    constructor.newInstance(constructor.getParameterTypes.zip(args).map { case (t, v) => argument(v, t) }: _*)
  }
  def main(args: Array[String]): Unit = {
    require(args.length == 3, "Usage: ElaborateChisel <module-class> <constructor-array.json> <directory>")
    require(chisel3.BuildInfo.version == "7.3.0", "This elaboration bridge requires pinned Chisel 7.3.0")
    val values = ujson.read(Files.readString(Paths.get(args(1)))).arr.toSeq
    GenerateRTL.emit(() => construct(args(0), values).asInstanceOf[RawModule], args(0), args(2), emitChirrtl = true)
    def factoryClasses(v: ujson.Value): Seq[String] = v match {
      case o: ujson.Obj => Seq(o("class").str) ++ o.obj.get("args").toSeq.flatMap(_.arr.flatMap(factoryClasses))
      case _ => Nil
    }
    def hash(name: String): String = {
      val stream = Class.forName(name).getResourceAsStream("/" + name.replace('.', '/') + ".class")
      require(stream != null, "Class bytes unavailable for " + name)
      try java.security.MessageDigest.getInstance("SHA-256").digest(stream.readAllBytes()).map(b => f"${b & 255}%02x").mkString
      finally stream.close()
    }
    val classes = (Seq(args(0)) ++ values.flatMap(factoryClasses)).distinct
    val metadata = ujson.Obj("chisel_version" -> chisel3.BuildInfo.version,
      "scala_version" -> scala.util.Properties.versionNumberString,
      "class_sha256" -> ujson.Obj.from(classes.map(name => name -> ujson.Str(hash(name)))))
    Files.writeString(Paths.get(args(2)).resolve("jvm-elaboration.json"), ujson.write(metadata, indent = 2))
  }
}
