#
# Install and configure LOG4PLSQL Background Process as a service
#
# Export the following variables:
#
# LOG4PLSQL_DIR: Directory where source files are
#   Default: `pwd`
# LOG4PLSQL_HOME: Installation directory
#   Default: /etc/log4plsql
# LOG4PLSQL_CONFIG: Relative location of config file
#   Default: $LOG4PLSQL_HOME/properties/$LOG4PLSQL_SERVICENAME.xml
# LOG4J_CONFIG: Log4J properties file
#   Default: $LOG4PLSQL_HOME/properties/log4j.properties
# (the following are for $LOG4PLSQL_CONFIG)
# DB_USERNAME
# DB_PASSWORD
# DB_URL
# DB_HOST
# DB_SERVICE
# (the following are for the daemon script)
# LOG4PLSQL_SERVICENAME:
#   Default: log4plsql
# LOG4PLSQL_DESCRIPTION: init file description 
#   Default: LOG4PLSQL Background Process ($LOG4PLSQL_SERVICENAME)
# LOG4PLSQL_PIDFILE:
#   Default: /var/run/$LOG4PLSQL_SERVICENAME.pid
# ORACLE_HOME
#   Default: $ORACLE_HOME
# LOG4PLSQL_SCRIPTNAME
#   Default: /etc/init.d/$LOG4PLSQL_SERVICENAME

# Set defaults
if [ -z "$LOG4PLSQL_SERVICENAME" ]; then 
    export LOG4PLSQL_SERVICENAME="log4plsql"
fi
if [ -z "$LOG4PLSQL_HOME" ]; then 
    export LOG4PLSQL_HOME="/etc/log4plsql"
fi
if [ -z "$LOG4PLSQL_DIR" ]; then 
    export LOG4PLSQL_DIR=`pwd`
fi
if [ -z "$LOG4PLSQL_CONFIG" ]; then 
    export LOG4PLSQL_CONFIG="$LOG4PLSQL_HOME/properties/$LOG4PLSQL_SERVICENAME.xml"
fi
if [ -z "$LOG4J_CONFIG" ]; then 
    export LOG4J_CONFIG="$LOG4PLSQL_HOME/properties/log4j-$LOG4PLSQL_SERVICENAME.properties"
fi
if [ -z "$LOG4PLSQL_SCRIPTNAME" ]; then 
    export LOG4PLSQL_SCRIPTNAME="/etc/init.d/$LOG4PLSQL_SERVICENAME"
fi
if [ -z "$LOG4PLSQL_DESCRIPTION" ]; then 
    export LOG4PLSQL_DESCRIPTION="LOG4PLSQL Background Process ($LOG4PLSQL_SERVICENAME)"
fi
if [ -z "$LOG4PLSQL_PIDFILE" ]; then 
    export LOG4PLSQL_PIDFILE="/var/run/$LOG4PLSQL_SERVICENAME.pid"
fi
### Mandatory params
if [ -z "$DB_USERNAME" ]; then 
    echo You must provide DB_USERNAME
    exit 1
fi
if [ -z "$DB_PASSWORD" ]; then 
    echo You must provide DB_PASSWORD
    exit 1
fi
if [ -z "$DB_URL" ]; then 
    echo You must provide DB_URL
    exit 1
fi
if [ -z "$DB_HOST" ]; then 
    echo You must provide DB_HOST
    exit 1
fi
if [ -z "$DB_SERVICE" ]; then 
    echo You must provide DB_SERVICE
    exit 1
fi

echo LOG4PLSQL_DIR=$LOG4PLSQL_DIR
echo LOG4PLSQL_CONFIG=$LOG4PLSQL_CONFIG
echo LOG4J_CONFIG=$LOG4J_CONFIG
echo LOG4PLSQL_SERVICENAME=$LOG4PLSQL_SERVICENAME
echo LOG4PLSQL_SCRIPTNAME=$LOG4PLSQL_SCRIPTNAME 
echo LOG4PLSQL_DESCRIPTION=$LOG4PLSQL_DESCRIPTION 
echo LOG4PLSQL_PIDFILE=$LOG4PLSQL_PIDFILE
echo DB_USERNAME=$DB_USERNAME 
echo DB_PASSWORD=$DB_PASSWORD 
echo DB_URL=$DB_URL 
echo DB_HOST=$DB_HOST 
echo DB_SERVICE=$DB_SERVICE 

# Create a build dir
rm -fr /tmp/build
mkdir --parents /tmp/build
mkdir --parents /tmp/build/etc/init.d

