/*
Feature tested

PLOG
    Purge
    debug 
    Info 
    FATAL
    IsXxxxxxEnable
    SetLevel

VIEW
LOG without backgroundProcess
Muti context
 
*/




set linesize 3000
begin 
    PLOG.PURGE;
end;
/
    
declare
    pCTX_DEBUG PLOGPARAM.LOG_CTX := PLOG.init('debugLevel', PLOG.LDEBUG);
    pCTX       PLOGPARAM.LOG_CTX := PLOG.init('workLevel', PLOG.LALL);
begin 
    PLOG.debug (pCTX_DEBUG, 'Generic        level : '|| PLOG.getLevel);
    PLOG.debug (pCTX_DEBUG, 'LOG_CTX_DEBUG  level : '|| PLOG.getLevel (pCTX_DEBUG));
    PLOG.debug (pCTX_DEBUG, 'LOG_CTX        level : '|| PLOG.getLevel (pCTX));

    IF  PLOG.isDebugEnabled(pCTX)  then
        PLOG.debug (pCTX, 'The best way for debug : test with isDebugEnabled befort log');
    END IF;

    IF  PLOG.isInfoEnabled(pCTX)  then
        PLOG.Info (pCTX, 'this message is log because you are in debug');
    END IF;

    PLOG.SETLEVEL(pCTX, PLOG.LINFO );
    IF  PLOG.isDebugEnabled(pCTX)  then
        PLOG.FATAL (pCTX, 'Never log');
    ELSE 
        PLOG.debug (pCTX_DEBUG, 'LOG_CTX        level : '|| PLOG.getLevel (pCTX));
    END IF;

    PLOG.DEBUG (pCTX, 'this message is never log ');

    PLOG.SETLEVEL(pCTX, PLOG.LWARN );
    IF  PLOG.isInfoEnabled(pCTX)  then
        PLOG.FATAL (pCTX, 'Never log');
    ELSE 
        PLOG.debug (pCTX_DEBUG, 'LOG_CTX        level : '|| PLOG.getLevel (pCTX));
    END IF;

    PLOG.SETLEVEL(pCTX, PLOG.LERROR);
    IF  PLOG.isWarnEnabled(pCTX)  then
        PLOG.FATAL (pCTX, 'Never log');
    ELSE 
        PLOG.debug (pCTX_DEBUG, 'LOG_CTX        level : '|| PLOG.getLevel (pCTX));
    END IF;

    PLOG.SETLEVEL(pCTX, PLOG.LFATAL);
    IF  PLOG.isErrorEnabled(pCTX)  then
        PLOG.FATAL (pCTX, 'Never log');
    ELSE 
        PLOG.debug (pCTX_DEBUG, 'LOG_CTX        level : '|| PLOG.getLevel (pCTX));
    END IF;

    PLOG.SETLEVEL(pCTX, PLOG.LOFF);
    IF  PLOG.isFatalEnabled(pCTX)  then
        PLOG.FATAL (pCTX, 'Never log');
    ELSE 
        PLOG.debug (pCTX_DEBUG, 'LOG_CTX        level : '|| PLOG.getLevel (pCTX));
    END IF;



End;
/


select * from vlog;



/*
good result : 
SQL> 
SQL> 
SQL> select * from vlog;

LOG
----------------------------------------------------------------------------------------------------
[07/06 01:37:35: 78][OFF    ][SCOTT][plog.purge][Purge By SCOTT]
[07/06 01:37:37: 32][DEBUG  ][SCOTT][debugLevel][Generic        level : 3]
[07/06 01:37:37: 33][DEBUG  ][SCOTT][debugLevel][LOG_CTX_DEBUG  level : 6]
[07/06 01:37:37: 33][DEBUG  ][SCOTT][debugLevel][LOG_CTX        level : 7]
[07/06 01:37:37: 33][DEBUG  ][SCOTT][workLevel][The best way for debug : test with isDebugEnabled be
[07/06 01:37:37: 33][INFO   ][SCOTT][workLevel][this message is log because you are in debug]
[07/06 01:37:37: 34][DEBUG  ][SCOTT][debugLevel][LOG_CTX        level : 5]
[07/06 01:37:37: 35][DEBUG  ][SCOTT][debugLevel][LOG_CTX        level : 4]
[07/06 01:37:37: 35][DEBUG  ][SCOTT][debugLevel][LOG_CTX        level : 3]
[07/06 01:37:37: 35][DEBUG  ][SCOTT][debugLevel][LOG_CTX        level : 2]
[07/06 01:37:37: 36][DEBUG  ][SCOTT][debugLevel][LOG_CTX        level : 1]

11 ligne(s) sélectionnée(s).

SQL>  
*/