# 
# Copyright (c) 2011-2012, Toji Project Contributors
# 
# Dual-licensed under the Apache License, Version 2.0, and the Microsoft Public License (Ms-PL).
# See the file LICENSE.txt for details.
# 

# This file is where you can override any settings specified in the other scripts.

properties {
  Write-Output "Loading override settings"
  $build.version = if($env:BUILD_NUMBER) {$env:BUILD_NUMBER} else { "1.0.4" }
}