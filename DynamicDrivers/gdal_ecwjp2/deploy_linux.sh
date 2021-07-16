#!/bin/bash

. common.maven.inc

function deploy(){
        $MAVEN_CMD -s $MAVEN_CONF deploy:deploy-file -Durl=http://per-nexus.ingrnet.com/nexus/content/repositories/releases -Dfile=./$1-$3-$4.zip -DgroupId=$2 -DartifactId=$1 -Dversion=$3 -Dpackaging=zip -Dclassifier=$4 -DuniqueVersion=false -DrepositoryId=perth-snaphots -DgeneratePom=true
}
deploy ecwjp2 org.gdal.drivers 2.1.2-$ECWJP2SDK_VERSION linux-gcc44-x64

