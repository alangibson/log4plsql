-------------------------------------------------------------------
--
--  File : output_aq.sql (SQLPlus script)
--
--  Description : installation of components for the log output in advanced queue:
--                1) queue types T_LOG_QUEUE, T_ARRAY_LOG_QUEUE
--                2) queue table QTAB_LOG_TOPIC (multi-consumer)
--                3) queue QTAB_LOG
--                4) subscriber LOG4J
--                5) package PLOG_OUT_AQ    
--                The queue is read by the LOG4J background process.
--                Note: grant on DBMS_SYSTEM is needed
-------------------------------------------------------------------
--
-- history : who                 created     comment
--     V1    Bertrand Caradec    15-MAY-08   Creation
--                                     
--
-------------------------------------------------------------------


PROMPT Create type T_LOG_QUEUE ...

@@create_type_t_log_queue

PROMPT Create type T_ARRAY_LOG_QUEUE ...

@@create_type_t_array_log_queue

PROMPT Create the queue table QTAB_LOG ...

exec dbms_aqadm.create_queue_table('qtab_log','T_LOG_QUEUE');

--exec dbms_aqadm.create_queue_table('qtab_log_topic','T_LOG_QUEUE', multiple_consumers => TRUE);

PROMPT Create the queue LOG_QUEUE in the table QTAB_LOG ...

exec dbms_aqadm.create_queue('log_queue', 'qtab_log'); 

--exec dbms_aqadm.create_queue('log_queue_topic', 'qtab_log_topic'); 

PROMPT Start the queue ...

exec dbms_aqadm.start_queue('log_queue');

--exec dbms_aqadm.start_queue('log_queue_topic');


--PROMPT Add subscriber 'LOG4J' for the topic

--exec DBMS_AQADM.ADD_SUBSCRIBER ('log_queue_topic', sys.aq$_agent('LOG4J', null, null), 'tab.user_data.llevel >= 0');

PROMPT Create package PLOG_OUT_AQ ...

@@ps_plog_out_aq
@@pb_plog_out_aq_queue
--@@pb_plog_out_aq_topic