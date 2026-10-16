package chicala.convert

import scala.tools.nsc
import nsc.Global
import nsc.Phase
import nsc.plugins.PluginComponent

import java.io._

import chicala.util.Format
import chicala.convert.frontend.Scala2Reader
import chicala.util.Printer
import chicala.convert.backend.stainless.StainlessEmitter
import chicala.convert.pass._
import chicala.ChicalaConfig
import chicala.lean.frontend.LeanAdapter
import chicala.lean.frontend.LeanSourceResolver
import chicala.lean.ir.{Module => IRModule, Normalize, TranslationError, Source}
import chicala.lean.backend.{LeanEmitter, Json}
import scala.util.control.NonFatal
import java.nio.file.{Files, Paths}
import java.nio.charset.StandardCharsets

object ChiselToScalaComponent {
  val phaseName = "chiselToScala"
}

class ChiselToScalaComponent(val global: Global) extends PluginComponent {
  import global._

  val runsAfter: List[String] = List("typer")

  // to keep recursive structure
  override val runsBefore: List[String] = List("tailcalls")

  val phaseName: String = ChiselToScalaComponent.phaseName

  def newPhase(_prev: Phase) = new ChiselToScalaPhase(_prev)

  class ChiselToScalaPhase(prev: Phase)
      extends StdPhase(prev)
      with Scala2Reader
      with LeanAdapter
      with LeanSourceResolver
      with ChicalaPassCollecttion
      with StainlessEmitter
      with Format {
    lazy val global: ChiselToScalaComponent.this.global.type = ChiselToScalaComponent.this.global

    val testRunDir = new File("test_run_dir/" + phaseName)
    testRunDir.mkdirs()

    val chicalaLog = new BufferedWriter(new PrintWriter(testRunDir.getPath() + "/chicala_log.txt"))
    global.computePhaseAssembly().foreach(s => chicalaLog.write(s.toString + "\n"))
    chicalaLog.close()

    var readerInfo: ReaderInfo = ReaderInfo.empty
    private val leanTrees = scala.collection.mutable.LinkedHashMap.empty[String, (Tree, String, Boolean)]
    private val leanDefinitions = scala.collection.mutable.Map.empty[String, (ModuleDef, Tree)]
    private val leanSourceMetadata = scala.collection.mutable.Map.empty[String, String]
    private val leanParameterBindings = scala.collection.mutable.Map.empty[String, List[LeanParamBinding]]

    private def safely(tree: Tree)(body: => Unit): Unit = try body catch {
      case e: TranslationError =>
        val src = global.currentRun.units.map(_.source).find(_.file.path == e.source.file)
        val pos = src.map(s => new scala.reflect.internal.util.OffsetPosition(s,
          s.lineToOffset(e.source.line - 1) + e.source.column - 1)).getOrElse(tree.pos)
        reporter.error(pos, "[chisel2lean] " + e.detail)
      case NonFatal(e) => reporter.error(tree.pos, s"[chisel2lean] Frontend could not represent this module: ${e.getClass.getSimpleName}: ${e.getMessage}")
    }

    private def emitLean(name: String, cache: scala.collection.mutable.Map[String, IRModule], stack: Set[String] = Set.empty): IRModule = {
      if (stack(name)) {
        val root = leanDefinitions(name)._2
        throw TranslationError(Source(root.pos.source.file.path, root.pos.line, root.pos.column + 1), "Recursive module instantiation: " + name)
      }
      cache.getOrElseUpdate(name, {
        val (definition, root) = leanDefinitions.getOrElse(name, throw new IllegalArgumentException("Module source unavailable: " + name))
        adaptToLean(definition, root, child => emitLean(child, cache, stack + name), leanParameterBindings.getOrElse(name, Nil))
      })
    }

    override def run(): Unit = {
      super.run()
      if (ChicalaConfig.backend == "lean") {
        val targets = leanTrees.toList.collect { case (name, (tree, pkg, true))
          if ChicalaConfig.module.isEmpty || ChicalaConfig.module == name || ChicalaConfig.module == name.split('.').last => name }
        val needed = scala.collection.mutable.LinkedHashSet.empty[String]
        val resolvedTrees = scala.collection.mutable.Map.empty[String, Tree]
        def visit(name: String): Unit = if (!needed(name)) {
          needed += name
          val original = leanTrees(name)._1.asInstanceOf[ClassDef]
          val tree = if (needsLeanSourceResolution(original)) {
            val resolved = resolveLeanSource(original)
            leanSourceMetadata(name) = resolved.metadata
            leanParameterBindings(name) = resolved.leanParameters
            resolved.tree
          } else original
          resolvedTrees(name) = tree
          new Traverser {
            override def traverse(t: Tree): Unit = {
              t match {
                case New(tpt) if tpt.tpe != null && leanTrees.contains(tpt.tpe.typeSymbol.fullName) => visit(tpt.tpe.typeSymbol.fullName)
                case _ =>
              }
              super.traverse(t)
            }
          }.traverse(tree)
        }
        targets.foreach(name => safely(leanTrees(name)._1) { visit(name) })
        needed.toList.reverse.foreach { name =>
          val (tree, pkg, isModule) = leanTrees(name)
          safely(tree) {
            resolvedTrees.get(name).foreach(applyOnTree(_, pkg))
          }
        }
        processTodos()
        readerInfo.todos.foreach { case (t, _) => reporter.error(t.pos, "Module or Bundle dependency could not be resolved") }
        val cache = scala.collection.mutable.Map.empty[String, IRModule]
        targets.foreach { name => safely(leanTrees(name)._1) {
          if (!reporter.hasErrors) {
            val ir = Normalize(emitLean(name, cache))
            if (name == "Chisel2Lean.Runtime") throw TranslationError(ir.module.source, "Module name collides with the generated runtime library")
            val segments = name.split('.').toList
            if (!segments.forall(_.matches("[a-zA-Z_][a-zA-Z0-9_]*"))) throw TranslationError(ir.module.source, "Module/package names must be ASCII identifiers")
            val directory = Paths.get(ChicalaConfig.leanOutput).resolve(segments.dropRight(1).mkString("/"))
            Files.createDirectories(directory)
            Files.write(directory.resolve(segments.last + ".lean"), LeanEmitter.emit(ir).getBytes(StandardCharsets.UTF_8))
            Files.write(directory.resolve(segments.last + ".ir.json"), (Json.module(ir,
              Some(ChicalaConfig.leanChiselVersion), leanSourceMetadata.get(name).map(m => "configuration" -> m).toList) + "\n").getBytes(StandardCharsets.UTF_8))
          }
        } }
        return
      }
      processTodos()
      readerInfo.todos.foreach { case (t, pname) => reporter.error(t.pos, "This class not processed") }
    }

    def apply(unit: CompilationUnit): Unit = {
      if (ChicalaConfig.backend == "lean") {
        registerLeanSources(unit.body)
        new Traverser {
          override def traverse(t: Tree): Unit = {
            t match {
              case c: ClassDef if c.symbol != NoSymbol && !c.symbol.isAnonymousClass =>
                val name = c.symbol.fullName
                val pkg = c.symbol.owner.fullName
                val bases = c.symbol.asClass.baseClasses.map(_.fullName)
                val isBundle = bases.contains("chisel3.Bundle") && !c.mods.isTrait && !c.symbol.isAbstractClass
                val isModule = bases.contains("chisel3.RawModule") && !c.mods.isTrait && !c.symbol.isAbstractClass
                if (isBundle || isModule) leanTrees(name) = (c, if (pkg == "<empty>") "" else pkg, isModule)
              case _ =>
            }
            super.traverse(t)
          }
        }.traverse(unit.body)
        return
      }
      val packageDef  = unit.body.asInstanceOf[PackageDef]
      val packageName = packageDef.pid.toString()

      for (tree @ ClassDef(mods, name, tparams, Template(parents, self, body)) <- packageDef.stats) {
        if (ChicalaConfig.backend != "lean") applyOnTree(tree, packageName)
        else {
          val fullName = List(packageName, name.toString).filter(p => p.nonEmpty && p != "<empty>").mkString(".")
          val bases = tree.symbol.asClass.baseClasses.map(_.fullName)
          val isBundle = bases.contains("chisel3.Bundle") && !mods.isTrait && !tree.symbol.isAbstractClass
          val isModule = bases.contains("chisel3.RawModule")
          if (isBundle || isModule) leanTrees(fullName) = (tree, if (packageName == "<empty>") "" else packageName, isModule)
        }
      }
    }

    def applyOnTree(tr: Tree, packageName: String): Unit = {
      val packageDir = s"${testRunDir.getPath()}/test/${packageName.replace(".", "/")}"
      val outputDir  = s"${testRunDir.getPath()}/out/${packageName.replace(".", "/")}"
      (new File(packageDir)).mkdirs()
      (new File(outputDir)).mkdirs()

      tr match {
        case tree @ ClassDef(mods, name, tparams, Template(parents, self, body)) =>
          Format.saveToFile(
            packageDir + s"/${name}.scala",
            show(tree) + "\n"
          )
          Format.saveToFile(
            packageDir + s"/${name}.AST.scala",
            showFormattedRaw(tree) + "\n"
          )

          val someInfoAndDef = CClassDefLoader(tree, packageName)(readerInfo)

          val (newRInfo, someCClassDef) = someInfoAndDef match {
            case Some((newRInfo, someCClassDef)) => { (newRInfo, someCClassDef) }
            case None =>
              reporter.error(tree.pos, "Unknown error in ChiselToScalaPhase #1")
              return
          }

          if (newRInfo.needExit) {
            if (newRInfo.isDependentClassNotDef) {
              readerInfo = newRInfo.clearedDependentClassNotDef.addedTodo(tree, packageName)
            }
            if (readerInfo.needExit == true)
              reporter.error(tree.pos, "Unknown error in ChiselToScalaPhase #2")
            return
          }

          someCClassDef match {
            case None =>
              reporter.error(tree.pos, "Unknown error in ChiselToScalaPhase #3")
            case Some(cClassDef) =>
              Format.saveToFile(
                packageDir + s"/${name}.chicala.scala",
                cClassDef.toString + "\n"
              )

              if (ChicalaConfig.backend == "lean") {
                cClassDef match {
                  case m: ModuleDef =>
                    readerInfo = readerInfo.addedModuleDef(m)
                    // Keep source connection order. DependencySort/SubModuleCall encode
                    // assumptions of the Scala backend that are not our semantic contract.
                    val prepared = RunChicalaPass(m, List(LiteralPropagation, RegEnableApply)).asInstanceOf[ModuleDef]
                    leanDefinitions(m.fullName.stripPrefix(".")) = (prepared, tree)
                  case b: BundleDef => readerInfo = readerInfo.addedBundleDef(b)
                }
                return
              }

              val sortedCClassDef = cClassDef match {
                case m @ ModuleDef(name, info, body, pkg) =>
                  readerInfo = readerInfo.addedModuleDef(m)

                  val sorted = RunChicalaPass(
                    m,
                    List(
                      LiteralPropagation,
                      RegEnableApply,
                      SubModuleCall,
                      ChicalaPeek(packageDir, "beforSort"),
                      DependencySort,
                      ChicalaPeek(packageDir, "sorted")
                    )
                  )
                  sorted
                case b: BundleDef =>
                  readerInfo = readerInfo.addedBundleDef(b)
                  b
              }

              sortedCClassDef match {
                case m: ModuleDef =>
                  if (ChicalaConfig.simulation == false)
                    Format.saveToFile(
                      outputDir + s"/${name}.stainless.scala",
                      EmitStainless(m)
                    )
                  else
                    Format.saveToFile(
                      outputDir + s"/${name}.simscala.scala",
                      EmitStainless(m)
                    )
                case _ =>
              }

          }

      }
    }

    def processTodos(): Unit = {
      var lastNum = readerInfo.todos.size + 1
      while (readerInfo.todos.size > 0 && lastNum > readerInfo.todos.size) {
        val todos = readerInfo.todos
        lastNum = todos.size
        readerInfo = readerInfo.copy(todos = List.empty)
        todos.foreach { case (t, pname) => if (ChicalaConfig.backend == "lean") safely(t)(applyOnTree(t, pname)) else applyOnTree(t, pname) }
      }
    }

  }

}
