-------------------------------------------------------------------
--
--  File : output_trace.sql (SQLPlus script)
--
--  Description : installation of the package PLOG_OUT_TRACE
--                Note: grant on DBMS_SYSTEM is needed
-------------------------------------------------------------------
--
-- history : who                 created     comment
--     V1    Bertrand Caradec    15-MAY-08   Creation
--                                     
--
-------------------------------------------------------------------
PROMPT Create package PLOG_OUT_TRACE ...

@@ps_plog_out_trace

@@pb_plog_out_trace
