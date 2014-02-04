package log4plsql.backgroundProcess;

/* Class TopicSubAsk
 * 
 * Topic subscriber receiving messages synchronously using the receive call
 * 
 */

import javax.jms.JMSException;
import javax.jms.Message;

import oracle.jms.AQjmsSession;

import org.apache.log4j.Logger;

public class TopicSubAsk extends TopicSub{
	private Logger logger = Logger.getLogger("backgroundProcess.TopicSubAsk");
	
	public TopicSubAsk (String pJDBC, String pDBUser, String pDBPass, String pQueueName)
	{
		super(pJDBC, pDBUser, pDBPass, pQueueName);
	}
	
	public void Receive()
	{
		Message JmsMsg;
		Log4jMsg Log4jMsg; 
		
		if (dbConn.connected == false)
		{
			logger.fatal("Connection not established - Impossible to receive");
			return;
		}
		
		// asking for new messages in a never ended loop
		try{
			while (true)
			{
				JmsMsg = tsubscriber.receive();
				
				// create the log4j message
				Log4jMsg = new Log4jMsg(JmsMsg, htLevels);
				Log4jMsg.Create();
				
				// commit the reception
		        ((AQjmsSession)dbConn.tsess).commit();
		        
		    } 
		}
		catch (JMSException JMSex) {
				logger.fatal("JMS error during receiving message - " +
	                    " JMSException" + JMSex);
		}
		catch (Exception ex) {
				logger.fatal("Error during receiving message - " +
	                    " Exception" + ex);
		}
		finally
		{
			try { tsubscriber.close(); } catch (Exception e) { }
			dbConn.disconnect_topic();
		}
	}
}

