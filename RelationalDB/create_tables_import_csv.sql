-- *******************************************
-- 2. feladat
-- staging tábla létrehozása
CREATE TABLE [Import]
(
	[UserId] [int] NULL,
	[Timestamp] [datetime] NULL,
	[Type] [char](1) NULL,
	[Length] [int] NULL,
	[UserGender] [char](1) NULL,
	[UserAge] [int] NULL
)
GO



-- *******************************************
-- 3. feladat
-- adatok importálása CSV-bõl
BULK INSERT [Import]
FROM 'GY-traffic-log-csv.csv'
WITH
(
	FIELDTERMINATOR =',',
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
CREATE TABLE [dbo].[Traffic](
	[Timestamp] [datetime] NULL, 
	[Type] [char](1) NULL,
	[Length] [int] NULL,
	[UserID] [int] NULL
)
GO
ALTER TABLE [dbo].[Traffic]  WITH CHECK ADD  CONSTRAINT [FK_Traffic_Customer] FOREIGN KEY([UserID])
REFERENCES [dbo].[Customer] ([UserID])
GO



-- adatok szétpakolása a két táblába
-- kurzorhoz szükséges változók
declare @userid int
declare @type char(1)
declare @length int
declare @userage int
declare @timestamp datetime
declare @usergender char(1)

-- kurzorhoz definiálása és az iterálás a kurzoron
declare cur cursor for select [UserId], [Timestamp], [Type], [Length], [UserGender], [UserAge] from [Import] FAST_FORWARD
open cur
fetch next from cur into @userid, @timestamp, @type, @length, @usergender, @userage
while @@FETCH_STATUS = 0
begin
	-- új Customer, ha még nem létezik
	if not exists(select * from Customer where Customer.UserID = @userid)
	begin
		insert into Customer([UserId],[Gender],[Age]) values (@userid, @usergender, @userage)
	end
	-- a nem felhasználói adatok felvétele a másik tálbába
	insert into Traffic([Timestamp],[Type],[Length],[UserID]) values(@timestamp, @type, @length, @userid)

	fetch next from cur into @userid, @timestamp, @type, @length, @usergender, @userage
end
close cur
deallocate cur

-- az importált adatok törlése a staging táblából
delete from [Import]
