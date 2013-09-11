# 
# Copyright (c) 2011-2012, Toji Project Contributors
# 
# Dual-licensed under the Apache License, Version 2.0, and the Microsoft Public License (Ms-PL).
# See the file LICENSE.txt for details.
# 
properties {
  Write-Output "Loading wix properties"
  
  $wix = @{}
  $wix.pub_dir = "$($release.dir)"

  $ignoreExpression = ($base.dir -replace "\\", "\\") + "\\(bin|build|release|packages|tools)\\.*"
  $wix.targets =  @((Get-ChildItem -path "$($base.dir)\*" -recurse -include *.wixproj) |  Where-Object {$_.FullName -notmatch $ignoreExpression} | Select-Object $_.FullName)
}

Task Create-WixPackage {
  if(!(Test-Path($wix.pub_dir))) { new-item $wix.pub_dir -itemType directory | Out-Null }

  $solutionDirectory = (split-path $solution.file) + "\\"
  $TargetFrameworkVersion = "$framework"
  $message = "Error executing command: {0}"
  $wix.targets | %{
    $command = "msbuild /m:$($msbuild.max_cpu_count) /p:BuildInParralel=$($msbuild.build_in_parralel) `"/logger:$($msbuild.logger);logfile=$($msbuild.logfilepath)\$($msbuild.logfilename)`" /p:Configuration=`"$($build.configuration)`" /p:TargetFrameworkVersion=`"$($TargetFrameworkVersion)`" /p:Platform=`"$($msbuild.platform)`" /p:OutDir=`"$($build.dir)`" /p:OutputPath=`"$($build.dir)`" /p:SolutionDir=`"$solutionDirectory`" /p:PublishProfile=Package /p:DeployOnBuild=true $($msbuild.commandlineparameters) `"$_`""
    $errorMessage = $message -f $command
    exec { msbuild /m:"$($msbuild.max_cpu_count)" "/p:BuildInParralel=$($msbuild.build_in_parralel)" "/logger:$($msbuild.logger);logfile=$($msbuild.logfilepath)\$($msbuild.logfilename)" /p:Configuration="$($build.configuration)" /p:TargetFrameworkVersion="$($TargetFrameworkVersion)" /p:Platform="$($msbuild.platform)" /p:OutDir="$($build.dir)" /p:OutputPath="$($build.dir)" /p:SolutionDir=`"$solutionDirectory`" /p:PublishProfile=Package /p:DeployOnBuild=true $($msbuild.commandlineparameters) "$_" } $errorMessage
  }

  Push-Location "$($wix.pub_dir)"
  try {
    $wix.targets | %{
      $projectDirectory = split-path $_
      Move-Item "$($build.dir)\*.msi" "$($wix.pub_dir)"
    }
  } finally { Pop-Location }
}