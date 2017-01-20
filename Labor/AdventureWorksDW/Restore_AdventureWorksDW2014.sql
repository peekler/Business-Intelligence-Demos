use [master]
go

RESTORE DATABASE [AdventureWorksDW2014] FROM  DISK = N'C:\AdventureWorksDW2014\AdventureWorksDW2014.bak' WITH  FILE = 1,
	MOVE N'AdventureWorksDW2014_Data' TO N'C:\AdventureWorksDW2014\AdventureWorksDW2014_Data.mdf',
	MOVE N'AdventureWorksDW2014_Log' TO N'C:\AdventureWorksDW2014\AdventureWorksDW2014_Log.ldf',
	NOUNLOAD,  REPLACE,  STATS = 5
GO

IF NOT EXISTS(SELECT name FROM [master].[sys].[syslogins] WHERE NAME = 'NT SERVICE\MSSQLServerOLAPService')
BEGIN 
	CREATE LOGIN [NT SERVICE\MSSQLServerOLAPService] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
END
GO

USE [AdventureWorksDW2014]
GO
CREATE USER [NT SERVICE\MSSQLServerOLAPService] FOR LOGIN [NT SERVICE\MSSQLServerOLAPService]
GO
ALTER ROLE [db_datareader] ADD MEMBER [NT SERVICE\MSSQLServerOLAPService]
GO
ALTER ROLE [db_datareader] ADD MEMBER [NT SERVICE\MSSQLServerOLAPService]
GO
