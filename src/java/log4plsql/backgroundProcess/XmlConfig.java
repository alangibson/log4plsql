package log4plsql.backgroundProcess;
 
/*
 * Copyright (C) LOG4PLSQL project team. All rights reserved.
 *
 * This software is published under the terms of the The LOG4PLSQL 
 * Software License, a copy of which has been included with this
 * distribution in the LICENSE.txt file.  
 * see: <http://log4plsql.sourceforge.net>  */
 
 
 
import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.NodeList;

import oracle.xml.parser.v2.DOMParser;
import oracle.xml.parser.v2.XMLDocument;
import oracle.xml.parser.v2.XMLNode;
import oracle.xml.parser.v2.XMLAttr;


/**
 * use for load, parse and read a XML propeties file
 * @author 	guillaume Moulard 
 * @version 	2b
 * @since       LOG4PLSQL NEW IN V2.0
 */
public class XmlConfig  {

private static XMLDocument configDoc;
private static XMLNode rootConfigNode;

/** XMLDocument initialisation
*/
  public XmlConfig(String configFileName){
     try {
         DOMParser parser = new DOMParser();
	       URL url = createURL(configFileName);
         parser.setErrorStream(System.err);
         parser.showWarnings(true);
         parser.parse(url);
         configDoc = parser.getDocument();
         rootConfigNode = (XMLNode) configDoc;
     } catch (Exception e) {
         System.out.println(e.toString());
     }
  }

  public XmlConfig(XMLNode node){
     try {
         configDoc = null;
         rootConfigNode =  node;
     } catch (Exception e) {
         System.out.println(e.toString());
     }
  }

  public static String getXpathParam(String xPathPattern) {
      return getXpathParam(xPathPattern, null);
  }

/**
return a string in xPathPattern place <BR>
see : http://www.w3.org/TR/xpath <BR>
for all possible use<BR>
*/
  public static String getXpathParam(String xPathPattern, String defaultValue) {
     String ret= null;
     try {
         ret = rootConfigNode.valueOf(xPathPattern).toString();
     } catch (Exception e) {
         System.out.println(e.toString());
     }
     if (ret.compareTo("")==0) {
       ret = defaultValue;
     }       
     return ret;
  }
  
