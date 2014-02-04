create or replace
PACKAGE BODY              PLOG IS
--*******************************************************************************
--   NAME:   PLOG (body)
--
--   Main package for the logging. This package provides to PL/SQL application
--   developers functions for logging with different levels: info, debug, error (...).
--   The developer can specify a log context when calling log functions (log level,
--   output types ...). If no context is given, default values defined in the
--   package PLOGPARAM are used.
--   Every call to a log function will use the log() function of the package
--   PLOG_INTERFACE which dispatchs the log information into several outputs.
--
-----------------------------------------------------------------
-- See the history in the specification
-----------------------------------------------------------------
/*
 * Copyright (C) LOG4PLSQL project team. All rights reserved.
 *
 * This software is published under the terms of the The LOG4PLSQL
 * Software License, a copy of which has been included with this
 * distribution in the LICENSE.txt file.
 * see: <http://log4plsql.sourceforge.net>  */
-------------------------------------------------------------------


-- private variables
LOG4PLSQL_VERSION  VARCHAR2(200) := '4.0';

-- constants for appication errors
AE_LEVEL_NOT_EXIST CONSTANT NUMBER  := -20100;
AE_OUTPUT_NOT_INSTALLED CONSTANT NUMBER  := -20200;

FUNCTION isPackageInstalled(pPackageName IN VARCHAR2) RETURN  BOOLEAN;


FUNCTION getNextID RETURN TLOG.ID%type
--******************************************************************************
--   NAME:   getNextID
--
--   Private. Returns the next value of the sequence SQ_STG
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
    temp NUMBER;
BEGIN
     SELECT SQ_STG.nextval INTO temp
     FROM dual;

     RETURN temp;

END getNextID;




FUNCTION getCallStack RETURN VARCHAR2 IS
--******************************************************************************
--   NAME:   getCallStack
--
--   Private. Returns the formated call stack
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
    endOfLine   CONSTANT    CHAR(1) := chr(10);
    endOfField  CONSTANT    CHAR(1) := chr(32);
    nbrLine     NUMBER;
    ptFinLigne  NUMBER;
    ptDebLigne  NUMBER;
    ptDebCode   NUMBER;
    pt1         NUMBER;
    cpt         NUMBER;
    allLines    VARCHAR2(4000);
    v_result    VARCHAR2(4000);
    Line        VARCHAR2(4000);
    UserCode    VARCHAR2(4000);
    myName      VARCHAR2(2000) := '.PLOG';
BEGIN
    allLines    := dbms_utility.format_call_stack;

    cpt         := 2;
    ptFinLigne  := LENGTH(allLines);
    ptDebLigne  := ptFinLigne;

    WHILE ptFinLigne > 0 AND ptDebLigne > 83 LOOP
       ptDebLigne   := INSTR (allLines, endOfLine, -1, cpt) + 1 ;
       cpt          := cpt + 1;
       -- process the line
       Line         := SUBSTR(allLines, ptDebLigne, ptFinLigne - ptDebLigne);
       ptDebCode    := INSTR (Line, endOfField, -1, 1);
       UserCode     := SUBSTR(Line, ptDebCode+1);

       IF INSTR(UserCode,myName) = 0 THEN
           IF cpt > 3 THEN
             v_result := v_result ||'-->';
           END IF;
           v_result := v_result||UserCode;
       END IF;
       ptFinLigne := ptDebLigne - 1;
    END LOOP;

  RETURN v_result;

END getCallStack;



FUNCTION getDefaultContext
--******************************************************************************
--   NAME:   getDefaultContext
--
--   Private. Returns the default context
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
RETURN PLOGPARAM.LOG_CTX
IS
    newCTX      PLOGPARAM.LOG_CTX;
    lSECTION    TLOG.LSECTION%TYPE;
BEGIN
    lSECTION := getCallStack;
    newCTX := init (pSECTION => lSECTION);

    RETURN newCTX;
END getDefaultContext;



PROCEDURE     checkAndInitCTX
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
--******************************************************************************
--   NAME:   checkAndInitCTX
--
--  PARAMETERS:
--
--      pCTX               log context
--
--   Private. Initializes the context parameter with a section equal to
--   the call stack if it is not initialized.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
    lSECTION    TLOG.LSECTION%TYPE;
BEGIN
    IF pCTX.isDefaultInit = FALSE THEN
        lSECTION := getCallStack;
        pCTX := init (pSECTION => lSECTION);
    END IF;
END;





PROCEDURE log
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX                      ,
    pID         IN       TLOG.id%TYPE                      ,
    pLDate      IN       TLOG.ldate%TYPE                   ,
    pLHSECS     IN       TLOG.lhsecs%TYPE                  ,
    pLLEVEL     IN       TLOG.llevel%TYPE                  ,
    pLSECTION   IN       TLOG.lsection%TYPE                ,
    pLUSER      IN       TLOG.luser%TYPE                   ,
    pLTEXT      IN       TLOG.LTEXT%TYPE
)
--******************************************************************************
--   NAME:   log
--
--   PARAMETERS:
--
--      pCTX               log context
--      pID                ID of the log message, generated by the sequence
--      pLDate             Date of the log message (SYSDATE)
--      pLHSECS            Number of seconds since the beginning of the epoch
--      pLLEVEL            Log level as numeric value
--      pLSection          formated call stack
--      pLUSER             database user (SYSUSER)
--      pLTEXT             log text
--
--   Private. Main procedure for logging an event. If the log text is empty, it is
--   automatically filled by the Oracle error code and message. This procedure uses the
--   procedure PLOG_INTERFACE.log() which dispatches the log event to several
--   outputs.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
    LLTEXT TLOG.LTEXT%TYPE;
