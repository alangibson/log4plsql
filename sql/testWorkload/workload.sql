-------------------------------------------------------------------
--
--  Nom script         : Workload.sql
--
--  Objectif           : performance test
-------------------------------------------------------------------
--
-- History : who                 created     comment
--     V1    Guillaume Moulard   11-Jui-02   Creation
--     V2    Bertrand Caradec    06-JUN-08   new function names, queue test                                
--
-------------------------------------------------------------------


CREATE OR REPLACE PROCEDURE workload_notrace IS
--------------------------------------------------- 
-- This function calls 100 000 times the info log function.
-- NO trace is written because the limit log level is set to WARNING.
--------------------------------------------------- 

vctx PLOGPARAM.LOG_CTX;
 counter PLS_INTEGER;
BEGIN  
  vctx := PLOG.INIT(NULL, PLOG.LWARN);

  FOR counter IN 1 .. 100000 LOOP     
    PLOG.INFO(vctx, 'debug test');
  END LOOP;
END;
/


CREATE OR REPLACE PROCEDURE workload_trace_in_tlog IS
--------------------------------------------------- 
-- This function calls 100 000 times the info log function.
-- Trace are written in the table TLOG
--------------------------------------------------- 

  vctx PLOGPARAM.LOG_CTX;
  counter PLS_INTEGER;

BEGIN
  vctx := PLOG.INIT(NULL, PLOG.LDEBUG);
  
  FOR counter IN 1 .. 100000 LOOP
     PLOG.INFO(vctx, 'debug test');
  END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE workload_trace_in_tlog_queue IS
--------------------------------------------------- 
-- This function calls 100 000 times the info log function.
-- Trace are written in the table TLOG and in the queue (read for the Java background process)
---------------------------------------------------    
   vctx PLOGPARAM.LOG_CTX;
   counter PLS_INTEGER;
BEGIN
  vctx := PLOG.INIT(NULL, PLOG.LDEBUG, TRUE);
  FOR counter IN 1 .. 100000 LOOP
     PLOG.INFO(vctx, 'debug test');  
  END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE workload_trace_in_queue IS
--------------------------------------------------- 
-- This function calls 100 000 times the info log function.
-- Trace are written in the queue only(read for the Java background process)
---------------------------------------------------     

vctx PLOGPARAM.LOG_CTX;
  counter PLS_INTEGER;
BEGIN
  vctx := PLOG.INIT(NULL, PLOG.LDEBUG, TRUE, FALSE);

  FOR counter IN 1 .. 100000 LOOP
     PLOG.INFO(vctx, 'debug test');
  END LOOP;
END;
/