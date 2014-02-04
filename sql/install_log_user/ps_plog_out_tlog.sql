create or replace PACKAGE PLOG_OUT_TLOG AS

--*******************************************************************************
--   NAME:   PLOG_OUT_TLOG
--
--   writes the log information in the table TLOG trough the public procedure
--   log()
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ----------------  ---------------------------------------
--   1.0    14.04.2008  Bertrand Caradec  First version.
--*******************************************************************************

PROCEDURE log
(
    pCTX        IN OUT NOCOPY PLOGPARAM.LOG_CTX                ,  
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

PROCEDURE purge
(
  pDateMax      IN TIMESTAMP DEFAULT NULL                                   
);

END;
/
