param([Parameter(Mandatory=$true)][string]$File,[string]$HostAlias='callisto-video')
$ErrorActionPreference='Stop'
$f=Get-Item -LiteralPath (Resolve-Path -LiteralPath $File).Path
if ($f.Name -cnotmatch '^[A-Za-z0-9_. -]+$') {throw 'Unsafe filename'}
if ($f.Extension.ToLowerInvariant() -notin @('.mkv','.mp4','.mov')) {throw 'Invalid extension'}
$project=(Get-Content -Raw (Join-Path $env:LOCALAPPDATA 'video-workflow/project.txt')).Trim()
if ($project -cnotmatch '^[a-z0-9][a-z0-9-]{0,62}$') {throw 'Invalid project'}
$day=$f.LastWriteTime.ToString('yyyy-MM-dd')
$dir="/srv/video/incoming/$project/$day"
$name=$f.Name
$remote="$dir/$name"
# Quote remote paths using shell single quotes; filename is restricted above.
function Q([string]$s) {return "'" + $s.Replace("'","'\''") + "'"}
& ssh -o BatchMode=yes $HostAlias "mkdir -p $(Q $dir) && test ! -e $(Q $remote) && test ! -e $(Q "$remote.part")"
if ($LASTEXITCODE -ne 0) {throw 'Remote destination exists or cannot be created'}
$batch=Join-Path $env:TEMP ("upload-"+[guid]::NewGuid().ToString('N')+'.txt')
try {
 $local=$f.FullName.Replace('\','/').Replace('"','\"')
 $dest="$remote.part"
 Set-Content -LiteralPath $batch -Encoding ascii -Value "put `"$local`" `"$dest`""
 & sftp -o BatchMode=yes -b $batch $HostAlias
 if ($LASTEXITCODE -ne 0) {throw 'Transfer failed'}
 $hash=(Get-FileHash $f.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
 $cmd="test `"\$(sha256sum $(Q $dest) | cut -d ' ' -f1)`" = $(Q $hash) && test ! -e $(Q $remote) && mv -n $(Q $dest) $(Q $remote) && test -f $(Q $remote)"
 & ssh -o BatchMode=yes $HostAlias $cmd
 if ($LASTEXITCODE -ne 0) {throw 'Remote checksum or publish failed'}
 Write-Host "Verified: $($f.Name)"
} finally {Remove-Item $batch -ErrorAction SilentlyContinue}
