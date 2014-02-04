/*
Feature tested

PLOG
    DEFINE_APPLICATION_LEVEL
       features        
@E:\GGM\Perso\log4plsql\Log4plsql\sql\pslog
@E:\GGM\Perso\log4plsql\Log4plsql\sql\pblog

*/


insert into TLOGLEVEL (LLEVEL, LCODE, LDESC) Values (11,'Emerg',   'Standard unix/linux Level.');
insert into TLOGLEVEL (LLEVEL, LCODE, LDESC) Values (12,'Alert',   'Standard unix/linux Level.');
insert into TLOGLEVEL (LLEVEL, LCODE, LDESC) Values (21,'Crit',    'Standard unix/linux Level.');
insert into TLOGLEVEL (LLEVEL, LCODE, LDESC) Values (31,'Err',     'Standard unix/linux Level.');
insert into TLOGLEVEL (LLEVEL, LCODE, LDESC) Values (41,'Warning', 'Standard unix/linux Level.');
insert into TLOGLEVEL (LLEVEL, LCODE, LDESC) Values (51,'Notice',  'Standard unix/linux Level.');
insert into TLOGLEVEL (LLEVEL, LCODE, LDESC) Values (52,'Info',   'Standard unix/linux Level.');
insert into TLOGLEVEL (LLEVEL, LCODE, LDESC) Values (61,'Debug',   'Standard unix/linux Level.');

Commit;

select LCODE, LLEVEL from TLOGLEVEL order by LLEVEL
/

exec PLOG.PURGE;


declare
    pCTX       PLOGPARAM.LOG_CTX := PLOG.init('workLevel', PLOG.LALL, pLOG4J => TRUE);
begin 
    plog.info( 'Log with default level: '|| plog.getLevel ());
    plog.log ( 'Debug' , 'Test Custom log level Debug');
    plog.log ( 'Info' , 'Test Custom log level Info');
    plog.log ( 'Notice' , 'Test Custom log level Notice');
    plog.log ( 'Warning' , 'Test Custom log level Warning');
    plog.log ( 'Err' , 'Test Custom log level Err');
    plog.log ( 'Crit' , 'Test Custom log level Crit');
    plog.log ( 'Alert' , 'Test Custom log level Alert');
    plog.log ( 'Emerg' , 'Test Custom log level Emerg');

    plog.info(pCTX, 'Log with level: '|| plog.getLevel (pCTX));
    plog.log (pCTX, 'Debug' , 'Test Custom log level Debug');
    plog.log (pCTX, 'Info' , 'Test Custom log level Info');
    plog.log (pCTX, 'Notice' , 'Test Custom log level Notice');
    plog.log (pCTX, 'Warning' , 'Test Custom log level Warning');
    plog.log (pCTX, 'Err' , 'Test Custom log level Err');
    plog.log (pCTX, 'Crit' , 'Test Custom log level Crit');
    plog.log (pCTX, 'Alert' , 'Test Custom log level Alert');
    plog.log (pCTX, 'Emerg' , 'Test Custom log level Emerg');
end;
/

select * from vlog;

