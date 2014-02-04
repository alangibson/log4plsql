create or replace function fct_test_log return number
is
    pCTX PLOGPARAM.LOG_CTX := PLOG.init(null, PLOG.LDEBUG, TRUE, TRUE);
begin 
        PLOG.debug (pCTX, 'message for debug');
        PLOG.info  (pCTX, 'message for information');
        PLOG.warn  (pCTX, 'message for warning ');
        PLOG.error (pCTX, 'message for error');
        PLOG.fatal (pCTX, 'message for fatal');
        return 0;
end fct_test_log;
/
sho error

create or replace procedure proc_test_log 
is
    pCTX PLOGPARAM.LOG_CTX := PLOG.init(null, PLOG.LDEBUG, TRUE, TRUE);
    temp  number; 
begin 
        temp := fct_test_log;
        PLOG.debug (pCTX, 'message for debug');
        PLOG.info  (pCTX, 'message for information');
        PLOG.warn  (pCTX, 'message for warning ');
        PLOG.error (pCTX, 'message for error');
        PLOG.fatal (pCTX, 'message for fatal');
end proc_test_log;
/
sho error

create or replace procedure proc_test_log2 (pCTX in out PLOGPARAM.LOG_CTX) 
is
begin 
        PLOG.error (pCTX, 'in sub section');
end proc_test_log2;
/
sho error


declare
    pCTX PLOGPARAM.LOG_CTX := PLOG.init(null, PLOG.LDEBUG, TRUE, TRUE);
begin 
    PLOG.SetBeginSection (pCTX, 'codePart1');
        PLOG.debug (pCTX, 'message for debug');
        PLOG.info  (pCTX, 'message for information');
        PLOG.warn  (pCTX, 'message for warning ');
        PLOG.error (pCTX, 'message for error');
        PLOG.fatal (pCTX, 'message for fatal');
    PLOG.SetBeginSection (pCTX, 'codePart2');
        PLOG.info  (pCTX, 'information message');
    PLOG.SetEndSection (pCTX);
    proc_test_log;
    PLOG.SetBeginSection (pCTX, 'call->proc_test_log');
        proc_test_log2 (pCTX);
    PLOG.SetEndSection (pCTX);
End;
/


/* No result un SQLPLUS.
but in backgroundProcess output
2008-06-05 08:54:43,597 DEBUG [Thread-2] block.codePart1   (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for debug
2008-06-05 08:54:43,764 INFO  [Thread-2] block.codePart1   (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for information
2008-06-05 08:54:43,922 WARN  [Thread-2] block.codePart1   (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for warning
2008-06-05 08:54:44,152 ERROR [Thread-2] block.codePart1   (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for error
2008-06-05 08:54:44,311 FATAL [Thread-2] block.codePart1   (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for fatal
2008-06-05 08:54:44,470 INFO  [Thread-2] codePart1.codePart2 (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - information message
2008-06-05 08:54:44,630 DEBUG [Thread-2] PROC_TEST_LOG-->PL.FCT_TEST_LOG (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for debug
2008-06-05 08:54:44,852 INFO  [Thread-2] PROC_TEST_LOG-->PL.FCT_TEST_LOG (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for information
2008-06-05 08:54:45,010 WARN  [Thread-2] PROC_TEST_LOG-->PL.FCT_TEST_LOG (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for warning
2008-06-05 08:54:45,176 ERROR [Thread-2] PROC_TEST_LOG-->PL.FCT_TEST_LOG (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for error
2008-06-05 08:54:45,335 FATAL [Thread-2] PROC_TEST_LOG-->PL.FCT_TEST_LOG (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for fatal
2008-06-05 08:54:45,569 DEBUG [Thread-2] block-->PL.PROC_TEST_LOG (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for debug
2008-06-05 08:54:45,729 INFO  [Thread-2] block-->PL.PROC_TEST_LOG (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for information
2008-06-05 08:54:45,886 WARN  [Thread-2] block-->PL.PROC_TEST_LOG (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for warning
2008-06-05 08:54:46,045 ERROR [Thread-2] block-->PL.PROC_TEST_LOG (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for error
2008-06-05 08:54:46,268 FATAL [Thread-2] block-->PL.PROC_TEST_LOG (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - message for fatal
2008-06-05 08:54:46,427 ERROR [Thread-2] block.call->proc_test_log (            ?:?) DatabaseLoginDate:2008-06-05 08:54:09.0 - in sub section
*/