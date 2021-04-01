-- THIS CODE WORKS

-- Search for all the dbs in the server FOR all USERS NOW
-- Get the list of users and their roles in all the DBs except the excluded ones
-- Create a query to delete all the existing users and login, add new login and associate the users to the given DB with the roles extracted.

DECLARE @dbname varchar(max),@queryUser varchar(max)
DECLARE @excluded_users VARCHAR(max) = '''guest'',''dbo'',''dc_admin'',''dc_operator'',''dc_operator'',''dc_operator'',''dc_proxy'',''dc_proxy'',''MS_DataCollectorInternalUser'',''PolicyAdministratorRole'',''ServerGroupAdministratorRole'',''SQLAgentOperatorRole'',''SQLAgentReaderRole'',''UtilityIMRWriter'',''INFORMATION_SCHEMA'',''sys'',''##MS_PolicyEventProcessingLogin##'',''##MS_PolicyTsqlExecutionLogin##'''
DECLARE @get_user_db_policy_Query VARCHAR(max)
DECLARE @get_user_db_users_Query VARCHAR(max)

IF OBJECT_ID ('tempdb..#tableDB') is not null
BEGIN
    drop table #tableDB
END
 
IF OBJECT_ID ('tempdb..#HoldTB') is not null
BEGIN
    drop table #HoldTB
END

Create table #HoldTB
(
    DBUserCreation varchar(max)
)


select name into #tableDB from master.sys.sysdatabases;

WHILE EXISTS(Select Top 1 name  from #tableDB)
BEGIN
	SET @dbname = (Select Top 1 name  from #tableDB);
	SET @get_user_db_policy_Query = 'USE ['+@dbname+'];
	SELECT ''ALTER AUTHORIZATION ON SCHEMA::''+r.name+'' TO [dbo];ALTER ROLE [''+r.name+''] ADD MEMBER [''+m.name+'']'' AS ''DBUserCreation''
	FROM sys.database_role_members rm
	JOIN sys.database_principals r
		ON rm.role_principal_id = r.principal_id
	JOIN sys.database_principals m 
		ON rm.member_principal_id = m.principal_id
	where m.name NOT IN ('+@excluded_users+')
	ORDER BY m.name';

	SET @get_user_db_users_Query = 'USE ['+@dbname+'];
	SELECT ''DROP USER IF EXISTS ''+m.name+'';CREATE USER [''+m.name+''] FOR LOGIN [''+m.name+''] WITH DEFAULT_SCHEMA=[dbo]''
	from sys.database_principals m
	where m.type not in (''U'',''C'',''A'', ''G'', ''R'', ''X'')
      and m.sid is not null
      and m.name NOT IN ('+@excluded_users+')
	order by m.name;';
	


	print @get_user_db_users_Query
	INSERT INTO #HoldTB VALUES ('USE ['+@dbname+'];')
	INSERT INTO #HoldTB EXEC(@get_user_db_users_Query)
	INSERT INTO #HoldTB EXEC(@get_user_db_policy_Query)
	INSERT INTO #HoldTB VALUES ('GO')
    Delete from #tableDB WHere name = @dbname
END

select * from #HoldTB
drop table #HoldTB
drop table #tableDB