BEGIN

    IF pCTX.isDefaultInit = FALSE THEN
        error('Context not initialized. Please use PLOG_MAIN.init to initialize it.');
    END IF;

    IF PLTEXT IS NULL THEN
        LLTEXT := 'SQLCODE:'||SQLCODE ||' SQLERRM:'||SQLERRM;
    ELSE
        BEGIN
            LLTEXT := pLTEXT;
        EXCEPTION
            WHEN VALUE_ERROR THEN
                ASSERT (pCTX, length(pLTEXT) <= 2000, 'Log Message id:'||pID||' too long. ');
                LLTEXT := substr(pLTEXT, 0, 2000);
            WHEN OTHERS THEN
                fatal;
        END;

    END IF;

    -- raise exceptions if an output parameter is active but the corespondent package not installed
    IF pCtx.USE_LOG4J THEN
      IF isPackageInstalled('PLOG_OUT_AQ') = FALSE THEN
        RAISE_APPLICATION_ERROR(AE_OUTPUT_NOT_INSTALLED, 'Parameter USE_LOG4J is TRUE but no advanced queue output (package PLOG_OUT_AQ) is installed');
      END IF;
    END IF;

    IF pCtx.USE_ALERT THEN
      IF isPackageInstalled('PLOG_OUT_ALERT') = FALSE THEN
        RAISE_APPLICATION_ERROR(AE_OUTPUT_NOT_INSTALLED, 'Parameter USE_ALERT is TRUE but no alert output (package PLOG_OUT_ALERT) is installed');
      END IF;
    END IF;

    IF pCtx.USE_TRACE THEN
      IF isPackageInstalled('PLOG_OUT_TRACE') = FALSE THEN
        RAISE_APPLICATION_ERROR(AE_OUTPUT_NOT_INSTALLED, 'Parameter USE_TRACE is TRUE but no trace output (package PLOG_OUT_TRACE) is installed');
      END IF;
    END IF;

    IF pCtx.USE_DBMS_OUTPUT THEN
      IF isPackageInstalled('PLOG_OUT_DBMS_OUTPUT') = FALSE THEN
        RAISE_APPLICATION_ERROR(AE_OUTPUT_NOT_INSTALLED, 'Parameter USE_DBMS_OUTPUT is TRUE but no DBMS output (package PLOG_OUT_DBMS_OUTPUT) is installed');
      END IF;
    END IF;

    IF pCtx.USE_SESSION THEN
      IF isPackageInstalled('PLOG_OUT_SESSION') = FALSE THEN
        RAISE_APPLICATION_ERROR(AE_OUTPUT_NOT_INSTALLED, 'Parameter USE_SESSION is TRUE but no session output (package PLOG_OUT_SESSION) is installed');
      END IF;
    END IF;

    -- use the interface package to dispatch the log message in several outputs
    PLOG_INTERFACE.log(pCTX, pID, pLDate, pLHSECS, pLLEVEL, pLSECTION, pLUSER, LLTEXT);

END log;



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
--******************************************************************************
--   NAME:   init
--
--   PARAMETERS:
--
--      pSECTION           log section
--      pLEVEL             log level (Use only for debug)
--      pLOG4J             TRUE: the log is written in a queue read by log4j
--      pLOGTABLE          TRUE: the log is insert into the table TLOG
--      pOUT_TRANS         TRUE: the transaction of the insert into TLOG is autonomous
--                         FALSE: no autonomous transaction for the insert into TLOG
--      pALERT             TRUE: the log is written in alert.log
--      pTRACE             TRUE: the log is written in trace file
--      pDBMS_OUTPUT       TRUE: log is sent to the standard output (DBMS_OUTPUT.PUT_LINE)
--      pSESSION           TRUE: log is written is the view V$SESSION
--      pDBMS_OUTPUT_WRAP  length to wrap output to when using DBMS_OUTPUT
--
--   Public. Initializes a context with special values. A developer can call this
--   function to configure a special log context with parameter values different
--   to the default ones (defined in the package PLOGPARAM)
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
RETURN PLOGPARAM.LOG_CTX
IS
    pCTX       PLOGPARAM.LOG_CTX;
BEGIN

    pCTX.isDefaultInit   := TRUE;
    pCTX.LSection        := nvl(pSECTION, getCallStack);
    pCTX.INIT_LSECTION   := pSECTION;
    pCTX.LLEVEL          := pLEVEL;
    pCTX.INIT_LLEVEL     := pLEVEL;
    pCTX.USE_LOG4J       := pLOG4J;
    pCTX.USE_OUT_TRANS   := pOUT_TRANS;
    pCTX.USE_LOGTABLE    := pLOGTABLE;
    pCTX.USE_ALERT       := pALERT;
    pCTX.USE_TRACE       := pTRACE;
    pCTX.USE_DBMS_OUTPUT := pDBMS_OUTPUT;
    pCTX.USE_SESSION     := pSESSION;
    pCTX.DBMS_OUTPUT_WRAP := pDBMS_OUTPUT_WRAP;

    RETURN pCTX;

END init;


PROCEDURE setBeginSection
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pSECTION      IN       TLOG.lsection%TYPE
)
--******************************************************************************
--   NAME:   setBeginSection
--
--  PARAMETERS:
--
--      pCTX               log context
--      pSection           Section node to add
--
--   Public. Creates a new node in the hierarchical section.
--   The text parameter pSection is added to the log context section.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    checkAndInitCTX(pCTX);
    pCTX.LSection := pCTX.LSection||PLOGPARAM.DEFAULT_Section_sep||pSECTION;

END setBeginSection;

FUNCTION getSection
(
    pCTX        IN PLOGPARAM.LOG_CTX
)
RETURN TLOG.lsection%TYPE
--******************************************************************************
--   NAME:   getSection
--
--   Public. Returns the section of a specific log context
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN

    RETURN pCTX.LSection;

END getSection;



FUNCTION getSection RETURN TLOG.lsection%TYPE
--******************************************************************************
--   NAME:   getSection
--
--   Public. Returns the call stack
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
    generiqueCTX PLOGPARAM.LOG_CTX := getDefaultContext;
BEGIN

    RETURN getSection(pCTX =>generiqueCTX);

END getSection;



PROCEDURE setEndSection
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pSECTION      IN       TLOG.LSECTION%TYPE  DEFAULT 'EndAllSection'
)
--******************************************************************************
--   NAME:   setEndSection
--
--   PARAMETERS:
--
--      pCTX               log context
--      pSection           section node to close
--
--   Public. Closes a section node of a log context. If pSection is left NULL,
--   all nodes are closed.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    checkAndInitCTX(pCTX);
    IF pSECTION = 'EndAllSection' THEN
        pCTX.LSection := nvl(pCTX.INIT_LSECTION, getCallStack);
        RETURN;
    END IF;

    pCTX.LSection := substr(pCTX.LSection,1,instr(UPPER(pCTX.LSection), UPPER(pSECTION), -1)-2);


END setEndSection;


