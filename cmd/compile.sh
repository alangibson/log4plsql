#!/bin/sh

export LOG4PLSQL_HOME=`pwd`

. ./cmd/setVariable.sh

export JAVA=$ORACLE_HOME/jdk/bin/java
export JAVAC=$ORACLE_HOME/jdk/bin/javac
export JAR=$ORACLE_HOME/jdk/bin/jar

rm -fr build
mkdir build
find src/ -name "*.java" > build/sources.txt
$JAVAC -d build @build/sources.txt
rm build/sources.txt
cp -R properties build/
# -e only works with > 1.5?
# jar cfve log4plsql-qr-4.0.2.jar log4plsql.backgroundProcess.Run -C build .
rm log4plsql-qr-4.0.2.jar
$JAR cfv build/log4plsql-qr-4.0.2.jar -C build .
cp -v build/log4plsql-qr-4.0.2.jar jlib/

# Test the jar
# $JAVA -jar log4plsql-qr-4.0.2.jar
# $JAVA -classpath "build/log4plsql-qr-4.0.2.jar:$CLASSPATH" log4plsql.backgroundProcess.Run ./properties/log4plsql.xml
