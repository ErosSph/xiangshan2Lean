/***************************************************************************************
* Copyright (c) 2020-2021 Institute of Computing Technology, Chinese Academy of Sciences
* Copyright (c) 2020-2021 Peng Cheng Laboratory
*
* XiangShan is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

// Standalone configuration adapter; the original hardware body is unchanged.
package xiangshan.backend.fu

import chisel3._
import chisel3.util._

class RightShiftModule(val XLEN: Int) extends Module {
  val io = IO(new Bundle() {
    val shamt = Input(UInt(6.W))
    val revShamt = Input(UInt(6.W))
    val srlSrc, sraSrc = Input(UInt(XLEN.W))
    val srl, sra = Output(UInt(XLEN.W))
    val revSrl = Output(UInt(XLEN.W))
  })
  io.srl  := io.srlSrc >> io.shamt
  io.sra  := (io.sraSrc.asSInt >> io.shamt).asUInt
  io.revSrl  := io.srlSrc >> io.revShamt
}
