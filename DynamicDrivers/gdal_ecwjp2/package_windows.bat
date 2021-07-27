@echo off

pushd ..\..\..\..
set THIRD_PARTY_ROOT=%cd%
popd

if not defined MVN_CMD (
@echo "MVN_CMD not defined"
exit /b 1
)
if not defined MVN_SETTINGS (
@echo "MVN_SETTINGS not defined"
exit /b 1
)

if not defined JAVA_HOME (
@echo "JAVA_HOME not defined"
exit /b 1
)
if not defined MSVC_VER (
@echo "MSVC_VER not defined"
exit /b 1
)
if not defined GDAL_VERSION (
@echo "GDAL_VERSION not defined"
exit /b 1
)
if not defined GDAL_SUFFIX (
@echo "GDAL_SUFFIX not defined"
exit /b 1
)

if not defined LIBRARY_VERSION (
@echo "LIBRARY_VERSION not defined"
exit /b 1
)

rem JENKINS sets LIBRARY_VERSION.
if defined LIBRARY_VERSION (
set ECWJP2SDK_VERSION=%LIBRARY_VERSION%
)

if not defined LIB_NCSECW (
@echo "LIBRARY NCSECW not defined"
exit /b 1
)

call %MVN_CMD% -s %MVN_SETTINGS% clean package -Px64,%MSVC_VER%
call %MVN_CMD% -s %MVN_SETTINGS% clean package -PWin32,%MSVC_VER%
