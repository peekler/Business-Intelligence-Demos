-- *******************************************
-- 2. feladat
-- staging tábla létrehozása
CREATE TABLE [RawImport]
(
	[UserId] [int] NULL,
	[Timestamp] [datetime] NULL,
	[Length] [int] NULL,
	[UserGender] [char](1) NULL,
	[UserAge] [int] NULL
)
GO



-- *******************************************
-- 3. feladat
-- adatok importálása CSV-bõl
BULK INSERT [RawImport]
FROM 'c:\import.csv'
WITH
(
	FIELDTERMINATOR =';',
	ROWTERMINATOR ='\n',
	FIRSTROW = 2
);



-- *******************************************
-- 5. feladat
-- adatok normalizálása: szétbontás két táblára

-- táblák létrehozása
CREATE TABLE [dbo].[Customer](
	[UserID] [int] NOT NULL,
	[Gender] [char](1) NULL,
	[Age] [int] NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([UserID] ASC)
)
GO
CREATE TABLE [dbo].[CallLog](
	[Timestamp] [datetime] NULL,
	[Length] [int] NULL,
	[UserID] [int] NULL
)
GO
ALTER TABLE [dbo].[CallLog]  WITH CHECK ADD  CONSTRAINT [FK_CallLog_Customer] FOREIGN KEY([UserID])
REFERENCES [dbo].[Customer] ([UserID])
GO


-- adatok szétpakolása a két táblába
-- kurzorhoz szükséges változók
declare @userid int
declare @length int
declare @userage int
declare @timestamp datetime
declare @usergender char(1)

-- kurzorhoz definiálása és az iterálás a kurzoron
declare cur cursor for select UserId, Timestamp, Length, UserGender, UserAge from RawImport FAST_FORWARD
open cur
fetch next from cur into @userid, @timestamp, @length, @usergender, @userage
while @@FETCH_STATUS = 0
begin
	-- új Customer, ha még nem létezik
if not exists(select * from Customer where Customer.UserID = @userid)
	begin
		insert into Customer(UserId,Gender,Age) values (@userid, @usergender, @userage)
	end
	-- a nem felhasználói adatok felvétele a másik tálbába
insert into CallLog(Timestamp, Length, UserID) values(@timestamp, @length, @userid)

	fetch next from cur into @userid, @timestamp, @length, @usergender, @userage
end
close cur
deallocate cur

-- az importált adatok törlése a staging táblából
delete from RawImport
