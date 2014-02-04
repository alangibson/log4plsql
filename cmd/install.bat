@echo off

set HOST=%1
shift
set PORT=%1
shift
set SERVICE=%1
shift
set LOG_USERNAME=%1
shift
set LOG_PASSWORD=%1
shift
set SYS_PASSWORD=%1
shift
set DROP_LOG_USER=%1
shift
set CREATE_LOG_USER=%1
shift
set INSTALL_DBMS_OUTPUT=%1
shift
set INSTALL_ALERT=%1
shift
set INSTALL_TRACE=%1
shift
set INSTALL_AQ=%1
shift
set INSTALL_SESSION=%1

if %HOST%.==. goto help
if %PORT%.==. goto help
if %SERVICE%.==. goto help
if %LOG_USERNAME%.==. goto help
if %LOG_PASSWORD%.==. goto help
if %SYS_PASSWORD%.==. goto help
if %DROP_LOG_USER%.==. goto help
if %CREATE_LOG_USER%.==. goto help
:: if %INSTALL_DBMS_OUTPUT%.==. goto help
:: if %INSTALL_ALERT%.==. goto help
:: if %INSTALL_TRACE%.==. goto help
:: if %INSTALL_AQ%.==. goto help
:: if %INSTALL_SESSION%.==. goto help
if "%DROP_LOG_USER%"=="y" goto drop_log_user
if "%CREATE_LOG_USER%"=="y" goto create_log_user  

:drop_log_user
( echo %LOG_USERNAME% & echo exit ) | sqlplus sys/%SYS_PASSWORD%@%HOST%:%PORT%/%SERVICE% as sysdba @sql/install_sys/drop_user.sql
if "%CREATE_LOG_USER%"=="y" goto create_log_user
goto pre_install

:create_log_user
( echo %LOG_USERNAME% & echo %LOG_PASSWORD% & echo exit ) | sqlplus sys/%SYS_PASSWORD%@%HOST%:%PORT%/%SERVICE% as sysdba @sql/install_sys/create_user.sql
goto pre_install

:pre_install
( echo %LOG_USERNAME% & echo exit ) | sqlplus sys/%SYS_PASSWORD%@%HOST%:%PORT%/%SERVICE% as sysdba @sql/install_sys/grant_before_installation.sql
goto install_log_user

:install_log_user
:: ( echo %INSTALL_DBMS_OUTPUT% & echo %INSTALL_ALERT% & echo %INSTALL_TRACE% & echo %INSTALL_AQ% & echo %INSTALL_SESSION% & echo exit ) | sqlplus %LOG_USERNAME%/%LOG_PASSWORD%@%HOST%:%PORT%/%SERVICE% @sql/install_log_user/install.sql
sqlplus %LOG_USERNAME%/%LOG_PASSWORD%@%HOST%:%PORT%/%SERVICE% @sql/install_log_user/install.sql
goto post_install

:post_install
( echo %LOG_USERNAME% & echo exit ) | sqlplus sys/%SYS_PASSWORD%@%HOST%:%PORT%/%SERVICE% as sysdba @sql/install_sys/grant_after_installation.sql
goto end

:help

echo LOG4PLSQL Installer
echo.
echo Positional arguments:
echo   1. HOST                = Hostname or IP address of server
echo   2. PORT                = Oracle DB port
echo   3. SERVICE             = Service name
echo   4. LOG_USERNAME        = Logging schema username
echo   5. LOG_PASSWORD        = Logging schema password
echo   6. SYS_PASSWORD        = SYS password
echo   7. DROP_LOG_USER       = Should logging schema be dropped? [y or n]
echo   8. CREATE_LOG_USER     = Should logging schema be created? [y or n]
echo   9. INSTALL_DBMS_OUTPUT = Install DBMS_OUTPUT (package PLOG_OUT_DBMS_OUTPUT) [y or n]
echo  10. INSTALL_ALERT       = Alert file (package PLOG_OUT_ALERT) [y or n]
echo  11. INSTALL_TRACE       = Trace file (package PLOG_OUT_TRACE) [y or n]
echo  12. INSTALL_AQ          = Advanced queue (package PLOG_OUT_AQ) [y or n]
echo  13. INSTALL_SESSION     = Session info in V$SESSION (package PLOG_OUT_SESSION) [y or n]
echo.
echo You provided:
echo   HOST                = %HOST%
echo   PORT                = %PORT%
echo   SERVICE             = %SERVICE%
echo   LOG_USERNAME        = %LOG_USERNAME%
echo   LOG_PASSWORD        = %LOG_PASSWORD%
echo   SYS_PASSWORD        = %SYS_PASSWORD%
echo   DROP_LOG_USER       = %DROP_LOG_USER%
echo   CREATE_LOG_USER     = %CREATE_LOG_USER%
echo   INSTALL_DBMS_OUTPUT = %INSTALL_DBMS_OUTPUT%
echo   INSTALL_ALERT       = %INSTALL_ALERT%
echo   INSTALL_TRACE       = %INSTALL_TRACE%
echo   INSTALL_AQ          = %INSTALL_AQ%
echo   INSTALL_SESSION     = %INSTALL_SESSION%

goto end

:end