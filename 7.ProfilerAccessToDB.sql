# Give DB owner permission to the user
USE your_db_name;
GO
exec sp_addrolemember 'db_owner', 'mkshgh';
GO

# Check the permission is provided
sp_helplogins mkshgh

# REVOKE ALTER TRACE permission 
USE master;
GO
GRANT ALTER TRACE TO mkshgh
GO

# REVOKE ALTER TRACE permission but if only needed. Here we wont need this.
USE Master;
GO
REVOKE ALTER TRACE FROM mkshgh;
GO

# Your query is done now.
