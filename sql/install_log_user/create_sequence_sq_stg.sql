-------------------------------------------------------------------
--
--  File : create_sequence_sq_stg.sql (SQLPlus script)
--
--  Description : creation of the sequence SQ_STG
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

-- Create sequence if it not exist
declare
  l$cnt integer := 0;
  l$sql varchar2(1024) := '
CREATE SEQUENCE SQ_STG
  INCREMENT BY 1
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 100
';

begin
  select count(1) into l$cnt
    from user_sequences
   where sequence_name = 'SQ_STG';

   if l$cnt = 0 then
     begin
       execute immediate l$sql;
       dbms_output.put_line( ' Sequence SQ_STG created' );
     end;
   else
       dbms_output.put_line( ' Sequence SQ_STG already exists' );
   end if;
end;
/

