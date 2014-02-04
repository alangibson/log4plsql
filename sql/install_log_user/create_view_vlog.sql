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
select '['||to_char(LDATE, 'Mon DD, HH24:MI:SS')||':'||LTRIM(to_char(mod(LHSECS,100),'09'))||']'||
       '['||plogparam.getLevelInText(llevel)||']['||
       LUSER||']['||
       LSECTION||']['||
       LTEXT||']' log
from (select * from (select * from tlog order by id desc) where rownum < 25) 
order by ID
/




-------------------------------------------------------------------
-- End of document
-------------------------------------------------------------------

