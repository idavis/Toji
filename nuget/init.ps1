param($rootPath, $toolsPath, $package, $project)

$tojiPath = "build"
if(Test-Path("$rootPath\$tojiPath")) { $tojiPath = "scripts" } elseif(Test-Path("$rootPath\$tojiPath")) { $tojiPath = "toji" } 

$files = Get-ChildItem "$toolsPath\scripts" -exclude build.ps1

if(!(Test-Path($tojiPath))) { new-item $tojiPath -itemType directory | Out-Null }

$files | % { Copy-Item $_.FullName "$tojiPath\$(Split-Path $_ -leaf)" -Force }

#only copy the build.ps1 if it doesn't exist
$buildFile = Resolve-Path "$toolsPath\scripts\build.ps1"

if(!(Test-Path("$tojiPath\$(Split-Path $buildFile -leaf)"))) { Copy-Item $buildFile "$tojiPath\$(Split-Path $buildFile -leaf)" }
