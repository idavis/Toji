Welcome to the Toji project.
=============================

## How to get started with the example project:
**Step 1:** Clone the repository.

**Step 2:** Copy the scripts folder into the Example folder and rename the folder to build (this will keep it ignored by git). CD into the directory where you copied the scripts.

**Step 3:** Execute bootstrap.ps1 in order to download psake and any other dependencies that the project has.
> .\bootstrap.ps1

**Step 4:** Clean, compile, and test your project. You can build the project by executing 
> .\build.cmd

**Step 5:** Package the project for nuget. You can build the project by executing 
> .\build.cmd -T Package

## About the files, 
* The default.ps1 is loaded by the build.cmd and build-release.cmd files.
* default.ps1 will find psake, load any parameters you passed in, and invoke psake on the build.ps1 file (you can specify an alternate on the command line)
* build.ps1 loads all of the other build tools (nunit, xunit, msbuild, etc.). Open the settings.ps1 in order to change the default settings for the build scripts including build output, release drops, solution file, global AssemblyInfo location, etc.
* each build file included in the build.ps1 has its own settings that you can override if the defaults need to be changed.
* The nunit script will look for the nunit NuGet package by default.
* Your main edits should be to the build.ps1 to customize your tasks and their dependencies.
* The nuget script will package your project by nuspec or project file. Please edit the settings for what you need. It will also, by default, create a symbol package for you.