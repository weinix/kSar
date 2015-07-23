#!/bin/sh

DIRNAME=`dirname $0`

# Setup the JVM
if [ "x$JAVA_HOME" != "x" ]; then
    JAVA="$JAVA_HOME/bin/java"
else
    JAVA="java"
fi

if [ ! -f "$DIRNAME/kSar.jar" ] ; then
    echo "Unable to find kSar.jar"
    exit 1;
fi

exec $JAVA $JAVA_OPT  -Xmx1024m  -jar $DIRNAME/kSar.jar $@