PROCEDURE setTransactionMode
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pOutTransaction IN BOOLEAN DEFAULT TRUE
)
--******************************************************************************
--   NAME:   setTransactionMode
--
--   PARAMETERS:
--
--      pCTX               log context
--      pOutTransaction    TRUE: 'insert into ST_TLOG' statements are in an autonomous transaction
--                         FALSE: 'insert into ST_TLOG' statements are part of the application transaction
--
--   Public. Set the transaction mode of the insert into the table ST_TLOG
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    checkAndInitCTX(pCTX);
    pCTX.USE_OUT_TRANS := pOutTransaction;

END setTransactionMode;


FUNCTION getTransactionMode
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN
--******************************************************************************
--   NAME:   getTransactionMode
--
--   PARAMETERS:
--
--      pCTX               log context
--
--   Public. Returns the transaction mode of a log context for inserting
--   log event in the table TLOG. Returned values:
--   TRUE: 'insert into ST_TLOG' statements are in an autonomous transaction
--   FALSE: 'insert into ST_TLOG' statements are part of the application transaction
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN

    RETURN pCTX.USE_OUT_TRANS;

END getTransactionMode;

FUNCTION getTransactionMode
RETURN BOOLEAN
--******************************************************************************
--   NAME:   getTransactionMode
--
--   Public. Returns the transaction mode of the default log context for inserting
--   log event in the table TLOG. Returned values:
--   TRUE: 'insert into ST_TLOG' statements are in an autonomous transaction
--   FALSE: 'insert into ST_TLOG' statements are part of the application transaction
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
        generiqueCTX PLOGPARAM.LOG_CTX := getDefaultContext;
BEGIN
    RETURN getTransactionMode(pCTX => generiqueCTX);
END getTransactionMode;





PROCEDURE setLOG_TABLEMode
(
    pCTX IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pInLogTable IN BOOLEAN DEFAULT TRUE
)
--******************************************************************************
--   NAME:   setLOG_TABLEMode
--
--   PARAMETERS:
--
--      pCTX               log context
--      pInLogTable        Flag for writting in the table TLOG
--                         TRUE: log is written in the table TLOG
--                         FALSE: log is not written in the table TLOG
--
--   Public. Activate/desactivate logging in the table TLOG.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    checkAndInitCTX(pCTX);
    pCTX.USE_LOGTABLE := pInLogTable;

END setLOG_TABLEMode;


