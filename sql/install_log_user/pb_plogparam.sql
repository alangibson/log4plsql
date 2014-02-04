create or replace
PACKAGE BODY PLOGPARAM AS

--*******************************************************************************
--   NAME:   PLOGPARAM (body)
--
--   Transformation functions between a log level in string code ('WARN', 'INFO' ...)
--   and the integer level. The table TLOGLEVEL is read.
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ----------------  ---------------------------------------
--   1.0    14.04.2008  Bertrand Caradec  First version.
--*******************************************************************************

FUNCTION getTextInLevel
(
    pCode TLOGLEVEL.LCODE%TYPE
)
RETURN  TLOG.llevel%TYPE
--******************************************************************************
--   NAME:   getTextInLevel
--
--  PARAMETERS:
--
--      pCode              Log level as string ('Fatal', 'Error' ...)
--
--   Public. Returns the numeric level code (TLOGLEVEL.LLEVEL) of a
--   string level value.Returned values: 10, 20 ...
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
    ret TLOG.llevel%TYPE;
BEGIN

    SELECT LLEVEL INTO ret
    FROM TLOGLEVEL
    WHERE LCODE = pCode;

    RETURN ret;

EXCEPTION
    WHEN OTHERS THEN
        RETURN DEFAULT_LEVEL;
END getTextInLevel;



FUNCTION getLevelInText
(
    pLevel TLOG.llevel%TYPE DEFAULT PLOGPARAM.DEFAULT_LEVEL
)
RETURN VARCHAR2
--******************************************************************************
--   NAME:   getLevelInText
--
--  PARAMETERS:
--
--      pCode              Log level as numeric value (10, 20 ...)
--
--   Public. Returns the string level code (TLOGLEVEL.LCODE) of a
--   numeric level value.
--   Returned values: 'OFF', 'FATAL', 'ERROR' ...
--
--   Ver    Date        Autor             Comment
--   -----  ----------  ---------------   --------------------------------------
--   1.0    17.04.2008  Bertrand Caradec  Initial version
--******************************************************************************
IS
    ret VARCHAR2(1000);
BEGIN

    SELECT LCODE into ret
    FROM TLOGLEVEL
    WHERE LLEVEL = pLevel;
    
    RETURN ret;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'UNDEFINED';
END getLevelInText;

END PLOGPARAM;
/