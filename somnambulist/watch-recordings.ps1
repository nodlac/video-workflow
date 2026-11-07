param([string]$ObsDir="$env:USERPROFILE\Videos\OBS")
$ErrorActionPreference='Stop'
$dir=Join-Path $env:LOCALAPPDATA 'video-workflow'
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$ledger=Join-Path $dir 'uploaded.txt'
if (!(Test-Path $ledger)) { New-Item -ItemType File -Path $ledger | Out-Null }
$seen=@{}; Get-Content $ledger | ForEach-Object { $seen[$_]=$true }
$pending=@{}
while ($true) {
 foreach ($f in (Get-ChildItem $ObsDir -File | Where-Object {$_.Extension -in '.mkv','.mp4','.mov'})) {
  $key="$($f.FullName)|$($f.Length)|$($f.LastWriteTimeUtc.Ticks)"
  if ($seen.ContainsKey($key)) { continue }
  $prev=$pending[$f.FullName]
  $count=if ($prev -and $prev.Key -eq $key) {$prev.Count+1} else {1}
  $pending[$f.FullName]=@{Key=$key;Count=$count}
  if ($count -lt 3) { continue }
  try {$h=[IO.File]::Open($f.FullName,'Open','Read','None');$h.Dispose()} catch {continue}
  try {
   & (Join-Path $PSScriptRoot 'upload.ps1') -File $f.FullName
   Add-Content -LiteralPath $ledger -Value $key
   $seen[$key]=$true
  } catch {Write-Warning "Upload failed: $_"}
 }
 Start-Sleep -Seconds 6
}
