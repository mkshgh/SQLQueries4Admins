declare @dbname varchar(max),@user varchar(max),@deleteQuery varchar(max)
-- put your username and DB name here
SET @user = 'yourusername';
SET @dbname = 'DBNAME'

-- delete the user from the given database
SET @deleteQuery = 'Use '+@dbname+';
DROP USER IF EXISTS "'+@user+'";'

-- Execute the query
EXEC(@deleteQuery)