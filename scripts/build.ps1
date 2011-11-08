﻿# 
# Copyright (c) 2011, Toji Project Contributors
# 
# Dual-licensed under the Apache License, Version 2.0, and the Microsoft Public License (Ms-PL).
# See the file LICENSE.txt for details.
# 

Include settings.ps1
#Include xunit.ps1
#Include nunit.ps1
#Include nuget.ps1
#Include msbuild.ps1

properties {
  Write-Output "Loading build properties"
  # Do not put any code in here. This method is invoked before all others
  # and will not have access to any of your shared properties.
}

Task Default -depends Init, Compile, Test
Task Release -depends Default, Package

Task Test { 
  $test_dlls = gci "$($build.dir)\*.Tests.dll"
  Invoke-TestRunner $test_dlls
}

Task IntegrationTest -depends Test { 
  $test_dlls = gci "$($build.dir)\*.IntegrationTests.dll"
  Invoke-TestRunner $test_dlls
}

Task Init -depends Clean {
  #Bootstrap-NuGet
  new-item $release.dir -itemType directory | Out-Null
  new-item $build.dir -itemType directory | Out-Null
}

Task Compile -depends Version, Init, Invoke-MsBuild

Task Clean { 
  remove-item -force -recurse $build.dir -ErrorAction SilentlyContinue | Out-Null
  remove-item -force -recurse $release.dir -ErrorAction SilentlyContinue | Out-Null
}

Task Version {
  #$version_pattern = "\d*\.\d*\.\d*\.\d*"  # 4 digit
  $version_pattern = "\d*\.\d*\.\d*"   # 3 digit for semver
  $content = Get-Content $solution.assembly_info | % { [Regex]::Replace($_, $version_pattern, $build.version) } 
  Set-Content -Value $content -Path $solution.assembly_info
}

Task ? -Description "Helper to display task info" {
  Write-Documentation
}