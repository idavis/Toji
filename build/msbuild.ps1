# 
# Copyright (c) 2011-2012, Toji Project Contributors
# 
# Dual-licensed under the Apache License, Version 2.0, and the Microsoft Public License (Ms-PL).
# See the file LICENSE.txt for details.
# 

properties {
  Write-Output "Loading msbuild properties"
  $msbuild = @{}
  $msbuild.logfilename = $build.dir
  $msbuild.logfilepath = "MSBuildOutput.txt"
  $msbuild.max_cpu_count = [System.Environment]::ProcessorCount
  $msbuild.build_in_parralel = $true
  $msbuild.logger = "FileLogger,Microsoft.Build.Engine"
  $msbuild.platform = "Any CPU"
}

Task Invoke-MsBuild {
  exec { msbuild /m:"$($msbuild.max_cpu_count)" /p:BuildInParralel=$msbuild.build_in_parralel "/logger:$($msbuild.logger);logfile=$($msbuild.logfilepath)\$($msbuild.logfilename)" /p:Configuration="$($build.configuration)" /p:Platform="$($msbuild.platform)" /p:OutDir="$($build.dir)"\\ "$($solution.file)" }
}