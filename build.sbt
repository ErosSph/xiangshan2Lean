ThisBuild / version      := "0.2.0-SNAPSHOT"
ThisBuild / organization := "cn.ac.ios.tis"
ThisBuild / scalaVersion := "2.13.15"

lazy val writeToolClasspath = taskKey[File]("Write the compiler/plugin classpath for the CLI")
lazy val writeReferenceClasspath = taskKey[File]("Write the independent official RTL generator classpath")
lazy val writeXiangshanClasspath = taskKey[File]("Write the real XiangShan/CDE elaboration classpath")
lazy val writeFirrtlClasspath = taskKey[File]("Write the isolated classic FIRRTL reader classpath")

lazy val root = (project in file("."))
  .settings(
    name := "chicala",
    Compile / unmanagedSources ~= (_.filterNot(_.getPath.replace('\\', '/').contains("/lean/firrtl/"))),
    libraryDependencies ++= Seq(
      "org.scala-lang" % "scala-compiler" % "2.13.15",
      "org.chipsalliance" %% "chisel" % "7.3.0"
    ),
    scalacOptions ++= Seq(
      "-deprecation",
      "-feature",
      "-Xcheckinit"
    ),
    writeToolClasspath := {
      val output = baseDirectory.value / ".cache" / "tool-classpath.txt"
      val jar = (Compile / packageBin).value
      val dependencies = (Compile / dependencyClasspath).value.files
      val digest = java.security.MessageDigest.getInstance("SHA-256").digest(java.nio.file.Files.readAllBytes(jar.toPath))
        .map(b => f"${b & 0xff}%02x").mkString
      val snapshot = baseDirectory.value / ".cache" / "compiler" / digest / "chicala.jar"
      if (!snapshot.exists) { IO.createDirectory(snapshot.getParentFile); IO.copyFile(jar, snapshot) }
      val temporary = output.getParentFile / "tool-classpath.tmp"
      IO.write(temporary, (snapshot +: dependencies).map(_.getAbsolutePath).mkString(java.io.File.pathSeparator))
      java.nio.file.Files.move(temporary.toPath, output.toPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING,
        java.nio.file.StandardCopyOption.ATOMIC_MOVE)
      output
    }
  )

// Keep the existing classic .fir reader in a separate JVM/classpath. Chisel 7's
// serialization-only firrtl package must never be mixed with Scala FIRRTL 1.x.
lazy val classicFirrtl = (project in file(".cache/classic-firrtl-build"))
  .settings(
    libraryDependencies += "edu.berkeley.cs" %% "firrtl" % "1.5.6",
    Compile / unmanagedSourceDirectories := Nil,
    Compile / unmanagedSources := {
      val source = file("src/main/scala/chicala/lean").getAbsoluteFile
      ((source / "firrtl") ** "*.scala").get ++ ((source / "ir") ** "*.scala").get ++ ((source / "backend") ** "*.scala").get
    },
    writeFirrtlClasspath := {
      val output = file(".cache/firrtl-classpath.txt")
      val jar = (Compile / packageBin).value
      val digest = java.security.MessageDigest.getInstance("SHA-256").digest(java.nio.file.Files.readAllBytes(jar.toPath))
        .map(b => f"${b & 0xff}%02x").mkString
      val snapshot = file(".cache/firrtl-compiler") / digest / "classic-firrtl.jar"
      if (!snapshot.exists) { IO.createDirectory(snapshot.getParentFile); IO.copyFile(jar, snapshot) }
      val paths = snapshot +: (Compile / dependencyClasspath).value.files
      IO.write(output, paths.map(_.getAbsolutePath).mkString(java.io.File.pathSeparator))
      output
    }
  )

val chiselVersion     = "7.3.0"
val chiselTestVersion = "6.0.0"
lazy val testcase = (project in file("testcase"))
  .settings(
    name := "testcase",
    resolvers += Resolver.mavenLocal,
    libraryDependencies ++= Seq(
      "org.chipsalliance" %% "chisel"    % chiselVersion,
      "edu.berkeley.cs" %% "chiseltest" % chiselTestVersion % "test"
    ),
    scalacOptions ++= Seq(
      "-language:reflectiveCalls",
      "-deprecation",
      "-feature",
      "-Xcheckinit"
    ),
    addCompilerPlugin("cn.ac.ios.tis" %% "chicala" % "0.2.0-SNAPSHOT")
  )

lazy val audit = (project in file("audit"))
  .settings(
    libraryDependencies += "org.chipsalliance" %% "chisel" % chiselVersion,
    scalacOptions ++= Seq("-language:reflectiveCalls", "-deprecation", "-feature"),
    addCompilerPlugin("cn.ac.ios.tis" %% "chicala" % "0.2.0-SNAPSHOT")
  )

