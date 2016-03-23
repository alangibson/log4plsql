set verify off

ACCEPT V_USER CHAR PROMPT 'Enter the user name:'

GRANT EXECUTE ON &V_USER..PLOG_OUT_AQ TO PUBLIC;
GRANT EXECUTE ON &V_USER..PLOGPARAM TO PUBLIC;
GRANT EXECUTE ON &V_USER..PLOG TO PUBLIC;

create public synonym plog for  &V_USER..plog;
create public synonym plogparam for  &V_USER..plogparam;
create public synonym logmessage for  &V_USER..logmessage;
grant execute on  &V_USER..logmessage to public;

create public synonym tlog for &V_USER..tlog;
create public synonym vlog for &V_USER..vlog;
grant select on tlog to public;
grant select on vlog to public;

set verify on


