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
-- V3.3     Bertrand Caradec      11-APR-08  added for error back trace

/*
 * Copyright (C) LOG4PLSQL project team. All rights reserved.
 *
 * This software is published under the terms of the The LOG4PLSQL
 * Software License, a copy of which has been included with this
 * distribution in the LICENSE.txt file.
 * see: <http://log4plsql.sourceforge.net>  */
-------------------------------------------------------------------

--
-- Defaults affecting what is logged and where it is logged.
-- public constants used by the other packages
--

-- definition of the default level
-- LERROR default level for production system
-- LDEBUG for developement phase
DEFAULT_LEVEL         TLOG.LLEVEL%type     := 70 ; -- LERROR

-- TRUE default value for Logging in table
DEFAULT_LOG_TABLE     BOOLEAN              := TRUE;

-- if DEFAULT_USE_LOG4J is TRUE log4j Log4JbackgroundProcess are necessary
-- Causes log messages to be sent to a queue
DEFAULT_USE_LOG4J     BOOLEAN              := TRUE;

-- TRUE default value for Logging out off transactional limits
DEFAULT_LOG_OUT_TRANS BOOLEAN              := TRUE;

-- if DEFAULT_LOG_ALERTLOG is true the log is written in alert.log file
DEFAULT_LOG_ALERT     BOOLEAN              := FALSE;

-- if DEFAULT_LOG_TRACE is true the log is written in trace file
DEFAULT_LOG_TRACE     BOOLEAN              := FALSE;

-- if DEFAULT_DBMS_OUTPUT is true the log is sent in standard output (DBMS_OUTPUT.PUT_LINE)
DEFAULT_DBMS_OUTPUT   BOOLEAN              := FALSE;

-- if DEFAULT_SESSION is true the log is written in the view V$SESSION
DEFAULT_SESSION       BOOLEAN              := FALSE;

--
-- Defaults effecting message output.
--

-- default level for asset
DEFAULT_ASSET_LEVEL             TLOG.LLEVEL%type            := DEFAULT_LEVEL;

-- default level for call_stack_level
DEFAULT_FULL_CALL_STACK_LEVEL   TLOG.LLEVEL%type   := DEFAULT_LEVEL;

-- default level for format error backtrace
DEFAULT_FT_ERR_BTRACE_LEVEL     TLOG.LLEVEL%type   := DEFAULT_LEVEL;

-- use for build a string section
DEFAULT_Section_sep             TLOG.LSECTION%type := '.';

-- Formats output sent to DBMS_OUTPUT to this width.
DEFAULT_DBMS_OUTPUT_LINE_WRAP   NUMBER := 100;

-- Default message formatting string
-- Maintains backwards compatability with VLOG message format
DEFAULT_FORMAT                  TLOG.LTEXT%TYPE := '%(seps)%(date):%(hsecs)%(sepe)%(seps)%(level)%(sepe)%(seps)%(user)%(sepe)%(seps)%(sid)%(sepe)%(seps)%(section)%(sepe)%(seps)%(text)%(sepe)'; 

DEFAULT_DATE_FORMAT             TLOG.LTEXT%TYPE := 'Mon DD, HH24:MI:SS';

DEFAULT_FORMAT_SEP_START        VARCHAR2(100) := '[';
DEFAULT_FORMAT_SEP_END          VARCHAR2(100) := ']';

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