lazy val reference = (project in file("reference"))
  .dependsOn(cdeRuntime)
  .settings(
    libraryDependencies += "org.chipsalliance" %% "chisel" % chiselVersion,
    addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full),
    scalacOptions ++= Seq("-language:reflectiveCalls", "-deprecation", "-feature"),
    Compile / unmanagedSourceDirectories += (LocalRootProject / baseDirectory).value / "audit" / "src" / "main" / "scala",
    Compile / unmanagedSourceDirectories += file("tests/fixtures/configuration").getAbsoluteFile,
    writeReferenceClasspath := {
      val output = (LocalRootProject / baseDirectory).value / ".cache" / "reference-classpath.txt"
      val paths = (Compile / fullClasspath).value.files
      IO.write(output, paths.map(_.getAbsolutePath).mkString(java.io.File.pathSeparator))
      output
    }
  )

// Full unchanged Nanhu framework with real CDE, sharing the pinned toolchain.
// Sources are fetched at immutable commits by fetch_xiangshan_dependencies.py.
def xsSources(name: String, suffix: String = "src/main/scala") =
  file(".cache/xiangshan-dependencies-7.3").getAbsoluteFile / name / suffix
val xsSettings = Seq(
  libraryDependencies += "org.chipsalliance" %% "chisel" % chiselVersion,
  addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full),
  scalacOptions ++= Seq("-language:reflectiveCalls", "-Ymacro-annotations")
)
lazy val cdeRuntime = (project in file(".cache/xiangshan-build-7.3/cde"))
  .settings(Compile / unmanagedSourceDirectories := Seq(file("vendor/cde/src").getAbsoluteFile))
lazy val xsMacros = (project in file(".cache/xiangshan-build-7.3/macros"))
  .settings(
    libraryDependencies += "org.scala-lang" % "scala-reflect" % "2.13.15",
    Compile / unmanagedSourceDirectories := Seq(xsSources("rocket", "macros/src/main/scala"))
  )
lazy val xsHardfloat = (project in file(".cache/xiangshan-build-7.3/hardfloat"))
  .settings(xsSettings)
  .settings(Compile / unmanagedSourceDirectories := Seq(xsSources("hardfloat", "hardfloat/src/main/scala")))
lazy val xsRocket = (project in file(".cache/xiangshan-build-7.3/rocket"))
  .dependsOn(cdeRuntime, xsMacros, xsHardfloat)
  .settings(xsSettings)
  .settings(
    libraryDependencies ++= Seq("com.lihaoyi" %% "mainargs" % "0.7.7", "org.json4s" %% "json4s-jackson" % "4.0.7"),
    Compile / unmanagedSourceDirectories := Seq(xsSources("rocket"))
  )
lazy val xsUtility = (project in file(".cache/xiangshan-build-7.3/utility"))
  .dependsOn(xsRocket)
  .settings(xsSettings)
  .settings(
    libraryDependencies += "com.lihaoyi" %% "sourcecode" % "0.4.4",
    Compile / unmanagedSourceDirectories := Seq(xsSources("utility"))
  )
lazy val xsHuancun = (project in file(".cache/xiangshan-build-7.3/huancun"))
  .dependsOn(xsRocket, xsUtility)
  .settings(xsSettings)
  .settings(Compile / unmanagedSourceDirectories := Seq(xsSources("huancun")))
lazy val xsDifftest = (project in file(".cache/xiangshan-build-7.3/difftest"))
  .settings(xsSettings)
  .settings(
    libraryDependencies += "org.json4s" %% "json4s-native" % "4.0.7",
    Compile / unmanagedSourceDirectories := Seq(xsSources("difftest"))
  )
lazy val xsFudian = (project in file(".cache/xiangshan-build-7.3/fudian"))
  .settings(xsSettings)
  .settings(Compile / unmanagedSourceDirectories := Seq(xsSources("fudian")))
lazy val xiangshanFramework = (project in file(".cache/xiangshan-build-7.3/xiangshan"))
  .dependsOn(xsRocket, xsUtility, xsHuancun, xsDifftest, xsFudian)
  .settings(xsSettings)
  .settings(
    libraryDependencies ++= Seq("org.scalatest" %% "scalatest" % "3.2.19",
      "io.circe" %% "circe-yaml" % "0.16.1", "io.circe" %% "circe-generic-extras" % "0.14.4"),
    Compile / unmanagedSourceDirectories := Seq(xsSources("xiangshan"), file("verification/xiangshan/config/reference")),
    Compile / unmanagedSources ++= Seq(file("reference/src/main/scala/GenerateRTL.scala").getAbsoluteFile,
      file("reference/src/main/scala/ConfiguredModule.scala").getAbsoluteFile),
    writeXiangshanClasspath := {
      val output = file(".cache/xiangshan-classpath.txt")
      IO.write(output, (Compile / fullClasspath).value.files.map(_.getAbsolutePath).mkString(java.io.File.pathSeparator))
      output
    }
  )
