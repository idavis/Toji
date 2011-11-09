param($rootPath, $toolsPath, $package, $project)

$tojiPath = "build"

$files = Get-ChildItem "$toolsPath\scripts\*" -exclude settings.ps1, build.ps1

if(!(Test-Path($tojiPath))) { new-item $tojiPath -itemType directory | Out-Null }

$files | % { Copy-Item $_.FullName "$tojiPath\$(Split-Path $_ -leaf)" -Force }

#only copy the build.ps1 and settings.ps1 if they don't exist

$files = Get-ChildItem "$toolsPath\scripts\*" -include settings.ps1, build.ps1

$files | ? { (!(Test-Path("$tojiPath\$(Split-Path $_ -leaf)"))) } | % { Copy-Item $_.FullName "$tojiPath\$(Split-Path $_ -leaf)" }
