#!/bin/bash

if [ -n "$LIBRARY_VERSION" ] ; then
export ECWJP2SDK_VERSION=$LIBRARY_VERSION
fi
. ../tools/common.maven.inc
../gdal/get_gdal.sh
../ecwjp2sdk/get_ecwjp2sdk.sh

$MVN_CMD -B -f pom.xml -s $MVN_SETTINGS  clean package -Px64linux,$COMPILER_VERSION_MAVEN
