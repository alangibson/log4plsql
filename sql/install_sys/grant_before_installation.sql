-------------------------------------------------------------------
--
--  File : grant_before_installation.sql (SQLPlus script)
--
--  Description : Administrator file.
--                Grant Oracle packages to the log user.
-------------------------------------------------------------------
--
-- history : who                 created     comment
--     V3    Bertrand Caradec    15-MAY-08   Creation
--                                     
--
-------------------------------------------------------------------
/*
 * Copyright (C) LOG4PLSQL project team. All rights reserved.
 *
 * This software is published under the terms of the The LOG4PLSQL 
 * Software License, a copy of which has been included with this
 * distribution in the LICENSE.txt file.  
 * see: <http://log4plsql.sourceforge.net>  */


set verify off
ACCEPT V_USER CHAR PROMPT 'Enter the user name:'

-- grant needed to write log messages in alert.log or trace files 
GRANT EXECUTE ON DBMS_SYSTEM TO &V_USER;  

-- following grant needed for the optional output 
-- in advanded queue (AQ) consumed by the log4j background process 
GRANT EXECUTE ON DBMS_AQ TO &V_USER;
GRANT EXECUTE ON DBMS_AQADM TO &V_USER;
GRANT EXECUTE ON DBMS_AQIN TO &V_USER;
GRANT EXECUTE ON DBMS_AQJMS TO &V_USER;


set verify on