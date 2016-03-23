-- drop queue if it exists
declare
  l$cnt integer := 0;
begin
    select count(1) into l$cnt
      from user_queue_tables
     where queue_table = 'QTAB_LOG';

    if l$cnt > 0 then
        -- stop the queue
        dbms_aqadm.stop_queue(queue_name => 'log_queue');

        --drop the queue
        dbms_aqadm.drop_queue('log_queue');

        -- force drop the queue table
        dbms_aqadm.drop_queue_table('qtab_log', true);

        -- force drop the type used for the queue
        execute immediate 'drop type T_LOG_QUEUE FORCE';
    end if;
end;
/
