package log4plsql.backgroundProcess;

/* Class QueueRecAsk
 * 
 * Queue receiver receiving messages synchronously using the receive call
 * 
 */

import oracle.jms.AQjmsSession;
import org.apache.log4j.Logger;
import javax.jms.JMSException;
import javax.jms.Message;

public class QueueRecAsk extends QueueRec {
	private Logger logger = Logger.getLogger("backgroundProcess.QueueRecAsk");


	public QueueRecAsk(String pJDBC, String pDBUser, String pDBPass, String pQueueName)
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
				JmsMsg = qreceiver.receive();
				
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
			try { qreceiver.close(); } catch (Exception e) { }
			dbConn.disconnect_queue();
		}
	}
}
