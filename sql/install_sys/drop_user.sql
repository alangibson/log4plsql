-------------------------------------------------------------------
--
--  File : drop_user.sql (SQLPlus script)
--
--  Description : Administrator file.
--                Drop of a user for the log framework.
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

set verify off
--WHENEVER sqlerror exit
--WHENEVER oserror exit

ACCEPT V_USER CHAR PROMPT 'Enter the user name to drop:'

DROP USER &V_USER cascade;

set verify on





   