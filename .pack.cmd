@echo off
call .version>nul

set DOT_BASE_NAME=Janda.Dot.GitVersion

set PACKAGE=%DOT_BASE_NAME%.%DOT_GIT_VERSION%.nupkg
if "%OUTPUT_DIR%" equ "" set OUTPUT_DIR=bin




echo Packing %PACKAGE%...
nuget pack .nuspec -OutputDirectory %OUTPUT_DIR% -NoDefaultExcludes -Properties "NoWarn=NU5105;Version=%DOT_GIT_VERSION%"
echo Adding %PACKAGE%...

set NUGET_SOURCE=%USERPROFILE%\.nuget\local
set PACKAGE_FOLDER="%NUGET_SOURCE%\%DOT_BASE_NAME%\%DOT_GIT_VERSION%"
if exist %PACKAGE_FOLDER% call :remove_nuget_package
nuget add bin\%PACKAGE% -source %USERPROFILE%\.nuget\local
goto :eof




:remove_nuget_package

echo WARNING: Removing %PACKAGE_FOLDER%...
rd /s /q %PACKAGE_FOLDER%

set NUGET_SOURCE=%USERPROFILE%\.nuget\packages
set PACKAGE_FOLDER="%NUGET_SOURCE%\%DOT_BASE_NAME%\%DOT_GIT_VERSION%"

if exist %PACKAGE_FOLDER% echo WARNING: Removing %PACKAGE_FOLDER%...&rd /s /q %PACKAGE_FOLDER%

goto :eof

