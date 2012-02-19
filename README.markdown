Welcome to the Toji project.
=============================

## How to get started with the example project:
**Step 1:** Install the nuget package: 
```
install-package toji
or
nuget install toji
```

**Step 2:** Open the PowerShell command prompt and cd into your project folder. Type 
```
.\build.ps1
```

**Step CI:** If running a CI build, you will want to make sure that you either edit the settings.ps1 or the overrides.ps1. The conventions used to figure out solution file names, nuspec file names, etc do not work when the folder names are randomly chosen.

## About the files, 
* The default.ps1 is loaded by the build.cmd and build-release.cmd files.
* default.ps1 will find psake, load any parameters you passed in, and invoke psake on the build.ps1 file (you can specify an alternate on the command line)
* build.ps1 loads all of the other build tools (nunit, xunit, msbuild, etc.). Open the settings.ps1 in order to change the default settings for the build scripts including build output, release drops, solution file, global AssemblyInfo location, etc.
* each build file included in the build.ps1 has its own settings that you can override if the defaults need to be changed.
* The nunit script will look for the nunit NuGet package by default.
* Your main edits should be to the .\build\build.ps1 to customize your tasks and their dependencies.
* The nuget script will package your project by nuspec or project file. Please edit the settings for what you need. It will also, by default, create a symbol package for you.