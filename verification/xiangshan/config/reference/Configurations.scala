package xiangshan.validation

import org.chipsalliance.cde.config.Config
import xiangshan.{XSCoreParamsKey, XSTileKey}

/** Actual Nanhu MinimalConfig and its complete original XSCoreParameters record.
  * Selecting a core into XSCoreParamsKey is how leaf XSModule consumers receive p.
  */
class NanhuCoreConfig extends Config(new top.MinimalConfig(1).alter((site, here, up) => {
  case XSCoreParamsKey => up(XSTileKey).head
}))

/** Local module parameter variations, using real CDE alter/up and record copy. */
class NanhuWidthConfig(width: Int, compressed: Boolean) extends Config(new NanhuCoreConfig().alter((site, here, up) => {
  case XSCoreParamsKey => up(XSCoreParamsKey).copy(XLEN = width, HasCExtension = compressed)
}))
