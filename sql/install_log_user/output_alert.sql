-------------------------------------------------------------------
--
--  File : output_alert.sql (SQLPlus script)
--
--  Description : installation of the package PLOG_OUT_ALERT
--                Note: grant on DBMS_SYSTEM is needed
-------------------------------------------------------------------
--
-- history : who                 created     comment
--     V1    Bertrand Caradec    15-MAY-08   Creation
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


PROMPT Create package PLOG_OUT_ALERT ...

@@ps_plog_out_alert

@@pb_plog_out_alert
