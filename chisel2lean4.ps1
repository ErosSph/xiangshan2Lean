param([Parameter(ValueFromRemainingArguments=$true)][string[]]$CliArgs)
$ErrorActionPreference = 'Stop'
& python (Join-Path $PSScriptRoot 'scripts\chisel2lean.py') @CliArgs
exit $LASTEXITCODE
