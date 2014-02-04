-------------------------------------------------------------------
--
--  File : insert_into_tloglevel.sql (SQLPlus script)
--
--  Description : insert rows into table TLOGLEVEL
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



insert into TLOGLEVEL (LLEVEL, LJLEVEL,  LCODE , LDESC) Values 
(10,99999,'OFF', 'The OFF has the highest possible rank and is intended to turn off logging.');

insert into TLOGLEVEL (LLEVEL, LJLEVEL,  LCODE , LDESC) Values 
(20,50000,'FATAL', 'The FATAL level designates very severe error events that will presumably lead the application to abort.');

insert into TLOGLEVEL (LLEVEL, LJLEVEL,  LCODE , LDESC) Values 
(30,40000,'ERROR', 'the ERROR level designates error events that might still allow the application  to continue running.');

insert into TLOGLEVEL (LLEVEL, LJLEVEL,  LCODE , LDESC) Values 
(40,30000,'WARN', 'The WARN level designates potentially harmful situations.');

insert into TLOGLEVEL (LLEVEL, LJLEVEL,  LCODE , LDESC) Values 
(50,20000,'INFO', 'The INFO level designates informational messages that highlight the progress of the application at coarse-grained level.');

insert into TLOGLEVEL (LLEVEL, LJLEVEL,  LCODE , LDESC) Values 
(60,10000,'DEBUG', 'The DEBUG Level designates fine-grained informational events that are most useful to debug an application.');

insert into TLOGLEVEL (LLEVEL, LJLEVEL,  LCODE , LDESC) Values 
(70,0,'ALL', 'The ALL has the lowest possible rank and is intended to turn on all logging.');

commit;