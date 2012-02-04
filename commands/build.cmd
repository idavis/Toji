@echo off

powershell -NonInteractive -NoProfile -ExecutionPolicy unrestricted -Command "& { Push-Location .\build; try{ .\default.ps1 %* } finally { Pop-Location } }"