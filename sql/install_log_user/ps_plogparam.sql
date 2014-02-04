create or replace
PACKAGE PLOGPARAM IS

-------------------------------------------------------------------
--
--  Specification for package: PLOGPARAM (this package has no body)
--
--  Feature            : Definition of parameters values for the logging tool
--
--  Version            : 3.3
------------------------------------------------------------------

-- History
-- version   who                  date       comment
-- V3       Guillaume Moulard     05-AUG-03  Creation
-- V3.2     Greg Woolsey          29-MAR-04  add MDC (Mapped Domain Context) Feature
-- V3.3     Bertrand Caradec      11-APR-08  constant added for error back trace

/*
 * Copyright (C) LOG4PLSQL project team. All rights reserved.
 *
 * This software is published under the terms of the The LOG4PLSQL
 * Software License, a copy of which has been included with this
 * distribution in the LICENSE.txt file.
 * see: <http://log4plsql.sourceforge.net>  */
-------------------------------------------------------------------


-- public constants used by the other packages

-- definition of the default level
-- LERROR default level for production system
-- LDEBUG for developement phase
DEFAULT_LEVEL         CONSTANT TLOG.LLEVEL%type     := 70 ; -- LERROR


-- TRUE default value for Logging in table
DEFAULT_LOG_TABLE     CONSTANT BOOLEAN              := TRUE;

-- if DEFAULT_USE_LOG4J is TRUE log4j Log4JbackgroundProcess are necessary
DEFAULT_USE_LOG4J     CONSTANT BOOLEAN              := FALSE;

-- TRUE default value for Logging out off transactional limits
DEFAULT_LOG_OUT_TRANS CONSTANT BOOLEAN              := TRUE;

-- if DEFAULT_LOG_ALERTLOG is true the log is written in alert.log file
DEFAULT_LOG_ALERT     CONSTANT BOOLEAN              := FALSE;

-- if DEFAULT_LOG_TRACE is true the log is written in trace file
DEFAULT_LOG_TRACE     CONSTANT BOOLEAN              := FALSE;

-- if DEFAULT_DBMS_OUTPUT is true the log is sent in standard output (DBMS_OUTPUT.PUT_LINE)
DEFAULT_DBMS_OUTPUT   CONSTANT BOOLEAN              := FALSE;

-- if DEFAULT_SESSION is true the log is written in the view V$SESSION
DEFAULT_SESSION   CONSTANT BOOLEAN              := FALSE;


-- default level for asset
DEFAULT_ASSET_LEVEL   CONSTANT TLOG.LLEVEL%type            := DEFAULT_LEVEL;

-- default level for call_stack_level
DEFAULT_FULL_CALL_STACK_LEVEL CONSTANT  TLOG.LLEVEL%type   := DEFAULT_LEVEL;

-- default level for format error backtrace
DEFAULT_FT_ERR_BTRACE_LEVEL CONSTANT  TLOG.LLEVEL%type   := DEFAULT_LEVEL;

-- use for build a string section
DEFAULT_Section_sep CONSTANT TLOG.LSECTION%type := '.';

-- Formats output sent to DBMS_OUTPUT to this width.
DEFAULT_DBMS_OUTPUT_LINE_WRAP  CONSTANT NUMBER := 100;

-- log context record
TYPE LOG_CTX IS RECORD (
    isDefaultInit     BOOLEAN default FALSE,
    LLEVEL            TLOG.LLEVEL%TYPE,
    LSECTION          TLOG.LSECTION%TYPE,
    LTEXT             TLOG.LTEXT%TYPE,
    USE_LOG4J         BOOLEAN,
    USE_OUT_TRANS     BOOLEAN,
    USE_LOGTABLE      BOOLEAN,
    USE_ALERT         BOOLEAN,
    USE_TRACE         BOOLEAN,
    USE_DBMS_OUTPUT   BOOLEAN,
    USE_SESSION       BOOLEAN,
    INIT_LSECTION     TLOG.LSECTION%TYPE,
    INIT_LLEVEL       TLOG.LLEVEL%TYPE,
    DBMS_OUTPUT_WRAP  PLS_INTEGER
);

FUNCTION getLevelInText (
    pLevel TLOG.LLEVEL%TYPE DEFAULT PLOGPARAM.DEFAULT_LEVEL
) RETURN VARCHAR2;


FUNCTION getTextInLevel (
    pCode TLOGLEVEL.LCODE%TYPE
) RETURN  TLOG.LLEVEL %TYPE;

END;
/
