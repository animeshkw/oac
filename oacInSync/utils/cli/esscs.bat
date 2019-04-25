
@echo off

set ERR_MSG_JAVA_REQUIRED=Install JDK8 and set JAVA_HOME variable to JDK8 installed location

:check_java

IF DEFINED JAVA_HOME (
    @REM Remore any quotes in JAVA_HOME variable value
    set JAVA_HOME_NO_QUOTE=%JAVA_HOME:"=%
) ELSE (
    set JAVA_HOME_NO_QUOTE=
)

IF NOT EXIST "%JAVA_HOME_NO_QUOTE%\bin\java.exe" (
    echo.
    echo %ERR_MSG_JAVA_REQUIRED%
    echo.
    SET errorlevel=1
    goto end
)

for /f "tokens=3" %%g in ('"%JAVA_HOME_NO_QUOTE%/bin/java" -version 2^>^&1') do (
    
    if /I %%g LSS "1.8" (
        echo.
        echo You are using older java version %%g
        echo %ERR_MSG_JAVA_REQUIRED%
        SET errorlevel=1
        goto end
    )
)

set CLI_HOME=%~sdp0
set REST_CLI_HOME=%CLI_HOME%/lib

set CLASSPATH=.;%REST_CLI_HOME%/ess_rest_cli.jar;%REST_CLI_HOME%/ess_es_server.jar;%REST_CLI_HOME%/ess_japi.jar;%REST_CLI_HOME%/ess_svp.jar;%REST_CLI_HOME%/commons-cli.jar;%REST_CLI_HOME%/commons-io.jar;%REST_CLI_HOME%/jersey-client.jar;%REST_CLI_HOME%/javax.ws.rs-api.jar;%REST_CLI_HOME%/jersey-common.jar;%REST_CLI_HOME%/hk2-utils.jar;%REST_CLI_HOME%/javax.inject.jar;%REST_CLI_HOME%/hk2-locator.jar;%REST_CLI_HOME%/hk2-api.jar;%REST_CLI_HOME%/javax-annotation-javax-annotation-api.jar;%REST_CLI_HOME%/jackson-annotations.jar;%REST_CLI_HOME%/jackson-core.jar;%REST_CLI_HOME%/jackson-databind.jar;%REST_CLI_HOME%/jackson-mapper-asl-1.9.2.jar;%REST_CLI_HOME%/ojdl.jar;%REST_CLI_HOME%/jersey-guava.jar;%REST_CLI_HOME%/cglib.jar;%REST_CLI_HOME%/jackson-core-asl-1.9.2.jar;%JAVA_HOME%/db/lib/derby.jar;%REST_CLI_HOME%/ojdbc7.jar;%REST_CLI_HOME%/ess-platform-common.jar;%REST_CLI_HOME%/commons-lang.jar;%REST_CLI_HOME%/datasource-model.jar;%REST_CLI_HOME%/excel-core.jar;%REST_CLI_HOME%/lz4-java.jar

set CLASSPATH=%CLASSPATH%;%EXTERNAL_CLASSPATH%

if "%1"=="usage" goto usage

:run

if "%ESSCLI_ID%"=="" (
    set ESSCLI_ID=%RANDOM%
)

set JAVA_OPTIONS=-DESSCLI_ID=%ESSCLI_ID% -Djava.util.logging.config.class=oracle.core.ojdl.logging.LoggingConfiguration -Doracle.core.ojdl.logging.config.file=%CLI_HOME%\logging.xml

"%JAVA_HOME_NO_QUOTE%\bin\java" %JAVA_OPTIONS% oracle.essbase.restcli.EssShell %*
goto end

:usage

goto end

:end
