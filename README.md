# SQL QUERIES FOR SUPER ADMINS

Will keep on updating as I encounter more of these. 
These are more useful for the system admininstrators working with the sql server a lot.
Some of these queries have saved my ass a lot of times 😊😊✌✌

## 1.RecreateAllUsersWithRoles.sql

Lets say you need to transfer or recreate all the users in the entire server with thier privileges to a multiple DBs, it is time consuming to go and create the backup of all the users and transfer them to the new one. Maybe you forgot to take the backup of the users and it was late before you figured it out. This generates a table with code to do all that which you can copy paste and run. And BAZINGA! you have all your users all over the db again like magic.\
This also takes count of the sql **Error: 15138**\
Just create the user LOGIN before running the code if there are none.


### STEPS USED:

- Search for all the dbs in the server FOR a SPECIFIC USER ONLY\
- Get the list of roles for this user in all the DBs except the excluded ones\
- Create a query to delete all the existing users and login, add new login and associate the users to the given DB with the roles extracted.

### USAGE:

<code>
-- copy the generated code to the target server and relax and wait.
</code>
&nbsp;

## 2.RecreateUserWithRoles.sql

Lets say you need to transfer or recreate a user to a multiple DBs, it is time consuming to go and create the users in each of the DB. This generates a table with code to do all that which you can copy paste and run. And BAZINGA! you have your user all over the db again like magic.\
This also takes count of the sql **Error: 15138**\
Just create the user LOGIN before running the code if there are none.


### STEPS USED:

- Search for all the dbs in the server FOR a SPECIFIC USER ONLY\
- Get the list of roles for this user in all the DBs except the excluded ones\
- Create a query to delete all the existing users and login, add new login and associate the users to the given DB with the roles extracted.

### USAGE:

<code>

-- change this name to the username you want to repopulate the db with\
\>  SET @user = 'yourusername';

</code>
&nbsp;

## 3.CheckEntireDBForUser.sql

Say you have to search all the database for a specific users and some of the users are not in the login. In that case, just searching through the table **sys.sysusers** table won't cut it. Use this script to list all the users whether they have a adjacent login in the system or not. It will show you all the users list

### USAGE:

<code>

-- Search for this username in the sql server\
-- And returns the table with dbs containing the given username\
-- change this name to the username you want to search

\>  SET @user = **'yourusername'**;

</code>
&nbsp;

## 4.CheckUserPrivileges.sql

Search for privilege of a given username in the sql server and get the And returns the username and their privileges using **SHOW GRANTS QUERY** in return.

### USAGE:

<code>

-- Search for privilege of a given username in the sql server\
-- And returns the username and their privileges\
-- change this name to the username and the database you want to search

\>  SET @user = **'yourusername'**;\
\>  SET @dbname = **'yourDBName'**;

</code>
&nbsp;

## 5.DeleteUserFromDB.sql

Search for privilege of a given username in the given DB and delete the user from the given database using **DROP USER QUERY** in return.

### USAGE:

<code>

-- delete the user from the given database
-- change this name to the username you want to delete and the database you want to search the user

\>  SET @user = 'yourusername';\
\>  SET @dbname = 'DBNAME';

</code>
&nbsp;

## 6.Error15138N15421

Check this  to resolve these errors which can come in handy:
- Error: 15138
- Error: 15421

## 7.ProfilerAccessToDB

Check this  to resolve these errors which can come in handy:
- exec sp_addrolemember 'db_owner', 'mkshgh';
- GRANT ALTER TRACE TO mkshgh
<code>

-- delete the user from the given database
-- change this name to the username you want to delete and the database you want to search the user

\>  exec sp_addrolemember 'db_owner', 'mkshgh';\
\>  GRANT ALTER TRACE TO mkshgh

</code>


## 8.TDE_TransparentDataEncryption.sql

TDE does real-time I/O encryption and decryption of data and log files. The encryption uses a database encryption key (DEK). The database boot record stores the key for availability during recovery. The DEK is a symmetric key. It's secured by a certificate that the server's master database stores or by an asymmetric key that an EKM module protects.

```
-- You need service master key to decrypt this password if you forget it 'sa password'
-- create a database master key (DMK)
USE master;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'mkshghPassw0rd';
GO

-- You will need the master key to decrypt this certificate used above.
-- create certificate
CREATE CERTIFICATE mTDECertificate
    WITH SUBJECT = 'My Encryption Certificate';
GO
 .
 .
 .
  
```
TDE protects data at rest, which is the data and log files. It lets you follow many laws, regulations, and guidelines established in various industries. This ability lets software developers encrypt data by using AES and 3DES encryption algorithms without changing existing applications.

TDE doesn't provide encryption across communication channels; you should use encrypted connections in combination with TDE for that. We will learn more about that in the upcoming section.
