
package log4plsql.backgroundProcess;

/*
 * Copyright (C) LOG4PLSQL project team. All rights reserved.
 *
 * This software is published under the terms of the The LOG4PLSQL 
 * Software License, a copy of which has been included with this
 * distribution in the LICENSE.txt file.  
 * see: <http://log4plsql.sourceforge.net>  */
 



import org.apache.log4j.Level;
import org.apache.log4j.Logger;



public class DynamicLevel extends Level {

  private static Logger logger = Logger.getLogger("backgroundProcess.DynamicLevel");

  int     dynamicLevelInt = 0 ;
  String  dynamicLevelStr = "";
  int     dynamicLevelSyslogEquiv;

  public DynamicLevel(int level, String strLevel, int syslogEquiv) {
    super(level, strLevel, syslogEquiv);
    logger.debug( "Level Creation name:" + strLevel + 
                  " level:" + level + 
                  " syslogEquiv:" + syslogEquiv);
    dynamicLevelInt         = level;
    dynamicLevelStr         = strLevel;
    dynamicLevelSyslogEquiv = syslogEquiv;
  }
}
  
