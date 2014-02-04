/*
Feature tested

PLOG
    assert
       features        
*/

set linesize 3000
exec PLOG.PURGE;

create or replace procedure testAssert
IS
    pCTX PLOGPARAM.LOG_CTX;
BEGIN
    PLOG.ASSERT(pCTX, 1>1, '1>1 always false');
    PLOG.ASSERT(1=1, '1=1 never false');
    PLOG.ASSERT(1 is null, '1 is null always false');
    PLOG.ASSERT(NOT 1>1, 'NOT 1>1 never false');
    
    PLOG.ASSERT(1>2, '1>2 always false', -20001,
                pRaiseExceptionIfFALSE=>TRUE ,
                pLogErrorReplaceError=>FALSE);
    PLOG.ASSERT(1>3, 'Never test there is a raise in previous assert');
END testAssert;
/

exec testAssert;


SELECT * from vlog
/


/*
SQL> set linesize 3000
SQL> exec PLOG.PURGE;

ProcÚdure PL/SQL terminÚe avec succÞs.

SQL>
SQL> create or replace procedure testAssert
  2  IS
  3      pCTX PLOG.LOG_CTX;
  4  BEGIN
  5      PLOG.ASSERT(pCTX, 1>1, '1>1 always false');
  6      PLOG.ASSERT(1=1, '1=1 never false');
  7      PLOG.ASSERT(1 is null, '1 is null always false');
  8      PLOG.ASSERT(NOT 1>1, 'NOT 1>1 never false');
  9
 10      PLOG.ASSERT(1>2, '1>2 always false', -20001,
 11                  pRaiseExceptionIfFALSE=>TRUE ,
 12                  pLogErrorReplaceError=>FALSE);
 13      PLOG.ASSERT(1>3, 'Never test there is a raise in previous assert');
 14  END testAssert;
 15  /

ProcÚdure crÚÚe.

SQL>
SQL> exec testAssert;
BEGIN testAssert; END;

*
ERREUR Ó la ligne 1 :
ORA-20001: 1>2 always false
ORA-06512: Ó "ULOG.PLOG", ligne 920
ORA-06512: Ó "ULOG.PLOG", ligne 938
ORA-06512: Ó "SCOTT.TESTASSERT", ligne 10
ORA-06512: Ó ligne 1


SQL>
SQL>
SQL> SELECT * from vlog
  2  /

LOG

[Aou 17, 01:39:44:06][OFF][SCOTT][plog.purge][Purge By SCOTT]
[Aou 17, 01:39:46:57][ERROR][SCOTT][block.SCOTT.TESTASSERT][AAS-20000: 1>1 always false]
[Aou 17, 01:39:46:58][ERROR][SCOTT][block.SCOTT.TESTASSERT][AAS-20000: 1 is null always false]
[Aou 17, 01:39:46:58][ERROR][SCOTT][block.SCOTT.TESTASSERT][AAS-20001: 1>2 always false]

SQL>
*/