FUNCTION getLOG_TABLEMode
(
    pCTX        IN PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN
--******************************************************************************
--   NAME:   getLOG_TABLEMode
--
--   PARAMETERS:
--
--      pCTX               log context
--
--   Public. Returns the logging mode in the table TLOG for a specific context
--   Returned values:
--   TRUE: logging in table TLOG activated
--   FALSE: logging in table TLOG not activated
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    RETURN pCTX.USE_LOGTABLE;
END getLOG_TABLEMode;


FUNCTION getLOG_TABLEMode
RETURN BOOLEAN
--******************************************************************************
--   NAME:   getLOG_TABLEMode
--
--   Public. Returns the logging mode in the table TLOG for the default context
--   Returned values:
--   TRUE: logging in table TLOG activated
--   FALSE: logging in table TLOG not activated
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
        generiqueCTX PLOGPARAM.LOG_CTX := getDefaultContext;
BEGIN
    RETURN getTransactionMode(pCTX => generiqueCTX);
END getLOG_TABLEMode;


PROCEDURE setDBMS_OUTPUTMode
(
    pCTX IN OUT NOCOPY PLOGPARAM.LOG_CTX, 
    inDBMS_OUTPUT IN BOOLEAN DEFAULT TRUE
)
--******************************************************************************
--   NAME:   setDBMS_OUTPUTMode
--
--   PARAMETERS:
--
--      pCTX               log context
--      inDBMS_OUTPUT      Flag for writting in the standard output
--                         TRUE: log is written in standard output
--                         FALSE: log is not written in standard output
--
--   Public. Activate/desactivate logging in the standard output
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    checkAndInitCTX(pCTX);
    pCTX.USE_DBMS_OUTPUT := inDBMS_OUTPUT;
    
END setDBMS_OUTPUTMode;


FUNCTION getDBMS_OUTPUTMode 
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN
--******************************************************************************
--   NAME:   getDBMS_OUTPUTMode
--
--   PARAMETERS:
--
--      pCTX               log context
--
--   Public. Returns the logging mode in the standard output for a specific context
--   Returned values:
--   TRUE: logging in the standard output activated
--   FALSE: logging in the standard output not activated
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    checkAndInitCTX(pCTX);
    RETURN pCTX.USE_DBMS_OUTPUT;
END getDBMS_OUTPUTMode;

FUNCTION getDBMS_OUTPUTMode 
--******************************************************************************
--   NAME:   getDBMS_OUTPUTMode 
--
--   Public. Returns the logging mode in the standard output for the default context
--   Returned values:
--   TRUE: logging in the standard output activated
--   FALSE: logging in the standard output not activated
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
RETURN BOOLEAN
IS
        generiqueCTX PLOGPARAM.LOG_CTX := PLOG.getDefaultContext;  
BEGIN
    RETURN getDBMS_OUTPUTMode(pCTX => generiqueCTX);
END getDBMS_OUTPUTMode;


PROCEDURE setUSE_LOG4JMode
(
    pCTX IN OUT NOCOPY PLOGPARAM.LOG_CTX, 
    inUSE_LOG4J IN BOOLEAN DEFAULT TRUE
)
--******************************************************************************
--   NAME:   setUSE_LOG4JMode
--
--   PARAMETERS:
--
--      pCTX               log context
--      inDBMS_OUTPUT      Flag for writting log for LOG4J
--                         TRUE: log is written for LOG4J
--                         FALSE: log is not written for LOG4J
--
--   Public. Activate/desactivate logging for LOG4J (in a advanced queue)
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    checkAndInitCTX(pCTX);
    pCTX.USE_LOG4J := inUSE_LOG4J;
    
END setUSE_LOG4JMode;


FUNCTION getUSE_LOG4JMode 
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN
--******************************************************************************
--   NAME:   getUSE_LOG4JMode
--
--   PARAMETERS:
--
--      pCTX               log context
--
--   Public. Returns the logging mode for LOG4J for a specific context
--   Returned values:
--   TRUE: logging in the standard output activated
--   FALSE: logging in the standard output not activated
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    checkAndInitCTX(pCTX);
    RETURN pCTX.USE_LOG4J;
END getUSE_LOG4JMode;

FUNCTION getUSE_LOG4JMode 
--******************************************************************************
--   NAME:   getUSE_LOG4JMode 
--
--   Public. Returns the logging mode for LOG4J for the default context
--   Returned values:
--   TRUE: logging for LOG4J activated
--   FALSE: logging for LOG4J not activated
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
RETURN BOOLEAN
IS
        generiqueCTX PLOGPARAM.LOG_CTX := PLOG.getDefaultContext;  
BEGIN
    RETURN getUSE_LOG4JMode(pCTX => generiqueCTX);
END getUSE_LOG4JMode;



PROCEDURE setLOG_AlertMode
(
    pCTX IN OUT NOCOPY PLOGPARAM.LOG_CTX, 
    inLOG_ALERT IN BOOLEAN DEFAULT TRUE
)
--******************************************************************************
--   NAME:   setLOG_AlertMode
--
--   PARAMETERS:
--
--      pCTX               log context
--      inLOG_ALERT        Flag for writting log in alert file
--                         TRUE: log is written in alert file
--                         FALSE: log is not written in alert file
--
--   Public. Activate/desactivate logging in alert file
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    checkAndInitCTX(pCTX);
    pCTX.USE_ALERT := inLOG_ALERT;
    
END setLOG_AlertMode;


FUNCTION getLOG_AlertMode 
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN
--******************************************************************************
--   NAME:   getLOG_AlertMode
--
--   PARAMETERS:
--
--      pCTX               log context
--
--   Public. Returns the logging mode in alert file for a specific context
--   Returned values:
--   TRUE: logging in alert file activated
--   FALSE: logging in alert file not activated
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    checkAndInitCTX(pCTX);
    RETURN pCTX.USE_LOG4J;
END getLOG_AlertMode;

FUNCTION getLOG_AlertMode 
--******************************************************************************
--   NAME:   getLOG_AlertMode 
--
--   Public. Returns the logging mode in alert file for the default context
--   Returned values:
--   TRUE: logging in alert file activated
--   FALSE: logging in alert file activated
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
RETURN BOOLEAN
IS
        generiqueCTX PLOGPARAM.LOG_CTX := PLOG.getDefaultContext;  
BEGIN
    RETURN getLOG_AlertMode(pCTX => generiqueCTX);
END getLOG_AlertMode;


PROCEDURE setLOG_TraceMode
(
    pCTX IN OUT NOCOPY PLOGPARAM.LOG_CTX, 
    inLOG_TRACE IN BOOLEAN DEFAULT TRUE
)
--******************************************************************************
--   NAME:   setLOG_TraceMode
--
--   PARAMETERS:
--
--      pCTX               log context
--      inLOG_TRACE        Flag for writting log in trace file
--                         TRUE: log is written in trace file
--                         FALSE: log is not written in trace file
--
--   Public. Activate/desactivate logging in alert file
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    checkAndInitCTX(pCTX);
    pCTX.USE_TRACE := inLOG_TRACE;
    
END setLOG_TraceMode;


FUNCTION getLOG_TraceMode 
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN
--******************************************************************************
--   NAME:   getLOG_TraceMode
--
--   PARAMETERS:
--
--      pCTX               log context
--
--   Public. Returns the logging mode in trace file for a specific context
--   Returned values:
--   TRUE: logging in trace file activated
--   FALSE: logging in trace file not activated
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    checkAndInitCTX(pCTX);
    RETURN pCTX.USE_LOG4J;
END getLOG_TraceMode;

FUNCTION getLOG_TraceMode 
--******************************************************************************
--   NAME:   getLOG_TraceMode 
--
--   Public. Returns the logging mode in trace file for the default context
--   Returned values:
--   TRUE: logging in trace file activated
--   FALSE: logging in trace file activated
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
RETURN BOOLEAN
IS
        generiqueCTX PLOGPARAM.LOG_CTX := PLOG.getDefaultContext;  
BEGIN
    RETURN getLOG_TraceMode(pCTX => generiqueCTX);
END getLOG_TraceMode;


PROCEDURE setLOG_SessionMode
(
    pCTX IN OUT NOCOPY PLOGPARAM.LOG_CTX, 
    inLOG_SESSION IN BOOLEAN DEFAULT TRUE
)
--******************************************************************************
--   NAME:   setLOG_SessionMode
--
--   PARAMETERS:
--
--      pCTX               log context
--      inLOG_SESSION      Flag for writting log in the view V$SESSION
--                         TRUE: log is written in V$SESSION
--                         FALSE: log is not written in V$SESSION
--
--   Public. Activate/desactivate logging in the view V$SESSION
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    checkAndInitCTX(pCTX);
    pCTX.USE_SESSION := inLOG_SESSION;
    
END setLOG_SessionMode;


FUNCTION getLOG_SessionMode 
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
RETURN BOOLEAN
--******************************************************************************
--   NAME:   getLOG_SessionMode
--
--   PARAMETERS:
--
--      pCTX               log context
--
--   Public. Returns the logging mode in the view V$SESSION for a specific context
--   Returned values:
--   TRUE: logging in V$SESSION activated
--   FALSE: logging in V$SESSION not activated
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    checkAndInitCTX(pCTX);
    RETURN pCTX.USE_LOG4J;
END getLOG_SessionMode;

FUNCTION getLOG_SessionMode 
--******************************************************************************
--   NAME:   getLOG_SessionMode 
--
--   Public. Returns the logging mode the view V$SESSION for the default context
--   Returned values:
--   TRUE: logging in V$SESSION activated
--   FALSE: logging in V$SESSION activated
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
RETURN BOOLEAN
IS
        generiqueCTX PLOGPARAM.LOG_CTX := PLOG.getDefaultContext;  
BEGIN
    RETURN getLOG_SessionMode(pCTX => generiqueCTX);
END getLOG_SessionMode;

PROCEDURE setLevel
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pLEVEL        IN TLOG.LLEVEL%TYPE DEFAULT NOLEVEL
)
--******************************************************************************
--   NAME:   setLevel
--
--   PARAMETERS:
--
--      pCTX               log context
--      pLevel             new log level as integer
--
--   Public. Changes the log level giving a numeric value.
--   If no level is given, the log level is set to the default package value.
--   Possible error : -20501, 'Set Level not in LOG predefine constantes
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
    nbrl NUMBER;
BEGIN
    checkAndInitCTX(pCTX);
    IF pLEVEL = NOLEVEL THEN
        pCTX.LLEVEL := pCTX.INIT_LLEVEL;
    END IF;

    SELECT COUNT(*) INTO nbrl
    FROM TLOGLEVEL
    WHERE TLOGLEVEL.LLEVEL=pLEVEL;

    IF nbrl > 0 THEN
        pCTX.LLEVEL := pLEVEL;
    ELSE
        raise_application_error(AE_LEVEL_NOT_EXIST, 'SetLevel ('||pLEVEL||') not in TLOGLEVEL table');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        error;
