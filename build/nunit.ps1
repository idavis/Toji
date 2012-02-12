# 
# Copyright (c) 2011-2012, Toji Project Contributors
# 
# Dual-licensed under the Apache License, Version 2.0, and the Microsoft Public License (Ms-PL).
# See the file LICENSE.txt for details.
# 

properties {
  Write-Output "Loading nunit properties"
  $nunit = @{}
  $nunit.runner = (Get-ChildItem "$($packages.dir)\*" -recurse -include nunit-console-x86.exe).FullName
}

Task Invoke-TestRunner -PreCondition { return (Test-Path($xunit.runner)) -and (![string]::IsNullOrEmpty($xunit.runner)) } {
  param(
    [Parameter(Position=0,Mandatory=0)]
    [string[]]$dlls = @()
  )
  if ($dlls.Length -le 0) { 
     Write-Host -ForegroundColor Red "No tests defined"
     return 
  }
  exec { & $nunit.runner $dlls /noshadow }
}