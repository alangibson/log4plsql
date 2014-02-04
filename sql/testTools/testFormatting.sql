
-- TODO regresson test VLOG vis a vis default perameters
-- select * from vlog;

select
    PLOG.formatMessage(pFORMAT     => '%(date)%(sepe)%(level)%(sepe)%(section)%(sepe)%(text)',
                        pDATEFORMAT => 'YYYY-MM-DD"T"HH24:MI:SS.FFTZR',
                        pSEPSTART   => '',
                        pSEPEND     => '|',
                        pID         => ID,
                        pLDATE      => LDATE,
                        pLHSECS     => LHSECS,
                        pLLEVEL     => LLEVEL,
                        pLSECTION   => LSECTION,
                        pLUSER      => LUSER,
                        pLTEXT      => LTEXT,
                        pLINSTANCE  => LINSTANCE 
                        ) log
from tlog 
order by ID;

