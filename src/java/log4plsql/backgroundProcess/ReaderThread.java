package log4plsql.backgroundProcess;


/*
 * Copyright (C) LOG4PLSQL project team. All rights reserved.
 *
 * This software is published under the terms of the The LOG4PLSQL 
 * Software License, a copy of which has been included with this
 * distribution in the LICENSE.txt file.  
 * see: <http://log4plsql.sourceforge.net>  */
 
 
import oracle.xml.parser.v2.XMLNode;
import org.apache.log4j.Logger;





/**
 * Thread to drive a database pooling
 * @author 	guillaume Moulard 
 * @version 	1.0   
 * @since       LOG4PLSQL V3.1.2
 */
class ReaderThread extends Thread {

  private  XmlConfig lxmlConfig;
  private  Logger ldbLogger;
  private  QueueRecAsk lQueueReceiverAsk;
  private  QueueRecListen lQueueReceiverListen;
  private  TopicSubAsk lTopicSubscriberAsk;
  private  TopicSubListen lTopicSubscriberListen;


/**
* Drive a connection to database
*/
public ReaderThread (XMLNode xmlNodeConfig,
                        Logger dbLogger ) {
    lxmlConfig = new XmlConfig(xmlNodeConfig); 
 
    ldbLogger = ldbLogger.getLogger("backgroundProcess.ReaderThread");

    lQueueReceiverAsk = new QueueRecAsk( 
            lxmlConfig.getXpathParam("database/source/connection/dburl/text()", "NotExiste"),
            lxmlConfig.getXpathParam("database/source/connection/username/text()", "NotExiste"),
            lxmlConfig.getXpathParam("database/source/connection/password/text()", "NotExiste"),
            lxmlConfig.getXpathParam("database/source/queuename/text()", "NotExiste")
            );
    /*lQueueReceiverListen = new QueueRecListen( 
            lxmlConfig.getXpathParam("database/source/connection/dburl/text()", "NotExiste"),
            lxmlConfig.getXpathParam("database/source/connection/username/text()", "NotExiste"),
            lxmlConfig.getXpathParam("database/source/connection/password/text()", "NotExiste"),
            lxmlConfig.getXpathParam("database/source/queuename/text()", "NotExiste")
            );*/
    
    /*lTopicSubscriberAsk = new TopicSubAsk( 
            lxmlConfig.getXpathParam("database/source/connection/dburl/text()", "NotExiste"),
            lxmlConfig.getXpathParam("database/source/connection/username/text()", "NotExiste"),
            lxmlConfig.getXpathParam("database/source/connection/password/text()", "NotExiste"),
            lxmlConfig.getXpathParam("database/source/queuename/text()", "NotExiste")
            );*/ 
    
    /*lTopicSubscriberListen = new TopicSubListen( 
            lxmlConfig.getXpathParam("database/source/connection/dburl/text()", "NotExiste"),
            lxmlConfig.getXpathParam("database/source/connection/username/text()", "NotExiste"),
            lxmlConfig.getXpathParam("database/source/connection/password/text()", "NotExiste"),
            lxmlConfig.getXpathParam("database/source/queuename/text()", "NotExiste")
            );*/
    
    

    
    
}


/**
* in loop, write a message in database to log4j logger 
*/
  public void run() {
	  
	lQueueReceiverAsk.Receive();
	//lQueueReceiverListen.Listen();
	  
	 // lTopicSubscriberAsk.Receive();
	 //lTopicSubscriberListen.Listen();
	  
	  
	  
  }
	
  
  
}
