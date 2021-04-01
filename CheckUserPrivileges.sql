declare @dbname varchar(max),@user varchar(max),@showPriviliges varchar(max)
-- Search for privilege of a given username in the sql server\
-- And returns the username and their privileges\

-- change this name to the username and the database you want to search\

SET @user = 'yourusername';
SET @dbname = 'yourDBName'

-- delete the user from the given database
SET @showPriviliges = 'Use '+@dbname+';
SHOW GRANTS FOR "'+@user+'";'

-- Execute the query
EXEC(@showPriviliges)