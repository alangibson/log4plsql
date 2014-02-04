create or replace PACKAGE PLOG_OUT_SESSION AS


--*******************************************************************************
--   NAME:   PLOG_OUT_SESSION (specification)
--
--   writes the log information into the view V$SESSION trough the public procedure log()
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ----------------  ---------------------------------------
--   1.0    03.06.2008  Bertrand Caradec  First version
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
    pLTEXT      IN       TLOG.LTEXT%TYPE                   ,
    pLINSTANCE  IN       TLOG.LINSTANCE%TYPE DEFAULT SYS_CONTEXT('USERENV', 'INSTANCE'),
    pLXML        IN       SYS.XMLTYPE DEFAULT NULL
);

 

END;
/
