package log4plsql.backgroundProcess;

/* Class TopicSub - Super class for a topic subscriber
 * 
 *  The constructor connects to the topic and creates a
 *  topic subscriber.
 * 
 */

import java.util.Hashtable;
import javax.jms.JMSException;
import javax.jms.TopicSubscriber;
import oracle.jms.AQjmsSession;
import org.apache.log4j.Logger;

public class TopicSub {
	private Logger logger = Logger.getLogger("backgroundProcess.TopicSub");

	Hashtable htLevels;
	DbConnTopic dbConn;
	TopicSubscriber tsubscriber = null;
	
	public TopicSub(String pJDBC, String pDBUser, String pDBPass, String pQueueName)
	{
		try{
			dbConn = new DbConnTopic(pJDBC, pDBUser, pDBPass, pQueueName);
			// get the mapping table for log levels
			htLevels = dbConn.getLogLevels();
			// create connection to the topic
			dbConn.connect_topic();
			if (dbConn.connected)
			{
				// create the topic subscriber
				tsubscriber =  ((AQjmsSession)dbConn.tsess).createDurableSubscriber(dbConn.topic, "LOG4J", "tab.user_data.LLEVEL >= 0", false, TLogQueue.getORADataFactory());
				logger.debug("Topic subscriber created: " + tsubscriber.toString());
			}
		}
		catch (JMSException JMSex) {
				logger.fatal("problem in the topic subscriber creation - " +
	                    " SQLException" + JMSex);
		}
	}
}
