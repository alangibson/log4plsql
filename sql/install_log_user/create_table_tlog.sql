-------------------------------------------------------------------
--
--  File : create_table_tlog.sql (SQLPlus script)
--
--  Description : creation of the table TLOG
-------------------------------------------------------------------
--
-- history : who                 created     comment
--     v1    Bertrand Caradec   15-MAY-08    creation
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

CREATE TABLE TLOG
(
  ID       NUMBER, 
  LDATE    DATE DEFAULT SYSDATE, 
  LHSECS   NUMBER(38), 
  LLEVEL   NUMBER(38), 
  LSECTION VARCHAR2(2000 BYTE), 
  LTEXT    VARCHAR2(2000 BYTE), 
  LUSER    VARCHAR2(30 BYTE), 
  CONSTRAINT   PK_STG PRIMARY KEY (ID));





