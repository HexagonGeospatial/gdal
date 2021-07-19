#!/bin/bash

ORIGINAL_PATH=`pwd`

if [ -z "$ECWJP2SDK_VERSION" ] ; then 
export ECWJP2SDK_VERSION=5.3.0.286
fi


SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $SCRIPT_DIR

. ../tools/common.maven.inc


if [ -z "$COMPILER_VERSION_MAVEN" ]; then
	COMPILER_VERSION_MAVEN=gcc51
fi

$MVN_CMD -B -s $MVN_SETTINGS -f pom.xml clean package -Px64linux,$COMPILER_VERSION_MAVEN,Release
$MVN_CMD -B -s $MVN_SETTINGS -f pom.xml clean package -Px64linux,$COMPILER_VERSION_MAVEN,Debug

function link_sdk
{
  if [ "${LIB_NCSECW}" = "ecw" ]; then
	NCSECW_SO=`ls libecw.so.*.*.*`
	NCSECWD_SO=`ls libecwd.so.*.*.*`
	ln -sf ./$NCSECW_SO libecw.so
	ln -sf ./$NCSECWD_SO libecwd.so
 else
	NCSECW_SO=`ls libNCSEcw.so.*.*.*`
	NCSECWD_SO=`ls libNCSEcwd.so.*.*.*`
	ln -sf ./$NCSECW_SO libNCSEcw.so
	ln -sf ./$NCSECWD_SO libNCSEcwd.so
 fi
}

cd ../root/usr/lib/x64linuxRelease
link_sdk
cd ../x64linuxDebug
link_sdk

cd $ORIGINAL_PATH

