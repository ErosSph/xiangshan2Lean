package reference

import java.nio.file.{Files, Paths}
import java.nio.charset.StandardCharsets
import org.chipsalliance.cde.config.{Field, Parameters}
import chisel3.RawModule

/** Materialize the frontend's field paths against real CDE objects. The same
  * objects are then supplied to the original module's constructor for RTL.
  */
object ConfiguredModule {
  private def primitive(t: Class[_], v: ujson.Value): AnyRef = {
    if (t == java.lang.Integer.TYPE) {
      val number = v.num
      require(number.isWhole && number >= Int.MinValue && number <= Int.MaxValue, "Expected a Scala Int")
      java.lang.Integer.valueOf(number.toInt)
    } else if (t == java.lang.Boolean.TYPE) java.lang.Boolean.valueOf(v.bool)
    else if (t == classOf[String]) v.str
    else throw new IllegalArgumentException("Unsupported configuration factory argument: " + t.getName)
  }

  private def construct(name: String, args: Seq[ujson.Value]): AnyRef = {
    val cls = Class.forName(name)
    val matching = cls.getConstructors.filter(_.getParameterCount == args.size)
    require(matching.length == 1, "Configuration factory needs one matching public constructor: " + name)
    val constructor = matching.head
    constructor.newInstance(constructor.getParameterTypes.zip(args).map { case (t, v) => primitive(t, v) }: _*)
  }

  private def key(name: String): Field[Any] =
    Class.forName(name + "$").getField("MODULE$").get(null).asInstanceOf[Field[Any]]

  private def classHash(name: String): String = {
    val stream = Class.forName(name).getResourceAsStream("/" + name.replace('.', '/') + ".class")
    require(stream != null, "Class bytes unavailable: " + name)
    try java.security.MessageDigest.getInstance("SHA-256").digest(stream.readAllBytes()).map(b => f"${b & 255}%02x").mkString
    finally stream.close()
  }

  def main(args: Array[String]): Unit = {
    require(args.length >= 4, "Usage: ConfiguredModule <ir.json> <factories.json> <constructor.json> <snapshot.json> [RTL directory]")
    val ir = ujson.read(Files.readString(Paths.get(args(0))))
    val factories = ujson.read(Files.readString(Paths.get(args(1))))
    val plain = ujson.read(Files.readString(Paths.get(args(2))))
    val meta = ir("configuration")
    val configNames = meta("constructor").arr.filter(_("kind").str == "configuration").map(_("name").str).toSet
    val plainNames = meta("constructor").arr.filter(_("kind").str != "configuration").map(_("name").str).toSet
    require(factories.obj.keySet.toSet == configNames, "Supply exactly the configuration constructor roots")
    require(plain.obj.keySet.toSet == plainNames, "Supply exactly the primitive constructor parameters")
    val configurations = factories.obj.map { case (name, descriptor) =>
      val value = construct(descriptor("class").str, descriptor("args").arr.toSeq)
      require(value.isInstanceOf[Parameters], "Factory must construct real CDE Parameters")
      name -> value.asInstanceOf[Parameters]
    }.toMap
    val queried = scala.collection.mutable.Map.empty[(String, String), Any]
    def query(root: String, k: String): Any = queried.getOrElseUpdate((root, k), configurations(root)(key(k)))
    meta("required_keys").arr.foreach(k => query(k("root").str, k("key").str))
    val values = ujson.Obj.from(plain.obj)
    meta("fields").arr.foreach { f =>
      var value = query(f("root").str, f("key").str)
      f("selectors").arr.foreach { selector =>
        require(value != null, "Null configuration record at " + selector.str)
        val methods = value.getClass.getMethods.filter(m => m.getName == selector.str && m.getParameterCount == 0)
        require(methods.nonEmpty, "Configuration field unavailable: " + selector.str)
        value = methods.head.invoke(value)
      }
      val scalar: ujson.Value = f("kind").str match {
        case "Int" => require(value.isInstanceOf[java.lang.Integer], "Expected Int configuration field"); ujson.Num(value.asInstanceOf[Int])
        case "Bool" => require(value.isInstanceOf[java.lang.Boolean], "Expected Boolean configuration field"); ujson.Bool(value.asInstanceOf[Boolean])
        case other => throw new IllegalArgumentException("Unsupported field kind: " + other)
      }
      values(f("name").str) = scalar
    }
    val constructor = meta("constructor").arr.sortBy(_("index").num).map { p =>
      if (p("kind").str == "configuration") configurations(p("name").str).asInstanceOf[AnyRef]
      else {
        val cls = if (p("kind").str == "Int") java.lang.Integer.TYPE else java.lang.Boolean.TYPE
        primitive(cls, plain(p("name").str))
      }
    }
    val snapshot = ujson.Obj(
      "format" -> "chisel2lean-configuration-v1", "module" -> ir("module"), "parameters" -> values,
      "factories" -> factories, "constructor" -> plain,
      "class_sha256" -> ujson.Obj.from((factories.obj.values.map(_("class").str).toSeq :+ ir("module").str).distinct.map(n => n -> ujson.Str(classHash(n)))),
      "projection" -> meta("fields"), "chisel_version" -> chisel3.BuildInfo.version)
    val path = Paths.get(args(3)).toAbsolutePath
    Files.createDirectories(path.getParent)
    Files.writeString(path, ujson.write(snapshot, indent = 2), StandardCharsets.UTF_8)
    if (args.length > 4) {
      val cls = Class.forName(ir("module").str)
      val matching = cls.getConstructors.filter(_.getParameterCount == constructor.size)
      require(matching.length == 1, "Module requires one matching primary constructor")
      GenerateRTL.emit(() => matching.head.newInstance(constructor.toSeq: _*).asInstanceOf[RawModule], ir("module").str, args(4))
    }
    println("Real CDE fields materialized: " + ujson.write(values))
  }
}
