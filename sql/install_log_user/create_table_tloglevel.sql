-------------------------------------------------------------------
--
--  File : create_table_tloglevel.sql (SQLPlus script)
--
--  Description : creation of the table TLOGLEVEL
-------------------------------------------------------------------
--
-- history : who                 created     comment
--     V1    Guillaume Moulard   27-NOV-03   Creation
--     V2    Ramakrishna Allu    29-JAN-05   Add LJLEVEL
--     V3    Bertrand Caradec    15-MAY-08   Name adaptation
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

-- Create table if it not exists
declare
  l$cnt integer := 0;

  l$sql varchar2(1024) := '
CREATE TABLE TLOGLEVEL
(
 LLEVEL       number (4,0),
 LJLEVEL      number (5,0),
 LSYSLOGEQUIV number (4,0),
 LCODE       varchar2(10),
 LDESC        varchar2(255),
 CONSTRAINT pk_TLOGLEVEL PRIMARY KEY (LLEVEL)
)
';
begin
  select count(1) into l$cnt
    from user_tables
   where table_name = 'TLOGLEVEL';
   
   if l$cnt = 0 then
     begin
       execute immediate l$sql;
       dbms_output.put_line( ' Table TLOGLEVEL created' );
     end;
   else
       dbms_output.put_line( ' Table TLOGLEVEL already exists' );
   end if;
end;
/


