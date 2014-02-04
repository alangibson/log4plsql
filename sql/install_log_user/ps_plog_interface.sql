create or replace
PACKAGE PLOG_INTERFACE AS

--*******************************************************************************
--   NAME:   PLOG_INTERFACE (specification)
--
--   Interface between the main log package PLOG and the output packages.
--   The body is dynamically built during the installation. The log/purge functions of the
--   output packages are called if the corresponding packages have been installed.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ----------------  ---------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  First version
--*******************************************************************************
  PROCEDURE log
(
    pCTX        IN OUT NOCOPY      PLOGPARAM.LOG_CTX                ,  
    pID         IN       TLOG.id%TYPE                      ,
    pLDate      IN       TLOG.ldate%TYPE                   ,
    pLHSECS     IN       TLOG.lhsecs%TYPE                  ,
    pLLEVEL     IN       TLOG.llevel%TYPE                  ,
    pLSECTION   IN       TLOG.lsection%TYPE                ,
    pLUSER      IN       TLOG.luser%TYPE                   ,
    pLTEXT      IN       TLOG.LTEXT%TYPE
);

  PROCEDURE purge
(
   pMaxDate IN DATE DEFAULT NULL 
);

END;
/