END setLevel;



PROCEDURE setLevel
--******************************************************************************
--   NAME:   setLevel
--
--   PARAMETERS:
--
--      pCTX               log context
--      pLevel             new log level as string
--
--   Public. Changes the log level giving a string value (INFO, ERROR ...).
--   If no level is given, the log level is set to the default package value.
--   Possible error : -20501, 'Set Level not in LOG predefine constantes
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
(
    pCTX          IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pLEVEL        IN TLOGLEVEL.LCODE%TYPE
) IS
    nbrl NUMBER;
BEGIN

    setLevel (pCTX, PLOGPARAM.getTextInLevel(pLEVEL));

END setLevel;



FUNCTION getLevel
(
    pCTX       IN PLOGPARAM.LOG_CTX
)
RETURN TLOG.LLEVEL%type
--******************************************************************************
--   NAME:   getLevel
--
--   PARAMETERS:
--
--      pCTX               log context
--
--   Public. Returns the log level of a specific context. The returned value is
--   an integer (10, 20 ...).
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    RETURN pCTX.LLEVEL;
END getLevel;


FUNCTION getLevel
RETURN TLOG.LLEVEL%TYPE
--******************************************************************************
--   NAME:   getLevel
--
--   Public. Returns the log level of the default context. The returned value is
--   an integer (10, 20 ...).
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
    generiqueCTX PLOGPARAM.LOG_CTX := getDefaultContext;
BEGIN
    RETURN getLevel( pCTX => generiqueCTX);
END getLevel;



FUNCTION isLevelEnabled
(
    pCTX        IN   PLOGPARAM.LOG_CTX,
    pLEVEL      IN TLOG.LLEVEL%TYPE
)
RETURN BOOLEAN
--******************************************************************************
--   NAME:   isLevelEnabled
--
--   PARAMETERS:
--
--      pCTX               log context
--      pLevel             level to test
--
--   Private. Test if a log level is enabled or not for a specific context.
--   Function called by Is[Debug|Info|Warn|Error]Enabled functions.
--   Returned values:
--   TRUE: log level is enabled
--   FALSE: log level is disabled
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    IF getLevel(pCTX) >= pLEVEL THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END isLevelEnabled;

FUNCTION isLevelEnabled
(
    pLEVEL       IN TLOG.LLEVEL%TYPE
)
RETURN BOOLEAN
--******************************************************************************
--   NAME:   isLevelEnabled
--
--   PARAMETERS:
--
--      pLevel             level to test
--
--   Private. Test if a log level is enabled or not for the default log context.
--   Function called by Is[Debug|Info|Warn|Error]Enabled functions.
--   Returned values:
--   TRUE: log level is enabled
--   FALSE: log level is disabled
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
    generiqueCTX PLOGPARAM.LOG_CTX := getDefaultContext;
BEGIN
    RETURN isLevelEnabled( pCTX => generiqueCTX, pLEVEL => pLEVEL);
END isLevelEnabled;

FUNCTION isFatalEnabled
RETURN BOOLEAN
--******************************************************************************
--   NAME:   isFatalEnabled
--
--   Public. Test if a 'Fatal' log level is enabled or not for the default log context.
--   Returned values:
--   TRUE: 'Fatal' log level is enabled
--   FALSE: 'Fatal' log level is disabled
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
   RETURN isLevelEnabled(PLOGPARAM.getTextInLevel('FATAL'));
END isFatalEnabled;


FUNCTION isErrorEnabled
RETURN BOOLEAN
--******************************************************************************
--   NAME:   isFatalEnabled
--
--   Public. Test if a 'Error' log level is enabled or not for the default log context.
--   Returned values:
--   TRUE: 'Error' log level is enabled
--   FALSE: 'Error' log level is disabled
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
  RETURN isLevelEnabled(PLOGPARAM.getTextInLevel('ERROR'));
END isErrorEnabled;

FUNCTION isWarnEnabled
RETURN BOOLEAN
--******************************************************************************
--   NAME:   isWarnEnabled
--
--   Public. Test if a 'Warning' log level is enabled or not for the default log context.
--   Returned values:
--   TRUE: 'Warning' log level is enabled
--   FALSE: 'Warning' log level is disabled
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
  RETURN isLevelEnabled(PLOGPARAM.getTextInLevel('WARN'));
END isWarnEnabled;

FUNCTION isInfoEnabled
RETURN BOOLEAN
IS
--******************************************************************************
--   NAME:   isInfoEnabled
--
--   Public. Test if a 'Info' log level is enabled or not for the default log context.
--   Returned values:
--   TRUE: 'Info' log level is enabled
--   FALSE: 'Info' log level is disabled
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
BEGIN
  RETURN isLevelEnabled(PLOGPARAM.getTextInLevel('INFO'));
END isInfoEnabled;

FUNCTION isDebugEnabled
RETURN BOOLEAN
--******************************************************************************
--   NAME:   isDebugEnabled
--
--   Public. Test if a 'Debug' log level is enabled or not for the default log context.
--   Returned values:
--   TRUE: 'Debug' log level is enabled
--   FALSE: 'Debug' log level is disabled
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
  RETURN isLevelEnabled(PLOGPARAM.getTextInLevel('DEBUG'));
END isDebugEnabled;

FUNCTION isFatalEnabled (pCTX IN PLOGPARAM.LOG_CTX)
RETURN BOOLEAN
--******************************************************************************
--   NAME:   isFatalEnabled
--
--   PARAMETERS:
--
--         pCTX       specific log context
--
--   Public. Test if a 'Fatal' log level is enabled or not for a specific log context.
--   Returned values:
--   TRUE: 'Fatal' log level is enabled
--   FALSE: 'Fatal' log level is disabled
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
  RETURN isLevelEnabled(pCTX, PLOGPARAM.getTextInLevel('FATAL'));
END isFatalEnabled;

FUNCTION isErrorEnabled (pCTX IN PLOGPARAM.LOG_CTX)
RETURN BOOLEAN
--******************************************************************************
--   NAME:   isErrorEnabled
--
--   PARAMETERS:
--
--         pCTX       specific log context
--
--   Public. Test if a 'Error' log level is enabled or not for a specific log context.
--   Returned values:
--   TRUE: 'Error' log level is enabled
--   FALSE: 'Error' log level is disabled
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
  RETURN isLevelEnabled(pCTX, PLOGPARAM.getTextInLevel('ERROR'));
