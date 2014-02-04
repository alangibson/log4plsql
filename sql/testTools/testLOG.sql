/*
Feature tested

PLOG
    SQLERRM, default values
    full_call_stack
*/

set linesize 3000
exec PLOG.PURGE;

exec plog.info;

create or replace procedure TestProc is
I number;
BEGIN
    plog.info('this select raise ORA-01403:No Data Found');    
    select id into i from tlog where id = -1;
    exception 
        when others then
        plog.error;
        plog.full_call_stack;
END;
/

create or replace procedure CallTestProc is
BEGIN
    TestProc;
END;
/


exec CallTestProc;

SELECT * from vlog
/

/*

SQL>
SQL> set linesize 3000
SQL> exec PLOG.PURGE;

ProcÚdure PL/SQL terminÚe avec succÞs.

SQL>
SQL> exec plog.info;

ProcÚdure PL/SQL terminÚe avec succÞs.

SQL>
SQL> create or replace procedure TestProc is
  2  I number;
  3  BEGIN
  4      plog.info('this select raise ORA-01403:No Data Found');
  5      select id into i from tlog where id = -1;
  6      exception
  7          when others then
  8          plog.error;
  9          plog.full_call_stack;
 10  END;
 11  /

ProcÚdure crÚÚe.

SQL>
SQL> create or replace procedure CallTestProc is
  2  BEGIN
  3      TestProc;
  4  END;
  5  /

ProcÚdure crÚÚe.

SQL>
SQL>
SQL> exec CallTestProc;

ProcÚdure PL/SQL terminÚe avec succÞs.

SQL>
SQL> SELECT * from vlog
  2  /

LOG

[Aou 14, 14:59:54:99][OFF][ULOG][plog.purge][Purge By ULOG]
[Aou 14, 14:59:54:14][INFO][ULOG][block][SQLCODE:0 SQLERRM:ORA-0000: normal, successful completion]
[Aou 14, 14:59:57:18][INFO][ULOG][block.ULOG.CALLTESTPROC.ULOG.TESTPROC][this select raise ORA-01403:No Data Found]
[Aou 14, 14:59:57:19][ERROR][ULOG][block.ULOG.CALLTESTPROC.ULOG.TESTPROC][SQLCODE:100 SQLERRM:ORA-01403: Aucune donnÚe trouvÚe]
[Aou 14, 14:59:57:19][ERROR][ULOG][block.ULOG.CALLTESTPROC][----- PL/SQL Call Stack -----
  object      line  object
  handle    number  name
7ABFF28C       925  package body ULOG.PLOG
7ABFF28C       916  package body ULOG.PLOG
7A75141C         9  procedure ULOG.TESTPROC
7A77620C         3  procedure ULOG.CALLTESTPROC

LOG

7A745B08         1  anonymous block
]


SQL>
SQL>
*/