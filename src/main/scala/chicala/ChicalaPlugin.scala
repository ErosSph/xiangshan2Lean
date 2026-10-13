package chicala

import scala.tools.nsc
import nsc.Global
import nsc.Phase
import nsc.plugins.Plugin
import nsc.plugins.PluginComponent

import chicala.convert.ChiselToScalaComponent

object ChicalaPlugin {
  val name: String        = "chicala"
  val description: String = "Convert Chisel to semantically equivalent Scala program"
}

object ChicalaConfig {
  var simulation = false
  var backend = "scala"
  var leanOutput = "generated"
  var module = ""
}

class ChicalaPlugin(val global: Global) extends Plugin {
  import global._

  val name: String        = ChicalaPlugin.name
  val description: String = ChicalaPlugin.description

  val components: List[PluginComponent] = List(
    new ChiselToScalaComponent(global)
  )

  override def init(options: List[String], error: String => Unit): Boolean = {
    ChicalaConfig.simulation = false
    ChicalaConfig.backend = "scala"
    ChicalaConfig.leanOutput = "generated"
    ChicalaConfig.module = ""
    var valid = true
    for (option <- options) {
      if (option == "backend:lean") ChicalaConfig.backend = "lean"
      else if (option == "backend:scala") ChicalaConfig.backend = "scala"
      else if (option.startsWith("out:")) ChicalaConfig.leanOutput = option.substring(4)
      else if (option.startsWith("module:")) ChicalaConfig.module = option.substring(7)
      else if (option.startsWith("simulation:")) {
        val emitFormat = option.substring("simulation:".length)
        emitFormat match {
          case "false" => ChicalaConfig.simulation = false
          case "true"  => ChicalaConfig.simulation = true
          case _: String =>
            error("simulation not understood: " + emitFormat); valid = false
        }
      } else {
        error("Option not understood: " + option); valid = false
      }
    }
    valid
  }

  override val optionsHelp: Option[String] = Some(
    "  -P:chicala:simulation:<true/false>             set Scala simulation mode\n" +
    "  -P:chicala:backend:<scala/lean>               output backend\n" +
    "  -P:chicala:out:<directory>                    Lean output directory\n" +
    "  -P:chicala:module:<qualified-name>            target module (default: all)"
  )
}
