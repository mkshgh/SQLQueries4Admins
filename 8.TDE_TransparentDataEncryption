------------------- Start TDE Enabling --------------------------------

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

-- In case we mess up anything; we need to backup all these for recovery of the db
-- backup everything
BACKUP SERVICE MASTER KEY
    TO FILE = 'C:\SQLWork\SMK.key'
    ENCRYPTION BY PASSWORD = 'MyBackupPa$$1';
GO
BACKUP MASTER KEY
    TO FILE = 'C:\SQLWork\DMK.key'
    ENCRYPTION BY PASSWORD = 'MyBackupPa$$2';
GO
BACKUP CERTIFICATE mTDECertificate
    TO FILE = 'C:\SQLWork\mEncryptionCert.cert'
    WITH PRIVATE KEY (
        FILE = 'C:\SQLWork\mEncryptionCert.key',
        ENCRYPTION BY PASSWORD = 'MyBackupPa$$3'
        );
GO

-- create database and a database encryption key
--> If you already have a database to encrypt then skip this step
CREATE DATABASE mkshghSampleDB;
GO
USE mkshghSampleDB;
GO

--> This is to encrypt the Database
CREATE DATABASE ENCRYPTION KEY
    WITH ALGORITHM = AES_128
    ENCRYPTION BY SERVER CERTIFICATE mTDECertificate;
GO

-- enable Transparent Data Encryption
ALTER DATABASE mkshghSampleDB
SET ENCRYPTION ON;
GO

-- check the state of encrypted databases on the server
-- You might also see a tempdb in this step 
SELECT  DB_NAME(Database_id) AS database_name,
        key_algorithm,
        key_length,
        encryption_state,
        percent_complete
FROM sys.dm_database_encryption_keys;
GO
 
------------------- Completed TDE Enabling --------------------------------




------------------- Start Verify TDE --------------------------------

-- verify that data is accessible
USE AdventureWorks2014
SELECT *
INTO Employees
FROM Person.Person
WHERE BusinessEntityID < 10;
GO

SELECT *
FROM Employees;
GO

------------------- Remove TDE with DB and Certificate --------------------------------

-- backup the database using Object Explorer, then
-- delete the database and clean the server instance
USE master;
GO
DROP DATABASE mkshghSampleDB;
GO
DROP CERTIFICATE mTDECertificate;
GO
DROP MASTER KEY;
GO


------------------- Restore TDE using Certificate --------------------------------

-- restore the database from backup using Object Explorer
-- restore the DMK and Certificate
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'mkshghPassw0rd';
GO

CREATE CERTIFICATE mTDECertificate
    FROM FILE ='C:\SQLWork\mEncryptionCert.cert'
    WITH PRIVATE KEY(
            FILE = 'C:\SQLWork\mEncryptionCert.key',
            DECRYPTION BY PASSWORD = 'MyBackupPa$$3');
GO

-- Trying restoration again using Object Explorer will now work

------------------- Delete TDE using Certificate --------------------------------
USE master;
GO
DROP DATABASE mkshghSampleDB;
GO
DROP CERTIFICATE mTDECertificate;
GO
DROP MASTER KEY;
GO
