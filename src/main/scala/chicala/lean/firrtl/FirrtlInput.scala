package chicala.lean.firrtl

import java.nio.charset.StandardCharsets
import java.nio.file.{Files, Path}
import org.antlr.v4.runtime._
import firrtl.{Parser, ir}
import firrtl.antlr.FIRRTLLexer
import chicala.lean.ir.{Source, TranslationError}

object FirrtlInput {
  def parse(path: Path): ir.Circuit = {
    val text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8).replace("\r\n", "\n")
    // The official parser reports parser errors but its lexer otherwise recovers
    // from unrecognized characters. Reject those rather than silently dropping them.
    val lexer = new FIRRTLLexer(CharStreams.fromString(text))
    lexer.removeErrorListeners()
    lexer.addErrorListener(new BaseErrorListener {
      override def syntaxError(recognizer: Recognizer[_, _], symbol: Any, line: Int,
                               column: Int, message: String, error: RecognitionException): Unit =
        throw TranslationError(Source(path.toString, line, column + 1), "FIRRTL lexical error: " + message)
    })
    lexer.getAllTokens()
    Parser.parse(text, Parser.AppendInfo(path.toString))
  }
}
