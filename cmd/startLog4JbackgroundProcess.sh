. ./setVariable.sh

cd $LOG4PLSQL_HOME

echo start listener

/usr/java/jdk1.5.0_14/bin/java log4plsql.backgroundProcess.Run ./properties/log4plsql.xml