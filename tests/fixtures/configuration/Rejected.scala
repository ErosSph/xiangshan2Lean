package rejectedconfiguration
import chisel3._
import org.chipsalliance.cde.config.{Field, Parameters}
import configuration._

class DynamicKey(key: Field[Core])(implicit val p: Parameters) extends Module {
  val y = IO(Output(UInt(p(key).width.W)))
  y := 0.U
}

class CollectionField(implicit val p: Parameters) extends Module {
  val y = IO(Output(UInt(p(CoreKey).unused.head.W)))
  y := 0.U
}

trait EagerConfig extends ConfigParams { val eager = width }
class EagerInherited(implicit val p: Parameters) extends Module with EagerConfig {
  val y = IO(Output(UInt(eager.W)))
  y := 0.U
}

class ForwardValue(implicit val p: Parameters) extends Module {
  val first = later
  val later = p(CoreKey).width
  val y = IO(Output(UInt(first.W)))
  y := 0.U
}

trait SuperWidth extends ConfigParams { override def laneWidth = super.laneWidth + 1 }
class ExplicitSuper(implicit val p: Parameters) extends Module with SuperWidth {
  val y = IO(Output(UInt(laneWidth.W)))
  y := 0.U
}

trait RecursiveWidth extends ConfigParams { override def laneWidth: Int = laneWidth + 1 }
class RecursiveGetter(implicit val p: Parameters) extends Module with RecursiveWidth {
  val y = IO(Output(UInt(laneWidth.W)))
  y := 0.U
}

class OverloadedGetter(implicit val p: Parameters) extends Module {
  def width: Int = p(CoreKey).width
  def width(value: Int): Int = value
  val y = IO(Output(UInt(width.W)))
  y := 0.U
}

class OverrideVal(override val width: Int) extends WidthBase(width + 1)
