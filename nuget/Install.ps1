param($installPath, $toolsPath, $package, $project)

$rootPath = Resolve-Path "$installPath\..\.."
$buildPath = "$rootPath\build"
$contentPath = Resolve-Path "$toolsPath\..\content"

if(!(Test-Path($buildPath))) { New-Item $buildPath -ItemType Directory | Out-Null }

$buildPath = Resolve-Path "$buildPath"

# copy main scripts
$files = Get-ChildItem "$contentPath\build\*" -exclude settings.ps1, build.ps1

$files | % { Move-Item $_.FullName "$buildPath\$(Split-Path $_ -leaf)" -Force }

# copy the build.ps1 and settings.ps1, ignore if they already exist

$files = Get-ChildItem "$contentPath\build\*" -include settings.ps1, build.ps1

$files | ? { (!(Test-Path("$buildPath\$(Split-Path $_ -leaf)"))) } | % { Move-Item $_.FullName "$buildPath\$(Split-Path $_ -leaf)" }

# copy the solution level build scripts, ignore if they already exist

$files = Get-ChildItem "$contentPath\commands\*"

$files | ? { (!(Test-Path("$rootPath\$(Split-Path $_ -leaf)"))) } | % { Move-Item $_.FullName "$rootPath\$(Split-Path $_ -leaf)" }
