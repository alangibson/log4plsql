
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
import org.apache.log4j.PropertyConfigurator;
import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.xml.DOMConfigurator;
import org.w3c.dom.NodeList;


/**
 * Main Classe of backgroundProcess <BR>
 * Start With : java -classic log4plsql.backgroundProcess.Run .\properties\log4plsql.properties 
 * @author 	guillaume Moulard 
 * @version 	1.1   
 * @since       LOG4PLSQL V3.1.2
 * 
 */

public class Run 
{
  private static XmlConfig xmlConfig;
  private static Logger dbLogger = Logger.getLogger("backgroundProcess");

/** 
* Run  start a backgroundProcess
*/
  public Run(String[] args)
  {

  // look for parameter file
  String log4plsqlProperties = "log4plsql.xml";
  if(args.length != 1) {
    log4plsqlProperties = "log4plsql.xml";
  } else {
    log4plsqlProperties = args[0];     
  }
  xmlConfig = new XmlConfig(log4plsqlProperties);
  String log4jProperties = xmlConfig.getXpathParam("/log4plsql/log4jParameterUseBybackgroundProcess/fileName/@name", "NotExiste"); 

  // bgLogger configuration
  String ltC = xmlConfig.getXpathParam("/log4plsql/log4jParameterUseBybackgroundProcess/typeConfigurator/@confType", "BasicConfigurator");
  if (ltC.compareToIgnoreCase("PropertyConfigurator")==0)
        PropertyConfigurator.configureAndWatch(log4jProperties); 
  else if (ltC.compareToIgnoreCase("DOMConfigurator")==0) 
        DOMConfigurator.configureAndWatch(log4jProperties);
  else
        BasicConfigurator.configure();
           
  dbLogger.info("start log4plsql.properties: " + log4plsqlProperties);
  dbLogger.debug("log4j.properties (/log4plsql/log4jParameterUseBybackgroundProcess/fileName/@name) : " + log4jProperties);
  }
                         
  public static void main(String[] args)
  {  
      Run run = new Run(args);
       
     try {
     
      XMLNode lstLogSourceNode = (XMLNode) xmlConfig.getNode("/log4plsql");
      NodeList listLogSource = lstLogSourceNode.selectNodes("logSource");
      XMLNode theLogSource;
      dbLogger.debug("Nbr backgroundProcess to launch :"+listLogSource.getLength());
      if (listLogSource.getLength() < 1 )
        dbLogger.error("No backgroundProcess to launch");
      for (int i=0; i<listLogSource.getLength(); i++){
        dbLogger.debug("start " + i + " backgroundProcess");
        theLogSource = (XMLNode) listLogSource.item(i);
        ReaderThread theReaderDBThread = new ReaderThread(theLogSource, dbLogger);     
        theReaderDBThread.start();
        }
    } catch (Exception e) {
      dbLogger.error(e.toString());
    }
  }
}