-------------------------------------------------------------------
--
--  Nom script         : test log4plsql
--
--  Objectif           : create a generique test package
-------------------------------------------------------------------
--
-- History : who                 created     comment
--     V1    Guillaume Moulard   18-AVR-02   Creation
--     V1.0  Guillaume Moulard   21-AUG-02   add trigger test
--
-------------------------------------------------------------------
/*
 * Copyright (C) LOG4PLSQL project team. All rights reserved.
 *
 * This software is published under the terms of the The LOG4PLSQL 
 * Software License, a copy of which has been included with this
 * distribution in the LICENSE.txt file.  
 * see: <http://log4plsql.sourceforge.net>  */
 
set linesize 200
set pagesize 2000


create or replace function func_test return number
is
    begin
    PLOG.purge;
    PLOG.debug;
    PLOG.info;
    PLOG.warn;
    PLOG.error;
    return 1;
end func_test;
/

create or replace procedure proc_test 
is
ret number;
myLogCtx PLOGPARAM.LOG_CTX := PLOG.init;
begin
    ret := func_test;
    PLOG.error (myLogCtx, 'mess error with ctx in proc_test ');
    PLOG.error ('mess error no ctx in proc_test ');
end;
/

drop table t_essais
/

create table t_essais
(
    data varchar2(255)
)
/

CREATE OR REPLACE TRIGGER  LOG_DML BEFORE
INSERT OR UPDATE OR DELETE 
ON T_ESSAIS FOR EACH ROW 
BEGIN
     IF DELETING OR UPDATING THEN 
         PLOG.INFO('T_ESSAIS:OLD:'||USER||':'||:old.data);
     END IF; 
    
     IF INSERTING OR UPDATING THEN 
          PLOG.INFO('T_ESSAIS:NEW:'||USER||':'||:new.data);
     END IF;
end;
/


create or replace package package_test 
is
procedure aproc;
end package_test;
/

create or replace package body package_test  
is
procedure aproc
is
    myLogCtx  PLOGPARAM.LOG_CTX := PLOG.init;
    myLogCtx1 PLOGPARAM.LOG_CTX := PLOG.init('TEST1');
begin
    plog.PURGE;
    proc_test;
    PLOG.error (myLogCtx, 'mess error with ctx in package_test');
    PLOG.error (myLogCtx1, 'mess error with ctx1 in package_test');
    PLOG.error ('mess error no ctx');

    insert into t_essais (DATA) values ('My data'||sysdate);
    update t_essais set data = data || 'upd'||sysdate;
end;
end package_test;
/


EXEC package_test.aproc;

exec PLOG.INFO('end');


select * from vlog;


/* 
LOG
------------------------------------------------------------------
[Jun 05, 10:33:17:40][INFO][PL][plog.purge][Purge by user:PL]
[Jun 05, 10:33:17:40][DEBUG][PL][block-->PL.PACKAGE_TEST-->PL.PROC_TEST-->PL.FUNC_TEST][SQLCODE:0 SQLERRM:ORA-0000: normal, successful completion]
[Jun 05, 10:33:17:40][INFO][PL][block-->PL.PACKAGE_TEST-->PL.PROC_TEST-->PL.FUNC_TEST][SQLCODE:0 SQLERRM:ORA-0000: normal, successful completion]
[Jun 05, 10:33:17:40][WARN][PL][block-->PL.PACKAGE_TEST-->PL.PROC_TEST-->PL.FUNC_TEST][SQLCODE:0 SQLERRM:ORA-0000: normal, successful completion]
[Jun 05, 10:33:17:40][ERROR][PL][block-->PL.PACKAGE_TEST-->PL.PROC_TEST-->PL.FUNC_TEST][SQLCODE:0 SQLERRM:ORA-0000: normal, successful completion]
[Jun 05, 10:33:17:40][ERROR][PL][block-->PL.PACKAGE_TEST-->PL.PROC_TEST][mess error with ctxin proc_test ]
[Jun 05, 10:33:17:40][ERROR][PL][block-->PL.PACKAGE_TEST-->PL.PROC_TEST][mess error no ctx in proc_test ]
[Jun 05, 10:33:17:41][ERROR][PL][block-->PL.PACKAGE_TEST][mess error with ctx in package_test]
[Jun 05, 10:33:17:41][ERROR][PL][TEST1][mess error with ctx1 in package_test]
[Jun 05, 10:33:17:41][ERROR][PL][block-->PL.PACKAGE_TEST][mess error no ctx]
[Jun 05, 10:33:17:41][INFO][PL][block-->PL.PACKAGE_TEST-->PL.LOG_DML][T_ESSAIS:NEW:PL:My data05-JUN-08]
[Jun 05, 10:33:17:42][INFO][PL][block-->PL.PACKAGE_TEST-->PL.LOG_DML][T_ESSAIS:OLD:PL:My data05-JUN-08]
[Jun 05, 10:33:17:42][INFO][PL][block-->PL.PACKAGE_TEST-->PL.LOG_DML][T_ESSAIS:NEW:PL:My data05-JUN-08upd05-JUN-08]
[Jun 05, 10:33:17:42][INFO][PL][block][end]

14 rows selected.                                                                                                                                                     

17 ligne(s) sélectionnée(s).

*/




-------------------------------------------------------------------
-- End of document
-------------------------------------------------------------------

