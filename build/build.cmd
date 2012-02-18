@echo off
powershell -NoProfile -ExecutionPolicy unrestricted -Command "& { "%~dp0default.ps1" %* }"
