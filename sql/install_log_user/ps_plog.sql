create or replace
PACKAGE             PLOG IS

--*******************************************************************************
--   NAME:   PLOG (specification)
--
--   Main package for the logging. This package provides to PL/SQL application
--   developers functions for logging with different levels: info, debug, error (...).
--   The developer can specify a log context when calling log functions (log level,
--   output types ...). If no context is given, default values defined in the
--   package PLOGPARAM are used.
--   Every call to a log function will use the log() function of the package
--   PLOG_INTERFACE which dispatchs the log information into several outputs.
--
--
--   Version   who               date      comment
--   -----  ----------  ----------------  ---------------------------------------
--   V0       Guillaume Moulard  08-AVR-98 Creation
--   V1       Guillaume Moulard  16-AVR-02 Add DBMS_PIPE funtionnality
--   V1.1     Guillaume Moulard  16-AVR-02 Increase a date log precision for bench user hundredths of seconds of V$TIMER
--   V2.0     Guillaume Moulard  07-MAY-02 Extend call prototype for more by add a default value
--   V2.1     Guillaume Moulard  07-MAY-02 optimisation for purge process
--   V2.1.1   Guillaume Moulard  22-NOV-02 patch bug length message identify by Lu Cheng
--   V2.2     Guillaume Moulard  23-APR-03 use automuns_transaction use Dan Catalin proposition
--   V2.3     Guillaume Moulard  30-APR-03 Add is[Debug|Info|Warn|Error]Enabled requested by Dan Catalin
--   V2.3.1   jan-pieter         27-JUN-03 supp to_char(to_char line ( line 219 )
--   V3       Guillaume Moulard  05-AUG-03 update default value of PLOGPARAM.DEFAULT_LEVEL -> DEBUG
--                                     new: log in alert.log, trace file (thank to andreAs for information)
--                                     new: log with DBMS_OUTPUT (Wait -> SET SERVEROUTPUT ON)
--                                     new: log full_call_stack
--                                     upd: now is possible to log in table and in log4j
--                                     upd: ctx and init funtion parameter.
--                                     new: getLOG4PLSQVersion return string Version
--                                     use dynamique *upd: create of PLOGPARAM for updatable parameter
--                                     new: getLevelInText return the text level for one level
--                                     **************************************************************
--                                     I read a very interesting article write by Steven Feuerstein
--                                     - Handling Exceptional Behavior -
--                                     this 2 new features is inspired direcly by this article
--                                     **************************************************************
--                                     new: assert procedure
--                                     new: new procedure error prototype from log SQLCODE and SQLERRM
--   V3.1     Guillaume Moulard  23-DEC-03 add functions for customize the log level
--   V3.1.1   Guillaume Moulard  29-JAN-04 increase perf : propose by Detlef
--   V3.1.2   Guillaume Moulard  02-FEV-04 *new: Log4JbackgroundProcess create a thread for each database connexion
--   V3.1.2   Guillaume Moulard   02-FEV-04 *new: Log4JbackgroundProcess create a thread for each database connexion
--   V3.1.2.1 Guillaume Moulard 12-FEV-04 *BUG: bad version number, bad log with purge and isXxxxEnabled Tx to Pascal  Mwakuye
--   V3.1.2.2 Guillaume Moulard 27-FEV-04 *BUG: pbs with call stack
--   V3.2     Greg Woolsey      29-MAR-04 add MDC (Mapped Domain Context) Feature
--   V3.1.2.3 Sharada           29-AUG-06 add log when there is a problem whith a pipe
--   V3.3     Bertrand Caradec  22-APR-08 software logic divided in several packages
--                                        output french comments translated in english
--                                        comments added for each function

/*
 * Copyright (C) LOG4PLSQL project team. All rights reserved.
 *
 * This software is published under the terms of the The LOG4PLSQL
 * Software License, a copy of which has been included with this
 * distribution in the LICENSE.txt file.
 * see: <http://log4plsql.sourceforge.net>  */
-------------------------------------------------------------------




-------------------------------------------------------------------
-- Constants (no modification please)
-------------------------------------------------------------------

NOLEVEL         CONSTANT NUMBER       := -999.99 ;

------------------------------------------------------------------
-- Constants (tools internal parameter)
-------------------------------------------------------------------

-- The OFF has the highest possible rank and is intended to turn off logging.
LOFF   CONSTANT number := 10 ;
-- The FATAL level designates very severe error events that will presumably lead the application to abort.
LFATAL CONSTANT number := 20 ;
-- The ERROR level designates error events that might still allow the application  to continue running.
LERROR CONSTANT number := 30 ;
-- The WARN level designates potentially harmful situations.
LWARN  CONSTANT number := 40 ;
-- The INFO level designates informational messages that highlight the progress of the application at coarse-grained level.
LINFO  CONSTANT number := 50 ;
-- The DEBUG Level designates fine-grained informational events that are most useful to debug an application.
LDEBUG CONSTANT number := 60 ;
-- The ALL has the lowest possible rank and is intended to turn on all logging.
LALL   CONSTANT number := 70 ;

PROCEDURE debug
(
    pTEXT      IN TLOG.LTEXT%TYPE DEFAULT NULL
);

PROCEDURE debug
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pTEXT       IN TLOG.LTEXT%TYPE DEFAULT NULL
);


