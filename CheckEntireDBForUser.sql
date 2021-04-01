-- Search for this username in the sql server
-- And returns the table with dbs containing the given username

declare @dbname varchar(max),@user varchar(50),@queryUser varchar(max)
-- put your username here
SET @user = 'yourusername';


IF OBJECT_ID ('tempdb..#temp') is not null
BEGIN
    drop table #temp
END
 
IF OBJECT_ID ('tempdb..#HoldTB') is not null
BEGIN
    drop table #HoldTB
END

Create table #HoldTB
(
    dbName varchar(max),
    name varchar(max)
)
select name into #temp from master.sys.sysdatabases;

WHILE EXISTS(Select Top 1 name  from #temp)
BEGIN
    SET @dbname = (Select Top 1 name  from #temp);
	SET @queryUser = 'select '''+@dbname+''' AS dbName,name from '+@dbname+'.sys.sysusers where name='''+@user+''' '
    INSERT INTO #HoldTB EXEC(@queryUser)
    Delete from #temp WHere name = @dbname
END
select * from #HoldTB
drop table #HoldTB
drop table #temp