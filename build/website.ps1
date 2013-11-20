# 
# Copyright (c) 2011-2012, Toji Project Contributors
# 
# Dual-licensed under the Apache License, Version 2.0, and the Microsoft Public License (Ms-PL).
# See the file LICENSE.txt for details.
# 
properties {
  Write-Output "Loading website package properties"
  
  $website_package = @{}
  $website_package.pub_dir = "$($release.dir)\$framework"
}

Task Get-WebsitePackage {
  if(!(Test-Path($website_package.pub_dir))) { New-Item $website_package.pub_dir -itemType directory | Out-Null }

  Push-Location $website_package.pub_dir
  try {
        Get-ChildItem "$($build.dir)\_PublishedWebsites\" -Name -attributes D | %{
            Compress-Folder -zipfilename "$($build.dir)\_PublishedWebsites\$($_).zip" -sourcedir "$($build.dir)\_PublishedWebsites\$($_)"
        }
        
        if(!(Test-Path($website_package.pub_dir))) { New-Item $website_package.pub_dir -itemType directory | Out-Null }
        Move-Item "$($build.dir)\_PublishedWebsites\*.zip" $website_package.pub_dir
  } finally { Pop-Location }
}