PROCEDURE info
(
    pTEXT      IN TLOG.LTEXT%TYPE DEFAULT NULL
);
PROCEDURE info
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pTEXT      IN TLOG.LTEXT%TYPE DEFAULT NULL
);


PROCEDURE warn
(
    pTEXT      IN TLOG.LTEXT%TYPE DEFAULT NULL
);
PROCEDURE warn
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pTEXT       IN TLOG.LTEXT%TYPE DEFAULT NULL
);


PROCEDURE error
(
    pTEXT      IN TLOG.LTEXT%TYPE DEFAULT NULL
);


PROCEDURE error
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pTEXT       IN TLOG.LTEXT%TYPE DEFAULT NULL
);

PROCEDURE fatal
(
    pTEXT      IN TLOG.LTEXT%TYPE DEFAULT NULL
);
PROCEDURE fatal
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pTEXT       IN TLOG.LTEXT%TYPE DEFAULT NULL
);


PROCEDURE log
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pLEVEL      IN TLOG.LLEVEL%TYPE,
    pTEXT       IN TLOG.LTEXT%TYPE DEFAULT NULL
);

PROCEDURE log
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pLEVEL      IN TLOGLEVEL.LCODE%TYPE,
    pTEXT       IN TLOG.LTEXT%TYPE DEFAULT NULL
);
PROCEDURE log
(
    pLEVEL      IN TLOG.LLEVEL%TYPE,
    pTEXT       IN TLOG.LTEXT%TYPE DEFAULT NULL
);

PROCEDURE log
(
    pLEVEL      IN TLOGLEVEL.LCODE%TYPE,
    pTEXT       IN TLOG.LTEXT%TYPE DEFAULT NULL
) ;




FUNCTION init
(
    pSECTION        IN TLOG.LSECTION%TYPE DEFAULT NULL ,
    pLEVEL          IN TLOG.LLEVEL%TYPE DEFAULT PLOGPARAM.DEFAULT_LEVEL,
    pLOG4J          IN BOOLEAN            DEFAULT PLOGPARAM.DEFAULT_USE_LOG4J,
    pLOGTABLE       IN BOOLEAN            DEFAULT PLOGPARAM.DEFAULT_LOG_TABLE,
    pOUT_TRANS      IN BOOLEAN            DEFAULT PLOGPARAM.DEFAULT_LOG_OUT_TRANS,
    pALERT          IN BOOLEAN            DEFAULT PLOGPARAM.DEFAULT_LOG_ALERT,
    pTRACE          IN BOOLEAN            DEFAULT PLOGPARAM.DEFAULT_LOG_TRACE,
    pDBMS_OUTPUT    IN BOOLEAN            DEFAULT PLOGPARAM.DEFAULT_DBMS_OUTPUT,
    pSESSION        IN BOOLEAN            DEFAULT PLOGPARAM.DEFAULT_SESSION,
    pDBMS_OUTPUT_WRAP IN PLS_INTEGER      DEFAULT PLOGPARAM.DEFAULT_DBMS_OUTPUT_LINE_WRAP
)
RETURN PLOGPARAM.LOG_CTX;





PROCEDURE setBeginSection
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pSECTION      IN       TLOG.LSECTION%TYPE
);


FUNCTION getSection
(
    pCTX        IN PLOGPARAM.LOG_CTX
)
RETURN TLOG.LSECTION%TYPE;

FUNCTION getSection
RETURN TLOG.LSECTION%TYPE;


PROCEDURE setEndSection
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pSECTION      IN       TLOG.LSECTION%TYPE DEFAULT 'EndAllSection'
);






PROCEDURE setLevel
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pLEVEL        IN TLOG.LLEVEL %TYPE DEFAULT NOLEVEL
);

