package aggregate

import chisel3._

class PacketMeta(w: Int) extends Bundle {
  val flag = Bool()
  val code = UInt((w + 1).W)
}

class Packet(w: Int, m: Int) extends Bundle {
  val data = UInt(w.W)
  val signed = SInt((w + 1).W)
  val valid = Bool()
  val meta = new PacketMeta(w)
  val lanes = Vec(m, UInt(w.W))
}

class BundleVectorPipeline(n: Int, w: Int, m: Int) extends Module {
  require(n > 0 && m > 0 && w > 0)
  val data = IO(Input(Vec(n, new Packet(w, m))))
  val enable = IO(Input(Bool()))
  val choose = IO(Input(Bool()))
  val index = IO(Input(UInt(8.W)))
  val out = IO(Output(Vec(n, new Packet(w, m))))
  val selected = IO(Output(new Packet(w, m)))
  val mixed = IO(Output(Vec(n, new Packet(w, m))))
  val saved = RegInit(data)
  when(enable) { saved := data }
  out := saved
  selected := saved(index)
  mixed := Mux(choose, data, saved)
}

class BundleVectorWrites(n: Int, w: Int, m: Int) extends Module {
  require(n > 0 && m > 0 && w > 0)
  val data = IO(Input(Vec(n, new Packet(w, m))))
  val patch = IO(Input(new Packet(w, m)))
  val write = IO(Input(Bool()))
  val overrideData = IO(Input(Bool()))
  val updateLanes = IO(Input(Bool()))
  val index = IO(Input(UInt(8.W)))
  val other = IO(Input(UInt(8.W)))
  val lane = IO(Input(UInt(8.W)))
  val otherLane = IO(Input(UInt(8.W)))
  val out = IO(Output(Vec(n, new Packet(w, m))))
  val saved = RegInit(data)
  when(write) { saved(index) := patch }
  when(overrideData) {
    saved(index).data := saved(index).data + 1.U
    saved(other).meta.code := patch.meta.code
  }
  when(updateLanes) {
    saved(index).lanes(lane) := patch.lanes(lane)
    saved(other).lanes(otherLane) := data(other).lanes(otherLane)
  }
  out := saved
}

class BundleVectorConstruct(n: Int, w: Int, m: Int) extends Module {
  require(n > 0 && m > 0 && w > 0)
  val data = IO(Input(Vec(n, new Packet(w, m))))
  val packet = IO(Input(new Packet(w, m)))
  val repeated = IO(Output(Vec(n, new Packet(w, m))))
  val tabulated = IO(Output(Vec(n, new Packet(w, m))))
  val literal = IO(Output(Vec(2, new Packet(w, m))))
  val generated = IO(Output(Vec(n, new Packet(w, m))))
  val filled = VecInit(Seq.fill(n)(packet))
  val copied = VecInit(Seq.tabulate(n)(i => data(i)))
  val pair = VecInit(Seq(data(0), packet))
  repeated := filled
  tabulated := copied
  literal := pair
  for (i <- 0 until n) {
    val item = data(i)
    generated(i) := item
    generated(i).valid := !item.valid
  }
}

class BundleVectorResize(n: Int, wi: Int, wo: Int) extends Module {
  require(n > 0 && wi > 0 && wo > 0)
  val data = IO(Input(Vec(n, new Packet(wi, 2))))
  val out = IO(Output(Vec(n, new Packet(wo, 2))))
  out := data
}

class BundleVectorMux(n: Int, wi: Int, wo: Int) extends Module {
  require(n > 0 && wi > 0 && wo > 0)
  val a = IO(Input(Vec(n, new Packet(wi, 2))))
  val b = IO(Input(Vec(n, new Packet(wi, 2))))
  val choose = IO(Input(Bool()))
  val out = IO(Output(Vec(n, new Packet(wo, 2))))
  val pair = IO(Output(Vec(2, new Packet(wo, 2))))
  val mixed = Mux(choose, a, b)
  val elements = VecInit(Seq(a(0), b(0)))
  out := mixed
  pair := elements
}

class NestedBundleVector(n: Int, m: Int, w: Int) extends Module {
  require(n > 0 && m > 0 && w > 0)
  val data = IO(Input(Vec(n, Vec(m, new Packet(w, 2)))))
  val patch = IO(Input(new Packet(w, 2)))
  val write = IO(Input(Bool()))
  val index = IO(Input(UInt(8.W)))
  val lane = IO(Input(UInt(8.W)))
  val out = IO(Output(Vec(n, Vec(m, new Packet(w, 2)))))
  val selected = IO(Output(new Packet(w, 2)))
  val saved = RegInit(data)
  when(write) {
    saved(index)(lane) := patch
    saved(0)(0).meta.flag := !saved(0)(0).meta.flag
    saved(index)(lane).lanes(1) := saved(index)(lane).lanes(0)
  }
  out := saved
  selected := saved(index)(lane)
}

class BundleVectorHierarchy(n: Int, w: Int, m: Int) extends Module {
  val data = IO(Input(Vec(n, new Packet(w, m))))
  val out = IO(Output(Vec(n, new Packet(w, m))))
  val child = Module(new BundleVectorPipeline(n, w, m))
  child.data := data
  child.enable := true.B
  child.choose := false.B
  child.index := 0.U
  out := child.out
}
