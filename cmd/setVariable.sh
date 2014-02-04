#
# Set LOG4PLSQL Background Process environment variables
#

echo "Setting CLASSPATH environment variable"

CLASSPATH=

if [ -z "$LOG4PLSQL_HOME" ]; then 
    echo "You must set the environment variable LOG4PLSQL_HOME"
    echo "to the directory that contains jlib/log4plsql-*.jar"
else
    echo "Environment variable LOG4PLSQL_HOME is: $LOG4PLSQL_HOME"
    
    # log4plsql jar needs to be first in order to avoid ClassNotFound exception
    CLASSPATH=$CLASSPATH:$LOG4PLSQL_HOME/jlib/log4plsql-qr.jar
    CLASSPATH=$CLASSPATH:$LOG4PLSQL_HOME/jlib/log4j-1.2.15.jar
fi

if [ -z "$ORACLE_HOME" ]; then
    echo "You must set the environment variable ORACLE_HOME."
else
    echo "Environment variable ORACLE_HOME is: $ORACLE_HOME"

    if [ -e $ORACLE_HOME/rdbms/jlib/aqapi13.jar ]; then 
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/rdbms/jlib/aqapi13.jar
    elif [ -e $ORACLE_HOME/oc4j/rdbms/jlib/aqapi.jar ]; then
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/oc4j/rdbms/jlib/aqapi.jar
    else
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/rdbms/jlib/aqapi.jar
    fi
    
    # for Oracle on Linux, jta.jar is needed for transactions
    if [ -e $ORACLE_HOME/oc4j/j2ee/home/lib/jta.jar ]; then 
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/oc4j/j2ee/home/lib/jta.jar
    else
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/jlib/jta.jar
    fi
    
    # FIXME This kills the process on 11g
    #if [ -e "$ORACLE_HOME/jdbc/lib/classes12.jar" ]; then
    #    CLASSPATH=$CLASSPATH:$ORACLE_HOME/jdbc/lib/classes12.jar
    #else
    #    CLASSPATH=$CLASSPATH:$ORACLE_HOME/oui/jlib/classes12.jar
    #fi
    
    if [ -e $ORACLE_HOME/oc4j/jdbc/lib/orai18n.jar ]; then 
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/oc4j/jdbc/lib/orai18n.jar
    else
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/jlib/orai18n.jar
    fi
    
    if [ -e $ORACLE_HOME/oc4j/lib/xmlparserv2.jar ]; then 
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/oc4j/lib/xmlparserv2.jar
    else
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/lib/xmlparserv2.jar
    fi
    
    if [ -e $ORACLE_HOME/oc4j/j2ee/home/lib/jms.jar ]; then 
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/oc4j/j2ee/home/lib/jms.jar
    else
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/oc4j/j2ee/home/lib/jms.jar
    fi
    
    # Using Java 1.5, can't use ojdbc7 or 6:
    #    bad class file: /u01/app/oracle/product/11.2.0/dbhome_1/jdbc/lib/ojdbc6.jar(oracle/jdbc/OracleTypes.class)
    #    class file has wrong version 50.0, should be 49.0
    #    Please remove or make sure it appears in the correct subdirectory of the classpath.
    #    import oracle.jdbc.OracleTypes;
    #if [ -e "$ORACLE_HOME/jdbc/lib/ojdbc7.jar" ]
    #then
    #    CLASSPATH=$CLASSPATH:$ORACLE_HOME/jdbc/lib/ojdbc7.jar
    #if [ -e "$ORACLE_HOME/jdbc/lib/ojdbc6.jar" ]; then
    #    CLASSPATH=$CLASSPATH:$ORACLE_HOME/jdbc/lib/ojdbc6.jar
    
    if [ -e "$ORACLE_HOME/jdbc/lib/ojdbc5.jar" ]; then
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/jdbc/lib/ojdbc5.jar
    elif [ -e "$ORACLE_HOME/owb/wf/lib/ojdbc14.jar" ]; then
        CLASSPATH=$CLASSPATH:$ORACLE_HOME/owb/wf/lib/ojdbc14.jar
    fi

fi

echo "CLASSPATH is now: $CLASSPATH"

export ORACLE_HOME CLASSPATH LOG4PLSQL_HOME
