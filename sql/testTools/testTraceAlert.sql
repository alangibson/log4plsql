/*
Feature tested

PLOG
    getLOG4PLSQVersion
       features        
*/

exec PLOG.PURGE;


declare
    pCTX       PLOGPARAM.LOG_CTX := PLOG.INIT(pALERT=>TRUE, pTRACE=>TRUE);
begin
    plog.error(pCTX, 'Send to all file'); 
end;
/    


declare
    pCTX       PLOGPARAM.LOG_CTX := PLOG.INIT();
begin
    plog.setBeginSection(pCTX, 'TraceTest');    
    if ( plog.getLOG_TRACEMode(pCTX) ) then
       plog.debug(pCTX, 'pCTX is true ');        
    else
        plog.debug(pCTX, 'pCTX is false');        
        plog.setLOG_TRACEMode(pCTX);
        plog.debug(pCTX, 'pCTX is true after setLOG_TRACEMode' );        
    end if;
    plog.info(pCTX,'find this message in TRACE File');   
    plog.setEndSection(pCTX, 'TraceTest');    
    plog.setLOG_TRACEMode(pCTX, FALSE);

    plog.setBeginSection(pCTX, 'AlertTest');    
    if ( plog.getLOG_ALERTMode(pCTX) ) then
       plog.debug(pCTX, 'pCTX is true ');        
    else
        plog.debug(pCTX,'pCTX is false');        
        plog.setLOG_ALERTMode(pCTX);
        plog.debug(pCTX,'pCTX is true after setLOG_ALERTMode' );        
    end if;
    plog.info(pCTX, 'find this message in ALERT File');   

end;
/    

select * from vlog;

