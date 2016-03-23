-------------------------------------------------------------------
--
--  File : create_table_tlog.sql (SQLPlus script)
--
--  Description : creation of the table TLOG
-------------------------------------------------------------------
--
-- history : who                 created     comment
--     v1    Bertrand Caradec   15-MAY-08    creation
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

-- drop table tlog;

-- Create table if it not exists
declare
  l$cnt integer := 0;

  l$sql varchar2(1024) := '
CREATE TABLE TLOG
(
  ID            NUMBER, 
  LDATE         TIMESTAMP DEFAULT SYSTIMESTAMP, 
  LHSECS        NUMBER(38), 
  LLEVEL        NUMBER(38), 
  LSECTION      VARCHAR2(2000 BYTE), 
  LTEXT         VARCHAR2(4000 BYTE), 
  LUSER         VARCHAR2(30 BYTE), 
  LINSTANCE     NUMBER(38) DEFAULT SYS_CONTEXT(''USERENV'', ''INSTANCE''),
  LSID          NUMBER, 
  LXML          SYS.XMLTYPE DEFAULT NULL,
  CONSTRAINT   PK_STG PRIMARY KEY (ID))
';
begin
  select count(1) into l$cnt
    from user_tables
   where table_name = 'TLOG';
   
   if l$cnt = 0 then
     begin
       execute immediate l$sql;
       dbms_output.put_line( ' Table TLOG created' );
     end;
   else
       dbms_output.put_line( ' Table TLOG already exists' );

       -- Check for new column LSID
       select count(1) into l$cnt
         from user_tab_columns
        where table_name =  'TLOG'
          and column_name = 'LSID';

       if l$cnt = 0 then
            execute immediate 'alter table TLOG add (LSID NUMBER)';
            dbms_output.put_line( ' Table TLOG modified: added LSID column' );
        end if;

   end if;
end;
/


COMMENT ON TABLE TLOG IS 'Table to keep logging messages in database';

COMMENT ON COLUMN TLOG.ID IS 'Record identifier';

COMMENT ON COLUMN TLOG.LDATE IS 'Date of the log message (SYSTIMESTAMP)';

COMMENT ON COLUMN TLOG.LHSECS IS 'Number of seconds since the beginning of the epoch';

COMMENT ON COLUMN TLOG.LLEVEL IS 'Log level as numeric value';

COMMENT ON COLUMN TLOG.LSECTION IS 'Formated call stack';

COMMENT ON COLUMN TLOG.LUSER IS 'Database user (SYSUSER)';

COMMENT ON COLUMN TLOG.LINSTANCE IS 'The instance identification number of the current instance';

COMMENT ON COLUMN TLOG.LSID IS 'Oracle session identifier';

COMMENT ON COLUMN TLOG.LXML IS 'XML data. Primarily for logging webservice calls';

