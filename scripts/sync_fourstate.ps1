param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet('Preview','Pack','Push','Verify','Status','Export','Pull')]
    [string]$Action,
    [ValidateSet('f3.1','f4.6','f4.7','f4.7a','f5.1','f5.1a')][string]$Profile = 'f3.1',
    [string]$SnapshotId,
    [string]$RunId,
    [string]$ExportId,
    [string]$Selection
)
$ErrorActionPreference = 'Stop'
$syncScript = Join-Path $PSScriptRoot 'fourstate_sync.py'
$syncArgs = @('-B', $syncScript, $Action.ToLowerInvariant(), '--profile', $Profile)
if ($SnapshotId) { $syncArgs += @('--snapshot-id', $SnapshotId) }
if ($RunId) { $syncArgs += @('--run-id', $RunId) }
if ($ExportId) { $syncArgs += @('--export-id', $ExportId) }
if ($Selection) { $syncArgs += @('--selection', $Selection) }
& python.exe @syncArgs
exit $LASTEXITCODE
