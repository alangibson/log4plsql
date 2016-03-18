create or replace PACKAGE PLOG_OUT_AQ AS

--*******************************************************************************
--   NAME:   PLOG_OUT_AQ (specification)
--
--   writes the log information in a queue available for other applications
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ----------------  ---------------------------------------
--   1.0    14.04.2008  Bertrand Caradec  First version.
--*******************************************************************************


PROCEDURE log
(
    pCTX        IN       PLOGPARAM.LOG_CTX                ,  
    pID         IN       TLOG.id%TYPE                      ,
    pLDate      IN       TLOG.ldate%TYPE                   ,
    pLHSECS     IN       TLOG.lhsecs%TYPE                  ,
    pLLEVEL     IN       TLOG.llevel%TYPE                  ,
    pLSECTION   IN       TLOG.lsection%TYPE                ,
    pLUSER      IN       TLOG.luser%TYPE                   ,
    pLTEXT      IN       TLOG.LTEXT%TYPE                   ,
    pLINSTANCE  IN       TLOG.LINSTANCE%TYPE DEFAULT SYS_CONTEXT('USERENV', 'INSTANCE'),
    pLSID       IN       TLOG.LSID%TYPE                    ,
    pLXML       IN       SYS.XMLTYPE DEFAULT NULL
);

PROCEDURE dequeue_one_msg
(
    pID         OUT       TLOG.id%TYPE                      ,
    pLDate      OUT       TLOG.ldate%TYPE                   ,
    pLHSECS     OUT       TLOG.lhsecs%TYPE                  ,
    pLLEVEL     OUT       TLOG.llevel%TYPE                  ,
    pLSECTION   OUT       TLOG.lsection%TYPE                ,
    pLUSER      OUT       TLOG.luser%TYPE                   ,
    pLTEXT      OUT       TLOG.LTEXT%TYPE                   ,
    pLINSTANCE  OUT       TLOG.LINSTANCE%TYPE               ,
    pLSID       OUT       TLOG.LSID%TYPE
);

PROCEDURE purge(pMaxDate IN TIMESTAMP DEFAULT NULL);

PROCEDURE display_one_log_msg(p_log_msg IN T_LOG_QUEUE);

FUNCTION get_queue_msg_count RETURN NUMBER;

END;
/
