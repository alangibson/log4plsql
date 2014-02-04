create or replace PACKAGE PLOG_OUT_DBMS_OUTPUT AS

--*******************************************************************************
--   NAME:   PLOG_DBMS_OUTPUT
--
--   writes the log information in the standard output trough the DBMS_OUPUT package
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ----------------  ---------------------------------------
--   1.0    15.04.2008  Bertrand Caradec  First version.
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

END;
/
