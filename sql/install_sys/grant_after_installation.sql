set verify off

ACCEPT V_USER CHAR PROMPT 'Enter the user name:'

GRANT EXECUTE ON &V_USER..PLOG_OUT_AQ TO PUBLIC;
GRANT EXECUTE ON &V_USER..PLOGPARAM TO PUBLIC;
GRANT EXECUTE ON &V_USER..PLOG TO PUBLIC;

create public synonym plog for plog;
create public synonym logmessage for logmessage;
grant execute on logmessage to public;

create public synonym tlog for tlog;
create public synonym vlog for vlog;
grant select on tlog to public;
grant select on vlog to public;

set verify on


