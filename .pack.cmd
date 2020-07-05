@echo off
call .version
rem set DOT_GIT_VERSION=0.1.0
set DOT_BASE_NAME=Janda.Dot.GitVersion


set PACKAGE=%DOT_BASE_NAME%.%DOT_GIT_VERSION%.nupkg
if "%OUTPUT_DIR%" equ "" set OUTPUT_DIR=bin


set NUSPEC_FILE=.nuspec
set NUSPEC_PACKAGE_VERSION=%DOT_GIT_VERSION%
set NUSPEC_PACKAGE_ID=%DOT_BASE_NAME%
set NUSPEC_PACKAGE_AUTHORS=Matt Janda
set NUSPEC_PACKAGE_DESCRIPTION=GitVersion dot package
set NUSPEC_PACKAGE_TITLE=
set NUSPEC_PACKAGE_OWNERS=Matt Janda


call :build_nuspec_file

echo Packing %PACKAGE%...
nuget pack .nuspec -OutputDirectory %OUTPUT_DIR% -NoDefaultExcludes -Version %DOT_GIT_VERSION% -Properties NoWarn=NU5105
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


:build_nuspec_file

call :nuspec_append_header
call :nuspec_append_content build %~p0
call :nuspec_append_content content %~p0
call :nuspec_append_footer
echo The file %NUSPEC_FILE% created successfully.
goto :eof



:nuspec_append_header
echo Creating %NUSPEC_FILE% file...
echo ^<?xml version="1.0" encoding="utf-8"?^>> %NUSPEC_FILE%
echo ^<package xmlns="http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd"^>>> %NUSPEC_FILE%
echo   ^<metadata^>>> %NUSPEC_FILE%
echo     ^<id^>%NUSPEC_PACKAGE_ID%^</id^>>> %NUSPEC_FILE%
echo     ^<version^>%NUSPEC_PACKAGE_VERSION%^</version^>>> %NUSPEC_FILE%
echo     ^<title^>%NUSPEC_PACKAGE_TITLE%^</title^>>> %NUSPEC_FILE%
echo     ^<authors^>%NUSPEC_PACKAGE_AUTHORS%^</authors^>>> %NUSPEC_FILE%
echo     ^<owners^>%NUSPEC_PACKAGE_OWNERS%^</owners^>>> %NUSPEC_FILE%
echo     ^<requireLicenseAcceptance^>false^</requireLicenseAcceptance^>>> %NUSPEC_FILE%
echo     ^<description^>%NUSPEC_PACKAGE_DESCRIPTION%^</description^>>> %NUSPEC_FILE%
echo     ^<developmentDependency^>true^</developmentDependency^>>> %NUSPEC_FILE%
echo     ^<dependencies^>>> %NUSPEC_FILE%
echo       ^<dependency id="GitVersionTask" version="5.3.3" /^>>> %NUSPEC_FILE%
echo     ^</dependencies^>>> %NUSPEC_FILE%
echo   ^</metadata^>>> %NUSPEC_FILE%
echo   ^<files^>>> %NUSPEC_FILE%
goto :eof

:nuspec_append_footer
echo   ^</files^>>> %NUSPEC_FILE%
echo ^</package^>>> %NUSPEC_FILE%
goto :eof

:nuspec_append_content
echo Adding %~1 to %NUSPEC_FILE% file...
for /R "%~1" %%G in ("*.*") do if %%~nxG neq %~nx0 call :nuspec_append_file "%%~pG%%~nxG" "%~2"
goto :eof


:nuspec_append_file
set CONTENT_PATH=%~1
set SEARCH_FOR=%~2
set REPLACE_TO=
call set CONTENT_PATH=%%CONTENT_PATH:%SEARCH_FOR%=%REPLACE_TO%%%
echo     ^<file src="%~3%CONTENT_PATH%" target="%~4%CONTENT_PATH%" /^>>> %NUSPEC_FILE%
goto :eof

