$ErrorActionPreference = 'Stop'
$project = Read-Host 'Project slug (lowercase letters, digits, hyphens)'
if ($project -cnotmatch '^[a-z0-9][a-z0-9-]{0,62}$') { throw 'Invalid project slug.' }
$dir = Join-Path $env:LOCALAPPDATA 'video-workflow'
New-Item -ItemType Directory -Force -Path $dir | Out-Null
Set-Content -LiteralPath (Join-Path $dir 'project.txt') -Value $project -Encoding ascii
Write-Host "Selected project: $project"
