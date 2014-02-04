create or replace PACKAGE PLOG_OUT_ALERT AS


--*******************************************************************************
--   NAME:   PLOG_OUT_ALERT (specification)
--
--   writes the log information into the file alert.log trough the public procedure log()
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ----------------  ---------------------------------------
--   1.0    14.04.2008  Bertrand Caradec  First version
--*******************************************************************************

PROCEDURE log
(
    pCTX        IN       PLOGPARAM.LOG_CTX                     ,  
    pID         IN       TLOG.id%TYPE                      ,
    pLDate      IN       TLOG.ldate%TYPE                   ,
    pLHSECS     IN       TLOG.lhsecs%TYPE                  ,
    pLLEVEL     IN       TLOG.llevel%TYPE                  ,
    pLSECTION   IN       TLOG.lsection%TYPE                ,
    pLUSER      IN       TLOG.luser%TYPE                   ,
    pLTEXT      IN       TLOG.LTEXT%TYPE
);

 

END;
/
