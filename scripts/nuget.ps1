# 
# Copyright (c) 2011, Toji Project Contributors
# 
# Dual-licensed under the Apache License, Version 2.0, and the Microsoft Public License (Ms-PL).
# See the file LICENSE.txt for details.
# 

properties {
  Write-Output "Loading nuget properties"
  $nuget = @{}
  $nuget.pub_dir = "$($release.dir)"
  $nuget.file = "$($tools.dir)\NuGet\NuGet.exe"
  # add either the project_name or nuspec file to use when packaging.
  $nuget.target = "$($source.dir)\Example\Example.csproj"#"$($source.dir)\Example.nuspec"
  $nuget.project = "$($nuget.project_name).csproj"
  $nuget.options = "-Build -Sym -Properties Configuration=$($build.configuration)"
  #$nuget.options = "-Sym"
  $nuget.command = "& $($nuget.file) pack $($nuget.target) $($nuget.options) -Version $($build.version) -OutputDirectory $($nuget.pub_dir)"
  Assert (![string]::IsNullOrEmpty($nuget.file)) "The location of the nuget exe must be specified."
  Assert (Test-Path($nuget.file)) "Could not find nuget exe"
}

Task Bootstrap-NuGetPackages {
  Write-Output "Loading Nuget Dependencies"
  . { Get-ChildItem -recurse -include packages.config | % { & $nuget.file i $_ -o Packages } }
}

Task Package -Depends Test {
  $path = Split-Path $nuget.target
  Write-Host "Moving into $path"
  Push-Location $path
  Write-Host "Executing exec { & $($nuget.file) $($nuget.command) }"
  exec { Invoke-Expression $nuget.command }
  Pop-Location
}

Task Publish {
  Push-Location "$($nuget.pub_dir)"
  ls "*$($build.version).nupkg" | % { & $nuget.file push $_ }
  Pop-Location
}