/*

select LCODE, LLEVEL from TLOGLEVEL order by LLEVEL

LCODE          LLEVEL
---------- ----------
OFF                10
Emerg              11
Alert              12
FATAL              20
Crit               21
ERROR              30
Err                31
WARN               40
Warning            41
INFO               50
Notice             51
Info               52
DEBUG              60
Debug              61
ALL                70

15 ligne(s) sélectionnée(s).

SQL> 

SQL> 
SQL> exec PLOG.PURGE;

Procédure PL/SQL terminée avec succès.

SQL> 
SQL> commit;

Validation effectuée.

SQL> 
SQL> declare
  2      pCTX       PLOG.LOG_CTX := PLOG.init('workLevel', PLOG.LALL, pLOG4J => TRUE);
  3  begin 
  4      plog.info( 'Log with default level: '|| plog.getLevel ());
  5      plog.log ( 'Debug' , 'Test Custom log level Debug');
  6      plog.log ( 'Info' , 'Test Custom log level Info');
  7      plog.log ( 'Notice' , 'Test Custom log level Notice');
  8      plog.log ( 'Warning' , 'Test Custom log level Warning');
  9      plog.log ( 'Err' , 'Test Custom log level Err');
 10      plog.log ( 'Crit' , 'Test Custom log level Crit');
 11      plog.log ( 'Alert' , 'Test Custom log level Alert');
 12      plog.log ( 'Emerg' , 'Test Custom log level Emerg');
 13  
 14      plog.info(pCTX, 'Log with level: '|| plog.getLevel (pCTX));
 15      plog.log (pCTX, 'Debug' , 'Test Custom log level Debug');
 16      plog.log (pCTX, 'Info' , 'Test Custom log level Info');
 17      plog.log (pCTX, 'Notice' , 'Test Custom log level Notice');
 18      plog.log (pCTX, 'Warning' , 'Test Custom log level Warning');
 19      plog.log (pCTX, 'Err' , 'Test Custom log level Err');
 20      plog.log (pCTX, 'Crit' , 'Test Custom log level Crit');
 21      plog.log (pCTX, 'Alert' , 'Test Custom log level Alert');
 22      plog.log (pCTX, 'Emerg' , 'Test Custom log level Emerg');
 23  end;
 24  /

Procédure PL/SQL terminée avec succès.

SQL> 
SQL> select * from vlog;

LOG
--------------------------------------------------------------------------------
[Dec 22, 17:21:12:87][UNDEFINED][ULOG][plog.purge][Purge By ULOG]
[Dec 22, 17:22:08:57][INFO][ULOG][workLevel][Log with level: ]
[Dec 22, 17:22:08:58][Debug][ULOG][workLevel][Test Custom log level Debug]
[Dec 22, 17:22:08:59][Info][ULOG][workLevel][Test Custom log level Info]
[Dec 22, 17:22:08:59][Notice][ULOG][workLevel][Test Custom log level Notice]
[Dec 22, 17:22:08:59][Warning][ULOG][workLevel][Test Custom log level Warning]
[Dec 22, 17:22:08:60][Err][ULOG][workLevel][Test Custom log level Err]
[Dec 22, 17:22:08:60][Crit][ULOG][workLevel][Test Custom log level Crit]
[Dec 22, 17:22:08:60][Alert][ULOG][workLevel][Test Custom log level Alert]
[Dec 22, 17:22:08:61][Emerg][ULOG][workLevel][Test Custom log level Emerg]

10 ligne(s) sélectionnée(s).

SQL> 

*/

/** in log4JbackgroundProcess
2003-12-22 17:22:08,420 INFO  [Thread-1] ULOG.workLevel    (            ?:?) DatabaseLoginDate:22 dÚcembre  2003 17:22:08:57 - Log with level:
2003-12-22 17:22:08,450 Debug [Thread-1] ULOG.workLevel    (            ?:?) DatabaseLoginDate:22 dÚcembre  2003 17:22:08:58 - Test Custom log level Debug
2003-12-22 17:22:08,490 Info  [Thread-1] ULOG.workLevel    (            ?:?) DatabaseLoginDate:22 dÚcembre  2003 17:22:08:59 - Test Custom log level Info
2003-12-22 17:22:08,530 Notice [Thread-1] ULOG.workLevel    (            ?:?) DatabaseLoginDate:22 dÚcembre  2003 17:22:08:59 - Test Custom log level Notice
2003-12-22 17:22:08,680 Warning [Thread-1] ULOG.workLevel    (            ?:?) DatabaseLoginDate:22 dÚcembre  2003 17:22:08:59 - Test Custom log level Warning
2003-12-22 17:22:08,710 Err   [Thread-1] ULOG.workLevel    (            ?:?) DatabaseLoginDate:22 dÚcembre  2003 17:22:08:60 - Test Custom log level Err
2003-12-22 17:22:08,750 Crit  [Thread-1] ULOG.workLevel    (            ?:?) DatabaseLoginDate:22 dÚcembre  2003 17:22:08:60 - Test Custom log level Crit
2003-12-22 17:22:08,790 Alert [Thread-1] ULOG.workLevel    (            ?:?) DatabaseLoginDate:22 dÚcembre  2003 17:22:08:60 - Test Custom log level Alert
2003-12-22 17:22:08,821 Emerg [Thread-1] ULOG.workLevel    (            ?:?) DatabaseLoginDate:22 dÚcembre  2003 17:22:08:61 - Test Custom log level Emerg
*/