-------------------------------------------------------------------
--
--  File : install.sql (SQLPlus script)
--
--  Description : installation of the LOG4PLSQL framework
-------------------------------------------------------------------
--
-- history : who                 created     comment
--     v1    Bertrand Caradec   15-MAY-08    creation
--                                     
--
-------------------------------------------------------------------
/*
 * Copyright (C) LOG4PLSQL project team. All rights reserved.
 *
 * This software is published under the terms of the The LOG4PLSQL 
 * Software License, a copy of which has been included with this
 * distribution in the LICENSE.txt file.  
 * see: <http://log4plsql.sourceforge.net>  */


spool install.txt

PROMPT LOG4PLSQL Installation
PROMPT **********************
PROMPT 

SET VERIFY OFF


PROMPT Create table TLOGLEVEL ...

@@create_table_tloglevel

PROMPT Insert rows into TLOGLEVEL ...

@@insert_into_tloglevel

PROMPT Create table TLOG ...

@@create_table_tlog

PROMPT Create sequence SQ_STG ...

@@create_sequence_sq_stg

PROMPT Create package PLOGPARAM ...

@@ps_plogparam
@@pb_plogparam

PROMPT Create package PLOG_OUT_TLOG ...

@@ps_plog_out_tlog
@@pb_plog_out_tlog


-- installation of the optional packages
SET FEEDBACK OFF

PROMPT 
PROMPT Installation of optional packages
PROMPT *********************************

PROMPT Please select the log outputs you want to install (y:yes - n:no) 

ACCEPT V_DBMS_OUTPUT CHAR PROMPT 'DBMS_OUTPUT (package PLOG_OUT_DBMS_OUTPUT):'
ACCEPT V_ALERT CHAR PROMPT 'Alert file (package PLOG_OUT_ALERT):'
ACCEPT V_TRACE CHAR PROMPT 'Trace file (package PLOG_OUT_TRACE):'
ACCEPT V_AQ CHAR PROMPT 'Advanced queue (package PLOG_OUT_AQ):'
ACCEPT V_SESSION CHAR PROMPT 'Session info in V$SESSION (package PLOG_OUT_SESSION):'

VARIABLE output_dbms_output VARCHAR2(50);
VARIABLE output_alert VARCHAR2(50);
VARIABLE output_trace VARCHAR2(50);
VARIABLE output_aq VARCHAR2(50);
VARIABLE output_session VARCHAR2(50);
 
DECLARE
  V_DBMS_OUTPUT2 VARCHAR2(20) := '&V_DBMS_OUTPUT';
  V_ALERT2 VARCHAR2(20) := '&V_ALERT';  
  V_TRACE2 VARCHAR2(20) := '&V_TRACE';
  V_AQ2 VARCHAR2(20) := '&V_AQ';
  V_SESSION2 VARCHAR2(20) := '&V_SESSION';

BEGIN
      IF LOWER(V_DBMS_OUTPUT2) = 'y' THEN
	 :output_dbms_output := 'output_dbms_output';
      ELSE
         :output_dbms_output := 'dummy';
      END IF;

      IF LOWER(V_ALERT2) = 'y' THEN
	 :output_alert := 'output_alert';
      ELSE
         :output_alert := 'dummy';
      END IF;

      IF LOWER(V_TRACE2) = 'y' THEN
	 :output_trace := 'output_trace';
      ELSE
         :output_trace := 'dummy';
      END IF;

      IF LOWER(V_AQ2) = 'y' THEN
	 :output_aq := 'output_aq';
      ELSE
         :output_aq := 'dummy';
      END IF;

      IF LOWER(V_SESSION2) = 'y' THEN
	 :output_session := 'output_session';
      ELSE
         :output_session := 'dummy';
      END IF;

END;
/



column c_file_output_dbms new_value package_file_output_dbms noprint
select :output_dbms_output c_file_output_dbms from dual;

column c_file_output_alert new_value package_file_output_alert noprint
select :output_alert c_file_output_alert from dual;

column c_file_output_trace new_value package_file_output_trace noprint
select :output_trace c_file_output_trace from dual;

column c_file_output_aq new_value package_file_output_aq noprint
select :output_aq c_file_output_aq from dual;

column c_file_output_session new_value package_file_output_session noprint
select :output_session c_file_output_session from dual;

SET FEEDBACK ON

-- call the file to install the feature
@@&package_file_output_dbms
@@&package_file_output_alert
@@&package_file_output_trace
@@&package_file_output_aq
@@&package_file_output_session


PROMPT Create dynamically the package PLOG_INTERFACE ...

@@ps_plog_interface
@@pb_plog_interface

PROMPT Create the main package PLOG ...

@@ps_plog
@@pb_plog

PROMPT Create the view VLOG

@@create_view_vlog

spool off

