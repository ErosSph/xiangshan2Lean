ThisBuild / version      := "0.2.0-SNAPSHOT"
ThisBuild / organization := "cn.ac.ios.tis"
ThisBuild / scalaVersion := "2.13.10"

lazy val writeToolClasspath = taskKey[File]("Write the compiler/plugin classpath for the CLI")
lazy val writeReferenceClasspath = taskKey[File]("Write the independent official RTL generator classpath")

lazy val root = (project in file("."))
  .settings(
    name := "chicala",
    libraryDependencies ++= Seq(
      "org.scala-lang" % "scala-compiler" % "2.13.10",
      "edu.berkeley.cs" %% "chisel3" % "3.5.6"
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

val chiselVersion     = "3.5.6"
val chiselTestVersion = "0.5.6"
lazy val testcase = (project in file("testcase"))
  .settings(
    name := "testcase",
    resolvers += Resolver.mavenLocal,
    libraryDependencies ++= Seq(
      "edu.berkeley.cs" %% "chisel3"    % chiselVersion,
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
    libraryDependencies += "edu.berkeley.cs" %% "chisel3" % chiselVersion,
    scalacOptions ++= Seq("-language:reflectiveCalls", "-deprecation", "-feature"),
    addCompilerPlugin("cn.ac.ios.tis" %% "chicala" % "0.2.0-SNAPSHOT")
  )

lazy val reference = (project in file("reference"))
  .settings(
    libraryDependencies += "edu.berkeley.cs" %% "chisel3" % chiselVersion,
    addCompilerPlugin("edu.berkeley.cs" % "chisel3-plugin" % chiselVersion cross CrossVersion.full),
    scalacOptions ++= Seq("-language:reflectiveCalls", "-deprecation", "-feature"),
    Compile / unmanagedSourceDirectories += (LocalRootProject / baseDirectory).value / "audit" / "src" / "main" / "scala",
    writeReferenceClasspath := {
      val output = (LocalRootProject / baseDirectory).value / ".cache" / "reference-classpath.txt"
      val paths = (Compile / fullClasspath).value.files
      IO.write(output, paths.map(_.getAbsolutePath).mkString(java.io.File.pathSeparator))
      output
    }
  )
