package chicala.ast

import scala.tools.nsc.Global

import chicala.util._

trait ChicalaAst extends CClassDefs with MStatements with MTypes with COps with Printer {
  private val sourcePositions = new java.util.IdentityHashMap[MStatement, global.Position]()
  def recordPosition(statement: MStatement, position: global.Position): Unit =
    sourcePositions.put(statement, position)
  def statementPosition(statement: MStatement): global.Position =
    Option(sourcePositions.get(statement)).getOrElse(global.NoPosition)
}
