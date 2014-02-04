setlocal

call setVariable.bat

cd %LOG4PLSQL_HOME%
cd

set BGL=java -DTHRESHOLD_LEVEL=WARN  log4plsql.backgroundProcess.Run properties\log4plsql.xml

echo CLASSPATH
echo %CLASSPATH%

echo %BGL%
%BGL%
