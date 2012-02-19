param($installPath, $toolsPath, $package, $project)

$rootPath = (Resolve-Path "$installPath\..\..").Path
$buildPath = "$rootPath\build"
if(!(Test-Path($buildPath))) { New-Item $buildPath -ItemType Directory | Out-Null }
$buildPath = (Resolve-Path $buildPath).Path

$buildToolsPath = "$toolsPath\build"
$folders = Get-ChildItem $buildToolsPath -recurse -force | ?{ $_.PSIsContainer } 
$folders | % { $newpath=(($_.FullName).Replace($buildToolsPath,$buildPath)); if(!(test-path $newpath)){ New-Item -ItemType Directory -Path "$newpath" -Force } }

# copy main scripts
$files = Get-ChildItem "$buildToolsPath" -recurse -exclude settings.ps1, build.ps1, overrides.ps1 | ? { !$_.PSIsContainer } 

$files | % { $newpath=(($_.FullName).Replace($buildToolsPath,$buildPath)); Copy-Item $_.FullName $newpath -Force }

# copy the build.ps1 and settings.ps1, ignore if they already exist

if(!(Test-Path("$buildToolsPath\settings.ps1"))) { Move-Item  "$buildToolsPath\settings.ps1" -Destination $buildPath }
if(!(Test-Path("$buildToolsPath\build.ps1"))) { Move-Item  "$buildToolsPath\build.ps1" -Destination $buildPath }
if(!(Test-Path("$buildToolsPath\overrides.ps1"))) { Move-Item  "$buildToolsPath\overrides.ps1" -Destination $buildPath }

# if we don't detect nuget, copy it over and bootstrap it.

$nugetIsOnPath = (@(Get-Command NuGet).Length -gt 0)
if(!$nugetIsOnPath -and !(Test-Path("$buildPath\NuGet.exe"))) {
  Move-Item "$toolsPath\NuGet.exe" -Destination $buildPath
  & "$buildPath\NuGet.exe"
  if(!(Test-Path "$buildPath\nuget.exe.old")) { Remove-Item "$buildPath\nuget.exe.old" -Force }
}

# copy the solution level build scripts, ignore if they already exist

if(!(Test-Path("$rootPath\build.ps1"))) { Move-Item  "$rootPath\build.ps1" -Destination $rootPath }
if(!(Test-Path("$rootPath\build.cmd"))) { Move-Item  "$rootPath\build.cmd" -Destination $rootPath }

# remove everything as we have copied it over.

Remove-Item $installPath -Recurse -Force
