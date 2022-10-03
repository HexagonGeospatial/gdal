#!/bin/bash
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

export SOURCES_ROOT=$( cd $SCRIPT_DIR/../../../../../.. && pwd )

if [ -z "$JAVA_HOME" ] ; then 
export JAVA_HOME=/usr
fi

if [ -z "$MVN_CMD" ] ; then 
export MVN_CMD=$SOURCES_ROOT/tools/maven/3.6.3/bin/mvn
fi

if [ -z "$MVN_SETTINGS" ] ; then 
export MVN_SETTINGS=$SOURCES_ROOT/tools/maven/settings/settings-perth.xml
fi 

