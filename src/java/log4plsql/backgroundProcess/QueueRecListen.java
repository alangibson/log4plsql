package log4plsql.backgroundProcess;

/* Class QueueRecListen
 * 
 * Queue receiver receiving messages asynchronously 
 * using a Message Listener.
 * When a message arrives for the message receiver, 
 * the onMessage method of the class (message listener) 
 * is invoked with the message.
 * 
 */


import oracle.jms.AQjmsSession;
import org.apache.log4j.Logger;
import javax.jms.*;




public class QueueRecListen extends QueueRec implements MessageListener {
	private Logger logger = Logger.getLogger("backgroundProcess.QueueRecListen");
	

	
	public QueueRecListen(String pJDBC, String pDBUser, String pDBPass, String pQueueName)
	{
		super(pJDBC, pDBUser, pDBPass, pQueueName);
	}
	
	public void Listen()
	{
		if (dbConn.connected == false)
		{
			logger.fatal("Connection not established - Impossible to listen");
			return;
		}
		
		
		try{		
			// attach this class as listener of the queue receiver
			qreceiver.setMessageListener(this);
			logger.debug("Message listener created: " + qreceiver.toString());
			
			// never ended loop - wait for messages (event function OnMessage) 
			while(true && dbConn.connected)
			{
				Thread.sleep(1000);
			}
		}
		catch (JMSException JMSex) {
				logger.fatal("problem in the listener creation - " +
	                    " SQLException" + JMSex);
		}
		catch(InterruptedException e) {
			  logger.error(e);  
		}
	}
	
	// event function
	public void onMessage(Message JmsMsg)
	{
		Log4jMsg Log4jMsg; 
		
		try{
			// create the log4j message
			Log4jMsg = new Log4jMsg(JmsMsg, htLevels);
			Log4jMsg.Create();
			
			// commit the reception
			((AQjmsSession)dbConn.tsess).commit();
	        
		}
		catch (JMSException JMSex) {
				logger.fatal("JMS error during receiving message - " +
	                    " JMSException" + JMSex);
		}
		catch (Exception ex) {
				logger.fatal("Error during receiving message - " +
	                    " Exception" + ex);
		}
	}
}
	
	

