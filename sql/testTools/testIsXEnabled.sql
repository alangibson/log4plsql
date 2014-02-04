/*
Feature tested

PLOG
    isXEnabled
*/

exec PLOG.PURGE;


DECLARE
    pCTX PLOGPARAM.LOG_CTX := PLOG.init (PLEVEL  => PLOG.LALL);
BEGIN
    
-- test without ctx
    IF Plog.isFatalEnabled   THEN
        Plog.FATAL('FATAL mess') ;
    END IF;
    IF Plog.isErrorEnabled THEN
        Plog.ERROR('ERROR mess') ;
    END IF;
    IF Plog.isWarnEnabled  THEN
        Plog.WARN('WARN mess') ;
    END IF;
    IF Plog.isInfoEnabled   THEN
        Plog.INFO('INFO mess') ;
    END IF;
    IF Plog.isDebugEnabled   THEN
        Plog.DEBUG('DEBUG mess') ;
    END IF;

-- test with ctx
    IF Plog.isFatalEnabled(pCTX)   THEN
        Plog.FATAL(pCTX, 'FATAL mess test2') ;
    END IF;
    IF Plog.isErrorEnabled(pCTX) THEN
        Plog.ERROR(pCTX, 'ERROR mess test2') ;
    END IF;
    IF Plog.isWarnEnabled(pCTX)  THEN
        Plog.WARN(pCTX, 'WARN mess test2') ;
    END IF;
    IF Plog.isInfoEnabled(pCTX)   THEN
        Plog.INFO(pCTX, 'INFO mess test2') ;
    END IF;
    IF Plog.isDebugEnabled(pCTX)   THEN
        Plog.DEBUG(pCTX, 'DEBUG mess test2') ;
    END IF;

END ;
/

select * from vlog;


/*
SQL> exec PLOG.PURGE;

ProcÚdure PL/SQL terminÚe avec succÞs.

SQL> select plog.getLOG4PLSQVersion  as Version from dual  ;

VERSION
--------------------------------------------------------------------------------
3.1.2.1

SQL> select plog.getLevelInText(plog.getLevel) from dual;

PLOG.GETLEVELINTEXT(PLOG.GETLEVEL)
--------------------------------------------------------------------------------
ERROR

SQL> DECLARE
  2      pCTX PLOG.LOG_CTX := PLOG.init (PLEVEL  => PLOG.LALL);
  3  BEGIN
  4
  5  -- test without ctx
  6      IF Plog.isFatalEnabled   THEN
  7          Plog.FATAL('FATAL mess') ;
  8      END IF;
  9      IF Plog.isErrorEnabled THEN
 10          Plog.ERROR('ERROR mess') ;
 11      END IF;
 12      IF Plog.isWarnEnabled  THEN
 13          Plog.WARN('WARN mess') ;
 14      END IF;
 15      IF Plog.isInfoEnabled   THEN
 16          Plog.INFO('INFO mess') ;
 17      END IF;
 18      IF Plog.isDebugEnabled   THEN
 19          Plog.DEBUG('DEBUG mess') ;
 20      END IF;
 21
 22  -- test with ctx
 23      IF Plog.isFatalEnabled(pCTX)   THEN
 24          Plog.FATAL(pCTX, 'FATAL mess test2') ;
 25      END IF;
 26      IF Plog.isErrorEnabled(pCTX) THEN
 27          Plog.ERROR(pCTX, 'ERROR mess test2') ;
 28      END IF;
 29      IF Plog.isWarnEnabled(pCTX)  THEN
 30          Plog.WARN(pCTX, 'WARN mess test2') ;
 31      END IF;
 32      IF Plog.isInfoEnabled(pCTX)   THEN
 33          Plog.INFO(pCTX, 'INFO mess test2') ;
 34      END IF;
 35      IF Plog.isDebugEnabled(pCTX)   THEN
 36          Plog.DEBUG(pCTX, 'DEBUG mess test2') ;
 37      END IF;
 38
 39  END ;
 40  /

ProcÚdure PL/SQL terminÚe avec succÞs.

SQL> select * from vlog;

LOG
--------------------------------------------------------------------------------
[Fev 23, 19:12:24:89][INFO][ULOG][plog.purge][Purge by user:ULOG]
[Fev 23, 19:12:36:06][FATAL][ULOG][ anonymous block][FATAL mess]
[Fev 23, 19:12:36:06][ERROR][ULOG][ anonymous block][ERROR mess]
[Fev 23, 19:12:36:06][FATAL][ULOG][ anonymous block][FATAL mess test2]
[Fev 23, 19:12:36:07][ERROR][ULOG][ anonymous block][ERROR mess test2]
[Fev 23, 19:12:36:07][WARN][ULOG][ anonymous block][WARN mess test2]
[Fev 23, 19:12:36:07][INFO][ULOG][ anonymous block][INFO mess test2]
[Fev 23, 19:12:36:07][DEBUG][ULOG][ anonymous block][DEBUG mess test2]

8 ligne(s) sÚlectionnÚe(s).

SQL>


*/