END isErrorEnabled;

FUNCTION isWarnEnabled(pCTX IN PLOGPARAM.LOG_CTX)
RETURN BOOLEAN
--******************************************************************************
--   NAME:   isWarnEnabled
--
--   PARAMETERS:
--
--         pCTX       specific log context
--
--   Public. Test if a 'Warning' log level is enabled or not for a specific log context.
--   Returned values:
--   TRUE: 'Warning' log level is enabled
--   FALSE: 'Warning' log level is disabled
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
  RETURN isLevelEnabled(pCTX, PLOGPARAM.getTextInLevel('WARN'));
END isWarnEnabled;

FUNCTION isInfoEnabled (pCTX IN PLOGPARAM.LOG_CTX)
RETURN BOOLEAN
--******************************************************************************
--   NAME:   isInfoEnabled
--
--   PARAMETERS:
--
--         pCTX       specific log context
--
--   Public. Test if a 'Info' log level is enabled or not for a specific log context.
--   Returned values:
--   TRUE: 'Info' log level is enabled
--   FALSE: 'Info' log level is disabled
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
  RETURN isLevelEnabled(pCTX, PLOGPARAM.getTextInLevel('INFO'));
END isInfoEnabled;

FUNCTION isDebugEnabled (pCTX IN PLOGPARAM.LOG_CTX)
RETURN BOOLEAN
--******************************************************************************
--   NAME:   isDebugEnabled
--
--   PARAMETERS:
--
--         pCTX       specific log context
--
--   Public. Test if a 'Debug' log level is enabled or not for a specific log context.
--   Returned values:
--   TRUE: 'Debug' log level is enabled
--   FALSE: 'Debug' log level is disabled
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
  RETURN isLevelEnabled(pCTX, PLOGPARAM.getTextInLevel('DEBUG'));
END isDebugEnabled;


PROCEDURE purge
(
    pDateMax      IN DATE DEFAULT NULL
)
--******************************************************************************
--   NAME:   purge
--
--  PARAMETERS:
--
--        pDateMax         limit date before which old log records are deleted
--
--   Public. Deletes log records older than the given date from several outputs
--   (table TLOG, advanced queue).
--   If no date is specificated, all records are deleted.
--   This procedure calls the procedure PLOG_INTERFACE.log() which dispatches
--   the purge command to the concerned output packages.
--   A log with info level is done at the end of the operation.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************

IS
   tempLogCtx  PLOGPARAM.LOG_CTX := init(pSECTION => 'plog.purge', pLEVEL => LINFO);
BEGIN

  -- call the dispatcher package
  PLOG_INTERFACE.purge(pDateMax);

  -- create a log with info level always fired because an internal context is used
  info(tempLogCtx, 'Purge by user:'||USER);

END purge;


PROCEDURE log
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pLEVEL      IN TLOG.LLEVEL%TYPE,
    pTEXT       IN TLOG.LTEXT%TYPE DEFAULT NULL
)
--******************************************************************************
--   NAME:   log
--
--  PARAMETERS:
--
--        pCTX             log context
--        pLEVEL           log level as numeric value
--        pTEXT            log text
--
--   Public. Log a message of a specificated level (parameter pLEVEL: 10, 20 ...)
--   using a specific log context.
--   The parameter pTEXT is the message text. If the parameter is NULL, the
--   log text will be filled by the Oracle error code and message.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS

     lId        TLOG.ID%TYPE;
     lLSECTION  TLOG.LSECTION%TYPE := getSection(pCTX);
     lLHSECS    TLOG.LHSECS%TYPE;

BEGIN
    checkAndInitCTX(pCTX);

    IF pLEVEL > getLevel(pCTX) THEN
        -- the log level is not big enough: cancel the log
        RETURN;
    END IF;

    -- increment the log message ID
    lId := getNextID;

    -- call the main log function
    log (   pCTX        =>pCTX,
            pID         =>lId,
            pLDate      =>SYSDATE,
            pLHSECS     =>DBMS_UTILITY.GET_TIME,
            pLLEVEL     =>pLEVEL,
            pLSECTION   =>lLSECTION,
            pLUSER      =>USER,
            pLTEXT      =>pTEXT
        );

END log;

PROCEDURE log
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pLEVEL      IN TLOGLEVEL.LCODE%TYPE,
    pTEXT       IN TLOG.LTEXT%TYPE DEFAULT NULL
)
--******************************************************************************
--   NAME:   log
--
--  PARAMETERS:
--
--        pCTX             log context
--        pLEVEL           log level as string value
--        pTEXT            log text
--
--   Public. Log a message of a specificated level (parameter pLEVEL: INFO, DEBUG ...)
--   using a specific log context.
--   The parameter pTEXT is the message text. If the parameter is NULL, the
--   log text will be filled by the Oracle error code and message.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    log(pLEVEL => PLOGPARAM.getTextInLevel(pLEVEL), pCTX => pCTX, pTEXT => pTEXT);
END log;


PROCEDURE log
(
    pLEVEL     IN TLOG.LLEVEL%TYPE,
    pTEXT      IN TLOG.LTEXT%TYPE DEFAULT NULL
)
--******************************************************************************
--   NAME:   log
--
--  PARAMETERS:
--
--        pLEVEL           log level as numeric value
--        pTEXT            log text
--
--   Public. Log a message of a specificated level (parameter pLEVEL: 10, 20 ...)
--   using the default log context.
--   The parameter pTEXT is the message text. If the parameter is NULL, the
--   log text will be filled by the Oracle error code and message.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
   generiqueCTX PLOGPARAM.LOG_CTX := getDefaultContext;
BEGIN
    LOG(pLEVEL => pLEVEL, pCTX => generiqueCTX, pTEXT => pTEXT);
END log;

PROCEDURE log
(
    pLEVEL      IN TLOGLEVEL.LCODE%TYPE,
    pTEXT       IN TLOG.LTEXT%TYPE DEFAULT NULL
)
--******************************************************************************
--   NAME:   log
--
--  PARAMETERS:
--
--        pLEVEL           log level as string value
--        pTEXT            log text
--
--   Public. Log a message of a specificated level (parameter pLEVEL: INFO, DEBUG ...)
--   using the default log context.
--   The parameter pTEXT is the message text. If the parameter is NULL, the
--   log text will be filled by the Oracle error code and message.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    log(pLEVEL => PLOGPARAM.getTextInLevel(pLEVEL), pTEXT => pTEXT);
END log;