  public static XMLNode getNode(String xPathPattern) {
     XMLNode ret = null;
     try {
         ret = (XMLNode) rootConfigNode.selectSingleNode(xPathPattern);
     } catch (Exception e) {
         System.out.println(e.toString());
     }
     return ret;
  }
  
/** don't use in normal case <BR>
Is possible to use for : testing<BR>
exemple : java.exe log4plsql.XmlConfig yourXMLFile <BR>
<BR>
In this case, you have a list off possible call Exemple : <BR>
<BR>
(nice for cut and past in the java code.)<BR>
<BR>
--- My XML File ----------<BR>
<?xml version="1.0" encoding="UTF-8" ?><BR>
<log4plsql><BR>
    <log4j><BR>
        <typeConfigurator confType="DOMConfigurator" /><BR>
        <fileName name=".\\properties\\log4j.xml" /><BR>
    </log4j><BR>
    <database><BR>
        <source><BR>
            <connection name="demo"><BR>
              <username>ulog</username><BR>
              <password>ulog</password><BR>
              <dburl>jdbc:oracle:thin:@localhost:1521:ORATEST</dburl><BR>
              <driver>oracle.jdbc.driver.OracleDriver</driver><BR>
            </connection><BR>
        </source><BR>
    </database><BR>
             <BR>
    <paramAction><BR>
        <action name="deleteInDatabase" value="Y" /><BR>
    </paramAction><BR>
             <BR>
</log4plsql><BR>
--- resutl ---------------<BR>
private static XmlConfig xmlConfig;<BR>
xmlConfig = new XmlConfig(log4plsqlProperties);<BR>
String myParam = xmlConfig.getXpathParam("/log4plsql/log4j/typeConfigurator/@confType", "NotExiste"); // = DOMConfigurator<BR>
String myParam = xmlConfig.getXpathParam("/log4plsql/log4j/fileName/@name", "NotExiste"); // = .\\properties\\log4j.xml<BR>
String myParam = xmlConfig.getXpathParam("/log4plsql/database/source/connection/@name", "NotExiste"); // = demo<BR>
String myParam = xmlConfig.getXpathParam("/log4plsql/database/source/connection/username/text()", "NotExiste"); // = ulog<BR>
String myParam = xmlConfig.getXpathParam("/log4plsql/database/source/connection/password/text()", "NotExiste"); // = ulog<BR>
String myParam = xmlConfig.getXpathParam("/log4plsql/database/source/connection/dburl/text()", "NotExiste"); // = jdbc:oracle:thin:@localhost:1521:ORATEST<BR>
String myParam = xmlConfig.getXpathParam("/log4plsql/database/source/connection/driver/text()", "NotExiste"); // = oracle.jdbc.driver.OracleDriver<BR>
String myParam = xmlConfig.getXpathParam("/log4plsql/paramAction/action/@name", "NotExiste"); // = deleteInDatabase<BR>
String myParam = xmlConfig.getXpathParam("/log4plsql/paramAction/action/@value", "NotExiste"); // = N<BR>
--------------------------<BR>
*/
   static public void main(String[] argv)
   {
      try
      {
         XmlConfig xmlConfig = new XmlConfig(argv[0]);
         System.out.println("private static XmlConfig xmlConfig;");
         System.out.println("xmlConfig = new XmlConfig(log4plsqlProperties);");

         if (argv.length == 1){
           infoNode(rootConfigNode , "/");
         }

         if (argv.length == 2){
           showExemple(argv[1]);
         }


    }
      catch (Exception e)
      {
         System.out.println(e.toString());
      }
   }

   private static void showExemple(String test){
          String res = getXpathParam(test, "NotExisteNotExisteNotExisteNotExiste");
          if( res.compareTo("NotExisteNotExisteNotExisteNotExiste") != 0){
              System.out.println( "String myParam = xmlConfig.getXpathParam(\""+test+"\", \"NotExiste\"); // = "+ res ); 
          }

   }
   private static void infoNode(XMLNode n, String xpath){
        try {
          showExemple(xpath + "text()");

          //parcoure des ATTRIBUE 
          NamedNodeMap nnm =  n.getAttributes();
          for (int i = 0; i < nnm.getLength(); i++) {
            XMLAttr att = (XMLAttr) nnm.item(i);
            showExemple(xpath + "@"+att.getExpandedName());
          }
          

          //parcoure des nodes
          NodeList nl =  n.getChildNodes();
          for (int i = 0; i < nl.getLength(); i++) {
             XMLNode theNode = (XMLNode) nl.item(i); 
             if (theNode.getNodeName().compareTo("#text")!=0) {
               if (theNode.getNodeName().compareTo("#document")!=0){
               infoNode(theNode , xpath + theNode.getNodeName()+"/");
               } else {
               infoNode(theNode , xpath );
               }
             }
           }
          } catch ( Exception e) {}
          
   }


   private static URL createURL(String fileName)
   {
      URL url = null;
      try 
      {
         url = new URL(fileName);
      } 
      catch (MalformedURLException ex) 
      {
         File f = new File(fileName);
         try 
         {
            String path = f.getAbsolutePath();
            String fs = System.getProperty("file.separator");
            if (fs.length() == 1)
            {
               char sep = fs.charAt(0);
               if (sep != '/')
                  path = path.replace(sep, '/');
               if (path.charAt(0) != '/')
                  path = '/' + path;
            }
            path = "file://" + path;
            url = new URL(path);
         } 
         catch (MalformedURLException e) 
         {
            System.out.println("Cannot create url for: " + fileName);
            System.exit(0);
         }
      }
      return url;
   }
}
