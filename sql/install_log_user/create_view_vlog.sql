-------------------------------------------------------------------
--
--  File : create_view_vlog.sql (SQLPlus script)
--
--  Description : creation of the view VLOG
-------------------------------------------------------------------
--
-- history : who                 created     comment
--     V0    Guillaume Moulard   18-AVR-02   Creation
--     V3    Guillaume Moulard   05-AUG-03   add ltrim in date part
--                                           use plog.getLevelInText                                    
--
-------------------------------------------------------------------
/*
 * Copyright (C) LOG4PLSQL project team. All rights reserved.
 *
 * This software is published under the terms of the The LOG4PLSQL 
 * Software License, a copy of which has been included with this
 * distribution in the LICENSE.txt file.  
 * see: <http://log4plsql.sourceforge.net>  */

create or replace  view VLOG as 
select
    PLOG.formatMessage(pID         => ID,
                        pLDATE      => LDATE,
                        pLHSECS     => LHSECS,
                        pLLEVEL     => LLEVEL,
                        pLSECTION   => LSECTION,
                        pLUSER      => LUSER,
                        pLTEXT      => LTEXT,
                        pLINSTANCE  => LINSTANCE 
                        ) log
from tlog 
order by ID
/


-------------------------------------------------------------------
-- End of document
-------------------------------------------------------------------

