package log4plsql.backgroundProcess;

/* Class QueueRec - Super class for a queue receiver 
 * 
 *  The constructor connects to the queue and creates a
 *  queue receiver.
 * 
 */

import java.util.Hashtable;
import javax.jms.JMSException;
import javax.jms.QueueReceiver;
import oracle.jms.AQjmsSession;
import org.apache.log4j.Logger;

public class QueueRec {
	private Logger logger = Logger.getLogger("backgroundProcess.QueueRec");

	
	Hashtable htLevels;
	DbConnQueue dbConn;
	QueueReceiver qreceiver = null;
	
	public QueueRec(String pJDBC, String pDBUser, String pDBPass, String pQueueName)
	{
		try{
			dbConn = new DbConnQueue(pJDBC, pDBUser, pDBPass, pQueueName);
			// get the mapping table for log levels
			htLevels = dbConn.getLogLevels();
			// connection to the queue
			dbConn.connect_queue();
			if (dbConn.connected)
			{
				// creation of the queue receiver
				qreceiver =  ((AQjmsSession)dbConn.tsess).createReceiver(dbConn.queue, TLogQueue.getORADataFactory());
				logger.debug("Queue receiver created: " + qreceiver.toString());
			}
		}
		catch (JMSException JMSex) {
			logger.fatal("problem in the queue receiver creation - " +
                    " SQLException" + JMSex);
		}
	}
	
}
