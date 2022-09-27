@echo off

if [%1] == [] (
	@echo "First parameter needs to be set to architecture: x86 or x64"
	set BUILD_ERROR=YES
	Goto :EOF
) 

@rem %1 ARCH : x86 or x64
@rem %2 MSVC : version
@rem %3 PROJECT: 

if [%2] == [] (
	@echo "Second parameter needs to be set to msvc runtime: msvc90, msvc100, msvc110 or msvc120"
	set BUILD_ERROR=YES
	Goto :EOF
) 

if "%2" == "msvc141" (
	set MSBUILD_ARCH=v141
) else if "%2" == "msvc143" (
	set MSBUILD_ARCH=v143
)


if [%3] == [] (
	@echo "Third parameter needs to be set to project name to be built"
	set BUILD_ERROR=YES
	goto :EOF
)
set PROJECT=%3

pushd .
call %4 %~5
popd


if "%1" == "x86" (
	Goto :Buildx86
)
if "%1" == "x64" (
	Goto :Buildx64
)

Goto :EOF
:Buildx86
set PLATFORM=Win32
call :Build

Goto :EOF

:Buildx64
set PLATFORM=x64
call :Build
Goto :EOF

:Build
call :ReallyBuild Debug
call :ReallyBuild Release

call :SignAndVersionDllsInDir %RELEASE_BIN_DIR%
call :SignAndVersionDllsInDir %DEBUG_BIN_DIR%

Goto :EOF

:ReallyBuild

echo library used: %LIB_NCSECW%

msbuild /t:%PROJECT% /p:Configuration=%1;Platform=%PLATFORM%;PlatformToolset=%MSBUILD_ARCH% ..\DynamicDrivers.sln
 if %ERRORLEVEL% GEQ 1 (
 	set BUILD_ERROR=YES
	Goto :EOF
)

Goto :EOF

:SignAFile

echo calling %CODE_SIGNING_DIR%\SignFile.bat %1 %SIGN_PROGRAM%
pushd %CODE_SIGNING_DIR%
Call SignFile.bat %1 %SIGN_PROGRAM%
popd

Goto :EOF

:VersionAFile

echo CURRENT_BUILD_VERSION=%CURRENT_BUILD_VERSION%
%CODE_SIGNING_DIR%\rcedit %1 --set-file-version %CURRENT_BUILD_VERSION%
%CODE_SIGNING_DIR%\verpatch %1 /va %CURRENT_BUILD_VERSION% /pv %CURRENT_BUILD_VERSION%

Goto :EOF

:SignAndVersionDllsInDir

pushd %1

call :VersionAFile %1\%DLL_NAME%
call :SignAFile %1\%DLL_NAME%

popd

Goto :EOF

