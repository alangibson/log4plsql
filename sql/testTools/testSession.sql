/*
test the logging in the view v$session

*/

create or replace procedure test_session is
  v_log_ctx PLOGPARAM.LOG_CTX;
BEGIN
  v_log_ctx := plog.init(pSESSION => TRUE); 

  plog.info(v_log_ctx, 'info test');
plog.info('info test');

END;
/

exec test_session;

-- query the view V$SESSION
select module, client_info, action 
from v$session 
where username = 'PL';


/*
Procedure created.


PL/SQL procedure successfully completed.

10:30:08 SYS>select module, client_info, action from v$session where username = 'PL';

MODULE
------------------------------------------------
CLIENT_INFO
----------------------------------------------------------------
ACTION
--------------------------------
block-->PL.TEST_SESSION User:PL
info test
INFO 05.06.2008 10:22:47
*/