echo Setting configurations

# Copy properties files to build dir
mkdir /tmp/build/properties
cp -v $LOG4PLSQL_DIR/properties/log4plsql.xml /tmp/build/properties/$LOG4PLSQL_SERVICENAME.xml
cp -v $LOG4PLSQL_DIR/properties/log4j.properties /tmp/build/properties/log4j-$LOG4PLSQL_SERVICENAME.properties  

sed -i "s|<username>.*</username>|<username>$DB_USERNAME</username>|" /tmp/build/properties/$LOG4PLSQL_SERVICENAME.xml 
sed -i "s|<password>.*</password>|<password>$DB_PASSWORD</password>|" /tmp/build/properties/$LOG4PLSQL_SERVICENAME.xml 
sed -i "s|<dburl>.*</dburl>|<dburl>$DB_URL</dburl>|" /tmp/build/properties/$LOG4PLSQL_SERVICENAME.xml 
sed -i "s|<host>.*</host>|<host>$DB_HOST</host>|" /tmp/build/properties/$LOG4PLSQL_SERVICENAME.xml 
sed -i "s|<service>.*</service>|<service>$DB_SERVICE</service>|" /tmp/build/properties/$LOG4PLSQL_SERVICENAME.xml 
sed -i "s|<fileName name=\".*\" />|<fileName name=\"$LOG4J_CONFIG\" />|" /tmp/build/properties/$LOG4PLSQL_SERVICENAME.xml 

echo Deploying LOG4PLSQL Background Process to $LOG4PLSQL_HOME

# Deploy files
sudo mkdir $LOG4PLSQL_HOME
# Remove existing symlink or we'll possibly overwrite new jar with old one 
sudo rm $LOG4PLSQL_HOME/jlib/log4plsql-qr.jar
sudo cp -vR $LOG4PLSQL_DIR/* $LOG4PLSQL_HOME
sudo rm $LOG4PLSQL_HOME/jlib/log4plsql-qr.jar
sudo ln -s $LOG4PLSQL_HOME/jlib/log4plsql-qr-4.0.2.jar $LOG4PLSQL_HOME/jlib/log4plsql-qr.jar
# Copy custom properties files
sudo cp -vR /tmp/build/properties/* $LOG4PLSQL_HOME/properties/

echo Deployed LOG4PLSQL Background Process to $LOG4PLSQL_HOME

echo Creating service

# Create service init file

cp -v $LOG4PLSQL_DIR/etc/init.d/log4plsql /tmp/build/etc/init.d/$LOG4PLSQL_SERVICENAME 
# Set params in init file
sed -i "s|#LOG4PLSQL_HOME#|$LOG4PLSQL_HOME|" /tmp/build/etc/init.d/$LOG4PLSQL_SERVICENAME
sed -i "s|#LOG4PLSQL_CONFIG#|$LOG4PLSQL_CONFIG|" /tmp/build/etc/init.d/$LOG4PLSQL_SERVICENAME
sed -i "s|#LOG4PLSQL_SERVICENAME#|$LOG4PLSQL_SERVICENAME|" /tmp/build/etc/init.d/$LOG4PLSQL_SERVICENAME
sed -i "s|#LOG4PLSQL_DESCRIPTION#|$LOG4PLSQL_DESCRIPTION|" /tmp/build/etc/init.d/$LOG4PLSQL_SERVICENAME
sed -i "s|#LOG4PLSQL_PIDFILE#|$LOG4PLSQL_PIDFILE|" /tmp/build/etc/init.d/$LOG4PLSQL_SERVICENAME
sed -i "s|#ORACLE_HOME#|$ORACLE_HOME|" /tmp/build/etc/init.d/$LOG4PLSQL_SERVICENAME
sed -i "s|#LOG4PLSQL_SCRIPTNAME#|$LOG4PLSQL_SCRIPTNAME|" /tmp/build/etc/init.d/$LOG4PLSQL_SERVICENAME

# Deploy init file
sudo cp -v /tmp/build/etc/init.d/$LOG4PLSQL_SERVICENAME $LOG4PLSQL_SCRIPTNAME
sudo chmod 755 $LOG4PLSQL_SCRIPTNAME

# Add service file to /etc/rc*.d
sudo /sbin/chkconfig --add $LOG4PLSQL_SERVICENAME

echo Created service

# Start service
echo To start the service, run:
echo     sudo $LOG4PLSQL_SCRIPTNAME start

