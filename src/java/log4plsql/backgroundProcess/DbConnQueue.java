package log4plsql.backgroundProcess;

/* Class DbConnQueue
 * 
 *  Connection to a queue using the JMS libraries
 * 
 */

import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.Queue;
import javax.jms.QueueConnection;
import javax.jms.QueueConnectionFactory;
import javax.jms.QueueReceiver;
import javax.jms.QueueSession;
import javax.jms.Session;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;

import oracle.jms.AQjmsFactory;
import oracle.jms.AQjmsSession;

public class DbConnQueue extends DbConn{
	private Logger logger = Logger.getLogger("backgroundProcess.DBConnQueue");
	  
	QueueConnectionFactory tcfact =null;
	QueueConnection tconn =null;
	QueueSession tsess =null;
	Queue queue = null;
	QueueReceiver qreceiver = null;
	Message msg = null;
	    
	 
	public DbConnQueue(String pJDBC, String pDBUser, String pDBPass, String pQueueName)
	{
		super(pJDBC, pDBUser, pDBPass, pQueueName);		
	}
	
	
	
	// establish a connection to the Oracle queue using the JMS libraries 
	public boolean connect_queue()
	{
		connected = false;
		if (formatOK == false)
		{
			logger.log(Level.FATAL, "Connection parameters are not OK");		
		}
		else
		{
			try
			{
				tcfact = AQjmsFactory.getQueueConnectionFactory(HostName, SID, PortNr, "thin");
	        
		         // create connection
		        tconn = tcfact.createQueueConnection(DbUser, DbPass);
		        logger.debug("Queue connection created: " + tconn.toString());
		        
		        // create queue session
		        tsess = tconn.createQueueSession(true, Session.CLIENT_ACKNOWLEDGE);
		        logger.debug("Queue session created: " + tsess.toString());
		        
		        // start connection
		        tconn.start() ;
		        logger.debug("Queue connection started");
		        
		        // get queue
		        queue = ((AQjmsSession)tsess).getQueue(DbUser, QueueName);
		        logger.debug("Got queue= " + queue.toString());
		        
		        
		        super.connected = true;
		       
			}
			catch (JMSException JMSex) {
		         logger.log(Level.FATAL, 
		                              "connectionProblem dbURI:" + JDBCurl + 
		                              " dbUser:" + DbUser + 
		                              " dbPass:" + DbPass + 
		                              " queueName:" + QueueName +
		                              " SQLException" + JMSex);
		    }
		}
	   
		return connected;

	}
	
	public void disconnect_queue()
	{
		try{
		tsess.close();
		tconn.close();
		}
		catch (JMSException JMSex) {
	         logger.log(Level.FATAL, 
	                              "disconnectionProblem dbURL:" + JDBCurl + 
	                              " dbUser:" + DbUser + 
	                              " dbPass:" + DbPass + 
	                              " queueName:" + QueueName +
	                              " SQLException" + JMSex);
	         
	    }
	}
}
