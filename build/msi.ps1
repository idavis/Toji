# 
# Copyright (c) 2011-2012, Toji Project Contributors
# 
# Dual-licensed under the Apache License, Version 2.0, and the Microsoft Public License (Ms-PL).
# See the file LICENSE.txt for details.
# 
properties {
  Write-Output "Loading msi properties"
  
  $msi = @{}
  $msi.pub_dir = "$($release.dir)"
}

Task Get-MsiPackage {
  if(!(Test-Path($msi.pub_dir))) { New-Item $msi.pub_dir -itemType directory | Out-Null }

  Push-Location "$($msi.pub_dir)"
  try {
      Move-Item "$($build.dir)\*.msi" "$($msi.pub_dir)"
  } finally { Pop-Location }
}