ORACLE_HOME=/home/oracle/oracle/product/10.2.0/db_3
LOG4PLSQL_HOME=/home/oracle/log4plsql

CLASSPATH=$ORACLE_HOME/rdbms/jlib/aqapi13.jar
# for Oracle on Linux, jta.jar is needed for transactions
CLASSPATH=$CLASSPATH:$ORACLE_HOME/jlib/jta.jar

CLASSPATH=$CLASSPATH:$ORACLE_HOME/jdbc/lib/classes12.jar
CLASSPATH=$CLASSPATH:$ORACLE_HOME/jlib/orai18n.jar
CLASSPATH=$CLASSPATH:$ORACLE_HOME/lib/xmlparserv2.jar
CLASSPATH=$CLASSPATH:$ORACLE_HOME/oc4j/j2ee/home/lib/jms.jar

CLASSPATH=$CLASSPATH:$LOG4PLSQL_HOME/jlib/log4j-1.2.15.jar
CLASSPATH=$CLASSPATH:$LOG4PLSQL_HOME/jlib/log4plsql-qr.jar

export ORACLE_HOME CLASSPATH LOG4PLSQL_HOME
