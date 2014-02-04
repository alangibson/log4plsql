-------------------------------------------------------------------
--
--  File : create_user.sql (SQLPlus script)
--
--  Description : Administrator file.
--                Creation of a user for the log framework.
--                Basis grants are also done to the user.
-------------------------------------------------------------------
--
-- history : who                 created     comment
--     V1    Bertrand Caradec    15-MAY-08   Creation
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


-- create a user
set verify off

ACCEPT V_USER CHAR PROMPT 'Enter the user name:'
ACCEPT V_PASSWORD CHAR PROMPT 'Enter the password:'

ACCEPT V_TS CHAR DEFAULT 'USERS' PROMPT 'Enter default tablespace [USERS]:'

CREATE USER &V_USER
IDENTIFIED BY &V_PASSWORD
DEFAULT TABLESPACE &V_TS;
 
GRANT CONNECT TO &V_USER;

GRANT CREATE TABLE TO &V_USER;

GRANT CREATE VIEW TO &V_USER;

GRANT CREATE TYPE TO &V_USER;

GRANT CREATE PROCEDURE TO &V_USER;

GRANT CREATE SEQUENCE TO &V_USER;

-- set tablespace quota for the user
-- ALTER USER &V_USER QUOTA 100M ON &V_TS;
GRANT UNLIMITED TABLESPACE TO &V_USER;

set verify on





   