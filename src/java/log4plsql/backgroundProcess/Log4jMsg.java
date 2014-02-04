package log4plsql.backgroundProcess;

/* Class Log4jMsg
 * 
 * Creates a LOG4J message from a JMS message.
 * The JMS message is first converted to the Oracle Type TLogQueue
 * (type of the queue table).
 */

import java.sql.SQLException;
import java.util.Hashtable;

import javax.jms.*;

import oracle.jms.AdtMessage;

import org.apache.log4j.Category;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.NDC;
import org.apache.log4j.Priority;
import org.apache.log4j.spi.LoggingEvent;

public class Log4jMsg {
	private Logger logger = Logger.getLogger("backgroundProcess.Log4jMsg");
	
	Message JmsMsg;
	Hashtable htLevels;
	
	public Log4jMsg(Message pJmsMessage, Hashtable phtLevels)
	{
		JmsMsg = pJmsMessage;
		htLevels = phtLevels;
	}
	
	public void Create()
	{
		AdtMessage adtmsg;
		TLogQueue datalog;
		
	    Priority priority = null;
	    LoggingEvent  event;
	    String        fqnOfCategoryClass = "fqnOfCategoryClass";
	    Throwable     myThrowable = null;
		
		try{
	    
			// convert the JMS message in the Oracle type TLogQueue
			adtmsg = (AdtMessage) JmsMsg;
		    datalog =(TLogQueue)(adtmsg.getAdtPayload());
	        
	        Category logger = Logger.getLogger(datalog.getLuser()+ "." +datalog.getLsection());
	        
	        // convert the PL/SQL log level in LOG4J level
	        // Level level = (DynamicLevel)htLevels.get(new Integer (datalog.getLlevel().intValue()));
	        // Alan Gibson changed conversion from casting to creating new Level
	        // A DynamicLevel was being sent to server when using SocketAppender
	        // constructor: Level(int level, String levelStr, int syslogEquivalent)
	        DynamicLevel dynLevel = (DynamicLevel) htLevels.get(new Integer (datalog.getLlevel().intValue()));
	        // Level level = new Level(dynLevel.dynamicLevelInt, dynLevel.dynamicLevelStr, dynLevel.dynamicLevelSyslogEquiv);
	        Level level = Level.toLevel(dynLevel.dynamicLevelInt);
	        
	        if (level != null) {
	           priority = level;
	        } else {
	          priority = Level.toLevel("UNDEFINED",  Level.ERROR );
	        }    
	        
	        // create the LOG4J event
	        NDC.push("DatabaseLoginDate:"+datalog.getLdate()) ;
	        event = new LoggingEvent(fqnOfCategoryClass,
	                                 logger,
	                                 priority,
	                                 datalog.getLtext(),
	                                 myThrowable);
	
	
	        logger.callAppenders(event);
	        NDC.remove();
	        Thread.yield();
        }
		catch (JMSException JMSex) {
			logger.fatal("JMS error during receiving message - " +
                    " JMSException" + JMSex);
		}
		catch (SQLException SQLex) {
			logger.fatal("SQL error during receiving message - " +
                    " SQLException" + SQLex);
		}
		catch (Exception ex) {
			logger.fatal("Error during receiving message - " +
                    " Exception" + ex);
		}

	}

}
