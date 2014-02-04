--
-- 
--

--@sql/install_log_user/create_type_logmessage.sql
--@sql/install_log_user/ps_plog.sql
--@sql/install_log_user/pb_plog.sql


begin 
    PLOG.PURGE();
end;
/

declare
    pCTX_ALL   PLOGPARAM.LOG_CTX := PLOG.init('workLevel', PLOG.LALL);
    pMESSAGE1 LOGMESSAGE := LOGMESSAGE('key1','value1', 'key2',222);
begin
    PLOG.log(pCTX => pCTX_ALL, pLEVEL => PLOG.LINFO, pLOGMESSAGE => pMESSAGE1);
    PLOG.log(pCTX => pCTX_ALL, pLEVEL => 'INFO', pLOGMESSAGE => pMESSAGE1);
    PLOG.log(pLEVEL => PLOG.LINFO, pLOGMESSAGE  => pMESSAGE1);
    PLOG.log(pLEVEL => 'INFO', pLOGMESSAGE  => pMESSAGE1) ;
    -- TODO MISSING? PLOG.log(pLEVEL => 'INFO', pMESSAGE1) ;

    PLOG.debug(pCTX => pCTX_ALL, pLOGMESSAGE => pMESSAGE1);
    PLOG.debug(pLOGMESSAGE  => pMESSAGE1);
    PLOG.debug(pMESSAGE1);
    
    PLOG.info(pCTX => pCTX_ALL, pLOGMESSAGE => pMESSAGE1);
    PLOG.info(pLOGMESSAGE  => pMESSAGE1);
    PLOG.info(pMESSAGE1);
    
    PLOG.warn(pCTX => pCTX_ALL, pLOGMESSAGE => pMESSAGE1);
    PLOG.warn(pLOGMESSAGE  => pMESSAGE1);
    PLOG.warn(pMESSAGE1);
    
    PLOG.error(pCTX => pCTX_ALL, pLOGMESSAGE => pMESSAGE1);
    PLOG.error(pLOGMESSAGE  => pMESSAGE1);
    PLOG.error(pMESSAGE1);
    
    PLOG.fatal(pCTX => pCTX_ALL, pLOGMESSAGE => pMESSAGE1);
    PLOG.fatal(pLOGMESSAGE  => pMESSAGE1);
    PLOG.fatal(pMESSAGE1);
end;
/

select * from vlog;

--
-- Test json escaping
--
select PLOG.jsonEscape(chr(10)||chr(13)||'"'||'\'||'/'||'    ') from dual;
-- \u005Cu000D\u005Cu000A\u005Cu0022\u005C\u002F\u0009

--
-- Test logging messages with special chars
--

begin 
    PLOG.PURGE();
end;
/

declare
    pCTX_ALL   PLOGPARAM.LOG_CTX := PLOG.init('workLevel', PLOG.LALL);
    pMESSAGE1 LOGMESSAGE := LOGMESSAGE('key1','line1'||chr(10)||chr(13)||'line 2');
begin
    PLOG.log(pLEVEL => 'INFO', pLOGMESSAGE  => pMESSAGE1) ;
end;
/

--
--
--

begin
      plog.error(LOGMESSAGE(
        'plsql_unit', $$plsql_unit||'.f_get_pruid_mapinfo',
        'plsql_line', $$plsql_line,
        'sqlerrm', SQLERRM));
end;
/



select * from vlog;

