#Requires -Version 2.0

# 
# Copyright (c) 2011, Toji Project Contributors
# 
# Dual-licensed under the Apache License, Version 2.0, and the Microsoft Public License (Ms-PL).
# See the file LICENSE.txt for details.
# 
  
$path = (Resolve-Path "$(Split-Path -parent $myInvocation.MyCommand.Definition)\..\").Path
Push-Location $path
try {
  Write-Output "Loading Nuget Dependencies"
  if(Test-Path ".NugetFile") {
    Write-Output "Loading chewie"
    Import-Module "$pwd\chewie.psm1"
    Write-Output "Running chewie"
    Invoke-Chewie
  } else {
    $nuGetIsInPath = (FileExistsInPath "NuGet.exe") -or (FileExistsInPath "NuGet.bat")
    $nuget = "NuGet"
    if(-not($nuGetIsInPath)) {
      $nuget = Resolve-Path ".\Tools\Nuget\NuGet.exe"
    }
    if(!(Test-Path($nuget))) {  
      $nugets = @(Get-ChildItem "..\*" -recurse -include NuGet.exe)
      if ($nugets.Length -le 0) { 
       Write-Host -ForegroundColor Red "No NuGet executables found."
       return 
      }
      $nuget = (Resolve-Path $nugets[0].FullName).Path
    }
    $output = "Packages"
    $package_files = Get-ChildItem . -recurse -include packages.config
    $package_files | % { & $nuget i $_ -OutputDirectory $output }
  }
} finally { Pop-Location }