-------------------------------------------------------------------
--
--  File : create_type_t_array_log_queue.sql (SQLPlus script)
--
--  Description : creation of the type T_ARRAY_LOG_QUEUE
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


create or replace TYPE T_ARRAY_LOG_QUEUE AS TABLE OF T_LOG_QUEUE;
/
