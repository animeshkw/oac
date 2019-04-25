#!/bin/sh

export ERR_MSG_JAVA_REQUIRED="Install JDK8 and set JAVA_HOME variable to JDK8 installed location"

if [ -z "$JAVA_HOME" ] 
then
    echo
    echo $ERR_MSG_JAVA_REQUIRED
    echo
    exit 1
fi

export JAVA_VERSION=$("$JAVA_HOME/bin/java" -version 2>&1 | awk -F '"' '/version/ {print $2}')

if [[ "$JAVA_VERSION" < "1.8" ]]
then
    echo
    echo You are using older java version $JAVA_VERSION
    echo $ERR_MSG_JAVA_REQUIRED
    echo
    exit 1
fi

export SCRIPT_DIRECTORY=$(dirname "$(readlink -f "$0")")
cd "$SCRIPT_DIRECTORY"

export CLI_HOME=.
export REST_CLI_HOME=$CLI_HOME/lib

export CLASSPATH=.:$REST_CLI_HOME/ess_rest_cli.jar:$REST_CLI_HOME/ess_es_server.jar:$REST_CLI_HOME/ess_japi.jar:$REST_CLI_HOME/ess_svp.jar:$REST_CLI_HOME/commons-cli.jar:$REST_CLI_HOME/commons-io.jar:$REST_CLI_HOME/jersey-client.jar:$REST_CLI_HOME/javax.ws.rs-api.jar:$REST_CLI_HOME/jersey-common.jar:$REST_CLI_HOME/hk2-utils.jar:$REST_CLI_HOME/hk2-apijar:$REST_CLI_HOME/javax.inject.jar:$REST_CLI_HOME/hk2-locator.jar:$REST_CLI_HOME/hk2-api.jar:$REST_CLI_HOME/javax-annotation-javax-annotation-api.jar:$REST_CLI_HOME/jackson-annotations.jar:$REST_CLI_HOME/jackson-core.jar:$REST_CLI_HOME/jackson-databind.jar:$REST_CLI_HOME/jackson-mapper-asl-1.9.2.jar:$REST_CLI_HOME/ojdl.jar:$REST_CLI_HOME/jersey-guava.jar:$REST_CLI_HOME/cglib.jar:$REST_CLI_HOME/jackson-core-asl-1.9.2.jar:$JAVA_HOME/db/lib/derby.jar:$REST_CLI_HOME/ojdbc7.jar:$REST_CLI_HOME/ess-platform-common.jar:$REST_CLI_HOME/commons-lang.jar:$REST_CLI_HOME/datasource-model.jar:$REST_CLI_HOME/excel-core.jar:$REST_CLI_HOME/lz4-java.jar

echo $EXTERNAL_CLASSPATH
export CLASSPATH=$CLASSPATH:$EXTERNAL_CLASSPATH

if [ -n "$ESSCS_ID" ] && [ -z "$ESSCLI_ID" ]
then
    export ESSCLI_ID=$ESSCS_ID
fi

if [ -z "$ESSCLI_ID" ]
then 
    if [ -t 1 ]
    then
        export ESSCLI_ID=`id -un`"_"`tty`
    else
        export ESSCLI_ID=`id -un`
    fi
fi

export JAVA_OPTIONS="-DESSCLI_ID=$ESSCLI_ID -Djava.util.logging.config.class=oracle.core.ojdl.logging.LoggingConfiguration -Doracle.core.ojdl.logging.config.file=${CLI_HOME}/logging.xml"

$JAVA_HOME/bin/java $JAVA_OPTIONS oracle.essbase.restcli.EssShell "$@"