PROCEDURE debug
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pTEXT       IN TLOG.LTEXT%TYPE DEFAULT NULL
)
--******************************************************************************
--   NAME:   debug
--
--  PARAMETERS:
--
--        pCTX             log context
--        pTEXT            log text
--
--   Public. Log a message of debug level using a specific log context.
--   The parameter pTEXT is the message text. If the parameter is NULL, the
--   log text will be filled by the Oracle error code and message.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    log(pLEVEL => PLOGPARAM.getTextInLevel('DEBUG'), pCTX => pCTX, pTEXT => pTEXT);
END debug;

PROCEDURE debug
(
    pTEXT      IN TLOG.LTEXT%TYPE DEFAULT NULL
)
--******************************************************************************
--   NAME:   debug
--
--  PARAMETERS:
--
--        pTEXT            log text
--
--   Public. Log a message of error level using the default log context.
--   The parameter pTEXT is the message text. If the parameter is NULL, the
--   log text will be filled by the Oracle error code and message.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    log(pLEVEL => PLOGPARAM.getTextInLevel('DEBUG'), pTEXT => pTEXT);
END debug;


PROCEDURE info
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pTEXT       IN TLOG.LTEXT%TYPE DEFAULT NULL
)
--******************************************************************************
--   NAME:   info
--
--  PARAMETERS:
--
--        pCTX             log context
--        pTEXT            log text
--
--   Public. Log a message of information level using a specific log context.
--   The parameter pTEXT is the message text. If the parameter is NULL, the
--   log text will be filled by the Oracle error code and message.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    log(pLEVEL => PLOGPARAM.getTextInLevel('INFO'), pCTX => pCTX,  pTEXT => pTEXT);
END info;

PROCEDURE info
(
    pTEXT      IN TLOG.LTEXT%TYPE DEFAULT NULL
)
--******************************************************************************
--   NAME:   info
--
--  PARAMETERS:
--
--        pTEXT            log text
--
--   Public. Log a message of info level using the default log context.
--   The parameter pTEXT is the message text. If the parameter is NULL, the
--   log text will be filled by the Oracle error code and message.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    log(pLEVEL => PLOGPARAM.getTextInLevel('INFO'),  pTEXT => pTEXT);
END info;


PROCEDURE warn
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pTEXT       IN TLOG.LTEXT%TYPE DEFAULT NULL
)
--******************************************************************************
--   NAME:   warn
--
--  PARAMETERS:
--
--        pCTX             log context
--        pTEXT            log text
--
--   Public. Log a message of warning level using a specific log context.
--   The parameter pTEXT is the message text. If the parameter is NULL, the
--   log text will be filled by the Oracle error code and message.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    log(pLEVEL => PLOGPARAM.getTextInLevel('WARN'), pCTX => pCTX,  pTEXT => pTEXT);
END warn;

PROCEDURE warn
(
    pTEXT      IN TLOG.LTEXT%TYPE DEFAULT NULL
)
--******************************************************************************
--   NAME:   warn
--
--  PARAMETERS:
--
--        pTEXT            log text
--
--   Public. Log a message of warning level using the default log context.
--   The parameter pTEXT is the message text. If the parameter is NULL, the
--   log text will be filled by the Oracle error code and message.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    LOG(pLEVEL => PLOGPARAM.getTextInLevel('WARN'),  pTEXT => pTEXT);
END warn;


PROCEDURE error
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX,
    pTEXT      IN TLOG.LTEXT%TYPE DEFAULT NULL
)
--******************************************************************************
--   NAME:   error
--
--  PARAMETERS:
--
--        pCTX             log context
--        pTEXT            log text
--
--   Public. Log a message of error level using a specific log context.
--   The parameter pTEXT is the message text. If the parameter is NULL, the
--   log text will be filled by the Oracle error code and message.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    log(pLEVEL => PLOGPARAM.getTextInLevel('ERROR'), pCTX => pCTX,  pTEXT => pTEXT);
END error;

PROCEDURE error
(
    pTEXT      IN TLOG.LTEXT%TYPE DEFAULT NULL
)
IS
--******************************************************************************
--   NAME:   error
--
--  PARAMETERS:
--
--        pTEXT            log text
--
--   Public. Log a message of error level using the default log context.
--   The parameter pTEXT is the message text. If the parameter is NULL, the
--   log text will be filled by the Oracle error code and message.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
BEGIN
    LOG(pLEVEL => PLOGPARAM.getTextInLevel('ERROR'),  pTEXT => pTEXT);
END error;


PROCEDURE fatal
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX                      ,
    pTEXT      IN TLOG.LTEXT%TYPE  DEFAULT NULL
)
--******************************************************************************
--   NAME:   fatal
--
--  PARAMETERS:
--
--        pCTX             log context
--        pTEXT            log text
--
--   Public. Log a message of fatal level using a specific log context.
--   The parameter pTEXT is the message text. If the parameter is NULL, the
--   log text will be filled by the Oracle error code and message.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    log(pLEVEL => PLOGPARAM.getTextInLevel('FATAL'), pCTX => pCTX,  pTEXT => pTEXT);
END fatal;

PROCEDURE fatal
(
    pTEXT      IN TLOG.LTEXT%TYPE DEFAULT NULL
)
--******************************************************************************
--   NAME:   fatal
--
--  PARAMETERS:
--
--        pTEXT            log text
--
--   Public. Log a message of fatal level using the default log context.
--   The parameter pTEXT is the message text. If the parameter is NULL, the
--   log text will be filled by the Oracle error code and message.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    log(pLEVEL => PLOGPARAM.getTextInLevel('FATAL'),  pTEXT => pTEXT);
END fatal;