PROCEDURE setLevel
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pLEVEL        IN TLOGLEVEL.LCODE%TYPE
);


FUNCTION getLevel
(
    pCTX        IN PLOGPARAM.LOG_CTX
)
RETURN TLOG.LLEVEL%TYPE;


FUNCTION getLevel
RETURN TLOG.LLEVEL %TYPE;



FUNCTION isDebugEnabled
(
    pCTX        IN  PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN;


FUNCTION isDebugEnabled
RETURN BOOLEAN;




FUNCTION isInfoEnabled
(
    pCTX        IN  PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN;


FUNCTION isInfoEnabled
RETURN BOOLEAN;




FUNCTION isWarnEnabled
(
    pCTX        IN  PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN;


FUNCTION isWarnEnabled
RETURN BOOLEAN;


FUNCTION isErrorEnabled
(
    pCTX        IN PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN;


FUNCTION isErrorEnabled
RETURN BOOLEAN;


FUNCTION isFatalEnabled
(
    pCTX        IN PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN;


FUNCTION isFatalEnabled
RETURN BOOLEAN;


PROCEDURE setTransactionMode
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pOutTransaction IN BOOLEAN DEFAULT TRUE
);


FUNCTION getTransactionMode
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN;

FUNCTION getTransactionMode
RETURN BOOLEAN;

PROCEDURE setLOG_TABLEMode
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX                      ,
    pInLogTable       IN BOOLEAN DEFAULT TRUE
);


FUNCTION getLOG_TABLEMode
(
    pCTX        IN PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN;

FUNCTION getLOG_TABLEMode
RETURN BOOLEAN;


PROCEDURE setDBMS_OUTPUTMode
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    inDBMS_OUTPUT IN BOOLEAN DEFAULT TRUE
);


FUNCTION getDBMS_OUTPUTMode 
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN;

FUNCTION getDBMS_OUTPUTMode
RETURN BOOLEAN;


PROCEDURE setUSE_LOG4JMode
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    inUSE_LOG4J   IN BOOLEAN DEFAULT TRUE
);


FUNCTION getUSE_LOG4JMode 
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN;

FUNCTION getUSE_LOG4JMode
RETURN BOOLEAN;


PROCEDURE setLOG_AlertMode
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    inLOG_ALERT   IN BOOLEAN DEFAULT TRUE
);


FUNCTION getLOG_AlertMode
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN;

FUNCTION getLOG_AlertMode
RETURN BOOLEAN;



PROCEDURE setLOG_TraceMode
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    inLOG_Trace   IN BOOLEAN DEFAULT TRUE
);


FUNCTION getLOG_TraceMode
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN;

FUNCTION getLOG_TraceMode
RETURN BOOLEAN;


PROCEDURE setLOG_SessionMode
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    inLOG_Session   IN BOOLEAN DEFAULT TRUE
);


FUNCTION getLOG_SessionMode
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN;

FUNCTION getLOG_SessionMode
RETURN BOOLEAN;


PROCEDURE assert (
    pCONDITION               IN BOOLEAN                                   ,
    pLogErrorMessageIfFALSE  IN VARCHAR2 DEFAULT 'assert condition error' ,
    pLogErrorCodeIfFALSE     IN NUMBER   DEFAULT -20000                   ,
    pRaiseExceptionIfFALSE   IN BOOLEAN  DEFAULT FALSE                    ,
    pLogErrorReplaceError    in BOOLEAN  DEFAULT FALSE
);

PROCEDURE assert (
    pCTX                     IN OUT NOCOPY PLOGPARAM.LOG_CTX                        ,
    pCONDITION               IN BOOLEAN                                   ,
    pLogErrorMessageIfFALSE  IN VARCHAR2 DEFAULT 'assert condition error' ,
    pLogErrorCodeIfFALSE     IN NUMBER   DEFAULT -20000                   ,
    pRaiseExceptionIfFALSE   IN BOOLEAN  DEFAULT FALSE                    ,
    pLogErrorReplaceError    in BOOLEAN  DEFAULT FALSE
);

PROCEDURE full_call_stack;
PROCEDURE full_call_stack (
    pCTX                     IN OUT NOCOPY PLOGPARAM.LOG_CTX
);

PROCEDURE full_error_backtrace;
PROCEDURE full_error_backtrace (
    pCTX                     IN OUT NOCOPY PLOGPARAM.LOG_CTX
);

FUNCTION getLOG4PLSQVersion RETURN VARCHAR2;

PROCEDURE purge
(
    pDateMax      IN DATE DEFAULT NULL
);

END;
/