/*

SQL> exec PLOG.PURGE;

Procédure PL/SQL terminée avec succès.

SQL> declare
  2      pCTX       PLOGPARAM.LOG_CTX := PLOG.INIT(pALERT=>TRUE, pTRACE=>TRUE);
  3  begin
  4      plog.error(pCTX, 'Send to all file'); 
  5  end;
  6  /    

Procédure PL/SQL terminée avec succès.

SQL> 
SQL> declare
  2      pCTX       PLOG.LOG_CTX;
  3  begin
  4      plog.setBeginSection(pCTX, 'TraceTest');    
  5      if ( plog.getLOG_TRACEMode(pCTX) ) then
  6         plog.debug(pCTX, 'pCTX is true ');        
  7      else
  8          plog.debug(pCTX, 'pCTX is false');        
  9          plog.setLOG_TRACEMode(pCTX);
 10          plog.debug(pCTX, 'pCTX is true after setLOG_TRACEMode' );        
 11      end if;
 12      plog.info(pCTX,'find this message in TRACE File');   
 13      plog.setEndSection(pCTX, 'TraceTest');    
 14      plog.setLOG_TRACEMode(pCTX, FALSE);
 15  
 16      plog.setBeginSection(pCTX, 'AlertTest');    
 17      if ( plog.getLOG_ALERTMode(pCTX) ) then
 18         plog.debug(pCTX, 'pCTX is true ');        
 19      else
 20          plog.debug(pCTX,'pCTX is false');        
 21          plog.setLOG_ALERTMode(pCTX);
 22          plog.debug(pCTX,'pCTX is true after setLOG_TRACEMode' );        
 23      end if;
 24      plog.info(pCTX, 'find this message in ALERT File');   
 25  
 26  end;
 27  /    

Procédure PL/SQL terminée avec succès.

SQL> 

LOG
--------------------------------------------------------------------------------
[Aou 15, 15:36:16:24][OFF][SCOTT][plog.purge][Purge By SCOTT]
[Aou 15, 15:36:16:62][ERROR][SCOTT][block][Send to all file]
[Aou 15, 15:36:17:64][DEBUG][SCOTT][block.TraceTest][pCTX is false]
[Aou 15, 15:36:17:65][DEBUG][SCOTT][block.TraceTest][pCTX is true after setLOG_TRACEMode]
[Aou 15, 15:36:18:74][INFO][SCOTT][block.TraceTest][find this message in TRACE File]
[Aou 15, 15:36:18:81][DEBUG][SCOTT][block.AlertTest][pCTX is false]
[Aou 15, 15:36:18:82][DEBUG][SCOTT][block.AlertTest][pCTX is true after setLOG_T
[Aou 15, 15:36:18:89][INFO][SCOTT][block.AlertTest][find this message in ALERT File]

8 ligne(s) sélectionnée(s).

SQL>

----------------------------------------------------------------
in trace directory


E:\Oracle9iR2\admin\gmdb\udump>type *

gmdb_ora_1272.trc


PLOG:2003-08-15 15:32:35:60 user: SCOTT level: ERROR logid: 18557 block
Send to all file
*** 2003-08-15 15:32:46.000
PLOG:2003-08-15 15:32:46:34 user: SCOTT level: DEBUG logid: 18559 .TraceTest
pCTX is true after setLOG_TRACEMode
PLOG:2003-08-15 15:32:46:43 user: SCOTT level: INFO logid: 18560 .TraceTest
find this message in TRACE File

E:\Oracle9iR2\admin\gmdb\udump>

----------------------------------------------------------------
in alert_gmdb.log file 

Dump file e:\oracle9ir2\admin\gmdb\bdump\alert_gmdb.log
Fri Aug 15 14:27:20 2003
ORACLE V9.2.0.1.0 - Production vsnsta=0
vsnsql=12 vsnxtr=3
Windows 2000 Version 5.0 Service Pack 1, CPU type 586
Fri Aug 15 14:27:20 2003
Starting ORACLE instance (normal)
LICENSE_MAX_SESSION = 0
LICENSE_SESSIONS_WARNING = 0
SCN scheme 2
Using log_archive_dest parameter default value
LICENSE_MAX_USERS = 0
SYS auditing is disabled
Starting up ORACLE RDBMS Version: 9.2.0.1.0.
System parameters with non-default values:
  processes                = 150
  timed_statistics         = TRUE
  shared_pool_size         = 50331648
  large_pool_size          = 8388608
  java_pool_size           = 0
  control_files            = E:\Oracle9iR2\oradata\gmdb\control01.ctl, E:\Oracle9iR2\oradata\gmdb\control02.ctl, E:\Oracle9iR2\oradata\gmdb\control03.ctl
  db_block_size            = 8192
  db_cache_size            = 25165824
  compatible               = 9.2.0.0.0
  db_file_multiblock_read_count= 16
  fast_start_mttr_target   = 300
  undo_management          = AUTO
  undo_tablespace          = UNDOTBS1
  undo_retention           = 10800
  remote_login_passwordfile= EXCLUSIVE
  db_domain                = 
  instance_name            = gmdb
  dispatchers              = (PROTOCOL=TCP) (SERVICE=gmdbXDB)
  hash_join_enabled        = TRUE
  background_dump_dest     = E:\Oracle9iR2\admin\gmdb\bdump
  user_dump_dest           = E:\Oracle9iR2\admin\gmdb\udump
  core_dump_dest           = E:\Oracle9iR2\admin\gmdb\cdump
  sort_area_size           = 524288
  db_name                  = gmdb
  open_cursors             = 300
  star_transformation_enabled= FALSE
  query_rewrite_enabled    = FALSE
  pga_aggregate_target     = 25165824
PMON started with pid=2
DBW0 started with pid=3
LGWR started with pid=4
CKPT started with pid=5
SMON started with pid=6
RECO started with pid=7
Fri Aug 15 14:27:28 2003
starting up 1 shared server(s) ...
starting up 1 dispatcher(s) for network address '(ADDRESS=(PARTIAL=YES)(PROTOCOL=TCP))'...
Fri Aug 15 14:27:30 2003
alter database mount exclusive 
Fri Aug 15 14:27:36 2003
Successful mount of redo thread 1, with mount id 2417075282.
Fri Aug 15 14:27:36 2003
Database mounted in Exclusive Mode.
Completed: alter database mount exclusive
Fri Aug 15 14:27:36 2003
alter database open
Fri Aug 15 14:27:39 2003
Beginning crash recovery of 1 threads
Fri Aug 15 14:27:39 2003
Started first pass scan
Fri Aug 15 14:27:53 2003
Completed first pass scan
 920 redo blocks read, 45 data blocks need recovery
Fri Aug 15 14:27:54 2003
Started recovery at
 Thread 1: logseq 86, block 6027, scn 0.0
Recovery of Online Redo Log: Thread 1 Group 2 Seq 86 Reading mem 0
  Mem# 0 errs 0: E:\ORACLE9IR2\ORADATA\GMDB\REDO02.LOG
Fri Aug 15 14:27:56 2003
Ended recovery at
 Thread 1: logseq 86, block 6947, scn 0.6362990
 45 data blocks read, 45 data blocks written, 920 redo blocks read
Crash recovery completed successfully
Fri Aug 15 14:27:57 2003
Thread 1 advanced to log sequence 87
Thread 1 opened at log sequence 87
  Current log# 3 seq# 87 mem# 0: E:\ORACLE9IR2\ORADATA\GMDB\REDO03.LOG
Successful open of redo thread 1.
Fri Aug 15 14:27:58 2003
SMON: enabling cache recovery
Fri Aug 15 14:28:02 2003
Undo Segment 1 Onlined
Undo Segment 2 Onlined
Undo Segment 3 Onlined
Undo Segment 4 Onlined
Undo Segment 5 Onlined
Undo Segment 6 Onlined
Undo Segment 7 Onlined
Undo Segment 8 Onlined
Undo Segment 9 Onlined
Undo Segment 10 Onlined
Successfully onlined Undo Tablespace 1.
Fri Aug 15 14:28:03 2003
SMON: enabling tx recovery
Fri Aug 15 14:28:03 2003
Database Characterset is WE8MSWIN1252
replication_dependency_tracking turned off (no async multimaster replication found)
Completed: alter database open
Fri Aug 15 15:32:35 2003
PLOG:2003-08-15 15:32:35:60 user: SCOTT level: ERROR logid: 18557 block
Send to all file
PLOG:2003-08-15 15:32:46:50 user: SCOTT level: DEBUG logid: 18562 .AlertTest
pCTX is true after setLOG_TRACEMode
PLOG:2003-08-15 15:32:46:57 user: SCOTT level: INFO logid: 18563 .AlertTest
find this message in ALERT File
---------------------------------------------------------------------------

*/