PROCEDURE assert (
    pCTX                     IN OUT NOCOPY PLOGPARAM.LOG_CTX                        ,
    pCONDITION               IN BOOLEAN                                   ,
    pLogErrorMessageIfFALSE  IN VARCHAR2 DEFAULT 'assert condition error' ,
    pLogErrorCodeIfFALSE     IN NUMBER   DEFAULT -20000                   ,
    pRaiseExceptionIfFALSE   IN BOOLEAN  DEFAULT FALSE                    ,
    pLogErrorReplaceError    in BOOLEAN  DEFAULT FALSE
)
--******************************************************************************
--   NAME:   assert
--
--  PARAMETERS:
--
--      pCTX                      log context
--      pCONDITION                error condition
--      pLogErrorMessageIfFALSE   message if pCondition is true
--      pLogErrorCodeIfFALSE      error code is pCondition is true range -20000 .. -20999
--      pRaiseExceptionIfFALSE    if true raise pException_in if pCondition is true
--      pLogErrorReplaceError     TRUE, the error is placed on the stack of previous errors.
--                                If FALSE (the default), the error replaces all previous errors
--                                see Oracle Documentation RAISE_APPLICATION_ERROR
--
--   Public. Test a boolean condition using a specific log context.
--   If the confition is false, the log entry is done.
--   If the parameter pRaiseExceptionIfFALSE is TRUE, an application error is also raised
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
  checkAndInitCTX(pCTX);
  IF not islevelEnabled(pCTX, PLOGPARAM.DEFAULT_ASSET_LEVEL) then
        RETURN;
  END IF;

  IF NOT pCONDITION THEN
     LOG (pLEVEL => PLOGPARAM.DEFAULT_ASSET_LEVEL, pCTX => pCTX,  pTEXT => 'AAS'||pLogErrorCodeIfFALSE||': '||pLogErrorMessageIfFALSE);
     IF pRaiseExceptionIfFALSE THEN
        raise_application_error(pLogErrorCodeIfFALSE, pLogErrorMessageIfFALSE, pLogErrorReplaceError);
     END IF;
  END IF;
END assert;


PROCEDURE assert (
    pCONDITION               IN BOOLEAN                                   ,
    pLogErrorMessageIfFALSE  IN VARCHAR2 DEFAULT 'assert condition error' ,
    pLogErrorCodeIfFALSE     IN NUMBER   DEFAULT -20000                   ,
    pRaiseExceptionIfFALSE   IN BOOLEAN  DEFAULT FALSE                    ,
    pLogErrorReplaceError    in BOOLEAN  DEFAULT FALSE
)
--******************************************************************************
--   NAME:   assert
--
--  PARAMETERS:
--
--      pCONDITION                error condition
--      pLogErrorMessageIfFALSE   message if pCondition is true
--      pLogErrorCodeIfFALSE      error code is pCondition is true range -20000 .. -20999
--      pRaiseExceptionIfFALSE    if true raise pException_in if pCondition is true
--      pLogErrorReplaceError     TRUE, the error is placed on the stack of previous errors.
--                                If FALSE (the default), the error replaces all previous errors
--                                see Oracle Documentation RAISE_APPLICATION_ERROR
--
--   Public. Test a boolean condition using the default context.
--   If the confition is false, the log entry is done.
--   If the parameter pRaiseExceptionIfFALSE is TRUE, an application error is also raised
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
   generiqueCTX PLOGPARAM.LOG_CTX := getDefaultContext;
BEGIN
assert (
    pCTX                        => generiqueCTX,
    pCONDITION                  => pCONDITION,
    pLogErrorCodeIfFALSE        => pLogErrorCodeIfFALSE,
    pLogErrorMessageIfFALSE     => pLogErrorMessageIfFALSE,
    pRaiseExceptionIfFALSE      => pRaiseExceptionIfFALSE,
    pLogErrorReplaceError       => pLogErrorReplaceError);
END assert;


PROCEDURE full_call_stack
--******************************************************************************
--   NAME:   full_call_stack
--
--   Public. Log the current call stack using the default log context
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
   generiqueCTX PLOGPARAM.LOG_CTX := getDefaultContext;
BEGIN
    full_call_stack (Pctx => generiqueCTX);
END full_call_stack;


PROCEDURE full_call_stack
(
    pCTX                     IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
--******************************************************************************
--   NAME:   full_call_stack
--
--  PARAMETERS:
--
--        pCTX            log context
--
--   Public. Log the current call stack using a specific context
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
     checkAndInitCTX(pCTX);
     log(pLEVEL => PLOGPARAM.DEFAULT_FULL_CALL_STACK_LEVEL, pCTX => pCTX,  pTEXT => dbms_utility.format_call_stack );
END full_call_stack;


PROCEDURE full_error_backtrace
--******************************************************************************
--   NAME:   full_error_backtrace
--
--   Public. Log the current error backtrace using the default log context
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
   generiqueCTX PLOGPARAM.LOG_CTX := getDefaultContext;
BEGIN
    full_error_backtrace (Pctx => generiqueCTX);
END full_error_backtrace;


PROCEDURE full_error_backtrace
(
    pCTX                     IN OUT NOCOPY PLOGPARAM.LOG_CTX
)
--******************************************************************************
--   NAME:   full_error_backtrace
--
--  PARAMETERS:
--
--        pCTX            log context
--
--   Public. Log the current error backtrace using a specific context
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
  LLTEXT TLOG.LTEXT%TYPE;


BEGIN
     checkAndInitCTX(pCTX);
     LLTEXT :=   'SQLCODE:'||SQLCODE ||' SQLERRM:'||SQLERRM || CHR(10) ||
              'Error back trace:' || CHR(10) ||
               replace(dbms_utility.format_error_backtrace, 'ORA-06512: ', '');
     log(pLEVEL => PLOGPARAM.DEFAULT_FT_ERR_BTRACE_LEVEL, pCTX => pCTX,  pTEXT => LLTEXT );
END full_error_backtrace;


FUNCTION getLOG4PLSQVersion
RETURN VARCHAR2
--******************************************************************************
--   NAME:   getLOG4PLSQVersion
--
--   Public. Returns the current version number as string
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
BEGIN
    RETURN LOG4PLSQL_VERSION;
END getLOG4PLSQVersion;





FUNCTION isPackageInstalled
(
    pPackageName IN VARCHAR2
)
RETURN  BOOLEAN
--******************************************************************************
--   NAME:   isPackageInstalled
--
--  PARAMETERS:
--
--      pPackageName           Package to verify if it is installed
--
--   Private. Returns TRUE if the package is installed, if not FALSE.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    25.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
  vObjectName USER_OBJECTS.OBJECT_NAME%TYPE;
BEGIN

    SELECT OBJECT_NAME INTO vObjectName
    FROM USER_OBJECTS
    WHERE OBJECT_NAME = pPackageName AND
    OBJECT_TYPE = 'PACKAGE BODY';

    RETURN TRUE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
       RETURN FALSE;
END isPackageInstalled;


-- end of the package
END;
/