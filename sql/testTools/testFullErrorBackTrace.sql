/*
Test the error back trace
Error raised in test_3 (select returns no_data_found) and
is propagated until the exception handler of test_error_backtrace

*/

create or replace procedure test_3 as
  val NUMBER;
begin
  SELECT 1 INTO val 
  FROM DUAL
  WHERE 1 = 2;
end;
/

create or replace procedure test_2 as

begin
  test_3;
end;
/



create or replace procedure test_error_backtrace as
begin
  test_2;
exception
  WHEN OTHERS THEN
    plog.full_error_backtrace;
end;
/




exec plog.purge;
exec test_error_backtrace;

select * from vlog;

/*

Procedure created.


Procedure created.


Procedure created.


PL/SQL procedure successfully completed.


PL/SQL procedure successfully completed.


LOG
--------------------------------------------------------------------------------------------

[Jun 05, 10:04:05:06][INFO][PL][plog.purge][Purge by user:PL]
[Jun 05, 10:04:05:06][ALL][PL][block-->PL.TEST_ERROR_BACKTRACE][SQLCODE:100 SQLERRM:ORA-0140
3: no data found
Error back trace:
at "PL.TEST_3", line 4
at "PL.TEST_2", line 4
at "PL.TEST_ERROR_BACKTRACE", line 3
]


2 rows selected.

*/

