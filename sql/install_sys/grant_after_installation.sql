set verify off

ACCEPT V_USER CHAR PROMPT 'Enter the user name:'

GRANT EXECUTE ON &V_USER..PLOG_OUT_AQ TO PUBLIC;
GRANT EXECUTE ON &V_USER..PLOG_PARAM TO PUBLIC;
GRANT EXECUTE ON &V_USER..PLOG TO PUBLIC;


set verify on

