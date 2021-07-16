#!/bin/bash

ORIGINAL_PATH=`pwd`

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $SCRIPT_DIR

. ../tools/common.maven.inc

if [ -z "$GDAL_VERSION" ]; then 
export GDAL_VERSION=3.3.0
fi

$MVN_CMD -B -s $MVN_SETTINGS -f pom.xml clean package -Px64linux,$COMPILER_VERSION_MAVEN,Release
$MVN_CMD -B -s $MVN_SETTINGS -f pom.xml clean package -Px64linux,$COMPILER_VERSION_MAVEN,Debug

cd $ORIGINAL_PATH
