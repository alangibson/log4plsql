-- stop the queue
exec dbms_aqadm.stop_queue(queue_name => 'log_queue');

-- drop the queue
exec dbms_aqadm.drop_queue('log_queue');


-- drop the queue table
exec dbms_aqadm.drop_queue_table('qtab_log');

-- drop the type used for the queue
drop type T_LOG_QUEUE;
