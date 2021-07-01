-- Error: 15138
-- Error: database principal owns a schema in the database and cannot be dropped
-- Query to get the user associated schema
-- Also check the schema for db_owner
select * from information_schema.schemata
where schema_owner = 'yourUserName'

-- Revoke the db_owner access to the database
-- Go to Object Explorer > Connect to the Target Server > Expand the target Database > Expand Security > Expand Roles > Expand Database Roles-> Right Click on the database role that you need to modify. 
-- You can see the user name "youruser" as the owner. Change it to "dbo"

-- Error: 15421
BEGIN 
    EXEC sp_executesql N'DROP SERVER ROLE [ServerRoleOwnedByUser1];';
END

-- Query to get the user associated Database Role
-- Check if the user has the dbowner rights
select DBPrincipal_2.name as role, DBPrincipal_1.name as owner 
from sys.database_principals as DBPrincipal_1 inner join sys.database_principals as DBPrincipal_2 
on DBPrincipal_1.principal_id = DBPrincipal_2.owning_principal_id 
where DBPrincipal_1.name = 'yourUserName'

-- Query to fix the error Msg 15138
-- Go to Object Explorer > Connect to the Target Server > Expand the target Database > Expand Security > Expand Schemas > Right Click on the schema that you need to modify.
-- Change the user name "youruser" as the owner to "dbo" or other user 
-- transferring ownership of schema from user to dbo
USE [db1]
GO
ALTER AUTHORIZATION ON ROLE::role_name_here TO [dbo]
GO
