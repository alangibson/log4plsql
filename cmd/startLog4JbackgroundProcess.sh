#!/bin/sh

# cd $LOG4PLSQL_HOME/cmd
. ./setVariable.sh

cd $LOG4PLSQL_HOME

echo Starting listener

java log4plsql.backgroundProcess.Run ./properties/log4plsql.xml

echo Listener stopped
