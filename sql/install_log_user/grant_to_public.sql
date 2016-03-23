-------------------------------------------------------------------
--
-- History : who                 created     comment
--     V1    Guillaume Moulard   18-AVR-02   Creation
--                                     
--
-------------------------------------------------------------------
/*
 * Copyright (C) LOG4PLSQL project team. All rights reserved.
 *
 * This software is published under the terms of the The LOG4PLSQL 
 * Software License, a copy of which has been included with this
 * distribution in the LICENSE.txt file.  
 * see: <http://log4plsql.sourceforge.net>  */
 
 
GRANT EXECUTE ON PLOG TO PUBLIC
/

DROP PUBLIC SYNONYM PLOG
/

CREATE  PUBLIC SYNONYM PLOG
    FOR PLOG
/



grant select on tlog to public
/

DROP PUBLIC SYNONYM tlog
/

CREATE  PUBLIC SYNONYM tlog
    FOR tlog
/


grant select on vlog to public
/

DROP PUBLIC SYNONYM vlog
/

CREATE  PUBLIC SYNONYM vlog
    FOR vlog
/




-------------------------------------------------------------------
-- End of document
-------------------------------------------------------------------

