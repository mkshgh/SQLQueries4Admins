

-- THIS CODE WORKS

-- Search for all the dbs in the server FOR a SPECIFIC USER ONLY\
-- Get the list of roles for this user in all the DBs except the excluded ones\
-- Create a query to delete all the existing users and login, add new login and associate the users to the given DB with the roles extracted.

DECLARE @dbname varchar(max),@user varchar(max),@queryUser varchar(max)
DECLARE @excluded_users VARCHAR(max) = '''guest'',''dbo'',''dc_admin'',''dc_operator'',''dc_operator'',''dc_operator'',''dc_proxy'',''dc_proxy'',''MS_DataCollectorInternalUser'',''PolicyAdministratorRole'',''ServerGroupAdministratorRole'',''SQLAgentOperatorRole'',''SQLAgentReaderRole'',''UtilityIMRWriter'',''INFORMATION_SCHEMA'',''sys'',''##MS_PolicyEventProcessingLogin##'',''##MS_PolicyTsqlExecutionLogin##'''
DECLARE @get_user_db_policy_Query VARCHAR(max)
DECLARE @is_user_in_db_Query VARCHAR(max)
DECLARE @is_user_in_db BIGINT

-- Change this to your username
SET @user = 'yourusername'
IF OBJECT_ID ('tempdb..#tableDB') is not null
BEGIN
    drop table #tableDB
END
 
IF OBJECT_ID ('tempdb..#HoldTB') is not null
BEGIN
    drop table #HoldTB
END

IF OBJECT_ID ('tempdb..#temp') is not null
BEGIN
    drop table #temp
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
		ON rm.member_principal_id = m.principal_id and m.name = '''+@user+'''
	where m.name NOT IN ('+@excluded_users+')
	ORDER BY m.name';
	Create table #temp
	(
		nameMy varchar(max)
	)
	SET @is_user_in_db_Query = 'select name from '+@dbname+'.sys.sysusers where name='''+@user+''''
	INSERT INTO #temp EXEC(@is_user_in_db_Query)

	IF (SELECT * FROM #temp) is not NULL
	BEGIN
	INSERT INTO #HoldTB VALUES ('USE ['+@dbname+']')
	INSERT INTO #HoldTB VALUES ('DROP USER IF EXISTS "'+@user+'" ')
	INSERT INTO #HoldTB VALUES ('CREATE USER ['+@user+'] FOR LOGIN ['+@user+'] WITH DEFAULT_SCHEMA=[dbo]')
	INSERT INTO #HoldTB EXEC(@get_user_db_policy_Query)
	INSERT INTO #HoldTB VALUES ('GO')
	END
    Delete from #tableDB WHere name = @dbname
	drop table #temp
END

select * from #HoldTB
drop table #HoldTB
drop table #tableDB