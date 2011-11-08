# 
# Copyright (c) 2011, Toji Project Contributors
# 
# Dual-licensed under the Apache License, Version 2.0, and the Microsoft Public License (Ms-PL).
# See the file LICENSE.txt for details.
# 

$path = (Resolve-Path "..\Example")
Test-Path $path
Push-Location $path
Write-Output "Loading Nuget Dependencies"
$nuget = Resolve-Path ".\Tools\Nuget\NuGet.exe"
$output = "Packages"
$package_files = Get-ChildItem . -recurse -include packages.config
$package_files | % { & $nuget i $_ -OutputDirectory $output }
Pop-Location