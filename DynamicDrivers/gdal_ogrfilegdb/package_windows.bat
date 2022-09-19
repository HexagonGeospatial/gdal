pushd ..\..\..\..
set THIRD_PARTY_ROOT=%cd%
popd



if not defined MVN_CMD (
set MVN_CMD=%THIRD_PARTY_ROOT%\bootstrap\maven\3.0.5\bin\mvn.bat
)
if not defined MVN_SETTINGS (
set MVN_SETTINGS=%THIRD_PARTY_ROOT%\bootstrap\maven\settings\settings-perth.xml
)

if not defined JAVA_HOME (
set JAVA_HOME=%THIRD_PARTY_ROOT%\bootstrap\jre\jre_win32_1.6.0_20
)
if not defined MSVC_VER (
set MSVC_VER=msvc120
)
if NOT DEFINED GDAL_VERSION (
set GDAL_VERSION=2.1.2
)
if NOT DEFINED GDAL_SUFFIX (
set GDAL_SUFFIX=1
)
if not defined FILEGDB_VERSION (
set FILEGDB_VERSION=1.5.1
)

call %MVN_CMD% -s %MVN_SETTINGS% clean package -Px64,%MSVC_VER%
call %MVN_CMD% -s %MVN_SETTINGS% clean package -PWin32,%MSVC_VER%

)
