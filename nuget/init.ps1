param($installPath, $toolsPath, $package, $project)

$rootPath = (Resolve-Path "$installPath\..\..").Path
$buildPath = "$rootPath\build"

if(!(Test-Path($buildPath))) { New-Item $buildPath -ItemType Directory | Out-Null }
$buildPath = (Resolve-Path $buildPath).Path

$buildToolsPath = "$toolsPath\build"
$commandsPath = "$toolsPath\commands"

# if we don't detect nuget, copy it over and bootstrap it.
$nugetIsAvailable = (@(Get-Command nuget -ErrorAction SilentlyContinue).Length -gt 0)
if(!$nugetIsAvailable) {
  $nugets = @(Get-ChildItem "$rootPath\*" -recurse -include NuGet.exe)
  if ($nugets.Length -gt 0) { 
    $nugetIsAvailable = $true
  }
}

if(!$nugetIsAvailable) {
  Move-Item "$toolsPath\NuGet.ex_" -Destination "$buildPath\NuGet.exe"
  & "$buildPath\NuGet.exe"
  if((Test-Path "$buildPath\nuget.exe.old")) { Remove-Item "$buildPath\nuget.exe.old" -Force }
}

# copy main scripts
$files = Get-ChildItem "$buildToolsPath" -recurse -exclude settings.ps1, build.ps1, overrides.ps1 | ? { !$_.PSIsContainer } 
$files | % { $newpath=(($_.FullName).Replace($buildToolsPath,$buildPath)); Copy-Item $_.FullName $newpath -Force }

# copy the build.ps1 and settings.ps1, ignore if they already exist
if(!(Test-Path("$buildPath\settings.ps1"))) { Move-Item  "$buildToolsPath\settings.ps1" -Destination $buildPath }
if(!(Test-Path("$buildPath\build.ps1"))) { Move-Item  "$buildToolsPath\build.ps1" -Destination $buildPath }
if(!(Test-Path("$buildPath\overrides.ps1"))) { Move-Item  "$buildToolsPath\overrides.ps1" -Destination $buildPath }

# copy the solution level build scripts, ignore if they already exist
if(!(Test-Path("$rootPath\build.ps1"))) { Move-Item  "$commandsPath\build.ps1" -Destination $rootPath }
if(!(Test-Path("$rootPath\build.cmd"))) { Move-Item  "$commandsPath\build.cmd" -Destination $rootPath }

# remove everything as we have copied it over.
Uninstall-Package Toji