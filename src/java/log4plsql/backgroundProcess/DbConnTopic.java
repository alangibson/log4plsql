package log4plsql.backgroundProcess;

/* Class DbConnTopic
 * 
 *  Connection to a topic using the JMS libraries
 * 
 */

import javax.jms.*;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;

import oracle.jms.AQjmsFactory;
import oracle.jms.AQjmsSession;

public class DbConnTopic extends DbConn{
	private Logger logger = Logger.getLogger("backgroundProcess.DbConnTopic");
	  
	TopicConnectionFactory tcfact =null;
	TopicConnection tconn =null;
	TopicSession tsess =null;
	Topic topic = null;
	TopicSubscriber treceiver = null;
	Message msg = null;
	 

	public DbConnTopic(String pJDBC, String pDBUser, String pDBPass, String pQueueName)
	{
		super(pJDBC, pDBUser, pDBPass, pQueueName);
	}
	
	
	// establish a connection to the Oracle topic using the JMS libraries 
	public boolean connect_topic()
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
				tcfact = AQjmsFactory.getTopicConnectionFactory(HostName, SID, PortNr, "thin");
	        
		         // create connection
		        tconn = tcfact.createTopicConnection(DbUser, DbPass);
		        logger.debug("Queue connection created: " + tconn.toString());
		        
		        // create topic session
		        tsess = tconn.createTopicSession(true, Session.CLIENT_ACKNOWLEDGE);
		        logger.debug("Topic session created: " + tsess.toString());
		        
		        // start connection
		        tconn.start() ;
		        logger.debug("Queue connection started");
		        
		        // get topic
		        topic = ((AQjmsSession)tsess).getTopic(DbUser, QueueName);
		        logger.debug("Got topic= " + topic.toString());
		        
		        
		        connected = true;
		       
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
	
	public void disconnect_topic()
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

